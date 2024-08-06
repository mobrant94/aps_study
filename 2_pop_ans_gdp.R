# Load necessary libraries
pacman::p_load("sidrar", "ineq", "tidyverse", "ggspatial", 
               "ggplot2", "plotly", "geobr", "gt", "janitor", 
               "gtsummary", "stringr", "tidyr")

# PIB data from IBGE
pib <- get_sidra(api = '/t/5938/n6/all/v/37/p/last%208/d/v37%200')
pib2 <- get_sidra(api = "/t/5938/n6/all/v/37/p/2008,2009,2010,2011,2012,2013/d/v37%200")

# Clean column names
pib <- pib %>%
  clean_names()

pib2 <- pib2 %>%
  clean_names()

# Combine dataframes
pib <- bind_rows(pib, pib2)
rm(pib2)

# Select relevant columns
pib <- pib %>%
  select(municipio_codigo, municipio, ano, renda = valor)

# Handle specific data adjustments
pib <- pib %>%
  mutate(
    renda = if_else(
      municipio == "Guamaré - RN", 
      gsub("(-19046|4199|260612|266331)", "892003", as.character(renda)),
      as.character(renda)
    )
  )

# Convert income column to numeric
pib <- pib %>%
  mutate(renda = as.numeric(renda))

# Sort data by municipality and year
pib <- pib %>%
  arrange(municipio, ano)

# Filter data up to 2021
pib_historico <- pib %>%
  filter(ano <= 2021)

# Calculate average annual growth rate
pib_growth <- pib_historico %>%
  group_by(municipio_codigo, municipio) %>%
  arrange(ano) %>%
  mutate(
    lag_renda = lag(renda),
    growth_rate = (renda - lag_renda) / lag_renda * 100
  ) %>%
  filter(!is.na(growth_rate)) %>%
  summarize(avg_growth_rate = mean(growth_rate, na.rm = TRUE), .groups = 'drop')

# Filter data for 2021
pib_2021 <- pib %>%
  filter(ano == 2021)

# Estimate income values for 2022 and 2023
pib_estimado <- pib_2021 %>%
  left_join(pib_growth, by = c("municipio_codigo", "municipio")) %>%
  mutate(
    renda_2022 = renda * (1 + avg_growth_rate / 100),
    renda_2023 = renda_2022 * (1 + avg_growth_rate / 100)
  ) %>%
  select(municipio_codigo, municipio, renda_2021 = renda, renda_2022, renda_2023)

# Display results
print(pib_estimado)

# Transform data to long format
pib_estimado_long <- pib_estimado %>%
  pivot_longer(
    cols = starts_with("renda_"),
    names_to = "ano",
    names_prefix = "renda_",
    values_to = "renda"
  )

# Filter out 2021 and convert year to character
pib_estimado_long <- pib_estimado_long %>%
  filter(!(ano == "2021")) %>%
  mutate(
    ano = as.numeric(ano),
    ano = as.character(ano)
  )

# Combine with original PIB data
pib <- bind_rows(pib, pib_estimado_long)

# Organize codes
pib <- pib %>%
  arrange(municipio, ano) %>%
  group_by(municipio) %>%
  fill(municipio_codigo, .direction = "down") %>%
  ungroup()

rm(projecoes_pib, pib_growth_avg, pib_growth, projeções_anos, pib_final, pib_estimado, pib_estimado_long, pib_historico, pib_2021)

# Population data from IBGE
pop010 <- get_sidra(api = "/t/1552/n6/all/v/allxp/p/all/c1/0/c2/0/c286/0/c287/0")
pop22 <- get_sidra(api = "/t/9514/n6/all/v/allxp/p/all/c2/6794/c287/100362/c286/113635")

# Clean column names
pop010 <- pop010 %>%
  clean_names()

pop22 <- pop22 %>%
  clean_names()

# Combine dataframes
pop <- bind_rows(pop010, pop22)
rm(pop22, pop010)

# Select relevant columns
pop <- pop %>%
  select(municipio_codigo, municipio, ano, pop = valor)

# Sort data by municipality and year
pop <- pop %>%
  arrange(municipio, ano)

# Determine unique years in dataset
anos_unicos <- unique(pop$ano)

# Count distinct years for each municipality
municipios_anos <- pop %>%
  group_by(municipio_codigo, municipio) %>%
  summarise(anos_presentes = n_distinct(ano))

# Identify municipalities missing years
municipios_faltando_anos <- municipios_anos %>%
  filter(anos_presentes < length(anos_unicos))

# Display municipalities missing years
print(municipios_faltando_anos)

# Filter data for 2000 and 2010
pop_filtered <- pop %>%
  filter(ano %in% c(2000, 2010))

# Transform data to wide format
pop_wide <- pop_filtered %>%
  pivot_wider(names_from = ano, values_from = pop, names_prefix = "pop_")

# Calculate percentage variation
pop_variation <- pop_wide %>%
  mutate(
    variation = (pop_2010 - pop_2000) / pop_2000 * 100,
    annual_growth = variation / 10
  )

# Function to estimate population based on annual growth
estimate_population <- function(pop_initial, annual_growth, years) {
  pop_est <- numeric(length(years))
  pop_est[1] <- pop_initial
  for (i in 2:length(years)) {
    pop_est[i] <- pop_est[i - 1] * (1 + annual_growth / 100)
  }
  return(pop_est)
}

# Create dataframe for years 2000 to 2010
years <- 2000:2010
pop_complete <- pop_variation %>%
  rowwise() %>%
  mutate(pop_all_years = list(estimate_population(pop_2000, annual_growth, years))) %>%
  unnest(cols = c(pop_all_years)) %>%
  mutate(ano = rep(years, times = n() / length(years)))

# Filter data for years 2010 to 2022
pop_filtered1 <- pop %>%
  filter(ano %in% c(2010, 2022))

# Transform data to wide format for 2010 and 2022
pop_wide1 <- pop_filtered1 %>%
  pivot_wider(names_from = ano, values_from = pop, names_prefix = "pop_")

# Calculate percentage variation
pop_variation1 <- pop_wide1 %>%
  mutate(variation = (pop_2022 - pop_2010),
         annual_growth = variation / 12)

# Function to estimate population based on annual growth (for 2010 onwards)
estimate_population <- function(pop_initial, annual_growth, years) {
  pop_est <- numeric(length(years))
  pop_est[1] <- pop_initial
  for (i in 2:length(years)) {
    pop_est[i] <- pop_est[i - 1] + annual_growth
  }
  return(pop_est)
}

# Create dataframe for years 2010 to 2022
years1 <- 2010:2022
pop_complete1 <- pop_variation1 %>%
  rowwise() %>%
  mutate(pop_all_years = list(estimate_population(pop_2010, annual_growth, years1))) %>%
  unnest(cols = c(pop_all_years)) %>%
  mutate(ano = rep(years1, times = n() / length(years1)))

# Combine the two dataframes
pop <- bind_rows(pop_complete, pop_complete1)
pop <- pop %>% arrange(municipio, ano)

# Remove unnecessary columns
pop$pop_2000 <- NULL
pop$pop_2010 <- NULL
pop$pop_2022 <- NULL

# Function to estimate population for the next year based on annual growth
estimate_next_year_population <- function(pop_last_year, annual_growth) {
  return(pop_last_year + annual_growth)
}

# Filter data for 2022
pop_2022 <- pop %>%
  filter(ano == 2022)

# Calculate population for 2023
pop_2023 <- pop_2022 %>%
  rowwise() %>%
  mutate(pop_2023 = estimate_next_year_population(pop_all_years, annual_growth),
         ano = 2023) %>%
  select(municipio_codigo, municipio, annual_growth, pop_all_years = pop_2023, ano)

# Add new rows for 2023 to the existing dataframe
pop <- bind_rows(pop, pop_2023)
pop <- pop %>% arrange(municipio, ano)

# Remove annual_growth and variation columns
pop$annual_growth <- NULL
pop$variation <- NULL

# Filter data for the years 2008 to 2023
pop <- pop %>% filter(between(ano, 2008, 2023))

# Remove duplicates for the year 2010, keeping the smallest population for each municipality
pop <- pop %>%
  filter(ano == 2010) %>%
  arrange(municipio_codigo, pop_all_years) %>%
  distinct(municipio_codigo, .keep_all = TRUE) %>%
  bind_rows(pop %>% filter(ano != 2010))

# Display result
pop$ano <- as.character(pop$ano)
print(pop)

# Join with PIB data
df1 <- left_join(pop, pib, by = c("municipio_codigo", "municipio", "ano"))

# Population for ages 0 - 4 years projection
pop010 <- get_sidra(api="/t/1552/n6/all/v/allxp/p/all/c1/0/c2/0/c286/0/c287/93070")
pop22 <- get_sidra(api="/t/9514/n6/all/v/allxp/p/all/c2/6794/c287/93070/c286/113635")

# Clean column names
pop010 <- pop010 %>% clean_names()
pop22 <- pop22 %>% clean_names()

# Combine dataframes
pop <- bind_rows(pop010, pop22)

pop <- pop %>%
  select(municipio_codigo, municipio, ano, pop = valor) %>%
  arrange(municipio, ano)

# Filter and transform data for years 2000 and 2010
pop_filtered <- pop %>%
  filter(ano %in% c(2000, 2010))

pop_wide <- pop_filtered %>%
  pivot_wider(names_from = ano, values_from = pop, names_prefix = "pop_")

# Calculate percentage variation
pop_variation <- pop_wide %>%
  mutate(variation = (pop_2010 - pop_2000) / pop_2000 * 100,
         annual_growth = variation / 10)

# Create dataframe for years 2000 to 2010
pop_complete <- pop_variation %>%
  rowwise() %>%
  mutate(pop_all_years = list(estimate_population(pop_2000, annual_growth, years))) %>%
  unnest(cols = c(pop_all_years)) %>%
  mutate(ano = rep(years, times = n() / length(years)))

# Filter to 2010 - 2022
pop_filtered1 <- pop %>%
  filter(ano %in% c(2010, 2022))

# Transform the data - pop 2000 - 2010
pop_wide <- pop_filtered %>%
  pivot_wider(names_from = ano, values_from = pop, names_prefix = "pop_")

# Calculate variation
pop_variation <- pop_wide %>%
  mutate(variation = (pop_2010 - pop_2000) / pop_2000 * 100)

pop_variation <- pop_variation %>%
  mutate(annual_growth = variation / 10)

# Function to calculate estimated population based on annual growth
estimate_population <- function(pop_2000, annual_growth, years) {
  pop_est <- numeric(length(years))
  pop_est[1] <- pop_2000
  for (i in 2:length(years)) {
    pop_est[i] <- pop_est[i - 1] * (1 + annual_growth / 100)
  }
  return(pop_est)
}

# Create dataframe for the years 2000 to 2010
years <- 2000:2010
pop_complete <- pop_variation %>%
  rowwise() %>%
  mutate(pop_all_years = list(estimate_population(pop_2000, annual_growth, years))) %>%
  unnest(cols = c(pop_all_years)) %>%
  # Add the years vector
  mutate(ano = rep(years, times = n() / length(years)))

# Filter for the period from 2010 to 2022
pop_filtered1 <- pop %>%
  filter(ano %in% c(2010, 2022))

# Transform the data so that each row has populations for 2010 and 2022
pop_wide1 <- pop_filtered1 %>%
  pivot_wider(names_from = ano, values_from = pop, names_prefix = "pop_")

# Calculate the percentage variation
pop_variation1 <- pop_wide1 %>%
  mutate(variation = (pop_2022 - pop_2010))

# Calculate the annual growth
pop_variation1 <- pop_variation1 %>%
  mutate(annual_growth = variation / 12)

# Function to calculate estimated population based on annual growth
estimate_population <- function(pop_2010, annual_growth, years) {
  pop_est <- numeric(length(years))
  pop_est[1] <- pop_2010
  for (i in 2:length(years)) {
    pop_est[i] <- pop_est[i - 1] + annual_growth
  }
  return(pop_est)
}

# Create dataframe for the years 2010 to 2022
years1 <- 2010:2022
pop_complete1 <- pop_variation1 %>%
  rowwise() %>%
  mutate(pop_all_years = list(estimate_population(pop_2010, annual_growth, years1))) %>%
  unnest(cols = c(pop_all_years)) %>%
  # Add the years vector
  mutate(ano = rep(years1, times = n() / length(years1)))

# Display the result
print(pop_complete1)

# Combine dataframes with estimated populations
pop = bind_rows(pop_complete, pop_complete1) # final base
rm(pop_complete, pop_complete1, pop_variation1, pop_variation, pop_wide1, pop_wide, pop_filtered, pop_filtered1)

# Sort data by municipality and year
pop = pop %>% arrange(municipio, ano)
pop$pop_2000 = NULL
pop$pop_2010 = NULL
pop$pop_2022 = NULL

# Function to estimate the population for the next year based on annual growth
estimate_next_year_population <- function(pop_last_year, annual_growth) {
  return(pop_last_year + annual_growth)
}

# Filter dataframe for 2022 data
pop_2022 <- pop %>%
  filter(ano == 2022)

# Calculate population for 2023
pop_2023 <- pop_2022 %>%
  rowwise() %>%
  mutate(pop_2023 = estimate_next_year_population(pop_all_years, annual_growth),
         ano = 2023) %>%
  select(municipio_codigo, municipio, annual_growth, pop_all_years = pop_2023, ano)

# Add new rows for 2023 to the existing dataframe
pop <- bind_rows(pop, pop_2023)
pop = pop %>% arrange(municipio, ano)
# Display the result
print(pop)
pop$annual_growth = NULL
pop$variation = NULL

# Filter data for the period from 2008 to 2023
pop = pop %>% filter(between(ano, 2008, 2023))

# Remove duplicates for the year 2010, keeping the smallest population for each municipality
pop04 <- pop %>%
  # Filter to keep only the year 2010
  filter(ano == 2010) %>%
  # Sort by municipality and population in ascending order
  arrange(municipio_codigo, pop_all_years) %>%
  # Remove duplicates, keeping the first occurrence (smallest value)
  distinct(municipio_codigo, .keep_all = TRUE) %>%
  # Combine again with the rest of the data
  bind_rows(pop %>% filter(ano != 2010))

# View the result
head(pop04)

# Rename the population column to pop_04
pop04 = pop04 %>% rename("pop_04" = "pop_all_years")

# Adjust data types
pop04$ano = as.character(pop04$ano)

# Join data with dataframe df1
df1 <- left_join(df1, pop04, by = c("municipio_codigo", "municipio", "ano"))

# Calculate per capita income
df1 = df1 %>% mutate(pib_per_cp = renda / pop_all_years)
df1 = df1 %>% arrange(municipio, ano)

# Clean up workspace
rm(media_historica, municipios_anos, municipios_faltando_anos, pib, pop, pop_2022, pop_2023, pop_cleaned, pop04)

# Remove the last digit from all observations of the municipio_codigo variable
df1 <- df1 %>%
  mutate(municipio_codigo = substr(municipio_codigo, 1, nchar(municipio_codigo) - 1))

# Set working directory
setwd("C:/Users/MARCOS.ANTUNES/Downloads/Simoni/SI_PNI")

# Read the ans.csv file
ans = read.csv2("ans.csv", fileEncoding = "latin1")

# Transform data to long format
ans <- ans %>%
  pivot_longer(cols = starts_with("X"), names_to = "ano", values_to = "ans_pop") %>%
  mutate(ano = as.integer(sub("X", "", ano)))

# Separate the 'municipio' column into 'code_muni' and 'municipio'
ans <- ans %>%
  separate(municipio, into = c("code_muni", "municipio"), sep = 6)

# Check and, if necessary, convert the 'ano' column to the same type in both datasets
ans$ano <- as.character(ans$ano)
df1$ano <- as.character(df1$ano)

# Perform the join by municipality code and year
df1 <- left_join(ans, df1, by = c("code_muni" = "municipio_codigo", "ano" = "ano"))

# Calculate the adjusted difference
df1$ans_ajust = df1$pop_04 - df1$ans_pop

# Identify municipalities with significant adjustments
municipios_vetor <- df1 %>%
  filter(ans_ajust < 10 | ans_ajust < 0) %>%
  pull(code_muni) %>%
  unique()

# Adjust ans_pop based on established criteria
df1 <- df1 %>%
  mutate(ans_ajust = case_when(
    ans_pop > pop_04 * 0.5 ~ pop_04 * 0.75,   # Adjust for municipalities where ans_pop is greater than 50% of pop_04
    code_muni %in% municipios_vetor ~ pop_04 * 0.75,  # Adjust for municipalities in the vector
    TRUE ~ pop_04 - ans_pop   # Keep the original calculation for others
  ))

# Clean temporary variables
rm(ans, ans_long)

# Rename the 'municipio.x' column to 'municipio'
df1 <- df1 %>%
  rename(municipio = municipio.x)
df1$municipio.y = NULL

# Filter out unwanted records
df1 <- df1 %>%
  filter(!str_detect(municipio, "Município ignorado")) %>%
  filter(!str_detect(municipio, "Ignorado ou exterior")) %>%
  filter(!str_detect(code_muni, "Total"))

# Remove missing values
df1 = df1 %>% drop_na()

# Codes to be removed
codes_to_remove <- c("251455", "251465", "170460", "431454", "500627", "150475", "422000", "421265")

# Read coverage data
aps = readxl::read_excel("cobertura.xlsx")
aps = clean_names(aps)

# Filter municipalities with codes to be removed
aps <- aps %>%
  filter(!co_municipio_ibge %in% codes_to_remove)

# Separate the 'nu_competencia' column into 'ano' and 'mes'
aps <- aps %>%
  separate(nu_competencia, into = c("ano", "mes"), sep = 4) %>%
  select(-mes)  # Remove the 'mes' column

# Rename the municipality code column
aps <- aps %>%
  rename(code_muni = co_municipio_ibge)

# Adjust data types for join
df1 <- df1 %>%
  mutate(ano = as.character(ano), code_muni = as.character(code_muni))

aps <- aps %>%
  mutate(ano = as.character(ano), code_muni = as.character(code_muni))

# Perform the join with the coverage dataframe
df1 <- left_join(df1, aps, by = c("code_muni" = "code_muni", "ano" = "ano"))

