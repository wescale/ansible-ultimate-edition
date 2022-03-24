# Installation

Outre le guide officiel qui est la référence pour toutes les plateformes, voici quelques retours de terrain
pour vous garder dans une zone de confort, à l'écart des problèmes imprévus.

La diversité des systèmes est le premier puzzle à résoudre pour permettre à une équipe de travailler efficacement.
L'approche préconisée diminue la surface de frottement avec le système au maximum pour s'attaquer très tôt aux éventuels
problèmes et ne plus avoir á y penser par la suite.

## Méthode

### Packages Pip dans un virtualenv

La meilleure façon d'installer Ansible de notre point de vue est de s'appuyer sur un virtualenv 
pour chacun de vos projets. Cela permet d'isoler les dépendances projet du système, mais également d'un projet à un autre
et de pouvoir travailler avec plusieurs versions fixes d'Ansible en parallèle.

Une release Ansible officielle commence par une publication sur PyPi. Le travail des mainteneurs démarre de ce 
point, donc autant se greffer ici pour être le plus à jour possible.

Il existe de nombreuses manières de réaliser cette gestion de virtualenv. Je vous livre ici une méthode qui 
est robuste et nécessite peu d'expertise Python et un minimum de prérequis
(comprendre: on n'a pas réussi à faire moins jusqu'ici).

```{admonition} Mise en pratique
:class: important

[Exercice 00 - Installation](/exercises/ex00-install.md)
```

### Alternative - Packages Pip au niveau système

L'installation de packages Python au niveau système, que ce soit pour un ou tous les utilisateurs, peut rapidement apporter 
des problèmes de conflits de version sur des dépendances. Source de problèmes, cette méthode est donc écartée.


### Alternative - Packages systèmes

À moins que vous en ressentiez le besoin parce que vous maîtrisez déjà Ansible : déconseillé. Les packages systèmes 
sont rarement à jour et vous allez rapidement avoir un décalage entre la documentation que vous pourrez consulter
et la version que vous avez installé. C'est une source d'erreur facilement évitable.


### Alternative - Conteneur de travail

Certains fans de conteneurs voudront enfermer Ansible pour s'assurer de l'isolation totale des dépendances de Dev avec le système.
C'est un chemin respectable et vous trouverez en bas de page un guide pour vous aidez.

Nous ne développons pas cette technique ici, dans la mesure où elle implique des connaissances supplémentaires et que nous visons
une approche très Lean d'Ansible.

----

```{admonition} Approfondir
:class: seealso

* [Doc officielle : Installation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installation-guide)
* [Guide de construction de conteneur de travail](https://dev.to/cloudskills/using-containers-for-ansible-development-2n9n)
```

