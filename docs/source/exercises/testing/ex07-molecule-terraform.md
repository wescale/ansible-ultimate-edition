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
Créez et emplissez les fichiers suivants (les chemins attendus sont en en-tête de chaque bloc) :

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

```hcl
#
# roles/a_tester/molecule/default/terraform/main.tf
# 
# Chargement des providers nécessaires
terraform {
  required_providers {
    docker = { source = "kreuzwerker/docker", version = "2.16.0" }
    tls    = { source = "hashicorp/tls", version = "3.3.0" }
  }
}

locals {
  base_name          = "ultimate"
  container_name     = "fake-server"
  root_key_algorithm = "ED25519"
}

# Génération de clé pour notre serveur
resource "tls_private_key" "root" {
  algorithm = local.root_key_algorithm
}

# Construction du conteneur de fake-server local
resource "docker_image" "fake_server" {
  name = local.base_name
  build {
    path      = "."
    tag       = ["${local.base_name}:${local.container_name}"]
    build_arg = { ROOT_PUBLIC_KEY : tls_private_key.root.public_key_openssh }
  }
}

# Lancement du conteneur
resource "docker_container" "fake_server" {
  name       = local.container_name
  image      = docker_image.fake_server.latest
  privileged = true
}

output "ipv4" {
  value = docker_container.fake_server.ip_address
}

output "root_private_key" {
  value     = tls_private_key.root.private_key_openssh
  sensitive = true
}
```

## Intégration Molecule

## Code des tests

## Ligne d'arrivée

