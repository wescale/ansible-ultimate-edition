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


```{toctree}
:maxdepth: 1

molecule/docker.md
molecule/terraform.md
```

