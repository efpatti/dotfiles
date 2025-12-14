# ── OH MY ZSH ─────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster" # set by `omz`
plugins=(git zsh-autosuggestions zsh-syntax-highlighting jump zsh-kitty gitignore clipboard spotify-zsh volume html-minifier)

source $ZSH/oh-my-zsh.sh

# ── PATHS ─────────────────────────────────────────────────────────────
# Programas e Variáveis de Ambiente
export JAVA_HOME="/usr/lib/jvm/temurin-11-jdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"
export PATH_TO_FX="/home/ilelo/open-jfx/javafx-sdk-17.0.15/lib"
export GTK_THEME="WhiteSur-Dark"

# ── Lazy Loading - Pyenv ──────────────────────────────
pyenv() {
  unset -f pyenv
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(command pyenv init --path)"
  eval "$(command pyenv init -)"
  eval "$(command pyenv virtualenv-init -)"
  pyenv "$@"
}

python() {
  # Use local .venv if it exists and we're in a venv
  if [[ -d ".venv" && -n "$VIRTUAL_ENV" ]]; then
    ".venv/bin/python" "$@"
  else
    if ! command -v pyenv &> /dev/null; then
      pyenv
    fi
    command python3 "$@"
  fi
}

python3() {
  # Use local .venv if it exists and we're in a venv
  if [[ -d ".venv" && -n "$VIRTUAL_ENV" ]]; then
    ".venv/bin/python3" "$@"
  else
    if ! command -v pyenv &> /dev/null; then
      pyenv
    fi
    command python3 "$@"
  fi
}

pip() {
  # Use local .venv if it exists and we're in a venv
  if [[ -d ".venv" && -n "$VIRTUAL_ENV" ]]; then
    ".venv/bin/pip" "$@"
  else
    if ! command -v pyenv &> /dev/null; then
      pyenv
    fi
    command pip3 "$@"
  fi
}

# Lazy Loading - NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

node() {
  unset -f node
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  node "$@"
}


npm() {
  unset -f npm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  npm "$@"
}


# ── ALIASES ───────────────────────────────────────────────────────────
# Zsh & Configs
alias reload="source ~/.zshrc && kitty-reload"
alias reloadVscode='code -r "$PWD"'
alias editZsh="code ~/.zshrc"
alias catZsh="cat ~/.zshrc"
alias copyZsh="cpcat ~/.zshrc"
alias getStatus="git status > status.txt && cpcat status.txt && r status.txt"

alias getDiffCached="git diff --cached > diff.txt && cpcat diff.txt && r diff.txt"
alias getDIff="git diff > diff.txt && cpcat diff.txt && r diff.txt"
alias getShow="git show > show.txt && cpcat show.txt && r show.txt"
alias vpn_connect="openvpn3 session-start --config configMottu"
alias list_vpn="openvpn3 sessions-list"
alias wps='nohup et >/dev/null 2>&1 &'
alias killPostman='pkill -f postman && echo "🧨 Postman finalizado com sucesso!" || echo "❌ Nenhum processo do Postman encontrado."'
alias killport='sudo fuser -k'


# Configurações específicas
alias editKitty="code ~/.config/kitty/kitty.conf"
alias editPicom="code ~/.config/picom/picom.conf"
alias copy="clipcopy"

vscode_usage() {
  ps -C code -o pid,%cpu,%mem,cmd --no-headers \
    | awk '{cpu+=$2; mem+=$3} END {printf "CPU: %.2f%%  MEM: %.2f%%\n", cpu, mem}'
}

# Configurações ODBC Simba
alias catSimbaodbc="cat /etc/odbc.ini"
alias catSimbaodbcInit="cat /etc/odbcinst.ini"
alias editSimbaodbc="code /etc/odbc.ini"
alias editSimbaodbcInit="code /etc/odbcinst.ini"
alias editSimbaGoogleOdbcInit="code /etc/simba.googlebigqueryodbc.ini"
alias catSimbaGoogleOdbcInit="cat /etc/simba.googlebigqueryodbc.ini"
export SIMBA_GOOGLE_BIGQUERY_ODBC_INI=/etc/simba.googlebigqueryodbc.ini
export LD_LIBRARY_PATH=/opt/simba/googlebigqueryodbc/lib:$LD_LIBRARY_PATH

# Sistema & Utilitários
alias restart="sudo reboot"
alias o="xdg-open"
alias r="rm -rf"
alias sudo="sudo "  # mantém o espaço para evitar problemas ao expandir aliases
alias t2="touch"
alias cls="clear"

# Git
alias gP="git push -u origin main"
alias gls='git log --pretty=format:"%h %s"'
alias gcdf="git clean -d -f"

# Banco de Dados
alias mysqlConnect="mysql -uroot -p"

# Terminal (Kitty)
alias nt='kitty @ launch --type=tab --cwd=current'

# Kill
alias killOutlook='pkill -f outlook-for-lin'
alias killTeams="pkill -f teams-for-linux"
# ── FUNÇÕES ───────────────────────────────────────────────────────────

# Toggle Mail Catcher - FUNÇÃO
toggleMailCatcher() {
  if pgrep -f "mailcatcher" > /dev/null; then
    echo "🛑 Parando MailCatcher..."
    killall -9 mailcatcher 2>/dev/null
    sleep 2
    if pgrep -f "mailcatcher" > /dev/null; then
        echo "❌ Forçando parada..."
        pkill -9 -f mailcatcher
        sudo fuser -k 1025/tcp 2>/dev/null
    fi
    echo "✅ MailCatcher parado!"
  else
    echo "🚀 Iniciando MailCatcher..."
    mailcatcher --ip=0.0.0.0
    echo "✅ MailCatcher iniciado! Acesse: http://localhost:1080"
  fi
}

# Get status from MailCatcher
statusMailCatcher() {
  if pgrep -f "mailcatcher" > /dev/null; then
    local pid=$(pgrep -f "mailcatcher")
    local port=$(ss -ltnp 2>/dev/null | grep "$pid" | awk '{print $4}' | awk -F: '{print $NF}' | head -n1)
    echo "✅ MailCatcher está rodando (PID: $pid, Porta: ${port:-desconhecida})"
    echo "   Acesse: http://localhost:1080"
  else
    echo "❌ MailCatcher não está rodando"
  fi
}


# Copiar conteúdo de arquivos para o clipboard (com feedback visual)
cpcat() {
  if [ -f "$1" ]; then
    kitty +kitten clipboard < "$1"
    echo "📋 File '$1' copied to clipboard!"
  else
    echo "❌ File not found: $1"
  fi
}

# Criar pasta e já entrar nela
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# ── ATALHOS ÚTEIS ─────────────────────────────────────────────────────
# Atualizar sistema (APT + Flatpak)
alias update="sudo apt update && sudo apt upgrade -y && flatpak update -y"

# Reiniciar GNOME
alias restart-gnome="gnome-shell --replace & disown"

# Ver IP local e externo
alias myip="echo 'Local: '; hostname -I | awk '{print \$1}'; echo 'Externo: '; curl -s ifconfig.me"

# Buscar no histórico com FZF
alias hf="history | fzf"

# ── FERRAMENTAS POWER-UP ──────────────────────────────────────────────
# Visualizar imagens no terminal (Kitty)
alias see="kitty +kitten icat"

# Git diff bonito com Delta
git config --global core.pager "delta"

# Visualizar arquivos com preview colorido (BAT)
alias preview="bat --style=numbers --theme=OneHalfDark"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/ilelo/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/home/ilelo/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/ilelo/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/ilelo/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="$HOME/.spicetify:$PATH"

# Load persisted Mottu tokens (if any)
if [ -f "$HOME/.mottu_tokens" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.mottu_tokens"
fi


# ── MOTTU TOKEN MANAGEMENT ────────────────────────────────────────────
# Token Mottu (geração via script)
generate_token_and_export() {
  local stage="$1"
  local script_path="$HOME/Documents/scripts/generate-token-mottu/script.py"
  if [ ! -f "$script_path" ]; then
    echo "script not found: $script_path" >&2
    return 2
  fi

  token=$(/home/ilelo/Documents/scripts/generate-token-mottu/.venv/bin/python "$script_path" --stage "$stage")
  if [ $? -ne 0 ] || [ -z "$token" ]; then
    echo "failed to generate token for $stage" >&2
    return 1
  fi

  # Persist token to file with restricted permissions so new shells can source it
  token_file="$HOME/.mottu_tokens"
  touch "$token_file"
  chmod 600 "$token_file"

  # Replace or add the corresponding export line in the token file
  if [ "$stage" = "homolog" ]; then
    if grep -q '^export token_mottu_homolog=' "$token_file" 2>/dev/null; then
      sed -i "/^export token_mottu_homolog=/c\export token_mottu_homolog=\"$token\"" "$token_file"
    else
      echo "export token_mottu_homolog=\"$token\"" >> "$token_file"
    fi
  else
    if grep -q '^export token_mottu_prod=' "$token_file" 2>/dev/null; then
      sed -i "/^export token_mottu_prod=/c\export token_mottu_prod=\"$token\"" "$token_file"
    else
      echo "export token_mottu_prod=\"$token\"" >> "$token_file"
    fi
  fi
  chmod 600 "$token_file"
  # shellcheck source=/dev/null
  source "$token_file"
  echo "token_$stage set and persisted to $token_file"
}

clearTokenMottu() {
  token_file="$HOME/.mottu_tokens"
  if [ -f "$token_file" ]; then
    rm -f "$token_file"
  fi
  unset token_mottu_prod token_mottu_homolog
  echo "mottu tokens cleared"
}

alias generateTokenHomolog="generate_token_and_export homolog"
alias generateTokenProd="generate_token_and_export prod"

# Funções diretas para gerar token e copiar para clipboard
tokenHomolog() {
  local script_path="$HOME/Documents/scripts/generate-token-mottu/script.py"
  if [ ! -f "$script_path" ]; then
    echo "❌ Script not found: $script_path" >&2
    return 2
  fi

  token=$(/home/ilelo/Documents/scripts/generate-token-mottu/.venv/bin/python "$script_path" --stage homolog)
  if [ $? -ne 0 ] || [ -z "$token" ]; then
    echo "❌ Failed to generate homolog token" >&2
    return 1
  fi

  echo "$token" | clipcopy
  echo "📋 Homolog token copied to clipboard!"
}

tokenProd() {
  local script_path="$HOME/Documents/scripts/generate-token-mottu/script.py"
  if [ ! -f "$script_path" ]; then
    echo "❌ Script not found: $script_path" >&2
    return 2
  fi

  token=$(/home/ilelo/Documents/scripts/generate-token-mottu/.venv/bin/python "$script_path" --stage prod)
  if [ $? -ne 0 ] || [ -z "$token" ]; then
    echo "❌ Failed to generate prod token" >&2
    return 1
  fi

  echo "$token" | clipcopy
  echo "📋 Prod token copied to clipboard!"
}

get_kpis() {
    local script_path="$HOME/Documents/scripts/generate-kpis-bonus/main.py"
    local script_dir="$HOME/Documents/scripts/generate-kpis-bonus"
    
    if [ ! -f "$script_path" ]; then
        echo "❌ Script not found: $script_path" >&2
        return 2
    fi

    echo "🔄 Gerando relatório de KPIs..."
    
    # Executa o script Python
    /home/ilelo/Documents/scripts/generate-kpis-bonus/.venv/bin/python "$script_path"
    
    if [ $? -ne 0 ]; then
        echo "❌ Failed to generate KPIs report" >&2
        return 1
    fi

    # Procura pelo arquivo recém-criado no diretório do script
    local output_file=$(find "$script_dir" -name "relatorio_kpis_com_bonus.md" -type f -newer "$script_path" 2>/dev/null | head -1)
    
    if [ -z "$output_file" ]; then
        # Fallback: tenta o caminho padrão
        output_file="$script_dir/relatorio_kpis_com_bonus.md"
    fi

    if [ -f "$output_file" ]; then
        cpcat "$output_file"
        echo "📋 KPIs bonification report copied to clipboard!"
    else
        echo "❌ Output file not found: $output_file" >&2
        return 1
    fi
}

# ── CODE SUGGESTIONS MANAGER ──────────────────────────────────────────
codeSuggestions() {
  local SETTINGS="$HOME/.config/Code/User/settings.json"
  
  if [[ ! -f "$SETTINGS" ]]; then
    echo "❌ VSCode settings file not found: $SETTINGS"
    return 1
  fi
    
  declare -A KEYS=(
    [copilot_enable]="github.copilot.enable"
    [copilot_code]="github.copilot.enableCodeSuggestions"
    [copilot_next]="github.copilot.nextEditSuggestions.enabled"
    [copilot_inline]="github.copilot.inlineSuggest.enable"
    [editor_inline]="editor.inlineSuggest.enabled"
    [gemini_enable]="geminicodeassist.enable"
    [gemini_code]="geminicodeassist.editSuggestions.enabled"
    [gemini_next]="geminicodeassist.nextEditSuggestions.enabled"
    [gemini_inline]="geminicodeassist.inlineSuggestions.enableAuto"
  )
  
  declare -A LABELS=(
    [copilot_enable]="Copilot General Enable"
    [copilot_code]="Copilot Code Suggestions"
    [copilot_next]="Copilot Next Suggestions"
    [copilot_inline]="Copilot Inline Suggest"
    [editor_inline]="Editor Inline Suggest (Global)"
    [gemini_enable]="Gemini General Enable"
    [gemini_code]="Gemini Code Suggestions"
    [gemini_next]="Gemini Next Suggestions"
    [gemini_inline]="Gemini Inline Suggestions"
  )

  set_suggestion() {
    local key="$1"
    local value="$2"
    
    cp "$SETTINGS" "$SETTINGS.backup.$(date +%s)" 2>/dev/null
    
    if [[ "$key" == "github.copilot.enable" ]]; then
      python3 -c "
import json
import re

def remove_json_comments(text):
    lines = []
    for line in text.split('\n'):
        in_string = False
        escaped = False
        comment_pos = -1
        
        for i, char in enumerate(line):
            if escaped:
                escaped = False
                continue
            if char == '\\\\':
                escaped = True
                continue
            if char == '\"' and not escaped:
                in_string = not in_string
                continue
            if not in_string and i < len(line) - 1 and line[i:i+2] == '//':
                comment_pos = i
                break
        
        if comment_pos >= 0:
            line = line[:comment_pos].rstrip()
        lines.append(line)
    
    return '\n'.join(lines)

try:
    with open('$SETTINGS', 'r') as f:
        content = f.read()
    
    clean_content = remove_json_comments(content)
    data = json.loads(clean_content)
    
    value = '$value' == 'true'
    
    if '$key' in data:
        if isinstance(data['$key'], dict):
            data['$key']['*'] = value
        else:
            data['$key'] = {'*': value}
    else:
        data['$key'] = {'*': value}
    
    with open('$SETTINGS', 'w') as f:
        json.dump(data, f, indent=1)
    
    print('✅ Updated $key.* to $value')
except Exception as e:
    print(f'❌ Error updating $key: {e}')
"
    else
      python3 -c "
import json
import re

def remove_json_comments(text):
    lines = []
    for line in text.split('\n'):
        in_string = False
        escaped = False
        comment_pos = -1
        
        for i, char in enumerate(line):
            if escaped:
                escaped = False
                continue
            if char == '\\\\':
                escaped = True
                continue
            if char == '\"' and not escaped:
                in_string = not in_string
                continue
            if not in_string and i < len(line) - 1 and line[i:i+2] == '//':
                comment_pos = i
                break
        
        if comment_pos >= 0:
            line = line[:comment_pos].rstrip()
        lines.append(line)
    
    return '\n'.join(lines)

try:
    with open('$SETTINGS', 'r') as f:
        content = f.read()
    
    clean_content = remove_json_comments(content)
    data = json.loads(clean_content)
    
    data['$key'] = '$value' == 'true'
    
    with open('$SETTINGS', 'w') as f:
        json.dump(data, f, indent=1)
    
    print('✅ Updated $key to $value')
except Exception as e:
    print(f'❌ Error updating $key: {e}')
"
    fi
  }

  get_suggestion() {
    local key="$1"
    
    if [[ "$key" == "github.copilot.enable" ]]; then
      python3 -c "
import json
import re

def remove_json_comments(text):
    lines = []
    for line in text.split('\n'):
        in_string = False
        escaped = False
        comment_pos = -1
        
        for i, char in enumerate(line):
            if escaped:
                escaped = False
                continue
            if char == '\\\\':
                escaped = True
                continue
            if char == '\"' and not escaped:
                in_string = not in_string
                continue
            if not in_string and i < len(line) - 1 and line[i:i+2] == '//':
                comment_pos = i
                break
        
        if comment_pos >= 0:
            line = line[:comment_pos].rstrip()
        lines.append(line)
    
    return '\n'.join(lines)

try:
    with open('$SETTINGS', 'r') as f:
        content = f.read()
    
    clean_content = remove_json_comments(content)
    data = json.loads(clean_content)
    
    if '$key' in data and isinstance(data['$key'], dict):
        print(str(data['$key'].get('*', '')).lower())
    elif '$key' in data:
        print(str(data['$key']).lower())
    else:
        print('')
except:
    print('')
"
    else
      python3 -c "
import json
import re

def remove_json_comments(text):
    lines = []
    for line in text.split('\n'):
        in_string = False
        escaped = False
        comment_pos = -1
        
        for i, char in enumerate(line):
            if escaped:
                escaped = False
                continue
            if char == '\\\\':
                escaped = True
                continue
            if char == '\"' and not escaped:
                in_string = not in_string
                continue
            if not in_string and i < len(line) - 1 and line[i:i+2] == '//':
                comment_pos = i
                break
        
        if comment_pos >= 0:
            line = line[:comment_pos].rstrip()
        lines.append(line)
    
    return '\n'.join(lines)

try:
    with open('$SETTINGS', 'r') as f:
        content = f.read()
    
    clean_content = remove_json_comments(content)
    data = json.loads(clean_content)
    print(str(data.get('$key', '')).lower())
except:
    print('')
"
    fi
  }

  show_status() {
    local filter="$1"
    local keys_to_show=()
    
    case "$filter" in
      "copilot")
        keys_to_show=("copilot_enable" "copilot_code" "copilot_next" "copilot_inline")
        echo ""
        echo "🤖 ── Copilot Suggestions Status ──────────────────"
        ;;
      "gemini")
        keys_to_show=("gemini_enable" "gemini_code" "gemini_next" "gemini_inline")
        echo ""
        echo "💎 ── Gemini Suggestions Status ───────────────────"
        ;;
      "editor")
        keys_to_show=("editor_inline")
        echo ""
        echo "📝 ── Editor Global Settings ──────────────────────"
        ;;
      *)
        keys_to_show=("copilot_enable" "copilot_code" "copilot_next" "copilot_inline" "editor_inline" "gemini_enable" "gemini_code" "gemini_next" "gemini_inline")
        echo ""
        echo "⚙️  ── Code Suggestions Status ────────────────────"
        ;;
    esac
    
    for k in "${keys_to_show[@]}"; do
      local val=$(get_suggestion "${KEYS[$k]}")
      local sug_state="❌ OFF"
      [[ "$val" == "true" ]] && sug_state="✅ ON"
      [[ -z "$val" ]] && sug_state="⭕ NOT SET"
      printf "   %-30s: %s\n" "${LABELS[$k]}" "$sug_state"
    done
    echo ""
  }

  show_help() {
    cat << 'EOF'

🚀 ── Code Suggestions Manager ────────────────────────────────────────

📊 STATUS COMMANDS:
   codeSuggestions status                    # Show all suggestions status
   codeSuggestions status copilot            # Show only Copilot status  
   codeSuggestions status gemini             # Show only Gemini status
   codeSuggestions status editor             # Show editor global settings

⚙️  CONTROL COMMANDS:
   codeSuggestions all on/off                # Enable/disable everything
   codeSuggestions copilot on/off            # Control Copilot suggestions
   codeSuggestions gemini on/off             # Control Gemini suggestions

🔧 EXAMPLES:
   codeSuggestions copilot off               # Disable Copilot completely
   codeSuggestions all off                   # Disable all AI suggestions
   codeSuggestions status                    # Check current status

⚡ QUICK ALIASES:
   csStatus    # Show status           csOn/csOff     # Toggle all
   csCopilot   # Copilot status        csGemini       # Gemini status
   csDashboard # Visual dashboard

💡 TIP: Settings are automatically backed up before changes!

EOF
  }

  case "$#" in
    0)
      show_help
      return 0
      ;;
    1)
      case "$1" in
        "status")
          show_status
          return 0
          ;;
        "help"|"-h"|"--help")
          show_help
          return 0
          ;;
        *)
          echo "❌ Invalid argument: $1"
          show_help
          return 1
          ;;
      esac
      ;;
    2|3)
      local should_reload=false
      if [[ "$#" -eq 3 && "$3" == "--reload" ]]; then
        should_reload=true
      fi
      
      case "$1" in
        "status")
          if [[ "$2" =~ ^(copilot|gemini|editor)$ ]]; then
            show_status "$2"
            return 0
          else
            echo "❌ Invalid status filter: $2 (use: copilot|gemini|editor)"
            return 1
          fi
          ;;
        "all")
          if [[ "$2" =~ ^(on|off)$ ]]; then
            local newval="false"
            local action_text="🔴 Disabling"
            [[ "$2" == "on" ]] && { newval="true"; action_text="🟢 Enabling"; }
            
            echo "$action_text all code suggestions..."
            echo ""
            
            local success_count=0
            for k in "copilot_enable" "copilot_code" "copilot_next" "copilot_inline" "editor_inline" "gemini_enable" "gemini_code" "gemini_next" "gemini_inline"; do
              if set_suggestion "${KEYS[$k]}" "$newval"; then
                ((success_count++))
              fi
            done
            
            echo ""
            echo "✨ Successfully updated $success_count/9 settings"
            if [[ "$should_reload" == true ]]; then
              echo "🔄 Reloading VSCode windows..."
              pkill -f "code.*--wait" 2>/dev/null || true
              sleep 1
              code --command workbench.action.reloadWindow 2>/dev/null &
              echo "✅ VSCode reload triggered"
            else
              echo "🔄 Restart VSCode to apply changes (use --reload flag for auto-reload)"
            fi
            return 0
          else
            echo "❌ Invalid action: $2 (use: on|off)"
            return 1
          fi
          ;;
        "copilot"|"gemini")
          if [[ "$2" =~ ^(on|off)$ ]]; then
            local newval="false"
            local action_text="🔴 Disabling"
            [[ "$2" == "on" ]] && { newval="true"; action_text="🟢 Enabling"; }
            
            echo "$action_text $1 suggestions..."
            echo ""
            
            if [[ "$1" == "copilot" ]]; then
              set_suggestion "${KEYS[copilot_enable]}" "$newval"
              set_suggestion "${KEYS[copilot_code]}" "$newval"
              set_suggestion "${KEYS[copilot_next]}" "$newval"
              set_suggestion "${KEYS[copilot_inline]}" "$newval"
            else
              set_suggestion "${KEYS[gemini_enable]}" "$newval"
              set_suggestion "${KEYS[gemini_code]}" "$newval"
              set_suggestion "${KEYS[gemini_next]}" "$newval"
              set_suggestion "${KEYS[gemini_inline]}" "$newval"
            fi
            
            echo ""
            echo "✨ $1 suggestions updated!"
            if [[ "$should_reload" == true ]]; then
              echo "🔄 Reloading VSCode windows..."
              code --command workbench.action.reloadWindow 2>/dev/null &
              echo "✅ VSCode reload triggered"
            else
              echo "🔄 Restart VSCode to apply changes (use --reload flag for auto-reload)"
            fi
            return 0
          else
            echo "❌ Invalid action: $2 (use: on|off)"
            return 1
          fi
          ;;
        *)
          echo "❌ Invalid command: $1"
          show_help
          return 1
          ;;
      esac
      ;;
    *)
      echo "❌ Too many arguments"
      show_help
      return 1
      ;;
  esac
}

# ── CODE SUGGESTIONS ALIASES & COMPLETIONS ────────────────────────────
alias csStatus="codeSuggestions status"
alias csHelp="codeSuggestions help"
alias csOn="codeSuggestions all on"
alias csOff="codeSuggestions all off"
alias csCopilot="codeSuggestions status copilot"
alias csGemini="codeSuggestions status gemini"

_codeSuggestions_completions() {
  local -a commands=(
    'status:Show current status of code suggestions'
    'all:Control all suggestions (on/off)'
    'copilot:Control Copilot suggestions (on/off)'
    'gemini:Control Gemini suggestions (on/off)'
    'help:Show help information'
  )
  
  local -a status_options=(
    'copilot:Show only Copilot status'
    'gemini:Show only Gemini status'
    'editor:Show editor global settings'  
  )
  
  local -a toggle_options=(
    'on:Enable suggestions'
    'off:Disable suggestions'
  )

  case $words[2] in
    status)
      _describe 'status options' status_options
      ;;
    all|copilot|gemini)
      _describe 'toggle options' toggle_options
      ;;
    *)
      _describe 'commands' commands
      ;;
  esac
}

compdef _codeSuggestions_completions codeSuggestions

csDashboard() {
  clear
  echo ""
  echo "🎯 ══════════════════════════════════════════════════════════════════"
  echo "                        CODE SUGGESTIONS DASHBOARD"
  echo "══════════════════════════════════════════════════════════════════"
  
  codeSuggestions status
  
  echo "🎮 ── Quick Actions ───────────────────────────────────────────────"
  echo "   csOn          # Enable all suggestions"
  echo "   csOff         # Disable all suggestions" 
  echo "   csStatus      # Show current status"
  echo "   csCopilot     # Show Copilot status"
  echo "   csGemini      # Show Gemini status"
  echo ""
  echo "🔧 ── Advanced Commands ──────────────────────────────────────────"
  echo "   codeSuggestions copilot off    # Disable only Copilot"
  echo "   codeSuggestions gemini off     # Disable only Gemini"
  echo "   codeSuggestions help           # Show detailed help"
  echo ""
  echo "💡 All changes require VSCode restart to take effect!"
  echo "══════════════════════════════════════════════════════════════════"
  echo ""
}
# bun completions
[ -s "/home/ilelo/.bun/_bun" ] && source "/home/ilelo/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH:/opt/jetbrains/idea-IU-252.26830.84/bin"

vpn_disconnect() {
    python3 "$HOME/Documents/scripts/vpn.py"
}
