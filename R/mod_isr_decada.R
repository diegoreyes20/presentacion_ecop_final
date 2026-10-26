# ------------------------------------------------------------------
# Pestaña 2: ISR en la última década
# ------------------------------------------------------------------
ANIOS_TABLA2 <- ANIOS_ISR[ANIOS_ISR >= 2016]
ANIOS_TABLA3 <- ANIOS_TABLA2   # esta grafica no depende de ENIGH, usa todos los anios disponibles

mod_isr_decada_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h3("ISR en la última década"),

    h4("Comparación de tasas marginales y promedio"),
    fluidRow(
      column(9, radioGroupButtons(ns("anio2"), "Año:", choices = ANIOS_TABLA2,
                                   selected = max(ANIOS_TABLA2), justified = TRUE, status = "light")),
      column(3, checkboxInput(ns("deciles"), "Mostrar distribución por deciles", FALSE))
    ),
    uiOutput(ns("nota_deciles")),
    fluidRow(
      column(3,
             div(style = "min-height:360px;border-radius:8px;padding:14px",
                 tags$p(
                   "El ISR de las personas es progresivo. La tasa promedio (el impuesto entre el ingreso) ",
                   "aumenta conforme crece el ingreso. Esto es causado por los incrementos en la tasa marginal ",
                   "(el pago por cada peso adicional) según el grupo de ingresos. Con esto se logra que las ",
                   "personas con mayores ingresos paguen una proporción mayor de sus ingresos. Al añadir la ",
                   "información sobre los deciles se puede observar que el ingreso de la mayoría de la población ",
                   "es gravado por menos del 30%, siendo solo los últimos dos deciles los que enfrentan gravámenes ",
                   "mayores. Durante los 10 años observados (2016-2026) la estructura de impuesto casi no cambió, ",
                   "pues las tasas y los tramos son los mismos y solo desplazan sus límites. Solo se actualizaron ",
                   "los límites, pero no se actualizaron las tasas."
                 ))),
      column(9, mod_tasas_plot_ui(ns("tasas"), mostrar_toggle_escala = TRUE))
    ),
    tags$p(style = "color:#5f6670;font-size:13px;margin-top:6px",
           ENIGH_CITA_TABLAS2, " ",
           tags$a(href = CONTRIBUYENTE_LINK, target = "_blank", "(El Contribuyente)"), " · ",
           "INEGI. Encuesta Nacional de Ingresos y Gastos de los Hogares. ENIGH 2024. Tabulados básicos. 2025."),

    hr(),
    h4("Salario mínimo frente a límites de tasas marginales"),
    radioGroupButtons(ns("anio3"), "Año:", choices = ANIOS_TABLA3, selected = max(ANIOS_TABLA3), justified = TRUE, status = "light"),
    plotlyOutput(ns("plot3"), height = "440px"),
    tags$p(style = "color:#5f6670;font-size:13px;margin-top:6px",
           SALARIO_MINIMO_CITA, " ", tags$a(href = SALARIO_MINIMO_LINK, target = "_blank", "(Fuente)")),

    hr(),
    h4("Evolución de la proporción del salario mínimo mensual necesaria para cada tramo (2016–2026)"),
    plotlyOutput(ns("plot3b"), height = "420px"),
    tags$p(style = "color:#5f6670;font-size:13px;margin-top:6px",
           SALARIO_MINIMO_CITA, " ", tags$a(href = SALARIO_MINIMO_LINK, target = "_blank", "(Fuente)")),

    tags$p(style = "margin-top:6px",
           "Los límites de los tramos del ISR crecieron menos que el salario mínimo, por lo que ahora se ",
           "requieren menos salarios mínimos para alcanzar cada tramo. El tramo más alto, que en 2016 ",
           "requería de 114.1 salarios mínimos mensuales, pasó a 45 salarios mínimos mensuales en 2026, ",
           "reduciéndose en más del 50%. La proporción baja de forma similar en todos los tramos. La caída ",
           "se vuelve más notoria a partir de 2018, cuando el salario mínimo comenzó a aumentar notoriamente ",
           "año tras año.")
  )
}

mod_isr_decada_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    anio2 <- reactive(as.numeric(input$anio2))
    mod_tasas_plot_server("tasas", anio2, reactive(input$deciles), xlim_max = 2e6)

    output$nota_deciles <- renderUI({
      if (isTRUE(input$deciles) && !(anio2() %in% ANIOS_DECILES)) {
        tags$p(style = "color:#9a3412;font-size:13px",
               "No hay datos de la distribución del ingreso (ENIGH) para ", anio2(),
               ". Años disponibles: ", paste(ANIOS_DECILES, collapse = ", "), ".")
      }
    })

    output$plot3 <- renderPlotly({
      a <- as.numeric(input$anio3)
      t <- isr[isr$anio == a, ] |>
        mutate(tramo = factor(round(li), levels = round(li)),
               etiqueta = paste0(round(li / salario_minimo_mensual, 1), " SM mensuales"))

      d <- t |>
        select(tramo, etiqueta, li, salario_minimo_mensual) |>
        pivot_longer(c(li, salario_minimo_mensual), names_to = "serie", values_to = "valor") |>
        mutate(serie = recode(serie, li = "Límite inferior del tramo", salario_minimo_mensual = "Salario mínimo mensual"))

      y_min <- sort(unique(t$li))[2]

      p <- ggplot(d, aes(x = tramo, y = valor, fill = serie,
                          text = paste0(serie, ": $", format(round(valor), big.mark = ","),
                                        if_else(serie == "Límite inferior del tramo", paste0("<br>", etiqueta, " para alcanzarlo"), "")))) +
        geom_col(position = position_dodge(width = 0.8), width = 0.75) +
        scale_fill_manual(values = c("Límite inferior del tramo" = "#18314f", "Salario mínimo mensual" = "#8bbeb2")) +
        scale_y_continuous(labels = label_dollar(big.mark = ",")) +
        coord_cartesian(ylim = c(y_min, NA)) +
        labs(x = "Límite inferior del tramo ($/mes)", y = "Pesos", fill = NULL) +
        theme_minimal(base_size = 13) +
        theme(legend.position = "bottom", axis.text.x = element_text(angle = 40, hjust = 1))

      ggplotly(p, tooltip = "text") |> layout(legend = list(orientation = "h", y = -0.35))
    })

    output$plot3b <- renderPlotly({
      d <- isr |>
        filter(anio >= 2016) |>
        group_by(anio) |>
        arrange(li) |>
        mutate(tramo_idx = row_number(),
               prop_sm_mensual = li / salario_minimo_mensual) |>
        ungroup() |>
        filter(tramo_idx > 1)   # se ignora la primera banda (la que inicia en 0)

      niveles_tramo <- sort(unique(d$tramo_idx))
      paleta_azul_marino <- colorRampPalette(c("#a9c6d8", "#0a1f33"))(length(niveles_tramo))
      etiquetas_tramo <- paste0("Tramo ", niveles_tramo)

      d <- d |> mutate(tramo_lbl = factor(paste0("Tramo ", tramo_idx), levels = etiquetas_tramo))

      p <- ggplot(d, aes(x = anio, y = prop_sm_mensual, color = tramo_lbl, group = tramo_lbl,
                          text = paste0(tramo_lbl, " (", anio, "): ", round(prop_sm_mensual, 1), " SM mensuales"))) +
        geom_line(linewidth = 1) +
        geom_point(size = 1.4) +
        scale_color_manual(values = setNames(paleta_azul_marino, etiquetas_tramo)) +
        scale_x_continuous(breaks = ANIOS_TABLA2) +
        labs(x = NULL, y = "Veces el salario mínimo mensual", color = NULL) +
        theme_minimal(base_size = 13) +
        theme(legend.position = "bottom", axis.text.x = element_text(angle = 40, hjust = 1))

      ggplotly(p, tooltip = "text") |> layout(legend = list(orientation = "h", y = -0.4))
    })
  })
}
