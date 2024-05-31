# σπόρος (spóros)
A set of configuration files and scripts that I use to seed and maintain my
development environment across all the computers I use.

## macOS
- To setup the system, install apps and dotfiles: `bash macos/<hostname>/bootstrap.sh`
- To install/update only the dotfiles: `bash macos/<hostname>/bootstrap.sh`

### Maintenance
- Manual operations:
  - Check for [hosts files][macos-maintenance-01] updates.
  - Check for [MongoDB Shell][macos-maintenance-01] updates.
  - Check for [MongoDB Tools][macos-maintenance-03] updates.
  - Check for VSCode plugins updates.

[macos-maintenance-01]: https://github.com/StevenBlack/hosts/releases
[macos-maintenance-02]: https://github.com/mongodb-js/mongosh/releases
[macos-maintenance-03]: https://github.com/mongodb/mongo-tools/tags