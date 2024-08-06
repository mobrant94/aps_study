#### ABRINDO PACOTES NECESSÁRIOS ####

pacman::p_load(microdatasus, remotes, tidyverse)

### setar diretório de trabalho para salvar os arquivos

##### COLETA DE DADOS PELO MICRODATASUS ####

## 2008
pnm8 = fetch_datasus(information_system = "SIH-RD",
                     year_start = 2008, year_end = 2008,
                     month_start = 1, month_end = 12)

gc()

pnm8 = pnm8 %>%
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

gc()

save(pnm8, file = "pnm8.RData")

## 2009 (falta mês nove, incluido diretamente pelo tabwin, arquivo enviado em CSV)

gc()

pnm9_1 = fetch_datasus(information_system = "SIH-RD",
                       year_start = 2009, year_end = 2009,
                       month_start = 1, month_end = 8)

gc()

pnm9_1 = pnm9_1 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm9_1, file = "pnm0901.RData")

gc()

pnm9_2 = fetch_datasus(information_system = "SIH-RD",
                       year_start = 2009, year_end = 2009,
                       month_start = 10, month_end = 12)

gc()

pnm9_2 = pnm9_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm9_2, file = "pnm0902.RData")

## 2010

gc()

pnm10_1 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2010, year_end = 2010,
                        month_start = 1, month_end = 6)

gc()

pnm10_1 = pnm10_1 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm10_1, file = "pnm1001.RData")

gc()

pnm10_2 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2010, year_end = 2010,
                        month_start = 7, month_end = 12)

gc()

pnm10_2 = pnm10_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm10_2, file = "pnm1002.RData")

## 2011

gc()

pnm11_1 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2011, year_end = 2011,
                        month_start = 1, month_end = 6)

gc()

pnm11_1 = pnm11_1 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm11_1, file = "pnm1101.RData")

gc()

pnm11_2 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2011, year_end = 2011,
                        month_start = 7, month_end = 12)

gc()

pnm11_2 = pnm11_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm11_2, file = "pnm1102.RData")

## 2012

pnm12_1 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2012, year_end = 2012,
                        month_start = 1, month_end = 6)

gc()

pnm12_1 = pnm12_1 %>%
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm12_1, file = "pnm1201.RData")

gc()

pnm12_2 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2012, year_end = 2012,
                        month_start = 7, month_end = 12)

gc()

pnm12_2 = pnm12_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm12_2, file = "pnm1202.RData")


## 2013

pnm13_1 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2013, year_end = 2013,
                        month_start = 1, month_end = 6)

gc()

pnm13_1 = pnm13_1 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm13_1, file = "pnm1301.RData")

gc()

pnm13_2 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2013, year_end = 2013,
                        month_start = 7, month_end = 12)

gc()

pnm13_2 = pnm13_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm13_2, file = "pnm1302.RData")

## 2014

pnm14_1 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2014, year_end = 2014,
                        month_start = 1, month_end = 6)

gc()

pnm14_1 = pnm14_1 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm14_1, file = "pnm1401.RData")

gc()

pnm14_2 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2014, year_end = 2014,
                        month_start = 7, month_end = 12)

gc()

pnm14_2 = pnm14_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm14_2, file = "pnm1402.RData")

## 2015

pnm15_1 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2015, year_end = 2015,
                        month_start = 1, month_end = 6)

gc()

pnm15_1 = pnm15_1 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm15_1, file = "pnm1501.RData")

gc()

pnm15_2 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2015, year_end = 2015,
                        month_start = 7, month_end = 12)

gc()

pnm15_2 = pnm15_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm15_2, file = "pnm1502.RData")

## 2016

pnm16_1 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2016, year_end = 2016,
                        month_start = 1, month_end = 6)

gc()

pnm16_1 = pnm16_1 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm16_1, file = "pnm1601.RData")

gc()

pnm16_2 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2016, year_end = 2016,
                        month_start = 7, month_end = 12)

gc()

pnm16_2 = pnm16_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm16_2, file = "pnm1602.RData")

## 2017

pnm17_1 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2017, year_end = 2017,
                        month_start = 1, month_end = 6)

gc()

pnm17_1 = pnm17_1 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm17_1, file = "pnm1701.RData")

gc()

pnm17_2 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2017, year_end = 2017,
                        month_start = 7, month_end = 12)

gc()

pnm17_2 = pnm17_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm17_2, file = "pnm1702.RData")

## 2018

pnm18_1 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2018, year_end = 2018,
                        month_start = 1, month_end = 6)

gc()

pnm18_1 = pnm18_1 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm18_1, file = "pnm1801.RData")

gc()

pnm18_2 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2018, year_end = 2018,
                        month_start = 7, month_end = 12)

gc()

pnm18_2 = pnm18_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm18_2, file = "pnm1802.RData")

## 2019

pnm19_1 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2019, year_end = 2019,
                        month_start = 1, month_end = 6)

gc()

pnm19_1 = pnm19_1 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm19_1, file = "pnm1901.RData")

gc()

pnm19_2 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2019, year_end = 2019,
                        month_start = 7, month_end = 12)

gc()

pnm19_2 = pnm19_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm19_2, file = "pnm1902.RData")

## 2020

pnm20_1 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2020, year_end = 2020,
                        month_start = 1, month_end = 6)

gc()

pnm20_1 = pnm20_1 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm20_1, file = "pnm2001.RData")

gc()

pnm20_2 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2020, year_end = 2020,
                        month_start = 7, month_end = 12)

gc()

pnm20_2 = pnm20_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm20_2, file = "pnm2002.RData")

## 2021

pnm21_1 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2021, year_end = 2021,
                        month_start = 1, month_end = 6)

gc()

pnm21_1 = pnm21_1 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm21_1, file = "pnm2101.RData")

gc()

pnm21_2 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2021, year_end = 2021,
                        month_start = 7, month_end = 12)

gc()

pnm21_2 = pnm21_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm21_2, file = "pnm2102.RData")

## 2022

pnm22_1 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2022, year_end = 2022,
                        month_start = 1, month_end = 6)

gc()

pnm22_1 = pnm22_1 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm22_1, file = "pnm2201.RData")

gc()

pnm22_2 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2022, year_end = 2022,
                        month_start = 7, month_end = 12)

gc()

pnm22_2 = pnm22_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm22_2, file = "pnm2202.RData")

## 2023

pnm23_1 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2023, year_end = 2023,
                        month_start = 1, month_end = 6)

gc()

pnm23_1 = pnm23_1 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm23_1, file = "pnm2301.RData")

gc()

pnm23_2 = fetch_datasus(information_system = "SIH-RD",
                        year_start = 2023, year_end = 2023,
                        month_start = 7, month_end = 12)

gc()

pnm23_2 = pnm23_2 %>% 
  filter(str_detect(DIAG_PRINC, "^J1[2-8]"))

save(pnm23_2, file = "pnm2302.RData")

gc()

### IMPORTANDO O BANCO DE DADOS DO MES NOVE DE 2009

pnm0909 = read.csv("pnm0909.csv", sep = ",")


#### COLUNAS DIFERENTES EM CADA ANO #####



#### UNINDO TODOS OS BANCOS DE DADOS #####






