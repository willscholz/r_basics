
#DATASET:
# https://towardsdatascience.com/a-feature-selection-tool-for-machine-learning-in-python-b64dd23710f0

#PACOTE CORRR:
# https://drsimonj.svbtle.com/exploring-correlations-in-r-with-corrr

library(dplyr)
library(tidyr)
library(mlr)
library(randomForest)
library(corrr)
library(openxlsx)


setwd("C:/Users/schowi02/Desktop/Kaggle Dataset - Home Credit")
df_model = read.csv('application_train.csv')


#FUNÇÃO AUXILIAR PARA MODA TANTO NUM COMO FACT
Modes <- function(x) {
  ux <- unique(x)
  ux = ux[!is.na(ux)]
  tab <- tabulate(match(x, ux))
  ux[tab == max(tab)]
}

#FUNÇÃO AUXILIAR QUE RETORNA SE VALOR É IGUAL MODA (RETORNA BOOL)
EqMode <- function(x){
  b = x %in% Modes(x)
  return(sum(b, na.rm = T))
}

#FUNÇÃO AUXILIAR PARA CONTAR VALORES DISTINTOS TANTO NUM COMO FACTOR
countDistinct <- function(x) {
  if (class(x)=="factor"){
    cnt <- length(levels(x))
  }
  else{
    cnt <- length(unique(x))
  }
  
  return(cnt)
}


feature_select <- function(df, y, na_max = 0.4, mode_max = 0.95, zero_max = 0.95, 
                           corr_max = 0.6, exclude = c(NULL), 
                           feat_imp=FALSE, sample_RF=20000, n_tree = 25, output_excel="") {
  
  
  featureName = colnames(df)
  featureName <- featureName[!featureName %in% exclude]
  #featureName[!featureName %in% y] #elimina variavel target da analise
  df_featureselec = as.data.frame(featureName)
  df = df[,featureName]
  
  #OUTPUT1: TABELA COM LISTA E STATS DE TODOS OS FEATURES-------------------------------
  df_featureselec$Type = sapply(df, class)
  df_featureselec$is_Num = sapply(df, is.numeric)
  df_featureselec$is_y = df_featureselec$featureName %in% y 
  df_featureselec$Distinct = sapply(df, countDistinct)
  df_featureselec$is_Bin = ifelse(df_featureselec$Distinct == 2, TRUE, FALSE)
  df_featureselec$NA_n = colSums(is.na(df) | df == "" , na.rm = T) 
  df_featureselec$ZERO_n = colSums(df == 0 | df == "0", na.rm = T)
  df_featureselec$MODE_n = sapply(df, EqMode)
  df_featureselec$NA_p = df_featureselec$NA_n / nrow(df)
  df_featureselec$ZERO_p = df_featureselec$ZERO_n / nrow(df)
  df_featureselec$MODE_p = df_featureselec$MODE_n / nrow(df) 
  df_featureselec$Select_1 = df_featureselec$NA_p <= na_max & df_featureselec$MODE_p <= mode_max & df_featureselec$MODE_p <= zero_max & df_featureselec$is_y == FALSE 

  
  
  #OUTPUT2: MATRIZ DE CORRELAÇÃO-------------------------------------------------------

  filtered_features = df_featureselec %>% filter((Select_1 == TRUE & is_Num == TRUE & Distinct != 2) | is_y == TRUE)
  features_cor = filtered_features[,"featureName"] 
  
  #imputar média p/ missings de vars selecionadas (CUIDADO COM MISS NO Y)
  NA2mean <- function(x) replace(x, is.na(x), round(mean(x, na.rm = TRUE)))
  df_imput = df %>% select(features_cor) %>% sapply(NA2mean) %>% as.data.frame()
  
  #fazer matriz de correlação nesse df com imputação
  matrix_corr = df_imput %>% correlate(diagonal = 0) 
  
  
  #Matriz de corr com alta corr
  matrix_corr_abs = matrix_corr %>% filter(rowname != y) %>% select(-y, -rowname) %>% abs() #tirar var resposta e coluna de nomes feature
  max_corr = sapply(matrix_corr_abs, max) %>% as.data.frame()
  max_corr$featureName = row.names(max_corr)
  high_corr = max_corr[max_corr$. > corr_max, "featureName"] #lista de variaves com alta corr
  matrix_corr2 = matrix_corr[matrix_corr$rowname %in% high_corr, c("rowname",high_corr,y)]
  
  
  #3. ITEM DA LISTA: TABELA COMPLETA COM DECISÕES E FEATURE IMPORTANCES/testes estat
  df_featureselec = df_featureselec %>% left_join(matrix_corr[,c("rowname",y)], by = c("featureName" = "rowname")) %>% rename(y_cor = y)
  
  tab_y = matrix_corr2 %>% select(rowname,y)
  tab_y[,y] = abs(tab_y[,y]) #tabela com corr com y
  
  matrix_corr2_abs = matrix_corr2 %>% select(-rowname, -y) %>%  abs()
  matrix_corr2_abs$rowname = matrix_corr2$rowname #matriz com cor absoluta
  
  #faz lista de variaveis com maior corr com y
  feat_to_select = matrix_corr2_abs$rowname
  var_selec_vec = c(NULL)
  var_disc_vec = c(NULL)
  for (i in feat_to_select){
    vars_cor = matrix_corr2_abs[matrix_corr2_abs[,i] > corr_max,"rowname"]
    vars_cor = rbind(vars_cor,i)
    vars_cor = vars_cor %>% left_join(tab_y, by="rowname") 
    vars_cor = vars_cor[order(-vars_cor[,y]),]
    var_selec = vars_cor[1,1]
    var_disc = vars_cor[-1,1] 
    var_selec_vec = rbind(var_selec_vec, var_selec)
    var_disc_vec = rbind(var_disc_vec, var_disc)
  }
  
  var_selec_vec_unique = unique(var_selec_vec)
  var_disc_vec_unique = unique(var_disc_vec)
  
  df_featureselec$discardCorr = df_featureselec$featureName %in% var_disc_vec_unique$rowname
  df_featureselec$Select_2 = ifelse(df_featureselec$Select_1 == FALSE, "NA/Zero/Unique", ifelse(df_featureselec$discardCorr == TRUE, "High corr", "Selected"))
  df_featureselec$Obs = ifelse(df_featureselec$Distinct >50 & df_featureselec$is_Num == FALSE, ">50 factor levels. Not possible run RF", ifelse(df_featureselec$Distinct >10 & df_featureselec$is_Num == FALSE, ">10 factor levels. Consider bining","-"))
  
  matrix_corr3 = rearrange(matrix_corr2) #clusterizando correlações
  matrix_corr3 = matrix_corr3 %>% left_join(matrix_corr[,c("rowname", y)], by = "rowname")
  matrix_corr3 = matrix_corr3[,c(1, ncol(matrix_corr3), seq(2,ncol(matrix_corr3)-1))]
  
  if (feat_imp){
    df_sample = sample_n(df, sample_RF)
    features_selected = df_featureselec %>% filter(Select_2 == "Selected" & Obs != ">50 factor levels. Not possible run RF") %>% select(featureName) %>% as.vector()
    features_selected =features_selected[,1]
    features_selected2 = paste(features_selected, collapse=" + ")
    
    f <- as.formula(paste(y, "~", features_selected2))
    
    RF = randomForest(formula = f, data=df_sample, ntree = n_tree, keep.forest = FALSE, importance = TRUE, na.action = na.omit)
    FI = as.data.frame(importance(RF))
    FI = FI %>% arrange(by_group = desc(`%IncMSE`))
    FI$featureName = rownames(FI)
    FI = FI[,c(3,1,2)]
    
    df_featureselec = df_featureselec %>% left_join(FI, by = "featureName")
    
    
    #exporta excel
    if(output_excel != ""){
      list_of_datasets <- list("Table of features" = df_featureselec, "Correlation Matrix" = matrix_corr, "High Correlation Matrix" = matrix_corr3, "Feature Importance" = FI)
      write.xlsx(list_of_datasets, file = output_excel)
    }
    
    
    return(list(table1 = df_featureselec, matrix = matrix_corr, matrix_h_corr = matrix_corr3, feat_imp = FI))
  } 
  
  
  #exporta excel sem feature importance
  if(output_excel != ""){
    list_of_datasets <- list("Table of features" = df_featureselec, "Correlation Matrix" = matrix_corr, "High Correlation Matrix" = matrix_corr3)
    write.xlsx(list_of_datasets, file = output_excel)
  }
  
  return(list(table1 = df_featureselec, matrix = matrix_corr, matrix_h_corr = matrix_corr3))
    
  #fazer score F estatistico variaveis
  #1.categorizar numericos
  #2.rodar teste estatístico
  
  #pegar vars selecionadas efazer modelo RF para ter FI
  #colocar na tabela FI de cada var
  
  
  #return(list(table1 = df_featureselec))

}




feature_select_table1 <- function(df, y, na_max = 0.4, mode_max = 0.95, zero_max = 0.95, 
                           corr_max = 0.6, exclude = c(NULL)) {
  
  
  featureName = colnames(df)
  featureName <- featureName[!featureName %in% exclude]
  #featureName[!featureName %in% y] #elimina variavel target da analise
  df_featureselec = as.data.frame(featureName)
  df = df[,featureName]
  
  #OUTPUT1: TABELA COM LISTA E STATS DE TODOS OS FEATURES-------------------------------
  df_featureselec$Type = sapply(df, class)
  df_featureselec$is_Num = sapply(df, is.numeric)
  df_featureselec$is_y = df_featureselec$featureName %in% y 
  df_featureselec$Distinct = sapply(df, countDistinct)
  df_featureselec$is_Bin = ifelse(df_featureselec$Distinct == 2, TRUE, FALSE)
  df_featureselec$NA_n = colSums(is.na(df) | df == "" , na.rm = T) 
  df_featureselec$ZERO_n = colSums(df == 0 | df == "0", na.rm = T)
  df_featureselec$MODE_n = sapply(df, EqMode)
  df_featureselec$NA_p = df_featureselec$NA_n / nrow(df)
  df_featureselec$ZERO_p = df_featureselec$ZERO_n / nrow(df)
  df_featureselec$MODE_p = df_featureselec$MODE_n / nrow(df) 
  df_featureselec$Select_1 = df_featureselec$NA_p <= na_max & df_featureselec$MODE_p <= mode_max & df_featureselec$ZERO_p <= zero_max & df_featureselec$is_y == FALSE 
  
  return(df_featureselec)
  
}


feature_select_matrix <- function(df, table1, corr_max = 0.6, y){
  df_featureselec = table1

  filtered_features = df_featureselec %>% filter((Select_1 == TRUE & is_Num == TRUE & Distinct != 2) | is_y == TRUE)
  features_cor = filtered_features[,"featureName"] 
  
  #imputar média p/ missings de vars selecionadas (CUIDADO COM MISS NO Y)
  NA2mean <- function(x) replace(x, is.na(x), round(mean(x, na.rm = TRUE)))
  df_imput = df %>% select(features_cor) %>% sapply(NA2mean) %>% as.data.frame()
  
  #fazer matriz de correlação nesse df com imputação
  matrix_corr = df_imput %>% correlate(diagonal = 0) 
  
  
  #Matriz de corr com alta corr
  matrix_corr_abs = matrix_corr %>% filter(rowname != y) %>% select(-y, -rowname) %>% abs() #tirar var resposta e coluna de nomes feature
  max_corr = sapply(matrix_corr_abs, max) %>% as.data.frame()
  max_corr$featureName = row.names(max_corr)
  high_corr = max_corr[max_corr$. > corr_max, "featureName"] #lista de variaves com alta corr
  matrix_corr2 = matrix_corr[matrix_corr$rowname %in% high_corr, c("rowname",high_corr,y)]
  
  
  return(list(matrix = matrix_corr, matrix_h_corr = matrix_corr2))
  
}



feature_select_table2 <- function(table1, out_matrix, y, corr_max = 0.6){
  
  df_featureselec = table1
  matrix_corr2 = out_matrix$matrix_h_corr
  matrix_corr = out_matrix$matrix
  
  df_featureselec = df_featureselec %>% left_join(matrix_corr[,c("rowname",y)], by = c("featureName" = "rowname")) %>% rename(y_cor = y)
  
  tab_y = matrix_corr2 %>% select(rowname,y)
  tab_y[,y] = abs(tab_y[,y]) #tabela com corr com y
  
  matrix_corr2_abs = matrix_corr2 %>% select(-rowname, -y) %>%  abs()
  matrix_corr2_abs$rowname = matrix_corr2$rowname #matriz com cor absoluta
  
  #faz lista de variaveis com maior corr com y
  feat_to_select = matrix_corr2_abs$rowname
  var_selec_vec = c(NULL)
  var_disc_vec = c(NULL)
  for (i in feat_to_select){
    vars_cor = matrix_corr2_abs[matrix_corr2_abs[,i] > corr_max,"rowname"]
    vars_cor = rbind(vars_cor,i)
    vars_cor = vars_cor %>% left_join(tab_y, by="rowname") 
    vars_cor = vars_cor[order(-vars_cor[,y]),]
    var_selec = vars_cor[1,1]
    var_disc = vars_cor[-1,1] 
    var_selec_vec = rbind(var_selec_vec, var_selec)
    var_disc_vec = rbind(var_disc_vec, var_disc)
  }
  
  var_selec_vec_unique = unique(var_selec_vec)
  var_disc_vec_unique = unique(var_disc_vec)
  
  df_featureselec$discardCorr = df_featureselec$featureName %in% var_disc_vec_unique$rowname
  df_featureselec$Select_2 = ifelse(df_featureselec$Select_1 == FALSE, "NA/Zero/Unique", ifelse(df_featureselec$discardCorr == TRUE, "High corr", "Selected"))
  df_featureselec$Obs = ifelse(df_featureselec$Distinct >50 & df_featureselec$is_Num == FALSE, ">50 factor levels. Not possible run RF", ifelse(df_featureselec$Distinct >10 & df_featureselec$is_Num == FALSE, ">10 factor levels. Consider bining","-"))
  
  matrix_corr3 = rearrange(matrix_corr2) #clusterizando correlações
  matrix_corr3 = matrix_corr3 %>% left_join(matrix_corr[,c("rowname", y)], by = "rowname")
  matrix_corr3 = matrix_corr3[,c(1, ncol(matrix_corr3), seq(2,ncol(matrix_corr3)-1))]
  
  return(list(table2 = df_featureselec, matrix_clust = matrix_corr3))
  
}


feature_select_final <- function(df, y, out_table2, out_matrix, sample_RF = 20000, n_tree=50, feat_imp = FALSE, output_excel=""){
  
  df_featureselec = out_table2$table2
  matrix_corr = out_matrix$matrix
  matrix_corr3 = out_table2$matrix_clust
  
  if (feat_imp){
    
    df_sample = sample_n(df, sample_RF)
    features_selected = df_featureselec %>% filter(Select_2 == "Selected" & Obs != ">50 factor levels. Not possible run RF") %>% select(featureName) %>% as.vector()
    features_selected = features_selected[,1]
    features_selected2 = paste(features_selected, collapse=" + ")
    
    f <- as.formula(paste(y, "~", features_selected2))
    
    RF = randomForest(formula = f, data=df_sample, ntree = n_tree, keep.forest = FALSE, importance = TRUE, na.action = na.omit)
    FI = as.data.frame(importance(RF))
    FI = FI %>% arrange(by_group = desc(`%IncMSE`))
    FI$featureName = rownames(FI)
    FI = FI[,c(3,1,2)]
    df_featureselec = df_featureselec %>% left_join(FI, by = "featureName")
    
    
    #exporta excel
    if(output_excel != ""){
      list_of_datasets <- list("Table of features" = df_featureselec, "Correlation Matrix" = matrix_corr, "High Correlation Matrix" = matrix_corr3, "Feature Importance" = FI)
      write.xlsx(list_of_datasets, file = output_excel)
    }
    
    
    return(list(table1 = df_featureselec, matrix = matrix_corr, matrix_h_corr = matrix_corr3, feat_imp = FI))
  } 
  
  
  
  #exporta excel sem feature importance
  if(output_excel != ""){
    list_of_datasets <- list("Table of features" = df_featureselec, "Correlation Matrix" = matrix_corr, "High Correlation Matrix" = matrix_corr3)
    write.xlsx(list_of_datasets, file = output_excel)
  }
  
  return(list(table1 = df_featureselec, matrix = matrix_corr, matrix_h_corr = matrix_corr3))
  

}



#FUNÇÕES QUEBRADAS
output_table1 = feature_select_table1(df_model, y="AMT_CREDIT", exclude = c("ORGANIZATION_TYPE")) #retorna tabela
output_matrices = feature_select_matrix(df_model, table1 = output_table1, y="AMT_CREDIT") #retorna lista com duas matrizes
output_table2 = feature_select_table2(table1 = output_table1, out_matrix = output_matrices, y="AMT_CREDIT") #retorna lista com tabela 2 e matriz clusterizada
output_table3 = feature_select_final(df=df_model, y="AMT_CREDIT", out_matrix = output_matrices, out_table2 = output_table2, output_excel="EDA_feature.xlsx", feat_imp = TRUE)


#FUNÇÃO COMPLETA
output = feature_select(df_model, y="AMT_CREDIT", exclude = c("ORGANIZATION_TYPE"), 
                        feat_imp = TRUE, output_excel="EDA_feature.xlsx")


nrow(df_model)
length(unique(df_model$SK_ID_CURR))

unique(df_model$TARGET)
sum(is.na(df_model$TARGET))
sum(df_model$TARGET == 0)

unique(df_model$NAME_CONTRACT_TYPE)
df_model %>% group_by(NAME_CONTRACT_TYPE) %>% count()
sum(is.na(df_model$NAME_CONTRACT_TYPE))

unique(df_model$CODE_GENDER)
df_model %>% group_by(CODE_GENDER) %>% count()

length(unique(df_model$CNT_CHILDREN))
df_model %>% group_by(CNT_CHILDREN) %>% count()

OWN_CAR_AGE

sum(is.na(df_model$OWN_CAR_AGE))
sum(df_model$OWN_CAR_AGE == 0, na.rm=T)
df_model %>% group_by(OWN_CAR_AGE) %>% count()


df_model %>% group_by(OCCUPATION_TYPE) %>% count()
sum(is.na(df_model$OCCUPATION_TYPE))

