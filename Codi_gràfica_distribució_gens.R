library(readxl)
library(dplyr)
library(ggplot2)

fitxer <- file.choose()
df <- readxl::read_excel(fitxer,
                         sheet = "SNP_selected")

head(df)
nrow(df)
colnames(df)

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

summary_gene <- df %>%
  mutate(
    gene_clean = ifelse(is.na(gene),
                        "Sense gen assignat",
                        gene),
    
    gene_group = ifelse(gene_clean %in% c("TLR1", "TLR6", "TLR10"),
                        "Gens TLR",
                        "Altres gens / no assignat")
  ) %>%
  count(gene_clean, gene_group, sort = TRUE)

summary_gene$gene_clean <- factor(summary_gene$gene_clean,
                                  levels = summary_gene$gene_clean)

p_gene <- ggplot(summary_gene,
                 aes(x = gene_clean,
                     y = n,
                     fill = gene_group)) +
  geom_col(width = 0.55) +
  geom_text(
    aes(label = n),
    vjust = -0.35,
    size = 3.2,
    family = "sans",
    fontface = "bold",
    color = "black"
  ) +
  scale_fill_manual(
    values = c(
      "Gens TLR" = "#1F5A92",
      "Altres gens / no assignat" = "#E69F00"
    )
  ) +
  scale_y_continuous(
    expand = expansion(mult = c(0, 0.08)),
    breaks = seq(0, max(summary_gene$n) + 5, 5)
  ) +
  labs(
    x = "Gen associat",
    y = "Nombre de SNPs",
    title = "Distribució dels SNPs seleccionats per gen",
    fill = NULL
  ) +
  theme_scientific() +
  theme(
    axis.text.x = element_text(
      angle = 30,
      hjust = 1,
      size = 11,
      face = "bold",
      color = "black"
    ),
    axis.title.x = element_text(
      margin = margin(t = 10)
    ),
    axis.title.y = element_text(
      margin = margin(r = 10)
    ),
    legend.position = "bottom"
  )

p_gene

ggsave(
  filename = "figura_distribucio_gene_SNPs_TLR_color_scientific.png",
  plot = p_gene,
  width = 7.5,
  height = 5,
  dpi = 300,
  bg = "white"
)

