#!/bin/bash

# Se déplacer à la racine du projet
ROOT_DIR=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -z "$ROOT_DIR" ]; then
    echo "Erreur : Tu dois être dans un dépôt Git."
    exit 1
fi
cd "$ROOT_DIR"

echo "--- Yocto Layers Status ---"

# On définit une fonction pour l'extraction
get_git_info() {
    # Nom du dossier (layer)
    local layer_name=$(basename "$1")
    
    # On entre dans le sous-module
    cd "$ROOT_DIR/$1" 2>/dev/null || return
    
    # Récupération du commit
    local commit=$(git rev-parse HEAD 2>/dev/null)
    
    # Récupération de la branche (si en HEAD détaché, on cherche le nom symbolique)
    local branch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$branch" == "HEAD" ]; then
        # Si on est sur un commit précis, on essaie de trouver une branche distante correspondante
        branch=$(git branch -a --contains HEAD | grep 'remotes/origin' | head -n 1 | sed 's|.*/||' || echo "detached")
    fi

    echo "$layer_name:"
    echo "  Branch: $branch"
    echo "  Commit: $commit"
}

# Export de la fonction pour qu'elle soit visible par 'git submodule'
export -f get_git_info
export ROOT_DIR

# Exécution propre
git submodule foreach --quiet 'get_git_info "$sm_path"'