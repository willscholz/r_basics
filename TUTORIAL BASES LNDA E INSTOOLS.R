
install.packages("tidylog")
library(tidyverse)
library(tidylog)

#/mnt pasta principal do servidor
#~ = home = /home/schowi02

#=========================================================================================
#CARREGANDO BASES DE TRABALHO
#=========================================================================================

#2. PACOTE BAIXA BASES-------------------------------------------------------------------

#1. Carregar pacote auxiliar
source("/mnt/paths/get_data.R") #carrega script inteiro

#/mnt/paths
#paths: relação de bases que temos salva e endereço delas
unified_v2 = get_dataset_by_id(95) #carrega tabela com id 95 (rodar apos credenciado)

#----------------------------------------------------------------------------------------



#2. COLOCANDO CREDENCIAIS-------------------------------------------------------------------

#1. Rodar código abaixo no terminal
#python3 /mnt/paths/scripts/utils/python/get_saml_credentials.py

#2. funcao do get_data para dar update no credencial (ou esse ou o debaixo)
update_credentials()

#2.b caso nao functione, rodar output de (1) substituindo campos abaixo
Sys.setenv(
  AWS_DEFAULT_REGION = "us-west-2",
  AWS_ACCESS_KEY_ID = "ASIAQQBDRU7JZ4WSY7HG",
  AWS_SECRET_ACCESS_KEY = "DztcHjZOy4tRvgWWDr3b/NZ/cFHPa6njnXQeka9S",
  AWS_SESSION_TOKEN = "FwoGZXIvYXdzEKP//////////wEaDO3z4s0HPfxXBU87jiLfAVVssLidNPUqyuS6bU4yMx45LbdbU5T31L+ABVtXmpYbHpCwu7fKWZDYvwgYMJg5Bh9vIUtzHQNaWqDIkXzy9Q2uQLNpIy0fZaL2W/TGrW5aM8n0aP/TXkF0hvC4FyMxvuAwMKm4DxP14kaT+WNI500DTKexN1aDEnaugyQiG6wGSS41EPJjbVnoEFt/PSPcoFWKZ08nle8M+DC7AOivMR0kcMiQ822udCyEeklpuDbNnacEMjF9P6H4H273KhxLt7O+qOEVhfgJ3IeL7Nip3Mfmu5+zLOWflW5K22xxts0o9uez9wUyMmkTri9XnHGHvA/9HfAUziNGmwU9nh0W6d0k4bVygzmGoTl/zRc1X+oBXhhdVzqtNlJB"
)

#APOS ESSES PASSOS TEM ACESSO A BASES NO S3

#----------------------------------------------------------------------------------------


#3. COMO LER BASE------------------------------------------------------------------------


#A. USANDO FUNÇÃO AUXILIAR-------------------

unified_v2 = get_dataset_by_id(95)

#--------------------------------------------

#B. DIRETO S3--------------------------------
#path = "s3...." #colocar path no s3: ver na tabela: normalmente no bucket BR analytics
#https://s3.console.aws.amazon.com/s3/buckets/br-analytics-input/?region=us-west-2&tab=overview

#se comunica com s3, lê path, 
df = aws.s3::s3read_using(readr::read_delim,
                          object = path,
                          delim = "\t",
                          guess_max = Inf,
                          #locale = readr::locale(encoding="latin1")
)
#ultimo argumento: alterar quando encoding diferente

#--------------------------------------------

#C. DE ARQUIVO EM PATH-----------------------

#lendo bases de ender
#library readr: 
#readr::read_csv() ler base
df_VIVO = read.csv('/mnt/Vivo/LEXISNEXIS_ENTREGA_202003.csv', sep = ";")
df_VIVO2 = read.csv('/mnt/Vivo/amostra_vivo.csv.gz', sep = "|")
df_VIVO3 = read.csv('/mnt/Vivo/LEXIS_BKT_202005_RICO_40B.txt', sep = " ")


#--------------------------------------------

#----------------------------------------------------------------------------------------

#=========================================================================================
#INSTALANDO E CARREGANDO LNDA E INSTOOLS
#=========================================================================================

#LNDA------------------------------------------------------------------------------------
#carregando biblioteca LNDA

install.packages("/mnt/LNDA/LNDA_0.6.6.tar.gz", repos = NULL, type='source')
library(LNDA)

mtcars
df <- mtcars
url_out = "/home/schowi02/mtcars.xlsx"
?eda
LNDA::eda(df = df, output = url_out)

#instalar no terminal modulo:
#pip install modulename

#-----------------------------------------------------------------------------------------


#INSTOOLS---------------------------------------------------------------------------------

#DOCUMENTAÇÃO: https://gitlab.ins.risk.regn.net/UKIAnalytics/instools

#In order to install instools, make sure you have installed the following packages:
#devtools
#git2r

library(devtools)
library(git2r)
library(instools)

install.packages("cplm")
install.packages("formula.tools")
install.packages("mltools")
install.packages("purrrlyr")
install.packages("rbokeh")

#JEITO MAIS FÁCIL
install.packages("/mnt/instools-master_20200616.tar.gz", repos = NULL, type = "source")

#----------------------------------------------------------------------------------------






