# Préparer un système OSX


Vous pouvez également réaliser les exercises sur OSX. Cependant quelques pré-requis sont à mettre en oeuvre avant de commencer.

```{admonition} Note
:class: important

Ces exercices peuvent êtres réalisés sur les Mac avec processeurs Intel. En effet les Mac avec processeur M1 ont une architecture ARM, et de ce fait sont incompatibles avec les conteneurs Docker construits sur des machines sous architecture Intel X86 64 bits.
```

## Gestion des paquets

Evidement on n'utilisera pas APT, mais [HomeBrew](https://brew.sh/index_fr). N'oubliez pas d'adapter les commandes d'installation de paquets le cas échéant dans les exercices.

Nous vous recommandons d'utiliser HomeBrew sur MacOSX, afin de gérer l'installation de vos logiciels open-source.

## Installation des pré-requis

```bash
$ brew install coreutils direnv wget curl
```

```bash
$ brew cask install docker
```

```{admonition} Approfondir
:class: seealso

* [Documentation Docker - Installation sur Mac ](https://docs.docker.com/desktop/mac/install/)

```
