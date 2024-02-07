
# Agregar color al prompt
#PS1='\[\e[32m\]\u@\h \[\e[33m\]\W \[\e[0m\]\$ '

# Agregar la fecha y hora al prompt
#PS1='\[\e[32m\]\u@\h \[\e[33m\]\W \[\e[0m\]\d \[\e[0m\]\$ '

#PS1="\e[30;46m\u\e[m \e[2men\e[m \H\e[2m:\e[m\w \e[2ma las\e[m \A \e[2m(desde \$(uptime -s | cut -d' ' -f2))\e[m\n> "

rightprompt()
{
    printf "%*s" "$COLUMNS" " Derecho"
}

pprompt() {
    echo $(rightprompt)
    echo '\H\e[2m:\e[m\w \e[2ma las\e[m \A \e[2m(desde \$(uptime -s | cut -d' ' -f2))\e[m\n>'
}

#PS1="\H\e[2m:\e[m\w \e[2ma las\e[m \A \e[2m(desde \$(uptime -s | cut -d' ' -f2))\e[m\n> "

#PS1='knoter:\u \e7 $(rightprompt) \e8 \n >'

#PS1='knoter:\u $(rightprompt $COLUMNS) \n >'


alias ll='ls -la'
alias git='docker run -it --rm knoter-git git'
alias composer='docker run -it --rm knoter-phptools composer'
alias php='docker run -it --rm knoter-phptools php'
alias node='docker run -it --rm knoter-jstools node'
alias npm='docker run -it --rm knoter-jstools npm'
alias yarn='docker run -it --rm knoter-jstools yarn'

#alias workin='cd ./code'

get_workdirs() {
    local directorio="$1"
    local carpetas=()

    # Verifica si el directorio existe
    if [ -d "$directorio" ]; then
        # Recorre las carpetas en el directorio
        while IFS= read -r carpeta; do
            [ -d "$carpeta" ] && carpetas+=("$(basename "$carpeta")")
        done < <(find "$directorio" -mindepth 1 -maxdepth 1 -type d)
    else
        echo "Error: El directorio no existe."
        return 1
    fi

    # Devuelve la matriz de carpetas
    echo "${carpetas[@]}"
}

lsworks() {
    get_workdirs "/var/code"
}

works_completion_function() {
    local completions=$(get_workdirs "/var/code")
    COMPREPLY=($(compgen -W "${completions[*]}" -- "${COMP_WORDS[COMP_CWORD]}"))
}

# Asigna la función de autocompletado a un comando específico
complete -F works_completion_function workin

workin() {
    workdirname="$1"

    ##echo '/var/code/${workdirname}'
    cd /var/code/$workdirname 
}