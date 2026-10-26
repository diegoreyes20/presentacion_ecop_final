# ------------------------------------------------------------------
# Pestaña 1: La Recaudación Mexicana (composición del total tax revenue)
# ------------------------------------------------------------------
mod_composicion_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h3("La Recaudación Mexicana"),
    fluidRow(
      column(5, selectInput(ns("vista"), "Qué quieres ver:",
                             choices = c("Impuestos como % del PIB" = "pib",
                                         "Composición de la recaudación" = "comp"),
                             selected = "pib")),
      column(7, sliderTextInput(ns("anios"), "Años a mostrar:",
                                 choices = ANIOS_TAXREV, selected = range(ANIOS_TAXREV), grid = TRUE))
    ),
    checkboxGroupInput(ns("rubros"), "Rubros a mostrar:",
                        choices = setNames(RUBROS$rubro_en, RUBROS$rubro_es),
                        selected = RUBROS$rubro_en, inline = TRUE),
    fluidRow(
      column(8, plotlyOutput(ns("plot"), height = "460px")),
      column(4, uiOutput(ns("definiciones")))
    ),
    tags$p(style = "color:#5f6670;font-size:13px;margin-top:10px",
           OCDE_CITA, " ", tags$a(href = OCDE_LINK, target = "_blank", "(Fuente)")),

    tags$p(style = "margin-top:10px",
           "La recaudación tributaria de México pasó de 11.5% del PIB en 1990 a 18.3% en 2024. ",
           "La mayor parte de este avance se dio después de 2010. El principal impulso de este crecimiento ",
           "fue un aumento en el impuesto sobre la renta y las utilidades que duplicó su recaudación como ",
           "porcentaje del PIB, pasando de 3.9% a 7.9%. Como consecuencia, la composición de la recaudación ",
           "mexicana cambió. El ISR pasó a ser el tipo de impuesto con mayores aportaciones a la recaudación ",
           "(43%), superando al impuesto sobre bienes y servicios durante la década de 2000 y consolidándose ",
           "como la mayor fuente de recaudación durante la década posterior. No es que los otros impuestos se ",
           "hayan reducido, es que no crecieron tanto como el ISR. Aun así, se puede observar que en el último ",
           "año observado el ISR se mantuvo en 7.9% del PIB mientras que la recaudación de impuestos sobre ",
           "bienes y servicios aumentó en 0.4 puntos porcentuales del PIB — un crecimiento mayor, en un solo ",
           "año, que el cambio acumulado entre 2000 y 2010 — por lo que será importante observar futuros ",
           "cambios en la composición.")
  )
}

mod_composicion_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    d <- reactive({
      req(input$rubros, input$anios)
      tax_rev |>
        filter(metric == input$vista,
               rubro_en %in% input$rubros,
               anio >= input$anios[1], anio <= input$anios[2]) |>
        mutate(rubro_es = factor(rubro_es, levels = RUBROS$rubro_es))
    })

    output$plot <- renderPlotly({
      dd <- d()
      validate(need(nrow(dd) > 0, "Selecciona al menos un rubro y un rango de años."))
      colores <- setNames(RUBROS$color, RUBROS$rubro_es)

      if (input$vista == "comp") {
        # barras apiladas por año con los sub-rubros (el Total se muestra como
        # linea de referencia en 100%, ya que es la suma de los demas).
        dd_stack <- dd |> filter(rubro_en != "Total tax revenue")
        validate(need(nrow(dd_stack) > 0, "Selecciona al menos un rubro (ademas del total) y un rango de años."))
        mostrar_total <- "Total tax revenue" %in% input$rubros

        p <- ggplot(dd_stack, aes(x = factor(anio), y = valor, fill = rubro_es,
                                   text = paste0(rubro_es, " (", anio, "): ", round(valor, 1), "%"))) +
          geom_col(position = "stack", width = 0.6) +
          geom_text(aes(label = paste0(round(valor, 1), "%")),
                     position = position_stack(vjust = 0.5), size = 2.8, color = "white")
        if (mostrar_total) {
          p <- p + geom_hline(yintercept = 100, linetype = "dashed", color = "#9aa0a6") +
            annotate("text", x = 1, y = 104, label = "Total = 100%", color = "#5f6670", size = 3, hjust = 0)
        }
        p <- p + labs(x = NULL, y = "% del total recaudado", fill = NULL)
      } else {
        p <- ggplot(dd, aes(x = factor(anio), y = valor, fill = rubro_es,
                             text = paste0(rubro_es, " (", anio, "): ", round(valor, 1), "%"))) +
          geom_col(position = position_dodge(width = 0.8), width = 0.75) +
          geom_text(aes(label = paste0(round(valor, 1), "%")),
                     position = position_dodge(width = 0.8), vjust = -0.4, size = 2.8) +
          labs(x = NULL, y = "% del PIB", fill = NULL)
      }

      p <- p + scale_fill_manual(values = colores) +
        theme_minimal(base_size = 13) +
        theme(legend.position = "bottom")

      ggplotly(p, tooltip = "text") |> layout(legend = list(orientation = "h", y = -0.25))
    })

    output$definiciones <- renderUI({
      req(input$rubros)
      defs <- DEFINICIONES |>
        filter(rubro_en %in% input$rubros) |>
        inner_join(RUBROS, by = "rubro_en")
      tagList(
        h5("Definiciones"),
        tags$ul(lapply(seq_len(nrow(defs)), function(i) {
          tags$li(tags$b(defs$rubro_es[i]), ": ", defs$definicion[i])
        }))
      )
    })
  })
}
