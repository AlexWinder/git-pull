# Git Pull

This simple BASH script allows you to cycle through a directory of Git projects and run a `git pull` against each of them, without needing to go into each directory and manually issue the command.

This allows you to quickly sync local versions of your Git projects with your remote servers, or for automated usage like scheduled backups.

## Contributors

- [Alex Winder](https://www.alexwinder.uk)

## Support

This BASH script has been tested to work on the following:

- Debian 11 Bullseye
- Git 2.30

To find your version of Git.

```bash
git --version
```

Whilst these versions have been tested your mileage may vary. There is very little reason for the script to not work if you are using an older/newer version of Debian or another flavour of Linux.

## Getting Started

The simplest way to get started is to clone the repository:

```bash
git clone git@github.com:AlexWinder/git-pull.git
```

Once you have a copy of the script you can then make use of it on your system. 

Call the script as you would any other bash script.

```bash
./path/to/git-pull/git-pull.sh
```

### Arguments

The script has a number of named arguments to assist with its uses and allow you to override parts of the script to meet your requirements:

- `--help` - Show a help guide on the script. If used then no other parameters will be considered.
- `--directory` - The directory under which your Git projects are located. By default if you do not specify the `--directory` flag then your current working directory will be used.

If you pass no arguments to the script then by default it will search inside of your current working directory.

## License

This project is licensed under the [MIT License](LICENSE.md).
