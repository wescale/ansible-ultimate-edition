# Ex01 - Créer un projet

```{admonition} Objectif
:class: hint

Création d'un projet Ansible vierge.
```

## Prérequis

Pour que tout se passe comme prévu, vous aurez besoin que soient installés sur votre machine de travail :

* [le premier exercice](ex00-install.md) ;
* git.

Pour notre cas de référence (Debian Bullseye), atteindre ces prérequis passe par le lancement des commandes suivantes :

```shell session
$ sudo apt update 
$ sudo apt install git -y
```

## Création de la structure

Pour disposer de notre installation locale d'Ansible, nous devons nous placer dans le répertoire
contenant le virtualenv géré par `direnv` :

```bash session
$ cd ~/ansible-workspaces
```

Puis, nous pouvons nous appuyer sur la commande `ansible-galaxy` pour initier la structure de notre projet :

```bash session
$ ansible-galaxy collection init ultimate.training
- Collection ultimate.training was created successfully

$ cd ultimate/training

$ tree
.
├── docs
├── galaxy.yml
├── plugins
│   └── README.md
├── README.md
└── roles

3 directories, 3 files
```

On peut voir qu'`ansible-galaxy` a créé le minimum. À nous de remplir le reste pour obtenir un espace de travail complet.


```bash session
$ mkdir -p playbooks/group_vars group_vars host_vars
mkdir: création du répertoire 'playbooks'
mkdir: création du répertoire 'playbooks/group_vars'
mkdir: création du répertoire 'group_vars'
mkdir: création du répertoire 'host_vars'

$ touch playbooks/group_vars/all.yml group_vars/all.yml host_vars/.gitkeep roles/.gitkeep docs/.gitkeep inventory

$ tree -a
.
├── docs
├── galaxy.yml
├── group_vars
│   └── all.yml
├── host_vars
│   └── .gitkeep
├── inventory
├── playbooks
│   └── group_vars
│       └── all.yml
├── plugins
│   └── README.md
├── README.md
└── roles

7 directories, 7 files
```

Nous avons maintenant un cadre de travail qui correspond à nos attentes, nous pouvons l'encadrer par une gestion
de version :


```bash session
$ pwd
/home/user/ansible-workspaces/ultimate/training

$ git init
Dépôt Git vide initialisé dans /home/user/ansible-workspaces/ultimate/training/.git/

$ git add .
$ git commit -am "ultimate init"
[main (commit racine) df65334] ultimate init
 7 files changed, 96 insertions(+)
 create mode 100644 README.md
 create mode 100644 galaxy.yml
 create mode 100644 group_vars/all.yml
 create mode 100644 host_vars/.gitkeep
 create mode 100644 inventory
 create mode 100644 playbooks/group_vars/all.yml
 create mode 100644 plugins/README.md
```

## Ligne d'arrivée

Félicitations, vous avez créé votre premier projet Ansible normé. Libre à vous de lancer quelques commandes de plus 
pour venir lier votre dépôt local git avec une plateforme centrale comme [GitHub](https://docs.github.com/en/get-started/importing-your-projects-to-github/importing-source-code-to-github/adding-locally-hosted-code-to-github) ou [GitLab](https://docs.gitlab.com/ee/gitlab-basics/start-using-git.html#add-a-remote).
