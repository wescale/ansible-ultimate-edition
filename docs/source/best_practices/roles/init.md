# Initialisation

## Squelette standard

Partant du principe que vous avez suivi les recommandations du chapitre sur [](/basics/__index.md), pour créer un rôle 
vide, lancez :

```bash session
$ pwd
/home/user/ansible-workspaces/ultimate/training

$ ansible-galaxy role init a_tester --init-path=roles
- Role a_tester was created successfully

$ tree -a roles/a_tester/
roles/a_tester/
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── README.md
├── tasks
│   └── main.yml
├── templates
├── tests
│   ├── inventory
│   └── test.yml
├── .travis.yml
└── vars
    └── main.yml

8 directories, 9 files
```

## Squelette sur mesure

Le squelette de base de la commande `ansible-galaxy` n'est pas forcément adapté à vos usages. Aucun directive claire 
n'est fournie dans la documentation officielle pour l'utilisation du contenu du répertoire `tests/` et tout le monde ne base pas sa CI sur Travis...


