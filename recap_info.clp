
;=================================================================================
;================================= RECAP INFO ====================================
;=================================================================================

(defmodule RECAP_INFO (import MAIN ?ALL) (export ?ALL))
 
; --------------------------
; REGLA: CREAR FACTO INICIAL
; --------------------------
(defrule RECAP_INFO::crear-facto-evento
   (declare (salience 200))
   (not (condiciones_evento))
   =>
   (assert (condiciones_evento
             (tipo Indefinido)
             (epoca Indefinido)
             (asistentes 0)
             (alcohol Indefinido)
             (estilo Indefinido)
             (presupuesto 0.0)
             (presupuesto_pastel 0.0)
             (dietas_omnivoras 0)
             (dietas_veganas 0)
             (dietas_vegetarianas 0)
             (dietas_halal 0)
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
             (temperatura_primero Indefinido)
             (temperatura_segundo Indefinido)
             (temperatura_postre Indefinido)
             (ingredientes_prohibidos nil)
             (dieta_pastel Indefinido)
           )
   )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RECAP_INFO: REGLAS INTERACTIVAS PARA EVENTO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; --------------------------
; PREGUNTA TIPO DE EVENTO CON VALIDACIÓN
; --------------------------
(defrule RECAP_INFO::preguntar-tipo
   ?e <- (condiciones_evento (tipo Indefinido))
   =>
   (bind ?valido FALSE)
   (while (eq ?valido FALSE)
      (printout t "¿Qué tipo de evento es? (Evento_familiar o Congreso): ")
      (bind ?respuesta (read))
      (if (or (eq ?respuesta Evento_familiar) (eq ?respuesta Congreso))
         then
            (modify ?e (tipo ?respuesta))
            (printout t "¡Registrado! Tipo de evento: " ?respuesta crlf crlf)
            (bind ?valido TRUE)
         else
            (printout t "Respuesta incorrecta. Debe ser 'Evento_familiar' o 'Congreso'." crlf)
      )
   )
)

; --------------------------
; PREGUNTA ÉPOCA 
; --------------------------
(defrule RECAP_INFO::preguntar-epoca
   ?e <- (condiciones_evento (tipo ?tipo&~Indefinido) (epoca Indefinido))
   =>
   (bind ?valido FALSE)
   (while (eq ?valido FALSE)
      (printout t "¿En qué época se celebra el evento? (Verano, Invierno, Primavera, Otono): ")
      (bind ?resp (read))
      (if (or (eq ?resp Verano) (eq ?resp Invierno) (eq ?resp Primavera) (eq ?resp Otono))
         then
            (modify ?e (epoca ?resp))
            (bind ?valido TRUE)
            (printout t crlf)
         else
            (printout t "Respuesta incorrecta. Debe ser Verano, Invierno, Primavera u Otono." crlf)
      )
   )
)

; --------------------------
; PREGUNTA INVITADOS 
; --------------------------
(defrule RECAP_INFO::preguntar-invitados
   ?e <- (condiciones_evento (epoca ?epoca&~Indefinido) (asistentes 0))
   =>
   (bind ?valido FALSE)
   (while (eq ?valido FALSE)
      (printout t "¿Cuál es el número de asistentes del evento? (número > 0): ")
      (bind ?resp (read))
      (if (and (numberp ?resp) (> ?resp 0))
         then
            (modify ?e (asistentes ?resp))
            (bind ?valido TRUE)
            (printout t crlf)
         else
            (printout t "Respuesta incorrecta. Debe ser un número mayor a 0." crlf)
      )
   )
)

; --------------------------
; PREGUNTA PRESUPUESTO 
; --------------------------
(defrule RECAP_INFO::preguntar-presupuesto
   ?e <- (condiciones_evento (asistentes ?asist&~0) (presupuesto 0.0))
   =>
   (bind ?valido FALSE)
   (while (eq ?valido FALSE)
      (printout t "¿Cuál es el presupuesto para el del evento? (número > 0): ")
      (bind ?resp (read))
      (if (and (numberp ?resp) (> ?resp 0))
         then
            (modify ?e (presupuesto ?resp))
            (bind ?valido TRUE)
            (printout t crlf)
         else
            (printout t "Respuesta incorrecta. Debe ser un número mayor a 0." crlf)
      )
   )
)

; --------------------------
; PREGUNTA PRESUPUESTO PASTEL
; --------------------------
(defrule RECAP_INFO::preguntar-presupuesto-pastel
      (declare (salience 5))
      ?e <- (condiciones_evento
      (tipo Evento_familiar) ;; solo eventos familiares
      (presupuesto ?p&~0.0) ;; ya tenemos presupuesto general
      (presupuesto_pastel 0.0)) ;; aún no fijado
      =>
      (bind ?valido FALSE)
      (while (eq ?valido FALSE)
      (printout t "¿Cuál es el presupuesto para el pastel? (número > 0): ")
      (bind ?resp (read))
      (if (and (numberp ?resp) (> ?resp 0))
            then
            (modify ?e (presupuesto_pastel ?resp))
            (bind ?valido TRUE)
            (printout t crlf)
            else
            (printout t "Respuesta incorrecta. Debe ser un número mayor a 0." crlf)
            )
      )
)

; --------------------------
; PREGUNTA SI HAY ALCOHOL
; --------------------------
(defrule RECAP_INFO::preguntar-alcohol
   ?e <- (condiciones_evento (presupuesto ?presupuesto&~0.0) (alcohol Indefinido))
   =>
   (bind ?valido FALSE)
   (while (eq ?valido FALSE)
      (printout t "¿Habrá alcohol? (si/no): ")
      (bind ?resp (read))
      (if (or (eq ?resp si) (eq ?resp no))
         then
            (modify ?e (alcohol ?resp))
            (bind ?valido TRUE)
            (printout t crlf)
         else
            (printout t "Respuesta incorrecta. Debe ser 'si' o 'no'." crlf)
      )
   )
)

(deftemplate control
  (slot estado (type SYMBOL))
)

; --------------------------
; PREGUNTA DIETAS 
; --------------------------
(defrule RECAP_INFO::preguntar-dietas
   ?e <- (condiciones_evento (tipo ?tipo)
            (alcohol ?alcohol&~Indefinido)
            (dietas_omnivoras 0)
            (dietas_vegetarianas 0)
            (dietas_veganas 0)
            (dietas_halal 0)
            (asistentes ?asist))
   (not (control))
   =>
   (bind ?correcto FALSE)
   (while (eq ?correcto FALSE) 
      (bind ?comensales 0)

      ; -------- Omnívora --------
      (bind ?valido FALSE)
      (while (eq ?valido FALSE) 
         (printout t "¿Cuántos asistentes seguirán una dieta omnívora? (número >= 0): ")
         (bind ?resp1 (read))
         (if (and (integerp ?resp1) (>= ?resp1 0))
             then
                (modify ?e (dietas_omnivoras ?resp1))
                (bind ?comensales (+ ?comensales ?resp1))
                (bind ?valido TRUE)
             else
                (printout t "Respuesta incorrecta. Debe ser un número entero mayor o igual a 0." crlf))
      )

      ; -------- Vegetariana --------
      (bind ?valido FALSE)
      (while (eq ?valido FALSE) 
         (printout t "¿Cuántos asistentes seguirán una dieta vegetariana? (número >= 0): ")
         (bind ?resp2 (read))
         (if (and (integerp ?resp2) (>= ?resp2 0))
             then
                (modify ?e (dietas_vegetarianas ?resp2))
                (bind ?comensales (+ ?comensales ?resp2))
                (bind ?valido TRUE)
             else
                (printout t "Respuesta incorrecta. Debe ser un número entero mayor o igual a 0." crlf))
      )

      ; -------- Vegana --------
      (bind ?valido FALSE)
      (while (eq ?valido FALSE) 
         (printout t "¿Cuántos asistentes seguirán una dieta vegana? (número >= 0): ")
         (bind ?resp3 (read))
         (if (and (integerp ?resp3) (>= ?resp3 0))
             then
                (modify ?e (dietas_veganas ?resp3))
                (bind ?comensales (+ ?comensales ?resp3))
                (bind ?valido TRUE)
             else
                (printout t "Respuesta incorrecta. Debe ser un número entero mayor o igual a 0." crlf))
      )

      ; -------- Halal --------
      (bind ?valido FALSE)
      (while (eq ?valido FALSE) 
         (printout t "¿Cuántos asistentes seguirán una dieta halal? (número >= 0): ")
         (bind ?resp4 (read))
         (if (and (integerp ?resp4) (>= ?resp4 0))
             then
                (modify ?e (dietas_halal ?resp4))
                (bind ?comensales (+ ?comensales ?resp4))
                (bind ?valido TRUE)
             else
                (printout t "Respuesta incorrecta. Debe ser un número entero mayor o igual a 0." crlf))
      )

      ; -------- Comprobación del total --------
      (if (= ?comensales ?asist)
          then
             (bind ?correcto TRUE)
          else
             (printout t "Ha habido algún error. Hay " ?asist
                         " asistentes y me has pedido " ?comensales " dietas." crlf)
             (printout t "Vuelve a responder a las preguntas." crlf)
      )
   )
   (if (eq ?tipo Congreso) then (assert (control (estado dieta_pastel_completado)))
         else (assert (control (estado dietas_completadas))))
   (printout t crlf)
)

; --------------------------
; PREGUNTA DIETA PASTEL 
; --------------------------

(defrule RECAP_INFO::preguntar-dieta-pastel
   ?e <- (condiciones_evento (tipo Evento_familiar) (dieta_pastel Indefinido))
   ?c <- (control (estado dietas_completadas))
   =>
   (bind ?valido FALSE)
   (while (eq ?valido FALSE)
      (printout t "¿Qué dieta quieres que siga el pastel? (Omnivora, Vegetariano, Vegano, Halal): ")
      (bind ?resp (read))
      (if (or (eq ?resp Omnivora) (eq ?resp Vegetariano) (eq ?resp Vegano) (eq ?resp Halal))
         then
            (modify ?e (dieta_pastel ?resp))
            (bind ?valido TRUE)
            (printout t crlf)
         else
            (printout t "Respuesta incorrecta.Debe ser Omnivora, Vegetariano, Vegano o Halal." crlf)
      )
   )
   (modify ?c (estado dieta_pastel_completado))
)


; --------------------------
; PREGUNTA ESTILO 
; --------------------------

(defrule RECAP_INFO::preguntar-estilo
   ?e <- (condiciones_evento (estilo Indefinido))
   ?c <- (control (estado dieta_pastel_completado))
   =>
   (bind ?valido FALSE)
   (while (eq ?valido FALSE)
      (printout t "¿De qué estilo quieres que sea la comida? (Sibarita, Moderno, Clasico) " crlf)
      (printout t "Si te da igual escribe: Any " crlf)
      (bind ?resp (read))
      (if (or (eq ?resp Sibarita) (eq ?resp Moderno) (eq ?resp Clasico) (eq ?resp Any))
         then
            (modify ?e (estilo ?resp))
            (bind ?valido TRUE)
            (printout t crlf)
         else
            (printout t "Respuesta incorrecta. Debe ser Sibarita, Moderno, Clasico o Any." crlf)
      )
   )
   (modify ?c (estado estilo_completado))
)

; --------------------------
; PREGUNTA TEMPERATURAS
; --------------------------
(defrule RECAP_INFO::preguntar-temperaturas
   ?e <- (condiciones_evento (temperatura_primero Indefinido)
                 (temperatura_segundo Indefinido)
                 (temperatura_postre Indefinido) 
                 (estilo ?estilo&~Indefinido))
   ?c <- (control (estado estilo_completado))
   =>
   ;; Primer plato
   (bind ?valido FALSE)
   (while (eq ?valido FALSE)
      (printout t "Temperatura del primer plato (Frio, Caliente) " crlf)
      (printout t "Si te da igual escribe: Any " crlf)
      (bind ?tp (read))
      (if (or (eq ?tp Frio) (eq ?tp Caliente) (eq ?tp Any))
         then (bind ?valido TRUE)
         else (printout t "Respuesta incorrecta. Debe ser Frio, Caliente o Any." crlf)
      )
   )
   (modify ?e (temperatura_primero ?tp))

   ;; Segundo plato
   (bind ?valido FALSE)
   (while (eq ?valido FALSE)
      (printout t "Temperatura del segundo plato (Frio, Caliente) " crlf)
      (printout t "Si te da igual escribe: Any " crlf)
      (bind ?ts (read))
      (if (or (eq ?ts Frio) (eq ?ts Caliente) (eq ?ts Any))
         then (bind ?valido TRUE)
         else (printout t "Respuesta incorrecta. Debe ser Frio, Caliente o Any." crlf)
      )
   )
   (modify ?e (temperatura_segundo ?ts))

   ;; Postre
   (bind ?valido FALSE)
   (while (eq ?valido FALSE)
      (printout t "Temperatura del postre (Frio, Caliente) " crlf)
      (printout t "Si te da igual escribe: Any " crlf)
      (bind ?tpo (read))
      (if (or (eq ?tpo Frio) (eq ?tpo Caliente) (eq ?tpo Any))
         then (bind ?valido TRUE)
         else (printout t "Respuesta incorrecta. Debe ser Frio, Caliente o Any." crlf)
      )
   )
   (modify ?e (temperatura_postre ?tpo))
   (modify ?c (estado temp_completadas))
   (printout t crlf)
)


; --------------------------
; PREGUNTAR ALERGIAS EN BUCLE INTERACTIVO
; --------------------------

(deftemplate control-alergias
    (slot estado (type SYMBOL) (allowed-symbols si no))
)

(defrule RECAP_INFO::crear-facto-control-alergias
   (declare (salience 100))
   (not (control-alergias))
   =>
   (assert (control-alergias (estado si)))
)

(defrule RECAP_INFO::preguntar-alergias
   ?e <- (condiciones_evento
          (alergias_a_altramuces ?a1)
          (alergias_a_apio ?a2)
          (alergias_a_cacahuetes ?a3)
          (alergias_a_crustaceos ?a4)
          (alergias_a_frutos_cascara ?a5)
          (alergias_a_huevo ?a6)
          (alergias_a_lactosa ?a7)
          (alergias_a_moluscos ?a8)
          (alergias_a_mostaza ?a9)
          (alergias_a_sesamo ?a10)
          (alergias_a_soja ?a11)
          (alergias_a_sulfitos ?a12)
          (alergias_a_gluten ?a13)
          (alergias_a_pescado ?a14)
          (temperatura_postre ?temp&~Indefinido))
    ?c <- (control (estado temp_completadas))
   =>
   (bind ?continuar TRUE)
   (while ?continuar
      (bind ?resp FALSE)
      (while (eq ?resp FALSE)
         (printout t "¿Alguien tiene alguna alergia? (si/no): ")
         (bind ?respuesta (read))
         (if (or (eq ?respuesta si) (eq ?respuesta no))
            then (bind ?resp TRUE)
            else (printout t "Respuesta incorrecta. Debe ser 'si' o 'no'." crlf)
         )
      )

      (if (eq ?respuesta no) 
         then   (bind ?continuar FALSE)
         else
            (bind ?alergia_valida FALSE)
            (while (eq ?alergia_valida FALSE)
               (printout t "¿Qué tipo de alergia?" crlf "(altramuces, apio, cacahuetes, crustaceos, frutos_cascara, huevo, lactosa, moluscos, mostaza, sesamo, soja, sulfitos, gluten, pescado): ")
               (bind ?tipo (read))
               (if (or (eq ?tipo altramuces) (eq ?tipo apio) (eq ?tipo cachuetes)
                       (eq ?tipo crustaceos) (eq ?tipo frutos_cascara) (eq ?tipo huevo)
                       (eq ?tipo lactosa) (eq ?tipo moluscos) (eq ?tipo mostaza)
                       (eq ?tipo sesamo) (eq ?tipo soja) (eq ?tipo sulfitos)
                       (eq ?tipo gluten) (eq ?tipo pescado))
                  then (bind ?alergia_valida TRUE)
                  else (printout t "Alergia no válida. Reintente." crlf)
               )
            )

            ; Modificar el fact según el tipo de alergia
            (if (eq ?tipo altramuces) then (modify ?e (alergias_a_altramuces TRUE)))
            (if (eq ?tipo apio) then (modify ?e (alergias_a_apio TRUE)))
            (if (eq ?tipo cachuetes) then (modify ?e (alergias_a_cacahuetes TRUE)))
            (if (eq ?tipo crustaceos) then (modify ?e (alergias_a_crustaceos TRUE)))
            (if (eq ?tipo frutos_cascara) then (modify ?e (alergias_a_frutos_cascara TRUE)))
            (if (eq ?tipo huevo) then (modify ?e (alergias_a_huevo TRUE)))
            (if (eq ?tipo lactosa) then (modify ?e (alergias_a_lactosa TRUE)))
            (if (eq ?tipo moluscos) then (modify ?e (alergias_a_moluscos TRUE)))
            (if (eq ?tipo mostaza) then (modify ?e (alergias_a_mostaza TRUE)))
            (if (eq ?tipo sesamo) then (modify ?e (alergias_a_sesamo TRUE)))
            (if (eq ?tipo soja) then (modify ?e (alergias_a_soja TRUE)))
            (if (eq ?tipo sulfitos) then (modify ?e (alergias_a_sulfitos TRUE)))
            (if (eq ?tipo gluten) then (modify ?e (alergias_a_gluten TRUE)))
            (if (eq ?tipo pescado) then (modify ?e (alergias_a_pescado TRUE)))
      )
   )
    (modify ?c (estado alergias_completadas))
    (printout t "No hay más alergias." crlf)
    (printout t crlf)
)

; --------------------------
; PREGUNTA INGREDIENTES PROHIBIDOS
; --------------------------
(defrule RECAP_INFO::preguntar-ingredientes-prohibidos
   ?e <- (condiciones_evento (ingredientes_prohibidos $?vacios))
   ?c <- (control (estado alergias_completadas))
   =>
   (printout t crlf)
   (printout t "¿Hay algún ingrediente que NO quieras en los platos?" crlf)
   (printout t "Escribe uno a uno los ingredientes prohibidos (primera letra mayúscula) y pulsa Enter tras cada uno." crlf)
   (printout t "Cuando hayas terminado, escribe: FIN" crlf crlf)

   (bind ?ingredientes (create$)) ; lista vacía inicial
   (bind ?fin FALSE)

   (while (eq ?fin FALSE)
      (printout t "Ingrediente prohibido (o 'FIN' para terminar): ")
      (bind ?ing (read))
      (if (eq ?ing FIN)
         then (bind ?fin TRUE)
         else
            (if (member$ ?ing ?ingredientes)
               then (printout t "Ya habías indicado ese ingrediente. No se añadirá de nuevo." crlf)
               else (bind ?ingredientes (create$ ?ingredientes ?ing))
            )
      )
   )

   (if (eq (length$ ?ingredientes) 0)
      then
         (printout t crlf "No se han indicado ingredientes prohibidos. Perfecto." crlf)
      else
         (printout t crlf "Ingredientes prohibidos guardados: " ?ingredientes crlf)
   )
   (printout t crlf)
   (modify ?e (ingredientes_prohibidos ?ingredientes))
   (modify ?c (estado acabado))
)

(defrule RECAP_INFO::final-recap-RECAP_INFO
   ?c <- (control (estado acabado))
   =>
   (printout t "¡Tus respuestas han sido registradas!")
   (modify ?c (estado no))
   (focus ABSTRACCION)
)

