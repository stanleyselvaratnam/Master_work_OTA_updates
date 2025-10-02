# ===============================================================
# Recette BitBake pour l'application HelloWorld
# Cette recette va cloner le code depuis GitHub, compiler le binaire
# et l'installer dans /usr/bin de l'image Yocto.
# ===============================================================

# Brève description de la recette
SUMMARY = "Simple Hello World app"

# Licence du logiciel (BitBake exige de préciser la licence)
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=33ef8b00d7f1a720a56a6d80ab7358a1"



# URL du dépôt GitHub contenant le code source de l'application
# 'branch=main' spécifie la branche à utiliser
SRC_URI = "git://github.com/stanleyselvaratnam/HelloWorld.git;protocol=https;branch=main"
SRCREV = "AUTOINC"



# Répertoire où BitBake trouvera le code source après l'avoir cloné
S = "${WORKDIR}/git"

# ---------------------------------------------------------------
# Étape de compilation
# Utilise le cross-compiler fourni par BitBake
# ---------------------------------------------------------------
do_compile() {
    oe_runmake CC="${CC}" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

# ---------------------------------------------------------------
# Étape d'installation
# Installe le binaire dans l’arborescence temporaire BitBake
# ---------------------------------------------------------------
do_install() {
    oe_runmake install DESTDIR=${D}
}

# ---------------------------------------------------------------
# Indique à BitBake quels fichiers doivent être inclus dans le paquet
# Ici, on précise que le binaire ira dans /usr/bin/helloworld
# ---------------------------------------------------------------
FILES_${PN} = "/usr/bin/helloworld"
