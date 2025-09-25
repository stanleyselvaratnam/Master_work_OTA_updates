# Désactive gold et gprofng pour éviter le plantage sur aarch64
EXTRA_OECONF:append:armv8a = " --disable-gold --disable-gprofng"
