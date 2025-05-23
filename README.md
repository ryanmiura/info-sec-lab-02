# Laboratório 2: Criação de Certificados Digitais com OpenSSL

## Objetivo da Atividade

O objetivo principal deste laboratório é capacitar o estudante a criar um certificado digital X.509. Este certificado será assinado por uma Autoridade Certificadora (CA) que também será criada durante a atividade. Todo o processo será realizado utilizando a ferramenta OpenSSL em um ambiente Linux.

## Ferramentas Necessárias

* **Sistema Operacional:** Linux 
* **Software:** OpenSSL

## Entregável

Ao final da atividade, o estudante deverá entregar um único arquivo no formato `.CRT`. Este arquivo deve ser nomeado seguindo o padrão:

`Nome_Sobrenome_LAB_02.CRT` 

## Informações para Criação dos Certificados

As seguintes informações, especificadas no enunciado, devem ser utilizadas durante a criação dos certificados:

### Para a Autoridade Certificadora (CA):

* **Nome Comum (CN - Common Name):** `ca.utfpr.edu.br` 
* **País (C - Country):** `BR` 
* **Localidade (L - Locality):** `Cornelio Procopio` 

### Para o Certificado do Servidor/Usuário (a ser assinado pela CA):

* **Nome Comum (CN - Common Name):** `seunome.utfpr.edu.br` (substituir "seunome" pelo nome de usuário do estudante) 
* **País (C - Country):** `BR` 
* **Localidade (L - Locality):** `sua cidade` (substituir pela cidade do estudante) 
* **Organização (O - Organization):** `UTFPR` 
* **Unidade Organizacional (OU - Organizational Unit):** `sua turma` (substituir pela turma do estudante) 
* **Endereços IP (para Subject Alternative Name - SAN) (conforme arquivo de configuração CSR):**
    * `IP.1 = 192.168.1.5`
    * `IP.2 = 192.168.1.6`
* **Nomes DNS (para Subject Alternative Name - SAN) (conforme arquivo de configuração CSR):**
    * `DNS.1 = <parametro>` (será `seunome.utfpr.edu.br`)
    * `DNS.2 = www.<parametro>` (será `www.seunome.utfpr.edu.br`)


## Utilização do Script `gerar_certificado_lab2.sh` 

Para facilitar a execução destes passos, um script Bash chamado `gerar_certificado_lab2.sh` pode ser criado (conforme gerado em interações anteriores). Ao ser executado, este script solicitará as informações personalizadas (seu nome, sobrenome, nome de usuário para o CN, sua cidade e sua turma) e realizará todos os comandos OpenSSL necessários para gerar os arquivos, incluindo o certificado final no formato `.CRT` com o nome correto.

**Instruções para o script (caso utilize o script sugerido):**

1.  Salve o conteúdo do script em um arquivo (ex: `gerar_certificado_lab2.sh`).
2.  Dê permissão de execução: `chmod +x gerar_certificado_lab2.sh`.
3.  Execute o script: `./gerar_certificado_lab2.sh`.
4.  Siga as instruções fornecidas pelo script.

Ao final, o script indicará o nome do arquivo `.CRT` gerado, que deverá ser submetido conforme as instruções da atividade

Este documento serve como um guia para entender os conceitos e os passos envolvidos na atividade. Consulte o PDF original do laboratório para todos os detalhes e requisitos.