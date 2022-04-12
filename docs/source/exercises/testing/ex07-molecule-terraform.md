# Molecule & Terraform

Nous allons voir ici comment utiliser le driver `delegated` de Molecule en faisant une implémentation basée sur Terraform.

Pour diminuer la phase de prérequis, l'exemple s'appuie également sur Docker, plutôt que sur un Cloud Provider.

## Prérequis 

* Avoir effectué l'[](ex05-molecule-install.md)
* Avoir un [démon Docker installé](https://docs.docker.com/engine/install/) sur votre machine de travail.
* Que votre [utilisateur de travail ait la permission de gérer Docker](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user) (pour éviter de devoir lancer vos tests en `root`).
* Avoir un role à tester, pour l'exemple nous prendrons un rôle fictif placé dans le répertoire `roles/a_tester`.
* Avoir installé Terraform (voir la [documentation officielle](https://www.terraform.io/downloads) ou la [proposition Ultimate](/howtos/terraform_install.md)).


## Initialisation

Pour démarrer avec Molecule :

* Placez vous à la racine du rôle que vous souhaitez tester :

```bash session
$ pwd 
/home/user/ansible-workspaces/ultimate/training

$ cd roles/a_tester

$ molecule init scenario --driver-name=delegated default
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/user/ansible-workspaces/ultimate/training/roles/a_tester/molecule/default successfully.

$ tree -a molecule/
molecule/
└── default
    ├── converge.yml
    ├── create.yml
    ├── destroy.yml
    ├── INSTALL.rst
    ├── molecule.yml
    └── verify.yml

1 directory, 6 files
```

On peut voir que la commande d'init a créé un répertoire `molecule/default/` et plusieurs fichiers :

|                |                                                                                                      |  
| -------------- | ---------------------------------------------------------------------------------------------------- |
| `molecule.yml` | fichier de configuration des environnements de test et des options molecule pour ce scénario.        |
| `converge.yml` | playbook qui sera appliqué au environnements de test                                                 |
| `verify.yml`   | playbook qui sera joué pour vérifier que `converge.yml` a bien effectué les modifications attendues. |
| `create.yml`   | playbook qui sera lancé pour la création des environnements de test                                  |
| `destroy.yml`  | playbook qui sera lancé pour la destruction des environnements de test                               |

## Terraforming

Nous allons maintenant ajouter le Terraform nécessaire pour simuler un serveur acessible en SSH avec un conteneur Docker local. Il s'agit de techniques dédiées 
aux tests, à proscrire dans des contexte de déploiements qu'ils soient.

Créez un répertoire pour hébergé le code Terraform :

```bash session
$ pwd 
/home/user/ansible-workspaces/ultimate/training/roles/a_tester

$ mkdir -p molecule/default/terraform
```

Créez et remplissez les fichiers suivants (les chemins attendus sont en en-tête de chaque bloc) :

* Un Dockerfile pour notre instance de serveur.

```bash
#
# roles/a_tester/molecule/default/terraform/Dockerfile
# 
ARG DEBIAN_TAG=11-slim
FROM debian:$DEBIAN_TAG
ARG DEBIAN_FRONTEND=noninteractive
ARG ROOT_PUBLIC_KEY=to-be-defined
RUN set -eux; \
  apt-get update && apt-get upgrade && apt-get dist-upgrade; \
  apt-get install --no-install-recommends -y apt-utils \
  curl ca-certificates sudo \
  python python3 python3-apt locales \
  systemd systemd-sysv libpam-systemd dbus dbus-user-session openssh-server; \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8; \
  localedef -i fr_FR -c -f UTF-8 -A /usr/share/locale/locale.alias fr_FR.UTF-8
ENV LANG fr_FR.utf8
RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
  /etc/systemd/system/*.wants/* \
  /lib/systemd/system/local-fs.target.wants/* \
  /lib/systemd/system/sockets.target.wants/*udev* \
  /lib/systemd/system/sockets.target.wants/*initctl* \
  /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
  /lib/systemd/system/systemd-update-utmp*; \
  mkdir -p /var/run/sshd /root/.ssh
RUN systemctl enable ssh
RUN echo $ROOT_PUBLIC_KEY > /root/.ssh/authorized_keys
EXPOSE 22
ENTRYPOINT ["/lib/systemd/systemd"]
```

* Le strict minimum de code Terraform pour construire le conteneur, le lancer et récupérer les informations de connexion.

```hcl
#
# roles/a_tester/molecule/default/terraform/main.tf
# 
terraform {
  required_providers {
    docker = { source = "kreuzwerker/docker", version = "2.16.0" }
    tls    = { source = "hashicorp/tls", version = "3.3.0" }
  }
}

locals {
  base_name          = "molecule"
  container_name     = "${terraform.workspace}"
  root_key_algorithm = "ED25519"
  identity_file      = "${abspath(path.module)}/${terraform.workspace}.key"
}

resource "tls_private_key" "root" {
  algorithm = local.root_key_algorithm
}

resource "docker_image" "fake_server" {
  name = local.base_name
  build {
    path      = "."
    tag       = ["${local.base_name}:${local.container_name}"]
    build_arg = { ROOT_PUBLIC_KEY : tls_private_key.root.public_key_openssh }
  }
}

resource "null_resource" "private_key" {
  provisioner "local-exec" {
    command = "cat > ${local.identity_file} <<EOF\n${tls_private_key.root.private_key_openssh}\nEOF"
  }
  provisioner "local-exec" {
    command = "chmod 600 ${local.identity_file}"
  }
}

resource "docker_container" "fake_server" {
  name       = local.container_name
  image      = docker_image.fake_server.latest
  privileged = true
}

output "address" { value = docker_container.fake_server.ip_address }
output "user" { value = "root" }
output "identity_file" { value = local.identity_file }
output "instance" { value = terraform.workspace }
output "port" { value = 22 }
```

## Intégration Molecule

Maintenant que nous avons de quoi démarrer un serveur local accessible en SSH, il faut l'intégrer dans le cycle de gestion de Molecule.

* Remplacez le contenu du fichier `roles/a_tester/molecule/default/create.yml` par :

```yaml
---
- name: Create
  hosts: localhost
  connection: local
  gather_facts: false
  no_log: "{{ molecule_no_log }}"
  tasks:

    - name: Create the test environment
      terraform:
        project_path: "{{ playbook_dir }}/terraform"
        force_init: true
        workspace: "{{ item.name }}"
        state: present
      register: server
      loop: "{{ molecule_yml.platforms }}"

    - when: server.changed | default(false) | bool
      block:
        - name: Populate instance config dict
          set_fact:
            instance_conf_dict:
              instance: "{{ item.outputs.instance.value }}"
              address: "{{ item.outputs.address.value }}"
              user: "{{ item.outputs.user.value }}"
              port: "{{ item.outputs.port.value }}"
              identity_file: "{{ item.outputs.identity_file.value }}"
          with_items: "{{ server.results }}"
          register: instance_config_dict

        - debug:
            var: instance_conf_dict
        - name: Convert instance config dict to a list
          set_fact:
            instance_conf: "{{ instance_config_dict.results | map(attribute='ansible_facts.instance_conf_dict') | list }}"

        - name: Dump instance config
          copy:
            content: |
              # Molecule managed

              {{ instance_conf | to_json | from_json | to_yaml }}
            dest: "{{ molecule_instance_config }}"
            mode: 0600
```

* Remplacez le contenu du fichier `roles/a_tester/molecule/default/destroy.yml` par :

```yaml
---
- name: Destroy
  hosts: localhost
  connection: local
  gather_facts: false
  no_log: "{{ molecule_no_log }}"
  tasks:
    - name: Destroy the test environment
      terraform:
        project_path: "{{ playbook_dir }}/terraform"
        force_init: true
        workspace: "{{ item.name }}"
        state: absent
      register: server
      loop: "{{ molecule_yml.platforms }}"
 
    - name: Populate instance config
      set_fact:
        instance_conf: {}

    - name: Dump instance config
      copy:
        content: |
          # Molecule managed

          {{ instance_conf | to_json | from_json | to_yaml }}
        dest: "{{ molecule_instance_config }}"
        mode: 0600
      when: server.changed | default(false) | bool
```

## Code du rôle

* Afin d'avoir quelque chose à tester, remplissez le fichier de tasks du rôles :

```yaml
---
#
# roles/a_tester/tasks/main.yml
#
- name: Installation de nginx
  apt:
    name: nginx
    update_cache: yes

- name: Activation de nginx
  service:
    name: nginx
    state: started
    enabled: true
```

## Code des tests

* Enfin, remplissez le fichier de vérification molecule :

```yaml
---
- name: Verify
  hosts: all
  gather_facts: false
  tasks:
  - name: Installation de nginx
    apt:
      name: nginx
    register: nginx_install

  - name: Activation de nginx
    service:
      name: nginx
      state: started
      enabled: true
    register: nginx_enable

  - assert:
      that:
        - nginx_install is not changed
        - nginx_enable is not changed
```

## Test complet

Tout est en place, vous pouvez maintenant lancer un test bout en bout avec les commandes suivantes :

```bash session
$ pwd
/home/user/ansible-workspaces/ultimate/training/roles/a_tester

$ molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/user/.cache/ansible-compat/9c82a6/modules:/home/user/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATHS=/home/user/.cache/ansible-compat/9c82a6/collections:/home/user/ansible-workspaces/ultimate/training/.direnv:/home/user/ansible-workspaces/ultimate/training/.direnv
INFO     Set ANSIBLE_ROLES_PATH=/home/user/.cache/ansible-compat/9c82a6/roles:/home/user/ansible-workspaces/ultimate/training/roles/a_tester/roles:roles
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > Destroy
[...]
===============================================================================
Destroy the test environment -------------------------------------------- 2.74s
Dump instance config ---------------------------------------------------- 0.34s
Populate instance config ------------------------------------------------ 0.02s
INFO     Pruning extra files from scenario ephemeral directory
```

## Ligne d'arrivée

Vous avez maintenant un workflow complet de Molecule qui intègre Terraform comme implémentation du driver `delegated`. Libre à vous 
d'adapter le code Terraform pour pouvoir lancer vos tests Molecule directement sur AWS, GCP ou tout autre founisseur d'infrastructure.
