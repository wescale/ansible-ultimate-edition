# Gérer les dépendances

```{admonition} Objectif
:class: hint

Ajouter des dépendances Python et Ansible à un projet.
```

## Prérequis

* [Préparation](/exercises/prerequisites.md)
* [Installer Ansible](ex00-install.md)
* [Créer un projet](ex01-project.md)
* [Configurer un projet](ex02-config.md)

## Échauffement

Pour éviter des problèmes communs de construction de package Pip, commencez par lancer :

```
pip3 install -U pip wheel setuptools --no-cache-dir 
```

## Création d'un fichier de requirements Pip

Créez un fichier `requirements.txt` avec notre version préférée d'Ansible pour le projet.

```bash session
echo 'ansible-core==2.14.2' >> requirements.txt
```

Une fois ceci fait, nous pouvons rapatrier les dépendances listées avec la commande :

```
pip3 install -U --no-cache-dir -r requirements.txt 
```

## Création d'un fichier de requirements Ansible Galaxy

Créez un fichier `requirements.yml` avec un rôle et une collection tirés de la plateforme centrale Ansible Galaxy :

```yaml
---
# Install roles from Ansible Galaxy.
roles:
  - name: geerlingguy.java
    version: 1.9.6

# Install collections from Ansible Galaxy.
collections:
  - name: community.general
    version: 4.5.0
  - name: ansible.posix
```

Une fois ceci fait, nous pouvons rapatrier les dépendances listées avec la commande :

```bash session
ansible-galaxy install -fr requirements.yml
```

Vous pouvez observer que la collection et le rôle sont installés dans un sous-répertoire de `.direnv`.

## Création d'un Makefile basique pour simplifier la mise à jour des dépendances

Comme nous sommes des gens d'automatisation, la complexité des commandes précédentes 
sera mieux placée dans un fichier `Makefile` :

```Makefile
.PHONY: prepare
prepare-desc = "Prepare local workspace"
prepare:
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

```
make prepare
```

## Ligne d'arrivée

Félicitations, vous avez maintenant l'expérience de la gestion des dépendances Python et Ansible, ce 
qui vous servira à coup sûr dans vos futurs projets. Vous avez également complété les exercices qui 
vous permettent de poser des bases saines pour tout projet Ansible. 
