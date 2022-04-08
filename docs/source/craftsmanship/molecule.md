# Molecule

Molecule est un outil dédié aux tests de rôles Ansible. Molecule permet de tester aussi bien avec des containers qu'avec de 
l'infrastructure éphémère. Il apporte un workflow pour :

* définir et gérer les cycles de vie des environnements de test
* appliquer des playbooks de setup/teardown
* appliquer des rôles Ansible 
* lancer des suites de tests de validation avec plusieurs frameworks 

Les environnements de tests peuvent être provisionnés avec à peu près n'importe quelle solution du moment qu'elle est pilotable 
par Ansible. Pour les technologies les plus courues (Docker, Podman, etc.), des intégrations existent. 
Il reste toujours possible de coder ses propres implémentation du workflow en playbook Ansible pour intégrer n'importe quel outil.


```{admonition} Mise en pratique
:class: important

* [](/exercises/testing/ex06-molecule-docker.md)
* [](/exercises/testing/ex07-molecule-terraform.md)
```

## Cycle de vie

Le workflow d'un scenario de test Molecule comprend les étapes suivantes :

* `lint` : Analyse statique du code.
* `destroy` : Destruction des éventuels environnements de tests encore existants.
* `dependency` :Rapatriement des dépendances nécessaires listées dans le fichier `meta.yml`.
* `syntax` : Validation de syntaxe avec Ansible.
* `create` : Creation de l'environnement de test du scénario.
* `prepare` : Application d'un playbook sur l'environnement de test pour préparer l'application du rôle en cours de test.
* `converge` : Application du rôle testé, doit s'exécuter sans erreur.
* `idempotence` : Seconde application du rôle testé, qui ne doit généré aucune `task` en état `changed`.
* `side_effect` : Partie obscure et mal documentée du framework, cette phase doit permettre d'introduire des effets de bords à l'environnement (modification contextuelle au rôle, simulation de pannes).
* `verify` : Application du code de test (playbooks, TestInfra, etc.)
* `destroy` : Destruction des environnements de test.


