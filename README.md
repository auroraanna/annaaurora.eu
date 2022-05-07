# [papojari.codeberg.page](https://papojari.codeberg.page) 🌐️

## Usage

### Dependencies

These are the dependencies for the following usage sections:
- [just](https://github.com/casey/just)
- [Zola](https://www.getzola.org/)
- Awk
- sed
- [imagemagick](https://imagemagick.org/index.php)

If you use Nixpkgs: Awk and sed are included in the stdenv so you don't have to install them separately.

### Starting a webserver with the compiled site

```
just serve
```
Note that the lossy artwork images are missing when serving because I thought it be hurtful to the disk to generate the lossy images into the source folders every time you want to serve. It also keeps the folders clean of files that shouldn't be in the source code because they can be generated.

### Compiling

```bash
just build
```

This lets Zola compile the website and then checks if any of the lossless artwork images have changed. If they have the lossy images are regenerated. The lossy images obviously don't need to be regenerated if nothing changed.
