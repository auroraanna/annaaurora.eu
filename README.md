# [annaaurora.eu](https://annaaurora.eu) 🌐️

Anna Aurora's personal website's <span style="text-decoration: underline;">source code</span>

This repository contains:
- The source code of the webpages for Anna Aurora's
	- Linux journey
	- recommendations
	- blog
	- artwork
	- online accounts
	- games

The [Zola static website generator](https://www.getzola.org/) compiles the Markdown, [Tera](https://tera.netlify.app/) templates and Sass to HTML and CSS. The compiled site can be found at <https://codeberg.org/annaaurora/pages>.

## Usage

### Dependencies

These are the dependencies for the following usage sections:
- [just](https://github.com/casey/just)
- [Zola](https://www.getzola.org)
- Awk
- sed
- [imagemagick](https://imagemagick.org/index.php)
- [rsync](https://rsync.samba.org)

If you use Nixpkgs or Alpine Linux: Awk and sed are included preinstalled so you don't have to install them separately.

### Starting a webserver with the compiled site

```
just serve
```
Note that the lossy artwork images are missing when serving because I thought it be hurtful to the disk to generate the lossy images into the source folders every time you want to serve. It also keeps the folders clean of files that shouldn't be in the source code because they can be generated.

### Compiling

```bash
just build
```

This lets Zola compile the website and then regenerates the lossy images.

## Contributing

If you have something that you think should be on this website please open an issue at <https://codeberg.org/annaaurora/annaaurora.eu/issues> so we can discuss it further.

## License

©️ 2022 Anna Aurora Neugebauer

By default everything in this repository is licensed under the [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/legalcode). [Here](https://creativecommons.org/licenses/by-sa/4.0/) is human-readable summary of the license.

However, if a file has a comment in it with a license statement or if a folder has a license file in it then the default license is overwritten for the respective files or folders.
