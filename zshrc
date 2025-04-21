# ── OH MY ZSH ─────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting jump zsh-kitty)
source $ZSH/oh-my-zsh.sh

# ── PATHS ─────────────────────────────────────────────────────────────
export PATH="$PATH:/home/ilelo/.spicetify"
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
export PATH_TO_FX=/home/ilelo/open-jfx/javafx-sdk-17.0.15/lib
export GTK_THEME=WhiteSur-Dark

# ── NVM ───────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ── ALIASES ───────────────────────────────────────────────────────────

# Zsh & Configs
alias reload="source ~/.zshrc && kitty-reload"
alias editZsh="code ~/.zshrc"
alias catZsh="cat ~/.zshrc"

# Configs específicos
alias editKitty="code ~/.config/kitty/kitty.conf"
alias editPicom="code ~/.config/picom/picom.conf"

# Sistema & Utilitários
alias restart="sudo reboot"
alias o="xdg-open"
alias r="rm -rf"
alias sudo="sudo "
alias t2="touch"
alias cls="clear"

# Git
alias gP="git push -u origin main"

# Banco de Dados
alias mysqlConnect="mysql -uroot -p"

# Terminal
alias nt='kitty @ launch --type=tab --cwd=current'

# ── FUNÇÕES ───────────────────────────────────────────────────────────

# Copy file contents to clipboard (visual feedback)
cpcat() {
  if [ -f "$1" ]; then
    kitty +kitten clipboard < "$1"
    echo "📋 File '$1' copied to clipboard!"
  else
    echo "❌ File not found: $1"
  fi
}

# ── ATALHOS ÚTEIS ─────────────────────────────────────────────────────

# Atualizar sistema (apt + flatpak)
alias update="sudo apt update && sudo apt upgrade -y && flatpak update -y"

# Reiniciar GNOME (caso necessário)
alias restart-gnome="gnome-shell --replace & disown"

# Ver IP local e externo
alias myip="echo 'Local: '; hostname -I | awk '{print \$1}'; echo 'Externo: '; curl -s ifconfig.me"

# Buscar no histórico com FZF
alias hf="history | fzf"

# ── FUNÇÕES POWER-UP ─────────────────────────────────────────────

# 1. Ver imagens direto no terminal (usa o icat do Kitty)
alias see="kitty +kitten icat"

# 3. Fuzzy Search no histórico do terminal (Kitty + Ctrl+Shift+F já tem, mas aqui é reforço)
# ⚠️ Nada pra adicionar — só lembrar de usar Ctrl+Shift+F no próprio terminal

# 4. Git diff bonito com Delta (instale com: sudo apt install git-delta)
git config --global core.pager "delta"

# 5. Visualizar arquivos com preview colorido e numerado (requer bat: sudo apt install bat)
alias preview="bat --style=numbers --theme=OneHalfDark"

# 6. Criar pasta e já entrar nela
mkcd() {
  mkdir -p "$1" && cd "$1"
}

