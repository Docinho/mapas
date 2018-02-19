library(readr)
library(plyr)
library(dplyr)

dados <- read.csv("Programas/Universidade/quartoPeriodo/mapas/PB/Base informaçoes setores2010 universo PB/CSV/ResponsavelRenda_PB.csv",sep = ";")
head(dados)

dados_selecionados <- dados %>% select(Cod_setor : V010) 
dados_selecionados$V010 <- as.numeric(revalue(dados_selecionados$V010, c ("X" = 0)))
dados_selecionados$V001 <- as.numeric(revalue(dados_selecionados$V001, c ("X" = 0)))
dados_selecionados$V002 <- as.numeric(revalue(dados_selecionados$V002, c ("X" = 0)))
dados_selecionados$V003 <- as.numeric(revalue(dados_selecionados$V003, c ("X" = 0)))
dados_selecionados$V004 <- as.numeric(revalue(dados_selecionados$V004, c ("X" = 0)))
dados_selecionados$V005 <- as.numeric(revalue(dados_selecionados$V005, c ("X" = 0)))
dados_selecionados$V006 <- as.numeric(revalue(dados_selecionados$V006, c ("X" = 0)))
dados_selecionados$V007 <- as.numeric(revalue(dados_selecionados$V007, c ("X" = 0)))
dados_selecionados$V008 <- as.numeric(revalue(dados_selecionados$V008, c ("X" = 0)))
dados_selecionados$V009 <- as.numeric(revalue(dados_selecionados$V009, c ("X" = 0)))


head(dados_selecionados)
soma <- dados_selecionados  %>% select(V001: V010) %>% mutate(soma = rowSums(.))

razao <- soma %>% mutate(div = (V005/soma)*100)
razao$Cod_setor <- dados_selecionados$Cod_setor
razao$Situacao_setor <- dados_selecionados$Situacao_setor
razao <- razao %>% select(Cod_setor, Situacao_setor, everything())
razao_escrita <- dados 
razao_escrita$div <- razao$div

setwd("Programas/Universidade/quartoPeriodo/mapas")
write.csv(razao, "razaoRenda.csv", row.names = F)
write.csv2(razao_escrita, "ResponsavelRazaoRenda.csv", row.names = F)

