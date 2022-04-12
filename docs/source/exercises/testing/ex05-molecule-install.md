# Installation de Molecule

## Prérequis 

Pour que tout se passe comme prévu, vous aurez besoin que votre projet se conforme aux pratiques vues dans les [](/exercises/basics/__index.md).

## Installation

Partant du principe que vous avez suivi les recommandations du chapitre sur [](/basics/__index.md), pour installer Molecule :

* Dans le fichier `requirements.txt` de votre projet, ajoutez une ligne :

```
molecule==3.5.2
molecule-docker
```

```{admonition} Note
:class: note

Cette dépendances est fixée sur 3.5.2 pour des problèmes de bugs non résolus au moment de la rédaction. 
Cela est destiné à changer.
```

* Dans le fichier `requirements.yml` de votre projet, ajoutez la collection `community.docker` :

```yaml
collections:
  - name: community.docker
```

* Lancez la commande : `make env`

## Validation

Molecule, ainsi que le driver Docker sont maintenant installés. Vous pouvez le vérifier en lançant :

```bash session
$ molecule --version
molecule 3.6.1 using python 3.9 
    ansible:2.12.3
    delegated:3.6.1 from molecule
    docker:1.1.0 from molecule_docker requiring collections: community.docker>=1.9.1
```

Vous pouvez également constater la présence du répertoire `.direnv/ansible_collections/community/docker` qui contient la collection
`community.docker` et ses modules indispensables au fonctionnement du driver Docker de Molecule.
