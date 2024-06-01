# σπόρος (spóros)
A set of configuration files and scripts that I use to seed and maintain my
development environment across all the computers I use.

## macOS
- To performe the whole setup: `bash macos/<hostname>/bootstrap.sh`
- To install/update only the dotfiles: `bash macos/<hostname>/configure.sh`

### Maintenance
- Check for [hosts files][macos-maintenance-01] updates.
- Check for [MongoDB Shell][macos-maintenance-02] updates.
- Check for [MongoDB Tools][macos-maintenance-03] updates.
- Check for VSCode plugins updates.
- Main ASDF maintenance commands:
  * Check latest available version: `asdf latest <pkg> [major]`.
  * Install latest available version: `asdf install <pkg> latest:<major>`.
  * Update specific plugin: `asdf plugin-update <pkg>`.
  * Update all plugins: `asdf plugin-update --all`.
  * Use the latest version globally: `asdf global <pkg> latest:<major>`.
- Main Homebrew maintenance commands:
  - Update Homebrew and the list of formulae: `brew update`.
  - List outdated formulae: `brew outdated --greedy`.
  - Upgrade all installed formulae and casks: `brew upgrade --greedy`.
  - Purge cache: `brew cleanup [--dry-run]`.
  - List dependencies of a formula: `brew deps --tree <pkg>`.
  - List installed dependencies of a formula: `brew uses --installed <pkg>`.
  - List installed formulae which are not dependencies of others: `brew leaves`.
- Main Neovim maintenance commands:
  * Update Lazy's plugins: `:Lazy sync`.
  * Update Mason's registry: `:MasonUpdate`.
  * Update Mason's LSPs: `:Mason` -> Press the `U` key.
  * Update TreeSitter's parsers: `TSUpdateSync`.
- Main Python maintenance commands:
  * `pip3 list --user --outdated`.
  * `pip3 install --user --upgrade <package>`.

[macos-maintenance-01]: https://github.com/StevenBlack/hosts/releases
[macos-maintenance-02]: https://github.com/mongodb-js/mongosh/releases
[macos-maintenance-03]: https://github.com/mongodb/mongo-tools/tags