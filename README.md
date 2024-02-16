![Ryan Mono](/.github/cover.svg)

Ryan's homemade [Iosevka][iosevka] build. There are two families: **Ryan Mono**, a monospace font, and **Ryan Term**, a fixed-width monospace font optimized for the terminal.

Each family also has a version that is patched with Nerd Fonts symbols, although it is recommended to use the normal font with [the symbols-only Nerd Font][NerdFontsSymbolsOnly.tar.xz] as a fallback.

## Download

Fonts are built as TTFs and packaged in three archive formats, in order from best to worst compression:

- `tar.xz`: tarballs compressed with XZ
- `tar.gz`: tarballs compressed with Gzip
- `zip`: zip archives

### Non-Nerd Font

|          | Ryan Mono                          | Ryan Term                          |
| -------- | ---------------------------------- | ---------------------------------- |
| `tar.xz` | [RyanMono.tar.xz][RyanMono.tar.xz] | [RyanTerm.tar.xz][RyanTerm.tar.xz] |
| `tar.gz` | [RyanMono.tar.gz][RyanMono.tar.gz] | [RyanTerm.tar.gz][RyanTerm.tar.gz] |
| `zip`    | [RyanMono.zip][RyanMono.zip]       | [RyanTerm.zip][RyanTerm.zip]       |

### Nerd Font

|          | RyanMono Nerd Font                                 | RyanTerm Nerd Font                                 |
| -------- | -------------------------------------------------- | -------------------------------------------------- |
| `tar.xz` | [RyanMonoNerdFont.tar.xz][RyanMonoNerdFont.tar.xz] | [RyanTermNerdFont.tar.xz][RyanTermNerdFont.tar.xz] |
| `tar.gz` | [RyanMonoNerdFont.tar.gz][RyanMonoNerdFont.tar.gz] | [RyanTermNerdFont.tar.gz][RyanTermNerdFont.tar.gz] |
| `zip`    | [RyanMonoNerdFont.zip][RyanMonoNerdFont.zip]       | [RyanTermNerdFont.zip][RyanTermNerdFont.zip]       |

## Building

A comprehensive build script is included in `build.sh`. FontForge, Node.js, Git, find, xargs, curl, unzip, tar, and zip are required dependencies.

```console
$ ./build.sh
```

The script automatically downloads sources for Iosevka and Nerd Fonts, builds and patches fonts, and packages them, along with managing concurrency.

## License

SIL Open Font License, Version 1.1

[iosevka]: https://typeof.net/Iosevka/
[NerdFontsSymbolsOnly.tar.xz]: https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.tar.xz
[RyanMono.zip]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanMono.zip
[RyanMono.tar.gz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanMono.tar.gz
[RyanMono.tar.xz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanMono.tar.xz
[RyanMonoNerdFont.zip]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanMonoNerdFont.zip
[RyanMonoNerdFont.tar.gz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanMonoNerdFont.tar.gz
[RyanMonoNerdFont.tar.xz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanMonoNerdFont.tar.xz
[RyanTerm.zip]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanTerm.zip
[RyanTerm.tar.gz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanTerm.tar.gz
[RyanTerm.tar.xz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanTerm.tar.xz
[RyanTermNerdFont.zip]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanTermNerdFont.zip
[RyanTermNerdFont.tar.gz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanTermNerdFont.tar.gz
[RyanTermNerdFont.tar.xz]: https://github.com/ryanccn/ryan-mono/releases/latest/download/RyanTermNerdFont.tar.xz
