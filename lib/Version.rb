# Version.rb
# Version

# 20140910
# 0.13.0

# Description: This class is able to compare strings containing version numbers.

# Changes since 0.12:
# 1. Version.each now returns Version instances.
# 2. Version.sorted now returns a collection with either strings or Version instances, depending on what was supplied.

lib_dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Module/alias_methods'
require 'Ordinal/Array'
require 'String/capture'

class Version

  module VERSION; STRING = '0.13.0'; end

  class << self

    include Enumerable
    include Comparable

    attr_accessor :version_strings

    def <<(version)
      self.version_strings ||= []
      self.version_strings << to_version_string(version)
    end
    alias_methods :append, :push, :<<

    def sorted(*versions)
      versions = versions.flatten
      return_value = versions.collect{|version| Version.new(to_version_string(version))}.sort
      return_value = return_value.collect{|e| e.to_s} if versions.all?{|e| e.is_a?(String)}
      return_value
    end

    def latest(*versions)
      sorted(*versions).last
    end
    alias_methods :last, :most_recent, :newest, :highest, :latest

    def major(version)
      major = to_version_string(version).split('.').first
      major = major.split('-').first if major && hyphenated_part?(version)
      major
    end
    alias_methods :major_version, :major_number, :major_version_number, :major

    def minor(version)
      minor = to_version_string(version).split('.').second
      minor = minor.split('-').first if minor && hyphenated_part?(version)
      minor
    end
    alias_methods :minor_version, :minor_number, :minor_version_number, :minor

    def tiny(version)
      tiny = to_version_string(version).split('.').third
      tiny = tiny.split('-').first if tiny && hyphenated_part?(version)
      tiny
    end
    alias_methods :tiny_version, :tiny_number, :tiny_version_number, :tiny

    def build(version)
      build = to_version_string(version).split('.').fourth
      build = build.split('-').first if build && hyphenated_part?(version)
      build
    end
    alias_methods :build_version, :build_number, :build_version_number, :build

    def patch(version)
      if hyphenated_part = self.hyphenated_part(version)
        hyphenated_part(version).capture(/^(p\d+)/) # It's unlikely that there would be a p without a number.
      end
    end
    alias_methods :patch_level, :patch_version, :patch_number, :patch_version_number, :patch

    def dev(version)
      if hyphenated_part = self.hyphenated_part(version)
        hyphenated_part(version).capture(/^(dev\d*)/)
      end
    end
    alias_methods :dev_version, :dev_number, :dev_version_number, :dev
    alias_methods :development, :development_version, :development_number, :development_version_number, :dev

    def preview(version)
      if hyphenated_part = self.hyphenated_part(version)
        hyphenated_part.capture(/^(preview\d*)/) # It's possible that there will be a preview without a number.
      end
    end
    alias_methods :preview_version, :preview_number, :preview_version_number, :preview

    def release_candidate(version)
      if hyphenated_part = self.hyphenated_part(version)
        hyphenated_part(version).capture(/^(rc\d*)/)
      end
    end
    alias_methods :release_candidate_version, :release_candidate_number, :release_candidate_version_number, :release_candidate
    alias_methods :rc, :rc_version, :rc_number, :rc_version_number, :release_candidate

    def hyphenated_part(version)
      if to_version_string(version).match(/-/)
        to_version_string(version).split('-').last
      end
    end

    def <=>(version_1, version_2)
      version_1 = Version.new(Version.to_version_string(version_1))
      version_2 = Version.new(Version.to_version_string(version_2))
      if version_1.has_hyphenated_part? || version_2.has_hyphenated_part?
        if (to_a(version_1, false) <=> to_a(version_2, false)) == 0
          if version_1.hyphenated_part == version_2.hyphenated_part
            0
          elsif version_1.hyphenated_part =~ /^dev/
            case version_2.hyphenated_part
            when /^dev/; version_1.hyphenated_part <=> version_2.hyphenated_part
            when /^preview/; -1
            when /^rc/; -1
            when /^p\d+/; -1
            else; -1
            end
          elsif version_1.hyphenated_part =~ /^preview/
            case version_2.hyphenated_part
            when /^preview/; version_1.hyphenated_part <=> version_2.hyphenated_part
            when /^dev/; 1
            when /^rc/; -1
            when /^p\d+/; -1
            else; -1
            end
          elsif version_1.hyphenated_part =~ /^rc/
            case version_2.hyphenated_part
            when /^rc/; version_1.hyphenated_part <=> version_2.hyphenated_part
            when /^dev/; 1
            when /^preview/; 1
            when /^p\d+/; -1
            else; -1
            end
          elsif version_1.hyphenated_part =~ /^p\d+/
            case version_2.hyphenated_part
            when /^p\d+/; version_1.hyphenated_part <=> version_2.hyphenated_part
            when /^dev/; 1
            when /^preview/; 1
            when /^rc/; 1
            else; -1 # This assumes that 2.1.0 != 2.1.0-p0 (ie. 2.1.0-p0 < 2.1.0) and that for all other patch levels that anything with no patch level is superior.
            end
          else
            case version_2.hyphenated_part
            when /^dev/; 1
            when /^preview/; 1
            when /^rc/; 1
            when /^p\d+/; 1
            else; 1
            end
          end
        else
          to_a(version_1, false) <=> to_a(version_2, false)
        end
      else
        to_a(version_1) <=> to_a(version_2)
      end
    end

    def ===(version_1, version_2)
      version_1_size = to_a(version_1).size
      version_2_size = to_a(version_2).size
      maximum_shared_places = [version_1_size, version_2_size].min
      if version_1_size < version_2_size
        new_version_2 = to_a(version_2).take(maximum_shared_places).join('.')
        self.<=>(version_1, new_version_2).zero? ? true : false
      elsif version_1_size > version_2_size
        new_version_1 = to_a(version_1).take(maximum_shared_places).join('.')
        self.<=>(new_version_1, version_2).zero? ? true : false
      else
        self.<=>(version_1, version_2).zero? ? true : false
      end
    end

    def each
      version_strings.each{|version_string| yield Version.new(version_string)}
    end

    def to_a(version, include_hyphenated = true)
      to_a = [major(version), minor(version), tiny(version), build(version)]
      to_a = to_a + [hyphenated_part(version)] if include_hyphenated
      to_a.compact
    end

    def from_version_code(version_code)
      version_string = version_code.scan(/../).collect{|n| n.to_i}.join('.')
      Version.new(version_string)
    end

    def to_version_code(version)
      version_string = to_version_string(version)
      to_a(version_string, false).collect{|part| part.rjust(2, '0')}.join
    end
    alias_methods :version_code, :to_version_code

    # Should I handle version codes here?  If I don't handle version codes for any argument which makes reference to a version, then I could simply do a version.to_s in place of using to_version_string().
    def to_version_string(version)
      version = version.to_s
      if version.match(/\./)
        version
      else
        from_version_code(version).to_s
      end
    end

    # boolean methods

    def major?(version)
      major(version) ? true : false
    end
    alias_methods :major_version?, :major_number?, :major_version_number?, :major?

    def minor?(version)
      minor(version) ? true : false
    end
    alias_methods :minor_version?, :minor_number?, :minor_version_number?, :minor?

    def tiny?(version)
      tiny(version) ? true : false
    end
    alias_methods :tiny_version?, :tiny_number?, :tiny_version_number?, :tiny?

    def build?(version)
      build(version) ? true : false
    end
    alias_methods :build_version?, :build_number?, :build_version_number?, :build?

    def patch?(version)
      patch(version) ? true : false
    end
    alias_methods :patch_level?, :patch_version?, :patch_number?, :patch_version_number?, :patch?

    def dev?(version)
      dev(version) ? true : false
    end
    alias_methods :dev_version?, :dev_number?, :dev_version_number?, :dev?
    alias_methods :development?, :development_version?, :development_number?, :development_version_number?, :dev?

    def preview?(version)
      preview(version) ? true : false
    end
    alias_methods :preview_version?, :preview_number?, :preview_version_number?, :preview?

    def release_candidate?(version)
      release_candidate(version) ? true : false
    end
    alias_methods :release_candidate_version?, :release_candidate_number?, :release_candidate_version_number?, :release_candidate?
    alias_methods :rc?, :rc_version?, :rc_number?, :rc_version_number?, :release_candidate?

    def hyphenated_part?(version)
      hyphenated_part(version) ? true : false
    end
    alias_methods :has_hyphenated_part?, :hyphenated_part?

  end # class << self

  include Comparable

  attr_accessor :version_string

  def initialize(version_string = nil)
    @version_string = version_string.to_s
  end

  def major
    self.class.major(version_string)
  end
  alias_methods :major_version, :major_number, :major_version_number, :major

  def minor
    self.class.minor(version_string)
  end
  alias_methods :minor_version, :minor_number, :minor_version_number, :minor

  def tiny
    self.class.tiny(version_string)
  end
  alias_methods :tiny_version, :tiny_number, :tiny_version_number, :tiny

  def build
    self.class.build(version_string)
  end
  alias_methods :build_version, :build_number, :build_version_number, :build

  def patch
    self.class.patch(version_string)
  end
  alias_methods :patch_level, :patch_version, :patch_number, :patch_version_number, :patch

  def dev
    self.class.dev(version_string)
  end
  alias_methods :dev_version, :dev_number, :dev_version_number, :dev
  alias_methods :development, :development_version, :development_number, :development_version_number, :dev

  def preview
    self.class.preview(version_string)
  end
  alias_methods :preview_version, :preview_number, :preview_version_number, :patch

  def release_candidate
    self.class.release_candidate(version_string)
  end
  alias_methods :release_candidte_level, :release_candidate_version, :release_candidate_number, :release_candidate_version_number, :release_candidate
  alias_methods :rc, :rc_version, :rc_number, :rc_version_number, :release_candidate

  def hyphenated_part
    patch || dev || preview || release_candidate
  end

  def <=>(other_version)
    self.class.<=>(version_string, other_version)
  end

  def ===(other_version)
    self.class.===(version_string, other_version)
  end

  def to_a
    self.class.to_a(version_string)
  end

  def to_s
    version_string
  end

  def version_code
    self.class.version_code(version_string)
  end

  def least_significant_version_part_name
    if patch?
      :patch
    elsif build?
      :build
    elsif tiny?
      :tiny
    elsif minor?
      :minor
    else
      :major
    end
  end

  # boolean methods

  def major?
    self.class.major?(version_string)
  end
  alias_methods :major_version?, :major_number?, :major_version_number?, :major?

  def minor?
    self.class.minor?(version_string)
  end
  alias_methods :minor_version?, :minor_number?, :minor_version_number?, :minor?

  def tiny?
    self.class.tiny?(version_string)
  end
  alias_methods :tiny_version?, :tiny_number?, :tiny_version_number?, :tiny?

  def build?
    self.class.build?(version_string)
  end
  alias_methods :build_version?, :build_number?, :build_version_number?, :build?

  def patch?
    self.class.patch?(version_string)
  end
  alias_methods :patch_level?, :patch_version?, :patch_number?, :patch_version_number?, :patch?

  def dev?
    self.class.dev?(version_string)
  end
  alias_methods :dev_version?, :dev_number?, :dev_version_number?, :dev?
  alias_methods :development?, :development_version?, :development_number?, :development_version_number?, :dev?

  def preview?
    self.class.preview?(version_string) ? true : false
  end
  alias_methods :preview_version?, :preview_number?, :preview_version_number?, :preview?

  def release_candidate?
    self.class.release_candidate?(version_string) ? true : false
  end
  alias_methods :release_candidate_version?, :release_candidate_number?, :release_candidate_version_number?, :release_candidate?
  alias_methods :rc?, :rc_version?, :rc_number?, :rc_version_number?, :release_candidate?

  def hyphenated_part?
    patch? || dev? || preview? || release_candidate?
  end
  alias_methods :has_hyphenated_part?, :hyphenated_part?

end
