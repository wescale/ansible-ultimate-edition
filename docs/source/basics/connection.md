# Connexion aux serveurs cibles

## Rappels utiles

La méthode de connexion par defaut d'Ansible est SSH. Par conséquent, si vous arrivez à vous connecter avec un client SSH
quelconque, Ansible DOIT y arriver aussi.

Les paramètres de connexion SSH utilisés par Ansible peuvent être placés à plusieurs endroits, en fonction de la saison et du sens
du vent. Là encore, choisir une convention et s'y tenir vous facilitera la vie.

## Configuration SSH

La méthode la plus efficace pour renseigner les informations de connexion est de construire un fichier de configuration SSH pur.
Le gros avantage de cette approche est de pouvoir tester la connectivité en sortant Ansible de la boucle. Une fois le fichier de configuration SSH mis au carré, il faut configurer Ansible pour qu'il s'appuie exclusivement sur cette configuration SSH.

**Exemple de configuration SSH**
```bash
#
# ssh.cfg
#
Host ultimate-controller
  Hostname 51.15.202.92

Host ultimate-master
  Hostname 192.168.42.1

Host ultimate-minion
  Hostname 192.168.42.11

Host ultimate-master ultimate-minion
  ProxyJump ultimate-controller

Host ultimate-*
  User root
  IdentityFile  group_vars/ultimate_platform/secrets/ultimate.key
  StrictHostKeyChecking no
  ControlMaster   auto
  ControlPath     ~/.ssh/mux-%r@%h:%p
  ControlPersist  15m
  ServerAliveInterval 100
  TCPKeepAlive yes
```

La maîtrise des options de configuration de client SSH vous apportera un grand confort au quotidien. Les options qu'on retrouve dans
l'exemple sont des classiques dans la pratique Ansible.

----

```bash
Host ultimate-controller
  Hostname 51.15.202.92
```

Vous permet de vous connecter via une commande `ssh -F ssh.cfg ultimate-controller`.

----

```bash
Host ultimate-master ultimate-minion
  ProxyJump ultimate-controller
```

Vous permet de rebondir de façon transparente au travers d'une connexion SSH à `ultimate-controller` pour atteindre `ultimate-master` ou `ultimate-minion`, qui peuvent donc être configurés avec des adresses IP sur un réseau privé routable depuis `ultimate-controller`.

----

```bash
Host ultimate-*
  [...]
```
Vous permet de grouper les options par patterns de nommage, pour éviter de créer des fichiers de configuration trop verbeux.

----

```bash
Host ultimate-*
  [...]
  ControlMaster   auto
  ControlPath     ~/.ssh/mux-%r@%h:%p
  ControlPersist  15m
  ServerAliveInterval 100
  TCPKeepAlive yes
```

Renforce les comportements de maintien de connexion de SSH, afin d'éviter à Ansible de relancer une session à chaque task.
Cela améliore grandement les performances globales des playbooks.

----

Si on reprend, les étapes sont donc :

* construire un fichier de configuration SSH (local au projet), nommé par exemple `ssh.cfg`
* s'assurer qu'on peut se connecter aux machines cibles via une commande `ssh -F ssh.cfg le_serveur`
* ajouter la mention `export ANSIBLE_SSH_ARGS="-F ${PWD}/ssh.cfg"` à la configuration Ansible (le désormais fameux fichier `.envrc`)


```{admonition} Approfondir
:class: seealso

* [SSH config manpage](https://man7.org/linux/man-pages/man5/ssh_config.5.html)
```

## Cohérence SSH-Config/Inventaire

Une fois que la connectivité est assurée en SSH pur, il ne nous reste plus qu'à tailler notre inventaire en reprenant
les labels attribués aux hosts dans la configuration SSH.

```bash
#
# ssh.cfg
#
Host ultimate-controller
  Hostname 51.15.202.92

Host ultimate-master
  Hostname 192.168.42.1

Host ultimate-minion
  Hostname 192.168.42.11
[...]
```

On a donc 3 hosts `ultimate-controller`, `ultimate-master` et `ultimate-minion` à répartir dans noter inventaire en taillant les 
groupes qui nous conviennent.

```bash
#
# ansible inventory
#
# Pour l'exemple un groupe de host incluant la totalité de nos cibles
[ultimate_platform:children]
ultimate_master_nodes
ultimate_minions_nodes
ultimate_bastions

# un groupe des noeuds masters avec notre host dedans, tel que nommé dans la conf SSH
[ultimate_master_nodes]
ultimate-master

# un groupe des noeuds minions avec notre host dedans, tel que nommé dans la conf SSH
[ultimate_minion_nodes]
ultimate-minion

# un groupe des noeuds de contrôle avec notre host dedans, tel que nommé dans la conf SSH
[ultimate_bastions]
ultimate-controller
```

## Validation de la connectivité

Pour valider la connectivité avec les hosts de notre inventaire, il suffit de lancer une commande :

```bash session
$ ansible -m ping all
ultimate-controller | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
ultimate-master | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
ultimate-minion | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

Si par hasard, au fil du projet, Ansible présente une erreur de connexion, commencez directement votre troubleshooting au niveau configuration SSH par un :


```bash session
$ ssh -F ssh.cfg ultimate-master
```

```{admonition} Mise en pratique
:class: important

[](/exercises/basics/ex04-connect.md)
```

