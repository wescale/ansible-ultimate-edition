# Gestion des dépendances

## Dépendances Python

Autant ne rien inventer et suivre les coutumes locales :

* un fichier `requirements.txt` au [format attendu par Pip](https://pip.pypa.io/en/latest/reference/requirements-file-format/)
* une commande `pip install -U requirements.txt`

Pas besoin de plus pour les dépendances de librairies Python... Les étapes précédentes de 
[gestion de virtualenv dédié](/exercises/basics/ex02-config.md) au projet commencent à payer puisque cette approche va naturellement 
installer les librairies dans le répertoire du virtualenv, proprement isolé d'un projet à l'autre.

```{admonition} Perle de sagesse
:class: tip

Tous les projets Python qui ont des dépendances devraient avant tout installer les modules `pip`, `wheel` et `setuptools` pour éviter des problèmes communs de build de paquets Pip.
```

## Dépendances Ansible

Les dépendances Ansible sont de 2 natures :

* des rôles
* des collections

par chance (ou intelligence des designers de Ansible), les 2 peuvent être décrits dans le même fichier. Ce fichier de 
dépendances se nomme par convention `requirements.yml` et ressemble à ceci :

```yaml
---
roles:
  # Install a role from Ansible Galaxy.
  - name: geerlingguy.java
    version: 1.9.6

collections:
  # Install a collection from Ansible Galaxy.
  - name: geerlingguy.php_roles
    version: 0.9.3
    source: https://galaxy.ansible.com
```

```{admonition} Approfondir
:class: seealso

* [Documentation Ansible - Le requirements.yml](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html#install-multiple-collections-with-a-requirements-file)
```

## Plus haut, plus vite, plus fort

Si vous lisez ce texte, nous pouvons supposer qu'une part de votre travail est d'automatiser des choses pour aller plus vite...

Par conséquent, poussons un petit cran plus loin. L'ajout d'un fichier `Makefile` pour grouper toutes les commandes 
de rapatriements des dépendances est assez confortable sur le long terme.

Le choix de Makefile a été dicté par sa grande disponibilité sur un ensemble de système (il est même souvent dans les packages
par défaut).

Voici ce que pourrait donner un Makefile un peu travaillé pour se faciliter la vie:

```Makefile
.PHONY: env
env-desc = "Setup local dev env"
env:
	@echo "==> $(env-desc)"

	@[ -d "${PWD}/.direnv" ] || (echo "Venv not found: ${PWD}/.direnv" && exit 1)
	@pip3 install -U pip wheel setuptools --no-cache-dir && \
	echo "[  OK  ] PIP + WHEEL + SETUPTOOLS" || \
	echo "[FAILED] PIP + WHEEL + SETUPTOOLS"

	@pip3 install -U --no-cache-dir -r ${PWD}/requirements.txt && \
	echo "[  OK  ] PIP REQUIREMENTS" || \
	echo "[FAILED] PIP REQUIREMENTS"

	@ansible-galaxy collection install -fr ${PWD}/requirements.yml && \
	echo "[  OK  ] ANSIBLE-GALAXY REQUIREMENTS" || \
	echo "[FAILED] ANSIBLE-GALAXY REQUIREMENTS"
```

Une fois toutes [](__index.md) respectées, on obtient une convention où un nouvel arrivant sur le projet à besoin de :

* Direnv
* Git
* Python
* Make

... et devient capable de produire du code après avoir lancé :

* `git clone [...]`
* `direnv allow .`
* `make env`

Ce qui paraît abordable par le plus grand nombre, même débutants. Ce n'est évidemment pas la seule façon de faire les choses, 
mais de toutes celles qu'on a essayé, c'est clairement le chemin de l'effort et de l'emmerdement minimal.
