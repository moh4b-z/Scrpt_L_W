#!/bin/bash

read -p "Quer trabalhar com pastas(1) ou usuarios(2)" escolha1

if [["$escolha1" -ep 1]]; then
    read -p "Quer deletar(1), criar(2) ou gerar pastas com nome(3)" escolha2

    if [["$escolha2" -ep 1]]; then
        # Solicita o nome base para as pastas a serem deletadas
        read -p "Digite o nome base das pastas a serem deletadas: " nome_base

        # Verifica se existem pastas com o nome base fornecido e deleta
        pastas_encontradas=$(find . -maxdepth 1 -type d -name "${nome_base}*")
        if [ -n "$pastas_encontradas" ]; then
            echo "Pastas encontradas:"
            echo "$pastas_encontradas"
            read -p "Tem certeza de que deseja deletar estas pastas? (s/n): " confirmacao
            if [ "$confirmacao" = "s" ]; then
                echo "Deletando pastas..."
                rm -r $pastas_encontradas
                echo "Pastas deletadas com sucesso."
            else
                echo "Operação cancelada pelo usuário."
            fi
        else
            echo "Nenhuma pasta com o nome base '$nome_base' encontrada."
        fi

    elif [["$escolha2" -ep 2]]; then

        # Função para criar as pastas
        criar_pastas() {
            # Solicita o número de pastas a serem criadas
            read -p "Digite o número de pastas a serem criadas: " num_pastas

            # Solicita o nome base para todas as pastas
            read -p "Digite o nome base para todas as pastas: " nome_base

            # Loop para criar as pastas
            for ((i = 1; i <= num_pastas; i++)); do
                nome_pasta="${nome_base}_${i}"
                if [ ! -d "$nome_pasta" ]; then
                    mkdir "$nome_pasta"
                    echo "Pasta '$nome_pasta' criada com sucesso."
                else
                    echo "A pasta '$nome_pasta' já existe."
                fi
            done
        }

        # Chama a função para criar as pastas
        criar_pastas

    elif [["$escolha2" -ep 3]]; then

        # Array de nomes
        nomes=("Mohammad" "Saddy" "João" "Maria" "Fernando" "Shirley" "Madu" "Milena" "Sophia" "Luana")

        # Array de sobrenomes
        sobrenomes=("Silva" "Salim" "Soares" "Assis" "Oliveira" "Gomes" "Guedes")

        # Gerar nomes aleatórios combinando nomes e sobrenomes
        for nome in "${nomes[@]}"; do
            for sobrenome in "${sobrenomes[@]}"; do
                nome_completo="$nome $sobrenome"
                mkdir "$nome_completo"
            done
        done

    else
        echo parou

    fi



elif [["$escolha1" -ep 2]]; then

    read -p "Quer deletar(1), criar(2) ou gerar usuarios com nome(3)" escolha3

    if [["$escolha3" -ep 1]]; then

        # Solicita o nome base para os usuários a serem deletados
        read -p "Digite o nome base dos usuários a serem deletados: " nome_base

        # Verifica se existem pastas (possíveis usuários) com o nome base fornecido e deleta
        usuarios_encontrados=$(ls /home | grep "${nome_base}")
        if [ -n "$usuarios_encontrados" ]; then
            echo "Usuários encontrados:"
            echo "$usuarios_encontrados"
            read -p "Tem certeza de que deseja deletar estes usuários? (s/n): " confirmacao
            if [ "$confirmacao" = "s" ]; then
                echo "Deletando usuários..."
                for usuario in $usuarios_encontrados; do
                    sudo deluser --remove-home $usuario
                done
                echo "Usuários deletados com sucesso."
            else
                echo "Operação cancelada pelo usuário."
            fi
        else
            echo "Nenhum usuário com o nome base '$nome_base' encontrado."
        fi

    elif [["$escolha3" -ep 2]]; then

        # Função para criar os usuários
        criar_usuarios() {
            # Solicita o número de usuários a serem criados
            read -p "Digite o número de usuários a serem criados: " num_usuarios

            # Solicita o nome base para todos os usuários
            read -p "Digite o nome base para todos os usuários: " nome_base

            # Define a senha padrão
            senha_padrao="senai127"

            # Loop para criar os usuários
            for ((i = 1; i <= num_usuarios; i++)); do
                nome_usuario="${nome_base}_${i}"
                if ! id "$nome_usuario" &>/dev/null; then
                    # Cria o usuário com a senha padrão e força a alteração na primeira vez que fizer login
                    sudo useradd -m -s /bin/bash "$nome_usuario"
                    echo "$nome_usuario:$senha_padrao" | sudo chpasswd
                    sudo chage -d 0 "$nome_usuario"
                    echo "Usuário '$nome_usuario' criado com sucesso."
                else
                    echo "O usuário '$nome_usuario' já existe."
                fi
            done
        }

        # Chama a função para criar os usuários
        criar_usuarios

    elif [["$escolha3" -ep 3]]; then

        #deve esetar errado

        # Arrays de nomes e sobrenomes
        nomes=("Mohammad" "Saddy" "João" "Maria" "Fernando" "Shirley" "Madu" "Milena" "Sophia" "Luana")
        sobrenomes=("Silva" "Salim" "Soares" "Assis" "Oliveira" "Gomes" "Guedes")

        # Solicitar o número de usuários a serem criados
        read -p "Digite o número de usuários a serem criados: " num_usuarios

        # Definir senha padrão
        senha_padrao="senai127"

        # Função para gerar nome aleatório único
        function gerar_nome_unico() {
            local indice_nome=$((RANDOM % ${#nomes[@]}))
            local indice_sobrenome=$((RANDOM % ${#sobrenomes[@]}))
            local nome="${nomes[$indice_nome]} ${sobrenomes[$indice_sobrenome]}"
            echo "$nome"
        }

        # Array para armazenar nomes únicos gerados
        declare -a nomes_gerados

        # Loop para criar usuários
        for ((i = 1; i <= num_usuarios; i++)); do
            # Gerar nome único
            nome_completo=$(gerar_nome_unico)
            
            # Verificar se o nome já foi usado
            while [[ " ${nomes_gerados[@]} " =~ " ${nome_completo} " ]]; do
                nome_completo=$(gerar_nome_unico)
            done

            # Adicionar nome à lista de nomes gerados
            nomes_gerados+=("$nome_completo")

            # Criar usuário com nome único
            nome_usuario="${nome_completo// /_}"
            if ! id "$nome_usuario" &>/dev/null; then
                useradd -m -s /bin/bash "$nome_usuario"
                echo "$nome_usuario:$senha_padrao" | chpasswd
                echo "Usuário '$nome_usuario' criado com sucesso."
            else
                echo "O usuário '$nome_usuario' já existe."
            fi
        done

    else
        echo parou

    fi

else
    echo parou

fi

