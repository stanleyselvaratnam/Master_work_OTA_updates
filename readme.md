# Installation de Yocto avec docker

## Lancement du docker

```bash
cd yocto/
```

```bash
# Install docker
sudo dnf install docker

sudo systemctl enable docker  

sudo systemctl start docker  
# Add the docker group (it might be already exist):
sudo groupadd docker
# Add the connected user “$USER” to the docker group:
sudo gpasswd -a $USER docker
# Either do a newgrp docker or log out/in to activate the changes to groups:
newgrp docker
```

Lancement du docker
```bash
docker run --rm -it -v ~/Documents/TM/yocto:/workdir:Z crops/poky:ubuntu-22.04 --workdir=/workdir
```

## Installation de Yocto 

```bash
git clone git://git.yoctoproject.org/poky -b scarthgap

cd poky

# Modifier le local.conf
MACHINE = "genericarm64"
```
Création de l'image :
```bash
source oe-init-build-env build-generic-arm64

bitbake core-image-minimal
```

## Réparation du build Yocto pour ARM64 (binutils + GCC)

### Contexte
Lors de la compilation sur ARM64 avec Yocto, les erreurs suivantes apparaissaient :

- **Binutils 2.42** : `undefined reference to 'main'` lors de la compilation de `gold`/`dwp`.
- **GCC 13.4** : échec du build de `cc1` et `cc1plus` à cause d’un linker non fonctionnel.

Ces erreurs sont liées à la compilation de modules facultatifs (`gold` et `gprofng`) qui ne sont pas compatibles avec certaines versions de glibc et binutils.

---

### Étape 1 : Désactiver gold et gprofng

1. Dans ton **meta-layer**, crée le dossier pour la recette binutils :

```bash
mkdir -p meta-my-layer/recipes-devtools/binutils
````

2. Crée un fichier `.bbappend` pour binutils :

```bash
touch meta-my-layer/recipes-devtools/binutils/binutils_2.42.bbappend
```

3. Édite ce fichier et ajoute :

```bitbake
# Désactive gold et gprofng pour éviter le plantage sur ARM64
EXTRA_OECONF:append:armv8a = " --disable-gold --disable-gprofng"
```

---

### Étape 2 : Recompiler binutils

```bash
bitbake binutils -c cleanall
bitbake binutils
```

Vérifie que binutils fonctionne correctement :

```bash
armv8a-poky-linux-ld --version
```

---

### Étape 3 : Recompiler GCC

Une fois binutils fonctionnel, reconstruis GCC :

```bash
bitbake gcc -c cleanall
bitbake gcc
```


Et maintenant la génération d'image fonctionne :

```bash
bitbake core-image-minimal
# or
bitbake core-image-full-cmdline

```


## Add Mender

```bash
# Dans le dossier racine du projet (dockyocto)
git clone https://github.com/mendersoftware/meta-mender.git
```
Ajouter les layers dans bblayers.conf :

```bash
# POKY_BBLAYERS_CONF_VERSION is increased each time build/conf/bblayers.conf
# changes incompatibly
POKY_BBLAYERS_CONF_VERSION = "2"

BBPATH = "${TOPDIR}"
BBFILES ?= ""

BBLAYERS ?= " \
    ${TOPDIR}/../meta \
    ${TOPDIR}/../meta-poky \
    ${TOPDIR}/../meta-yocto-bsp \
    ${TOPDIR}/../../meta-mender/meta-mender-core \
    ${TOPDIR}/../../meta-mender/meta-mender-qemu \
    ${TOPDIR}/../../meta-mender/meta-mender-demo \
  "

```

Puis ajouter dans local.conf :

```bash
# Incorpore Mender Client

# Add systemd like init system
DISTRO_FEATURES:append = " systemd"
VIRTUAL-RUNTIME_init_manager = "systemd"
DISTRO_FEATURES_BACKFILL_CONSIDERED = "sysvinit"
VIRTUAL-RUNTIME_initscripts = ""

# Include the Yocto class usefull for generate the partitions A/B, the mender-client and the scripts for OTA updates
INHERIT += "mender-full"

# Mender create à .mender file for update
MENDER_ARTIFACT_NAME = "release-1"


MENDER_SERVER_URL = "https://eu.hosted.mender.io/"
MENDER_TENANT_TOKEN = "AVi5j0YkJYNeYRamqwzY2r9WRz3sJo5nbGDGaE0uXtQ"

# Définir le périphérique de stockage pour Mender
# /dev/vda pour QEMU, /dev/sda pour machine réelle
MENDER_STORAGE_DEVICE = "/dev/vda"
MENDER_BOOT_PART_SIZE_MB = "64"
MENDER_DATA_PART_SIZE_MB = "1024"
```