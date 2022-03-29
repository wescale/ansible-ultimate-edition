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

[](/exercises/basics/ex01-project.md)
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

Quelques clés de configuration Ansible à connaître (et les valeurs conseillées) :

* `ANSIBLE_STDOUT_CALLBACK="ansible.posix.debug"` : formatage de la sortie standard d'Ansible pour 
la rendre lisible par un humain (interpréter les '\n' notamment).
* `ANSIBLE_INVENTORY="inventory"` : le fichier d'inventaire pris par défaut.
* `ANSIBLE_FORKS="10"` : nombre de connexions SSH simultanées qui vont appliquer les playbooks aux machines cibles.
* `ANSIBLE_ROLES_PATH="roles"` : chemin où Ansible va rechercher les rôles inclus depuis les playbooks.
* `ANSIBLE_CALLBACKS_ENABLED="timer,profile_tasks"` : ajout d'une prise de mesure des performances de chaque tasks et 
un top 15 des plus chronophages en fin d'exécution de playbook.

```{admonition} Approfondir
:class: seealso

* [Documentation Ansible - Configuration Settings](https://docs.ansible.com/ansible/latest/reference_appendices/config.html)
```

## Configuration personnelle

Outre les configurations communes destinées au comportement d'Ansible ou de vos autres outils, il émerge une besoin de façon
quasi-systématique : surcharger une valeur de configuration ou y ajouter des valeurs spécifique à chaque membre d'équipe 
(comme un chemin absolu incluant le nom de l'utilisateur).

Pour cela, encore une fois `direnv` nous permet de régler le problème de façon simple. Il suffit d'ajouter une section de 
chargement d'un autre fichier depuis notre `.envrc`:

```bash
layout python3

ENV_ADDONS=".env.local .env.personal .env.secrets"
for addon in ${ENV_ADDONS}; do
    if [ -e "${PWD}/${addon}" ]; then
        source ${PWD}/${addon}
    fi
done
```

Évidemment on git-ignore les fichiers `.env.local`, `.env.personal` et `.env.secrets` pour s'assurer qu'ils ne 
soient pas poussés ailleurs que notre machine de travail.

C'est typiquement dans ce fichier git-ignoré que vous pourrez sereinement ranger des variables d'environnement comme `AWS_PROFILE`,
`SCW_SECRET_KEY` et autres `GANDI_API_KEY`. Le chargement sera assuré par `direnv` dès que vous entrez dans le répertoire 
et sera déchargé en le quittant. Cela vous met à l'abri des problèmes de mauvaise clé active quand vous changez de contexte projet.

Cette convention ne coûte pas cher à mettre en place et n'ajoute aucune dépendance d'outil.

```{admonition} Mise en pratique
:class: important

[](/exercises/basics/ex02-config.md)
```

