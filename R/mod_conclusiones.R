# ------------------------------------------------------------------
# Pestaña: Conclusiones
# ------------------------------------------------------------------
conclusiones_ui <- function() {
  tagList(
    h3("Conclusiones"),

    h4("¿Qué tan progresivo es el impuesto sobre la renta en México?"),
    div(style = "min-height:120px;border-radius:8px;padding:14px;margin-bottom:28px",
        tags$p(
          "En su diseño, el ISR logra ser progresivo. Como ya se mencionó, la tasa promedio aumenta de forma ",
          "continua a raíz de alzas en la tasa marginal según cada grupo de ingreso. No obstante, el tramo más ",
          "alto no es alcanzado hasta ingresos muy elevados y la estructura no ha cambiado en la última década. ",
          "Además, es importante recalcar que en esta investigación se habla del impuesto estatutario y no de ",
          "los efectos económicos de este. La progresividad económica depende de deducciones, exenciones e ",
          "informalidad. Acudiendo a más literatura, Ramírez Cedillo confirma en su artículo ",
          tags$a(href = "https://www.cya.unam.mx/index.php/cya/article/view/2654", target = "_blank",
                 "Estudio de la Progresividad del Impuesto Sobre la Renta de Personas Físicas en México"),
          " que el ISR es progresivo y reduce la desigualdad, aunque de forma ligera."
        )),

    h4("¿Cómo se compara internacionalmente?"),
    div(style = "min-height:120px;border-radius:8px;padding:14px",
        tags$p(
          "Se puede argumentar que México tiene una recaudación más progresiva con respecto a otros países de ",
          "Latinoamérica si de su ISR se trata, pero con claras áreas de oportunidad de mejora como las diversas ",
          "herramientas adicionales que otros países usan en su gravamen. La progresividad del ISR en México se ",
          "encuentra dentro de los 10 niveles de ingreso gravable a diferencia de países como Bolivia que solo ",
          "cuenta con solo uno o Paraguay con tres. Pero la tasa de gravamen más alta es 35% la cual pareciera ",
          "ser estándar en el continente. Así mismo, el país no cuenta con tasas diferenciadas para hogares como ",
          "Estados Unidos o Uruguay y a diferencia de otros países que utilizan instrumentos de gravamen ajenos a ",
          "su moneda, en México se cobra el ISR sobre pesos por lo que su recaudación es susceptible a la ",
          "inflación. Este acomodo permite a México tener la mayor recaudación por medio del ISR como % de su ",
          "PIB, pero muchos países superan su recaudación total con tasas máximas de 13%. Por lo tanto, hay ",
          "muchas áreas de oportunidad en la tributación que van más allá del ISR, y hasta poder sacarles ",
          "provecho no podemos implementar las alternativas que países de ingresos altos la OECD ofrecen."
        ))
  )
}
