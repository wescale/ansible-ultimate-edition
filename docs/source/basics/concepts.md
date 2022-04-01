# Concepts

Ansible est un logiciel libre (GPLv3) d'automatisation à large spectre. Ansible est notamment très adapté
pour la configuration et la gestion des ordinateurs. Il combine le déploiement de logiciels multi-hosts et multi-os,
l'exécution de tâches _ad hoc_ et la gestion de configuration.

Il interagit avec ces différents hosts à travers SSH (par défaut, de nombreuses options sont disponibles)
et ne nécessite l'installation d'aucun logiciel supplémentaire sur ceux-ci.

Le but principal du projet Ansible est de rester simple d'accès et d'utilisation. Le projet déploie également de gros
efforts sur la sécurité et la fiabilité. Le langage d'expression d'Ansible est notamment pensé pour être auditable
par des humains non formés à Ansible.

## Ansible...

* est codé en Python et distribué comme un package PyPi ;
* exécute des actions décrites en YAML (écrit par ses utilisateurs) ;
* peut exécuter des actions sur un ou plusieurs systèmes distants ;
* repose sur SSH comme mécanique de connexion par défaut ;
* vise à l'[idempotence](https://fr.wikipedia.org/wiki/Idempotence) ;
* s'installe dans l'espace utilisateur ;
* ne nécessite pas l'installation d'agent sur les machines pilotées.

----

## Lexique

### Inventaire

Liste de machines avec lesquelles interagir, organisées en groupes. Un inventaire peut être :

* statique : un fichier au format INI, YAML ou JSON
* dynamique : un retour JSON sur le stdout d'un programme à exécuter par Ansible

**Exemple d'inventaire statique**
```
web_1 ansible_host=10.10.10.101 ansible_ssh_private_key_file=...
web_2 ansible_host=10.10.10.102 ansible_ssh_private_key_file=...

[web_servers]
web_1
web_2

[databases]
db_1 ansible_host=10.10.20.201 ansible_ssh_private_key_file=...
10.10.20.202 ansible_ssh_private_key_file=...

[production:children]
web_servers
databases
```

**Exemple d'inventaire dynamique**
```bash session
$ ./dyn_inventory --list
{ 
  "databases" : { 
    "hosts" : [ "db_1", "10.10.20.202" ]
  }, 

  "web_servers" : [ "web_1", "web_2" ],

  "production" : { 
    "children": [ "web_servers", "databases" ]
  }
}

$ ./dyn_inventory --host web_1
{ 
  "ansible_host": "10.10.10.101" 
}
```

Les inventaires dynamiques peuvent prendre la forme de scripts et donc forger leur réponse en interrogeant des API qui connaissent les machines auxquelles se connecter (AWS, OpenStack, Cobbler, _etc._).

### Module/Task

C'est la plus petite unité d'action disponible. Le résultat de son exécution par Ansible peut être `changed`, `ok` ou `failed`.

**Exemple d'appel au module `apt`**
```
- name: un joli titre c’est mieux
  apt: 
    pkg: "tmux"
    state: present
```

### Handler

Task lancée en fin de play si "notifiée" par une autre task, c'est-à-dire si la task porte un attribut
`notify` avec le `name` du handler et que son résultat d'exécution est `changed`.
Un handler notifié plusieurs fois ne sera exécuté qu’une fois.

**Exemple de handler**
```
---
- hosts: webservers 
  tasks: 
    - template: [...] 
      notify: restart my service 

  handlers:
    - name: restart my service 
      service: 
        name: my_service
        state: restarted
```

### Rôle

Unité de réutilisation de code Ansible. Peut contenir des tasks, des handlers, des templates, des fichiers et des variables.

**Organisation d'un rôle**
```
├── defaults 
│   └── main.yml --> variables par défaut (aisément redéfinissables)
├── files        --> fichiers statiques 
├── handlers 
│   └── main.yml --> handlers 
├── meta 
│   └── main.yml --> fiche d'info et dépendances 
├── tasks 
│   └── main.yml --> tâches (appels de modules) 
├── templates    --> templates Jinja2 
├── tests 
│   ├── inventory 
│   └── test.yml 
└── vars
    └── main.yml --> variables redéfinissables uniquement par option en ligne de commande
```

### Playbook

Liste d'objets Play. Un Play est une liste de rôles et/ou de tasks à appliquer sur un groupe de machines cibles.

**Exemple de fichier playbook contenant 2 plays**

```
---
- hosts: web_servers
  become: yes
  tasks:
    - service: 
        name: sshd
        state: stopped

- hosts: web_servers
  become: yes
  tasks:
    - service: 
        name: sshd
        state: started
```

### Collection

Unité de réutilisation de code Ansible. Peut contenir des rôles, des playbooks et des plugins.

**Organisation d'une collection**
```
├── docs/
├── galaxy.yml
├── meta/
│   └── runtime.yml
├── plugins/
│   ├── modules/
│   │   └── module1.py
│   ├── inventory/
│   └── .../
├── README.md
├── roles/
│   ├── role1/
│   ├── role2/
│   └── .../
├── playbooks/
│   ├── files/
│   ├── vars/
│   ├── templates/
│   └── tasks/
└── tests/
```

------

```{admonition} Approfondir
:class: seealso

* [Documentation Ansible - Accueil](https://docs.ansible.com/ansible/latest/index.html)
* [Documentation Ansible - Rôles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)
* [Documentation Ansible - Collection](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html)
* [Jinja2 Template Designer Documentation](https://jinja.palletsprojects.com/en/3.1.x/templates/)
* [YAML Specification 1.1](https://yaml.org/spec/1.1/)
* [SSH config manpage](https://man7.org/linux/man-pages/man5/ssh_config.5.html)
```
