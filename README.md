# [annaaurora.eu](https://annaaurora.eu) 🌐️

## What is this?

Anna Aurora's personal website's <span style="text-decoration: underline;">source code</span>.

Anna Aurora's website contains her the her [Linux journey](https://annaaurora.eu/linux-journey), her [software recommendations](https://annaaurora.eu/recommendations), her [blog](https://annaaurora.eu/blog), her [artwork](https://annaaurora.eu/art), [links to her online accounts which includes ways to contact her](https://annaaurora.eu/accounts) and [one of her games](https://annaaurora.eu/find-billy).

The compiled site can be found at <https://annaaurora.eu> of course or by [compiling it yourself](#compiling).

## Development

The compilation tools are defined by the `nativeBuildInputs` on line 27 of `flake.nix`.

To start a shell with all the compilation tools do
```bash
nix develop
```
and after that do
```bash
zola serve
```
to start a development webserver of the website. Note that all the stuff the the compilation does like the lossy artwork images and music is missing on the website served by Zola. To have all the stuff and the compilation tools follow [Compiling](#compiling) and then run the command again.

You could also do other stuff with the compilation tools I guess like testing out which audio format takes up the least space for my songs with FFmpeg.

### Compiling

```bash
nix build --verbose ".?submodules=1"
```
In short, the above command runs all the shell commands in the `buildPhase` on line 35 of `flake.nix` with the compilation tools installed and the `inputs` on line 4 of `flake.nix`  downloaded. The compiled website is then in `result`.

In short, the [Zola static website generator](https://www.getzola.org/) compiles the Markdown, [Tera](https://tera.netlify.app/) templates and Sass to HTML and CSS. Then some images and audio is generated and the site is polished.

## Contributing

If you have something that you think should be on this website, found any security issues or whatever else please [open an issue](https://codeberg.org/annaaurora/annaaurora.eu/issues), [contact me](https://annaaurora.eu/accounts#contact) or [open a Pull Request](https://codeberg.org/annaaurora/annaaurora.eu/pulls).

## License

©️ 2022 Anna Aurora Neugebauer

By default everything in this repository is licensed under the [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/legalcode). [Here](https://creativecommons.org/licenses/by-sa/4.0/) is human-readable summary of the license.

However, if a file has a comment in it with a license statement or if a folder has a license file in it then the default license is overwritten for the respective files or folders.
