# Préparer un système OSX


Vous pouvez également réaliser les exercises sur OSX. Cependant, quelques pré-requis sont à mettre en œuvre avant de commencer.

```{admonition} Note
:class: important

Ce guide peut être réalisé sur les Mac avec processeurs Intel. Les Mac avec processeurs M1 ont une architecture ARM, ce qui les rend incompatibles avec les conteneurs Docker construits sur des machines sous architecture Intel x86 64 bits.
```

## Gestion des paquets

Évidemment, on n'utilisera pas APT, mais [HomeBrew](https://brew.sh/index_fr). N'oubliez pas d'adapter les commandes d'installation de paquets le cas échéant dans les exercices.

Nous vous recommandons d'utiliser HomeBrew sur MacOSX, afin de gérer l'installation de vos logiciels open-source.

## Installation des pré-requis

```bash session
$ brew install coreutils direnv wget curl

$ brew cask install docker
```

Vous devriez être paré pour attaquer les [](/exercises/__index.md)

```{admonition} Approfondir
:class: seealso

* [Documentation Docker - Installation sur Mac ](https://docs.docker.com/desktop/mac/install/)
```
