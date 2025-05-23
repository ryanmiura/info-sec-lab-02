# Laboratório 2: Criação de Certificados Digitais com OpenSSL

## Objetivo da Atividade

O objetivo principal deste laboratório é capacitar o estudante a criar um certificado digital X.509[cite: 5]. Este certificado será assinado por uma Autoridade Certificadora (CA) que também será criada durante a atividade[cite: 5]. Todo o processo será realizado utilizando a ferramenta OpenSSL em um ambiente Linux[cite: 4].

## Ferramentas Necessárias

* **Sistema Operacional:** Linux [cite: 4]
* **Software:** OpenSSL [cite: 4]

## Entregável

Ao final da atividade, o estudante deverá entregar um único arquivo no formato `.CRT`[cite: 6]. Este arquivo deve ser nomeado seguindo o padrão:

`Nome_Sobrenome_LAB_02.CRT` [cite: 7]

## Informações para Criação dos Certificados

As seguintes informações, especificadas no enunciado, devem ser utilizadas durante a criação dos certificados[cite: 6]:

### Para a Autoridade Certificadora (CA):

* **Nome Comum (CN - Common Name):** `ca.utfpr.edu.br` [cite: 6]
* **País (C - Country):** `BR` [cite: 6]
* **Localidade (L - Locality):** `Cornelio Procopio` [cite: 6]

### Para o Certificado do Servidor/Usuário (a ser assinado pela CA):

* **Nome Comum (CN - Common Name):** `seunome.utfpr.edu.br` (substituir "seunome" pelo nome de usuário do estudante) [cite: 6]
* **País (C - Country):** `BR` [cite: 6]
* **Localidade (L - Locality):** `sua cidade` (substituir pela cidade do estudante) [cite: 6]
* **Organização (O - Organization):** `UTFPR` [cite: 6]
* **Unidade Organizacional (OU - Organizational Unit):** `sua turma` (substituir pela turma do estudante) [cite: 6]
* **Endereços IP (para Subject Alternative Name - SAN) (conforme arquivo de configuração CSR):**
    * `IP.1 = 192.168.1.5` [cite: 9]
    * `IP.2 = 192.168.1.6` [cite: 9]
* **Nomes DNS (para Subject Alternative Name - SAN) (conforme arquivo de configuração CSR):**
    * `DNS.1 = <parametro>` (será `seunome.utfpr.edu.br`) [cite: 9]
    * `DNS.2 = www.<parametro>` (será `www.seunome.utfpr.edu.br`) [cite: 9]
