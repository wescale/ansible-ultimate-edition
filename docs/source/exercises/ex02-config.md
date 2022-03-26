# Ex02 - Configurer un projet

```{admonition} Objectif
:class: hint

Configurer un projet pour pouvoir travailler proprement avec.
```

## Création d'un virtualenv dédié

Afin d'être certain de fixer la version d'Ansible avec laquelle nous travaillons et pour préparer
l'isolation des dépendances Python du projet, nous faisons un virtualenv dédié. C'est la même méthode que pour 
l'installation initiale, mais au niveau de notre projet.

* Création d'un fichier `.envrc` au niveau projet, pour indiquer à direnv de créer un virtualenv

```bash session
$ pwd
/home/user/ansible-workspaces/ultimate/training

$ echo "layout python3" > .envrc
direnv: error /home/amaury/ansible-workspaces/ultimate/training/.envrc is blocked. Run `direnv allow` to approve its content

$ direnv allow
direnv: loading ~/ansible-workspaces/ultimate/training/.envrc
direnv: export +VIRTUAL_ENV ~PATH

$ which python
/home/user/ansible-workspaces/ultimate/training/.direnv/python-3.9.2/bin/python

$ git add .envrc && git commit -m "adding .envrc"
```

Il nous reste à faire ignorer à Git le répertoire `.direnv` local au projet pour éviter de l'inclure dans un commit.


```bash session
$ echo ".direnv" >> .gitignore

$ git add .gitignore && git commit -m "ignore local virtualenv"
```

## Configuration Ansible

## Ligne d'arrivée
