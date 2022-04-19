# AWX

AWX permet de gérer l'execution de vos playbooks de façon avancée. En effet il est possible de plannifier leur exécution dans le temps, ainsi que de centraliser la gestion des inventaires.

En plus de son interface graphique, AWX propose une API ! Et c'est là que ça deviens intéressant. Cela vous permet d'intégrer des projets entiers à n'importe quelle application ou sein de votre SI.

AWX gère tout le nécessaire à l'exécution et la gestion de vos rôles, collections ou playbooks Ansible : clés SSH, identités externes, synchronisation projets GIT, configuration des modules Ansible, etc. 


```{admonition} Approfondir
:class: seealso

* [Introduction AWX - Blog Wescale](https://blog.wescale.fr/awx-lansible-tower-open-source-part-1/)
* [Utilisation AWX - Blog Wescale](https://blog.wescale.fr/awx-lansible-tower-open-source-partie-2/)
```


## Installation 

```bash
git clone -b 20.1.0 https://github.com/ansible/awx.git
cd awx
````

On construit l'image docker :
```bash
make docker-compose-build
```

On démarre les conteneurs AWX, Postgres et Redis :

```bash
make docker-compose
```

Attendez que les processus d'initialisation se terminent, notamment les migrations de l'ORM d'AWX(Django)

Pour suivre l'initialisation :

```bash
docker-compose -f tools/docker-compose/_sources/docker-compose.yml logs -f
```

On construit la web ui :

```bash
docker exec tools_awx_1 make clean-ui ui-devel
````

On créer un utilisateur administrateur :

```bash
docker exec -ti tools_awx_1 awx-manage createsuperuser
````

Chargeons les données example de démonstration 

```bash
docker exec tools_awx_1 awx-manage create_preload_data
```

L'interface web est disponible à cette adresse : 
https://localhost:8043/#/home

L'API est disponible à cette adresse : [https://localhost:8043/api/v2](https://localhost:8043/api/v2)



```{admonition} Approfondir
:class: seealso

* [Documentation AWX - Installation via docker-compose](https://github.com/ansible/awx/blob/devel/tools/docker-compose/README.md)
* [Pour aller plus loin - Intégration avec ARA](https://ara.recordsansible.org/blog/recording-ansible-playbooks-from-awx-with-ara/)
```


## La CLI 

Le client en ligne de commande officiel s'installe très simplement d'un coup de Pip :

```bash
pip install awxkit
# On vérifie que le client est bien installé :
awx --help
```

On récupère le token de connexion :
```bash
awx login --conf.host https://localhost:8043 --conf.insecure --conf.username <votre_username> --conf.password <votre_password>
```
Récupérez le token, et allons configurer quelques variables d'environnement pour l'exercice :

```bash
export CONTROLLER_OAUTH_TOKEN=<votre_token>
export CONTROLLER_HOST=https://localhost:8043
export CONTROLLER_VERIFY_SSL=false
$(CONTROLLER_USERNAME=alice CONTROLLER_PASSWORD=secret awx login -f human)
```

Votre client AWX est prêt à l'emploi ! 
Cependant ce n'est une configuration à utiliser sur des environnements réels, ici nous vous proposons la configuration la plus rapide à mettre en oeuvre pour tester et apprendre. Nous irons plus loin, dans un prochain chapitre, où nous parlerons de l'intégration SSO et plus globalement comment mettre en place un serveur AWX de façon sécurisé prêt pour la production.


Quelques commandes pour la route :

```bash
# Lister les rôles AWX
awx roles list

# Lister les jobs, filtrer sur le nom 'Example Job Template'
awx jobs list --all --name 'Example Job Template' \
    -f human --filter 'name,created,status'

# Lister les instances AWX
awx instance list

# Lister les projets AWX
awx project list

# Lister les métriques exposées
awx metrics

# Lister un inventaire
awx inventory get 1
```

Création et lancement d'un job template :

```bash
awx projects create --wait \
    --organization 1 --name='Example Project' \
    --scm_type git --scm_url 'https://github.com/ansible/ansible-tower-samples' \
    -f human
awx job_templates create \
    --name='Example Job Template' --project 'Example Project' \
    --playbook hello_world.yml --inventory 'Demo Inventory' \
    -f human
awx job_templates launch 'Example Job Template' --monitor -f human
```

```{admonition} Approfondir
:class: seealso

* [Documentation AWX CLI](https://docs.ansible.com/ansible-tower/latest/html/towercli/reference.html#awx-inventory-create)
* [Documentation AWX CLI - Examples](https://docs.ansible.com/ansible-tower/latest/html/towercli/examples.html)
```
