+++
title = 'Home Manager, the best solution to your dotfiles'
date = 2022-01-02 02:13:00

[taxonomies]
tags = ["nix", "home-manager"]
categories = ["programming"]
+++
## Problems with other dotfiles managers

You have your dotfiles hosted on GitHub or GitLab for example but have to add a license for a wallpaper from someone else. You have to update files from others manually. You have to manually install programs or run scripts to do so.

## Solutions

### Git

If you use Git to manage your dotfiles then it may be viable to add another Git repository as a git submodule. (`git submodule add`) A Git submodule is a git repository inside a git repository and can therefore be easily updated. Since the Git submodule's files are only put your Git repo when your repo is cloned you bypass having to add a license.

### Home Manager

However, if you only want a single file from somewhere or the files are not in a Git repository then I recommend using [Home Manager](https://github.com/nix-community/home-manager), which uses the [The Nix Expression Language](https://nixos.wiki/wiki/Nix_Expression_Language), to manage your dotfiles. The Nix Expression Language has builtin functions download files when you **rebuild** your dotfiles. Here's an example on how to use them with Home Manager:
```nix
home.file.".config/neofetch/image.svg".source = builtins.fetchurl {
  url = https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg;
  sha256 = "14mbpw8jv1w2c5wvfvj8clmjw0fi956bq5xf9s2q3my14far0as8";
};
```
This will check whether <https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg> still has that sha256 checksum (checking whether the file has changed or not) and then download it to `$HOME/.config/neofetch/image.svg` if the checksum is the same. If not you will have to update it. That way the files won't be uploaded into your git repo and therefore you won't have to add their license. Same as for [Git](#git)

What is **rebuilding** my dotfiles though? With Home Manager you place your dotfiles in one folder. Then when you do `home-manager switch` and your dotfiles will be placed in their corresponding locations in your home directory.

You won't have to rewrite all of your dotfiles. They can be imported in `.nix` files.

Home Manager can also install programs for you when you rebuild. You define them in `.nix` files too.

In conclusion, I find Home Manager to be a way better solution to you dotfiles than using `stow` for example.

How to install and use home manager can be found [here](https://github.com/nix-community/home-manager). To get a list of all the nix options for Home Manager visit [this site](https://nix-community.github.io/home-manager/options.html).

If you not only want to use Nix to manage your home directory but also your system [NixOS](https://nixos.org/) may be a fit for you.
