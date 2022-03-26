# Organisation de projet

## Fichiers et répertoires

L'organisation des collections Ansible colle parfaitement avec tous les besoins d'un projet
par conséquent, pas besoin de tenter d'établir un nouveau standard exotique. On s'en tient à la 
documentation ! Votre code sera beaucoup plus maintenable si vous adoptez les standards de la communauté.

```{admonition} Perle de sagesse
:class: tip

Tout projet Ansible contenant des playbooks doit être une collection.
```

```{admonition} Mise en pratique
:class: important

[](/exercises/ex01-project.md)
```

## Configuration

Le plus efficace est d'adopter une méthode de gestion de la configuration qui puisse convenir à Ansible mais également à d'autres
outils qui seront impliqués dans notre développement. La méthode la plus tout-terrain est celle qui passe **par les variables
d'environnement**. On peut de cette façon configurer Ansible, mais aussi à :

* Terraform (et l'immense majorité des providers Terraform)
* AWS CLI
* kubectl
* helm
* et bien d'autres...

C'est une méthode de travail fiable et pratique, pour peu qu'on soit un peu aidé. C'est aussi un des aspects qui nous a poussé à 
choisir `direnv` pour la gestion de virtualenv décrite dans la section [](install.md). `Direnv` charge tout fichier 
`.envrc` se trouvant dans un répertoire dans lequel on se place, mais il remet l'environnement à son état d'origine dès qu'on 
en sort. Il n'y a donc plus de risque d'oublier une variable d'environnement en changeant de projet et qu'elle vienne 
impacter un autre projet.

On va donc s'appuyer sur le fichier `.envrc` dédié à `direnv` pour y placer la configuration commune à toute l'équipe.

```{admonition} Mise en pratique
:class: important

[](/exercises/ex02-config.md)
```

----

```{admonition} Approfondir
:class: seealso

* [Documentation Ansible - Configuration Settings](https://docs.ansible.com/ansible/latest/reference_appendices/config.html)
```


