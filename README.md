#Contexto
A vulnerabilidade econômica em países em desenvolvimento resulta em sistemas de saúde deficitários, com falhas em vários níveis de assistência, afetando o acesso e a qualidade do atendimento. A Atenção Primária à Saúde (APS) é um modelo de cuidado recomendado pela Organização Mundial da Saúde (OMS) como uma estratégia essencial para alcançar saúde universal e integral. Este estudo visa analisar o impacto da APS na cobertura vacinal da vacina contra pneumonia (VPC10) e nas taxas de hospitalizações por pneumonia em crianças menores de 5 anos nos municípios brasileiros. Avaliar os efeitos da APS em programas de imunização é crucial para entender a proteção infantil e a sustentabilidade em saúde.

##Análise Estatística
A análise estatística foi conduzida utilizando o ambiente R (RStudio versão 4.4.1). Os dados foram descritos com medianas e intervalo interquartil (IQR) ou médias e desvios padrão (DP) para variáveis numéricas, e frequências e proporções para variáveis categóricas. Não foram realizadas imputações para valores ausentes.

A análise foi dividida em três partes principais:

###Análise Descritiva da Pandemia e Cobertura Vacinal:
Avaliamos a progressão diária da carga da pandemia de COVID-19 (internações hospitalares por 100.000 habitantes) e a cobertura vacinal. A cobertura vacinal foi calculada com base no número de indivíduos vacinados, estratificados por município, estado e região.

###Análise da Associação com PIB per Capita:
Estimamos a associação entre o PIB per capita e as taxas de vacinação usando um modelo de regressão multivariado. A taxa de vacinação da primeira dose foi a variável dependente, e o PIB per capita (classificado como baixo) foi a principal variável de interesse. Como covariáveis, incluímos o tamanho da população municipal, a densidade populacional, a taxa de internações por pneumonia entre 2008 e 2022, as cinco macrorregiões brasileiras (Norte, Nordeste, Centro-Oeste, Sudeste e Sul), e a cobertura de APS. Um termo de interação entre o PIB per capita e a cobertura de APS foi incluído no modelo.

###Tratamento e Visualização dos Dados:
Os dados foram ajustados para prevalência usando a fórmula: acometidos/população no local x 100.000. As análises descritivas foram apresentadas por estado e região. Mapas de visualização foram utilizados para avaliar alterações espaço-temporais, e regressões foram aplicadas para analisar mudanças temporais. Pacotes utilizados para a análise e visualização de dados incluíram ggplot2, geobr, tidyverse, janitor e microdatasus.
Adicionalmente, foram realizadas análises de sensibilidade para verificar a robustez das estimativas:

Avaliação da associação entre o PIB per capita e as taxas de cobertura vacinal ajustadas pelos mesmos covariáveis.
Estimativa da associação entre PIB per capita e taxas de cobertura vacinal para doses administradas em menores de 4 anos, para observar o efeito sem o impacto de possíveis grupos prioritários na vacinação.
