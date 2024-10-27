# CRIU Debian Packages

This repository contains all the files necessary to build the Ubuntu/Debian packages for CRIU, published in the [Open Build Service](https://build.opensuse.org/project/show/devel:tools:criu) and [Launchpad](https://launchpad.net/~criu).

# Git Branches

The following branches contain the source tree for each CRIU package:

- [open-build-service](https://github.com/rst0git/criu-deb-packages/tree/open-build-service)
- [launchpad-24.04](https://github.com/rst0git/criu-deb-packages/tree/launchpad-24.04)
- [launchpad-22.04](https://github.com/rst0git/criu-deb-packages/tree/launchpad-22.04)
- [launchpad-20.04](https://github.com/rst0git/criu-deb-packages/tree/launchpad-20.04)
- [launchpad-18.04](https://github.com/rst0git/criu-deb-packages/tree/launchpad-18.04)

## Building Source Packages for OBS

```console
# Install scripts for creating Debian packages:
apt-get update
apt-get install -y devscripts equivs

# Install build dependencies from `debian/control`
mk-build-deps --install --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes' debian/control

# Building a source package (without signature)
dpkg-buildpackage --unsigned-source --unsigned-changes --build=source
```

## Upload a package to OBS

### Install osc

The following packages provide a command-line client for the Open Build Service:

- Fedora/CentOS

```console
sudo dnf install osc
```

- Ubuntu/Debian

```console
sudo apt-get install osc
```

The first time you use the `osc` command, it will ask you to configure your credentials in `~/.config/osc/oscrc`.

### Checkout content from OBS

```console
osc co devel:tools:criu
```

To update existing packages or check out new ones within a project directory, use the following commands:

```console
osc up
osc up [directory]
osc up *            # from within a project dir, update all packages
osc up              # from within a project dir, update all packages AND check out all newly added packages
```

### Add and remove files

The following commands can be used to add and remove files:

```console
osc add FILE [FILE...]
osc delete FILE [...]

# Add all files new in the local copy, and remove all disappeared files.
osc addremove
```

### Uploading changes to OBS

```console
osc ci                          # current dir
osc ci [file1] [file2]          # only specific files
osc ci [dir1] [dir2] ...        # multiple packages
osc ci -m "updated foobar"      # specify a commit message
```

## Ubuntu Packages in Launchpad

Ubuntu package names are suffixed with the version number of the package. This allows Ubuntu to distinguish newer packages from older ones and remain up to date.

If you're creating an alternative version of a package already available in Ubuntu's repositories, you should ensure that:

- Your package supersedes the official Ubuntu version.
- Future Ubuntu versions will supersede your package.

To do this, add the suffix `ppa` (where `n` is your package's revision number). Here are two examples:

- Ubuntu package `myapp_1.0-1` → PPA package `myapp_1.0-1ppa1`
- Ubuntu package `myapp_1.0-1ubuntu3` → PPA package `myapp_1.0-1ubuntu3ppa1`

Version numbers must be unique. This has implications if you want to provide packages for multiple Ubuntu series at once:

- If your package can be used on different versions of Ubuntu without being recompiled, then use the naming scheme already described and start by uploading your package to the oldest series you want to support. Once you have successfully uploaded your package to your PPA, you can copy the existing binaries to the new series; see "Copying packages" and use the "Copy existing binaries" option.

- If your package needs to be recompiled to support multiple Ubuntu series, then you should add a suffix with a tilde and the series version to the version number. For example, a package for Yakkety Yak (16.10) could be named `myapp_1.0-1ubuntu3ppa1~ubuntu16.10.1`, and for Xenial Xerus (16.04), it could be named `myapp_1.0-1ubuntu3ppa1~ubuntu16.04.1`. If you need to release an updated package, increment the `ppa` suffix. It is important to note that specifying the version name here doesn't change the series you are targeting; this must still be set correctly as described in the Ubuntu packaging guide's section on the changelog file.

### Building Options

How you build your package depends on whether you're creating a brand new package or a derivative of a package that's already in Ubuntu's primary archive.

If you're creating an alternative version of a package that's already in Ubuntu's primary archive, you don't need to upload the `.orig.tar.gz` file, i.e., the original source.

#### Building an alternative version of an existing package

The following command will build a new source package version without the `.orig.tar.gz` source file. This is necessary, for example, when the source file has already been uploaded to Launchpad.

```console
debuild -S -sd
```

#### Build a new package version

The following command will build a new source package with the `.orig.tar.gz` file. This is necessary, for example, when a new upstream release has been created and the `.orig.tar.gz` file has not yet been uploaded to Launchpad.

```console
debuild -S -sa
```

## Upload a package to Launchpad

### Update /etc/dput.cf

The "ppa" entry in `/etc/dput.cf` should be updated as follows:

```
[criu-ppa]
fqdn = ppa.launchpad.net
method = ftp
incoming = ~criu/ppa/ubuntu
login = anonymous
allow_unsigned_uploads = 0
```

Alternatively, you can use `~/.dput.cf` instead.

Then, enter the following:
```console
dput criu-ppa <package>_source.changes
```
