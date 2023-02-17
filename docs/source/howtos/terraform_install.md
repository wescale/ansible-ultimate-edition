# Installer un outil annexe au niveau projet

En suivant la méthode poussée dans ce guide jusqu'au bout, l'installation d'un outil annexe, 
comme Terraform, devrait se faire : 

* avec une version fixe, car le code projet sera lié à la version de cet outil
* via `direnv` ou `make` qui sont les racines de manipulation de l'environnement de travail

La méthode présentée ici a l'avantage de rester dans la logique initiale et 
donc de demander un minimum de connaissances supplémentaires. 

Cela peut être vu comme restrictif par certains qui maîtrisent d'autres techniques 
mais cela reste un avantage lorsqu'on a une promotion de débutants à former.

L'idée est de réaliser une installation directement dans le répertoire `.direnv` de 
notre projet, en shell, via la mécanique native de `direnv`. 

Prenons ici comme exemple l'installation d'une version de Terraform pour un projet.

* Ajoutez le bloc suivant à votre fichier `.envrc` de projet pour construire un répertoire local à votre projet
qui contiendra les binaires à ajouter au `PATH` :

```{code-block}
:linenos:
#
# .envrc 
#   - Manipulation du PATH pour privilégier le répertoire .direnv/bin
#
export DIRENV_TMP_DIR="${PWD}/.direnv"
export DIRENV_BIN_DIR="${DIRENV_TMP_DIR}/bin"
if [ ! -e "${DIRENV_BIN_DIR}" ]; then
    mkdir -p "${DIRENV_BIN_DIR}"
fi
export PATH="${DIRENV_BIN_DIR}:${PATH}"
```

## Installer Terraform

* Ajoutez à votre `.envrc` :

```{code-block}
:linenos:
:lineno-start: 12
#
# .envrc
#   - Installation automatique de terraform
#
TF_VERSION="1.1.8"
TF_ARCH="linux_amd64"
TF_PKG_NAME="terraform_${TF_VERSION}_${TF_ARCH}.zip"
TF_PKG_URL="https://releases.hashicorp.com/terraform/${TF_VERSION}/${TF_PKG_NAME}" 
TF_PKG_PATH="${DIRENV_TMP_DIR}/${TF_PKG_NAME}" 
if [ ! -e "${DIRENV_BIN_DIR}/terraform" ]; then
    echo "===> Getting terraform:${TF_VERSION}:${TF_ARCH} (can take a while to execute)"
    curl -s -L "${TF_PKG_URL}" -o "${TF_PKG_PATH}"
    unzip "${TF_PKG_PATH}" -d "${DIRENV_BIN_DIR}"
    chmod 700 "${DIRENV_BIN_DIR}/terraform"
    rm -f "${TF_PKG_PATH}"
fi
```

* Suivi de la commande :

```{code-block}
> direnv allow .
direnv: loading ~/ansible-workspaces/ultimate/training/.envrc
===> Getting terraform:1.1.8:linux_amd64 (can take a while to execute)
Archive:  /home/amaury/ansible-workspaces/ultimate/training/.direnv/terraform_1.1.8_linux_amd64.zip
  inflating: /home/amaury/ansible-workspaces/ultimate/training/.direnv/bin/terraform  

> which terraform
/home/user/ansible-workspaces/ultimate/training/.direnv/bin/terraform
```

## Installer Goss

* Ajoutez à votre `.envrc` :

```{code-block}
:linenos:
:lineno-start: 30
#
# .envrc
#   - Installation automatique de goss
#
GOSS_VERSION="0.3.16"
GOSS_ARCH="linux-amd64"
GOSS_PKG_NAME="goss-${GOSS_VERSION}-${GOSS_ARCH}"
GOSS_PKG_URL="https://github.com/aelsabbahy/goss/releases/download/v${GOSS_VERSION}/${GOSS_PKG_NAME}" 
GOSS_PKG_PATH="${DIRENV_TMP_DIR}/${GOSS_PKG_NAME}" 
if [ ! -e "${DIRENV_BIN_DIR}/goss" ]; then
    echo "===> Getting goss:${GOSS_VERSION}:${GOSS_ARCH} (can take a while to execute)"
    curl -s -L "${GOSS_PKG_URL}" -o "${DIRENV_BIN_DIR}/goss"
    chmod 700 "${DIRENV_BIN_DIR}/goss"
fi
```

* Suivi de la commande :

```{code-block}
> direnv allow
direnv: loading ~/ansible-workspaces/ultimate/training/.envrc
===> Getting goss:0.3.16:linux-amd64 (can take a while to execute)

> which goss
/home/user/ansible-workspaces/ultimate/training/.direnv/bin/goss
```

