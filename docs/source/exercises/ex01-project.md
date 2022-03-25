# Ex01 - Création de projet

```{admonition} Objectif
:class: hint

Création d'un projet Ansible vierge.
```

## Prérequis

Pour que tout se passe comme prévu, vous aurez besoin que soient installés sur votre machine de travail:

* Python > 3.7.3 et les modules venv et pip
* direnv

Il y a trop de configurations de systèmes pour pouvoir couvrir tous les cas ici. Notre cas de référence sur 
Debian Bullseye n'est pas tiré de nulle part : cette configuration permet à de nombreux professionnels de gagner leur vie
en étant productif au quotidien (Debian sur laptop, aujourd'hui ce n'est pas un problème).

Pour notre cas de référence donc, atteindre ces prérequis passe par le lancement des commandes suivantes :

```shell session
$ sudo apt update 
$ sudo apt install direnv python3 python3-pip python3-venv
$ echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
$ source ~/.bashrc
```

