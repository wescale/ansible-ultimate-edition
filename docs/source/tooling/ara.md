# ARA

Ara est un callback module qui enregistre toute la sortie d'Ansible. Cela en fait un outil assez pratique 
pour investiguer et conserver une traçabilité des exécutions de vos playbooks.

Pour cela vous avez à votre disposition une interface en ligne de commande et une interface web.



## Installation 

Pour installer Ara rien de plus simple ! Clonez ce projet GIT : https://github.com/gloterman/ansible-ara-quickstart 
ou suivez le guide de départ de la documentation officielle : https://ara.readthedocs.io/en/latest/getting-started.html

Une fois Ara activé, et votre premier playbook exécuté, toutes les informations seront stockées dans une 
base Sqlite (par défaut). Voici quelques commandes pour afficher ces informations :


```bash session
# lister les playbooks
$ ara playbook list

# Voir le détail du playbook dont l'id est 1 
$ ara playbook show 1

# Voir les métriques des playbooks
$ ara playbook metrics

# Voir la list des tasks
$ ara task list

# Voir le détail d'une task
$ ara task show 1
 ```

Pour démarrer l'interface web : 

```bash

$ ara-manage runserver
```

```{admonition} Approfondir
:class: seealso

* [Documentation Ara - CLI](https://ara.readthedocs.io/en/latest/cli.html#ara)
```

## Démo

Une instance de démonstration est disponible à cette adresse : [https://demo.recordsansible.org](https://demo.recordsansible.org)

## Pour aller plus loin

Félicitations ! Vous avez Ara qui est configuré pour enregistrer votre utilisation d'Anible. 
Cependant ce n'est pas suffisant en situation de production.

On préfèrera utiliser Ara en mode "api server", où toutes les données stockées resteront sur un serveur prévue à cet effet.

Pour l'exemple : 

```bash
# Create a directory for a volume to store settings and a sqlite database
$ mkdir -p ~/.ara/server

# or with docker from the image on quay.io:
$ docker run --name api-server --detach --tty \
    --volume ~/.ara/server:/opt/ara:z -p 8000:8000 \
    quay.io/recordsansible/ara-api:latest
```

Cette fois ci, on va configurer Ara pour contacter l'API server. Éditez le fichier d'environnment et ajoutez ceci:

```bash
# fichier .envrc
export ARA_API_CLIENT="http"
export ARA_API_SERVER="http://127.0.0.1:8000"
```

----



```{admonition} Approfondir
:class: seealso

* [Documentation Ara](https://ara.readthedocs.io/en/latest/getting-started.html)
* [Documentation Ara - Github](https://github.com/ansible-community/ara)
* [Démonstration Ara interface web](https://demo.recordsansible.org)
```

