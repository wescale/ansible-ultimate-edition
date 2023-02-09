# Configurer un projet

```{admonition} Objectif
:class: hint

Configurer un projet pour pouvoir travailler proprement avec.
```

## Prérequis

* [Préparation](/exercises/prerequisites.md)
* [Installer Ansible](ex00-install.md)
* [Créer un projet](ex01-project.md)

## Création d'un virtualenv dédié

Afin d'être certain de fixer la version d'Ansible avec laquelle nous travaillons et pour préparer
l'isolation des dépendances Python du projet, nous créons un virtualenv dédié. C'est la même méthode que pour 
l'installation initiale, reproduite au niveau de notre projet.

```bash session
echo
echo "--- Placement dans le bon répertoire"
cd 
cd ansible-workspaces/ultimate/training
echo "--- Directive de création d'un venv dans le répertoire"
echo "layout python3" > .envrc
echo "--- Autorisation du nouveau contenu de .envrc"
direnv allow
echo "--- Vérification du chemin de Python"
echo "------ doit être sous ~/ansible-workspaces/ultimate/training/.direnv"
which python
echo "--- Sauvegarde des modifications"
git add .envrc && git commit -m "adding .envrc"
```

On peut voir que le virtual env est activé à partir de l'activation de direnv.

Il nous reste à faire ignorer par git le répertoire `.direnv` local au projet pour éviter de l'inclure dans un commit.

```bash session
echo ".direnv" >> .gitignore
git add .gitignore && git commit -m "ignore local virtualenv"
```

## Configuration d'Ansible

Nous allons maintenant configurer quelques comportements basiques d'Ansible en remplissant le fichier `.envrc`.

```bash session
cat >> .envrc <<EOF
export DIRENV_TMP_DIR="\${PWD}/.direnv"
export ANSIBLE_STDOUT_CALLBACK="ansible.posix.debug"
export ANSIBLE_FORKS="10"
export ANSIBLE_INVENTORY="inventory"
export ANSIBLE_SSH_ARGS="-F ssh.cfg"
export ANSIBLE_ROLES_PATH="\${DIRENV_TMP_DIR}/ansible_roles:\${PWD}/roles"
export ANSIBLE_COLLECTIONS_PATHS="\${DIRENV_TMP_DIR}"
export ANSIBLE_CALLBACKS_ENABLED="timer,profile_tasks"
EOF
echo "--- Autorisation du nouveau contenu de .envrc"
direnv allow .
git commit -am "Added ansible configuration"
```

## Configuration personnelle

Sur cette base, nous ajoutons notre configuration personnelle: des valeurs qui ne doivent pas être partagées
même au travers de git. Pour l'exemple, nous prenons 
les variables sensibles permettant de configurer notre accès aux 
API Scaleway : `SCW_ACCESS_KEY`, `SCW_SECRET_KEY` et `SCW_DEFAULT_ORGANIZATION_ID`.

Tout d'abord nous rajoutons un fichier dans le `.gitignore` afin de ne pas faire d'erreur de manipulation :

```bash session
echo '.env.local' >> .gitignore
```

Ensuite nous pouvons remplir ce fichier avec nos exports de variables :

```bash session
cat >> .env.local <<EOF
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

Une fois modifié le fichier `.envrc`, direnv nécessite que l'on revalide son chargement. Lancer :

```bash session
direnv allow .
git commit -am "Added personal configuration loading"
```

## Ligne d'arrivée

Félicitations, vous venez d'ajouter de la configuration Ansible à votre projet. 
Toutes les configurations communes à tous les intervenants sur le code peuvent être gérées de cette façon.
