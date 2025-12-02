
;=================================================================================
;================================ ABSTRACCION ====================================
;=================================================================================
; Recoger la informacion que necesitamos del evento
(defmodule ABSTRACCION (import MAIN ?ALL)(export ?ALL))

; PARA PROBAR SIN TENER QUE EJECUTAR RECAP_INFO
(defrule ABSTRACCION::crear-evento
   (declare (salience 200))
   (not (condiciones_evento))
   =>
   (assert (condiciones_evento
             (tipo Evento_familiar)
             (epoca Verano)
             (asistentes 50)
             (alcohol si)
             (estilo Clasico)
             (presupuesto 2500.0)
             (presupuesto_pastel 200.0)
             (dietas_omnivoras 44)
             (dietas_veganas 2)
             (dietas_vegetarianas 2)
             (dietas_halal 2)
             (alergias_a_altramuces FALSE)
             (alergias_a_apio FALSE)
             (alergias_a_cacahuetes FALSE)
             (alergias_a_crustaceos FALSE)
             (alergias_a_frutos_cascara FALSE)
             (alergias_a_huevo FALSE)
             (alergias_a_lactosa FALSE)
             (alergias_a_moluscos FALSE)
             (alergias_a_mostaza FALSE)
             (alergias_a_sesamo FALSE)
             (alergias_a_soja FALSE)
             (alergias_a_sulfitos FALSE)
             (alergias_a_gluten FALSE)
             (alergias_a_pescado FALSE)
             (temperatura_primero Any)
             (temperatura_segundo Any)
             (temperatura_postre Any)
             (ingredientes_prohibidos (create$))
             (dieta_pastel Omnivora)
           )
   )
   (printout t "Condiciones creadas" crlf)
)


(defrule ABSTRACCION::crear-instancia-evento
   ?e <- (condiciones_evento 
           (tipo ?tipo&~Indefinido)
           (epoca ?epoca&~Indefinido)
           (estilo ?estilo&~Indefinido)
           (temperatura_primero ?tp&~Indefinido)
           (temperatura_segundo ?ts&~Indefinido)
           (temperatura_postre ?tpo&~Indefinido)
           (ingredientes_prohibidos $?prohibidos)
           (alergias_a_frutos_cascara ?a1)
           (alergias_a_huevo ?a2)
           (alergias_a_lactosa ?a3)
           (alergias_a_soja ?a4)
           (alergias_a_sulfitos ?a5)
           (alergias_a_gluten ?a6)
           (alergias_a_pescado ?a7)
           (alergias_a_mostaza ?a8)
           (alergias_a_crustaceos ?a9)
           (alergias_a_sesamo ?a10)
           (alergias_a_apio ?a11)
           (alergias_a_altramuces ?a12)
           (alergias_a_moluscos ?a13)
           (alergias_a_cacahuetes ?a14)
           (dietas_omnivoras ?omn)
           (dietas_vegetarianas ?veg)
           (dietas_veganas ?vegana)
           (dietas_halal ?halal))
   =>

   ;; Crear la instancia y guardarla en ?inst
   (bind ?inst (if (eq ?tipo Congreso)
                  then (make-instance evento of Congreso)
                  else (make-instance evento of Evento_familiar)))

   ;; Asignar restricciones de estilo, temperatura e ingredientes
   (send ?inst put-sucede_en ?epoca)
   (send ?inst put-tiene_restriccion_estilo ?estilo)
   (send ?inst put-tiene_restriccion_temperatura_primero ?tp)
   (send ?inst put-tiene_restriccion_temperatura_segundo ?ts)
   (send ?inst put-tiene_restriccion_temperatura_postre ?tpo)
   (send ?inst put-prohibe_ingredientes ?prohibidos)

   ;; Inicializar lista de alergias
   (bind ?lista-alergias (create$))
   (if ?a1 then (bind ?lista-alergias (create$ ?lista-alergias [Alergia_a_frutos_con_cascara])))
   (if ?a2 then (bind ?lista-alergias (create$ ?lista-alergias [Alergia_a_huevos])))
   (if ?a3 then (bind ?lista-alergias (create$ ?lista-alergias [Alergia_a_lactosa])))
   (if ?a4 then (bind ?lista-alergias (create$ ?lista-alergias [Alergia_a_soja])))
   (if ?a5 then (bind ?lista-alergias (create$ ?lista-alergias [Alergia_a_sulfitos])))
   (if ?a6 then (bind ?lista-alergias (create$ ?lista-alergias [Alergia_al_gluten])))
   (if ?a7 then (bind ?lista-alergias (create$ ?lista-alergias [Alergia_al_pescado])))
   (if ?a8 then (bind ?lista-alergias (create$ ?lista-alergias [Alergia_a_mostaza])))
   (if ?a9 then (bind ?lista-alergias (create$ ?lista-alergias [Alergia_a_crustaceos])))
   (if ?a10 then (bind ?lista-alergias (create$ ?lista-alergias [Alergia_a_sesamo])))
   (if ?a11 then (bind ?lista-alergias (create$ ?lista-alergias [Alergia_a_apio])))
   (if ?a12 then (bind ?lista-alergias (create$ ?lista-alergias [Alergia_a_altramuces])))
   (if ?a13 then (bind ?lista-alergias (create$ ?lista-alergias [Alergia_a_moluscos])))
   (if ?a14 then (bind ?lista-alergias (create$ ?lista-alergias [Alergia_a_cacahuetes])))

   ;; Inicializar lista de dietas
   (bind ?lista-dietas (create$))
   (if (> ?omn 0) then (bind ?lista-dietas (create$ ?lista-dietas [Omnivora])))
   (if (> ?veg 0) then (bind ?lista-dietas (create$ ?lista-dietas [Vegetariano])))
   (if (> ?vegana 0) then (bind ?lista-dietas (create$ ?lista-dietas [Vegano])))
   (if (> ?halal 0) then (bind ?lista-dietas (create$ ?lista-dietas [Halal])))
    
    (send ?inst put-dietas ?lista-dietas)
    (send ?inst put-alergias ?lista-alergias)

   (printout t "Instancia de evento creada correctamente." crlf)
   (focus ASOCIACION)
)
