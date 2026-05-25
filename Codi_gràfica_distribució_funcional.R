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

summary_region <- df %>%
  mutate(
    functional_region = ifelse(is.na(functional_region),
                               "not_annotated",
                               functional_region),
    functional_region_clean = case_when(
      functional_region == "intron_variant" ~ "Intrònica",
      functional_region == "upstream_gene_variant" ~ "Upstream",
      functional_region == "downstream_gene_variant" ~ "Downstream",
      functional_region == "intergenic_or_not_annotated" ~ "Intergènica / no anotada",
      functional_region == "5_prime_UTR_variant" ~ "5' UTR",
      functional_region == "3_prime_UTR_variant" ~ "3' UTR",
      functional_region == "splice_polypyrimidine_tract_variant;intron_variant" ~ "Splicing / intrònica",
      TRUE ~ functional_region
    )
  ) %>%
  count(functional_region_clean, sort = TRUE)

p_region <- ggplot(summary_region,
                   aes(x = reorder(functional_region_clean, n),
                       y = n)) +
  geom_col(fill = "#1F5A92", width = 0.55) +
  geom_text(aes(label = n),
            hjust = -0.35,
            size = 3.2,
            family = "sans",
            fontface = "bold",
            color = "black") +
  geom_vline(xintercept = 0.5,
             linetype = "solid",
             color = "black",
             linewidth = 0.45) +
  coord_flip(clip = "off") +
  scale_y_continuous(
    limits = c(0, 30),
    breaks = c(0, 5, 10, 15, 20, 25, 30),
    expand = expansion(mult = c(0, 0))
  ) +
  labs(
    x = NULL,
    y = "Nombre de SNPs",
    title = "Distribució funcional dels SNPs seleccionats"
  ) +
  theme_scientific() +
  theme(
    axis.text.y = element_text(
      size = 12,
      face = "bold",
      color = "black"
    ),
    axis.title.x = element_text(
      margin = margin(t = 8)
    )
  )

p_region

ggsave(
  filename = "figura_distribucio_funcional_SNPs_scientific.png",
  plot = p_region,
  width = 8.5,
  height = 5,
  dpi = 300,
  bg = "white"
)
