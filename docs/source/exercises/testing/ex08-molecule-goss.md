# Goss Verifier

## Prérequis 

* Avoir effectué l'[](ex05-molecule-install.md)
* Avoir un [démon Docker installé](https://docs.docker.com/engine/install/) sur votre machine de travail.
* Que votre [utilisateur de travail ait la permission de gérer Docker](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user) (pour éviter de devoir lancer vos tests en `root`).

## Initialisation

* Créez un rôle pour notre exercice

```bash session
$ pwd
/home/user/ansible-workspaces/ultimate-training

$ cd roles

$ molecule init role molecule_goss_demo --driver-name docker --verifier-name goss

$ cd molecule_goss_demo
```

* Créez un fichier `molecule/default/Dockerfile.j2` pour service de modèle à notre host de test :

```{include} __dockerfile_no_ssh.md

```

* Modifiez le fichier `molecule/default/molecule.yml` comme ceci :

```yaml
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  - name: debian
    image: "ultimate:11"
    pre_build_image: false
    pull: false
    privileged: true
provisioner:
  name: ansible
verifier:
  name: goss
```

À ce stade nous pouvons déjà lancer un `molecule test` qui s'appuie sur notre Dockerfile. Cependant nous testerions un rôle vide, 
donc peu de gloire.

## Code du rôle

* Modifiez le fichier `tasks/main.yml` pour que notre rôle installe et active le démon SSH :

```yaml
---
- name: Installation de sshd
  apt:
    name: openssh-server
    update_cache: yes

- name: Activation de sshd
  service:
    name: sshd
    state: started
    enabled: true
```

## Code des tests

* Modifiez l'état attendu par goss en éditant le fichier `molecule/default/tests/test_default.yml` :

```yaml
---
port:
  tcp:22:
    listening: true
    ip:
    - 0.0.0.0
service:
  sshd:
    enabled: true
    running: true
process:
  sshd:
    running: true
```

## Lancement

Tout est prêt vous pouvez maintenant lancer les tests :

```bash session
$ pwd 
/home/user/ansible-workspaces/ultimate-training/roles/molecule_goss_demo

$ molecule test
[...]
```

## Ligne d'arrivée

Vous avez là la combinaison la plus confortable pour tester des rôles Ansible au moment de la rédaction.
