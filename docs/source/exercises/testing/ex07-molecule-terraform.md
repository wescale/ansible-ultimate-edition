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

## Intégration Molecule

## Code des tests

## Ligne d'arrivée

