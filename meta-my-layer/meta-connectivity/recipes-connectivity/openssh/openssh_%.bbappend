# Ajouter le chemin vers notre fichier
FILESEXTRAPATHS:prepend := "${THISDIR}/openssh:"

# Ajouter le fichier sshd_config personnalisé
SRC_URI += "file://sshd_config"

# Installer le fichier à la place de celui du système
do_install:append() {
    install -d ${D}/etc/ssh
    install -m 600 ${WORKDIR}/sshd_config ${D}/etc/ssh/sshd_config
}
