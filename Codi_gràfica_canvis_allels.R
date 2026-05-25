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

summary_change <- df %>%
  mutate(
    Allelic_difference_REF_HIII = ifelse(
      is.na(Allelic_difference_REF_HIII),
      "No disponible",
      Allelic_difference_REF_HIII
    )
  ) %>%
  count(Allelic_difference_REF_HIII, sort = TRUE) %>%
  mutate(
    percent = round(n / sum(n) * 100, 1),
    label = paste0(n, " SNPs")
  )

p_change_donut <- ggplot(summary_change,
                         aes(x = 2,
                             y = n,
                             fill = Allelic_difference_REF_HIII)) +
  geom_col(width = 0.9, color = "white", linewidth = 0.6) +
  coord_polar(theta = "y", clip = "off") +
  xlim(0.5, 2.5) +
  geom_text(aes(label = label),
            position = position_stack(vjust = 0.5),
            size = 3.4,
            family = "sans",
            fontface = "bold",
            color = "black") +
  scale_fill_manual(values = c(
    "#1F5A92",
    "#E69F00",
    "#56B4E9",
    "#009E73",
    "#F0E442",
    "#0072B2",
    "#D55E00",
    "#CC79A7",
    "#999999",
    "#8DA0CB"
  )) +
  labs(
    title = "Canvis al·lèlics REF/HIII",
    fill = NULL
  ) +
  theme_void(base_family = "sans") +
  theme(
    plot.title = element_text(
      face = "bold",
      hjust = 0.5,
      size = 15,
      color = "black",
      margin = margin(b = 8)
    ),
    legend.position = "right",
    legend.direction = "vertical",
    legend.box = "vertical",
    legend.text = element_text(
      face = "bold",
      size = 11,
      color = "black"
    ),
    legend.key.size = unit(0.55, "cm"),
    plot.margin = margin(8, 8, 8, 8)
  ) +
  guides(fill = guide_legend(
    ncol = 1,
    title.position = "top"
  ))

p_change_donut

ggsave(
  filename = "figura_canvis_allelics.png",
  plot = p_change_donut,
  width = 8,
  height = 5.5,
  dpi = 300,
  bg = "white"
)