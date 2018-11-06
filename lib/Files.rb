# Files.rb
# Files

# 20140508
# 0.8.3

# Changes since 0.7: (Switched from using Files to OpenStructs for @files instance variable because Ruby can't open more than some hundreds of files and nil was being returned after that limit had been reached.)
# 1. - Files.files_for().
# 2. + Files.with_attributes().
# 3. /return_files_object/return_ostruct_object/.
# 4. ~ Files.in_path___with_pattern___(), so as to make reference to Files.with_attributes().
# 5. ~ Files#absolute_paths(), to not rely upon an extension to File.
# 6. ~ Files#dirnames(), to not rely upon an extension to File.
# 7. ~ Files#absolute_dirnames(), to not rely upon an extension to File.
# 8 - require_relative './File'.
# 0/1
# 9. Even though MacRuby is supposed to be an MRI 1.9.2 analogue, it doesn't know Kernel#require_relative, so I've added a 'backport' for it in Ruby.
# 1/2
# 10. I don't need require_relative if I am altering the path and wrapping this up as a gem does that automatically for me.
# 11. However, perhaps I can't assume that someone will be using RubyGems, so I've got some $LOAD_PATH manipulation stuff there instead.  It also means that I don't have to change any of the test code, else I'd have to it in there.  Perhaps it doesn't matter terribly which of these ways I do this?
# 12. - ruby '1.9.3' from the Gemfile, since I had merely copied and pasted that from another project.
# 2/3
# 13. /MiniTest::Unit::TestCase/MiniTest::Test/.
# 14. + gem 'minitest' to all children test files and to the Gemfile so as to silence the warnings.
# 15. Moved test/all.rb to test/Files.rb.
# 16. Moved all children tests to test/Files/ as was forshadowed by the first line of the test files prior to 8.3.
# 17. ~ TC_Files_instance_methods_performing_operations#test_gsub! and #test_move, so that they were actually testing the instance methods and not the class methods as they were, thereby helping improve test coverage to 99.07%.
# 18. + TC_Files_instance_methods#test_initialize_with_no_filenames_and_no_path_or_pattern, so as to achieve 100% test coverage finally.
# 19. /TC_Files_instance_methods#test_initialize_with_no_path_or_pattern/TC_Files_instance_methods#test_initialize_with_a_filename/, so as to make the name more accurate.
# 20. /TC_Files_instance_methods#test_initialize_and_a_path/TC_Files_instance_methods#test_initialize_with_a_path/, so as to make the name more accurate.
# 21. /TC_Files_instance_methods#test_initialize_and_a_pattern/TC_Files_instance_methods#test_initialize_with_a_pattern/, so as to make the name more accurate.
# 22. /TC_Files_instance_methods#test_initialize_and_a_path_and_pattern/TC_Files_instance_methods#test_initialize_with_a_path_and_pattern/, so as to make the name more accurate.
# 23. Updated lib/Array/extract_optionsX.rb to the latest version.
# 24. Added lib/Array/all_but_last.rb, since it was a missing dependency.
# 25. Added lib/Array/lastX.rb, since it too was a missing dependency.
# 26. ~ Files#sort_method_macro, #sorter_macro, and #reverse_sort_method_macro, so as to make use of instance_eval rather than eval.
# 27. Added Kernel/require_relative.rb back, since I should be able to run the specs with MacRuby as well.
# 28. Updated the gemspec with latest version number.

# Todo:
# 1. Ensure that the interface is sufficiently usable that it will be reading for a 1.0 release after some more tinkering through the remainder of 0.8 and 0.9.

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless
  $LOAD_PATH.include?(File.dirname(__FILE__)) || $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

require 'Array/extract_optionsX'
require 'File/self.gsubX'
require 'fileutils'
require 'Module/alias_methods'
require 'ostruct'

class Files

  class << self

    def find(options = {})
      path, pattern, return_ostruct_object = options[:path], options[:pattern], options[:return_ostruct_object]
      case
      when path && pattern
        in_path___with_pattern___(path, pattern, return_ostruct_object)
      when path && !pattern
        in_path___(path, return_ostruct_object)
      when !path && pattern
        with_pattern___(pattern, return_ostruct_object)
      when !path && !pattern
        here(return_ostruct_object)
      end
    end
    alias_methods :all, :find

    def in_path___with_pattern___(path, pattern, return_ostruct_object = true)
      files = with_attributes(Dir["#{path}/#{pattern}"])
      if return_ostruct_object
        files_object = Files.new
        files_object.files = files
        files_object
      else
        files
      end
    end
    alias_methods :in_path_matching, :in_path___matching___,
      :in_path_with_pattern, :in_path___with_pattern___

    def in_path___(path, return_ostruct_object = true)
      in_path___matching___(path, '*', return_ostruct_object)
    end
    alias_methods :in, :in_path, :in_path___

    def with_pattern___(pattern, return_ostruct_object = true)
      in_path___matching___('./', pattern, return_ostruct_object)
    end
    alias_methods :with_pattern, :with_pattern___

    def here(return_ostruct_object = true)
      in_path___matching___('./', '*', return_ostruct_object)
    end

    def with_attributes(paths)
      paths.collect do |path|
        begin
          f = {}
          f[:path] = path
          f[:size] = File.stat(path).size
          f[:ftype] = File.stat(path).ftype
          f[:mode] = File.stat(path).mode
          f[:gid] = File.stat(path).gid
          f[:uid] = File.stat(path).uid
          f[:ctime] = File.stat(path).ctime
          f[:mtime] = File.stat(path).mtime
          f[:atime] = File.stat(path).atime
          OpenStruct.new(f)
        rescue
        end
      end
    end

    def gsub!(filenames, replacement_pattern, replacement_text, selection_pattern = nil)
      filenames.each do |filename|
        File.gsub!(filename, replacement_pattern, replacement_text, selection_pattern)
      end
    end

    def move(filenames, replacement_pattern, replacement_text)
      filenames.each do |filename|
        new_filename = filename.gsub(/#{replacement_pattern}/, replacement_text)
        FileUtils.mv(filename, new_filename)
      end
    end
    alias_methods :ren, :rename, :mv, :move

  end # class << self

  include Enumerable

  attr_writer :files
  attr_reader :path
  attr_reader :pattern

  def initialize(*args)
    options = args.extract_options!
    @args, @path, @pattern = args, options[:path], options[:pattern]
    load_metaprogrammed_methods
  end

  def files
    @files ||= (
      if !@args.empty?
        Files.with_attributes(@args.flatten)
      elsif path && pattern
        Files.find(path: path, pattern: pattern, return_ostruct_object: false)
      elsif path
        Files.find(path: path, return_ostruct_object: false)
      elsif pattern
        Files.find(pattern: pattern, return_ostruct_object: false)
      else
        []
      end
    )
  end

  def each
    files.each{|f| yield f}
  end

  def paths
    files.collect{|f| f.path}
  end

  def absolute_paths
    files.collect{|f| File.expand_path(f.path)}
  end

  def dirnames
    files.collect{|f| File.dirname(f.path)}
  end

  def absolute_dirnames
    files.collect{|f| File.dirname(File.absolute_path(f.path))}
  end

  def gsub!(replacement_pattern, replacement_text)
    Files.gsub!(paths, replacement_pattern, replacement_text)
  end

  def move(replacement_pattern, replacement_text)
    Files.move(paths, replacement_pattern, replacement_text)
  end
  alias_methods :ren, :rename, :mv, :move

  def path=(new_path)
    @path = new_path
    set_files
  end

  def pattern=(new_pattern)
    @pattern = new_pattern
    set_files
  end

  private

  def set_files
    @files = nil
    files
  end

  def load_metaprogrammed_methods
    sort_method_macro
    reverse_sort_method_macro
    sorter_macro
  end

  def sort_method_macro
    %w(atime ctime mtime size ftype mode gid uid filename).each do |method|
      instance_eval("
        def sort_by_#{method}
          files.sort! do |a,b|
            by_#{method}(a,b)
          end
          self
        end
      ")
    end
  end

  def sorter_macro
    %w(atime ctime mtime size ftype mode gid uid filename).each do |method|
      instance_eval("
        def by_#{method}(a,b)
          a.#{method} <=> b.#{method}
        end
      ")
    end
  end

  def reverse_sort_method_macro
    %w(atime ctime mtime size ftype mode gid uid filename).each do |method|
      instance_eval("
        def reverse_sort_by_#{method}
          files.sort! do |a,b|
            by_#{method}(a,b)
          end.reverse!
          self
        end
      ")
    end
  end

end
