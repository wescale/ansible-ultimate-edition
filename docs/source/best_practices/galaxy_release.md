# Ansible Galaxy Release

La ligne de commande `ansible-galaxy` vous permet de publier votre collection ou votre rôle sur la plateforme
communautaire [galaxy.ansible.com] et ainsi de permettre à d'autres d'utiliser votre code.

Cependant, `ansible-galaxy` ne permet que de publier le répertoire courant au moment de l'exécution et ne contient pas de 
mécanique de templating pour le fichier de meta `galaxy.yml`. Voici un playbook pour compenser ce léger manque.

Nous vous conseillons de placer ce playbook `release_collection.yml` dans un répertoire `build/` à la racine du projet.

```yaml
---
- hosts: localhost
  connection: local
  become: false
  gather_facts: false

  vars:
    project_repository: "project_git url"
    galaxy_namespace: your_namespace
    galaxy_name: your_collection

    project_dir: "{{ (playbook_dir + '/../') | realpath }}"
    build_dir: "{{ project_dir }}/build"
    clone_dir: "{{ build_dir }}/clone"

    dot_ansible_dir: "{{ lookup('env', 'HOME') }}/.ansible"
    galaxy_token_file: "{{ dot_ansible_dir }}/galaxy_token"
    galaxy_token: "{{ lookup('env','ANSIBLE_GALAXY_TOKEN') }}"
    src_galaxy_template: "{{ clone_dir }}/build/templates/galaxy.yml.j2"
    galaxy_version: "{{ gitref | regex_replace('v','') }}"
    galaxy_archive_name: "{{ galaxy_namespace }}-{{ galaxy_name }}-{{ galaxy_version }}.tar.gz"
    galaxy_archive_file: "{{ clone_dir }}/{{ galaxy_archive_name }}"
    galaxy_meta_file: "{{ clone_dir }}/galaxy.yml"

  pre_tasks:
    - name: Ensure the ANSIBLE_GALAXY_TOKEN environment variable is set.
      assert:
        that:
          - (galaxy_token | length) > 0
        msg: Env variable 'ANSIBLE_GALAXY_TOKEN' is not set.

    - name: Ensure $HOME/.ansible directory exists
      file:
        path: "{{ dot_ansible_dir }}"
        state: directory
        mode: 0700

    - name: Write the galaxy token to $HOME/.ansible/galaxy_token
      copy:
        content: |
          token: {{ lookup('env','ANSIBLE_GALAXY_TOKEN') }}
        dest: "{{ galaxy_token_file }}"
        mode: 0600

  tasks:
    - name: Delete old clone
      file:
        path: "{{ clone_dir }}"
        state: absent

    - name: Clone project at desired gitref
      git:
        repo: "{{ project_repository }}"
        dest: "{{ clone_dir }}"
        version: "{{ gitref }}"

    - name: Render galaxy.yml
      template:
        src: "{{ src_galaxy_template }}"
        dest: "{{ galaxy_meta_file }}"
        mode: 0644
      register: galaxy_yml_rendering

    - include_vars:
        file: "{{ galaxy_meta_file }}"
        name: galaxy_meta

    - shell: >-
        rm -rf {{ galaxy_meta.build_ignore | join (' ') }}
      args:
        chdir: "{{ clone_dir }}"

    - name: Build the collection
      command: >-
        ansible-galaxy collection build
      args:
        chdir: "{{ clone_dir }}"
      when: galaxy_yml_rendering is changed

    - name: Publish the collection
      command: >-
        ansible-galaxy collection publish {{ galaxy_archive_file }}
      args:
        chdir: "{{ clone_dir }}"
      when: 
        - galaxy_yml_rendering is changed
```

Vous aurez noté qu'il s'appuie sur une template. Vous pouvez prendre exemple et adapter à votre cas le template suivant, 
à placer dans un fichier `build/templates/galaxy.yml.j2`. 

```{admonition} À savoir
:class: important
La partie la plus importante est l'attribut `build_ignore`, vous 
être attentif à :

* ne jamais livrer des secrets.
* ignorer tout ce qui n'est pas strictement nécessaire, de façon à alléger l'archive qui sera téléchargée par vos utilisateurs. 


```
```yaml
---
namespace: "{{ galaxy_namespace }}"
name: "{{ galaxy_name }}"
version: "{{ galaxy_version }}"
readme: README.md

# A list of the collection's content authors. Can be just the name or in the format 'Full Name <email> (url)
# @nicks:irc/im.site#channel'
authors:
  - Aurélien Maury <aurelien.maury@wescale.fr>

description: >-
  Demo collection

license:
  - MIT

# A list of tags you want to associate with the collection for indexing/searching. A tag name has the same character
# requirements as 'namespace' and 'name'
tags: []

# Collections that this collection requires to be installed for it to be usable. The key of the dict is the
# collection label 'namespace.name'. The value is a version range
# L(specifiers,https://python-semanticversion.readthedocs.io/en/latest/#requirement-specification). Multiple version
# range specifiers can be set and are separated by ','
dependencies:
  ansible.netcommon: ">=2.5.0"
  ansible.posix: ">=1.3.0"

# The URL of the originating SCM repository
repository: >-
  https://github.com/wescale/my_project

# The URL to any online docs
documentation: >-
  https://my_project.rtfd.io

# The URL to the homepage of the collection/project
homepage: >-
  https://my_project.rtfd.io

# The URL to the collection issue tracker
issues: >-
  https://github.com/wescale/my_project/issues

# Since: ansible>=2.10
# Backported with love in build/release_collection.yml
#
build_ignore:
  - "*.local"
  - "*.secrets"
  - "*.tar.gz"
  - ".ansible-lint"
  - ".direnv"
  - ".env*"
  - ".envrc"
  - ".gitignore"
  - ".gitignore"
  - "Makefile"
  - "ansible.cfg"
  - "build"
  - "docs"
  - "documentation/Makefile"
  - "documentation/conf.py"
  - "documentation/requirements.txt"
  - "group_vars"
  - "host_vars"
  - "hosts"
  - "hosts.sample"
  - "keys"
  - "mkdocs.yml"
  - "ops_*.yml"
  - "requirements.*"
  - "requirements.txt"
  - "secrets"
  - "snippets"
  - "ssh.cfg"
  - "tests"
```


