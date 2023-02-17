# Molecule & Docker

```{admonition} À savoir
:class: tip

Pour réaliser vos tests de rôles Ansible avec Molecule et Docker, vous allez devoir commettre une hérésie. 

Vous trouverez dans tous les bon tutoriels sur Docker qu'il est contre-nature de faire démarrer un conteneur avec 
systemd ou un autre service manager comme processus principal. C'est ce que vous allez devoir faire si vous testez des 
rôles qui mettent en place des services systèmes (spoiler : c'est le cas 90% du temps).
```

## Prérequis 

* [](ex05-molecule-install.md)
* Avoir un [démon Docker installé](https://docs.docker.com/engine/install/) sur votre machine de travail.
* Que votre [utilisateur de travail ait la permission de gérer Docker](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user) (pour éviter de devoir lancer vos tests en `root`).
* Avoir un role à tester, pour l'exemple nous prendrons un rôle fictif placé dans le répertoire `roles/molecule_docker_demo`.


## Initialisation

Pour démarrer avec Molecule :

* Placez vous à la racine du rôle que vous souhaitez tester :

```bash session
$ pwd 
/home/user/ansible-workspaces/ultimate/training

$ cd roles

$ molecule init role molecule_docker_demo --driver-name docker

$ cd molecule_docker_demo

$ tree -a molecule/
molecule/
└── default
    ├── converge.yml
    ├── molecule.yml
    └── verify.yml

1 directory, 3 files
```

On peut voir que la commande d'init a créé un répertoire `molecule/default/` et plusieurs fichiers :

|                |                                                                                                      |  
| -------------- | ---------------------------------------------------------------------------------------------------- |
| `molecule.yml` | fichier de configuration des environnements de test et des options molecule pour ce scénario.        |
| `converge.yml` | playbook qui sera appliqué aux environnements de test                                                |
| `verify.yml`   | playbook qui sera joué pour vérifier que `converge.yml` a bien effectué les modifications attendues. |

## Configuration

Allez modifier le fichier `molecule/default/molecule.yml` pour qu'il ressemble à ceci :

```yaml
---
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
  name: ansible
```

```{admonition} Approfondir
:class: seealso

* [Spécification complète des options du driver Docker pour Molecule](https://github.com/ansible-community/molecule-docker/blob/main/src/molecule_docker/driver.py)
```

## Construire son conteneur cible

Pour que Molecule prenne en charge la construction du conteneur qui sert de machine cible, créez un template de Dockerfile
au chemin par défaut pour le scénario, `molecule/default/Dockerfile.j2`, avec ce contenu :

```{include} __dockerfile_no_ssh.md

```

Nous construisons **volontairement** un conteneur qui démarre avec `systemd` pour pouvoir tester la mise en place de services
système avec Ansible.

## Coder le comportement du rôle

Nous allons maintenant remplir les tasks de notre rôle de test dans `tasks/main.yml` :

```yaml
---
#
# roles/molecule_docker_demo/tasks/main.yml
#
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

## Coder le playbook de test 

Enfin nous remplissons le fichier `molecule/default/verify.yml` avec des tasks qui devront
valider l'état de notre machine de test :


```yaml
---
- name: Verify
  hosts: all
  gather_facts: false
  tasks:
    - name: Activation de sshd
      service:
        name: sshd
        state: started
        enabled: true
      register: sshd_service_status

    - name: Sshd est actif et démarré
      assert:
        that:
          - sshd_service_status is not changed
```

## Lancement

Depuis le répertoire de notre rôle à tester, lancez la commande :

```bash session
$ pwd 
/home/user/ansible-workspaces/ultimate/training/roles/molecule_docker_demo

$ molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
[...]
Wait for instance(s) deletion to complete ------------------------------- 5.34s
Destroy molecule instance(s) -------------------------------------------- 0.32s
Delete docker networks(s) ----------------------------------------------- 0.02s
INFO     Pruning extra files from scenario ephemeral directory
```

Le workflow complet peut prendre un peu de temps à tourner pour le premier lancement (construction du conteneur oblige). 

Si `molecule test` s'exécute sans erreur, notre test est valide.

## Ligne d'arrivée

Félicitations, vous venez d'effectuer votre premier test de rôle Ansible avec Molecule et le driver Docker. Vous pouvez extrapoler
vos propres suites de tests à partir ce premier exemple basique.
