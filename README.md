# Ryan Mono

Ryan's homemade Iosevka build. There are two families: **Ryan Mono**, a monospace font, and **Ryan Term**, a fixed-width monospace font optimized for the terminal.

## Install

Fonts are built as TTFs and packaged in four archive formats, in order from best to worst compression:

- `tar.br`: tarballs compressed with Brotli (_nonstandard_)
- `tar.xz`: tarballs compressed with XZ
- `tar.gz`: tarballs compressed with Gzip
- `zip`: zip archives

### Non-Nerd Font

|          | Ryan Mono                          | Ryan Term                          |
| -------- | ---------------------------------- | ---------------------------------- |
| `zip`    | [RyanMono.zip][RyanMono.zip]       | [RyanTerm.zip][RyanTerm.zip]       |
| `tar.gz` | [RyanMono.tar.gz][RyanMono.tar.gz] | [RyanTerm.tar.gz][RyanTerm.tar.gz] |
| `tar.xz` | [RyanMono.tar.xz][RyanMono.tar.xz] | [RyanTerm.tar.xz][RyanTerm.tar.xz] |
| `tar.br` | [RyanMono.tar.br][RyanMono.tar.br] | [RyanTerm.tar.br][RyanTerm.tar.br] |

### Nerd Font

|          | Ryan Mono                                          | Ryan Term                                          |
| -------- | -------------------------------------------------- | -------------------------------------------------- |
| `zip`    | [RyanMonoNerdFont.zip][RyanMonoNerdFont.zip]       | [RyanTermNerdFont.zip][RyanTermNerdFont.zip]       |
| `tar.gz` | [RyanMonoNerdFont.tar.gz][RyanMonoNerdFont.tar.gz] | [RyanTermNerdFont.tar.gz][RyanTermNerdFont.tar.gz] |
| `tar.xz` | [RyanMonoNerdFont.tar.xz][RyanMonoNerdFont.tar.xz] | [RyanTermNerdFont.tar.xz][RyanTermNerdFont.tar.xz] |
| `tar.br` | [RyanMonoNerdFont.tar.br][RyanMonoNerdFont.tar.br] | [RyanTermNerdFont.tar.br][RyanTermNerdFont.tar.br] |

## Building

A comprehensive build script is included in `build.sh`. FontForge, Node.js, Git, find, xargs, curl, unzip, tar, and zip are required dependencies. Brotli is an optional dependency for building tarballs compressed with Brotli.

```console
$ ./build.sh
```

The script automatically downloads sources for Iosevka and Nerd Fonts, builds and patches fonts, and packages them, along with managing concurrency.

## License

SIL Open Font License, Version 1.1

[RyanMono.zip]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanMono.zip
[RyanMono.tar.gz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanMono.tar.gz
[RyanMono.tar.xz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanMono.tar.xz
[RyanMono.tar.br]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanMono.tar.br
[RyanMonoNerdFont.zip]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanMonoNerdFont.zip
[RyanMonoNerdFont.tar.gz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanMonoNerdFont.tar.gz
[RyanMonoNerdFont.tar.xz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanMonoNerdFont.tar.xz
[RyanMonoNerdFont.tar.br]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanMonoNerdFont.tar.br
[RyanTerm.zip]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanTerm.zip
[RyanTerm.tar.gz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanTerm.tar.gz
[RyanTerm.tar.xz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanTerm.tar.xz
[RyanTerm.tar.br]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanTerm.tar.br
[RyanTermNerdFont.zip]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanTermNerdFont.zip
[RyanTermNerdFont.tar.gz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanTermNerdFont.tar.gz
[RyanTermNerdFont.tar.xz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanTermNerdFont.tar.xz
[RyanTermNerdFont.tar.br]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanTermNerdFont.tar.br
