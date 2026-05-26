---
categories:
- code
- devsec
date: "2026-05-25T00:00:00Z"
title: Securing dev environments using VMs
---

With the increasing number of supply-chain attacks that target
development environments and the cambrian explosion of tools with
indirect dependencies, it's harder to keep a dev system lean with a
limited blast radius when things go wild. This article is part of a
series of posts on the topic, focusing on VM isolation.

It is opinionated and I encourage you to come up with your own way.
    
# Overview

The idea is to have a light setup on the host distribution (a
graphical environment to spawn terminals, packages to run VMs, text
editor, etc) and create VMs for each dedicated use or project (social,
web, audio development, infrastructure, ...). VMs are setup in a
uniform way via `cloud-init` and `chezmoi` and are meant to be cheap
and throw-away.

On the host, a GnuPG agent and an SSH agent are running, backed by a
physical key (like YubiKey) that requires a touch upon signature. VMs
have access to the `X`' host socket so they can open windows, and to
the GnuPG and SSH agents which require a physical touch on the Yubikey
whenever performing something that needs secrets. For instance:
pushing a git commit from one of the VMs to GitHub will poke the host
agent from the VM, and ask to confirm physically that the action comes
from a human: the SSH key is never inside the VM. Secrets are
similarly protected via GnuPG using gopass (so they require a physical
touch as well).

This is a trade-off that works for me: accepting the risk of X
exploits or VM exploits that could break isolation. It allows to have
independent podman/docker setups inside each VMs while pure
container-based isolation makes this hard.

The rest of this article is mainly how to get there at a high-level.

# Setup

## Chezmoi

[Chezmoi](https://www.chezmoi.io/) is a tool to manage dotfiles
accross multiple machines, the goal is to not have to re-setup common
config files like emacs, gitconfig, zsh, and so on. Configs are stored
in a git repository and can be installed or edited via the `chezmoi`
CLI tool.

There are two flavors in my setup:

- what is on the host (frugal and limited to trusted tools, ensures
  SSH/GPG agents are setup, etc),
- what is on VMs (wider exposure to random packages, default sane
  configs for common tools like npm, etc).

Each of those flavors has its own git repository and can roughly be
initialized this way:

```
chezmoi init --apply <repo>
```

This step is automated at the creation of VMs, because it depends on
pulling a private git repository, it asks for a YubiKey touch.

## Incus

VMs are created via [Incus](https://linuxcontainers.org/incus/) which
supports multiple flavors (system containers, application containers,
or pure virtual machines). The Incus usage is limited to virtual
machines which allows to use docker and such if needed inside VMs:
container in VM is simple, container in container is painful.  Also,
container in container is still vulnerable to recent kernel exploits
that are minted by AI such as CopyFail (CVE-2026-31431).

My main script runs Incus somewhat like this (roughly adapted for this
post):

```
incus launch images:archlinux/cloud --vm <PROJECT> < devel.yaml
```

Where `devel.yaml` is something similar to:

```yaml
architecture: x86_64
devices:
  eth0:
    name: eth0
    network: incusbr0
    type: nic
  root:
    path: /
    pool: default
    type: disk
  rift:
    path: /rift
    source: /home/<USER>/rift
    type: disk
config:
  limits.cpu: "16"
  limits.memory: "32GiB"
  cloud-init.user-data: |
    #cloud-config
    users:
      - name: <USER>
        groups: [wheel]
        shell: /bin/zsh   
        sudo: "ALL=(ALL) NOPASSWD:ALL"
        ssh_authorized_keys:
          - ssh-ed25519 <PUBLIC_SSH_KEY>
    packages:
      - openssh
      - zsh
      - emacs-nox
      - tmux
      - htop
      - git
      - chezmoi
    package_update: true
    package_upgrade: true
    runcmd:
      - echo "X11Forwarding yes" >> /etc/ssh/sshd_config
      - echo "AcceptEnv PULSE_SERVER" >> /etc/ssh/sshd_config
      - ssh-keyscan github.com >> /home/<USER>/.ssh/known_hosts
      - sudo -u <USER> chezmoi init --apply repo/dotfiles-vm
      - chown -R <USER>:<USER> /home/<USER>
      - systemctl enable sshd
      - systemctl start sshd
```

This creates a VM with some default packages, configures an SSH server
so that it accepts the host's public SSH key, and install dotfiles and
such via chezmoi. There is a special mount point on `/rift` which
allows to share files between all VMs and the host. This config allows
X forwarding as well as `PULSE_SERVER` for audio forwarding (i.e:
playing music inside one of the VMs will play on the host). It's then
possible to ssh into the VM as follows:

```sh
bridge_ip=$(ip -4 addr show incusbr0 | awk '/inet / {print $2}' | cut -d/ -f1)
PULSE_SERVER=tcp:$bridge_ip ssh -A \
        -X \
        -t \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o SendEnv=PULSE_SERVER \
        "<USER>@vm"
```

X11 forwarding has deeper implications: it means a compromised VM can
keylog the host display, this part can likely be improved via stronger
isolation on the host using `waypipe` for instance.

# Wrapping it up

This type of isolation goes a long way if used systematically: it
limits the blast radius as secrets are not immediately accessible from
VMs, while keeping it flexible for all sorts of usages. Upon a
security issue, it's easy to throw away a VM and start with a fresh
one. It has some drawbacks (VM bug could mean escalation to host, a
bug in the protocol used by SSH/GPG agents, or X, or pulseaudio could
be exploited, ...). So it is meant to be combined with other security
layers ([defense in
depth](https://en.wikipedia.org/wiki/Defense_in_depth_(computing))).
