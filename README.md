# startor

## Description

Easily install, start, and stop tor.

tor by itself only listens; something still has to point the machine at it. `startor` does both halves on macOS:

1. Finds every active network interface and the hardware port it belongs to — Wi-Fi, Thunderbolt Ethernet, and so on.
2. Points each of them at tor's SOCKS proxy on 127.0.0.1:9050, and turns the proxy on.
3. Starts tor.
4. Turns the proxy off again when tor stops.

Derived from [Simple Tor setup on Mac OS X](https://kremalicious.com/simple-tor-setup-on-mac-os-x/).

## Installation

```shell
$ brew tap thoran/tap
$ brew install thoran/tap/startor
```

The formula installs `lib` alongside the script and points `RUBYLIB` at it, which is what makes the four libraries the script requires resolvable. Installed any other way, `lib` has to be on the load path yourself.

Then, to install tor itself:

```shell
$ startor setup
```

which installs Homebrew if it is not there, and tor through it. Both are skipped where already present.

## Usage

### 1. Start tor, and stop it with ctrl-c

```shell
$ startor
```

Enter your login password when `sudo` asks for it. On ctrl-c the proxy is taken back down before it exits.

### 2. Start tor in place of the shell

```shell
$ startor up
```

### 3. Take the proxy down

```shell
$ startor down
```

## Notes

1. macOS only. The proxy is set through `networksetup`, and the interfaces come from `ifconfig`.
2. `sudo` is needed to change the proxy settings. `startor` asks for it up front, with `sudo -v`, before it touches anything.
3. That `sudo -v` asks for your password even where `/usr/sbin/networksetup` carries a `NOPASSWD` entry, because it validates against your entries as a whole rather than against one command. It goes quiet only where every entry you have is `NOPASSWD`, or where your credentials are still cached from a recent `sudo`. So this is not a thing to run unattended without arranging that first.
4. `startor up` replaces itself with tor, so nothing of startor is left to notice tor stopping and the proxy stays on. Run `startor down` afterwards. Plain `startor` runs tor as a child and takes the proxy down for you, on ctrl-c and on tor exiting.
5. The proxy is set on the hardware port behind each active interface, so a machine on both Wi-Fi and Ethernet has both pointed at tor. The ports are any of 'Thunderbolt Ethernet', 'Thunderbolt Bridge', 'Wi-Fi', 'Ethernet', 'Bluetooth PAN' or 'Display Ethernet'. See `networksetup -listallnetworkservices` for the complete list on your machine.
6. `startor setup` installs tor through Homebrew, and installs Homebrew first where it is missing, by running [Homebrew's own installer](https://brew.sh). Both halves are skipped where what they install is already there.
7. To choose which country your traffic leaves through, see [exitor](https://github.com/thoran/exitor).

## Contributing

1. Fork it: `https://github.com/thoran/startor/fork`
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create a new pull request


## License

MIT
