# Supporter plusieurs versions de systèmes

## Observation

Il peut arriver que l'on veuille supporter :

* différents systèmes
* différentes version d'un même système

Ansible collecte des **facts** à la connexion au système pour nous permettre de différencier un OS d'un autre. C'est 
classiquement sur ces variable collectées qu'il convient de s'appuyer pour savoir dans quel cas l'exécution se déroule.

Pour cela, vous trouverez couramment des approches basées sur l'exécution conditionnelle de tasks.

```yaml
- name: Debian-only templating
  template:
    src: ...
    dest: ...
  when: ansible_distribution == 'Debian'
```

Le problème latent est la duplication de code, qui arrive rapidement avec la multiplication des cas particuliers.

Le niveau supérieur est de charger un fichier de tasks dédié en s'appuyant sur la même variable :

```yaml
- name: Debian-only tasks
  include_tasks: debian.yml
  when: ansible_distribution == 'Debian'
```
...ou encore :

```yaml
- name: Debian-only tasks
  include_tasks: "{{ ansible_distribution | lower }}.yml
```

Mais là encore on va rapidement se retrouver avec des cas et des sous-cas au fil de la vie du code.

## Proposition

L'organisation de code pour pouvoir supporter des tasks spécifiques par système est un problème récurrent et chaque
projet y va de son implémentation. Voici une méthode tout-terrain.

L'idée est de créer un fois pour toute une chaine de chargement préférentiel qui s'appuie sur nos facts. L'inclusion de facts dans
le nommage des fichiers recherchés permet de ne charger que les cas les plus spécifiques, et cela pour des fichiers de variable ET pour des fichiers de tasks.

```yaml
- name: OS markers
  debug:
    msg: >-
      Distrib: {{ ansible_distribution | lower }} - Version: {{ ansible_distribution_major_version }} - Arch: {{ ansible_architecture | lower }}
    verbosity: 1

- name: Load os-specific vars
  include_vars: "{{ _current_os_vars }}"
  with_first_found:
    - skip: true
      files:
        - "{{ ansible_distribution | lower }}_{{ ansible_distribution_major_version }}_{{ ansible_architecture | lower }}.yml"
        - "{{ ansible_distribution | lower }}_{{ ansible_architecture | lower }}.yml"
        - "{{ ansible_distribution | lower }}_{{ ansible_distribution_major_version }}.yml"
        - "{{ ansible_distribution | lower }}.yml"
        - "{{ ansible_os_family | lower }}.yml"
  loop_control:
    loop_var: _current_os_vars

- name: Execute os-specific tasks
  include_tasks: "{{ _current_os_tasks }}"
  with_first_found:
    - skip: true
      files:
        - "{{ ansible_distribution | lower }}_{{ ansible_distribution_major_version }}_{{ ansible_architecture | lower }}/main.yml"
        - "{{ ansible_distribution | lower }}_{{ ansible_architecture | lower }}/main.yml"
        - "{{ ansible_distribution | lower }}_{{ ansible_distribution_major_version }}/main.yml"
        - "{{ ansible_distribution | lower }}/main.yml"
  loop_control:
    loop_var: _current_os_tasks
```

Concrètement, ce code exécuté depuis un rôle sur une machine Debian Bullseye d'architecture x86 va :

* tenter de charger le fichier de variables `vars/debian_11_x86_64.yml`
* si le fichier est absent, tenter `vars/debian_x86_64.yml`
* si le fichier est absent, tenter `vars/debian_11.yml`
* si le fichier est absent, tenter `vars/debian.yml`
* si le fichier est absent, passer à la suite sans erreur
* tenter d'exécuter le fichier de tasks `tasks/debian_11_x86_64/main.yml`
* si le fichier est absent, tenter `tasks/debian_x86_64/main.yml`
* si le fichier est absent, tenter `tasks/debian_11/main.yml`
* si le fichier est absent, tenter `tasks/debian/main.yml`
* si le fichier est absent, passer à la suite sans erreur

## Intégration

Une fois ce code en place dans le fichier `tasks/main.yml` d'un rôle, vous n'aurez plus besoin d'y toucher. Implémenter des 
variables et comportements spécifiques reviendra à ajouter les fichiers à charger en suivant la convention de nommage des fichiers.

À vous de trouvez la priorisation qui convient le mieux à vos usages et de poser une convention avec vos équipes.
