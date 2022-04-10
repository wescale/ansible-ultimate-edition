# Gérer les dépendances

```{admonition} Objectif
:class: hint

Ajouter des dépendances Python et Ansible à un projet.
```

## Prérequis

Pour que tout se passe comme prévu, vous aurez besoin que soient installés sur votre machine de travail :

* [Les exercices 00 à 02](__index.md)
* Make

Pour notre cas de référence (Debian Bullseye), atteindre ces prérequis passe par le lancement des commandes suivantes :

```shell session
$ sudo apt update 
$ sudo apt install make -y
```

## Échauffement

Pour éviter des problèmes communs de construction de package Pip, commencez par lancer :

```bash session
$ pip3 install -U pip wheel setuptools --no-cache-dir 
```

Afin de bien isoler nos dépendances Ansible, il faut rajouter à la configuration commune du projet (dans le `.envrc`) :

```bash
export DIRENV_TMP_DIR="${PWD}/.direnv"
export ANSIBLE_COLLECTIONS_PATHS="${DIRENV_TMP_DIR}"
```

Et valider la nouvelle version de notre `.envrc` auprès de direnv avec la commande :

```bash session
$ direnv allow .
```

## Création d'un fichier de requirements Pip

Créez un fichier `requirements.txt` avec notre version préférée d'Ansible pour le projet.

```bash session
$ echo 'ansible-core==2.12.4' >> requirements.txt
```

Une fois ceci fait, nous pouvons rapatrier les dépendances listées avec la commande :

```bash session
$ pip3 install -U --no-cache-dir -r requirements.txt 
Collecting ansible-core==2.12.4
  Downloading ansible-core-2.12.4.tar.gz (7.8 MB)
     |████████████████████████████████| 7.8 MB 5.6 MB/s 
[...]
Successfully installed MarkupSafe-2.1.1 PyYAML-6.0 ansible-core-2.12.3 cffi-1.15.0 cryptography-36.0.2 jinja2-3.1.1 packaging-21.3 pycparser-2.21 pyparsing-3.0.7 resolvelib-0.5.4
```

## Création d'un fichier de requirements Ansible Galaxy

Créez un fichier `requirements.yml` avec un rôle et une collection tirés de la plateforme centrale Ansible Galaxy :

```yaml
---
roles:
  # Install a role from Ansible Galaxy.
  - name: geerlingguy.java
    version: 1.9.6

collections:
  # Install a collection from Ansible Galaxy.
  - name: community.general
    version: 4.5.0
```

Une fois ceci fait, nous pouvons rapatrier les dépendances listées avec la commande :

```bash session
$ ansible-galaxy install -fr requirements.yml
Starting galaxy role install process
- downloading role 'java', owned by geerlingguy
- downloading role from https://github.com/geerlingguy/ansible-role-java/archive/1.9.6.tar.gz
- extracting geerlingguy.java to /home/user/ansible-workspaces/ultimate/training/roles/geerlingguy.java
- geerlingguy.java (1.9.6) was installed successfully
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Downloading https://galaxy.ansible.com/download/community-general-4.5.0.tar.gz to /home/user/.ansible/tmp/ansible-local-22651iywi1i6a/tmp3l1ya7ov/community-general-4.5.0-kwp8buwp
Installing 'community.general:4.5.0' to '/home/user/ansible-workspaces/ultimate/training/.direnv/ansible_collections/community/general'
community.general:4.5.0 was installed successfully
```

Vous pouvez observer que la collection s'est installée dans un sous-répertoire de `.direnv` et que le rôle est installè dans votre sous-répertoire `roles`.

## Création d'un Makefile basique pour simplifier la mise à jour des dépendances

Comme nous sommes des gens d'automatisation, la complexité des commandes précédente sera mieux placée dans un fichier `Makefile` :

```Makefile
.PHONY: env
env-desc = "Setup local dev env"
env:
	@echo "==> $(env-desc)"

	@[ -d "${PWD}/.direnv" ] || (echo "Venv not found: ${PWD}/.direnv" && exit 1)
	@pip3 install -U pip wheel setuptools --no-cache-dir && \
	echo "[  OK  ] PIP + WHEEL + SETUPTOOLS" || \
	echo "[FAILED] PIP + WHEEL + SETUPTOOLS"

	@pip3 install -U --no-cache-dir -r "${PWD}/requirements.txt" && \
	echo "[  OK  ] PIP REQUIREMENTS" || \
	echo "[FAILED] PIP REQUIREMENTS"
	
	@ansible-galaxy install -fr "${PWD}/requirements.yml" && \
	echo "[  OK  ] ANSIBLE-GALAXY REQUIREMENTS" || \
	echo "[FAILED] ANSIBLE-GALAXY REQUIREMENTS"
```

Vous pouvez relancer la procédure complète de rapatriement des dépendances avec la commande :

```bash session
$ make env
```

## Ligne d'arrivée

Félicitations, vous avez maintenant l'expérience de la gestion des dépendances Python et Ansible, ce qui vous servira à coup sûr dans
vos futurs projets. Vous avez également complété les exercices qui vous permettent de poser des bases saines pour tout projet Ansible. 
