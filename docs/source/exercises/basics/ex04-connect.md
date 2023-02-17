# Premier host cible

```{admonition} Objectif
:class: hint

* Créer un répertoire de pilotage pour un host
* Configurer le dépôt local pour gérer la machine avec Ansible
```

## Prérequis

* [](/exercises/prerequisites.md)
* [](ex00-install.md)
* [](ex01-project.md)
* [](ex02-config.md)
* [](ex03-dependencies.md)
* un serveur (autre que celui qui contient le projet) auquel vous connecter en SSH
* les accès de base de connexion au serveur (login et clé privée de connexion)


```{admonition} Nota Bene
:class: note

Pour l'exercice, nous prendrons un host fictif que nous nommerons `ultimate-server`, charge à vous de 
créer un serveur de test.
```

## Configuration SSH

* Créer un répertoire pour les variables dédiées au serveur :

```
mkdir -p inventories/ultimate/host_vars/ultimate-server/secrets
```

* Deposer la clé privée de connexion dans votre répertoire de travail : `inventories/ultimate/host_vars/ultimate-server/secrets/private.key`
* Remplissez un fichier `inventories/ultimate/ssh.cfg` avec les paramètres de connexion au serveur.

```{code-block}
:linenos:
#
# inventories/ultimate/ssh.cfg
#
Host ultimate-server
  Hostname          <IP ADDRESS>
  User              <DEFAULT USER>
  IdentityFile      host_vars/ultimate-server/secrets/private.key

  ControlMaster         auto
  ControlPath           ~/.ssh/mux-%r@%h:%p
  ControlPersist        15m
  ServerAliveInterval   100
  TCPKeepAlive          yes
```

L'essentiel pour savoir si vous avez atteint la fin de cette étape est de valider la connexion en lançant :

```{code-block}
> cd inventories/ultimate
> ssh -F ssh.cfg ultimate-server
```

## Ajout à l'inventaire

Une fois votre connexion SSH validée, ajoutez le label de votre serveur à l'inventaire (le fichier `inventory`) :

```{code-block}
:linenos:
#
# inventories/ultimate/inventory
#
ultimate-server
```

Vérifiez que votre configuration Ansible pointe bien sur cet inventaire :

```
> env | grep ANSIBLE_INVENTORY
ANSIBLE_INVENTORY=inventory
```

Vérifiez que votre configuration Ansible prend en compte votre fichier de configuration SSH :

```
> env | grep ANSIBLE_SSH_ARGS
ANSIBLE_SSH_ARGS=-F ssh.cfg
```

Si ce n'est pas le cas, ajustez votre fichier `.envrc` sans oublier de 
lancer un `direnv allow .` après vos modifications.


## Premier contact

* Lancer la commande :

```
> ansible -m ping ultimate-server
ultimate-server | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

Ce `ping` Ansible permet de valider que vous avez bien une connexion SSH valide 
et qu'il y a au moins une version de Python sur le serveur auquel on se connecte.

## Ligne d'arrivée

Félicitations, vous venez d'effectuer votre premier ping Ansible. Si vous avez bien suivi 
tous les exercices de la section, vous l'avez fait depuis un projet au propre qui plus est. 

Vous avez maintenant un projet de travail sain avec lequel nous allons continuer à jouer.
