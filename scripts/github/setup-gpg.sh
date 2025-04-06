#!/bin/bash

echo "🔐 Configurando GPG y firma de commits en Git..."

# Instalar GPG si no está
if ! command -v gpg &> /dev/null; then
  echo "📦 Instalando GPG con Homebrew..."
  brew install gnupg
fi

# Instalar pinentry para mac
if ! command -v pinentry-mac &> /dev/null; then
  echo "📦 Instalando pinentry-mac..."
  brew install pinentry-mac
fi

# Configurar gpg-agent
mkdir -p ~/.gnupg
echo "pinentry-program $(which pinentry-mac)" > ~/.gnupg/gpg-agent.conf
echo "use-agent" > ~/.gnupg/gpg.conf
chmod 600 ~/.gnupg/*
gpgconf --kill gpg-agent

# Mostrar claves y pedir selección
echo "🔎 Buscando claves GPG..."
gpg --list-secret-keys --keyid-format=long
echo ""
read -p "👉 Copia y pega el ID largo de tu clave GPG: " GPG_KEY

# Mostrar email actual de git
CURRENT_EMAIL=$(git config --global user.email || echo "(no configurado)")
echo "📧 Email de Git actual: $CURRENT_EMAIL"

# Preguntar por nuevo email
read -p "✉️  Introduce el email vinculado a esa clave GPG: " GIT_EMAIL
read -p "🧑 Nombre para usar en Git: " GIT_NAME

# Configurar Git
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global user.signingkey "$GPG_KEY"
git config --global commit.gpgSign true
git config --global gpg.program "$(which gpg)"

echo ""
echo "✅ Todo listo. Ya puedes firmar tus commits con:"
echo "  git commit -S -m 'Mensaje firmado'"