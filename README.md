# cros-up - Quick Chromium OS Development & Build Environment

## Purpose

This package enables a developer to bring up a <a href="http://www.chromium.org/chromium-os">Chromium OS</a> development
environment and, if desired, create a build of Chromium OS with a single command.

This packages uses <a href="https://www.vagrantup.com/">Vagrant</a> and <a href="http://www.saltstack.com/">SaltStack</a>
to configure the development environment on either a local VirtualBox VM or on a remote DigitalOcean VM. While other VM
providers have not been tested and are not explicitly supported, it is expected that other cloud providers (Amazon AWS, Google GCE, Rackspace, etc.)
are compatible.

## Usage

1. Install Vagrant
2. Install vagrant-env and vagrant-digitalocean plugins (`vagrant plugin install vagrant-env vagrant-digitalocean`)
3. Create a .env file (or prefix future vagrant commands with environment variables)
4. `vagrant up --provider=virtualbox` or `vagrant up --provider=digital_ocean`
5. If desired, "vagrant provision" can be used to run a new build on an existing machine

The machine will be configured and a Chromium OS development environment will be set up in `/home/$BUILD_USER/chromiumos`.
A minimum of 30-40 gigabytes of disk space is required, and the initial setup and build is likely to take at least 2-3 hours
on a DigitalOcean VM. By default, the VirtualBox provider is configured to use 4GB of ram and the DigitalOcean provider is
configured to provision a 2GB droplet.

## Supported Environment Variables

   * DO_TOKEN - API key, required if using the DigitalOcean provider.
   * DO_SSH_KEY - Path to private SSH key. vagrant-digitalocean will automatically add a `Vagrant` SSH key to your DigitalOcean account by locating a file with ".pub" added to the end of the private key's filename. Defaults to `~/.ssh/id_rsa`.
   * USB_ATTACH - Available with VirtualBox provider. Space-separated list of serial numbers of USB storage device to attach. Useful for writing a built image to a USB key.
   * GIT_NAME - Name to specify in `BUILD_USER`'s git configuration. Defaults to `Unknown`.
   * GIT_EMAIL - Email to specify in `BUILD_USER`'s git configuration. Defaults to `fixme@example.com`.
   * BUILD_USER - Username to setup in the virtual machine with cros_sdk. Defaults to `crosupuser`.
   * IMAGE_FLAGS - Flags to pass to `build_image`. Defaults to `--noenable_rootfs_verification dev`.
   * BOARD_LIST - Space-separated list of boards to automatically build images for. Defaults to building nothing.
   * RESYNC_SOURCES - Re-fetch the manifest & sync sourcecode, even if it's already been downloaded. Defaults to 0.
   * PUBLIC_IP - Available with VirtualBox provider. Provides a bridged network interface with the configured ip. Can be set to `DHCP` (case-sensitive) for network auto-configuration.
   * NFS_EXPORT - Machine(s) allowed access via NFS to the `/home/$BUILD_USER/chromiumos` folder. Mounting the `chromiumos` folder over NFS enables developers to use local development tools while still running builds within the VM. Must be in the format expected in `/etc/exports`.

## Example .env file (with 'export' prefixes so the file could be executed with `source`)

    export DO_TOKEN=123456789abcdef123456789abcdef123456789abcdef123456789abcdef
    export DO_SSH_KEY="~/magic_ssh_key"
    export USB_ATTACH=ABC123
    export GIT_NAME="Example User"
    export GIT_EMAIL="someone@example.com"
    export BUILD_USER=someone
    export IMAGE_FLAGS="--noenable_rootfs_verification test"
    export BOARD_LIST="amd64-generic arm-generic"
    export RESYNC_SOURCES=1
    export PUBLIC_IP="DHCP"
    export NFS_EXPORT="192.168.1.100"

## Security Warnings

   * Vagrant bypasses SSH host key fingerprint verification. This creates exposure to active man in the middle attacks if techniques are not used to mitigate this risk.
   * Creating an NFS export onto a public network increases attack surface.

## Areas for Improvement

   * With the VirtualBox provider, new USB filters are added to the machine's configuration each time the machine is brought up by Vagrant, resulting in duplicate filter entries.
   * Additional configuration options for how 'repo' is called would be helpful. Local repo manifests are a common but currently unsupported use case.

## Issues, Contributing

If you run into any problems with these images, please check for issues on [GitHub](https://github.com/DanielDent/cros-up/issues).
Please file a pull request or create a new issue for problems or potential improvements.

## License

Copyright 2015 [Daniel Dent](https://www.danieldent.com/).

Licensed under the Apache License, Version 2.0 (the "License");
you may not use these files except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Any included third-party contents are licensed separately.
