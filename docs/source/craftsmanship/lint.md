# Ansible-Lint

`ansible-lint` est un outil d'analyse statique de code dédié à Ansible. Il va parcourir les sources Ansible qu'il 
détecte et générer un rapport des violations par rapport à un ensemble de règles maintenu par la communauté. Il est bien
sûr possible de le configurer afin de limiter son périmètre d'analyse ou les règles qu'il doit vérifier.

C'est un must-have sur tout projet Ansible afin d'avoir un rapport objectif sur la qualité du code produit.

```{admonition} Approfondir
:class: seealso

[Liste complète des règles Ansible-Lint](https://ansible-lint.readthedocs.io/en/latest/default_rules/)
```

## Installation

Partant du principe que vous avez suivi les recommandations du chapitre sur [](/basics/__index.md), pour installer ansible-lint :

* Dans le fichier `requirements.txt` de votre projet, ajoutez une ligne `ansible-lint[yamllint]`
* Lancez la commande : `make env`

## Configuration

```yaml
# .ansible-lint
#
# Reference documentation: 
#   https://ansible-lint.readthedocs.io/en/latest/configuring.html#configuration-file
#
# Chemins à exclure de l'analyse statique
#
exclude_paths:
  - .cache/  
  - .github/
  - .direnv/
  - .git/
  - keys/
  - secrets/
  - tests/
  - requirements.yml
  - molecule.yml
parseable: true
quiet: false
verbosity: 1
#
# Oblige les variables de boucles à être nommées avec ce préfix
#
loop_var_prefix: "__current_"
#
# Active le set de règles par défaut
#
use_default_rules: true
#
# Ignore toutes les règles listées dans cette 'skip_list'
#
skip_list:
  - fqcn-builtins    # 
  - meta-no-info     # No 'galaxy_info' found
  - no-changed-when  # Commands should not change things if nothing needs doing
  - no-tabs          # Most files should not contain tabs
  - role-name        # Role name does not match ``^[a-z][a-z0-9_]+$`` pattern
#
# Certaines règles ont un tag 'opt-in', elles ne sont pas activées à moins de les inclure
# dans cette 'enable_list'
#
enable_list:
  - no-log-password
  - no-same-owner
  - yaml
#
# Règles à relever comme des Warning et non des Fautes
#
warn_list:
  - skip_this_tag
  - git-latest
  - experimental     # experimental is included in the implicit list
#
# Désactive l'installation du requirements.yml
#
offline: true
```
