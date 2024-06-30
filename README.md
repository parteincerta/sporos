# σπόρος (spóros)
A set of configuration files and scripts that I use to seed and maintain my
development environment across all the computers I use.

## macOS
- Optionally follow the preliminary macOS [setup guide](macos/REAME.md).
- Install Apple CLI Tools `xcode-select --install`.
- Add the following location to Spotlight Privacy list `/Library/Developer`.
- Clone this repo and run: `bash macos/<hostname>/bootstrap.sh`.
- Start neovim and let the LSP servers install.
- Open applications and configure them as needed.
  - If the machine has an external drive, reinstall the dotfiles before
    accepting Docker's ToS just so it's disk is created in the external storage
    instead of in the internal one: `bash macos/<hostname>/configure.sh`.
- Disable auto-updates: `bash shared_macos/scripts/disable-updates.sh`.
- Clone the [containers](https://github.com/parteincerta/containers) repo and
  setup the Docker containers.
- Revisit Notifications, Login Items, Spotlight and re-access accordingly.
- Configure VPNs and show them in the Menu Bar.
- Reboot.

### Maintenance
- ASDF maintenance commands:
  * Add new plugin: `asdf plugin-add <plugin>`.
  * Check latest available version: `asdf latest <plugin> [major]`.
  * Install latest available version: `asdf install <plugin> latest:<major>`.
  * Update plugins: `asdf plugin-update <plugin|--all>`.
  * Use the latest version globally: `asdf global <plugin> latest:<major>`.
- Dotfiles maintenance commands:
  - Install the dotfiles: `bash macos/<hostname>/configure.sh`.
  - Export configurations: `bash shared_macos/scripts/export-defaults.sh`.
  - Disable auto-updates: `bash shared_macos/scripts/disable-updates.sh`.
- Homebrew maintenance commands:
  - Update Homebrew and the list of formulae: `brew update`.
  - List outdated formulae: `brew outdated --greedy`.
  - Upgrade all installed formulae and casks: `brew upgrade --greedy`.
  - Purge cache: `brew cleanup [--dry-run]`.
  - List dependencies of a formula: `brew deps --tree <pkg>`.
  - List installed dependencies of a formula: `brew uses --installed <pkg>`.
  - List installed formulae which are not dependencies of others: `brew leaves`.
- Hosts file maintenance steps:
  - Check for [hosts files][macos-maintenance-01] update.
  - Update the version reference in
    [install-hosts.sh](shared/scripts/install-hosts.sh).
  - Update the hosts file: `bash shared/scripts/install-hosts.sh`.
- MongoDB utilities maintenance steps:
  - Check for [MongoDB Shell][macos-maintenance-02] and
    [MongoDB Tools][macos-maintenance-03] updates.
  - Update the version references in
    [install-mongo-utils.sh](shared/scripts/install-mongo-utils.sh).
  - Update Shell: `bash shared/scripts/install-mongo-utils.sh shell`.
  - Update Tools: `bash shared/scripts/install-mongo-utils.sh tools`.
- Neovim maintenance commands:
  * Update Lazy's plugins: `:Lazy sync`.
  * Update Mason's registry: `:MasonUpdate`.
  * Update Mason's LSPs: `:Mason` -> Press the `U` key.
  * Update TreeSitter's parsers: `TSUpdateSync`.
- Python maintenance commands:
  * `pip3 list --user --outdated`.
  * `pip3 install --user --upgrade <package>`.
- Check for VSCode plugins updates.
- Check for App Store updates.

[macos-maintenance-01]: https://github.com/StevenBlack/hosts/releases
[macos-maintenance-02]: https://github.com/mongodb-js/mongosh/releases
[macos-maintenance-03]: https://github.com/mongodb/mongo-tools/tags