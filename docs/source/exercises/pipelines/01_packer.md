# Ex01 - Découverte intégration Gitlab-CI

```{admonition} Objectif
:class: hint

Industrialiser la création des images des machines virtuelles EC2. 
```

```{admonition} Note
:class: important

Cet exercice a été validé sur Gitlab.com, le service SaaS de Gitlab. Il vous faut créer un compte gratuit sur sur gitlab.com en pré-requis, ou utiliser votre compte personnel si vous en possédez déjà un. 

```

Notre image doit comporter tout le nécessaire pour construire des [AMI AWS](https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/AMIs.html). 

Créer un projet Gitlab vierge. Ce projet comportera un fichier Packer, un playbook Ansilbe et son requirements.yml pour la gestion des dépendances?


## Fichier `quick-start.pkr.hcl`

```{admonition} VPC par défaut
:class: tip

Le fichier de configuration Packer suivant fonctionne dans le cas où le VPC par défaut existe dans le compte AWS cible. 
Si vous ne disposez pas de VPC par défaut utiliser le fichier de configuration n°2.
```

* Exemple n°1 (VPC par défaut requis) :

```hcl
packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "quick-start" {
  ami_name      = "packer-example ${local.timestamp}"
  instance_type = "t2.micro"
  region        = "eu-west-1"
  source_ami    = "ami-0a2616929f1e63d91"
  ssh_username  = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.quick-start"]

  provisioner "ansible" {
    playbook_file   = "ansible/playbook.yml"
  }
}
```

```{admonition} Choix du VPC
:class: tip

Le fichier de configuration Packer suivant fonctionne dans le cas où le VPC par défaut n'existe pas. Dans ce cas vous devez spécifier à Packer le VPC et le sous-réseau à utiliser.
```

* Exemple n°2

```hcl
source "amazon-ebs" "quick-start" {
  ami_name      = "packer-example ${local.timestamp}"
  instance_type = "t2.micro"
  region        = "eu-west-1"
  source_ami    = "ami-0a2616929f1e63d91"
  ssh_username  = "ubuntu"

  subnet_filter {
    filters = {
      "tag:Name" = "<Valeur du tag:Name du sous-réseau à utiliser>"
    }
    most_free = true
    random    = false
  }

  vpc_filter {
    filters = {
      cidr       = "<CIDR du VPC à utiliser>"
      isDefault  = "false"
      "tag:Name" = "<Valeur du tag:Name du VPC à utiliser"
    }
  }
}

build {
  sources = ["source.amazon-ebs.quick-start"]
  provisioner "ansible" {
    
    playbook_file   = "ansible/playbook.yml"
  }  
}
```

## Fichiers Ansible

Organiser les fichiers Ansible en suivant les bonnes pratiques présentées ici.

Ajoutons le playbook *ansible/playbook.yml* suivant :

```yaml
- hosts: "{{ target|default('all') }}"
  become: true
  roles:
    - ansible-role-security
  tags:
    - security
```

Le rôle *ansible-role-security* est un rôle public qui permet de configurer et ajouter des paramètres de sécurité basiques.
 Ajoutons le rôle dans le fichier *ansible/requirements.yml* :

```yaml
- src: https://github.com/geerlingguy/ansible-role-security.git
  scm: git
  version: "2.1.0"
```

A ce stade vous devriez avoir l'arborescence suivante dans votre projet Gitlab :
```sh
.
├── README.md
├── ansible
│   ├── playbook.yml
│   └── requirements.yml
└── quick-start.pkr.hcl

1 directory, 4 files
```

## Configuration Gitlab-CI

Dans le menu *Settings* --> *CI/CD* déroulez la section *Variables* afin d'ajouter les variables d'environment suivantes :

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_DEFAULT_REGION

```{admonition} Authentification AWS
:class: important

[Pour plus d'informations au sujet des déploiements sur AWS depuis Gitlab](https://docs.gitlab.com/ee/ci/cloud_deployment/index.html#run-aws-commands-from-gitlab-cicd)
```

Maintenant que les variables sont ajoutées il nous reste à définir les actions dans la pipeline.
Pour cela il suffit d'ajouter un fichier *.gitlab-ci.yml* comme suit : 

```yaml
# https://docs.gitlab.com/ee/development/cicd/templates.html
# This specific template is located at:
# https://gitlab.com/gitlab-org/gitlab/-/blob/master/lib/gitlab/ci/templates/Packer.gitlab-ci.yml

image:
  name: stelar/packer_ansible_build:latest
  
before_script:
  - packer --version
  - find . -maxdepth 1 -name '*.pkr.hcl' -print0 | xargs -t0n1 packer init

stages:
  - validate
  - build
  - test
  - deploy

validate:
  stage: validate
  script:
    - find . -maxdepth 1 -name '*.pkr.hcl' -print0 | xargs -t0n1 packer validate

build:
  stage: deploy
  environment: production
  before_script:
    - ansible-galaxy install -r ansible/requirements.yml -p ./ansible/roles --force
  script:
    - find . -maxdepth 1 -name '*.pkr.hcl' -print0 | xargs -t0n1 packer build
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
      when: manual
```

Ce fichier de configuration de CI/CD est largement basé sur le modèle disponible en lien en haut du fichier.

On utilise une image Docker qui contient tout le nécessaire dont Packer, Ansible et Awscli.


## Ligne d'arrivée

Féliciations vous venez de configurer votre première chaîne d'intégration et de déploiment continue pour la construction des 
AMI AWS via Packer et Ansible ! 

Mais attention, il reste encore du chemin avant d'aller en production ! En effet nous avons posé les bases, nous irons 
plus loin dans une prochaine section. 
