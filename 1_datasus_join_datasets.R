pacman::p_load(dplyr)

# Define the directory where the files are located
dir_path = "C:/Users/MARCOS.ANTUNES/Downloads/Simoni"

# List all .csv and .Rdata files in the folder
csv_files = list.files(path = dir_path, pattern = "\\.csv$", full.names = TRUE)
rdata_files = list.files(path = dir_path, pattern = "\\.RData$", full.names = TRUE)

# Function to read .csv files
read_csv_file = function(file) {
  data = read.csv(file, stringsAsFactors = FALSE)
  assign(x = tools::file_path_sans_ext(basename(file)), value = data, envir = .GlobalEnv)
}

# Function to load .Rdata files
load_rdata_file = function(file) {
  e = new.env()
  load(file, envir = e)
  obj_name = ls(envir = e)
  for (name in obj_name) {
    assign(name, get(name, envir = e), envir = .GlobalEnv)
  }
}

# Import all .csv files
lapply(csv_files, read_csv_file)

# Load all .Rdata files
lapply(rdata_files, load_rdata_file)

# Check the loaded objects
ls()

# List the names of all dataframes with the prefix 'pnm'
dataframe_names <- ls(pattern = "^pnm")

# Function to get all unique columns
get_all_columns <- function(dataframes) {
  unique(unlist(lapply(dataframes, colnames)))
}

# Get the list of all dataframes
dataframes_list <- mget(dataframe_names)

# Get all unique columns present in any dataframe
all_columns <- get_all_columns(dataframes_list)

# Function to standardize columns of a dataframe
standardize_columns <- function(df, all_columns) {
  missing_columns <- setdiff(all_columns, colnames(df))
  df[missing_columns] <- NA
  return(df[, all_columns])
}

# Standardize the columns of all dataframes
standardized_dataframes <- lapply(dataframes_list, standardize_columns, all_columns)

# Update the dataframes in the global environment
for (i in seq_along(dataframe_names)) {
  assign(dataframe_names[i], standardized_dataframes[[i]], envir = .GlobalEnv)
}

# Check if all dataframes have the same number of columns
sapply(mget(dataframe_names), ncol)

# Function to ensure specific columns are integers
convert_specific_columns_to_integer <- function(df, columns_to_convert) {
  for (column_name in columns_to_convert) {
    if (column_name %in% colnames(df)) {
      df[[column_name]] <- as.integer(as.character(df[[column_name]]))
    }
  }
  return(df)
}

# Names of the columns to be converted
columns_to_convert <- c("UF_ZI", "ANO_CMPT","MES_CMPT","ESPEC","CGC_HOSP","N_AIH","IDENT","CEP",
                        "MUNIC_RES","NASC","SEXO","UTI_MES_IN","UTI_MES_AN","UTI_MES_AL","UTI_MES_TO",
                        "MARCA_UTI","UTI_INT_IN","UTI_INT_AN","UTI_INT_AL","UTI_INT_TO","DIAR_ACOM","QT_DIARIAS",
                        "PROC_SOLIC","PROC_REA","DT_INTER","DT_SAIDA","COBRANCA","NATUREZA","GESTAO", 
                        "RUBRICA","IND_VDRL","MUNIC_MOV","COD_IDADE","IDADE","DIAS_PERM","MORTE","NACIONAL",
                        "CAR_INT","TOT_PT_SP","CPF_AUT","HOMONIMO","NUM_FILHOS","INSTRU","CID_NOTIF","CONTRACEP1",
                        "CONTRACEP2","GESTRISCO","INSC_PN","SEQ_AIH5","CBOR","CNAER","VINCPREV","GESTOR_COD","GESTOR_TP",
                        "GESTOR_CPF","GESTOR_DT","CNES","CNPJ_MANT","INFEHOSP","CID_ASSO","CID_MORTE","COMPLEX","FINANC","FAEC_TP",
                        "REGCT","RACA_COR","ETNIA","SEQUENCIA")

# Convert the specific columns to integer in each dataframe
standardized_dataframes <- lapply(standardized_dataframes, convert_specific_columns_to_integer, columns_to_convert = columns_to_convert)

# Combine all dataframes into a single dataframe
df <- bind_rows(standardized_dataframes)

# Check the resulting dataframe
print(df)
rm(list = setdiff(ls(), "df"))

df <- df %>%
  mutate(IDADE_ANOS = case_when(
    COD_IDADE == 2 ~ IDADE / 365,  # Days to years
    COD_IDADE == 3 ~ IDADE / 12,   # Months to years
    COD_IDADE == 4 ~ IDADE,         # Years
    TRUE ~ NA_real_                 # Other categories
  )) %>%
  filter(IDADE_ANOS <= 4.99)

df <- df %>%
  mutate(IDADE_CATEGORICA = case_when(
    IDADE_ANOS < 1 ~ "até 1 ano",
    IDADE_ANOS == 1 ~ "1 ano",
    IDADE_ANOS == 2 ~ "2 anos",
    IDADE_ANOS == 3 ~ "3 anos",
    IDADE_ANOS == 4 ~ "4 anos",
    TRUE ~ NA_character_  # For values outside the categories
  ))




