# Ex00 Installation


```{admonition} Note
:class: important

Cet exercice a été validé sur un système **Debian Bullseye**. Il se peut que vous ayez besoin d'adapter quelques éléments
pour pouvoir reproduire sur d'autres sytèmes.
```

## Prérequis

Pour que tout se passe comme prévu, vous aurez besoin que soient installés sur votre machine de travail :

* Python > 3.7.3 et les modules venv et pip ;
* direnv.

Il y a trop de configurations de systèmes pour pouvoir couvrir tous les cas ici. Notre cas de référence sur 
Debian Bullseye n'est pas tiré de nulle part : cette configuration permet à de nombreux professionnels de gagner leur vie
en étant productif au quotidien (Debian sur laptop, aujourd'hui ce n'est pas un problème).

Pour notre cas de référence donc, atteindre ces prérequis passe par le lancement des commandes suivantes :

```shell session
$ sudo apt update 
$ sudo apt install direnv python3 python3-pip python3-venv
$ echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
$ source ~/.bashrc
```

```{admonition} Nota Bene
:class: tip

* Si vous êtes sous Ubuntu, les commandes sont valides également.
* Si vous n'utilisez pas Bash comme shell par défaut, reportez vous à la [doc de direnv](https://direnv.net/docs/hook.html)
pour l'intégrer à votre shell préféré.
* Si vous êtes sous Windows, un WSL bien configuré doit vous permettre de faire ça 
(n'hésitez pas à contribuer un guide en PR sur le projet).
```

## Création du virtualenv

Pour respecter l'isolation, nous allons créer un virtualenv global à tous nos futurs projets. Chaque projet pourra ensuite venir surcharger ce virtualenv avec le sien propre pour isoler ses dépendances.

* Création de notre espace de travail Ansible

```shell session
$ mkdir ~/ansible-workspaces
$ cd ~/ansible-workspaces
```

* Création d'un fichier `.envrc` pour indiquer à direnv de créer un virtualenv

```bash
# ~/ansible-workspaces/.envrc
layout python3
```

* Référencement du `.envrc` auprès de direnv

```shell session
$ direnv allow .
```

```{admonition} Activation automatique du virtualenv
:class: tip

Si vous lancez la commande `which python3` depuis le répertoire `~/ansible-workspaces` ou en dehors, vous n'obtenez pas le même chemin. 
Direnv active automatiquement le virtualenv qu'il crée lorsque votre shell se trouve dans un sous-répertoire comparé à l'emplacement du fichier `.envrc`.
```

## Installation d'Ansible

Maintenant que notre virtualenv est prêt, une simple commande nous permet d'y installer Ansible :

```shell session
$ pip install ansible-core 
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

```bash session
$ which ansible
/home/user/ansible-workspaces/.direnv/python-3.9.2/bin/ansible

$ ansible --version
ansible [core 2.12.3]
  config file = None
  configured module search path = ['/home/user/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/user/ansible-workspaces/.direnv/python-3.9.2/lib/python3.9/site-packages/ansible
  ansible collection location = /home/user/.ansible/collections:/usr/share/ansible/collections
  executable location = /home/user/ansible-workspaces/.direnv/python-3.9.2/bin/ansible
  python version = 3.9.2 (default, Feb 28 2021, 17:03:44) [GCC 10.2.1 20210110]
  jinja version = 3.1.0
  libyaml = True
```

