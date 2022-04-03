# Docker Driver

```{admonition} À savoir
:class: tip

Pour réaliser vos tests de rôles Ansible avec Molecule et Docker, vous allez devoir comettre une hérésie. 

Vous trouverez dans tous les bon tutoriels sur Docker qu'il est contre-nature de faire démarrer un conteneur avec 
systemd ou un autre service manager comme processus principal. C'est ce que vous allez devoir faire si vous testez des 
rôles qui mettent en place des services systèmes (spoiler : c'est le cas 90% du temps).
```

## Installation

Partant du principe que vous avez suivi les recommandations du chapitre sur [](/basics/__index.md), pour installer Molecule :

* Dans le fichier `requirements.txt` de votre projet, ajoutez une ligne `molecule[docker]`
* Dans le fichier `requirements.yml` de votre projet, ajoutez la collection `community.docker` :

```yaml
collections:
  - name: community.docker
```

* Lancez la commande : `make env`

## Initialisation

Pour démarrer avec Molecule :

* placez vous à la racine d'un rôle, disons `roles/a_tester` pour l'exemple.

```bash session
$ cd roles/a_tester

$ molecule init scenario --driver=docker default
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/user/ansible-workspaces/ultimate/training/roles/a_tester/molecule/default successfully.

$ tree -a molecule/
molecule/
└── default
    ├── converge.yml
    ├── molecule.yml
    └── verify.yml

1 directory, 3 files
```

On peut voir que la commande d'init a créer un répertoire `molecule` et plusieurs fichiers :

* `molecule.yml` : fichier de configuration des environnements de test et des options molecule pour ce scénario
* `converge.yml` : playbook qui sera appliqué au environnements de test
* `verify.yml` : playbook qui sera joué pour vérifier que `converge.yml` a bien effectué les modifications attendues

## Configuration

Allez modifier le fichier `molecule.yml` pour qu'il ressemble à ceci :

```yaml
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  - name: debian
    image: geerlingguy/docker-debian11-ansible:latest 
    pre_build_image: true
    pull: true
    privileged: true
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
provisioner:
  name: ansible
verifier:
  name: ansible
```

```{admonition} Approfondir
:class: seealso

* [Spécification complète des options du driver Docker pour Molecule](https://github.com/ansible-community/molecule-docker/blob/main/src/molecule_docker/driver.py)
```
