# Packer

Hashicorp Packer est un outil qui vous permet de créer des images de machines identiques pour différentes plateformes, à partir d'un modèle unique.

Packer permet d'adopter le principe de "golden image", c'est-à-dire où l'on va construire une image avec des composants testés et validés pour la mise en production. Cette image sera la source pour déployer toutes les machines virtuelles ou installer un ensemble de serveurs physiques.

La force de Packer réside dans le fait qu'il est relativement simple à utiliser et propose de nombreuses extensions (dont un provisionner Ansible).

```{admonition} Approfondir
:class: seealso

* [Documentation Packer](https://www.packer.io/docs)
* [Documentation Packer - Installation](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)
```

## Provisioner 

Un provisioner utilise des logiciels intégrés et tiers pour installer et configurer l'image de la machine après le démarrage. Un provisionner prépare le système pour l'utilisation, avec par exemple :

* installation de paquets
* compilation de modules du kernel
* création d'utilisateurs
* récupération de code source ou exécutables

### Provisioner Ansible

Le provisioner Ansible utilise le mode push (le mode de fonctionnement natif) pour exécuter des playbooks Ansible.
Le mode de fonctionnement implique que le code Ansible doit être sur votre machine de travail ou sur la machine de contrôle. Des connexions SSH seront alors établies vers les machines cibles via SSH afin de recueillir et appliquer les changements.

Ce provisionner est très utile dans le cas où vous devez construire des images système pour vos instances de machines virtuelles. 

Prenons l'exemple de la création d'une image ISO pour une machine virtuelle compatible Virtualbox :

On crée le fichier ansible-remote.json :

```json
{
  "builders": [
    {
      "type": "docker",
      "image": "stelar/debian:11-systemd",
      "export_path": "image-builded-by-packer.tar",
      "run_command": ["-d", "-i", "-t", "--entrypoint=/bin/bash", "{{.Image}}"]
    }
  ],
  "provisioners": [
    {
      "type": "ansible",
      "playbook_file": "./playbook.yml"
     }
  ]
}
```

On crée le playbook :

```yaml
---
# playbook.yml
- name: 'Provision Image'
  hosts: default
  become: true

  tasks:
    - name: install Apache
      package:
        name: 'apache2'
        state: present
```

On valide que la configuration de Packer est correcte :

```sh
$ packer validate virtualbox-iso.json
The configuration is valid.
```

On lance la création de l'image Docker :

```sh
packer build ansible-remote.json
```

Packer va utiliser les APIs de Docker afin de créer une image.

Le résultat de ce build sera une image Docker Debian 11 avec Apache installé, exporté dans le fichier `image-builded-by-packer.tar`.


### Provisioner Ansible Local

Le provisioner Ansible Local utilise le mode push. A l'inverse du mode pull, ce sont directement les machines cibles qui exécutent le code Ansible et appliquent les changements en local, sans passer par une connexion SSH. 

Cela implique qu'Ansible soit pré-installé sur les machines cibles.

```json
{
  "builders": [
    {
      "type": "docker",
      "image": "williamyeh/ansible:ubuntu18.04",
      "export_path": "packer_ansible_ultimate",
      "run_command": ["-d", "-i", "-t", "--entrypoint=/bin/bash", "{{.Image}}"]
    }
  ],
  "variables": {
    "topping": "mushroom"
  },
  "provisioners": [
    {
      "type": "ansible-local",
      "playbook_file": "./playbook.yml",
      "extra_arguments": [
        "--extra-vars",
        "\"pizza_toppings={{ user `topping`}}\""
      ]
    }
  ]
}
```

On valide que la configuration de Packer est correcte :

```sh
$ packer ansible-local.json
The configuration is valid.
```

On lance la création de l'image Docker :

```sh
packer build ansible-local.json
```

Packer va utiliser les APIs de Docker afin de créer une image.

Le résultat de ce build sera une image Docker Debian 11 avec l'affichage d'un message "mushroom", 
exporté dans le fichier `image-builded-by-packer.tar`

```{admonition} Approfondir
:class: seealso

* [Documentation Packer - Plugins ](https://www.packer.io/plugins)
* [Documentation Packer - Provisionner](https://www.packer.io/docs/provisioners)
* [Documentation Packer - Provisionner Ansible ](https://www.packer.io/plugins/provisioners/ansible/ansible)
* [Documentation Packer - Provisionner Ansible Local ](https://www.packer.io/plugins/provisioners/ansible/ansible-local)
```
