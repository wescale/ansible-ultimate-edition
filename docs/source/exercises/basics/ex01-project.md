# Créer un projet

```{admonition} Objectif
:class: hint

Création d'un projet Ansible vierge.
```

## Prérequis

* [Préparation](/exercises/prerequisites.md)
* [Installer Ansible](ex00-install.md)

## Création de la structure

Pour disposer de notre installation locale d'Ansible, nous devons nous placer dans le répertoire
contenant le virtualenv géré par `direnv` :

```{code-block}
> cd ~/ansible-workspaces
```

Puis, nous pouvons nous appuyer sur la commande `ansible-galaxy` pour initier la structure de notre projet :

```{code-block}
> ansible-galaxy collection init ultimate.training
- Collection ultimate.training was created successfully
```

----


```{code-block}
> cd ultimate/training
> tree -a
.
├── docs
├── galaxy.yml
├── meta
│   └── runtime.yml
├── plugins
│   └── README.md
├── README.md
└── roles

4 directories, 4 files
```

On peut voir qu'`ansible-galaxy` a créé le minimum. À nous de remplir le reste pour obtenir un espace de 
travail complet.


```{code-block}
> mkdir -p playbooks/group_vars inventories/
> touch playbooks/group_vars/all.yml inventories/.gitkeep roles/.gitkeep docs/.gitkeep
> tree -a
.
├── docs
│   └── .gitkeep
├── galaxy.yml
├── inventories
│   └── .gitkeep
├── meta
│   └── runtime.yml
├── playbooks
│   └── group_vars
│       └── all.yml
├── plugins
│   └── README.md
├── README.md
└── roles
    └── .gitkeep

7 directories, 8 files
```

Nous avons maintenant un premier cadre de travail utile,
nous pouvons l'encadrer par une gestion de version :


```{code-block}
> git init
> git add .
> git commit -m "ultimate init"
```

## Ligne d'arrivée

Félicitations, vous avez créé votre premier cadre de projet Ansible normé. 
Libre à vous de lancer quelques commandes de plus pour venir lier votre dépôt 
local git avec une plateforme centrale comme 
[GitHub](https://docs.github.com/en/get-started/importing-your-projects-to-github/importing-source-code-to-github/adding-locally-hosted-code-to-github) ou [GitLab](https://docs.gitlab.com/ee/gitlab-basics/start-using-git.html#add-a-remote).
