# Workspaces

```{admonition} Perle de sagesse
L'erreur est humaine. Répéter l'erreur sur 50 serveurs d'un coup est DevOps.

_@DEVOPS_BORAT_, Twitter, traduction libre.
```

Plus nous poussons l'automatisation, plus il est crucial de se forcer à donner un périmètre à nos lancements de procédures automatisées.
Personne n'a envie de laisser une infrastructure de production se détruire en profondeur via un playbook, tout en allant prendre 
un café... L'excès de confiance crée des pannes.

Les conventions, de code ou de conduite, peuvent être facilement oubliées dans un instant d'égarement. Par conséquent il est plus 
prudent de se poser des pièges à soi-même (et à son équipe) pour empêcher certains comportements à risque.

C'est là que le concept de **Workspace** entre en scène. L'idée de Workspace Ansible consiste à se **forcer** à définir intentionnellement le périmètre d'impact de nos playbooks. On offre ainsi à notre cerveau une chance de reconnaître une erreur au moment où l'on agit.


## Inventaires multiples

Si vous ne définissez PAS d'inventaire par défaut (clé de configuration `ANSIBLE_INVENTORY`), et que vous maintenez un inventaire statique par environnement, vous serez forcé de fournir une option d'inventaire au lancement de tout playbook :

```bash session
$ ansible-playbook playbooks/danger_zone.yml -i inventories/dev_env.inventory
```

## Variable des les patterns de sélection

Vous avez la possibilité d'intégrer des variables dans votre sélection de hosts au sein d'un playbook.

```yaml
---
- name: Exemple de pattern variabilisé
  hosts: "{{ env_name }}_webservers"
  tasks:
    [...]
```

Dans le flot d'exécution d'Ansible, le playbook est évalué bien avant le chargement des variables. Par conséquent si vous définissez `env_name` dans un fichier de variables de groupe ou de host, vous aurez tout de même une erreur disant qu'elle n'a pas de valeur.

Vous serez obligé de fournir la valeur de `env_name` via une option de ligne de commande, comme ceci :

```bash session
$ ansible-playbook playbooks/danger_zone.yml -e env_name=production
```

De cette façon, la variable sera disponible pour le playbook au bon moment et le playbook s'appliquera sur le groupe `production_webservers` (selon notre exemple).


