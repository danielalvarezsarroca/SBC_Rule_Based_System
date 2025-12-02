
;=================================================================================
;================================ ASOCIACION =====================================
;=================================================================================
; Qué platos son válidos

(defmodule ASOCIACION (import MAIN ?ALL)(export ?ALL))

(deftemplate control_asociacion
  (slot estado (type SYMBOL))
)

(deftemplate comida_compatible
  (multislot ingredientes)
  (multislot primeros_omnivoros)
  (multislot primeros_veganos)
  (multislot primeros_vegetarianos)
  (multislot primeros_halal)
  (multislot segundos_omnivoros)
  (multislot segundos_veganos)
  (multislot segundos_vegetarianos)
  (multislot segundos_halal)
  (multislot postres_omnivoros)
  (multislot postres_veganos)
  (multislot postres_vegetarianos)
  (multislot postres_halal)
  (multislot bebidas_omnivoras)
  (multislot bebidas_veganas)
  (multislot bebidas_vegetarianas)
  (multislot bebidas_halal)
  (multislot pasteles_omnivoros)
  (multislot pasteles_veganos)
  (multislot pasteles_vegetarianos)
  (multislot pasteles_halal)
)

(defrule ASOCIACION::buscar_ingredientes
    (declare (salience 100))
    (not (control_asociacion))
    ?e <- (object 
                (is-a Evento) 
                (sucede_en ?epoca))
    =>
    (assert (control_asociacion (estado buscando_ingredientes)))
    (printout t crlf "===  BUSCANDO INGREDIENTES DISPONIBLES EN " ?epoca " ===" crlf)
    (bind ?ingredientes_disponibles (create$))

    (do-for-all-instances ((?i Ingredientes)) TRUE
        (bind ?disp (send ?i get-disponible_en))  ;; lista de instancias de estaciones
        ;; Convertimos a nombres de instancias
        (bind ?disp-nombres (create$))
        (foreach ?inst ?disp
            (bind ?disp-nombres (create$ ?disp-nombres (instance-name ?inst)))
        )
        ;; Comprobamos si la estación del evento está en la lista de nombres
        (if (member$ (instance-name ?epoca) ?disp-nombres) then
            (bind ?ingredientes_disponibles (create$ ?ingredientes_disponibles (instance-name ?i)))
        )
    )
   (assert (comida_compatible (ingredientes ?ingredientes_disponibles)))
   (printout t "Ingredientes encontrados: " ?ingredientes_disponibles crlf)
)

(defrule ASOCIACION::buscar_primeros
  (declare (salience 90))
  ?e <- (object
          (is-a Evento)
          (dietas $?dietas)
          (tiene_restriccion_estilo ?estilo)
          (tiene_restriccion_temperatura_primero ?temp)
          (prohibe_ingredientes $?ingredientes_prohibidos)
          (sucede_en ?epoca)
          (alergias $?alergenos_no))
  ?c <- (control_asociacion (estado buscando_ingredientes))
  ?comp <- (comida_compatible (ingredientes $?ingDisponibles))
  =>
  (modify ?c (estado buscando_primeros))
  (printout t crlf "=== BUSCANDO PRIMEROS ===" crlf)

  ;; Inicializar listas de primeros según dieta
  (bind ?primero_omnivoros     (create$))
  (bind ?primero_veganos       (create$))
  (bind ?primero_vegetarianos  (create$))
  (bind ?primero_halal         (create$))

  (bind ?epocaName (instance-name ?epoca))

  ;; Normalizar banderas “Any” por si vienen con nombres distintos
  (bind ?estiloEsAny (or (eq ?estilo Any) (eq ?estilo AnyEstilo)))
  (bind ?tempEsAny   (or (eq ?temp   Any) (eq ?temp   AnyTempPrimero)))

  ;; Recorrer todos los primeros
  (do-for-all-instances ((?p Primero)) TRUE

    ;; ===== Estilo: convertir a nombres Y a símbolos “pelados” =====
    (bind ?estilosNames (create$))
    (bind ?estilosSyms  (create$))
    (foreach ?inst (create$ (send ?p get-tiene_estilo))
      (bind ?nm (instance-name ?inst))
      (bind ?estilosNames (create$ ?estilosNames ?nm))
      (bind ?estilosSyms  (create$ ?estilosSyms (instance-name-to-symbol ?nm)))
    )
    (if (or ?estiloEsAny
            (member$ ?estilo ?estilosSyms)) then

      ;; ===== Temperatura: a nombres Y símbolos =====
      (bind ?tempsNames (create$))
      (bind ?tempsSyms  (create$))
      (foreach ?inst (create$ (send ?p get-tiene_temperatura))
        (bind ?nm (instance-name ?inst))
        (bind ?tempsNames (create$ ?tempsNames ?nm))
        (bind ?tempsSyms  (create$ ?tempsSyms (instance-name-to-symbol ?nm)))
      )
      (if (or ?tempEsAny
              (member$ ?temp ?tempsSyms)) then

        ;; ===== Época (se_sirve_en) =====
        (bind ?sirveEnNames (create$))
        (foreach ?inst (create$ (send ?p get-se_sirve_en))
          (bind ?sirveEnNames (create$ ?sirveEnNames (instance-name ?inst)))
        )
        (if (member$ ?epocaName ?sirveEnNames) then

          ;; ===== Ingredientes del plato a nombres =====
          (bind ?usa_ingredientes (create$))
          (foreach ?inst (send ?p get-usa_ingrediente)
            ;; Convertimos a string y luego a field para unificar INSTANCE-NAME/SYMBOL
            (bind ?usa_ingredientes
              (create$ ?usa_ingredientes
                (string-to-field (str-cat (instance-name ?inst)))))
          )

          ;; ===== Normalizar prohibidos a nombres (símbolo o instance-name) =====
          (bind ?prohibidosNames (create$))
          (foreach ?x ?ingredientes_prohibidos
            (bind ?prohibidosNames
              (create$ ?prohibidosNames
                (string-to-field
                  (str-cat
                    (if (instance-addressp ?x) then (instance-name ?x)
                     else (if (instance-namep ?x) then ?x else ?x)))))))

          ;; ===== Chequeo de PROHIBIDOS =====
          (bind ?valido TRUE)
          (foreach ?bad ?prohibidosNames
            (if (member$ ?bad ?usa_ingredientes) then
              (bind ?valido FALSE))
          )

          ;; ===== Chequeo de ALERGIAS =====
          (if ?valido then
            ;; Alergias del plato normalizadas a nombres/fields
            (bind ?alergias_plato (create$))
            (foreach ?a (send ?p get-contiene_alergenos)
              (bind ?alergias_plato
                (create$ ?alergias_plato
                  (string-to-field
                    (str-cat
                      (if (instance-addressp ?a) then (instance-name ?a)
                       else (if (instance-namep ?a) then ?a else ?a)))))))

            ;; Alergias del evento normalizadas del mismo modo
            (bind ?alerUser (create$))
            (foreach ?x ?alergenos_no
              (bind ?alerUser
                (create$ ?alerUser
                  (string-to-field
                    (str-cat
                      (if (instance-addressp ?x) then (instance-name ?x)
                       else (if (instance-namep ?x) then ?x else ?x)))))))

            ;; Si hay intersección, se descarta el plato
            (foreach ?ua ?alerUser
              (if (member$ ?ua ?alergias_plato) then (bind ?valido FALSE)))
          )

          ;; ===== Reparto por dietas (si sigue siendo válido) =====
          (if ?valido then
            ;; aptitudes del plato: normalmente instancias [Omnivora] [Vegano] ...
            (bind ?apt (create$ (send ?p get-es_apto_para)))

            ;; Omnívora
            (if (and (member$ [Omnivora] ?dietas) (member$ [Omnivora] ?apt)) then
              (bind ?primero_omnivoros (create$ ?primero_omnivoros (instance-name ?p))))
            ;; Vegana (también válida para vegetariana y omnívora)
            (if (and (member$ [Vegano] ?dietas) (member$ [Vegano] ?apt)) then
              (bind ?primero_veganos (create$ ?primero_veganos (instance-name ?p)))
              (bind ?primero_vegetarianos (create$ ?primero_vegetarianos (instance-name ?p)))
              (bind ?primero_omnivoros (create$ ?primero_omnivoros (instance-name ?p))))
            ;; Vegetariana (también válida para omnívora)
            (if (and (member$ [Vegetariano] ?dietas) (member$ [Vegetariano] ?apt)) then
              (bind ?primero_vegetarianos (create$ ?primero_vegetarianos (instance-name ?p)))
              (bind ?primero_omnivoros (create$ ?primero_omnivoros (instance-name ?p))))
            ;; Halal (también válida para omnívora)
            (if (and (member$ [Halal] ?dietas) (member$ [Halal] ?apt)) then
              (bind ?primero_halal (create$ ?primero_halal (instance-name ?p)))
              (bind ?primero_omnivoros (create$ ?primero_omnivoros (instance-name ?p))))
          )
        )
      )
    )
  )

  ;; Guardar resultados en comida_compatible
  (modify ?comp
    (primeros_omnivoros     ?primero_omnivoros)
    (primeros_veganos       ?primero_veganos)
    (primeros_vegetarianos  ?primero_vegetarianos)
    (primeros_halal         ?primero_halal))

  ;; Mostrar
  (printout t crlf "--- PRIMEROS COMPATIBLES ---" crlf)
  (printout t "Omnívoros (" (length$ ?primero_omnivoros)     "): " ?primero_omnivoros crlf)
  (printout t "Veganos   (" (length$ ?primero_veganos)       "): " ?primero_veganos crlf)
  (printout t "Vegetar.  (" (length$ ?primero_vegetarianos)  "): " ?primero_vegetarianos crlf)
  (printout t "Halal     (" (length$ ?primero_halal)         "): " ?primero_halal crlf)

  (printout t "Primeros compatibles añadidos a comida_compatible." crlf)
)



(defrule ASOCIACION::buscar_segundos
  (declare (salience 80))
  ?e <- (object
          (is-a Evento)
          (dietas $?dietas)
          (tiene_restriccion_estilo ?estilo)
          (tiene_restriccion_temperatura_segundo ?temp)
          (prohibe_ingredientes $?ingredientes_prohibidos)
          (sucede_en ?epoca)
          (alergias $?alergenos_no))
  ?c <- (control_asociacion (estado buscando_primeros))
  ?comp <- (comida_compatible (ingredientes $?ingDisponibles))
  =>
  (modify ?c (estado buscando_segundos))
  (printout t crlf crlf "=== BUSCANDO SEGUNDOS ===" crlf crlf)

  ;; Inicializar listas por dieta
  (bind ?segundo_omnivoros     (create$))
  (bind ?segundo_veganos       (create$))
  (bind ?segundo_vegetarianos  (create$))
  (bind ?segundo_halal         (create$))

  (bind ?epocaName (instance-name ?epoca))

  ;; Normalizar banderas “Any”
  (bind ?estiloEsAny (or (eq ?estilo Any) (eq ?estilo AnyEstilo)))
  (bind ?tempEsAny   (or (eq ?temp   Any) (eq ?temp   AnyTempSegundo)))

  ;; Recorrer todos los segundos
  (do-for-all-instances ((?p Segundo)) TRUE

    ;; ===== Estilo: a nombres y símbolos =====
    (bind ?estilosNames (create$))
    (bind ?estilosSyms  (create$))
    (foreach ?inst (create$ (send ?p get-tiene_estilo))
      (bind ?nm (instance-name ?inst))
      (bind ?estilosNames (create$ ?estilosNames ?nm))
      (bind ?estilosSyms  (create$ ?estilosSyms (instance-name-to-symbol ?nm)))
    )
    (if (or ?estiloEsAny
            (member$ ?estilo ?estilosSyms)) then

      ;; ===== Temperatura: a nombres y símbolos =====
      (bind ?tempsNames (create$))
      (bind ?tempsSyms  (create$))
      (foreach ?inst (create$ (send ?p get-tiene_temperatura))
        (bind ?nm (instance-name ?inst))
        (bind ?tempsNames (create$ ?tempsNames ?nm))
        (bind ?tempsSyms  (create$ ?tempsSyms (instance-name-to-symbol ?nm)))
      )
      (if (or ?tempEsAny
              (member$ ?temp ?tempsSyms)) then

        ;; ===== Época =====
        (bind ?sirveEnNames (create$))
        (foreach ?inst (create$ (send ?p get-se_sirve_en))
          (bind ?sirveEnNames (create$ ?sirveEnNames (instance-name ?inst)))
        )
        (if (member$ ?epocaName ?sirveEnNames) then

          ;; ===== Ingredientes del plato a nombres =====
          (bind ?usa_ingredientes (create$))
          (foreach ?inst (send ?p get-usa_ingrediente)
            (bind ?usa_ingredientes
              (create$ ?usa_ingredientes
                (string-to-field (str-cat (instance-name ?inst)))))
          )

          ;; ===== Normalizar PROHIBIDOS (símbolo o instancia) =====
          (bind ?prohibidosNames (create$))
          (foreach ?x ?ingredientes_prohibidos
            (bind ?prohibidosNames
              (create$ ?prohibidosNames
                (string-to-field
                  (str-cat
                    (if (instance-addressp ?x) then (instance-name ?x)
                     else (if (instance-namep ?x) then ?x else ?x)))))))

          ;; ===== Chequeo de PROHIBIDOS =====
          (bind ?valido TRUE)
          (foreach ?bad ?prohibidosNames
            (if (member$ ?bad ?usa_ingredientes) then
              (bind ?valido FALSE))
          )

          ;; ===== Chequeo de ALERGIAS =====
          (if ?valido then
            ;; Alergias del plato normalizadas
            (bind ?alergias_plato (create$))
            (foreach ?a (send ?p get-contiene_alergenos)
              (bind ?alergias_plato
                (create$ ?alergias_plato
                  (string-to-field
                    (str-cat
                      (if (instance-addressp ?a) then (instance-name ?a)
                       else (if (instance-namep ?a) then ?a else ?a)))))))

            ;; Alergias del evento normalizadas
            (bind ?alerUser (create$))
            (foreach ?x ?alergenos_no
              (bind ?alerUser
                (create$ ?alerUser
                  (string-to-field
                    (str-cat
                      (if (instance-addressp ?x) then (instance-name ?x)
                       else (if (instance-namep ?x) then ?x else ?x)))))))

            ;; Intersección -> descartar
            (foreach ?ua ?alerUser
              (if (member$ ?ua ?alergias_plato) then (bind ?valido FALSE)))
          )

          ;; ===== Reparto por dietas =====
          (if ?valido then
            (bind ?apt (create$ (send ?p get-es_apto_para)))

            ;; Omnívora
            (if (and (member$ [Omnivora] ?dietas) (member$ [Omnivora] ?apt)) then
              (bind ?segundo_omnivoros (create$ ?segundo_omnivoros (instance-name ?p))))
            ;; Vegana (también vegetariana y omnívora)
            (if (and (member$ [Vegano] ?dietas) (member$ [Vegano] ?apt)) then
              (bind ?segundo_veganos (create$ ?segundo_veganos (instance-name ?p)))
              (bind ?segundo_omnivoros (create$ ?segundo_omnivoros (instance-name ?p)))
              (bind ?segundo_vegetarianos (create$ ?segundo_vegetarianos (instance-name ?p))))
            ;; Vegetariana (también omnívora)
            (if (and (member$ [Vegetariano] ?dietas) (member$ [Vegetariano] ?apt)) then
              (bind ?segundo_vegetarianos (create$ ?segundo_vegetarianos (instance-name ?p)))
              (bind ?segundo_omnivoros (create$ ?segundo_omnivoros (instance-name ?p))))
            ;; Halal (también omnívora)
            (if (and (member$ [Halal] ?dietas) (member$ [Halal] ?apt)) then
              (bind ?segundo_halal (create$ ?segundo_halal (instance-name ?p)))
              (bind ?segundo_omnivoros (create$ ?segundo_omnivoros (instance-name ?p))))
          )
        )
      )
    )
  )

  ;; Guardar resultados en comida_compatible
  (modify ?comp
    (segundos_omnivoros     ?segundo_omnivoros)
    (segundos_veganos       ?segundo_veganos)
    (segundos_vegetarianos  ?segundo_vegetarianos)
    (segundos_halal         ?segundo_halal))

  ;; Mostrar
  (printout t crlf "--- SEGUNDOS COMPATIBLES ---" crlf)
  (printout t "Omnívoros (" (length$ ?segundo_omnivoros)     "): " ?segundo_omnivoros crlf)
  (printout t "Veganos   (" (length$ ?segundo_veganos)       "): " ?segundo_veganos crlf)
  (printout t "Vegetar.  (" (length$ ?segundo_vegetarianos)  "): " ?segundo_vegetarianos crlf)
  (printout t "Halal     (" (length$ ?segundo_halal)         "): " ?segundo_halal crlf)

  (printout t "Segundos compatibles añadidos a comida_compatible." crlf)
)



(defrule ASOCIACION::buscar_postre
  (declare (salience 70))
  ?e <- (object
          (is-a Evento)
          (dietas $?dietas)
          (tiene_restriccion_estilo ?estilo)
          (tiene_restriccion_temperatura_postre ?temp)
          (prohibe_ingredientes $?ingredientes_prohibidos)
          (sucede_en ?epoca)
          (alergias $?alergenos_no))
  ?c <- (control_asociacion (estado buscando_segundos))
  ?comp <- (comida_compatible (ingredientes $?ingDisponibles))
  =>
  (modify ?c (estado buscando_postres))
  (printout t crlf crlf "=== BUSCANDO POSTRES ===" crlf)

  ;; Inicializar listas por dieta
  (bind ?postre_omnivoros     (create$))
  (bind ?postre_veganos       (create$))
  (bind ?postre_vegetarianos  (create$))
  (bind ?postre_halal         (create$))

  (bind ?epocaName (instance-name ?epoca))

  ;; Normalizar banderas “Any”
  (bind ?estiloEsAny (or (eq ?estilo Any) (eq ?estilo AnyEstilo)))
  (bind ?tempEsAny   (or (eq ?temp   Any) (eq ?temp   AnyTempPostre)))

  ;; Recorrer todos los postres
  (do-for-all-instances ((?p Postre)) TRUE

    ;; ===== Estilo: a nombres y a símbolos =====
    (bind ?estilosNames (create$))
    (bind ?estilosSyms  (create$))
    (foreach ?inst (create$ (send ?p get-tiene_estilo))
      (bind ?nm (instance-name ?inst))
      (bind ?estilosNames (create$ ?estilosNames ?nm))
      (bind ?estilosSyms  (create$ ?estilosSyms (instance-name-to-symbol ?nm)))
    )
    (if (or ?estiloEsAny (member$ ?estilo ?estilosSyms)) then

      ;; ===== Temperatura: a nombres y símbolos =====
      (bind ?tempsNames (create$))
      (bind ?tempsSyms  (create$))
      (foreach ?inst (create$ (send ?p get-tiene_temperatura))
        (bind ?nm (instance-name ?inst))
        (bind ?tempsNames (create$ ?tempsNames ?nm))
        (bind ?tempsSyms  (create$ ?tempsSyms (instance-name-to-symbol ?nm)))
      )
      (if (or ?tempEsAny (member$ ?temp ?tempsSyms)) then

        ;; ===== Época =====
        (bind ?sirveEnNames (create$))
        (foreach ?inst (create$ (send ?p get-se_sirve_en))
          (bind ?sirveEnNames (create$ ?sirveEnNames (instance-name ?inst))))
        (if (member$ ?epocaName ?sirveEnNames) then

          ;; ===== Ingredientes del postre (instance-name → símbolo) =====
          (bind ?usa_ingredientes (create$))
          (foreach ?inst (send ?p get-usa_ingrediente)
            (bind ?usa_ingredientes
              (create$ ?usa_ingredientes
                (string-to-field (str-cat (instance-name ?inst))))))

          ;; ===== Normalizar PROHIBIDOS (símbolo o instancia) =====
          (bind ?prohibidosNames (create$))
          (foreach ?x ?ingredientes_prohibidos
            (bind ?prohibidosNames
              (create$ ?prohibidosNames
                (string-to-field
                  (str-cat
                    (if (instance-addressp ?x) then (instance-name ?x)
                     else (if (instance-namep ?x) then ?x else ?x)))))))

          ;; ===== Chequeo de PROHIBIDOS =====
          (bind ?valido TRUE)
          (foreach ?bad ?prohibidosNames
            (if (member$ ?bad ?usa_ingredientes) then (bind ?valido FALSE)))

          ;; ===== Chequeo de ALERGIAS =====
          (if ?valido then
            ;; Alergias del postre normalizadas
            (bind ?alergias_plato (create$))
            (foreach ?a (send ?p get-contiene_alergenos)
              (bind ?alergias_plato
                (create$ ?alergias_plato
                  (string-to-field
                    (str-cat
                      (if (instance-addressp ?a) then (instance-name ?a)
                       else (if (instance-namep ?a) then ?a else ?a)))))))

            ;; Alergias del evento normalizadas
            (bind ?alerUser (create$))
            (foreach ?x ?alergenos_no
              (bind ?alerUser
                (create$ ?alerUser
                  (string-to-field
                    (str-cat
                      (if (instance-addressp ?x) then (instance-name ?x)
                       else (if (instance-namep ?x) then ?x else ?x)))))))

            ;; Intersección -> descartar
            (foreach ?ua ?alerUser
              (if (member$ ?ua ?alergias_plato) then (bind ?valido FALSE)))
          )

          ;; ===== Reparto por dietas =====
          (if ?valido then
            (bind ?apt (create$ (send ?p get-es_apto_para)))
            ;; Omnívora
            (if (and (member$ [Omnivora] ?dietas) (member$ [Omnivora] ?apt)) then
              (bind ?postre_omnivoros (create$ ?postre_omnivoros (instance-name ?p))))
            ;; Vegana (también vegetariana y omnívora)
            (if (and (member$ [Vegano] ?dietas) (member$ [Vegano] ?apt)) then
              (bind ?postre_veganos (create$ ?postre_veganos (instance-name ?p)))
              (bind ?postre_omnivoros (create$ ?postre_omnivoros (instance-name ?p)))
              (bind ?postre_vegetarianos (create$ ?postre_vegetarianos (instance-name ?p))))
            ;; Vegetariana (también omnívora)
            (if (and (member$ [Vegetariano] ?dietas) (member$ [Vegetariano] ?apt)) then
              (bind ?postre_vegetarianos (create$ ?postre_vegetarianos (instance-name ?p)))
              (bind ?postre_omnivoros (create$ ?postre_omnivoros (instance-name ?p))))
            ;; Halal (también omnívora)
            (if (and (member$ [Halal] ?dietas) (member$ [Halal] ?apt)) then
              (bind ?postre_halal (create$ ?postre_halal (instance-name ?p)))
              (bind ?postre_omnivoros (create$ ?postre_omnivoros (instance-name ?p))))
          )
        )
      )
    )
  )

  ;; Guardar resultados en comida_compatible
  (modify ?comp
    (postres_omnivoros     ?postre_omnivoros)
    (postres_veganos       ?postre_veganos)
    (postres_vegetarianos  ?postre_vegetarianos)
    (postres_halal         ?postre_halal))

  ;; Mostrar
  (printout t crlf "--- POSTRES COMPATIBLES ---" crlf)
  (printout t "Omnívoros (" (length$ ?postre_omnivoros)     "): " ?postre_omnivoros crlf)
  (printout t "Veganos   (" (length$ ?postre_veganos)       "): " ?postre_veganos crlf)
  (printout t "Vegetar.  (" (length$ ?postre_vegetarianos)  "): " ?postre_vegetarianos crlf)
  (printout t "Halal     (" (length$ ?postre_halal)         "): " ?postre_halal crlf)

  (printout t "Postres compatibles añadidos a comida_compatible." crlf)
)



(defrule ASOCIACION::buscar_bebidas
  (declare (salience 75))
  (condiciones_evento (tipo ?tipo))
  ?e <- (object
          (is-a Evento)
          (dietas $?dietas)
          (sucede_en ?epoca)
          (alergias $?alergenos_no)
          (prohibe_ingredientes $?ingredientes_prohibidos))
  (condiciones_evento (alcohol ?alc))
  ?ctrl <- (control_asociacion (estado buscando_postres))
  ?comp <- (comida_compatible (ingredientes $?ingDisponibles))
=>
  (modify ?ctrl (estado buscando_bebidas))
  (printout t crlf "=== BUSCANDO BEBIDAS  ===" crlf)

  (bind ?b_omn    (create$))
  (bind ?b_vegano (create$))
  (bind ?b_vegt   (create$))
  (bind ?b_halal  (create$))

  ;; Permiso alcohol del evento
  (bind ?permiteAlcohol
        (or (eq ?alc si) (eq ?alc yes) (eq ?alc TRUE) (eq ?alc Si)))

  ;; Dietas activas
  (bind ?has-omn    (or (member$ [Omnivora] ?dietas)    (member$ Omnivora ?dietas)))
  (bind ?has-vegano (or (member$ [Vegano] ?dietas)      (member$ Vegano ?dietas)))
  (bind ?has-vegt   (or (member$ [Vegetariano] ?dietas) (member$ Vegetariano ?dietas)))
  (bind ?has-halal  (or (member$ [Halal] ?dietas)       (member$ Halal ?dietas)))

  ;; === NORMALIZACIONES A NOMBRE (instance-name o símbolo) ===
  (bind ?dispN (create$))
  (progn$ (?x ?ingDisponibles)
    (bind ?dispN (create$ ?dispN
                 (string-to-field (str-cat (if (instance-addressp ?x) then (instance-name ?x)
                                         else (if (instance-namep ?x) then ?x else ?x)))))))
  (bind ?prohN (create$))
  (progn$ (?x ?ingredientes_prohibidos)
    (bind ?prohN (create$ ?prohN
                 (string-to-field (str-cat (if (instance-addressp ?x) then (instance-name ?x)
                                         else (if (instance-namep ?x) then ?x else ?x)))))))
  (bind ?alerN (create$))
  (progn$ (?x ?alergenos_no)
    (bind ?alerN (create$ ?alerN
                 (string-to-field (str-cat (if (instance-addressp ?x) then (instance-name ?x)
                                         else (if (instance-namep ?x) then ?x else ?x)))))))

  (do-for-all-instances ((?b Bebida)) TRUE
    (bind ?nombreB (instance-name ?b))
    (bind ?claseB  (class ?b))
    (bind ?supers  (create$ ?claseB (class-superclasses ?claseB inherit)))

    ;; --- Detectar tipo de bebida (con/sin alcohol) ---
    (bind ?esConAlcohol
          (or (member$ Con_alcohol ?supers)
              (and (class-existp BEBIDAS::Con_alcohol)
                   (member$ BEBIDAS::Con_alcohol ?supers))))
    (bind ?esSinAlcohol
          (or (member$ Sin_alcohol ?supers)
              (and (class-existp BEBIDAS::Sin_alcohol)
                   (member$ BEBIDAS::Sin_alcohol ?supers))))

    ;; --- INGREDIENTES DE LA BEBIDA → nombres normalizados ---
    (bind ?ingsB (create$))
    (if (slot-existp ?claseB usa_ingrediente inherit)
      then
        (foreach ?inst (send ?b get-usa_ingrediente)
          (bind ?ingsB (create$ ?ingsB (string-to-field (str-cat (instance-name ?inst))))))
      else
        (if (slot-existp ?claseB ingredientes inherit)
          then
            (progn$ (?it (send ?b get-ingredientes))
              (bind ?ingsB (create$ ?ingsB
                          (string-to-field (str-cat (if (instance-addressp ?it) then (instance-name ?it)
                                                  else (if (instance-namep ?it) then ?it else ?it)))))))
          else
            (if (slot-existp ?claseB contiene inherit)
              then
                (progn$ (?it (send ?b get-contiene))
                  (bind ?ingsB (create$ ?ingsB (string-to-field (str-cat (instance-name ?it))))))
              else
                (bind ?ingsB (create$))
            )))

    ;; --- ALÉRGENOS DE LA BEBIDA → nombres normalizados ---
    (bind ?alergB (create$))
    (if (slot-existp ?claseB contiene_alergenos inherit)
      then
        (progn$ (?a (send ?b get-contiene_alergenos))
          (bind ?alergB (create$ ?alergB
                       (string-to-field (str-cat (if (instance-addressp ?a) then (instance-name ?a)
                                               else (if (instance-namep ?a) then ?a else ?a)))))))
      else
        (if (slot-existp ?claseB alergenos inherit)
          then
            (progn$ (?a (send ?b get-alergenos))
              (bind ?alergB (create$ ?alergB
                           (string-to-field (str-cat (if (instance-addressp ?a) then (instance-name ?a)
                                                   else (if (instance-namep ?a) then ?a else ?a)))))))
          else
            (if (slot-existp ?claseB alergenos_presentes inherit)
              then
                (progn$ (?a (send ?b get-alergenos_presentes))
                  (bind ?alergB (create$ ?alergB
                               (string-to-field (str-cat (if (instance-addressp ?a) then (instance-name ?a)
                                                       else (if (instance-namep ?a) then ?a else ?a)))))))
              else
                (bind ?alergB (create$))
            )))

    ;; --- COMPROBACIONES ---
    ;; Ingredientes fuera de temporada/listado disponibles
    (bind ?faltan FALSE)
    (progn$ (?i ?ingsB)
      (if (not (member$ ?i ?dispN)) then (bind ?faltan TRUE)))

    ;; Ingredientes prohibidos por el usuario/evento
    (bind ?tieneProhibido FALSE)
    (progn$ (?p ?prohN)
      (if (member$ ?p ?ingsB) then (bind ?tieneProhibido TRUE)))

    ;; Alérgenos vetados por el usuario/evento
    (bind ?tieneAlergeno FALSE)
    (progn$ (?ua ?alerN)
      (if (member$ ?ua ?alergB) then (bind ?tieneAlergeno TRUE)))

    ;; --- DESCARTE / AÑADIR SEGÚN DIETA ---
    (if (not (or ?faltan ?tieneProhibido ?tieneAlergeno))
      then
        (bind ?apta (send ?b get-es_apta_para))
        (bind ?apta-omn    (or (member$ [Omnivora] ?apta)    (member$ Omnivora ?apta)))
        (bind ?apta-vegano (or (member$ [Vegano] ?apta)      (member$ Vegano ?apta)))
        (bind ?apta-vegt   (or (member$ [Vegetariano] ?apta) (member$ Vegetariano ?apta)))

        (if (and ?has-omn ?apta-omn (or ?permiteAlcohol ?esSinAlcohol))
          then (bind ?b_omn (create$ ?b_omn (instance-name ?b))))

        (if (and ?has-vegano ?apta-vegano (or ?permiteAlcohol ?esSinAlcohol))
          then (bind ?b_vegano (create$ ?b_vegano (instance-name ?b))))

        (if (and ?has-vegt ?apta-vegt (or ?permiteAlcohol ?esSinAlcohol))
          then (bind ?b_vegt (create$ ?b_vegt (instance-name ?b))))

        ;; Halal: solo sin alcohol
        (if (and ?has-halal ?esSinAlcohol)
          then (bind ?b_halal (create$ ?b_halal (instance-name ?b))))
    )
  )

  ;; --- GUARDAR RESULTADOS ---
  (modify ?comp
    (bebidas_omnivoras     ?b_omn)
    (bebidas_veganas       ?b_vegano)
    (bebidas_vegetarianas  ?b_vegt)
    (bebidas_halal         ?b_halal))

  ;; --- RESUMEN FINAL ---
  (printout t crlf "--- BEBIDAS DISPONIBLES ---" crlf)
  (printout t "Omnivoras   (" (length$ ?b_omn)    "): " ?b_omn crlf)
  (printout t "Veganas     (" (length$ ?b_vegano) "): " ?b_vegano crlf)
  (printout t "Vegetarianas(" (length$ ?b_vegt)   "): " ?b_vegt crlf)
  (printout t "Halal       (" (length$ ?b_halal)  "): " ?b_halal crlf)
  (printout t "-------------------------" crlf)

  (if (eq ?tipo Congreso)
    then (modify ?ctrl (estado acabado))
    (focus REFINAMIENTO))
)



(defrule ASOCIACION::buscar_pasteles
  (condiciones_evento (tipo Evento_familiar))
  ?e <- (object
          (is-a Evento)
          (dietas $?dietas)
          (tiene_restriccion_estilo ?estilo)
          (prohibe_ingredientes $?ingredientes_prohibidos)
          (sucede_en ?epoca)
          (alergias $?alergenos_no))
  ?c <- (control_asociacion (estado buscando_bebidas))
  ?comp <- (comida_compatible (ingredientes $?ingDisponibles))
  =>
  (modify ?c (estado buscando_pasteles))
  (printout t crlf "=== BUSCANDO PASTELES (solo Evento_familiar) ===" crlf)

  (bind ?past_omnivoros     (create$))
  (bind ?past_veganos       (create$))
  (bind ?past_vegetarianos  (create$))
  (bind ?past_halal         (create$))

  ;; ===== Normalizaciones del EVENTO =====
  (bind ?estiloIsAny (or (eq ?estilo Any) (eq ?estilo AnyEstilo)))

  (bind ?evtEstiloName
    (if (instance-addressp ?estilo) then (instance-name ?estilo)
     else (if (instance-namep ?estilo) then ?estilo else nil)))
  (bind ?evtEstiloSym
    (if (symbolp ?estilo) then ?estilo
     else (if ?evtEstiloName then (instance-name-to-symbol ?evtEstiloName) else nil)))

  (bind ?evtEpocaName
    (if (instance-addressp ?epoca) then (instance-name ?epoca)
     else (if (instance-namep ?epoca) then ?epoca else nil)))
  (bind ?evtEpocaSym
    (if (symbolp ?epoca) then ?epoca
     else (if ?evtEpocaName then (instance-name-to-symbol ?evtEpocaName) else nil)))

  ;; Alergias del evento normalizadas (a instance-name o símbolo)
  (bind ?alergEvento (create$))
  (foreach ?a ?alergenos_no
    (bind ?alergEvento (create$ ?alergEvento
      (string-to-field
        (str-cat (if (instance-addressp ?a) then (instance-name ?a)
                else (if (instance-namep ?a) then ?a else ?a)))))))

  ;; Prohibidos normalizados (pueden ser ingredientes [Instancia] o clases Symbol)
  (bind ?prohibidos (create$))
  (foreach ?x ?ingredientes_prohibidos
    (bind ?prohibidos (create$ ?prohibidos
      (string-to-field
        (str-cat (if (instance-addressp ?x) then (instance-name ?x)
                else (if (instance-namep ?x) then ?x else ?x)))))))

  ;; Ingredientes disponibles del comp normalizados a instance-name/símbolo
  (bind ?dispN (create$))
  (progn$ (?d ?ingDisponibles)
    (bind ?dispN (create$ ?dispN
      (string-to-field (str-cat (if (instance-addressp ?d) then (instance-name ?d)
                               else (if (instance-namep ?d) then ?d else ?d)))))))

  ;; ===== Iterar pasteles =====
  (do-for-all-instances ((?p Pastel)) TRUE
    ;; Estilos del pastel
    (bind ?estilosNames (create$))
    (bind ?estilosSyms  (create$))
    (foreach ?inst (create$ (send ?p get-tiene_estilo))
      (bind ?nm (instance-name ?inst))
      (bind ?estilosNames (create$ ?estilosNames ?nm))
      (bind ?estilosSyms  (create$ ?estilosSyms (instance-name-to-symbol ?nm))))

    ;; Match de estilo (estricto salvo Any)
    (bind ?matchEstilo
      (or
        ?estiloIsAny
        (and ?evtEstiloName (member$ ?evtEstiloName ?estilosNames))
        (and ?evtEstiloSym  (member$ ?evtEstiloSym  ?estilosSyms))))

    (if ?matchEstilo then
      ;; Épocas del pastel
      (bind ?sirveEnNames (create$))
      (bind ?sirveEnSyms  (create$))
      (foreach ?inst (create$ (send ?p get-se_sirve_en))
        (bind ?sirveEnNames (create$ ?sirveEnNames (instance-name ?inst)))
        (bind ?sirveEnSyms  (create$ ?sirveEnSyms (instance-name-to-symbol (instance-name ?inst)))))

      (bind ?matchEpoca
        (or
          (and ?evtEpocaName (member$ ?evtEpocaName ?sirveEnNames))
          (and ?evtEpocaSym  (member$ ?evtEpocaSym  ?sirveEnSyms))
          (= (length$ ?sirveEnNames) 0))) ; si el pastel no define época, se acepta

      (if ?matchEpoca then
        ;; Ingredientes usados del pastel → instance-name/símbolo
        (bind ?usa_ingredientes (create$))
        (foreach ?inst (create$ (send ?p get-usa_ingrediente))
          (bind ?usa_ingredientes (create$ ?usa_ingredientes (string-to-field (str-cat (instance-name ?inst))))))

        ;; Comprobar que no faltan ingredientes fuera de los disponibles/temporada
        (bind ?faltan FALSE)
        (progn$ (?ing ?usa_ingredientes)
          (if (not (member$ ?ing ?dispN)) then (bind ?faltan TRUE)))

        ;; Clases (y superclases) de los ingredientes usados (para prohibidos por clase)
        (bind ?ingClases (create$))
        (foreach ?inst (create$ (send ?p get-usa_ingrediente))
          (bind ?addr ?inst)  ;; ya es instance-address
          (if (neq ?addr nil) then
            (bind ?cls (class ?addr))
            (bind ?ingClases (create$ ?ingClases ?cls))
            (foreach ?sup (class-superclasses ?cls inherit)
              (bind ?ingClases (create$ ?ingClases ?sup)))))

        ;; ---- Veto por PROHIBIDOS (ingrediente exacto o clase)
        (bind ?ok (not ?faltan))
        (if ?ok then
          (foreach ?bad ?prohibidos
            (if (member$ ?bad ?usa_ingredientes) then (bind ?ok FALSE))
            (if (and (symbolp ?bad) (class-existp ?bad) (member$ ?bad ?ingClases)) then (bind ?ok FALSE))))

        ;; ---- Veto por ALERGIAS (comparación por instance-name/símbolo normalizados)
        (if ?ok then
          (bind ?alergPastel (create$))
          (foreach ?al (create$ (send ?p get-contiene_alergenos))
            (bind ?alergPastel (create$ ?alergPastel
              (string-to-field (str-cat (if (instance-addressp ?al) then (instance-name ?al)
                                       else (if (instance-namep ?al) then ?al else ?al)))))))
          (foreach ?ae ?alergEvento
            (if (member$ ?ae ?alergPastel) then (bind ?ok FALSE))))

        (if ?ok then
          ;; Aptitudes del pastel -> instance-name/símbolo
          (bind ?aptNames (create$))
          (foreach ?a (create$ (send ?p get-es_apto_para))
            (bind ?aptNames (create$ ?aptNames (instance-name ?a))))

          ;; Reparto por dietas activas
          (if (and (member$ [Omnivora] ?dietas) (member$ [Omnivora] ?aptNames))
            then (bind ?past_omnivoros (create$ ?past_omnivoros (instance-name ?p))))
          (if (and (member$ [Vegano] ?dietas) (member$ [Vegano] ?aptNames))
            then (bind ?past_veganos (create$ ?past_veganos (instance-name ?p)))
                 (bind ?past_omnivoros (create$ ?past_omnivoros (instance-name ?p)))
                 (bind ?past_vegetarianos (create$ ?past_vegetarianos (instance-name ?p))))
          (if (and (member$ [Vegetariano] ?dietas) (member$ [Vegetariano] ?aptNames))
            then (bind ?past_vegetarianos (create$ ?past_vegetarianos (instance-name ?p)))
                 (bind ?past_omnivoros (create$ ?past_omnivoros (instance-name ?p))))
          (if (and (member$ [Halal] ?dietas) (member$ [Halal] ?aptNames))
            then (bind ?past_halal (create$ ?past_halal (instance-name ?p)))
                 (bind ?past_omnivoros (create$ ?past_omnivoros (instance-name ?p))))
        ))))

  ;; Guardar resultados
  (modify ?comp
    (pasteles_omnivoros     ?past_omnivoros)
    (pasteles_veganos       ?past_veganos)
    (pasteles_vegetarianos  ?past_vegetarianos)
    (pasteles_halal         ?past_halal))

  ;; Mostrar resumen
  (printout t crlf "--- PASTELES COMPATIBLES ---" crlf)
  (printout t "Omnívoros (" (length$ ?past_omnivoros)     "): " ?past_omnivoros crlf)
  (printout t "Veganos   (" (length$ ?past_veganos)       "): " ?past_veganos crlf)
  (printout t "Vegetar.  (" (length$ ?past_vegetarianos)  "): " ?past_vegetarianos crlf)
  (printout t "Halal     (" (length$ ?past_halal)         "): " ?past_halal crlf)
  (printout t "Pasteles compatibles añadidos a comida_compatible." crlf)
  (focus REFINAMIENTO)
)

