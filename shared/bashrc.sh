
knotercodepath='/var/k/code'
workname='home'
workdirpath='/'
gitbranch=''

promptname='knoter'
promptoffset=93

worktypes=("html" "laravel" "bash")

wtype=''
wfullpath=''

setvars() {
  # Read the environment file in a safer way using `source`
  source "/var/code/$1/.work"

  # Assign values retrieved from the environment file to variables with different names
  wtype="$wtype"
  wfullpath="$wfullpath"
}

pcolors() {
    
    # colores estándar
    echo -en "Standar BG Colors \n"
    for C in {40..47}; do
        echo -en "\e[${C}m$C "
    done
    echo -en "\e(B\e[m\n"
    echo -en "Standar TEXT Colors \n"
    for C in {30..37}; do
        echo -en "\e[${C}m$C "
    done
    echo -en "\e(B\e[m\n"

    # colores de alta intensidad
    echo -en "Hight Intensity BG Colors \n"
    for C in {100..107}; do
        echo -en "\e[${C}m$C "
    done
    echo -en "\e(B\e[m\n"
    echo -en "Hight Intensity TEXT Colors \n"
    for C in {90..97}; do
        echo -en "\e[${C}m$C "
    done
    echo -en "\e(B\e[m\n"


    # 256 colores
    echo -en "256 BG Colors \n"
    for C in {16..255}; do
        echo -en "\e[48;5;${C}m$C "
    done
    echo -e "\e(B\e[m\n"
    echo -en "256 Text Colors \n"
    for C in {16..255}; do
        echo -en "\e[38;5;${C}m$C "
    done
    echo -e "\e(B\e[m\n"

}

setprompt() {
    
    cdir=$(pwd)
    time="$(echo '\e[92m')$(echo -e '\uf017') $(date +"%H:%M:%S")$(echo '\e(B\e[m') $(echo -e '\e[94m\u2510\e(B\e[m')"
    phead="$(echo -e '\e[94m\u250C\e(B\e[m \e[90m$promptname:$(whoami)\e(B\e[m') $(echo -e '\e[90m\uf07c \e[1m$cdir\e(B\e[m') \e[1m\e[94m[ $workname ]\e(B\e[m"
    pbody="$(echo -e '\e[94m\u2514\e(B\e[m')"
    cols=$(echo "$COLUMNS")
    pheadl=${#phead}
    timel=${#time}
    cdirl=${#cdir}
    totall=$((pheadl + timel))
    totall=$((totall + cdirl))
    totall=$((totall - promptoffset))
    n=$((cols - totall))
    x="$(echo -e '\u2B1D')"
    
    spacer=""
    for i in $(seq 1 $n); do
        spacer="$spacer$x"
    done

    PS1="$phead $spacer $time\n$pbody # "

}

alias ll='ls -la'
alias git='docker run -w $wfullpath/ -v $knotercodepath:/var/code -it --rm knoter-git git'
alias composer='docker run -w $wfullpath/ -v $knotercodepath:/var/code -it --rm knoter-phptools composer'
alias php='docker run -w $wfullpath/ -v $knotercodepath:/var/code -it --rm knoter-phptools php'
alias node='docker run -w $wfullpath/ -v $knotercodepath:/var/code -it --rm knoter-jstools node'
alias npm='docker run -w $wfullpath/ -v $knotercodepath:/var/code -it --rm knoter-jstools npm'
alias yarn='docker run -w $wfullpath/ -v $knotercodepath:/var/code -it --rm knoter-jstools yarn'

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

addwork() {

    type=$(echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g')
    name=$(echo "$2" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g')
    names=$(get_workdirs "/var/code")

    typeok=false

    for findtype in "${worktypes[@]}"; do
        if [ "$findtype" == "$type" ]; then
            typeok=true
            break
        fi
    done

    nameok=false

    for findname in "${names[@]}"; do
        if [ "$findname" == "$name" ]; then
            nameok=true
            break
        fi
    done
    

    if [ "$typeok" = true ]; then
        if [ "$nameok" = false ]; then
            
            mkdir "/var/code/$name"
            cd "/var/code/$name"
            touch "/var/code/$name/.work"
            
            case $type in
                "html")
                        echo "wtype='html'" >> "/var/code/$name/.work"
                        echo "wfullpath='/var/code/$name'" >> "/var/code/$name/.work"
                    ;;
                "laravel")
                        echo "wtype='laravel'" >> "/var/code/$name/.work"
                        echo "wfullpath='/var/code/$name/laravel'" >> "/var/code/$name/.work"
                        mkdir "/var/code/$name/laravel"
                    ;;
                "bash")
                        echo "wtype='bash'" >> "/var/code/$name/.work"
                        echo "wfullpath='/var/code/$name'" >> "/var/code/$name/.work"
                    ;;
                *)
                    ;;
            esac

        else
            echo -e "ERROR The work are exist. \n"
        fi
    else
        echo -e "ERROR Invalid work type. \n"
    fi

}

rmwork(){
    rm -R /var/code/$1
}

works_completion_function() {
    local completions=$(get_workdirs "/var/code")
    COMPREPLY=($(compgen -W "${completions[*]}" -- "${COMP_WORDS[COMP_CWORD]}"))
}

# Asigna la función de autocompletado a un comando específico
complete -F works_completion_function workin
complete -F works_completion_function rmwork

workin() {
    workname="$1"
    setvars $workname
    cd $wfullpath
}

PROMPT_COMMAND='setprompt'

clear

setprompt