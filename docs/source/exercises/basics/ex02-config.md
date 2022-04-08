# Ex02 - Configurer un projet

```{admonition} Objectif
:class: hint

Configurer un projet pour pouvoir travailler proprement avec.
```

## Création d'un virtualenv dédié

Afin d'être certain de fixer la version d'Ansible avec laquelle nous travaillons et pour préparer
l'isolation des dépendances Python du projet, nous créons un virtualenv dédié. C'est la même méthode que pour 
l'installation initiale, mais au niveau de notre projet.

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

On peut voir que le virtual env est activé à partir de l'activation de direnv.

Il nous reste à faire ignorer par git le répertoire `.direnv` local au projet pour éviter de l'inclure dans un commit.

```bash session
$ echo ".direnv" >> .gitignore

$ git add .gitignore && git commit -m "ignore local virtualenv"
```

## Configuration d'Ansible

Nous allons maintenant configurer quelques comportements basiques d'Ansible en remplissant le fichier `.envrc`.

```bash session
$ cat >> .envrc <<EOF
export DIRENV_TMP_DIR="${PWD}/.direnv"
export ANSIBLE_STDOUT_CALLBACK="ansible.posix.debug"
export ANSIBLE_INVENTORY="inventory"
export ANSIBLE_FORKS="10"
export ANSIBLE_ROLES_PATH="roles"
export ANSIBLE_COLLECTIONS_PATHS="${DIRENV_TMP_DIR}"
export ANSIBLE_CALLBACKS_ENABLED="timer,profile_tasks"
EOF

direnv: error /home/user/Workspaces/WeScale/ansible-ultimate-edition/.envrc is blocked. Run `direnv allow` to approve its content

$ direnv allow .
direnv: loading ~/ansible-workspaces/ultimate/training/.envrc
direnv: export +ANSIBLE_CALLBACK_WHITELIST +ANSIBLE_FORKS +ANSIBLE_INVENTORY +ANSIBLE_ROLES_PATH +ANSIBLE_STDOUT_CALLBACK

$ git commit -am "Added ansible configuration"
```

Dès que nous modifions le fichier `.envrc`, direnv nous met en garde car la version actuelle n'a pas été explicitement  approuvée
par une commande `direnv allow .`. Une fois nos modifications terminées, on lance cette commande pour que direnv charge la
version finale.


## Configuration personnelle

Sur cette base, nous ajoutons notre configuration personnelle. Pour l'exemple, nous prenons les 2 variables sensibles permettant de configurer notre accès aux API Scaleway : `SCW_ACCESS_KEY`, `SCW_SECRET_KEY` et `SCW_DEFAULT_ORGANIZATION_ID`.

Tout d'abord nous rajoutons un fichier dans le `.gitignore` afin de ne pas faire d'erreur de manipulation :

```bash session
$ echo '.env.local' >> .gitignore
```

Ensuite nous pouvons remplir ce fichier avec nos exports de variables :


```bash session
$ cat >> .env.local <<EOF
export SCW_ACCESS_KEY="..."
export SCW_SECRET_KEY="..."
export SCW_DEFAULT_ORGANIZATION_ID="..."
EOF
```

Enfin, pour assurer le chargement transparent de ce nouveau fichier, on intègre un bout de shell dans notre 
`.envrc` qui sert de point d'accroche à direnv :

```bash
LOCAL_CONFIG="${PWD}/.env.local"
if [ -e "${LOCAL_CONFIG}" ]; then
  source "${LOCAL_CONFIG}"
fi
```

Une fois modifié le fichier `.envrc`, direnv nécessite que l'on revalide son chargement.


```bash session
$ direnv allow .
```

Et histoire de rester propre, on commit le tout :

```bash session
$ git commit -am "Added personnal configuration loading"
```

## Ligne d'arrivée

Félicitations, vous venez d'ajouter de la configuration Ansible à votre projet. Toutes les configurations communes à tous les
intervenants sur le code peuvent être gérées de cette façon.
