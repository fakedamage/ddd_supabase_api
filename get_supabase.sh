#!/bin/bash

# Script para análise de projetos Supabase - Focado em functions e migrations
# Cria arquivo .txt com árvore de arquivos e seus conteúdos APENAS das pastas functions e migrations

SUPABASE_PATH="supabase"
FUNCTIONS_PATH="${SUPABASE_PATH}/functions"
MIGRATIONS_PATH="${SUPABASE_PATH}/migrations"

# Verifica se o diretório supabase existe
if [ ! -d "$SUPABASE_PATH" ]; then
    echo "❌ Erro: Diretório '$SUPABASE_PATH' não encontrado."
    echo "Certifique-se de estar no diretório raiz do projeto Supabase."
    exit 1
fi

# Nome do arquivo de saída
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="supabase_project_${TIMESTAMP}.txt"

echo "🎯 Análise FOCADA do Supabase"
echo "📁 Pastas analisadas: functions e migrations"
echo "📄 Gerando relatório: $OUTPUT_FILE"
echo "⏳ Processando..."

# Função para criar separador
separator() {
    echo "================================================================"
}

# Função para criar separador menor
small_separator() {
    echo "----------------------------------------------------------------"
}

# Inicia o arquivo de relatório
{
    echo "RELATÓRIO FOCADO DO SUPABASE - FUNCTIONS & MIGRATIONS"
    echo "Gerado em: $(date)"
    echo "Local: $(pwd)"
    separator
    echo ""
    
    # ========== ESTRUTURA DA ÁRVORE ==========
    echo "🌳 ESTRUTURA DA ÁRVORE (functions e migrations apenas)"
    separator
    echo ""
    
    # Analisa functions
    if [ -d "$FUNCTIONS_PATH" ]; then
        echo "📂 supabase/functions/"
        
        # Função recursiva para mostrar árvore do functions
        show_tree_functions() {
            local dir="$1"
            local indent="$2"
            
            # Lista conteúdo do diretório ordenado
            find "$dir" -maxdepth 1 -type f -o -type d | grep -v "^$dir$" | sort | while read item; do
                local base_item=$(basename "$item")
                
                if [ -d "$item" ]; then
                    # É um diretório (uma function específica)
                    echo "${indent}📁 $base_item/"
                    show_tree_functions "$item" "${indent}  "
                elif [ -f "$item" ]; then
                    # É um arquivo
                    echo "${indent}📄 $base_item"
                fi
            done
        }
        
        show_tree_functions "$FUNCTIONS_PATH" "  "
        echo ""
    else
        echo "⚠️  Pasta 'functions' não encontrada: $FUNCTIONS_PATH"
        echo ""
    fi
    
    # Analisa migrations
    if [ -d "$MIGRATIONS_PATH" ]; then
        echo "📂 supabase/migrations/"
        
        # Mostra apenas arquivos .sql na pasta migrations
        find "$MIGRATIONS_PATH" -maxdepth 1 -name "*.sql" | sort | while read sql_file; do
            echo "  📄 $(basename "$sql_file")"
        done
        
        # Mostra subdiretórios se existirem
        find "$MIGRATIONS_PATH" -maxdepth 1 -type d | grep -v "^$MIGRATIONS_PATH$" | sort | while read dir; do
            echo "  📁 $(basename "$dir")/"
            find "$dir" -name "*.sql" | sort | while read sql_file; do
                echo "    📄 $(basename "$sql_file")"
            done
        done
        echo ""
    else
        echo "⚠️  Pasta 'migrations' não encontrada: $MIGRATIONS_PATH"
        echo ""
    fi
    
    separator
    echo ""
    
    # ========== CONTEÚDO DOS ARQUIVOS ==========
    echo "📝 CONTEÚDO DOS ARQUIVOS"
    separator
    echo ""
    
    # Contador de arquivos
    file_count=0
    
    # ========== PROCESSAR FUNCTIONS ==========
    if [ -d "$FUNCTIONS_PATH" ]; then
        echo "🚀 FUNCTIONS (Edge Functions)"
        separator
        echo ""
        
        # Processa cada function
        find "$FUNCTIONS_PATH" -maxdepth 1 -type d ! -name "$(basename "$FUNCTIONS_PATH")" | sort | while read func_dir; do
            func_name=$(basename "$func_dir")
            echo "📦 FUNCTION: $func_name"
            echo "📍 Local: supabase/functions/$func_name/"
            small_separator
            
            # Processa cada arquivo dentro da function
            find "$func_dir" -type f | sort | while read file; do
                file_count=$((file_count + 1))
                
                rel_path="${file#$FUNCTIONS_PATH/}"
                full_display_path="supabase/functions/$rel_path"
                
                echo ""
                echo "📄 ARQUIVO #${file_count}: $full_display_path"
                echo "📊 Tamanho: $(wc -l < "$file") linhas"
                small_separator
                
                echo "📋 CONTEÚDO:"
                echo ""
                
                # Adiciona numeração de linhas para arquivos de texto
                file_extension="${file##*.}"
                
                case "$file_extension" in
                    ts|tsx|js|jsx|json|toml|yml|yaml|md|txt)
                        # Arquivos de código/texto - mostra com numeração
                        cat -n "$file" | sed 's/^/     /'
                        ;;
                    *)
                        # Outros tipos de arquivo
                        if [[ $(file -b --mime-type "$file") == text/* ]]; then
                            cat "$file"
                        else
                            echo "⚠️  Arquivo binário (conteúdo não exibido)"
                        fi
                        ;;
                esac
                
                echo ""
            done
            
            separator
            echo ""
        done
    fi
    
    # ========== PROCESSAR MIGRATIONS ==========
    if [ -d "$MIGRATIONS_PATH" ]; then
        echo "🗃️  MIGRATIONS (Arquivos SQL)"
        separator
        echo ""
        
        # Processa cada arquivo SQL
        find "$MIGRATIONS_PATH" -type f -name "*.sql" | sort | while read sql_file; do
            file_count=$((file_count + 1))
            
            rel_path="${sql_file#$MIGRATIONS_PATH/}"
            full_display_path="supabase/migrations/$rel_path"
            
            echo "📄 ARQUIVO #${file_count}: $full_display_path"
            echo "📊 Tamanho: $(wc -l < "$sql_file") linhas"
            small_separator
            
            echo "📋 CONTEÚDO:"
            echo ""
            
            # Mostra as primeiras 50 linhas de cada migration SQL
            echo "Linha | Conteúdo"
            echo "------+---------"
            head -50 "$sql_file" | cat -n | sed 's/^/     /'
            
            # Se o arquivo tiver mais de 50 linhas, mostra mensagem
            total_lines=$(wc -l < "$sql_file")
            if [ "$total_lines" -gt 50 ]; then
                echo "... (mais $((total_lines - 50)) linhas não exibidas)"
            fi
            
            echo ""
            separator
            echo ""
        done
        
        # Processa outros arquivos em migrations (se houver)
        find "$MIGRATIONS_PATH" -type f ! -name "*.sql" | sort | while read other_file; do
            file_count=$((file_count + 1))
            
            rel_path="${other_file#$MIGRATIONS_PATH/}"
            full_display_path="supabase/migrations/$rel_path"
            
            echo "📄 ARQUIVO #${file_count}: $full_display_path"
            echo "⚠️  Arquivo não-SQL em migrations"
            echo "📊 Tamanho: $(wc -l < "$other_file") linhas"
            small_separator
            
            echo "📋 CONTEÚDO:"
            echo ""
            
            # Mostra conteúdo se for arquivo de texto
            if [[ $(file -b --mime-type "$other_file") == text/* ]]; then
                cat -n "$other_file" | sed 's/^/     /'
            else
                echo "Arquivo binário (conteúdo não exibido)"
            fi
            
            echo ""
            separator
            echo ""
        done
    fi
    
    # ========== RESUMO FINAL ==========
    echo "📊 RESUMO FINAL"
    separator
    echo ""
    
    # Estatísticas específicas
    if [ -d "$FUNCTIONS_PATH" ]; then
        func_dirs=$(find "$FUNCTIONS_PATH" -maxdepth 1 -type d ! -name "$(basename "$FUNCTIONS_PATH")" | wc -l)
        func_files=$(find "$FUNCTIONS_PATH" -type f | wc -l)
        func_lines=$(find "$FUNCTIONS_PATH" -type f -exec cat {} \; 2>/dev/null | wc -l || echo 0)
        
        echo "🚀 FUNCTIONS:"
        echo "  • Número de functions: $func_dirs"
        echo "  • Total de arquivos: $func_files"
        echo "  • Linhas de código: $func_lines"
        echo ""
    fi
    
    if [ -d "$MIGRATIONS_PATH" ]; then
        mig_files=$(find "$MIGRATIONS_PATH" -type f -name "*.sql" | wc -l)
        mig_other=$(find "$MIGRATIONS_PATH" -type f ! -name "*.sql" | wc -l)
        mig_total=$((mig_files + mig_other))
        mig_lines=$(find "$MIGRATIONS_PATH" -type f -name "*.sql" -exec cat {} \; 2>/dev/null | wc -l || echo 0)
        
        echo "🗃️  MIGRATIONS:"
        echo "  • Migrations SQL: $mig_files"
        echo "  • Outros arquivos: $mig_other"
        echo "  • Total de arquivos: $mig_total"
        echo "  • Linhas SQL: $mig_lines"
        
        if [ "$mig_files" -gt 0 ]; then
            echo ""
            echo "  📅 LINHA DO TEMPO DAS MIGRATIONS:"
            find "$MIGRATIONS_PATH" -name "*.sql" -type f | sort | while read mig; do
                mig_name=$(basename "$mig")
                mig_size=$(wc -l < "$mig")
                echo "    • $mig_name ($mig_size linhas)"
            done
        fi
        echo ""
    fi
    
    echo "📈 ESTATÍSTICAS GERAIS:"
    echo "  • Total de arquivos processados: $file_count"
    echo "  • Data da análise: $(date)"
    echo ""
    
    if [ -d "$FUNCTIONS_PATH" ] && [ -d "$MIGRATIONS_PATH" ]; then
        echo "✅ AMBAS AS PASTAS ENCONTRADAS E ANALISADAS"
    elif [ -d "$FUNCTIONS_PATH" ]; then
        echo "⚠️  Apenas 'functions' encontrada (migrations não existe)"
    elif [ -d "$MIGRATIONS_PATH" ]; then
        echo "⚠️  Apenas 'migrations' encontrada (functions não existe)"
    else
        echo "❌ Nenhuma das pastas (functions/migrations) foi encontrada"
    fi
    
    separator
    echo "✅ RELATÓRIO FOCADO GERADO COM SUCESSO"
    
} > "$OUTPUT_FILE"

# Verifica se o arquivo foi criado
if [ -f "$OUTPUT_FILE" ]; then
    # Obtém estatísticas do arquivo gerado
    file_lines=$(wc -l < "$OUTPUT_FILE")
    file_size=$(du -h "$OUTPUT_FILE" | cut -f1)
    
    echo ""
    echo "✅ Relatório criado com sucesso!"
    echo "📄 Arquivo: $OUTPUT_FILE"
    echo "📏 Tamanho: $file_size ($file_lines linhas)"
    echo ""
    
    # Mostra estatísticas rápidas
    if [ -d "$FUNCTIONS_PATH" ]; then
        func_count=$(find "$FUNCTIONS_PATH" -maxdepth 1 -type d ! -name "$(basename "$FUNCTIONS_PATH")" | wc -l)
        echo "🚀 Functions encontradas: $func_count"
    fi
    
    if [ -d "$MIGRATIONS_PATH" ]; then
        mig_count=$(find "$MIGRATIONS_PATH" -name "*.sql" | wc -l)
        echo "🗃️  Migrations SQL encontradas: $mig_count"
    fi
    
    echo ""
    
    # Opções de visualização
    read -p "👁️  Visualizar relatório agora? (s/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        if command -v less > /dev/null 2>&1; then
            less "$OUTPUT_FILE"
        else
            cat "$OUTPUT_FILE"
        fi
    fi
    
else
    echo "❌ Erro: Não foi possível criar o arquivo de relatório."
    exit 1
fi