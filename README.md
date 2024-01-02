# 🐳 Whanos Projet.

Whanos est un projet permettant le déploiement automatique de projets, dans un certain nombre de langages, via une interface.

## 🤔 Principe

Le principe est donc de cloner un projet sur un projet Git, ensuite détecter le langage de ce dernier et en faire en image Docker, Standalone ou Base, pour ainsi conteneuriser le projet et pouvoir le déployer plus facilement, idéalement sur un cluster Kubernetes.

# 🔑 Prérequis

Pour pouvoir faire tourner notre instance de projet Whanos, il est nécessaire d'avoir ces dépendances d'installées:
 - <b>Jenkins</b>
 - <b>Docker</b>
 </br> </br>

Il est également important de noter que le projet Whanos est uniquement compatible avec les langages suivants:

![C](https://img.shields.io/badge/c-%2300599C.svg?style=for-the-badge&logo=c&logoColor=white)
![JavaScript](https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E)

![Java](https://img.shields.io/badge/java-%23ED8B00.svg?style=for-the-badge&logo=openjdk&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)

![TypeScript](https://img.shields.io/badge/typescript-%23007ACC.svg?style=for-the-badge&logo=typescript&logoColor=white)

<b>Et aussi du Befunge :)</b>

Veuillez vous réferer à la section "*<u><b>Architecture d'un projet</b></u>*" pour vérifier que votre architecture de projet est compatible.


- ## <u>Jenkins</u>
Voici la doc pour l'installer: <br>
https://www.jenkins.io/doc/book/installing/

Il est aussi nécessaire de bien configurer <b>l'admin</b>, ainsi que d'installer <b><u>tout</u></b> ces plugins:

<b>

```cloudbees-folder, configuration-as-code, credentials, github, instance -identity, job-dsl, structs, role-strategy and ws-cleanup, role-strategy, parameterized-trigger.```

</b>

*Sans ces plugins, l'instance ne pourra pas tourner. En cas d'erreur, veuillez vous référez aux logs internes de Jenkins (manage Jenkins/logs).*


- ## <u>Docker</u>
Autre instance nécessaire, Docker. Cela est indispensable pour conteneuriser les projets et en faire des images.

Pour l'installer, suis l'installation: <br>
(https://docs.docker.com/engine/install/fedora/)

<br>

Une fois ces dépendances installées, vous pouvez continuer.

# 1 - 📦 Docker

Pour pouvoir faire tourner notre instance de Whanos et pouvoir utiliser Docker pour la conteneurisation, il faudra effectuer ses commandes. Sans cela, l'instance pourrait avoir des problèmes.

```sh
docker stop registry

docker rm registry

docker run -d -p 5001:5000 --restart=always --name registry registry:2
```

Cela permettra à Docker de pouvoir écouter/utiliser le port 5001

Veuillez ensuite laisser votre Docker/Docker Desktop tourner en arrière-plan.

# 2 - ⚙️ Jenkins

Une fois jenkins installé, lancez jenkins avec la commande:<br>

```sh
jenkins 8080
```
<br>
Cela vous permettra d'accéder à l'interface de jenkins, sur le port 8080 de votre machine.

<h6>❗️ À noter que vous pouvez changer de port si vous le souhaitez, mais veuillez à configurer tout ce qui écoute sur le port 8080 par défaut sur votre nouveau port.</h6>

Ensuite, faite l'installation par défaut. Une fois cela fait, il est important de vérifier que tout les plugins sont correctement installer. (*Notamment JCASC - Jenkins Configuration As Code*).<br><br>


### 🗄️ Variables à changer

Avant de pouvoir charger le script, vous devrez changer deux variables, vous permettant d'indiquer le chemin relative de votre projet.

Il faudra donc changer <u>les variables "BASE_DIR" dans le fichier:</u><br>
```sh
jenkins/find_langage.sh
```
<br>
ainsi que le fichier<br><br>

```sh
jenkins/jod_dsl.groovy.
```
Il faut aussi changer le chemin à la ligne <b>102</b> du fichier.
</u>

<u>Il faudra également changer le chemin d'accès pour le job_dsl.groovy dans</u>:
```sh
jenkins/config.yml
```
Sans changer cela, le projet ne pourrait pas fonctionner correctement.

Une fois ici, accéder à la page JCASC de votre interface jenkins, et charger votre script (en mettant le chemin relatif)

Cela chargera les différents jobs et vous permettra de commencer à utiliser les principales fonctionnalités du projet whanos.

Si vous avez une erreur ou autre, veuillez vous référer aux logs internes à Jenkins (manage jenkins/logs).


# 2.1 - ⚙️ Jenkins | Link un projet

Pour pouvoir cloner un repo github, il faudra utiliser le jobs "*<b><u>link-projet</b></u>*".
Il faudra renseigner l'url du repo github dans <b>GITHUB_URL</b> (A noter que ce dernier doit être un repo publique), ainsi qu'un nom d'affichage, à renseigner dans <b>DISPLAY_NAME</b>
C'est avec ce nom que le dossier du projet sera cloner.

Ensuite lancer un build, et si cela est réussi, un projet sera créer dans le dossier "<b>Projet</b>", portant le nom du champ précèdent.

## 2.2 - ⚙️ Jenkins | Build et compiler un projet.

Une fois le build lancé, cela détectera automatiquement le langage utilisé, parmi ceux supportés.
Cela ira build une image standalone si le projet le contient pas de fichier Dockerfile.base, dans un but de conteneuriser le projet en question.

Dans le cas ou votre projet est en <b>standalone</b>, vous pouvez tester le projet dans le container en questions, via la commande:

```sh
docker run -it localhost:PORT/whanos-LANGAGE
```
Voic un exemple:

```
docker run -it localhost:5001/whanos-c
```

## 2.3 - ⚙️ Jenkins | Build toutes les images

Pour build toutes les images en un seul job, vous pouvez utiliser le job "<u><b>Build all base image</b></u>".

## 2.4 - ⚙️ Jenkins | Build toutes les images individuellement

Pour build les images individuellement, vous pouvez utiliser les jobs correspondant au langage voulus dans le dossier *"<u><b>Whanos base images</b></u>"*


# 3 - 📂 Arthictecture d'un projet

Pour pouvoir compiler un projet dans un langage supporté, il faudra impérativement respecter une architecture:

- <b>Un dossier app:</b> avec tous les fichiers du projet à compiler
- <b>Une directive de compilation/fichier de config:</b> Makefile, package.json, requirements.txt, etc..</br></br>

Voici les architectures à respecter:<br>

### <u>En C</u> :

```sh
.
├── Makefile
└── app
    └── hello.c
```
### <u>En Javascript</u> :

```sh
.
├── app
│   └── app.js
├── package-lock.json
└── package.json
```

### <u>En Java</u> :
```sh
.
└── app
    ├── pom.xml
    └── src
        ├── main
        │   └── java
        │       └── eu
        │           └── epitech
        │               └── App.java
        └── test
            └── java
                └── eu
                    └── epitech
                        └── AppTest.java
```

### <u>En python</u> :
```sh
.
├── app
│   ├── __init__.py
│   └── __main__.py
└── requirements.txt
```

### <u>En typescript</u> :
```sh
.
├── Dockerfile
├── app
│   └── app.ts
├── package-lock.json
├── package.json
├── tsconfig.json
└── whanos.yml
```
</br>
Toute autre architecture pourrait causer des problèmes de compilation et/ou d'utilisation.

### À noter que si votre projet doit avoir des dépendances en plus que ce que l'image du langage propose, il devra être obligatoire de fournir un fichier <u>Dockerfile.base</u>, pour ainsi build une image base avec toutes les dépendances requises. <br><br> ❗️ Il doit être à la racine du projet

Voici l'exemple d'un fichier  pour build un projet en typescript:

### Si vous souhaitez déployer votre projet sur un cluster kubernetes il est important de fournir une fichier <u>whanos.yml</u> à la racine du projet.</br></br>

Il doit <b>absolument</b> contenir ces infos:

- replicas
- ressources
- ports

Sans ces infos, le projet pourrait avoir des difficultés pour être déployé sur un cluster kubernetes.</br></br>


Voici un exemple de fichier whanos.yml pour un projet en Typescript:

```yml
deployment:
  replicas: 3
  resources:
    limits:
      memory: "128M"
    requests:
      memory: "64M"
  ports:
    - 3000
```
