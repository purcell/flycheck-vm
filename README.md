Flycheck VM
===========

This repository provides a virtual machine based on [Vagrant][] and [Chef][]
which contains Emacs and all syntax checkers supported by Flycheck.

[Vagrant]: https://www.vagrantup.com
[Chef]: https://www.chef.io/chef/

Setup
-----

- Install [Vagrant][]
- Install [Chef DK][]
- Install [Vagrant Berkshelf][] with `vagrant plugin install vagrant-berkshelf`
- `vagrant up --provision`

To have the Flycheck source code available inside the VM, you must have Flycheck
cloned in `./flycheck` or `../flycheck`, relative to this README.  Vagrant will
automatically sync the source code on `vagrant up`, you can explicitly sync with
`vagrant rsync`.

[Chef DK]: https://downloads.chef.io/chef-dk/
[Vagrant Berkshelf]: https://github.com/berkshelf/vagrant-berkshelf

Usage
-----

Start the VM, and provision it:

```console
$ vagrant up --provision
```

Sync the Flycheck sources with the VM:

```console
$ vagrant rsync
# Automatically sync on changes
$ vagrant rsync-auto
```

Connect to the VM:

```console
$ vagrant ssh
```

Run tests with Emacs 24:

```console
$ cd ~/flycheck/
$ make EMACS=emacs24 test
```

Run tests with Emacs snapshot:

```console
$ cd ~/flycheck/
$ make EMACS=emacs-snapshot test
```

Re-provision the machine from time to time, from the host:

```console
$ vagrant provision
```
