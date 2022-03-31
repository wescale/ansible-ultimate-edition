# Handlers

## Observation

Parmi les exemples de code que vous trouverez immanquablement sur la toile, le déclenchement de tasks en fonction
du résultat d'une autre task revient souvent sous ces formes :

```yaml
#
# Ne pas reproduire chez vous
#
- name: Templating de conf
  template:
    src: ...
    dest ...
  register: _templating

- name: Restart de service si la conf change
  service:
    state: restarted
  when: _templating is changed
```

Cette approche complexifie inutilement le code de vos rôles/playbooks en réimplémentant la mécanique interne à Ansible qu'est le 
handler. Un des arguments est que les handlers se déclenchent en fin d'exécution de playbook et donc diffèrent parfois trop
le lancement de ces comportements conditionnels.

## Proposition

En couplant la définition classique de handler ave l'usage du module **meta**, moins connu, on obtient l'effet désiré. Si on prend l'exemple d'un micro-playbook pour illustrer, cela donne :

```yaml
---
- hosts: localhost
  become: yes

  tasks:
    - name: Templating de conf
      template:
        src: ...
        dest: ...
      notify: Restart service

    - name: Application de tous les handlers notifiés jusqu'ici
      meta: flush_handlers

    - debug:
        msg: "Si la config a été modifiée, à ce stade, le service est déjà redémarré."

  handlers:
    - name: Restart service
      service:
        name: ...
        state: restarted
```

## Intégration

Cette approche est aussi bien applicable dans un contexte de playbooks comme vu au-dessus, que dans un contexte de rôle. Dans un rôle
vous rangerez vos handlers dans le fichier `handlers/main.yml` et vous utiliserez la combo attribut `notify` + module `meta: flush_handlers` là où cela sera utile.

