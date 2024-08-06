######################ANÁLISE#####################################

df_p = df1 %>% filter(prev>0)
df_p <- df_p[!is.na(df_p$prev) & !is.nan(df_p$prev) & is.finite(df_p$prev),]
df_p = df_p %>% filter(between(tx_cobertura,20,120))
df_p = df_p %>% filter(between(pc_cobertura_ab,20,120))
# Converta 'estrato' para fator, se ainda não for
df_p$estrato <- as.factor(df_p$estrato)

# Defina o nível de referência como 'Baixo'
df_p$estrato <- relevel(df_p$estrato, ref = "Baixo")

model=glm(prev~pc_cobertura_ab_r+tx_cobertura,data=df_p)
summary(model)
car::compareCoefs(model,
                  pvals = T)

library(broom)
# Usar a função tidy do broom para obter os resultados do modelo em formato tidy
tidy_model <- tidy(model, conf.int = TRUE, conf.level = 0.95)

# Exibir a tabela com as estimativas, intervalos de confiança e valores de p
print(tidy_model)

c.1=glm(prev~pc_cobertura_ab_r+factor(estrato),data=df_p)

car::compareCoefs(c.1,
                  pvals = T)

summary(c.1)

