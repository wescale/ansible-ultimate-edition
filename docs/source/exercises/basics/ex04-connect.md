# Premier host cible

```{admonition} Objectif
:class: hint

Ajouter un host à l'inventaire et configurer le projet pour pouvoir s'y connecter avec Ansible.
```

## Prérequis

Pour que tout se passe comme prévu, vous aurez besoin que soient installés sur votre machine de travail:

* [Les exercices 00 à 03](__index.md)

Il vous faudra en supplément :

* un serveur auquel vous connecter en SSH

Malheureusement il est complexe de vous en fournir un pour les exercices. Pour l'exercice, nous prendrons un host
fictif, à vous de vous entraîner sur un serveur de test.

## Configuration SSH

Remplissez un fichier `ssh.cfg` en choisissant un label pour le serveur puis en renseignant les paramètres de connexion.

Un exemple pourrait ressembler à ceci :

```bash
#
# ssh.cfg
#
Host ultimate-server
  Hostname 51.15.202.92
  User root
  IdentityFile  group_vars/ultimate_platform/secrets/ultimate.key
  ControlMaster   auto
  ControlPath     ~/.ssh/mux-%r@%h:%p
  ControlPersist  15m
  ServerAliveInterval 100
  TCPKeepAlive yes
```

L'essentiel pour savoir si vous avez atteint la fin de cette étape est de valider la connexion en lançant :

```bash session
$ ssh -F ssh.cfg ultimate-server
```

## Ajout à l'inventaire

Une fois votre connexion SSH validée, ajoutez le label de votre serveur à l'inventaire (le fichier `inventory`) :

```bash
ultimate-server
```

Vérifiez que votre configuration Ansible pointe bien sur cet inventaire :

```bash session
$ env | grep ANSIBLE_INVENTORY
ANSIBLE_INVENTORY=inventory
```

Vérifiez que votre configuration Ansible prend en compte votre fichier de configuration SSH :

```bash session
$ env | grep ANSIBLE_SSH_ARGS
ANSIBLE_SSH_ARGS=-F ssh.cfg
```

Si ce n'est pas le cas, ajustez votre fichier `.envrc` sans oublier de lancer un `direnv allow .` après vos modifications.


## Premier contact

Lancez la commande :

```bash session
$ ansible -m ping ultimate-server
ultimate-server | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

Ce `ping` Ansible permet de valider que vous avez bien une connexion SSH valide et qu'il y a au moins une version de Python
sur le serveur auquel on se connecte.


## Ligne d'arrivée

Félicitations, vous venez d'effectuer votre premier ping Ansible. Si vous avez bien suivi tous les exercices de la section, vous
l'avez fait depuis un projet au propre qui plus est. Vous avez maintenant un projet de travail sain avec lequel 
nous allons continuer à jouer.
