# Préparation

Bienvenue, nous allons passer de bons moments ensemble, autant se préparer à ce que tout
se déroule au mieux. Cette préparation trace le chemin d'emmerdement minimum pour te faciliter la vie
pour la suite.

Il y a trop de configurations de systèmes pour pouvoir couvrir tous les cas ici. Notre cas de 
référence sur Debian 11 n’est pas tiré de nulle part : cette configuration permet à de 
nombreux professionnels de gagner leur vie en étant productif au quotidien (Debian sur laptop, 
aujourd’hui ce n’est pas un problème).

## Freestyling

Pour réaliser les exercices qui vont suivre, il faut se procurer :

* un système Debian stable (11 à l'heure de la dernière modification)
* un terminal branché dessus avec un shell Bash
* un environnement de développement intégré ([IDE](https://fr.wikipedia.org/wiki/Environnement_de_d%C3%A9veloppement))
capable d'éditer des fichiers votre système Debian ([LunarVim](https://www.lunarvim.org/docs/installation), [VSCodium](https://vscodium.com/#install))

...tous les coups sont permis pour atteindre ces premiers critères.

```{admonition} Nota Bene
:class: tip

* Si vous êtes sous Ubuntu, les commandes sont valides également.
* Si vous n'utilisez pas Bash comme shell par défaut, reportez vous à la [doc de direnv](https://direnv.net/docs/hook.html)
pour l'intégrer à votre shell préféré.
* Si vous êtes sous Windows, un WSL bien configuré doit vous permettre de faire ça 
(n'hésitez pas à contribuer un guide en PR sur le projet).
* Si vous êtes sous OSX, vous pourriez être intéressé par le guide [](/howtos/prepare_osx.md)
```

## Figures imposées

Une fois votre système prêt, il faut y ajouter plusieurs paquets pour pouvoir travailler:

```shell session
echo "--- Installation des paquets apt nécessaires"
sudo apt update 
sudo apt-get install python3 python3-dev python3-venv python3-pip git direnv make bash curl
echo "--- Branchement de direnv dans la configuration bash de l'utilisateur"
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
echo "--- Rechargement de la configuration bash de l'utilisateur"
source ~/.bashrc
```


```{admonition} Note
:class: important

Il vous faudra également un démon Docker pour pouvoir exécuter les exercices qui concernent les tests
automatisés de code Ansible : 
* [Guide officiel d'installation de Docker](https://docs.docker.com/engine/install/debian/).
```


