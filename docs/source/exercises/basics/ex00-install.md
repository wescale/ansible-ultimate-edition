# Installer Ansible

```{admonition} Objectif
:class: hint

Installation d'Ansible sur un poste de travail.
```

## Prérequis

* [Préparation](/exercises/prerequisites.md)

## Création du virtualenv

Pour isoler l'installation de nos dépendances du reste du système, nous allons créer un 
virtualenv global à tous nos futurs projets. Chaque projet pourra ensuite venir 
surcharger ce virtualenv avec le sien propre pour isoler ses dépendances au fil des besoins.

* Création de notre espace de travail Ansible

```shell session
mkdir ~/ansible-workspaces
cd ~/ansible-workspaces
```

* Création d'un fichier `.envrc` pour indiquer à [direnv](https://direnv.net/) de créer un virtualenv

```bash
# ~/ansible-workspaces/.envrc
layout python3
```

* Référencement du `.envrc` auprès de direnv. Lancer la commande:

```shell session
direnv allow .
```

```{admonition} Activation automatique du virtualenv
:class: tip

Si vous lancez la commande `which python3` depuis le répertoire `~/ansible-workspaces` ou en dehors, 
vous n'obtenez pas le même chemin. Direnv active automatiquement le virtualenv qu'il crée lorsque votre 
shell se trouve dans un sous-répertoire comparé à l'emplacement du fichier `.envrc`.
```

## Installation d'Ansible

Maintenant que notre virtualenv est prêt, une simple commande nous permet d'y installer Ansible :

```shell session
pip install ansible-core 
```

```{admonition} Installation locale
:class: tip

Si vous lancez la commande `which ansible` depuis le répertoire `~/ansible-workspaces`, vous pourrez observer que le binaire qui
répond est situé dans le virtualenv créé juste avant.
```

## Ligne d'arrivée

Félicitations, vous venez d'installer Ansible dans un virtualenv. Si vous lancez la commande `which ansible` 
depuis le répertoire `~/ansible-workspaces`, vous pourrez observer que le binaire qui
répond est situé dans le virtualenv créé juste avant.

```shell session
which ansible
```

```
/home/user/ansible-workspaces/.direnv/python-3.9.2/bin/ansible
```
----
```shell session
ansible --version
```

```
ansible [core 2.14.2]
  config file = None
  configured module search path = ['/home/amaury/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/amaury/ansible-workspaces/.direnv/python-3.9.2/lib/python3.9/site-packages/ansible
  ansible collection location = /home/amaury/.ansible/collections:/usr/share/ansible/collections
  executable location = /home/amaury/ansible-workspaces/.direnv/python-3.9.2/bin/ansible
  python version = 3.9.2 (default, Feb 28 2021, 17:03:44) [GCC 10.2.1 20210110] (/home/amaury/ansible-workspaces/.direnv/python-3.9.2/bin/python3)
  jinja version = 3.1.2
  libyaml = True
```

