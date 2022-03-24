# Installation

Outre le guide officiel qui est la référence pour toutes les plateformes, voici quelques retours de terrain
pour vous garder dans une zone de confort, à l'écart des problèmes imprévus.

La diversité des systèmes est le premier puzzle à résoudre pour permettre à une équipe de travailler efficacement.
L'approche préconisée diminue la surface de frottement avec le système au maximum pour s'attaquer très tôt aux éventuels
problèmes et ne plus avoir á y penser par la suite.

```{admonition} Note
:class: important

Ce guide a été validé sur un système Debian Bullseye. Il se peut que vous ayez besoin d'adapter quelques éléments
pour pouvoir reproduire sur d'autres sytèmes.
```

## Installation dans un virtualenv de travail

La meilleure façon d'installer Ansible de notre point de vue est de s'appuyer sur un virtualenv 
pour chacun de vos projets. Cela permet d'isoler les dépendances projet du système, mais également d'un projet à un autre
et de pouvoir travailler avec plusieurs versions fixes d'Ansible en parrallèle. 

Il existe de nombreuses manières de réaliser cette gestion de virtualenv. Je vous livre ici une méthode qui 
est robuste et nécessite peu d'expertise Python.

### Prérequis

Pour que tout se passe comme prévu, vous aurez besoin de:

* Python > 3.7.3 et les modules venv
* direnv, qui va nous faciliter la vie pour gérer le virtualenv
* make, encore une fois pour se faciliter la vie

```{admonition} Mise en pratique
:class: todo

[Exercice 00 - Installation](/exercises/ex00-install.md)
```

## Option: Installation par les packages systèmes

À moins que vous en ressentiez le besoin parce que vous maîtrisez déjà Ansible : déconseillé. Les packages systèmes 
sont rarement à jour et vous allez rapidement avoir un décalage entre la documentation que vous pourrez consulter
et la version que vous avez installé. C'est une source d'erreur facilement évitable.

## Option: Installation par les packages Python

De notre point de vue la seule méthode pour vraiment maîtriser ce qu'on fait. Une release Ansible officielle commence par
une publication sur PyPi. Le travail des mainteneurs démarre de ce point, donc autant se greffer ici pour être le plus à 
jour possible.

## Option: Conteneur de travail

Certains fans de conteneurs voudront enfermer Ansible pour s'assurer de l'isolation totale des dépendances de Dev avec le système.
C'est un chemin respectable et vous trouverez en bas de page un guide pour vous aidez.

Nous ne développons pas cette technique ici, dans la mesure où elle implique des connaissances supplémentaires et que nous visons
une approche très Lean d'Ansible.


```{admonition} Approfondir
:class: seealso

* [Doc officielle : Installation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installation-guide)
* [Guide de construction de conteneur de travail](https://dev.to/cloudskills/using-containers-for-ansible-development-2n9n)
```
