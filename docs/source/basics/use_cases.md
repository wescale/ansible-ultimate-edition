# Cas d'usage

Ansible est un outil d'automatisation très versatile. Vous pouvez en tirer avantage pour tous les cas suivants :

* automatisation d'installation sur tous types de machines distantes ;
* langage de scripting local ;
* gestion de configuration (templating, actions de post-configuration, _etc._) ;
* orchestration de migrations (base de données, flux réseaux, _etc._) ;
* tests d'infrastructure.


```{admonition} Perle de sagesse
:class: tip

Ansible vous permet d'écrire des scripts qui s'exécutent à travers tout votre SI sans restriction.
```

La grande force d'Ansible réside dans les très nombreux modules qui vous permettront d'enchaîner, au sein d'une même exécution :

* un post RabbitMQ ;
* une modification de flux sur une appliance réseau ;
* une extinction de service sur un serveur ;
* une modification d'enregistrement DNS.

La principale question est de savoir ce que vous avez envie de faire. Tant qu'il s'agit de sujet DevOps/PureOps, entre les modules existant et les capacités d'extension, il y a forcément une façon de tirer parti d'Ansible pour vous faciliter la vie.
