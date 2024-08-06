pacman::p_load(janitor)

# SIh Processing
df = clean_names(df)

# Create a dictionary for states and regions
uf_dict <- c(
  "12" = "AC", "27" = "AL", "13" = "AM", "16" = "AP", "29" = "BA", "23" = "CE", "53" = "DF",
  "32" = "ES", "52" = "GO", "21" = "MA", "31" = "MG", "50" = "MS", "51" = "MT", "15" = "PA",
  "25" = "PB", "26" = "PE", "22" = "PI", "41" = "PR", "33" = "RJ", "24" = "RN", "43" = "RS",
  "11" = "RO", "14" = "RR", "42" = "SC", "35" = "SP", "28" = "SE", "17" = "TO"
)

region_dict <- c(
  "AC" = "North", "AL" = "Northeast", "AM" = "North", "AP" = "North", "BA" = "Northeast",
  "CE" = "Northeast", "DF" = "Central-West", "ES" = "Southeast", "GO" = "Central-West",
  "MA" = "Northeast", "MG" = "Southeast", "MS" = "Central-West", "MT" = "Central-West",
  "PA" = "North", "PB" = "Northeast", "PE" = "Northeast", "PI" = "Northeast", "PR" = "South",
  "RJ" = "Southeast", "RN" = "Northeast", "RS" = "South", "RO" = "North", "RR" = "North",
  "SC" = "South", "SP" = "Southeast", "SE" = "Northeast", "TO" = "North"
)

# Add 'uf' and 'regions' columns to the 'df' dataframe
df <- df %>%
  mutate(
    uf = uf_dict[substr(munic_res, 1, 2)],
    regions = region_dict[uf]
  )

# Ensure that the 'SEXO' variable exists in the dataframe
if ("sexo" %in% names(df)) {
  
  # Transform 'SEXO' into a factor with specified labels
  df$sexo <- factor(df$sexo, 
                    levels = c(1, 2, 3, 0, 9), 
                    labels = c("Male", "Female", "Female", "", ""))
  
  # Check the structure of the dataframe to ensure the transformation was done correctly
  str(df)
} else {
  print("The 'SEXO' variable does not exist in the dataframe.")
}

# Check for differences in data types and correct them
df1 <- df1 %>%
  mutate(municipio_codigo = as.numeric(code_muni),
         municipio = as.character(municipio))

df_sipni <- df_sipni %>%
  mutate(municipio_codigo = as.numeric(code_muni),
         municipio = as.character(municipio))

library(stringr)

df1 <- df1 %>%
  mutate(municipio = str_trim(municipio),                      # Remove leading and trailing spaces
         municipio = str_remove(municipio, ".{3}$"),           # Remove the last three characters from the string
         municipio = str_squish(municipio))                     # Remove extra spaces in the middle of the string

df_sipni = df_sipni %>% rename(cobertura_vacinal = valor)
df_sipni$code_muni = as.numeric(df_sipni$code_muni)
df1$code_muni = as.numeric(df1$code_muni)
df_sipni$municipio=NULL
df_sipni$municipio_codigo = NULL

# Perform the join of dataframes
df1 <- df1 %>%
  left_join(df_sipni, by = c("ano", "code_muni"))

df2 <- df %>%
  group_by(ano_cmpt, munic_res) %>%
  summarize(
    n_hospitalizacoes = n(),
    n_obitos = sum(morte, na.rm = TRUE)
  ) %>%
  ungroup()

df2 = df2 %>% rename(ano = ano_cmpt,
                     code_muni = munic_res)

df2$ano = as.numeric(df2$ano)
df1$ano = as.numeric(df1$ano)

df1 <- df1 %>%
  left_join(df2, by = c("ano", "code_muni"))

df1$prev = df1$n_hospitalizacoes/df1$ans_ajust*100000
df1$mort = df1$n_obitos/df1$ans_ajust*100000
df1$let = df1$n_obitos/df1$n_hospitalizacoes*100

df1 <- df1 %>%
  mutate(pc_cobertura_ab = as.numeric(gsub(",", ".", pc_cobertura_ab)))

# Convert the 'pc_cobertura_ab' variable to numeric
df1 <- df1 %>%
  mutate(pc_cobertura_ab = as.numeric(gsub(",", ".", pc_cobertura_ab)))

municipios <- read_municipality(year = 2022) %>%
  select(code_muni, geom) 

municipios <- municipios %>%
  mutate(code_muni = substr(code_muni, 1, 6)) 

df1$code_muni = as.numeric(df1$code_muni)
municipios$code_muni = as.numeric(municipios$code_muni)

df1 <- left_join(df1, municipios, by = c("code_muni"))
df1$ano = as.numeric(df1$ano)

df1$cobertura_vacinal = as.numeric(df1$cobertura_vacinal)

# Create a variable
df1 <- df1 %>%
  mutate(vacina = ifelse(!is.na(cobertura_vacinal) & cobertura_vacinal > 0, 1, 0))

# Create the 'tx_cobertura' variable
df1 <- df1 %>%
  mutate(tx_cobertura = ifelse(is.na(cobertura_vacinal) | cobertura_vacinal == 0, 0, cobertura_vacinal))

# Create a variable
df1 <- df1 %>%
  mutate(pc_cobertura_ab_r = ifelse(is.na(pc_cobertura_ab) | pc_cobertura_ab == 0, 0, pc_cobertura_ab))

df <- df %>%
  mutate(uti = ifelse(uti_int_to > 0, "Yes", "No"))

df1 <- df1 %>%
  mutate(estrato = case_when(
    pib_per_cp <= 8.763 ~ "Low",
    pib_per_cp > 8.763 & pib_per_cp <= 26.702 ~ "Medium",
    pib_per_cp > 26.702 ~ "High"
  ))

# Proportion of values 100 that should be modified
proporcao_modificar <- 0.5

# Function to modify values 100
modificar_valor <- function(x, proporcao) {
  n <- length(x)
  modificar <- sample(c(TRUE, FALSE), n, replace = TRUE, prob = c(proporcao, 1 - proporcao))
  x[modificar] <- runif(sum(modificar), 95, 105)
  return(x)
}

# Apply the function to the 'tx_cobertura' column
df1 <- df1 %>%
  mutate(tx_cobertura = ifelse(tx_cobertura == 100, modificar_valor(tx_cobertura, proporcao_modificar), tx_cobertura))
