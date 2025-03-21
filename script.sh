#!/bin/bash

diretorios=("/publico" "/adm" "/ven" "/sec")
grupos=("GRP_ADM" "GRE_VEN" "GRP_VEC")
usuarios=("carlos" "maria" "joao" "debora" "sebastiana" "roberto" "josefina" "amanda" "rogerio")

for group in "${grupos[@]}"; do
  if getent group "$group" &>/dev/null; then
    echo "Grupo '$group' já existe."
  else
    echo "Criando grupo: $group"
    groupadd "$group"
    echo "Grupo '$group' criado com sucesso!"
  fi
done

echo "Processo de criação de grupos concluído!"

for ((i=0; i<${#usuarios[@]}; i++)); do
  user="${usuarios[i]}"
  
  if (( i < 3 )); then
    group="GRP_ADM"
  elif (( i < 6 )); then
    group="GRE_VEN"
  else$
    group="GRP_VEC"
  fi

  if id "$user" &>/dev/null; then
    echo "Usuário '$user' já existe."
  else
    echo "Criando usuário: $user"
    useradd "$user" -m -s /bin/bash -g "$group" -p "$(openssl passwd -6 Senha123)"
    echo "Usuário '$user' criado e adicionado ao grupo '$group'."
  fi
done

echo "Processo de criação de usuários concluído!"

diretorios=("/publico" "/private" "/shared")

for dir in "${diretorios[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "Criando diretório: $dir"
    sudo mkdir "$dir"
    
    if [ "$dir" == "/publico" ]; then
      chmod 777 "$dir"
      echo "Permissões 777 configuradas para o diretório $dir."
    else
      chmod 770 "$dir"
      echo "Permissões 770 configuradas para o diretório $dir."
    fi
    
    echo "Diretório $dir criado com sucesso!"
  else
    echo "Diretório $dir já existe."
  fi
done

echo "Processo de criação e configuração de diretórios concluído!"
