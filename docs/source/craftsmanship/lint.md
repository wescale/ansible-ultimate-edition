# Ansible-Lint

`ansible-lint` est un outil d'analyse statique de code dédié à Ansible. Il va parcourir les sources Ansible qu'il 
détecte et générer un rapport des violations par rapport à un ensemble de règles maintenu par la communauté. Il est bien
sûr possible de le configurer afin de limiter son périmètre d'analyse ou les règles qu'il doit vérifier.

C'est un must-have sur tout projet Ansible afin d'avoir un rapport objectif sur la qualité du code produit.


## Installation

Partant du principe que vous avez suivi les recommandations du chapitre sur [](/basics/__index.md), pour installer ansible-lint :

* Dans le fichier `requirements.txt` de votre projet, ajoutez une ligne `ansible-lint[yamllint]`
* Lancez la commande : `make env`

## Configuration

Plutôt que de vous attaquer à la maîtrise des options CLI de `ansible-lint`, mieux vaut simplement rajouter un fichier de 
de configuration `.ansible-lint`à la racine de votre projet. L'exemple donné si dessous peut convenir pour un grand nombre de projets
mais pensez à approfondir votre maîtrise de l'outil en allant creuser les possibilités par vous-même.

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
parseable: true     # Utiliser un format parseable de rapport
quiet: false        # Limiter le contenu du rapport à son strict minimum
verbosity: 1        # Niveau de verbosité du rapport
#
# Oblige les variables de boucles à être nommées avec ce préfix, comme ceci :
#
#   - name: Exemple conforme
#     debug:
#       msg: "Élement courant {{ __current_name }}"
#     loop:
#       - "premier"
#       - "second"
#     loop_control:
#       loop_var: "__current_name"
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
  - fqcn-builtins   # Pas besoin de surcharger le code avec des noms de module complet quand il 
                    # s'agit de 'ansible.builtin.*'

  - meta-no-info    # La plupart des projets internes n'ont pas besoin de renseigner un fichier
                    # 'meta/main.yml' pour leur rôles. Á retirer si vous comptez publier.
#
# Certaines règles ont un tag 'opt-in', elles ne sont pas activées à moins de les inclure
# dans cette 'enable_list'
#
enable_list:
  - no-log-password # Vérifie tant que possible que des passwords ne soient pas loggés
  - no-same-owner   # Vérifie que les transfert de fichier mentionne 'owner' et 'group'
  - yaml            # Intègre un rapport Yaml-Lint dans le rapport de Ansible-Lint
#
# Règles à relever comme des Warning et non des Fautes
#
warn_list:
  - git-latest      # Les usages du module 'git' doivent metionner la gitref ciblée.
  - experimental    # Relève les usages de modules Ansible marqués comme expérimentaux (par défaut)
#
# Désactive l'installation du requirements.yml
#
offline: true
```

## Exécution

Pour lancer un scan de votre code, lancez simplement :

```bash session
$ pwd
/home/user/ansible-workspaces/ultimate/training

$ ansible-lint
[...]
roles/rproxy/defaults/main.yml:12: yaml no new line character at the end of file (new-line-at-end-of-file)
roles/rproxy/meta/main.yml:6: yaml comment not indented like content (comments-indentation)
roles/rproxy/tasks/install.yml:6: no-loop-var-prefix Role loop_var should use configured prefix.: rproxy_
roles/rproxy/tasks/install.yml:30: no-loop-var-prefix Role loop_var should use configured prefix.: rproxy_
roles/rproxy/tasks/install.yml:39: no-loop-var-prefix Role loop_var should use configured prefix.: rproxy_
roles/rproxy/tasks/install.yml:49: no-loop-var-prefix Role loop_var should use configured prefix.: rproxy_
roles/rproxy/tasks/install.yml:58: no-loop-var-prefix Role loop_var should use configured prefix.: rproxy_
roles/rproxy/tasks/install.yml:75: unnamed-task All tasks should be named
roles/rproxy/tasks/install.yml:75: yaml no new line character at the end of file (new-line-at-end-of-file)
roles/rproxy/tasks/main.yml:5: yaml missing starting space in comment (comments)
roles/rproxy/tasks/main.yml:20: unnamed-task All tasks should be named
[...]
Finished with 51 failure(s), 27 warning(s) on 128 files.
```

Il ne vous reste plus qu'à en faire l'intégration dans votre chaine de CI préférée pour avoir un contrôle de qualité en continue.

```{admonition} Approfondir
:class: seealso

* [Configurer Ansible-Lint](https://ansible-lint.readthedocs.io/en/latest/configuring/)
* [Liste complète des règles Ansible-Lint](https://ansible-lint.readthedocs.io/en/latest/default_rules/)
```

