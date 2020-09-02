# macsetup

There are many approaches out there for how to get a clean macOS install ready for use. This is mine.

You're welcome to fork it and tailor it for your needs. If you have changes that you feel will be beneficial to me or other users, please feel free to submit a pull request.

## Configuration

### Bootstrap script

Please add to or delete from [bootstrap.sh](bootstrap.sh), as appropriate, to have it do what you need to do to setup your Mac.

### Bootstrap Config

The [bootstrap.sh](bootstrap.sh) expects a configuration file as a command line parameter. Please see the [example config](example.conf) and customize it for your needs.

### Brewfile

We use [Homebrew](https://brew.sh/) to install software. Please see my [Brewfile](config/Brewfile) and customize it for your needs.

### Masfile

We use the [mas-cli](https://github.com/mas-cli/mas) to install software from the Mac App Store. Please see my [Masfile](config/Masfile) and customize it for your needs.

### Other config files

* [atom_package_list](config/atom_package_list) contains a list of packages to install for the [Atom text editor](https://atom.io/)

* [aws_config](config/aws_config) contains my [AWS](https://aws.amazon.com/) (which just specifies the AWS region).

* [bash_colors](config/bash_colors) contains some environment variables for setting colors in bash.

* [bash_profile](config/bash_profile) contains my bash profile.

* [gpg-agent.conf](config/gpg-agent.conf) is my GPG Agent config.

* [vscode_package_list](config/vscode_package_list) contains the list of packages to install for [Visual Studio Code](https://code.visualstudio.com/)

## Use

```
bash ./bootstrap.sh <config file>
```
