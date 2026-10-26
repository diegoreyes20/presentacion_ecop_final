# ------------------------------------------------------------------
# Pestaña: Referencias (orden alfabético, estilo Chicago)
# ------------------------------------------------------------------
referencias_ui <- function() {
  tagList(
    h3("Referencias"),
    tags$ol(
      style = "list-style-type:none;padding-left:0",
      tags$li(style = "margin-bottom:14px",
              "El Contribuyente. \"Tablas de ISR.\" Consultado en 2026. ",
              tags$a(href = "https://www.elcontribuyente.mx/tablas-isr/", target = "_blank",
                     "https://www.elcontribuyente.mx/tablas-isr/.")),
      tags$li(style = "margin-bottom:14px",
              "Gobierno de México, Comisión Nacional de los Salarios Mínimos (CONASAMI). \"Evolución del Salario Mínimo.\" Consultado en 2026. ",
              tags$a(href = "https://www.gob.mx/conasami/documentos/evolucion-del-salario-minimo", target = "_blank",
                     "https://www.gob.mx/conasami/documentos/evolucion-del-salario-minimo.")),
      tags$li(style = "margin-bottom:14px",
              "Instituto Nacional de Estadística y Geografía (INEGI). ",
              "Encuesta Nacional de Ingresos y Gastos de los Hogares. ENIGH 2024. Tabulados básicos. ",
              "Aguascalientes: INEGI, 2025."),
      tags$li(style = "margin-bottom:14px",
              "OECD. Revenue Statistics in Latin America and the Caribbean 2026. Paris: OECD Publishing, 2026. ",
              tags$a(href = "https://www.oecd.org/content/dam/oecd/en/publications/reports/2026/05/revenue-statistics-in-latin-america-and-the-caribbean-2026_436209c8/2f21f131-en.pdf",
                     target = "_blank",
                     "https://www.oecd.org/content/dam/oecd/en/publications/reports/2026/05/revenue-statistics-in-latin-america-and-the-caribbean-2026_436209c8/2f21f131-en.pdf.")),
      tags$li(style = "margin-bottom:14px",
              "PricewaterhouseCoopers International Limited. 2026. \"Personal Income Tax (PIT) Rates.\" ",
              tags$a(href = "https://taxsummaries.pwc.com", target = "_blank", "https://taxsummaries.pwc.com.")),
      tags$li(style = "margin-bottom:14px",
              "Ramírez Cedillo, E. 2020. \"Estudio de la Progresividad del Impuesto Sobre la Renta de Personas ",
              "Físicas en México.\" Contaduría y Administración 66 (2): e256. ",
              tags$a(href = "https://doi.org/10.22201/fca.24488410e.2021.2654", target = "_blank",
                     "https://doi.org/10.22201/fca.24488410e.2021.2654.")),
      tags$li(style = "margin-bottom:14px",
              "SAT (Servicio de Administración Tributaria). 2021. Informe Tributario y de Gestión. ",
              "Al cuarto trimestre de 2020."),
      tags$li(style = "margin-bottom:14px",
              "SAT (Servicio de Administración Tributaria). 2022. Informe Tributario y de Gestión. ",
              "Al cuarto trimestre de 2021."),
      tags$li(style = "margin-bottom:14px",
              "SAT (Servicio de Administración Tributaria). 2023. Informe Tributario y de Gestión. ",
              "Al cuarto trimestre de 2022."),
      tags$li(style = "margin-bottom:14px",
              "SAT (Servicio de Administración Tributaria). 2024. Informe Tributario y de Gestión. ",
              "Al cuarto trimestre de 2023."),
      tags$li(style = "margin-bottom:14px",
              "SAT (Servicio de Administración Tributaria). 2025. Informe Tributario y de Gestión. ",
              "Al cuarto trimestre de 2024.")
    )
  )
}
