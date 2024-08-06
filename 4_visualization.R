########################VISUALIZATION##################################

# Create a summary table for demographic data
demo = df %>% tbl_summary(include = c(idade_categorica, sexo, regions, uti, morte),
                          label = list(idade_categorica~"Faixa etária",
                                       sexo~"Gênero",
                                       regions~"Região",
                                       morte~"Óbito"),
                          sort = list(idade_categorica~"frequency",
                                      sexo~"frequency",
                                      regions~"frequency",
                                      uti~"frequency",
                                      morte~"frequency"),
                          value = list(sexo~"Masculino",
                                       uti~"Sim",
                                       morte~"1")) %>% bold_labels() %>% 
  as_flex_table()

# Save the summary table as a Word document
flextable::save_as_docx(demo, path="tabela_demo.docx")

# Filter the dataset for years between 2008 and 2022
df_p1 = df_p %>% filter(between(ano, 2008, 2022))

# Plot hospitalizations and vaccination coverage rates over time
ggplot(df_p1, aes(x = ano)) +
  geom_bar(aes(y = prev, fill = "Hospitalização por 100,000 hab."), stat = "identity", position = "dodge", width = 0.8) +
  geom_smooth(
    data = df_p1[df_p1$ano > 2008, ],  # Filter data to remove the green line in the first two years
    aes(y = tx_cobertura * max_prev / max_tx_cobertura, color = "Taxa de Cobertura Vacinal"), 
    se = FALSE, size = 1, method = "loess", 
    linetype = "solid"
  ) +
  geom_smooth(
    aes(y = pc_cobertura_ab_r * max_prev / max_tx_cobertura, color = "Taxa de Cobertura Atenção Básica"), 
    se = FALSE, size = 1, linetype = "dashed", method = "loess"
  ) +
  geom_vline(xintercept = 2010, color = "red", linetype = "dashed", size = 1) +  # Red vertical line indicating the start of vaccination
  annotate("text", x = 2011, y = 40000, label = "Início da vacinação (VPC-10)", color = "red", angle = 360, vjust = 1.5) +  # Annotation for the vaccination start
  scale_y_continuous(
    name = "Hospitalização por 100,000 hab.",
    sec.axis = sec_axis(~ . * max_tx_cobertura / max_prev,  # Adjust inverse transformation for secondary y-axis
                        name = "Taxa de Cobertura - (%)", 
                        breaks = seq(0, 150, by = 25))
  ) +
  scale_x_continuous(
    breaks = seq(2008, 2022, by = 1), 
    labels = as.character(seq(2008, 2022, by = 1)),
    expand = c(0.05, 0)
  ) +
  scale_fill_manual(values = c("Hospitalização por 100,000 hab." = "skyblue")) +
  scale_color_manual(values = c("Taxa de Cobertura Vacinal" = "darkgreen", "Taxa de Cobertura Atenção Básica" = "orange")) +
  labs(x = "Período", fill = "", color = "") +
  theme_classic() +
  theme(
    axis.title.y.left = element_text(color = "black"),
    axis.title.y.right = element_text(color = "black"),
    axis.title.x = element_text(margin = margin(t = 10)),  # Adjust margin for the x-axis title
    axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, margin = margin(t = 10)),  # Adjust margin for x-axis labels
    legend.position = "bottom"
  )


# Plot vaccination coverage rates adjusted by income stratum
df1 %>% drop_na() %>% filter(!is.na(estrato) & tx_cobertura > 20 & tx_cobertura < 120) %>% 
  mutate(estrato = factor(estrato, levels = c("Baixo", "Médio", "Alto"))) %>% 
  ggplot()+
  geom_violin(aes(x = estrato, y = tx_cobertura), 
              draw_quantiles = 0.5, fill = NA) +
  labs(
    x = "",
    y = "Taxa de cobertura vacinal \najustada por estrato de PIB per capta"
  ) +
  theme_classic()

# Parameters for the scatter plot
plot_params <- 
  list(shape = 21, 
       alpha = 0.6,
       cex = 0.3,                    # "distance" of the points
       priority = "none",    # you can play with the sorting as well
       groupOnX = FALSE,
       dodge.width = 0.8,
       
       line_width = 0.8
  )

# Calculate median vaccination coverage values by income stratum and region
df_median_vals <- 
  df1 %>% 
  filter(!is.na(estrato) & tx_cobertura > 20 & tx_cobertura < 120) %>%
  mutate(
    no_regiao = factor(no_regiao, 
                       levels = c("NORTE", "NORDESTE", 
                                  "CENTRO-OESTE",
                                  "SUDESTE", "SUL"))
  ) %>% 
  group_by(estrato, no_regiao) %>% 
  summarise(
    dose_median = median(tx_cobertura, na.rm = TRUE)
  ) 

# Plot vaccination coverage by income stratum and region with beeswarm plot and boxplots
df1 %>% 
  filter(!is.na(estrato) & tx_cobertura > 20 & tx_cobertura < 120) %>%
  mutate(estrato = factor(estrato, levels = c("Baixo", "Médio", "Alto"))) %>%   
  mutate(
    region = factor(no_regiao, 
                    levels = c("NORTE", "NORDESTE", 
                               "CENTRO-OESTE",
                               "SUDESTE", "SUL"))
  ) %>% 
  ggplot() +
  ggbeeswarm::geom_beeswarm(
    aes(y = estrato, x = tx_cobertura, 
        fill = no_regiao, size = ans_ajust),
    shape = plot_params[[1]], 
    alpha = plot_params[[2]],
    cex = plot_params[[3]],                    # "distance" of the points
    priority = plot_params[[4]],    # you can play with the sorting as well
    groupOnX = plot_params[[5]],
    dodge.width = plot_params[[6]]
  ) +
  scale_fill_discrete(name = "") +
  scale_size(range = c(1, 12), guide = "none") +
  geom_boxplot(data = df_median_vals,
               aes(y = estrato, x = dose_median), size = plot_params[[7]], width = 0.8) +
  labs(
    y = "",
    x = "Cobertura vacinal (%) por estrato de PIB per capta"
  ) +
  theme_classic() +
  theme(legend.position = "top")

# Plot primary care coverage on a map for the year 2022
p1 = df1 %>% filter(ano == 2022) %>% 
  ggplot() +
  geom_sf(aes(fill = pc_cobertura_ab, geometry = geom.x), 
          color = "#FEBF57", show.legend = TRUE, linewidth = 0.01) +
  labs(title = "Cobertura - Atenção primária", size = 8) +
  scale_fill_distiller(palette = "BrBG",
                       name = "Cobertura - %", 
                       limits = c(min(df1$pc_cobertura_ab),
                                  max(df1$pc_cobertura_ab)))+
  theme_void() + 
  theme(plot.title = element_text(hjust = 0.5))

# Save the map plot as a PNG file
agg_png("out.png", 6000, 4000, scaling = 12)
p1
dev.off()
