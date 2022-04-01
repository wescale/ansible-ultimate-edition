# Inventaires

## Dynamiques ou statiques ?

Tout va dépendre de votre cas et de la géométrie du parc que vous gérez avec Ansible... 

Parmi les bonnes pratiques poussées par Ansible, il est conseillé de privilégier des inventaires dynamiques dès 
lors que vous êtes dans un milieu très dynamique comme un fournisseur de Cloud. Le contre-argument est que si vous devez gérer
un parc de VM dans un milieu Cloud, vous aurez suûrement mieux à faire que de vous connecter en SSH aux machines pour quelque opération que ce soit. Dans ce genre de cas, Ansible a bien plus sa place au niveau d'un pipeline de build d'images serveur dans une approche Golden Image.

Si vous choisissez de vous porter vers un inventaire dynamique, assurez vous de contrôler son retour avant de lancer un playbook 
à l'aveugle. En effet, le côté dynamique augmente le risque d'inclure des machines cibles imprévues. Il est très simple de choisir un périmètre trop large et de faire déborder un playbook.

La technique la plus sûre à notre avis reste celle de l'inventaire statique généré. Vous fournissez à Ansible un fichier statique 
mais au préalable vous le générez, avec un programme d'inventaire dynamique ou votre propre implémentation. Et surtout, entre la génération et la consommation, insérez une phase d'audit/relecture. La confiance n'exclut pas la contrôle.

## Géométrie des groupes

Choisissez vos groupes en fonction des playbooks/rôles que vous souhaitez appliquer. Les groupements de machines dans l'inventaire 
doivent vous faciliter la vie, pas la complexifier.

Intégrez le nom de l'environnement dans le nom des groupes vous évitera de reconfigurer votre production. Il faut éviter à tout 
prix que des groupes de groupes ne contiennent des machines de différents environnements. 

```bash
#
# NE PAS REPRODUIRE
# 
[webservers]
web-01
web-02
web-03
web-04

[staging]
web-01
web-02

[production]
web-03
web-04
```

Dans cet exemple, si je sélectionne le groupe `webservers` sans exclure explicitement les machine appartenant au groupe `production`

Préférez cette version, sans ambigüité :

```bash
[staging_webservers]
web-01
web-02

[production_webservers]
web-03
web-04
```

Avec cette version vous ne risquez plus de sélectionner des serveurs de plusieurs environnements par mégarde.

Idéalement, une machine doit figurer dans un minimum de groupes différents.

## Syntaxe de sélection

Une information qui peut vous aider à structurer vtre inventaire est de connaître l'existence des patterns de sélection.

Un pattern de sélection est typiquement en toute première place dans les playbooks et les exemples de code sur la toile
ne s'attardent que rarement dessus. Dans sa forme la plus simple, ça donne :

```yaml
---
- name: Playbook de démo 
  hosts: un_groupe_de_mon_inventaire
#        ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^
#           pattern de sélection 

  tasks:
    [...]
```

Mais la syntaxe de sélection est plus riche que cela.


| Description             | Pattern(s)                 | Cibles
| ----------------------- | -------------------------- | ---------------------------------------------------------
| tous les hosts          | `all`                      | tous les hosts de l'inventaire (mot réservé)
| un host en particulier  | `host1`                    |
| plusieurs hosts         | `host1:host2`              |
| un groupe               | `group1`                   | tous les hosts présents dans `group1` 
| plusieurs groupes       | `group1:group2`            | tous les hosts de `group1` ET ceux de `group2`
| exclusion de groupe     | `group1:!group2`           | tous les hosts de `group1` ET **absents** de `group2`
| intersection de groupes | `group1:&group2`           | tous les hosts présents dans `group1` ET `group2`


```{admonition} Approfondir
:class: seealso

[Documentation Ansible - Sélection de hosts](https://docs.ansible.com/ansible/latest/user_guide/intro_patterns.html)
```

## Keep It Simple

Les groupes que vous façonnez dans votre inventaire doivent simplement refléter vos habitudes opérationnelles :

* quels sont les hosts qui se ressemblent ? Grouper les hosts d'un cluster semble évident.
* quels sont les hosts qui s'assemblent ? Un groupe parent `application` pour englober 2 groupes `backend` et `frontend` peut être intéressant

Il n'y a pas de véritable règle de design dans la mesure où il n'existe aucune norme sur l'organisation de machines au sein de réseaux. Garder en tête que si vous avez besoin régulièrement d'utiliser les options de limitations de `ansible-playbook`, c'est que votre design d'inventaire n'est pas en adéquation avec vos usages.

```bash session
# Si vous voyez ce genre de commande souvent, retournez affiner votre inventaire.
$ ansible-playbooks playbooks/exemple.yml --limit='web_servers:!centos_servers'
```

```{admonition} Perle de sagesse
:class: important

If something is too complex to understand, it must be wrong.

_Arjen Poutsma_, The Poutsma Principle, [Xebia Essential Cards](https://essentials.xebia.com/poutsma-principle/)
```


