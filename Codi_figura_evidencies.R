library(readxl)
library(dplyr)
library(ggplot2)

theme_scientific <- function(base_size = 13, base_family = "sans") {
  theme_classic(base_size = base_size, base_family = base_family) +
    theme(
      plot.title = element_text(
        face = "bold",
        hjust = 0.5,
        size = 15,
        color = "black",
        margin = margin(b = 12)
      ),
      axis.title = element_text(
        face = "bold",
        size = 13,
        color = "black"
      ),
      axis.text = element_text(
        face = "bold",
        size = 11,
        color = "black"
      ),
      axis.line = element_line(
        color = "black",
        linewidth = 0.45
      ),
      axis.ticks = element_line(
        color = "black",
        linewidth = 0.45
      ),
      axis.ticks.length = unit(0.15, "cm"),
      panel.grid = element_blank(),
      legend.position = "none",
      plot.margin = margin(12, 12, 12, 12)
    )
}

fitxer <- file.choose()
carpeta_sortida <- dirname(fitxer)

df <- read_excel(fitxer, sheet = "Functional_study") %>%
  slice(1:50) %>%      # agafa les 50 primeres files
  mutate(
    rsID = trimws(as.character(rsID)),
    Expressio_diferencial_S7 = trimws(as.character(Expressio_diferencial_S7)),
    Associacions_GWAS_S9 = trimws(as.character(Associacions_GWAS_S9)),
    RegulomeDB_rank = trimws(as.character(RegulomeDB_rank)),
    Literatura_externa = trimws(as.character(Literatura_externa))
  ) %>%
  filter(!is.na(rsID)) %>%
  filter(grepl("^rs[0-9]+$", rsID))

cat("Nombre de SNPs carregats:", nrow(df), "\n")


# INDICADORS D'EVIDÈNCIA

df <- df %>%
  mutate(
    evidencia_expressio = ifelse(Expressio_diferencial_S7 == "Y", 1, 0),
    
    evidencia_gwas = ifelse(Associacions_GWAS_S9 == "Y", 1, 0),
    
    evidencia_s7_s9 = ifelse(
      evidencia_expressio == 1 & evidencia_gwas == 1,
      1,
      0
    ),
    
    regulomedb_rank_num = as.numeric(
      sub("^([0-9]).*", "\\1", RegulomeDB_rank)
    ),
    
    regulomedb_rank_4 = ifelse(
      !is.na(regulomedb_rank_num) & regulomedb_rank_num <= 4,
      1,
      0
    ),
    
    literatura_externa_bin = ifelse(Literatura_externa == "Y", 1, 0)
  )

# Comprovació dels recomptes
cat("Expressió diferencial:", sum(df$evidencia_expressio, na.rm = TRUE), "\n")
cat("GWAS/fenotípica:", sum(df$evidencia_gwas, na.rm = TRUE), "\n")
cat("Expressió + GWAS:", sum(df$evidencia_s7_s9, na.rm = TRUE), "\n")
cat("RegulomeDB rank <= 4:", sum(df$regulomedb_rank_4, na.rm = TRUE), "\n")
cat("Literatura externa:", sum(df$literatura_externa_bin, na.rm = TRUE), "\n")


#TAULA 
total_snps <- nrow(df)

taula_evidencia <- data.frame(
  Font_evidencia = c(
    "Expressió diferencial",
    "RegulomeDB rank ≤ 4",
    "Associació GWAS/fenotípica",
    "Expressió + GWAS",
    "Literatura externa"
  ),
  Nombre_SNPs = c(
    sum(df$evidencia_expressio, na.rm = TRUE),
    sum(df$regulomedb_rank_4, na.rm = TRUE),
    sum(df$evidencia_gwas, na.rm = TRUE),
    sum(df$evidencia_s7_s9, na.rm = TRUE),
    sum(df$literatura_externa_bin, na.rm = TRUE)
  ),
  stringsAsFactors = FALSE
) %>%
  mutate(
    Percentatge = round((Nombre_SNPs / total_snps) * 100, 1),
    Etiqueta = paste0(Nombre_SNPs, " (", Percentatge, "%)"),
    Font_evidencia = factor(
      Font_evidencia,
      levels = Font_evidencia[order(Nombre_SNPs)]
    )
  )

print(taula_evidencia)


fig_evidencia <- ggplot(
  taula_evidencia,
  aes(x = Font_evidencia, y = Nombre_SNPs)
) +
  geom_col(
    width = 0.55,
    fill = "#1F5A92",
    color = "black",
    linewidth = 0.45
  ) +
  geom_text(
    aes(label = Etiqueta),
    hjust = -0.12,
    fontface = "bold",
    size = 4,
    color = "black"
  ) +
  coord_flip() +
  labs(
    title = "Fonts d’evidència funcional integrades",
    x = "Tipus d'evidència",
    y = "Nombre de SNPs"
  ) +
  scale_y_continuous(
    expand = expansion(mult = c(0, 0.18)),
    breaks = scales::pretty_breaks(n = 6)
  ) +
  theme_scientific() +
  theme(
    axis.text.y = element_text(
      face = "bold",
      size = 11,
      color = "black"
    )
  )

print(fig_evidencia)

ggsave(
  filename = file.path(carpeta_sortida, "Figura_evidencia_funcional_integrada.png"),
  plot = fig_evidencia,
  width = 9,
  height = 5.2,
  dpi = 300,
  bg = "white"
)

cat("Figura guardada a:\n")
cat(file.path(carpeta_sortida, "Figura_evidencia_funcional_integrada_oficial.png"), "\n")