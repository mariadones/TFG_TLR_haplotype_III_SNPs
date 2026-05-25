# ============================================================
# Figura: Priorització funcional final amb percentatges
# ============================================================

library(readxl)
library(dplyr)
library(ggplot2)

# ============================================================
# 1. Tema gràfic científic
# ============================================================

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
      legend.title = element_text(
        face = "bold",
        size = 11,
        color = "black"
      ),
      legend.text = element_text(
        face = "bold",
        size = 11,
        color = "black"
      ),
      plot.margin = margin(12, 12, 12, 12)
    )
}

# ============================================================
# 2. Carregar dades
# ============================================================

fitxer <- file.choose()
carpeta_sortida <- dirname(fitxer)

df <- read_excel(fitxer, sheet = "Functional_study") %>%
  slice(1:50) %>%   # agafa les 50 primeres files útils
  mutate(
    rsID = trimws(as.character(rsID)),
    Prioritat_final = trimws(as.character(Prioritat_final))
  ) %>%
  filter(!is.na(rsID)) %>%
  filter(grepl("^rs[0-9]+$", rsID))

cat("Nombre de SNPs carregats:", nrow(df), "\n")

if (nrow(df) != 49) {
  stop("ATENCIÓ: no s'han carregat 49 SNPs. Revisa el full Functional_study o el filtre slice(1:50).")
}

# ============================================================
# 3. Neteja de la columna de prioritat
# ============================================================

df <- df %>%
  mutate(
    Prioritat_final = case_when(
      Prioritat_final %in% c("Alta", "alta", "ALTA") ~ "Alta",
      Prioritat_final %in% c("Mitjana", "mitjana", "MITJANA") ~ "Mitjana",
      Prioritat_final %in% c("Baixa", "baixa", "BAIXA") ~ "Baixa",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(Prioritat_final))

# ============================================================
# 4. Taula de priorització amb percentatges
# ============================================================

total_snps <- 49

taula_prioritat <- df %>%
  count(Prioritat_final, name = "Nombre_SNPs") %>%
  mutate(
    Prioritat_final = factor(
      Prioritat_final,
      levels = c("Alta", "Mitjana", "Baixa")
    )
  ) %>%
  arrange(Prioritat_final) %>%
  mutate(
    Percentatge = round((Nombre_SNPs / total_snps) * 100, 1),
    Etiqueta = paste0(Nombre_SNPs, " (", Percentatge, "%)")
  )

print(taula_prioritat)

# ============================================================
# 5. Crear figura
# ============================================================

fig_prioritat <- ggplot(
  taula_prioritat,
  aes(x = Prioritat_final, y = Nombre_SNPs, fill = Prioritat_final)
) +
  geom_col(
    width = 0.5,
    color = "black",
    linewidth = 0.45
  ) +
  geom_text(
    aes(label = Etiqueta),
    vjust = -0.45,
    fontface = "bold",
    size = 4,
    family = "sans",
    color = "black"
  ) +
  scale_fill_manual(
    values = c(
      "Alta" = "#08306B",
      "Mitjana" = "#4292C6",
      "Baixa" = "#DEEBF7"
    )
  ) +
  labs(
    title = "Priorització funcional final dels SNPs diferencials",
    x = "Categoria de prioritat",
    y = "Nombre de SNPs",
    caption = "Nota: la priorització indica el grau de suport funcional acumulat i no implica causalitat directa \nEls percentatges han estat calculats respecte els 49 SNPs seleccionats."
  ) +
  scale_y_continuous(
    expand = expansion(mult = c(0, 0.16)),
    breaks = scales::pretty_breaks(n = 6)
  ) +
  theme_scientific() +
  theme(
    legend.position = "none",
    plot.caption = element_text(
      size = 9,
      face = "italic",
      color = "black",
      hjust = 0,
      margin = margin(t = 10)
    )
  )
print(fig_prioritat)

# ============================================================
# 6. Guardar figura en PNG
# ============================================================

ggsave(
  filename = file.path(carpeta_sortida, "Figura_prioritzacio_final_percentatges.png"),
  plot = fig_prioritat,
  width = 7.5,
  height = 5.6,
  dpi = 300,
  bg = "white"
)

cat("Figura guardada a:\n")
cat(file.path(carpeta_sortida, "Figura_prioritzacio_final_percentatges.png"), "\n")