####################################################################################
#AUTOR: RAPHAEL DEMOSTENES CARDOZO - Email: raphaeldemostenes@gmail.com
#MESTRANDO EM EDUCA��O - PPGE- PE - UFPR
#ORIENTADORA: PROFa.  Dra. Gabriela Schneider
#T�TULO: ESTUDO COMPARATIVO DA INFRAESTRUTURA ELEMENTAR DAS ESCOLAS DO ESTADO DO PARAN�:P�BLICO X PRIVADO
#VERSAO FINAL:29/03/2018
#####################################################################################

##Defini��o de pasta do artigo

rm(list=ls())
getwd()
setwd('C:\\r\\infrapub')

##  Importa��o e base de dados
library(readr)
CENSO2017<-read.csv(file = "C:\\r\\infrapub\\Base\\2017\\DADOS\\ESCOLAS\\ESCOLAS.csv", header = TRUE, sep = "|")
names(CENSO2017)
BASE<- subset(CENSO2017, select = c(1,2,3,5,11,12,14,15,16,17,18,27,40,41,49,52,67,74,76,77,142))
names(BASE)
str(BASE)

##Filtros iniciais
library(dplyr)
ESCOLASPR<-BASE%>%filter(BASE$TP_SITUACAO_FUNCIONAMENTO==1 & 
                           BASE$CO_UF==41 & 
                           BASE$IN_LOCAL_FUNC_PREDIO_ESCOLAR==1 &
                           BASE$IN_REGULAR==1 )
##Limpando �rea
rm(BASE)
rm(CENSO2017)

##Inicio da An�lise explorat�ria

##Escolas do PR - DEP. ADM
DEPADM<-table(ESCOLASPR$TP_DEPENDENCIA, useNA = "always")
DEPADM
names(DEPADM)
names(DEPADM)<-c("Fed.","Est.","Mun.","Priv.","NA")
n<-sum(DEPADM)
DEPADM
graf_depadm<-barplot(sort((DEPADM), decreasing = TRUE),col = c("#009E73"), main="",
                     ylim = c(0,6000), cex.names = .7, cex.axis = .7
)
text(graf_depadm, sort(DEPADM, decreasing = TRUE),col="black",pos=3, cex=0.7, 
     paste(sort(DEPADM, decreasing = TRUE),"\n" ,sort(round((DEPADM/n)*100,2), decreasing = TRUE),"%"))

##Escolas do PR - LOCALIZA��O
LOCALI<-table(ESCOLASPR$TP_LOCALIZACAO, useNA = "always")
LOCALI
names(LOCALI)
names(LOCALI)<-c("Urbana","Rural","NA")
n<-sum(LOCALI)
LOCALI
graf_LOCALI<-barplot(sort((LOCALI), decreasing = TRUE),col = c("#009E73"), main="",
                     ylim = c(0,9000), cex.names = .7, cex.axis = .7)
text(graf_LOCALI, sort(LOCALI, decreasing = TRUE),col="black",pos=3, cex=0.7, 
     paste(sort(LOCALI, decreasing = TRUE),"\n" ,sort(round((LOCALI/n)*100,2), decreasing = TRUE),"%"))

#Escolas; Dep. Adm. x Local.
library(gmodels)
CrossTable(ESCOLASPR$TP_LOCALIZACAO,ESCOLASPR$TP_DEPENDENCIA, 
           dnn = c("LOCALIZA��O", "DEP. ADM"), format = "SPSS",
           prop.chisq=FALSE)
Fed<-c(30,2)
Est<-c(1631,421)
Mun<-c(4218,892)
Pri<-c(1915,9)
DEPXLOC<-rbind(Fed,Est,Mun,Pri)
colnames(DEPXLOC)<-c("Urbano","Rural")
DEPXLOC
graf_DEPXLOC<-barplot(DEPXLOC, beside  = TRUE,col = c("#E69F00", "#56B4E9", "#009E73", "#F0E442"), main="",
                      cex.names = .7, cex.axis = .7,ylim = c(0,8000), xlab = "")
legend("topleft", legend=c("Federal","Estadual","Municipal","Privada"),
       fill=c("#E69F00", "#56B4E9", "#009E73", "#F0E442"), bty="n")
text(graf_DEPXLOC, DEPXLOC,col="black",pos=3, cex=0.7, paste(DEPXLOC))

##Escolas por  Municipio
EscolasporMun<-sort(table(ESCOLASPR$CO_MUNICIPIO),decreasing = TRUE)
EscolasporMun
write.table(EscolasporMun, file = "escolasPRmun.txt",quote = TRUE,sep = ";")
EscolasporMunbreaks = cut(EscolasporMun, breaks=c(0,5,10,20,40,60,80,90, 100, 200, 300,500,1000),
                          labels=c('at� 5','5-10', '10-20','20-40','40-60','60-80','80-90',
                                   '90-100','100-200','200-300','300-500','+500'))
EscolasporMunbreaks<-table(EscolasporMunbreaks)
str(EscolasporMunbreaks)
barplot(EscolasporMunbreaks)
graf_escolqt<-barplot(EscolasporMunbreaks,col = "#009E73", main="",
                      cex.names = .7, cex.axis = .7,ylim = c(0,150), xlab = "")
text(graf_escolqt, EscolasporMunbreaks,col="black",pos=3, cex=0.7, paste(EscolasporMunbreaks))
##############################################################################################
##Filtros esc priv.
library(dplyr)
ESCOLASPRPRIV<-ESCOLASPR%>%filter(ESCOLASPR$TP_DEPENDENCIA==4)
ESCOLASPRPUB<-ESCOLASPR%>%filter(ESCOLASPR$TP_DEPENDENCIA!=4)

##ITENS DE IE ESC PRI
AGUACON_PRI<-table(ESCOLASPRPRIV$IN_AGUA_FILTRADA)
ABASTAGUA_PRI<-table(ESCOLASPRPRIV$IN_AGUA_REDE_PUBLICA)
ENERGIA_PRI<-table(ESCOLASPRPRIV$IN_ENERGIA_INEXISTENTE)
ESGOTO_PRI<-table(ESCOLASPRPRIV$IN_ESGOTO_INEXISTENTE)
BANHEIRODENTRO_PRI<-table(ESCOLASPRPRIV$IN_BANHEIRO_DENTRO_PREDIO)
BANHEIROPNE_PRI<-table(ESCOLASPRPRIV$IN_BANHEIRO_PNE)
DEPENDPNE_PRI<-table(ESCOLASPRPRIV$IN_DEPENDENCIAS_PNE)
COZINHA_PRI<-table(ESCOLASPRPRIV$IN_COZINHA)
ITENSPRIV<-cbind(AGUACON_PRI,
                 ABASTAGUA_PRI,
                 ENERGIA_PRI,
                 ESGOTO_PRI,
                 BANHEIRODENTRO_PRI,
                 BANHEIROPNE_PRI,
                 DEPENDPNE_PRI,
                 COZINHA_PRI)
ITENSPRIV
ITENSPRIV[2,3]=0
n<-sum(ITENSPRIV[,1])
n
colnames(ITENSPRIV)<-c("�gua filtrada?","Abastecimento?","Sem Energia?","Sem Esgoto?","WC Interno?",
                       "WC Acess�vel","Depend. Acess�veis?","Cozinha?")
graf_ITENSPRI<-barplot(ITENSPRIV,col = c("red","#009E73"), main="",beside = TRUE,
                       cex.names = .7, cex.axis = .7,ylim = c(0,2300), xlab = "")
legend("topright", legend=c("N�o","Sim"), fill=c("red","#009E73"), bty="n")
text(graf_ITENSPRI, ITENSPRIV,col="black",pos=3, cex=0.7, paste(ITENSPRIV,"\n" ,round((ITENSPRIV/n)*100,2),"%")
)
#ITENS ESC PUB
AGUACON_PUB<-table(ESCOLASPRPUB$IN_AGUA_FILTRADA)
ABASTAGUA_PUB<-table(ESCOLASPRPUB$IN_AGUA_REDE_PUBLICA)
ENERGIA_PUB<-table(ESCOLASPRPUB$IN_ENERGIA_INEXISTENTE)
ESGOTO_PUB<-table(ESCOLASPRPUB$IN_ESGOTO_INEXISTENTE)
BANHEIRODENTRO_PUB<-table(ESCOLASPRPUB$IN_BANHEIRO_DENTRO_PREDIO)
BANHEIROPNE_PUB<-table(ESCOLASPRPUB$IN_BANHEIRO_PNE)
DEPENDPNE_PUB<-table(ESCOLASPRPUB$IN_DEPENDENCIAS_PNE)
COZINHA_PUB<-table(ESCOLASPRPUB$IN_COZINHA)
ITENSPUB<-cbind(AGUACON_PUB,
                ABASTAGUA_PUB,
                ENERGIA_PUB,
                ESGOTO_PUB,
                BANHEIRODENTRO_PUB,
                BANHEIROPNE_PUB,
                DEPENDPNE_PUB,
                COZINHA_PUB)
ITENSPUB
n<-sum(ITENSPUB[,1])
n
colnames(ITENSPUB)<-c("�gua filtrada?","Abastecimento?","Sem Energia?","Sem Esgoto?","WC Interno?",
                      "WC Acess�vel","Depend. Acess�veis?","Cozinha?")
graf_ITENSPUB<-barplot(ITENSPUB,col = c("red","#009E73"), main="",beside = TRUE,
                       cex.names = .7, cex.axis = .7,ylim = c(0,9000), xlab = "")
legend("topright", legend=c("N�o","Sim"), fill=c("red","#009E73"), bty="n")
text(graf_ITENSPUB, ITENSPUB,col="black",pos=3, cex=0.7, paste(ITENSPUB,"\n" ,round((ITENSPUB/n)*100,2),"%"))

#####

##Escolas do PRIV - DEP. ADM
DEPADMPRI<-table(ESCOLASPRPRIV$TP_CATEGORIA_ESCOLA_PRIVADA, useNA = "always")
DEPADMPRI
names(DEPADMPRI)
names(DEPADMPRI)<-c("Particular","Comunit�ria","Confessional","Filantr�pica","NA")
n<-sum(DEPADMPRI)
DEPADMPRI
graf_DEPADMPRI<-barplot(sort((DEPADMPRI), decreasing = TRUE),col = c("#009E73"), main="",
                        ylim = c(0,1900), cex.names = .7, cex.axis = .7
)
text(graf_DEPADMPRI, sort(DEPADMPRI, decreasing = TRUE),col="black",pos=3, cex=0.7, paste(sort(DEPADMPRI, decreasing = TRUE),"\n" ,sort(round((DEPADMPRI/n)*100,2), decreasing = TRUE),"%"))
########

DEPXLOCPRI<-table(ESCOLASPRPRIV$TP_CONVENIO_PODER_PUBLICO, useNA = "always")
DEPXLOCPRI
names(DEPXLOCPRI)<-c("Municipal","Estadual","Estadual e Municipal","Sem Conv�nio")
n<-sum(DEPXLOCPRI)
DEPXLOCPRI
graf_DEPXLOCPRI<-barplot(sort((DEPXLOCPRI), decreasing = TRUE),col = c("#009E73"), main="",
                         ylim = c(0,1600), cex.names = .7, cex.axis = .7
)
text(graf_DEPXLOCPRI, sort(DEPXLOCPRI, decreasing = TRUE),col="black",pos=3, cex=0.7, paste(sort(DEPXLOCPRI, decreasing = TRUE),"\n" ,sort(round((DEPXLOCPRI/n)*100,2), decreasing = TRUE),"%"))

###############
##Escolaspri-convenio x depadm

library(gmodels)
CrossTable(ESCOLASPRPRIV$TP_CONVENIO_PODER_PUBLICO,ESCOLASPRPRIV$TP_CATEGORIA_ESCOLA_PRIVADA)
Municipal<-c(9,7,2,219)
Estadual<-c(3,0,0,63)
Municipal_e_Estadual<-c(0,0,0,307)
DEPXCONV<-rbind(Municipal,Estadual,Municipal_e_Estadual)
colnames(DEPXCONV)<-c("Particular","Comunit�ria","Confessional","Filantr�pica")
DEPXCONV
graf_DEPXCONV<-barplot(DEPXCONV, beside  = TRUE,col = c("#E69F00", "#56B4E9", "#009E73"), main="",
                       cex.names = .7, cex.axis = .7,ylim = c(0,400), xlab = "")
legend("topleft", legend=c("Municipal","Estadual","Estadual e Municipal"),
       fill=c("#E69F00", "#56B4E9", "#009E73", "#F0E442"), bty="n")
text(graf_DEPXCONV, DEPXCONV,col="black",pos=3, cex=0.7, paste(DEPXCONV))
#################################
#Painel de graficos - por infra estrut. elementar
##################################
par(mfrow = c(1,1)) # Janela com 2 linhas e 1 coluna
pie(table(ESCOLASPRPRIV$IN_AGUA_FILTRADA), col=c("red","green"), main ="�gua filtrada?(Pri)", labels = c("13,77%","86,23%"))
pie(table(ESCOLASPRPUB$IN_AGUA_FILTRADA), col=c("red","green"), main ="�gua filtrada?(Pub)", labels = c("45,29%","54,71%"))
pie(table(ESCOLASPRPRIV$IN_AGUA_REDE_PUBLICA), col=c("red","green"), main ="Abastecimento?(Pri)", labels = c("2,75%","97,25%"))
pie(table(ESCOLASPRPUB$IN_AGUA_REDE_PUBLICA), col=c("red","green"), main ="Abastecimento?(Pub)", labels = c("12,25%","87,75%"))
pie(table(ESCOLASPRPRIV$IN_ENERGIA_INEXISTENTE), col=c("green","red"), main ="Energia?(Pri)", labels = c("100%","0%"))
pie(table(ESCOLASPRPUB$IN_ENERGIA_INEXISTENTE), col=c("green","red"), main ="Energia?(Pub)", labels = c("99,94%","0,06%"))
#
pie(table(ESCOLASPRPRIV$IN_ESGOTO_INEXISTENTE), col=c("green","red"), main ="Esgoto?(Pri)", labels = c("99,9%","0,1%"))
pie(table(ESCOLASPRPUB$IN_ESGOTO_INEXISTENTE), col=c("green","red"), main ="Esgoto?(Pub)", labels = c("99,65%","0,35%"))
pie(table(ESCOLASPRPRIV$IN_BANHEIRO_DENTRO_PREDIO), col=c("red","green"), main ="WC Interno?(Pri)", labels = c("2,13%","97,87%"))
pie(table(ESCOLASPRPUB$IN_BANHEIRO_DENTRO_PREDIO), col=c("red","green"), main ="WC Interno?(Pub)", labels = c("4,41%","95,59%"))
pie(table(ESCOLASPRPRIV$IN_BANHEIRO_PNE), col=c("red","green"), main ="WC Acess�vel(Pri)", labels = c("35,24%","64,76%"))
pie(table(ESCOLASPRPUB$IN_BANHEIRO_PNE), col=c("red","green"), main ="WC Acess�vel?(Pub)", labels = c("45,23%","54,77%"))
#
pie(table(ESCOLASPRPRIV$IN_BANHEIRO_PNE), col=c("red","green"), main ="Depend. Acess�veis?(PRI)", labels = c("44,39%","55,61%"))
pie(table(ESCOLASPRPUB$IN_BANHEIRO_PNE), col=c("red","green"), main ="Depend. Acess�veis?(PUB)", labels = c("56,51%","43,49%"))
pie(table(ESCOLASPRPRIV$IN_BANHEIRO_PNE), col=c("red","green"), main ="Cozinha(Pri)", labels = c("7,17%","92,83"))
pie(table(ESCOLASPRPUB$IN_BANHEIRO_PNE), col=c("red","green"), main ="Cozinha(Pub)", labels = c("1,39%","98,61%"))
################
#Tabela para mapas
#############
INFRAESCOLASPRIV<- subset(ESCOLASPRPRIV, select = c(2,3,5,6,13,14,15,16,17,18,19,20))
names(ESCOLASPRPRIV)
str(INFRAESCOLASPRIV)
##Alterando valores p/ energ elet  esgoto p/ 
INFRAESCOLASPRIV$IN_ENERGIA_EXISTENTE<-INFRAESCOLASPRIV$IN_ENERGIA_INEXISTENTE
names(INFRAESCOLASPRIV)
str(INFRAESCOLASPRIV)  
INFRAESCOLASPRIV$IN_ENERGIA_EXISTENTE[INFRAESCOLASPRIV$IN_ENERGIA_EXISTENTE==0]<-1
table(INFRAESCOLASPRIV$IN_ENERGIA_EXISTENTE)
INFRAESCOLASPRIV$IN_ESGOTO_EXISTENTE<-INFRAESCOLASPRIV$IN_ESGOTO_INEXISTENTE
table(INFRAESCOLASPRIV$IN_ESGOTO_EXISTENTE)
INFRAESCOLASPRIV$IN_ESGOTO_EXISTENTE[INFRAESCOLASPRIV$IN_ESGOTO_EXISTENTE==0]<-2
INFRAESCOLASPRIV$IN_ESGOTO_EXISTENTE[INFRAESCOLASPRIV$IN_ESGOTO_EXISTENTE==1]<-0
INFRAESCOLASPRIV$IN_ESGOTO_EXISTENTE[INFRAESCOLASPRIV$IN_ESGOTO_EXISTENTE==2]<-1
table(INFRAESCOLASPRIV$IN_ESGOTO_EXISTENTE)
names(INFRAESCOLASPRIV)
INFRAESCOLASPRIV<- subset(INFRAESCOLASPRIV, select = c(1,2,3,4,5,6,9,10,11,12,13,14))
INFRAESCOLASPRIV
INFRAESCOLASPRIV$ScorePRI<-c(INFRAESCOLASPRIV$IN_AGUA_FILTRADA+
                               INFRAESCOLASPRIV$IN_AGUA_REDE_PUBLICA+
                               INFRAESCOLASPRIV$IN_COZINHA+
                               INFRAESCOLASPRIV$IN_BANHEIRO_DENTRO_PREDIO+
                               INFRAESCOLASPRIV$IN_BANHEIRO_PNE+ 
                               INFRAESCOLASPRIV$IN_DEPENDENCIAS_PNE+
                               INFRAESCOLASPRIV$IN_ENERGIA_EXISTENTE+
                               INFRAESCOLASPRIV$IN_ESGOTO_EXISTENTE)
INFRAESCOLASPRIV$ScorePRI<-(INFRAESCOLASPRIV$ScorePRI/8)*100
INFRAESCOLASPRIVEXP<-table(INFRAESCOLASPRIV$CO_MUNICIPIO, INFRAESCOLASPRIV$ScorePRI)
write.table(INFRAESCOLASPRIVEXP, "INFRAPRI.txt", sep=";", row.names = TRUE, col.names = TRUE, quote = FALSE)
################
#Mapa PRIV
require(XML)
require(RCurl)
require(rgdal)
require(maptools)
require(RColorBrewer)
##################################################################
mapaUF = readShapePoly("./PR/41MUE250GC_SIR.shp")
plot(mapaUF)
length(mapaUF@data$NM_MUNICIP)#qt mun
##############################################################
dados<- read.table("C://r//infrapub//ScorePRI.csv", header=TRUE, sep=";", dec = ",", na.strings = "0")
####################################################
?read.table
####################################################
dados$Score = cut(dados$Score, breaks=c(0,20,40,60,80,100),
                  labels=c('0 at� 20','20 a 40', '40 a 60','60 a 80','80 a 100'))
dados
paletaDeCores = brewer.pal(9, 'YlOrRd')#Greens#OrRd
paletaDeCores
paletaDeCores = paletaDeCores[-c(2,3,7,9)]
# Agora fazemos um pareamento entre as faixas da vari�vel (categ�rica) e as cores:
coresDasCategorias = data.frame(Score=levels(dados$Score), Cores=paletaDeCores)

dados = merge(dados, coresDasCategorias)
dados
############################################
mapaData = attr(mapaUF, 'data')
mapaData$Index = row.names(mapaData)
names(mapaData)[2] = "GEOCMU"
names(dados)
names(mapaData)

mapaData = merge(mapaData, dados, by="GEOCMU")
attr(mapaUF, 'data') = mapaData

#########################################################################################
parDefault = par(no.readonly = T)
layout(matrix(c(1,2),nrow=2),widths= c(1,1), heights=c(4,1))
par (mar=c(0,0,0,0))
# Plotando mapa
plot(mapaUF, col=as.character(mapaData$Cores))
plot(1,1,pch=NA, axes=F)
legend(x='center', legend=rev(levels(mapaData$Score)),
       box.lty=0, fill=rev(paletaDeCores),cex=.8, ncol=2,
       title='Mapa das escolas PRIVADAS com \n Infraestrutura Elementar')
###############################################################
###################################################################################################################


####################################################################################################################
################
#Tabela para mapas
#############
INFRAESCOLASPUB<- subset(ESCOLASPRPUB, select = c(2,3,5,6,13,14,15,16,17,18,19,20))
names(INFRAESCOLASPUB)
str(INFRAESCOLASPUB)

##Alterando valores p/ energ elet  esgoto p/ 
INFRAESCOLASPUB$IN_ENERGIA_EXISTENTE<-INFRAESCOLASPUB$IN_ENERGIA_INEXISTENTE
names(INFRAESCOLASPUB)
str(INFRAESCOLASPUB)  
table(INFRAESCOLASPUB$IN_ENERGIA_EXISTENTE)
INFRAESCOLASPUB$IN_ENERGIA_EXISTENTE[INFRAESCOLASPUB$IN_ENERGIA_EXISTENTE==0]<-2
INFRAESCOLASPUB$IN_ENERGIA_EXISTENTE[INFRAESCOLASPUB$IN_ENERGIA_EXISTENTE==1]<-0
INFRAESCOLASPUB$IN_ENERGIA_EXISTENTE[INFRAESCOLASPUB$IN_ENERGIA_EXISTENTE==2]<-1

table(INFRAESCOLASPUB$IN_ENERGIA_EXISTENTE)
INFRAESCOLASPUB$IN_ESGOTO_EXISTENTE<-INFRAESCOLASPUB$IN_ESGOTO_INEXISTENTE
table(INFRAESCOLASPUB$IN_ESGOTO_EXISTENTE)
INFRAESCOLASPUB$IN_ESGOTO_EXISTENTE[INFRAESCOLASPUB$IN_ESGOTO_EXISTENTE==0]<-2
INFRAESCOLASPUB$IN_ESGOTO_EXISTENTE[INFRAESCOLASPUB$IN_ESGOTO_EXISTENTE==1]<-0
INFRAESCOLASPUB$IN_ESGOTO_EXISTENTE[INFRAESCOLASPUB$IN_ESGOTO_EXISTENTE==2]<-1
table(INFRAESCOLASPUB$IN_ESGOTO_EXISTENTE)
names(INFRAESCOLASPUB)
INFRAESCOLASPUB<- subset(INFRAESCOLASPUB, select = c(1,2,3,4,5,6,9,10,11,12,13,14))
names(INFRAESCOLASPUB)
INFRAESCOLASPUB$ScorePUB<-c(INFRAESCOLASPUB$IN_AGUA_FILTRADA+
                              INFRAESCOLASPUB$IN_AGUA_REDE_PUBLICA+
                              INFRAESCOLASPUB$IN_COZINHA+
                              INFRAESCOLASPUB$IN_BANHEIRO_DENTRO_PREDIO+
                              INFRAESCOLASPUB$IN_BANHEIRO_PNE+ 
                              INFRAESCOLASPUB$IN_DEPENDENCIAS_PNE+
                              INFRAESCOLASPUB$IN_ENERGIA_EXISTENTE+
                              INFRAESCOLASPUB$IN_ESGOTO_EXISTENTE)
INFRAESCOLASPUB$ScorePUB<-(INFRAESCOLASPUB$ScorePUB/8)*100
INFRAESCOLASPUBEXP<-table(INFRAESCOLASPUB$CO_MUNICIPIO, INFRAESCOLASPUB$ScorePUB)
table(INFRAESCOLASPUB$CO_MUNICIPIO, INFRAESCOLASPUB$ScorePUB)
write.table(INFRAESCOLASPUBEXP, "INFRAPUB.txt", sep=";", row.names = TRUE, col.names = TRUE, quote = FALSE)
################
#Mapa PUBLICA
require(XML)
require(RCurl)
require(rgdal)
require(maptools)
require(RColorBrewer)
##################################################################
mapaUF = readShapePoly("./PR/41MUE250GC_SIR.shp")
plot(mapaUF)
length(mapaUF@data$NM_MUNICIP)#qt mun
##############################################################
dados<- read.table("C://r//infrapub//ScorePUB.csv", header=TRUE, sep=";", dec = ",", na.strings = "0")
####################################################
?read.table
####################################################
dados$Score = cut(dados$Score, breaks=c(0,20,40,60,80,100),
                  labels=c('0 at� 20','20 a 40', '40 a 60','60 a 80','80 a 100'))
dados
paletaDeCores = brewer.pal(9, 'YlOrRd')#Greens#OrRd
paletaDeCores
paletaDeCores = paletaDeCores[-c(2,3,7,9)]
# Agora fazemos um pareamento entre as faixas da vari�vel (categ�rica) e as cores:
coresDasCategorias = data.frame(Score=levels(dados$Score), Cores=paletaDeCores)

dados = merge(dados, coresDasCategorias)
dados
############################################
mapaData = attr(mapaUF, 'data')
mapaData$Index = row.names(mapaData)
names(mapaData)[2] = "GEOCMU"
names(dados)
names(mapaData)

mapaData = merge(mapaData, dados, by="GEOCMU")
attr(mapaUF, 'data') = mapaData

#########################################################################################
parDefault = par(no.readonly = T)
layout(matrix(c(1,2),nrow=2),widths= c(1,1), heights=c(4,1))
par (mar=c(0,0,0,0))
# Plotando mapa
plot(mapaUF, col=as.character(mapaData$Cores))
plot(1,1,pch=NA, axes=F)
legend(x='center', legend=rev(levels(mapaData$Score)),
       box.lty=0, fill=rev(paletaDeCores),cex=.8, ncol=2,
       title='Mapa das escolas PUBLICAS com \n Infraestrutura Elementar')
###############################################################
###################################################################################################################
#boxplot
dados<- read.table("C://r//infrapub//ScorePUB.csv", header=TRUE, sep=";", dec = ",", na.strings = "0")
dados1<- read.table("C://r//infrapub//ScorePRI.csv", header=TRUE, sep=";", dec = ",", na.strings = "0")
boxplot(dados$Score,dados1$Score, col = "#009E73", names = c("Publicas","Privadas"))
################
