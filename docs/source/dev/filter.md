# Filter plugins

Tous les filters que vous développez doivent se trouver au sein d'une collection, cela facilitera la diffusion, que ce soit
en au sein de la communauté ou pour vos projets d'entreprise.

Les modules custom que vous développez doivent se trouver dans le répertoire `plugins/filter_plugins` pour être retrouvés
à l'installation de la collection en dépendances d'un projet.

Le [guide officiel de développement de plugins](https://docs.ansible.com/ansible/latest/dev_guide/developing_plugins.html) est très fourni sur le sujet.

## Initialisation

En phase de développement, vous devez indiquer à Ansible où trouvez vos plugins filters en cours de développement.

* Ajoutez ceci à votre `.envrc`

```bash
export ANSIBLE_FILTER_PLUGINS="${PWD}/plugins/filter_plugins:${ANSIBLE_FILTER_PLUGINS}"
```

## Exemple fonctionnel

Coller ceci dans le fichier `plugins/filter_plugins/rev.py` :

```python
#!/usr/bin/python

class FilterModule(object):
    ''' Nested dict filter '''

    def filters(self):
        return {
            'rev': self.rev
        }

    def rev(self, input):

        return input[::-1]
```

Vous pouvez le tester en créant le fichier `playbooks/rev.yml` :

```yaml
---
- hosts: localhost
  become: false
  gather_facts: false

  tasks:
    - debug:
        msg: "{{ item | rev }}"
      loop:
        - palindrome
        - kayak
```

Et en lançant la commande :

```bash session
$ ansible-playbook playbooks/rev.yml
PLAY [localhost] ************************************************************************************************************************************************************

TASK [debug] ****************************************************************************************************************************************************************
mardi 19 avril 2022  01:38:22 +0200 (0:00:00.006)       0:00:00.006 *********** 
ok: [localhost] => (item=palindrome) => {}

MSG:

emordnilap
ok: [localhost] => (item=kayak) => {}

MSG:

kayak

PLAY RECAP ******************************************************************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

Playbook run took 0 days, 0 hours, 0 minutes, 0 seconds
mardi 19 avril 2022  01:38:22 +0200 (0:00:00.021)       0:00:00.028 *********** 
=============================================================================== 
debug ---------------------------------------------------------------------------------------------------------------------------------------------------------------- 0.02s
```

