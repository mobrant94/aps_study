pacman::p_load(tidyverse)

df_sipni = read.csv2("si_pni.csv")

# Separate the 'municipio' column into 'code_muni' and 'municipio'
df_sipni <- df_sipni %>%
  separate(municipio, into = c("code_muni", "municipio"), sep = " ", extra = "merge", fill = "right")

df_sipni$code_muni = as.numeric(df_sipni$code_muni)

df_sipni = df_sipni %>% filter(!(is.na(code_muni)))

# Transform the data into long format
df_sipni <- df_sipni %>%
  pivot_longer(cols = starts_with("anos_"), 
               names_to = "ano", 
               values_to = "valor")

# Remove the "anos_" prefix from the 'ano' column
df_sipni <- df_sipni %>%
  mutate(ano = str_remove(ano, "anos_"))

# Create a dataframe with the years 2008 and 2009 for all municipalities
new_years <- df_sipni %>%
  select(municipio) %>%
  distinct() %>%
  tidyr::expand(municipio, ano = c("2008", "2009")) %>%
  mutate(valor = 0)

# Combine the original dataframe with the newly added years
df_sipni_updated <- bind_rows(df_sipni, new_years)

# Optional: Sort the dataframe by 'code_muni' and 'ano' for better visualization
df_sipni <- df_sipni_updated %>%
  arrange(code_muni, ano)

rm(df_sipni_updated, new_years)
