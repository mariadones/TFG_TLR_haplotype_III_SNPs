# TFG: Caracterització funcional dels SNPs diferencials del core haplotype III en el clúster TLR6–TLR1–TLR10

## Descripció

Aquest repositori conté els scripts i el dataset utilitzats en el Treball de Fi de Grau (TFG) titulat **"Caracterització funcional dels SNPs diferencials del core haplotype III en el clúster TLR6–TLR1–TLR10"**.

El treball es basa en les dades suplementàries de Dannemann et al. (2016) i té com a objectiu identificar i prioritzar funcionalment les variants que diferencien el core haplotype III de la referència humana, integrant evidència d'expressió diferencial, associacions fenotípiques, anotació reguladora i literatura específica.

---

## Estructura del repositori

```
├── Codi_taula_dades.ipynb             # Script Python: construcció del dataset base
├── Seleccio_SNPs_estudi.ipynb         # Script Python: selecció dels 49 SNPs diferencials REF/HIII
├── Grafiques_resultats_oficial.R      # Script R: generació de les figures principals
├── codi_grafiques.R                   # Script R: figures addicionals
├── Dades_base_oficial_OFICIAL.xlsx    # Dataset base complet amb totes les anotacions
└── README.md                          # Aquest arxiu
```

---

## Dades d'origen

Les dades utilitzades provenen de les taules suplementàries de:

> Dannemann, M., Andrés, A. M., & Kelso, J. (2016). Introgression of Neandertal- and Denisovan-like haplotypes contributes to adaptive variation in human Toll-like receptors. *The American Journal of Human Genetics*, *98*(1), 22–33. https://doi.org/10.1016/j.ajhg.2015.11.015

Concretament:
- **Taula S5 (mmc4)**: posicions hg19 i al·lels dels haplotips V, III, IV i VII
- **Taula S2 (mmc3)**: al·lels neandertal i denisovà per a cada variant
- **Taula S7**: variants associades a expressió diferencial de TLR1, TLR6 i TLR10
- **Taula S9**: variants associades a fenotips en estudis GWAS

---

## Entorn i versions

### Python
- Python v3.13.12
- Jupyter Notebook
- `pandas` (The pandas development team, 2024)
- `requests` (consultes a l'API REST d'Ensembl GRCh37)

### R
- R v4.5.2 (R Core Team, 2025)
- RStudio
- `ggplot2` v4.0.3
- `dplyr` v1.2.1
- `readxl` v1.5.0
- `flextable` v0.9.11
- `officer` v0.7.5
  
---

## Bases de dades externes consultades

- **Ensembl GRCh37** (API REST): obtenció de rsID, al·lel de referència, posició hg38 i anotació funcional via VEP
- **dbSNP** (NCBI): revisió manual de rsID
- **RegulomeDB v2**: anotació reguladora de variants no codificants
- **NHGRI-EBI GWAS Catalog**: cerca complementària d'associacions fenotípiques

---

## Nota

Els scripts han estat desenvolupats amb finalitat acadèmica en el marc d'un TFG de Grau en Genètica (Universitat Autònoma de Barcelona, curs 2024–2025). El dataset conté informació derivada de fonts públiques i no inclou dades de participants individuals.

