#!/bin/bash

# Script para criar um certificado digital assinado por uma CA local,
# conforme as especificações do Laboratório 2 de Segurança em Redes da UTFPR.

echo "--- Bem-vindo ao Gerador de Certificados do Laboratório 2 ---"
echo "Por favor, forneça as seguintes informações:"
echo ""

# Solicitar informações do usuário
read -p "Seu PRIMEIRO NOME (para o nome do arquivo, ex: Peter): " NOME_PARA_ARQUIVO
read -p "Seu SOBRENOME (para o nome do arquivo, ex: Parker): " SOBRENOME_PARA_ARQUIVO
read -p "Seu nome de usuário para o CN do certificado (ex: peterparker para peterparker.utfpr.edu.br): " NOME_PARA_CN
read -p "Sua CIDADE (para localização do certificado, ex: Curitiba): " SUA_CIDADE
read -p "Sua TURMA (para Unidade Organizacional, ex: ES44F): " SUA_TURMA

# Validar se os inputs não estão vazios (validação básica)
if [[ -z "$NOME_PARA_ARQUIVO" || -z "$SOBRENOME_PARA_ARQUIVO" || -z "$NOME_PARA_CN" || -z "$SUA_CIDADE" || -z "$SUA_TURMA" ]]; then
    echo "Erro: Todas as informações são obrigatórias. Por favor, execute o script novamente."
    exit 1
fi

# Parâmetros Fixos
CA_CN="ca.utfpr.edu.br"
CA_COUNTRY="BR"
CA_LOCATION="Cornelio Procopio"
CERT_COUNTRY="BR"
CERT_ORG="UTFPR"
SERVER_CERT_CN="${NOME_PARA_CN}.utfpr.edu.br"
IP1="192.168.1.5"
IP2="192.168.1.6"
DAYS_VALID=365

# Nomes dos arquivos
ROOT_CA_KEY="rootCA.key"
ROOT_CA_CERT="rootCA.crt"
SERVER_KEY="server.key"
CSR_CONF="csr.conf"
SERVER_CSR="server.csr"
CERT_EXT_CONF="cert_ext.conf" # Nomeado para evitar conflito com um possível cert.conf genérico
SERVER_CERT_TEMP="server_temp.crt"
FINAL_CERT_NAME="${NOME_PARA_ARQUIVO}_${SOBRENOME_PARA_ARQUIVO}_LAB_02.CRT"

echo ""
echo "--- Iniciando a criação dos certificados ---"
echo "Nome final do arquivo do certificado: ${FINAL_CERT_NAME}"
echo ""

# 1. Criar o certificado da Autoridade Certificadora (CA)
echo "[PASSO 1/6] Criando o certificado da Autoridade Certificadora (CA)..."
openssl req -x509 \
    -sha256 -days ${DAYS_VALID} \
    -nodes \
    -newkey rsa:2048 \
    -subj "/CN=${CA_CN}/C=${CA_COUNTRY}/L=${CA_LOCATION}" \
    -keyout ${ROOT_CA_KEY} -out ${ROOT_CA_CERT}
if [ $? -ne 0 ]; then echo "Erro ao criar CA. Abortando."; exit 1; fi
echo "CA criada com sucesso: ${ROOT_CA_CERT} e ${ROOT_CA_KEY}"
echo ""

# 2. Criar o par de chaves para o servidor
echo "[PASSO 2/6] Criando o par de chaves do servidor..."
openssl genrsa -out ${SERVER_KEY} 2048
if [ $? -ne 0 ]; then echo "Erro ao criar par de chaves do servidor. Abortando."; exit 1; fi
echo "Par de chaves do servidor criado: ${SERVER_KEY}"
echo ""

# 3. Criar o arquivo de configuração da Requisição de Assinatura de Certificado (CSR)
echo "[PASSO 3/6] Criando arquivo de configuração para o CSR (csr.conf)..."
cat <<EOF > ${CSR_CONF}
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = ${CERT_COUNTRY}
ST = ${SUA_CIDADE}
L = ${SUA_CIDADE}
O = ${CERT_ORG}
OU = ${SUA_TURMA}
CN = ${SERVER_CERT_CN}

[ req_ext ]
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${SERVER_CERT_CN}
DNS.2 = www.${SERVER_CERT_CN}
IP.1 = ${IP1}
IP.2 = ${IP2}
EOF
if [ $? -ne 0 ]; then echo "Erro ao criar ${CSR_CONF}. Abortando."; exit 1; fi
echo "${CSR_CONF} criado com sucesso."
echo ""

# 4. Gerar o CSR
echo "[PASSO 4/6] Gerando a Requisição de Assinatura de Certificado (CSR)..."
openssl req -new -key ${SERVER_KEY} -out ${SERVER_CSR} -config ${CSR_CONF}
if [ $? -ne 0 ]; then echo "Erro ao gerar CSR. Abortando."; exit 1; fi
echo "CSR gerado com sucesso: ${SERVER_CSR}"
echo ""

# 5. Criar arquivo de configuração externo para assinatura do certificado (extensões X.509 v3)
echo "[PASSO 5/6] Criando arquivo de configuração de extensões para assinatura (cert_ext.conf)..."
cat <<EOF > ${CERT_EXT_CONF}
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${SERVER_CERT_CN}
EOF
if [ $? -ne 0 ]; then echo "Erro ao criar ${CERT_EXT_CONF}. Abortando."; exit 1; fi
echo "${CERT_EXT_CONF} criado com sucesso."
echo ""

# 6. Assinar e gerar o certificado do servidor
echo "[PASSO 6/6] Assinando o certificado do servidor com a CA..."
openssl x509 -req \
    -in ${SERVER_CSR} \
    -CA ${ROOT_CA_CERT} -CAkey ${ROOT_CA_KEY} \
    -CAcreateserial -out ${SERVER_CERT_TEMP} \
    -days ${DAYS_VALID} \
    -sha256 -extfile ${CERT_EXT_CONF}
if [ $? -ne 0 ]; then echo "Erro ao assinar o certificado do servidor. Abortando."; exit 1; fi

# Renomear o certificado final
mv ${SERVER_CERT_TEMP} ${FINAL_CERT_NAME}
if [ $? -ne 0 ]; then echo "Erro ao renomear o certificado final. Abortando."; exit 1; fi

echo ""
echo "--- Processo Concluído com Sucesso! ---"
echo "O seu certificado final é: ${FINAL_CERT_NAME}"
echo ""
echo "Arquivos gerados:"
echo "- Autoridade Certificadora:"
echo "  - Chave privada: ${ROOT_CA_KEY}"
echo "  - Certificado: ${ROOT_CA_CERT}"
echo "  - Serial: ${ROOT_CA_CERT%.crt}.srl (ou rootCA.srl)"
echo "- Servidor/Usuário:"
echo "  - Chave privada: ${SERVER_KEY}"
echo "  - Requisição de Assinatura (CSR): ${SERVER_CSR}"
echo "  - Certificado assinado: ${FINAL_CERT_NAME}"
echo "- Arquivos de Configuração:"
echo "  - ${CSR_CONF}"
echo "  - ${CERT_EXT_CONF}"
echo ""
echo "Submeta o arquivo '${FINAL_CERT_NAME}' conforme as instruções do laboratório."

# Fim do script
