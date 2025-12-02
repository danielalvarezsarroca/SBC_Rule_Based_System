;=================================================================================
;================================ REFINAMIENTO ===================================
;=================================================================================
(defmodule REFINAMIENTO
  (import MAIN ?ALL)
  (import RECAP_INFO ?ALL)
  (import ASOCIACION ?ALL)
  (export ?ALL))

(deftemplate control_refinamiento
    (slot estado (type SYMBOL)))

(deftemplate menus_elegidos
  (slot omnivoro (type FLOAT) (default 0.0))
  (slot vegetariano (type FLOAT) (default 0.0))
  (slot vegano (type FLOAT) (default 0.0))
  (slot halal (type FLOAT) (default 0.0))
  (slot pastel (type FLOAT) (default 0.0))
)

(deffunction contiene-tipo (?plato ?clase)
   (bind ?ingredientes (send ?plato get-usa_ingrediente))
   (bind ?contiene FALSE)
   (foreach ?ing ?ingredientes
      (if (eq (class ?ing) ?clase)
         then (bind ?contiene TRUE))
   )
   (return ?contiene)
)

(deffunction marida-con-plato (?bebida ?plato)
   (bind ?tipos-bebida (send ?bebida get-marida_con))
   (bind ?ingredientes (send ?plato get-usa_ingrediente))
   (bind ?ok FALSE)
   (foreach ?ing ?ingredientes
      (bind ?clase (class ?ing))
      (foreach ?t ?tipos-bebida
         (bind ?t-simbolo (str-cat ?t))             ; convierte a string
         (bind ?t-simbolo (string-to-field ?t-simbolo)) ; convierte string a símbolo
         (if (eq ?clase ?t-simbolo) then (bind ?ok TRUE))
      )
   )
   (return ?ok))

(deffunction no-contienen-misma-fruta (?plato1 ?plato2)
   (bind ?ing1 (send ?plato1 get-usa_ingrediente))
   (bind ?ing2 (send ?plato2 get-usa_ingrediente))
   (bind ?ok TRUE)
   (foreach ?i1 ?ing1
      (if (eq (class ?i1) Fruta) then
         (foreach ?i2 ?ing2 
            (if (eq (instance-name ?i1) (instance-name ?i2)) then (bind ?ok FALSE))
         )
      )
   )
   (return ?ok)
)


(defrule REFINAMIENTO::generar-menu-omnivoro
   ?comp <- (comida_compatible
               (primeros_omnivoros $?p_omni)
               (segundos_omnivoros $?s_omni)
               (bebidas_omnivoras $?beb_omni)
               (postres_omnivoros $?post_omni))
   ?cond <- (condiciones_evento
               (presupuesto ?presup)
               (asistentes ?asist)
               (alcohol ?alc))
   ?e <- (object 
                (is-a Evento) 
                (dietas $?dietas))
   (not (control_refinamiento))
   =>
   (assert (menus_elegidos))
   (if (member$ [Omnivora] ?dietas) then
      (printout t crlf "*** Generando menús omnívoros ***" crlf)
      (bind ?dinero_por_menu (/ ?presup ?asist))
      (bind ?precio_del_menu 0.0)
      (bind ?menus_totales (create$))
      (bind ?bebidas_ex (create$))
      (bind ?agua (instance-address [Agua_mineral]))
      (bind ?cola (instance-address [Refresco_cola_seco]))
      (bind ?naranja (instance-address [Refresco_de_naranja]))
      (bind ?limon (instance-address [Refresco_de_limon]))

      (if (> ?dinero_por_menu 50) then
         ; Añadimos Agua_mineral y descontamos su precio
         (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?agua)))
         (bind ?precio_del_menu (+ ?precio_del_menu (send ?agua get-Precio)))
         
         ; Si es mayor a 55 → añadimos Refresco_de_cola si está disponible
         (if (> ?dinero_por_menu 55) then
            (if (member$ (instance-name ?cola) ?beb_omni) then
                  (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?cola)))
                  (bind ?precio_del_menu (+ ?precio_del_menu (send ?cola get-Precio)))
            )

            ; Si es mayor a 60 → añadimos Refresco_de_naranja si está disponible
            (if (> ?dinero_por_menu 60) then
                  (if (member$ (instance-name ?naranja) ?beb_omni) then
                     (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?naranja)))
                     (bind ?precio_del_menu (+ ?precio_del_menu (send ?naranja get-Precio)))
                  )

                  ; Si es mayor a 65 → añadimos otro Refresco_de_limon si está disponible
                  (if (> ?dinero_por_menu 65) then
                     (if (member$ (instance-name ?limon) ?beb_omni) then
                        (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?limon)))
                        (bind ?precio_del_menu (+ ?precio_del_menu (send ?limon get-Precio)))
                     )
                  )
            )
         )
      )

      (foreach ?primero ?p_omni
         (bind ?dinero_primero (+ ?precio_del_menu (send ?primero get-Precio)))
         (foreach ?segundo ?s_omni
            ;--- Restricción: carne/pescado/marisco no se repiten
            (if (not(or
                  (and (or (contiene-tipo ?primero Pescado)
                           (contiene-tipo ?primero Marisco))
                        (or (contiene-tipo ?segundo Pescado)
                           (contiene-tipo ?segundo Marisco)))
                  (and (contiene-tipo ?primero Carne)
                        (contiene-tipo ?segundo Carne))
                  (and (contiene-tipo ?primero Huevos)
                        (contiene-tipo ?segundo Huevos))
                  (and (contiene-tipo ?primero Legumbre)
                        (contiene-tipo ?segundo Legumbre))
                  (no-contienen-misma-fruta ?primero ?segundo)))
               then
                  (bind ?dinero_segundo (+ ?dinero_primero (send ?segundo get-Precio)))
                  (foreach ?bebida_primero ?beb_omni
                     (bind ?dinero_bebida1 (+ ?dinero_segundo (send ?bebida_primero get-Precio)))
                     (if (and (< ?dinero_bebida1 ?dinero_por_menu) 
                              (not (eq (instance-name ?bebida_primero) [Agua_mineral]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_cola_seco]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_de_naranja]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_de_limon]))
                              (or (eq (class ?bebida_primero) Con_alcohol) (eq ?alc no))
                              (marida-con-plato ?bebida_primero ?primero)) then
                           (foreach ?bebida_segundo ?beb_omni
                              (bind ?dinero_bebida2 (+ ?dinero_bebida1 (send ?bebida_segundo get-Precio)))
                              (if (and (< ?dinero_bebida2 ?dinero_por_menu) 
                                       (not (eq (instance-name ?bebida_segundo) [Agua_mineral]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_cola_seco]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_de_naranja]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_de_limon]))
                                       (not (eq (instance-name ?bebida_primero) (instance-name ?bebida_segundo)))
                                       (or (eq (class ?bebida_segundo) Con_alcohol) (eq ?alc no))
                                       (marida-con-plato ?bebida_segundo ?segundo)) then
                                 (foreach ?postre ?post_omni
                                    (bind ?dinero_total (+ ?dinero_bebida2 (send ?postre get-Precio)))
                                    (if (< ?dinero_total ?dinero_por_menu) then
                                       (if (not(or
                                                   (and (contiene-tipo ?primero Pescado)
                                                            (contiene-tipo ?postre Pescado))
                                                   (and (contiene-tipo ?primero Marisco)
                                                            (contiene-tipo ?postre Marisco))
                                                   (and (contiene-tipo ?primero Carne)
                                                         (contiene-tipo ?postre Carne))
                                                   (and (contiene-tipo ?segundo Marisco)
                                                            (contiene-tipo ?postre Marisco))
                                                   (and (contiene-tipo ?segundo Pescado)
                                                            (contiene-tipo ?postre Pescado))
                                                   (and (contiene-tipo ?segundo Carne)
                                                         (contiene-tipo ?postre Carne))
                                                   (and (contiene-tipo ?primero Legumbre)
                                                         (contiene-tipo ?postre Legumbre))
                                                   (and (contiene-tipo ?segundo Legumbre)
                                                         (contiene-tipo ?postre Legumbre))
                                                   (no-contienen-misma-fruta ?primero ?postre)
                                                   (no-contienen-misma-fruta ?segundo ?postre)))
                                                then
                                                   (bind ?nombre-menu
                                                      (string-to-field
                                                         (str-cat "menu_" 
                                                                  (instance-name ?primero) "_" 
                                                                  (instance-name ?segundo) "_"
                                                                  (instance-name ?bebida_primero) "_"
                                                                  (instance-name ?bebida_segundo)
                                                                  (instance-name ?postre))))
                                                   (bind ?menus_totales (create$ ?menus_totales ?nombre-menu))
                                                   (make-instance ?nombre-menu of Menu
                                                         (precio ?dinero_total)
                                                         (tiene_primero ?primero)
                                                         (tiene_bebida_primero ?bebida_primero)
                                                         (tiene_segundo ?segundo)
                                                         (tiene_bebida_segundo ?bebida_segundo)
                                                         (tiene_postre ?postre)
                                                         (bebidas_extras ?bebidas_ex)
                                                         (sigue_dieta Omnivora)
                                          )
                                       )
                                    )
                                 )
                              )
                           )
                     )
                  )   
            )

         
         )
      )
      (if (eq (length$ ?menus_totales) 0) then
         (foreach ?primero ?p_omni
         (bind ?dinero_primero (+ ?precio_del_menu (send ?primero get-Precio)))
         (foreach ?segundo ?s_omni
            ;--- Restricción: carne/pescado/marisco no se repiten
            (if (not(or
                  (and (or (contiene-tipo ?primero Pescado)
                           (contiene-tipo ?primero Marisco))
                        (or (contiene-tipo ?segundo Pescado)
                           (contiene-tipo ?segundo Marisco)))
                  (and (contiene-tipo ?primero Carne)
                        (contiene-tipo ?segundo Carne))))
               then
                  (bind ?dinero_segundo (+ ?dinero_primero (send ?segundo get-Precio)))
                  (foreach ?bebida_primero ?beb_omni
                     (bind ?dinero_bebida1 (+ ?dinero_segundo (send ?bebida_primero get-Precio)))
                     (if (and (< ?dinero_bebida1 ?dinero_por_menu) 
                              (not (eq (instance-name ?bebida_primero) [Agua_mineral]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_cola_seco]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_de_naranja]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_de_limon]))
                              (or (eq (class ?bebida_primero) Con_alcohol) (eq ?alc no))
                              (marida-con-plato ?bebida_primero ?primero)) then
                           (foreach ?bebida_segundo ?beb_omni
                              (bind ?dinero_bebida2 (+ ?dinero_bebida1 (send ?bebida_segundo get-Precio)))
                              (if (and (< ?dinero_bebida2 ?dinero_por_menu) 
                                       (not (eq (instance-name ?bebida_segundo) [Agua_mineral]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_cola_seco]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_de_naranja]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_de_limon]))
                                       (not (eq (instance-name ?bebida_primero) (instance-name ?bebida_segundo)))
                                       (or (eq (class ?bebida_segundo) Con_alcohol) (eq ?alc no))
                                       (marida-con-plato ?bebida_segundo ?segundo)) then
                                 (foreach ?postre ?post_omni
                                    (bind ?dinero_total (+ ?dinero_bebida2 (send ?postre get-Precio)))
                                    (if (< ?dinero_total ?dinero_por_menu) then
                                       (if (not(or
                                                   (and (contiene-tipo ?primero Pescado)
                                                            (contiene-tipo ?postre Pescado))
                                                   (and (contiene-tipo ?primero Marisco)
                                                            (contiene-tipo ?postre Marisco))
                                                   (and (contiene-tipo ?primero Carne)
                                                         (contiene-tipo ?postre Carne))
                                                   (and (contiene-tipo ?segundo Marisco)
                                                            (contiene-tipo ?postre Marisco))
                                                   (and (contiene-tipo ?segundo Pescado)
                                                            (contiene-tipo ?postre Pescado))
                                                   (and (contiene-tipo ?segundo Carne)
                                                         (contiene-tipo ?postre Carne))))
                                                then
                                                   (bind ?nombre-menu
                                                      (string-to-field
                                                         (str-cat "menu_" 
                                                                  (instance-name ?primero) "_" 
                                                                  (instance-name ?segundo) "_"
                                                                  (instance-name ?bebida_primero) "_"
                                                                  (instance-name ?bebida_segundo)
                                                                  (instance-name ?postre))))
                                                   (bind ?menus_totales (create$ ?menus_totales ?nombre-menu))
                                                   (make-instance ?nombre-menu of Menu
                                                         (precio ?dinero_total)
                                                         (tiene_primero ?primero)
                                                         (tiene_bebida_primero ?bebida_primero)
                                                         (tiene_segundo ?segundo)
                                                         (tiene_bebida_segundo ?bebida_segundo)
                                                         (tiene_postre ?postre)
                                                         (bebidas_extras ?bebidas_ex)
                                                         (sigue_dieta Omnivora)
                                          )
                                       )
                                    )
                                 )
                              )
                           )
                     )
                  )   
            )

         
         )
      )

      )

   )
   (assert (control_refinamiento (estado omnivoros_buscados)))
)



(defrule REFINAMIENTO::generar-menu-vegetariano
   ?comp <- (comida_compatible
               (primeros_vegetarianos $?p_veget)
               (segundos_vegetarianos $?s_veget)
               (bebidas_vegetarianas $?beb_veget)
               (postres_vegetarianos $?post_veget))
   ?cond <- (condiciones_evento
               (presupuesto ?presup)
               (asistentes ?asist)
               (alcohol ?alc))
   ?e <- (object 
                (is-a Evento) 
                (dietas $?dietas))
   ?c <- (control_refinamiento (estado omnivoros_buscados))
   =>
   (if (member$ [Vegetariano] ?dietas) then
      (printout t crlf "*** Generando menús vegetarianos ***" crlf)
      (bind ?dinero_por_menu (/ ?presup ?asist))
      (bind ?precio_del_menu 0.0)
      (bind ?menus_totales (create$))
      (bind ?bebidas_ex (create$))
      (bind ?agua (instance-address [Agua_mineral]))
      (bind ?cola (instance-address [Refresco_cola_seco]))
      (bind ?naranja (instance-address [Refresco_de_naranja]))
      (bind ?limon (instance-address [Refresco_de_limon]))

      (if (> ?dinero_por_menu 50) then
         ; Añadimos Agua_mineral y descontamos su precio
         (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?agua)))
         (bind ?precio_del_menu (+ ?precio_del_menu (send ?agua get-Precio)))
         
         ; Si es mayor a 55 → añadimos Refresco_de_cola si está disponible
         (if (> ?dinero_por_menu 55) then
            (if (member$ (instance-name ?cola) ?beb_veget) then
                  (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?cola)))
                  (bind ?precio_del_menu (+ ?precio_del_menu (send ?cola get-Precio)))
            )

            ; Si es mayor a 60 → añadimos Refresco_de_naranja si está disponible
            (if (> ?dinero_por_menu 60) then
                  (if (member$ (instance-name ?naranja) ?beb_veget) then
                     (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?naranja)))
                     (bind ?precio_del_menu (+ ?precio_del_menu (send ?naranja get-Precio)))
                  )

                  ; Si es mayor a 65 → añadimos otro Refresco_de_limon si está disponible
                  (if (> ?dinero_por_menu 65) then
                     (if (member$ (instance-name ?limon) ?beb_veget) then
                        (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?limon)))
                        (bind ?precio_del_menu (+ ?precio_del_menu (send ?limon get-Precio)))
                     )
                  )
            )
         )
      )

      (foreach ?primero ?p_veget
         (bind ?dinero_primero (+ ?precio_del_menu (send ?primero get-Precio)))
         (foreach ?segundo ?s_veget
            ;--- Restricción: carne/pescado/marisco no se repiten
            (if (not (or
                  (and (contiene-tipo ?primero Legumbre)
                        (contiene-tipo ?segundo Legumbre))
                  (no-contienen-misma-fruta ?primero ?segundo)))
               then
                  (bind ?dinero_segundo (+ ?dinero_primero (send ?segundo get-Precio)))
                  (foreach ?bebida_primero ?beb_veget
                     (bind ?dinero_bebida1 (+ ?dinero_segundo (send ?bebida_primero get-Precio)))
                     (if (and (< ?dinero_bebida1 ?dinero_por_menu) 
                              (not (eq (instance-name ?bebida_primero) [Agua_mineral]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_cola_seco]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_de_naranja]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_de_limon]))
                              (or (eq (class ?bebida_primero) Con_alcohol) (eq ?alc no))
                              (marida-con-plato ?bebida_primero ?primero)) then
                           (foreach ?bebida_segundo ?beb_veget
                              (bind ?dinero_bebida2 (+ ?dinero_bebida1 (send ?bebida_segundo get-Precio)))
                              (if (and (< ?dinero_bebida2 ?dinero_por_menu) 
                                       (not (eq (instance-name ?bebida_segundo) [Agua_mineral]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_cola_seco]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_de_naranja]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_de_limon]))
                                       (not (eq (instance-name ?bebida_primero) (instance-name ?bebida_segundo)))
                                       (or (eq (class ?bebida_segundo) Con_alcohol) (eq ?alc no))
                                       (marida-con-plato ?bebida_segundo ?segundo)) then
                                 (foreach ?postre ?post_veget
                                    (bind ?dinero_total (+ ?dinero_bebida2 (send ?postre get-Precio)))
                                    (if (< ?dinero_total ?dinero_por_menu) then
                                       (if (not(or
                                                   (and (contiene-tipo ?primero Legumbre)
                                                         (contiene-tipo ?postre Legumbre))
                                                   (and (contiene-tipo ?segundo Legumbre)
                                                         (contiene-tipo ?postre Legumbre))
                                                   (no-contienen-misma-fruta ?primero ?postre)
                                                   (no-contienen-misma-fruta ?segundo ?postre)))
                                                then
                                                   (bind ?nombre-menu
                                                      (string-to-field
                                                         (str-cat "menu_" 
                                                                  (instance-name ?primero) "_" 
                                                                  (instance-name ?segundo) "_"
                                                                  (instance-name ?bebida_primero) "_"
                                                                  (instance-name ?bebida_segundo)
                                                                  (instance-name ?postre))))
                                                   (bind ?menus_totales (create$ ?menus_totales ?nombre-menu))
                                                   (make-instance ?nombre-menu of Menu
                                                         (precio ?dinero_total)
                                                         (tiene_primero ?primero)
                                                         (tiene_bebida_primero ?bebida_primero)
                                                         (tiene_segundo ?segundo)
                                                         (tiene_bebida_segundo ?bebida_segundo)
                                                         (tiene_postre ?postre)
                                                         (bebidas_extras ?bebidas_ex)
                                                         (sigue_dieta Vegetariano)
                                          )
                                       )
                                    )
                                 )
                              )
                           )
                     )
                  )   
            )

         
         )
      )
      (if (eq (length$ ?menus_totales) 0) then
         
      (foreach ?primero ?p_veget
         (bind ?dinero_primero (+ ?precio_del_menu (send ?primero get-Precio)))
         (foreach ?segundo ?s_veget
            ;--- Restricción: carne/pescado/marisco no se repiten
                  (bind ?dinero_segundo (+ ?dinero_primero (send ?segundo get-Precio)))
                  (foreach ?bebida_primero ?beb_veget
                     (bind ?dinero_bebida1 (+ ?dinero_segundo (send ?bebida_primero get-Precio)))
                     (if (and (< ?dinero_bebida1 ?dinero_por_menu) 
                              (not (eq (instance-name ?bebida_primero) [Agua_mineral]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_cola_seco]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_de_naranja]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_de_limon]))
                              (or (eq (class ?bebida_primero) Con_alcohol) (eq ?alc no))
                              (marida-con-plato ?bebida_primero ?primero)) then
                           (foreach ?bebida_segundo ?beb_veget
                              (bind ?dinero_bebida2 (+ ?dinero_bebida1 (send ?bebida_segundo get-Precio)))
                              (if (and (< ?dinero_bebida2 ?dinero_por_menu) 
                                       (not (eq (instance-name ?bebida_segundo) [Agua_mineral]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_cola_seco]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_de_naranja]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_de_limon]))
                                       (not (eq (instance-name ?bebida_primero) (instance-name ?bebida_segundo)))
                                       (or (eq (class ?bebida_segundo) Con_alcohol) (eq ?alc no))
                                       (marida-con-plato ?bebida_segundo ?segundo)) then
                                 (foreach ?postre ?post_veget
                                    (bind ?dinero_total (+ ?dinero_bebida2 (send ?postre get-Precio)))
                                    (if (< ?dinero_total ?dinero_por_menu) then
                                                   (bind ?nombre-menu
                                                      (string-to-field
                                                         (str-cat "menu_" 
                                                                  (instance-name ?primero) "_" 
                                                                  (instance-name ?segundo) "_"
                                                                  (instance-name ?bebida_primero) "_"
                                                                  (instance-name ?bebida_segundo)
                                                                  (instance-name ?postre))))
                                                   (make-instance ?nombre-menu of Menu
                                                         (precio ?dinero_total)
                                                         (tiene_primero ?primero)
                                                         (tiene_bebida_primero ?bebida_primero)
                                                         (tiene_segundo ?segundo)
                                                         (tiene_bebida_segundo ?bebida_segundo)
                                                         (tiene_postre ?postre)
                                                         (bebidas_extras ?bebidas_ex)
                                                         (sigue_dieta Vegetariano)
                                          
                                       )
                                    )
                                 )
                              )
                           )
                     )
                   
               )
            )
         )
      
      )
   )
   (modify ?c (estado vegetarianos_buscados))
)

(defrule REFINAMIENTO::generar-menu-vegano
   ?comp <- (comida_compatible
               (primeros_veganos $?p_vega)
               (segundos_veganos $?s_vega)
               (bebidas_veganas $?beb_vega)
               (postres_veganos $?post_vega))
   ?cond <- (condiciones_evento
               (presupuesto ?presup)
               (asistentes ?asist)
               (alcohol ?alc))
   ?e <- (object 
                (is-a Evento) 
                (dietas $?dietas))
   ?c <- (control_refinamiento (estado vegetarianos_buscados))
   =>
   (if (member$ [Vegano] ?dietas) then
      (printout t crlf "*** Generando menús veganos ***" crlf)
      (bind ?dinero_por_menu (/ ?presup ?asist))
      (bind ?precio_del_menu 0.0)
      (bind ?bebidas_ex (create$))
      (bind ?agua (instance-address [Agua_mineral]))
      (bind ?cola (instance-address [Refresco_cola_seco]))
      (bind ?naranja (instance-address [Refresco_de_naranja]))
      (bind ?limon (instance-address [Refresco_de_limon]))

      (if (> ?dinero_por_menu 50) then
         ; Añadimos Agua_mineral y descontamos su precio
         (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?agua)))
         (bind ?precio_del_menu (+ ?precio_del_menu (send ?agua get-Precio)))
         
         ; Si es mayor a 55 → añadimos Refresco_de_cola si está disponible
         (if (> ?dinero_por_menu 55) then
            (if (member$ (instance-name ?cola) ?beb_vega) then
                  (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?cola)))
                  (bind ?precio_del_menu (+ ?precio_del_menu (send ?cola get-Precio)))
            )

            ; Si es mayor a 60 → añadimos Refresco_de_naranja si está disponible
            (if (> ?dinero_por_menu 60) then
                  (if (member$ (instance-name ?naranja) ?beb_vega) then
                     (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?naranja)))
                     (bind ?precio_del_menu (+ ?precio_del_menu (send ?naranja get-Precio)))
                  )

                  ; Si es mayor a 65 → añadimos otro Refresco_de_limon si está disponible
                  (if (> ?dinero_por_menu 65) then
                     (if (member$ (instance-name ?limon) ?beb_vega) then
                        (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?limon)))
                        (bind ?precio_del_menu (+ ?precio_del_menu (send ?limon get-Precio)))
                     )
                  )
            )
         )
      )
      
      (foreach ?primero ?p_vega
         (bind ?dinero_primero (+ ?precio_del_menu (send ?primero get-Precio)))
         (foreach ?segundo ?s_vega
            ; Reinicia validez para cada pareja
            (bind ?dinero_segundo (+ ?dinero_primero (send ?segundo get-Precio)))
            (foreach ?bebida_primero ?beb_vega
               (bind ?dinero_bebida1 (+ ?dinero_segundo (send ?bebida_primero get-Precio)))
               (if (and (< ?dinero_bebida1 ?dinero_por_menu) 
                        (not (eq (instance-name ?bebida_primero) [Agua_mineral]))
                        (not (eq (instance-name ?bebida_primero) [Refresco_cola_seco]))
                        (not (eq (instance-name ?bebida_primero) [Refresco_de_naranja]))
                        (not (eq (instance-name ?bebida_primero) [Refresco_de_limon]))
                        (or (eq (class ?bebida_primero) Con_alcohol) (eq ?alc no))
                        (marida-con-plato ?bebida_primero ?primero)) then
                     (foreach ?bebida_segundo ?beb_vega
                        (bind ?dinero_bebida2 (+ ?dinero_bebida1 (send ?bebida_segundo get-Precio)))
                        (if (and (< ?dinero_bebida2 ?dinero_por_menu) 
                                 (not (eq (instance-name ?bebida_segundo) [Agua_mineral]))
                                 (not (eq (instance-name ?bebida_segundo) [Refresco_cola_seco]))
                                 (not (eq (instance-name ?bebida_segundo) [Refresco_de_naranja]))
                                 (not (eq (instance-name ?bebida_segundo) [Refresco_de_limon]))
                                 (not (eq (instance-name ?bebida_primero) (instance-name ?bebida_segundo)))
                                 (or (eq (class ?bebida_primero) Con_alcohol) (eq ?alc no))
                                 (marida-con-plato ?bebida_segundo ?segundo)) then
                           (foreach ?postre ?post_vega
                              (bind ?dinero_total (+ ?dinero_bebida2 (send ?postre get-Precio)))
                              (if (< ?dinero_total ?dinero_por_menu) then
                                 then
                                    (bind ?nombre-menu
                                       (string-to-field
                                          (str-cat "menu_" 
                                                   (instance-name ?primero) "_" 
                                                   (instance-name ?segundo) "_"
                                                   (instance-name ?bebida_primero) "_"
                                                   (instance-name ?bebida_segundo)
                                                   (instance-name ?postre))))
                                    (make-instance ?nombre-menu of Menu
                                          (precio ?dinero_total)
                                          (tiene_primero ?primero)
                                          (tiene_bebida_primero ?bebida_primero)
                                          (tiene_segundo ?segundo)
                                          (tiene_bebida_segundo ?bebida_segundo)
                                          (tiene_postre ?postre)
                                          (bebidas_extras ?bebidas_ex)
                                          (sigue_dieta Vegano))
                              )
                           )
                        )
                     )
               )
            )   
         )
      )
      
   )
   (modify ?c (estado veganos_buscados))
)


(defrule REFINAMIENTO::generar-menu-halal
   ?comp <- (comida_compatible
               (primeros_halal $?p_hal)
               (segundos_halal $?s_hal)
               (bebidas_halal $?beb_hal)
               (postres_halal $?post_hal))
   ?cond <- (condiciones_evento
               (presupuesto ?presup)
               (asistentes ?asist))
   ?e <- (object 
                (is-a Evento) 
                (dietas $?dietas))
   ?c <- (control_refinamiento (estado veganos_buscados))
   =>
   (if (member$ [Halal] ?dietas) then
      (printout t crlf "*** Generando menús halal ***" crlf)
      (bind ?dinero_por_menu (/ ?presup ?asist))
      (bind ?precio_del_menu 0.0)
      (bind ?bebidas_ex (create$))
      (bind ?menus_totales (create$))
      (bind ?agua (instance-address [Agua_mineral]))
      (bind ?cola (instance-address [Refresco_cola_seco]))
      (bind ?naranja (instance-address [Refresco_de_naranja]))
      (bind ?limon (instance-address [Refresco_de_limon]))

      (if (> ?dinero_por_menu 50) then
         ; Añadimos Agua_mineral y descontamos su precio
         (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?agua)))
         (bind ?precio_del_menu (+ ?precio_del_menu (send ?agua get-Precio)))
         
         ; Si es mayor a 55 → añadimos Refresco_de_cola si está disponible
         (if (> ?dinero_por_menu 55) then
            (if (member$ (instance-name ?cola) ?beb_hal) then
                  (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?cola)))
                  (bind ?precio_del_menu (+ ?precio_del_menu (send ?cola get-Precio)))
            )

            ; Si es mayor a 60 → añadimos Refresco_de_naranja si está disponible
            (if (> ?dinero_por_menu 60) then
                  (if (member$ (instance-name ?naranja) ?beb_hal) then
                     (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?naranja)))
                     (bind ?precio_del_menu (+ ?precio_del_menu (send ?naranja get-Precio)))
                  )

                  ; Si es mayor a 65 → añadimos otro Refresco_de_limon si está disponible
                  (if (> ?dinero_por_menu 65) then
                     (if (member$ (instance-name ?limon) ?beb_hal) then
                        (bind ?bebidas_ex (create$ ?bebidas_ex (instance-name ?limon)))
                        (bind ?precio_del_menu (+ ?precio_del_menu (send ?limon get-Precio)))
                     )
                  )
            )
         )
      )

      (foreach ?primero ?p_hal
         (bind ?dinero_primero (+ ?precio_del_menu (send ?primero get-Precio)))
         (foreach ?segundo ?s_hal
            ;--- Restricción: carne/pescado/marisco no se repiten
            (if (not (or
                  (and (or (contiene-tipo ?primero Pescado)
                           (contiene-tipo ?primero Marisco))
                        (or (contiene-tipo ?segundo Pescado)
                           (contiene-tipo ?segundo Marisco)))
                  (and (contiene-tipo ?primero Carne)
                        (contiene-tipo ?segundo Carne))
                  (no-contienen-misma-fruta ?primero ?segundo)))
               then
                  (bind ?dinero_segundo (+ ?dinero_primero (send ?segundo get-Precio)))
                  (foreach ?bebida_primero ?beb_hal
                     (bind ?dinero_bebida1 (+ ?dinero_segundo (send ?bebida_primero get-Precio)))
                     (if (and (< ?dinero_bebida1 ?dinero_por_menu) 
                              (not (eq (instance-name ?bebida_primero) [Agua_mineral]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_cola_seco]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_de_naranja]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_de_limon]))
                              (marida-con-plato ?bebida_primero ?primero)) then
                           (foreach ?bebida_segundo ?beb_hal
                              (bind ?dinero_bebida2 (+ ?dinero_bebida1 (send ?bebida_segundo get-Precio)))
                              (if (and (< ?dinero_bebida2 ?dinero_por_menu) 
                                       (not (eq (instance-name ?bebida_segundo) [Agua_mineral]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_cola_seco]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_de_naranja]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_de_limon]))
                                       (not (eq (instance-name ?bebida_primero) (instance-name ?bebida_segundo)))
                                       (marida-con-plato ?bebida_segundo ?segundo)) then
                                 (foreach ?postre ?post_hal
                                    (bind ?dinero_total (+ ?dinero_bebida2 (send ?postre get-Precio)))
                                    (if (< ?dinero_total ?dinero_por_menu) then
                                       (if (not(or
                                                   (and (contiene-tipo ?primero Pescado)
                                                            (contiene-tipo ?postre Pescado))
                                                   (and (contiene-tipo ?primero Marisco)
                                                            (contiene-tipo ?postre Marisco))
                                                   (and (contiene-tipo ?primero Carne)
                                                         (contiene-tipo ?postre Carne))
                                                   (and (contiene-tipo ?segundo Marisco)
                                                            (contiene-tipo ?postre Marisco))
                                                   (and (contiene-tipo ?segundo Pescado)
                                                            (contiene-tipo ?postre Pescado))
                                                   (and (contiene-tipo ?segundo Carne)
                                                         (contiene-tipo ?postre Carne))
                                                   (no-contienen-misma-fruta ?primero ?postre)
                                                   (no-contienen-misma-fruta ?segundo ?postre)))
                                                then
                                                   (bind ?nombre-menu
                                                      (string-to-field
                                                            (str-cat "menu_" 
                                                                     (instance-name ?primero) "_" 
                                                                     (instance-name ?segundo) "_"
                                                                     (instance-name ?bebida_primero) "_"
                                                                     (instance-name ?bebida_segundo)
                                                                     (instance-name ?postre))))
                                                   (bind ?menus_totales (create$ ?menus_totales ?nombre-menu))
                                                   (make-instance ?nombre-menu of Menu
                                                         (precio ?dinero_total)
                                                         (tiene_primero ?primero)
                                                         (tiene_bebida_primero ?bebida_primero)
                                                         (tiene_segundo ?segundo)
                                                         (tiene_bebida_segundo ?bebida_segundo)
                                                         (tiene_postre ?postre)
                                                         (bebidas_extras ?bebidas_ex)
                                                         (sigue_dieta Halal))
                                          
                                       )
                                    )
                                 )
                              )
                           )
                     )
                  )   
            )

         
         )
      )
      (if (eq (length$ ?menus_totales) 0) then
      (foreach ?primero ?p_hal
         (bind ?dinero_primero (+ ?precio_del_menu (send ?primero get-Precio)))
         (foreach ?segundo ?s_hal
            ;--- Restricción: carne/pescado/marisco no se repiten
            (if (not (or
                  (and (or (contiene-tipo ?primero Pescado)
                           (contiene-tipo ?primero Marisco))
                        (or (contiene-tipo ?segundo Pescado)
                           (contiene-tipo ?segundo Marisco)))
                  (and (contiene-tipo ?primero Carne)
                        (contiene-tipo ?segundo Carne))))
               then
                  (bind ?dinero_segundo (+ ?dinero_primero (send ?segundo get-Precio)))
                  (foreach ?bebida_primero ?beb_hal
                     (bind ?dinero_bebida1 (+ ?dinero_segundo (send ?bebida_primero get-Precio)))
                     (if (and (< ?dinero_bebida1 ?dinero_por_menu) 
                              (not (eq (instance-name ?bebida_primero) [Agua_mineral]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_cola_seco]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_de_naranja]))
                              (not (eq (instance-name ?bebida_primero) [Refresco_de_limon]))
                              (marida-con-plato ?bebida_primero ?primero)) then
                           (foreach ?bebida_segundo ?beb_hal
                              (bind ?dinero_bebida2 (+ ?dinero_bebida1 (send ?bebida_segundo get-Precio)))
                              (if (and (< ?dinero_bebida2 ?dinero_por_menu) 
                                       (not (eq (instance-name ?bebida_segundo) [Agua_mineral]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_cola_seco]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_de_naranja]))
                                       (not (eq (instance-name ?bebida_segundo) [Refresco_de_limon]))
                                       (not (eq (instance-name ?bebida_primero) (instance-name ?bebida_segundo)))
                                       (marida-con-plato ?bebida_segundo ?segundo)) then
                                 (foreach ?postre ?post_hal
                                    (bind ?dinero_total (+ ?dinero_bebida2 (send ?postre get-Precio)))
                                    (if (< ?dinero_total ?dinero_por_menu) then
                                                   (bind ?nombre-menu
                                                      (string-to-field
                                                            (str-cat "menu_" 
                                                                     (instance-name ?primero) "_" 
                                                                     (instance-name ?segundo) "_"
                                                                     (instance-name ?bebida_primero) "_"
                                                                     (instance-name ?bebida_segundo)
                                                                     (instance-name ?postre))))
                                                   (bind ?menus_totales (create$ ?menus_totales ?nombre-menu))
                                                   (make-instance ?nombre-menu of Menu
                                                         (precio ?dinero_total)
                                                         (tiene_primero ?primero)
                                                         (tiene_bebida_primero ?bebida_primero)
                                                         (tiene_segundo ?segundo)
                                                         (tiene_bebida_segundo ?bebida_segundo)
                                                         (tiene_postre ?postre)
                                                         (bebidas_extras ?bebidas_ex)
                                                         (sigue_dieta Halal))
                                          
                                       
                                    )
                                 )
                              )
                           )
                     )
                  )   
            )

         
         )
      )
      )
   )
   (modify ?c (estado halal_buscados))
)


(defrule REFINAMIENTO::escoger-menu-caro_omn
   ?ctrl <- (control_refinamiento (estado halal_buscados))
   ?e <- (object 
            (is-a Evento) 
            (dietas $?dietas))
   =>
   (modify ?ctrl (estado menu_caro_omnivoro))
   (if (member$ [Omnivora] ?dietas) then
      (bind ?todos (find-all-instances ((?m Menu)) TRUE))
      (bind ?maximo -1)
      (bind ?menu_caro nil)
      (foreach ?m ?todos
         (if (and (eq (send ?m get-sigue_dieta) Omnivora) (> (send ?m get-precio) ?maximo)) then
            (bind ?maximo (send ?m get-precio))
            (bind ?menu_caro ?m)))
      (if (eq ?maximo -1)
         then
         (printout t crlf "---- No se han encontrado menús omnívoros que cumplan todas las restricciones. ----" crlf)
         (modify ?ctrl (estado menu_omnivoro_completado))
         
         else
         (printout t crlf "---- OPCIONES DE MENÚS OMNÍVOROS ----" crlf)
         (printout t crlf "-- CARO " crlf
                        "   Primero: " (instance-name (send ?menu_caro get-tiene_primero)) crlf
                        "   Bebida para el primero: " (instance-name (send ?menu_caro get-tiene_bebida_primero)) crlf
                        "   Segundo: " (instance-name (send ?menu_caro get-tiene_segundo)) crlf
                        "   Bebida para el segundo: " (instance-name (send ?menu_caro get-tiene_bebida_segundo)) crlf
                        "   Postre: " (instance-name (send ?menu_caro get-tiene_postre)) crlf
                        "   Bebidas extras:" (send ?menu_caro get-bebidas_extras) crlf
                        "   Precio por persona: " (send ?menu_caro get-precio) crlf)
         (bind ?menus (create$))
         (bind ?menus (create$ ?menus (instance-name ?menu_caro)))
         (send ?menu_caro put-tipo_segun_precio caro)
         (send ?e put-menus_omnivoros ?menus)
      )
   )

)

(defrule REFINAMIENTO::escoger-menu-medio_omn
   ?ctrl <- (control_refinamiento (estado menu_caro_omnivoro))
   ?e <- (object (is-a Evento) (dietas $?dietas) (menus_omnivoros $?menus_omnivoros))
   =>
   (modify ?ctrl (estado menu_medio_omnivoro))
   (if (member$ [Omnivora] ?dietas) then
      (bind ?todos (find-all-instances ((?m Menu)) TRUE))
      (foreach ?men ?todos
         (if (and (eq caro (send ?men get-tipo_segun_precio)) (eq Omnivora (send ?men get-sigue_dieta))) then
            (bind ?menu_caro ?men)
            (bind ?primero_caro (send ?menu_caro get-tiene_primero))
            (bind ?segundo_caro (send ?menu_caro get-tiene_segundo))
            (bind ?postre_caro (send ?menu_caro get-tiene_postre))
            (bind ?maximo (send ?menu_caro get-precio))
         )
      )
      (bind ?maximo (send ?menu_caro get-precio))

      ;; 2) Precio objetivo = 90% del caro
      (bind ?objetivo (* 0.90 ?maximo))

      ;; 3) Buscar el mejor menú "medio":
      ;;    - Omnívoro
      ;;    - Precio <= objetivo (lo más caro posible sin pasar del objetivo)
      ;;    - Sin platos repetidos (primero, segundo, postre distintos)
      (bind ?menu_medio nil)
      (bind ?precio_medio -1)
      (foreach ?candidato ?todos
         (if (eq (send ?candidato get-sigue_dieta) Omnivora) then
            (bind ?p (send ?candidato get-precio))
            (bind ?pr (send ?candidato get-tiene_primero))
            (bind ?sg (send ?candidato get-tiene_segundo))
            (bind ?po (send ?candidato get-tiene_postre))
            (bind ?prn (instance-name ?pr))
            (bind ?sgn (instance-name ?sg))
            (bind ?pon (instance-name ?po))
            (if (and (<= ?p ?objetivo)
                     (neq ?candidato ?menu_caro)
                     (neq ?prn (instance-name ?primero_caro)) (neq ?sgn (instance-name ?segundo_caro)) (neq ?pon (instance-name ?postre_caro)))
                then
                (if (> ?p ?precio_medio) then
                   (bind ?precio_medio ?p)
                   (bind ?menu_medio ?candidato)))))


      (if (neq ?menu_medio nil) then
         ;; 6) Salida y almacenamiento
         (printout t crlf "-- MEDIO " crlf
                        "   Primero: " (instance-name (send ?menu_medio get-tiene_primero)) crlf
                        "   Bebida para el primero: " (instance-name (send ?menu_medio get-tiene_bebida_primero)) crlf
                        "   Segundo: " (instance-name (send ?menu_medio get-tiene_segundo)) crlf
                        "   Bebida para el segundo: " (instance-name (send ?menu_medio get-tiene_bebida_segundo)) crlf
                        "   Postre: " (instance-name (send ?menu_medio get-tiene_postre)) crlf
                        "   Bebidas extras: " (send ?menu_medio get-bebidas_extras) crlf
                        "   Precio por persona: " (send ?menu_medio get-precio) crlf)

         (bind ?menus (create$ ?menus_omnivoros (instance-name ?menu_medio)))
         (send ?menu_medio put-tipo_segun_precio medio)
         (send ?e put-menus_omnivoros ?menus)

         else
            (printout t crlf "No se han encontrado menus más baratos." crlf)
            (modify ?ctrl (estado menu_barato_omnivoro))
      )
   )
)

(defrule REFINAMIENTO::escoger-menu-barato_omn
   ?ctrl <- (control_refinamiento (estado menu_medio_omnivoro))
   ?e <- (object (is-a Evento) (dietas $?dietas) (menus_omnivoros $?menus_omnivoros))

   =>
   (modify ?ctrl (estado menu_barato_omnivoro))
   (if (member$ [Omnivora] ?dietas) then
      (bind ?todos (find-all-instances ((?m Menu)) TRUE))
      (foreach ?men ?todos
         (if (and (eq medio (send ?men get-tipo_segun_precio)) (eq Omnivora (send ?men get-sigue_dieta))) then
            (bind ?menu_medio ?men)
            (bind ?primero_caro (send ?menu_medio get-tiene_primero))
            (bind ?segundo_caro (send ?menu_medio get-tiene_segundo))
            (bind ?postre_caro (send ?menu_medio get-tiene_postre))
            (bind ?maximo (send ?menu_medio get-precio))
         )
      )

      ;; 2) Precio objetivo = 90% del caro
      (bind ?objetivo (* 0.90 ?maximo))

      ;; 3) Buscar el mejor menú "medio":
      ;;    - Omnívoro
      ;;    - Precio <= objetivo (lo más caro posible sin pasar del objetivo)
      ;;    - Sin platos repetidos (primero, segundo, postre distintos)
      (bind ?menu_barato nil)
      (bind ?precio_barato -1)
      (foreach ?candidato ?todos
         (if (eq (send ?candidato get-sigue_dieta) Omnivora) then
            (bind ?p (send ?candidato get-precio))
            (bind ?pr (send ?candidato get-tiene_primero))
            (bind ?sg (send ?candidato get-tiene_segundo))
            (bind ?po (send ?candidato get-tiene_postre))
            (bind ?prn (instance-name ?pr))
            (bind ?sgn (instance-name ?sg))
            (bind ?pon (instance-name ?po))
            (if (and (<= ?p ?objetivo)
                     (neq ?candidato ?menu_medio)
                     (neq ?prn (instance-name ?primero_caro)) (neq ?sgn (instance-name ?segundo_caro)) (neq ?pon (instance-name ?postre_caro)))
                then
                (if (> ?p ?precio_barato) then
                   (bind ?precio_barato ?p)
                   (bind ?menu_barato ?candidato)))))

      (if (neq ?menu_barato nil) then
         (printout t crlf "-- BARATO " crlf
                        "   Primero: " (instance-name (send ?menu_barato get-tiene_primero)) crlf
                        "   Bebida para el primero: " (instance-name (send ?menu_barato get-tiene_bebida_primero)) crlf
                        "   Segundo: " (instance-name (send ?menu_barato get-tiene_segundo)) crlf
                        "   Bebida para el segundo: " (instance-name (send ?menu_barato get-tiene_bebida_segundo)) crlf
                        "   Postre: " (instance-name (send ?menu_barato get-tiene_postre)) crlf
                        "   Bebidas extras: " (send ?menu_barato get-bebidas_extras) crlf
                        "   Precio por persona: " (send ?menu_barato get-precio) crlf)

         (bind ?menus (create$ ?menus_omnivoros (instance-name ?menu_barato)))
         (send ?menu_barato put-tipo_segun_precio barato)
         (send ?e put-menus_omnivoros ?menus)

         else
            (printout t crlf "No se han encontrado menus más baratos." crlf)

      )
   )
)

(defrule REFINAMIENTO::preguntar-menu_omnivoro
   ?e <- (object (is-a Evento) (dietas $?dietas) (menus_omnivoros $?menus_omnivoros))
   ?c <- (control_refinamiento (estado menu_barato_omnivoro))
   ?menus <- (menus_elegidos)
   =>
   (modify ?c (estado menu_omnivoro_completado))
   (if (member$ [Omnivora] ?dietas) then
   (bind ?valido FALSE)
   (bind ?precio 0.0)
   (while (eq ?valido FALSE)
      (printout t "¿Qué tipo de menú quieres? (caro, medio, barato) " crlf)
      (bind ?resp (read))
      (if (or (eq ?resp caro) (eq ?resp medio) (eq ?resp barato))
         then
            (foreach ?m ?menus_omnivoros
               (if (eq (send ?m get-tipo_segun_precio) ?resp)
               then
                  (bind ?precio (send ?m get-precio))
               )
            )
            (if (> ?precio 0.0) then
               (modify ?menus (omnivoro ?precio))
               (bind ?valido TRUE)
               (printout t crlf)
            else
               (printout t "Respuesta incorrecta. No hay ese tipo de menú." crlf)
            )
         else
            (printout t "Respuesta incorrecta. Debe ser caro, medio, barato." crlf)
      )
   )
   )

   
)

(defrule REFINAMIENTO::escoger-menu-caro_vegetariano
   ?ctrl <- (control_refinamiento (estado menu_omnivoro_completado))
   ?e <- (object 
            (is-a Evento) 
            (dietas $?dietas))
   =>
   (modify ?ctrl (estado menu_caro_vegetariano))
   (if (member$ [Vegetariano] ?dietas) then
      (bind ?todos (find-all-instances ((?m Menu)) TRUE))
      (bind ?maximo -1)
      (bind ?menu_caro nil)
      (foreach ?m ?todos
         (if (and (eq (send ?m get-sigue_dieta) Vegetariano) (> (send ?m get-precio) ?maximo)) then
            (bind ?maximo (send ?m get-precio))
            (bind ?menu_caro ?m)))
      (if (eq ?maximo -1)
         then
         (printout t crlf "---- No se han encontrado menús vegetarianos que cumplan todas las restricciones. ----" crlf)
         (modify ?ctrl (estado menu_vegetariano_completado))
         
         else
         (printout t crlf "---- OPCIONES DE MENÚS VEGETARIANOS ----" crlf)
         (printout t crlf "-- CARO " crlf
                        "   Primero: " (instance-name (send ?menu_caro get-tiene_primero)) crlf
                        "   Bebida para el primero: " (instance-name (send ?menu_caro get-tiene_bebida_primero)) crlf
                        "   Segundo: " (instance-name (send ?menu_caro get-tiene_segundo)) crlf
                        "   Bebida para el segundo: " (instance-name (send ?menu_caro get-tiene_bebida_segundo)) crlf
                        "   Postre: " (instance-name (send ?menu_caro get-tiene_postre)) crlf
                        "   Bebidas extras:" (send ?menu_caro get-bebidas_extras) crlf
                        "   Precio por persona: " (send ?menu_caro get-precio) crlf)
         (bind ?menus (create$))
         (bind ?menus (create$ ?menus (instance-name ?menu_caro)))
         (send ?menu_caro put-tipo_segun_precio caro)
         (send ?e put-menus_vegetarianos ?menus)
      )
   )

)

(defrule REFINAMIENTO::escoger_menu_medio_vegetariano
   ?ctrl <- (control_refinamiento (estado menu_caro_vegetariano))
   ?e <- (object (is-a Evento) (dietas $?dietas) (menus_vegetarianos $?menus_vegetarianos))
   =>
   (modify ?ctrl (estado menu_medio_vegetariano))
   (if (member$ [Vegetariano] ?dietas) then
      (bind ?todos (find-all-instances ((?m Menu)) TRUE))
      (foreach ?men ?todos
         (if (and (eq caro (send ?men get-tipo_segun_precio)) (eq Vegetariano (send ?men get-sigue_dieta))) then
            (bind ?menu_caro ?men)
            (bind ?primero_caro (send ?menu_caro get-tiene_primero))
            (bind ?segundo_caro (send ?menu_caro get-tiene_segundo))
            (bind ?postre_caro (send ?menu_caro get-tiene_postre))
            (bind ?maximo (send ?menu_caro get-precio))
         )
      )

      ;; 2) Precio objetivo = 90% del caro
      (bind ?objetivo (* 0.90 ?maximo))

      ;; 3) Buscar el mejor menú "medio":
      ;;    - Omnívoro
      ;;    - Precio <= objetivo (lo más caro posible sin pasar del objetivo)
      ;;    - Sin platos repetidos (primero, segundo, postre distintos)
      (bind ?menu_medio nil)
      (bind ?precio_medio -1)
      (foreach ?candidato ?todos
         (if (eq (send ?candidato get-sigue_dieta) Vegetariano) then
            (bind ?p (send ?candidato get-precio))
            (bind ?pr (send ?candidato get-tiene_primero))
            (bind ?sg (send ?candidato get-tiene_segundo))
            (bind ?po (send ?candidato get-tiene_postre))
            (bind ?prn (instance-name ?pr))
            (bind ?sgn (instance-name ?sg))
            (bind ?pon (instance-name ?po))
            (if (and (<= ?p ?objetivo)
                     (neq ?candidato ?menu_caro)
                     (neq ?prn (instance-name ?primero_caro)) (neq ?sgn (instance-name ?segundo_caro)) (neq ?pon (instance-name ?postre_caro)))
                then
                (if (> ?p ?precio_medio) then
                   (bind ?precio_medio ?p)
                   (bind ?menu_medio ?candidato)))))

      (if (neq ?menu_medio nil) then
         (printout t crlf "-- MEDIO " crlf
                        "   Primero: " (instance-name (send ?menu_medio get-tiene_primero)) crlf
                        "   Bebida para el primero: " (instance-name (send ?menu_medio get-tiene_bebida_primero)) crlf
                        "   Segundo: " (instance-name (send ?menu_medio get-tiene_segundo)) crlf
                        "   Bebida para el segundo: " (instance-name (send ?menu_medio get-tiene_bebida_segundo)) crlf
                        "   Postre: " (instance-name (send ?menu_medio get-tiene_postre)) crlf
                        "   Bebidas extras: " (send ?menu_medio get-bebidas_extras) crlf
                        "   Precio por persona: " (send ?menu_medio get-precio) crlf)

         (bind ?menus (create$ ?menus_vegetarianos (instance-name ?menu_medio)))
         (send ?menu_medio put-tipo_segun_precio medio)
         (send ?e put-menus_vegetarianos ?menus)
      else
         (printout t crlf "No se han encontrado menus más baratos." crlf)
         (modify ?ctrl (estado menu_barato_vegetariano))

      )
   )
)

(defrule REFINAMIENTO::escoger-menu-barato_vegetariano
   ?ctrl <- (control_refinamiento (estado menu_medio_vegetariano))
   ?e <- (object (is-a Evento) (dietas $?dietas) (menus_vegetarianos $?menus_vegetarianos))

   =>
   (modify ?ctrl (estado menu_barato_vegetariano))
   (if (member$ [Vegetariano] ?dietas) then
      (bind ?todos (find-all-instances ((?m Menu)) TRUE))
      (foreach ?men ?todos
         (if (and (eq medio (send ?men get-tipo_segun_precio)) (eq Vegetariano (send ?men get-sigue_dieta))) then
            (bind ?menu_medio ?men)
            (bind ?primero_caro (send ?menu_medio get-tiene_primero))
            (bind ?segundo_caro (send ?menu_medio get-tiene_segundo))
            (bind ?postre_caro (send ?menu_medio get-tiene_postre))
            (bind ?maximo (send ?menu_medio get-precio))
         )
      )

      ;; 2) Precio objetivo = 90% del caro
      (bind ?objetivo (* 0.9 ?maximo))

      ;; 3) Buscar el mejor menú "medio":
      ;;    - Omnívoro
      ;;    - Precio <= objetivo (lo más caro posible sin pasar del objetivo)
      ;;    - Sin platos repetidos (primero, segundo, postre distintos)
      (bind ?menu_barato nil)
      (bind ?precio_barato -1)
      (foreach ?candidato ?todos
         (if (eq (send ?candidato get-sigue_dieta) Vegetariano) then
            (bind ?p (send ?candidato get-precio))
            (bind ?pr (send ?candidato get-tiene_primero))
            (bind ?sg (send ?candidato get-tiene_segundo))
            (bind ?po (send ?candidato get-tiene_postre))
            (bind ?prn (instance-name ?pr))
            (bind ?sgn (instance-name ?sg))
            (bind ?pon (instance-name ?po))
            (if (and (<= ?p ?objetivo)
                     (neq ?candidato ?menu_medio)
                     (neq ?prn (instance-name ?primero_caro)) (neq ?sgn (instance-name ?segundo_caro)) (neq ?pon (instance-name ?postre_caro)))
                then
                (if (> ?p ?precio_barato) then
                   (bind ?precio_barato ?p)
                   (bind ?menu_barato ?candidato)))))

      (if (neq ?menu_barato nil) then         
      (printout t crlf "-- BARATO " crlf
                     "   Primero: " (instance-name (send ?menu_barato get-tiene_primero)) crlf
                     "   Bebida para el primero: " (instance-name (send ?menu_barato get-tiene_bebida_primero)) crlf
                     "   Segundo: " (instance-name (send ?menu_barato get-tiene_segundo)) crlf
                     "   Bebida para el segundo: " (instance-name (send ?menu_barato get-tiene_bebida_segundo)) crlf
                     "   Postre: " (instance-name (send ?menu_barato get-tiene_postre)) crlf
                     "   Bebidas extras: " (send ?menu_barato get-bebidas_extras) crlf
                     "   Precio por persona: " (send ?menu_barato get-precio) crlf)

      (bind ?menus (create$ ?menus_vegetarianos (instance-name ?menu_barato)))
      (send ?menu_barato put-tipo_segun_precio barato)
      (send ?e put-menus_vegetarianos ?menus)
      
      else
         (printout t crlf "No se han encontrado menus más baratos." crlf)

      )
   )
)

(defrule REFINAMIENTO::preguntar-menu_vegetariano
   ?e <- (object (is-a Evento) (dietas $?dietas) (menus_vegetarianos $?menus_vegetarianos))
   ?c <- (control_refinamiento (estado menu_barato_vegetariano))
   ?menus <- (menus_elegidos)
   =>
   (modify ?c (estado menu_vegetariano_completado))
   (if (member$ [Vegetariano] ?dietas) then
   (bind ?valido FALSE)
   (bind ?precio 0.0)
   (while (eq ?valido FALSE)
      (printout t "¿Qué tipo de menú quieres? (caro, medio, barato) " crlf)
      (bind ?resp (read))
      (if (or (eq ?resp caro) (eq ?resp medio) (eq ?resp barato))
         then
            (foreach ?m ?menus_vegetarianos
               (if (eq (send ?m get-tipo_segun_precio) ?resp)
               then
                  (bind ?precio (send ?m get-precio))
               )
            )
            (if (> ?precio 0.0) then
               (modify ?menus (vegetariano ?precio))
               (bind ?valido TRUE)
               (printout t crlf)
            else
               (printout t "Respuesta incorrecta. No hay ese tipo de menú." crlf)
            )
         else
            (printout t "Respuesta incorrecta. Debe ser caro, medio, barato." crlf)
      )
   )
   )   
)

(defrule REFINAMIENTO::escoger-menu-caro_vegano
   ?ctrl <- (control_refinamiento (estado menu_vegetariano_completado))
   ?e <- (object 
            (is-a Evento) 
            (dietas $?dietas))
   =>
   (modify ?ctrl (estado menu_caro_vegano))
   (if (member$ [Vegano] ?dietas) then
      (bind ?todos (find-all-instances ((?m Menu)) TRUE))
      (bind ?maximo -1)
      (bind ?menu_caro nil)
      (foreach ?m ?todos
         (if (and (eq (send ?m get-sigue_dieta) Vegano) (> (send ?m get-precio) ?maximo)) then
            (bind ?maximo (send ?m get-precio))
            (bind ?menu_caro ?m)))
      (if (eq ?maximo -1)
         then
         (printout t crlf "---- No se han encontrado menús veganos que cumplan todas las restricciones. ----" crlf)
         (modify ?ctrl (estado menu_vegano_completado))
         
         else
         (printout t crlf "---- OPCIONES DE MENÚS VEGANOS ----" crlf)
         (printout t crlf "-- CARO " crlf
                        "   Primero: " (instance-name (send ?menu_caro get-tiene_primero)) crlf
                        "   Bebida para el primero: " (instance-name (send ?menu_caro get-tiene_bebida_primero)) crlf
                        "   Segundo: " (instance-name (send ?menu_caro get-tiene_segundo)) crlf
                        "   Bebida para el segundo: " (instance-name (send ?menu_caro get-tiene_bebida_segundo)) crlf
                        "   Postre: " (instance-name (send ?menu_caro get-tiene_postre)) crlf
                        "   Bebidas extras:" (send ?menu_caro get-bebidas_extras) crlf
                        "   Precio por persona: " (send ?menu_caro get-precio) crlf)
         (bind ?menus (create$))
         (bind ?menus (create$ ?menus (instance-name ?menu_caro)))
         (send ?menu_caro put-tipo_segun_precio caro)
         (send ?e put-menus_veganos ?menus)
      )
   )

)

(defrule REFINAMIENTO::escoger_menu_medio_veganos
   ?ctrl <- (control_refinamiento (estado menu_caro_vegano))
   ?e <- (object (is-a Evento) (dietas $?dietas) (menus_veganos $?menus_veganos))
   =>
   (modify ?ctrl (estado menu_medio_vegano))
   (if (member$ [Vegano] ?dietas) then
      (bind ?todos (find-all-instances ((?m Menu)) TRUE))
      (foreach ?men ?todos
         (if (and (eq caro (send ?men get-tipo_segun_precio)) (eq Vegano (send ?men get-sigue_dieta))) then
            (bind ?menu_caro ?men)
            (bind ?primero_caro (send ?menu_caro get-tiene_primero))
            (bind ?segundo_caro (send ?menu_caro get-tiene_segundo))
            (bind ?postre_caro (send ?menu_caro get-tiene_postre))
            (bind ?maximo (send ?menu_caro get-precio))
         )
      )

      ;; 2) Precio objetivo = 90% del caro
      (bind ?objetivo (* 0.9 ?maximo))

      ;; 3) Buscar el mejor menú "medio":
      ;;    - Omnívoro
      ;;    - Precio <= objetivo (lo más caro posible sin pasar del objetivo)
      ;;    - Sin platos repetidos (primero, segundo, postre distintos)
      (bind ?menu_medio nil)
      (bind ?precio_medio -1)
      (foreach ?candidato ?todos
         (if (eq (send ?candidato get-sigue_dieta) Vegano) then
            (bind ?p (send ?candidato get-precio))
            (bind ?pr (send ?candidato get-tiene_primero))
            (bind ?sg (send ?candidato get-tiene_segundo))
            (bind ?po (send ?candidato get-tiene_postre))
            (bind ?prn (instance-name ?pr))
            (bind ?sgn (instance-name ?sg))
            (bind ?pon (instance-name ?po))
            (if (and (<= ?p ?objetivo)
                     (neq ?candidato ?menu_caro)
                     (neq ?prn (instance-name ?primero_caro)) (neq ?sgn (instance-name ?segundo_caro)) (neq ?pon (instance-name ?postre_caro)))
                then
                (if (> ?p ?precio_medio) then
                   (bind ?precio_medio ?p)
                   (bind ?menu_medio ?candidato)))))

      ;; 4) Si no hay ninguno <= objetivo, coger el más cercano al objetivo por arriba,
      ;;    manteniendo las mismas restricciones de no repetir platos.
      (if (eq ?menu_medio nil) then
         (bind ?mejor_diff 1.0e+12)
         (foreach ?candidato ?todos
            (if (eq (send ?candidato get-sigue_dieta) Vegano) then
               (bind ?p (send ?candidato get-precio))
               (bind ?pr (send ?candidato get-tiene_primero))
               (bind ?sg (send ?candidato get-tiene_segundo))
               (bind ?po (send ?candidato get-tiene_postre))
               (bind ?prn (instance-name ?pr))
               (bind ?sgn (instance-name ?sg))
               (bind ?pon (instance-name ?po))
               (bind ?diff (abs (- ?p ?objetivo)))
               (if (and (neq ?candidato ?menu_caro)
                        (neq ?prn ?sgn) (neq ?prn ?pon) (neq ?sgn ?pon)
                        (< ?diff ?mejor_diff))
                   then
                   (bind ?mejor_diff ?diff)
                   (bind ?menu_medio ?candidato)))))

      (if (neq ?menu_medio nil) then
         

      ;; 6) Salida y almacenamiento
      (printout t crlf "-- MEDIO " crlf
                     "   Primero: " (instance-name (send ?menu_medio get-tiene_primero)) crlf
                     "   Bebida para el primero: " (instance-name (send ?menu_medio get-tiene_bebida_primero)) crlf
                     "   Segundo: " (instance-name (send ?menu_medio get-tiene_segundo)) crlf
                     "   Bebida para el segundo: " (instance-name (send ?menu_medio get-tiene_bebida_segundo)) crlf
                     "   Postre: " (instance-name (send ?menu_medio get-tiene_postre)) crlf
                     "   Bebidas extras: " (send ?menu_medio get-bebidas_extras) crlf
                     "   Precio por persona: " (send ?menu_medio get-precio) crlf)

      (bind ?menus (create$ ?menus_veganos (instance-name ?menu_medio)))
      (send ?menu_medio put-tipo_segun_precio medio)
      (send ?e put-menus_veganos ?menus)

      else
         (printout t crlf "No se han encontrado menus más baratos." crlf)
         (modify ?ctrl (estado menu_barato_vegano))

      ) 
   )
)

(defrule REFINAMIENTO::escoger-menu-barato_veganos
   ?ctrl <- (control_refinamiento (estado menu_medio_vegano))
   ?e <- (object (is-a Evento) (dietas $?dietas) (menus_veganos $?menus_veganos))

   =>
   (modify ?ctrl (estado menu_barato_vegano))
   (if (member$ [Vegano] ?dietas) then
      (bind ?todos (find-all-instances ((?m Menu)) TRUE))
      (foreach ?men ?todos
         (if (and (eq medio (send ?men get-tipo_segun_precio)) (eq Vegano (send ?men get-sigue_dieta))) then
            (bind ?menu_medio ?men)
            (bind ?primero_caro (send ?menu_medio get-tiene_primero))
            (bind ?segundo_caro (send ?menu_medio get-tiene_segundo))
            (bind ?postre_caro (send ?menu_medio get-tiene_postre))
            (bind ?maximo (send ?menu_medio get-precio))
         )
      )

      ;; 2) Precio objetivo = 90% del caro
      (bind ?objetivo (* 0.9 ?maximo))

      ;; 3) Buscar el mejor menú "medio":
      ;;    - Omnívoro
      ;;    - Precio <= objetivo (lo más caro posible sin pasar del objetivo)
      ;;    - Sin platos repetidos (primero, segundo, postre distintos)
      (bind ?menu_barato nil)
      (bind ?precio_barato -1)
      (foreach ?candidato ?todos
         (if (eq (send ?candidato get-sigue_dieta) Vegano) then
            (bind ?p (send ?candidato get-precio))
            (bind ?pr (send ?candidato get-tiene_primero))
            (bind ?sg (send ?candidato get-tiene_segundo))
            (bind ?po (send ?candidato get-tiene_postre))
            (bind ?prn (instance-name ?pr))
            (bind ?sgn (instance-name ?sg))
            (bind ?pon (instance-name ?po))
            (if (and (<= ?p ?objetivo)
                     (neq ?candidato ?menu_medio)
                     (neq ?prn (instance-name ?primero_caro)) (neq ?sgn (instance-name ?segundo_caro)) (neq ?pon (instance-name ?postre_caro)))
                then
                (if (> ?p ?precio_barato) then
                   (bind ?precio_barato ?p)
                   (bind ?menu_barato ?candidato)))))

      ;; 6) Salida y almacenamiento
      (if (neq ?menu_barato nil) then 
      (printout t crlf "-- BARATO " crlf
                     "   Primero: " (instance-name (send ?menu_barato get-tiene_primero)) crlf
                     "   Bebida para el primero: " (instance-name (send ?menu_barato get-tiene_bebida_primero)) crlf
                     "   Segundo: " (instance-name (send ?menu_barato get-tiene_segundo)) crlf
                     "   Bebida para el segundo: " (instance-name (send ?menu_barato get-tiene_bebida_segundo)) crlf
                     "   Postre: " (instance-name (send ?menu_barato get-tiene_postre)) crlf
                     "   Bebidas extras: " (send ?menu_barato get-bebidas_extras) crlf
                     "   Precio por persona: " (send ?menu_barato get-precio) crlf)

      (bind ?menus (create$ ?menus_veganos (instance-name ?menu_barato)))
      (send ?menu_barato put-tipo_segun_precio barato)
      (send ?e put-menus_veganos ?menus)

      else

         (printout t crlf "No se han encontrado menus más baratos." crlf)

      )
   )
)

(defrule REFINAMIENTO::preguntar-menu_vegano
   ?e <- (object (is-a Evento) (dietas $?dietas) (menus_veganos $?menus_veganos))
   ?c <- (control_refinamiento (estado menu_barato_vegano))
   ?menus <- (menus_elegidos)
   =>
   (if (member$ [Vegano] ?dietas) then
   (bind ?valido FALSE)
   (bind ?precio 0.0)
   (while (eq ?valido FALSE)
      (printout t "¿Qué tipo de menú quieres? (caro, medio, barato) " crlf)
      (bind ?resp (read))
      (if (or (eq ?resp caro) (eq ?resp medio) (eq ?resp barato))
         then
            (foreach ?m ?menus_veganos 
               (if (eq (send ?m get-tipo_segun_precio) ?resp)
               then
                  (bind ?precio (send ?m get-precio))
               )
            )
            (if (> ?precio 0.0) then
               (modify ?menus (vegano ?precio))
               (bind ?valido TRUE)
               (printout t crlf)
            else
               (printout t "Respuesta incorrecta. No hay ese tipo de menú." crlf)
            )
         else
            (printout t "Respuesta incorrecta. Debe ser caro, medio, barato." crlf)
      )
   )
   )
   (modify ?c (estado menu_vegano_completado))
   
)

(defrule REFINAMIENTO::escoger-menu-caro_halal
   ?ctrl <- (control_refinamiento (estado menu_vegano_completado))
   ?e <- (object 
            (is-a Evento) 
            (dietas $?dietas))
   =>
   (modify ?ctrl (estado menu_caro_halal))
   (if (member$ [Halal] ?dietas) then
      (bind ?todos (find-all-instances ((?m Menu)) TRUE))
      (bind ?maximo -1)
      (bind ?menu_caro nil)
      (foreach ?m ?todos
         (if (and (eq (send ?m get-sigue_dieta) Halal) (> (send ?m get-precio) ?maximo)) then
            (bind ?maximo (send ?m get-precio))
            (bind ?menu_caro ?m)))
      (if (eq ?maximo -1)
         then
         (printout t crlf "---- No se han encontrado menús halal que cumplan todas las restricciones. ----" crlf)
         (modify ?ctrl (estado menu_halal_completado))
         
         else
         (printout t crlf "---- OPCIONES DE MENÚS HALAL ----" crlf)
         (printout t crlf "-- CARO " crlf
                        "   Primero: " (instance-name (send ?menu_caro get-tiene_primero)) crlf
                        "   Bebida para el primero: " (instance-name (send ?menu_caro get-tiene_bebida_primero)) crlf
                        "   Segundo: " (instance-name (send ?menu_caro get-tiene_segundo)) crlf
                        "   Bebida para el segundo: " (instance-name (send ?menu_caro get-tiene_bebida_segundo)) crlf
                        "   Postre: " (instance-name (send ?menu_caro get-tiene_postre)) crlf
                        "   Bebidas extras:" (send ?menu_caro get-bebidas_extras) crlf
                        "   Precio por persona: " (send ?menu_caro get-precio) crlf)
         (bind ?menus (create$))
         (bind ?menus (create$ ?menus (instance-name ?menu_caro)))
         (send ?menu_caro put-tipo_segun_precio caro)
         (send ?e put-menus_halal ?menus)
      )
   )

)

(defrule REFINAMIENTO::escoger_menu_medio_halal
   ?ctrl <- (control_refinamiento (estado menu_caro_halal))
   ?e <- (object (is-a Evento) (dietas $?dietas) (menus_halal $?menus_halal))
   =>
   (modify ?ctrl (estado menu_medio_halal))
   (if (member$ [Halal] ?dietas) then
      (bind ?todos (find-all-instances ((?m Menu)) TRUE))
      (foreach ?men ?todos
         (if (and (eq caro (send ?men get-tipo_segun_precio)) (eq Halal (send ?men get-sigue_dieta))) then
            (bind ?menu_caro ?men)
            (bind ?primero_caro (send ?menu_caro get-tiene_primero))
            (bind ?segundo_caro (send ?menu_caro get-tiene_segundo))
            (bind ?postre_caro (send ?menu_caro get-tiene_postre))
            (bind ?maximo (send ?menu_caro get-precio))
         )
      )
      ;; 2) Precio objetivo = 90% del caro
      (bind ?objetivo (* 0.9 ?maximo))

      ;; 3) Buscar el mejor menú "medio":
      ;;    - Omnívoro
      ;;    - Precio <= objetivo (lo más caro posible sin pasar del objetivo)
      ;;    - Sin platos repetidos (primero, segundo, postre distintos)
      (bind ?menu_medio nil)
      (bind ?precio_medio -1)
      (foreach ?candidato ?todos
         (if (eq (send ?candidato get-sigue_dieta) Halal) then
            (bind ?p (send ?candidato get-precio))
            (bind ?pr (send ?candidato get-tiene_primero))
            (bind ?sg (send ?candidato get-tiene_segundo))
            (bind ?po (send ?candidato get-tiene_postre))
            (bind ?prn (instance-name ?pr))
            (bind ?sgn (instance-name ?sg))
            (bind ?pon (instance-name ?po))
            (if (and (<= ?p ?objetivo)
                     (neq ?candidato ?menu_caro)
                     (neq ?prn (instance-name ?primero_caro)) (neq ?sgn (instance-name ?segundo_caro)) (neq ?pon (instance-name ?postre_caro)))
                then
                (if (> ?p ?precio_medio) then
                   (bind ?precio_medio ?p)
                   (bind ?menu_medio ?candidato)))))



      (if (neq ?menu_medio nil) then
         (printout t crlf "-- MEDIO " crlf
                        "   Primero: " (instance-name (send ?menu_medio get-tiene_primero)) crlf
                        "   Bebida para el primero: " (instance-name (send ?menu_medio get-tiene_bebida_primero)) crlf
                        "   Segundo: " (instance-name (send ?menu_medio get-tiene_segundo)) crlf
                        "   Bebida para el segundo: " (instance-name (send ?menu_medio get-tiene_bebida_segundo)) crlf
                        "   Postre: " (instance-name (send ?menu_medio get-tiene_postre)) crlf
                        "   Bebidas extras: " (send ?menu_medio get-bebidas_extras) crlf
                        "   Precio por persona: " (send ?menu_medio get-precio) crlf)

         (bind ?menus (create$ ?menus_halal (instance-name ?menu_medio)))
         (send ?menu_medio put-tipo_segun_precio medio)
         (send ?e put-menus_halal ?menus)

      else
         (printout t crlf "No se han encontrado menus más baratos." crlf)
         (modify ?ctrl (estado menu_barato_halal))
      ) 
   )
)

(defrule REFINAMIENTO::escoger-menu-barato_halal
   ?ctrl <- (control_refinamiento (estado menu_medio_halal))
   ?e <- (object (is-a Evento) (dietas $?dietas) (menus_halal $?menus_halal))

   =>
   (modify ?ctrl (estado menu_barato_halal))
   (if (member$ [Halal] ?dietas) then
      (bind ?todos (find-all-instances ((?m Menu)) TRUE))
      (foreach ?men ?todos
         (if (and (eq medio (send ?men get-tipo_segun_precio)) (eq Halal (send ?men get-sigue_dieta))) then
            (bind ?menu_medio ?men)
            (bind ?primero_caro (send ?menu_medio get-tiene_primero))
            (bind ?segundo_caro (send ?menu_medio get-tiene_segundo))
            (bind ?postre_caro (send ?menu_medio get-tiene_postre))
            (bind ?maximo (send ?menu_medio get-precio))
         )
      )

      ;; 2) Precio objetivo = 90% del caro
      (bind ?objetivo (* 0.9 ?maximo))

      ;; 3) Buscar el mejor menú "medio":
      ;;    - Omnívoro
      ;;    - Precio <= objetivo (lo más caro posible sin pasar del objetivo)
      ;;    - Sin platos repetidos (primero, segundo, postre distintos)
      (bind ?menu_barato nil)
      (bind ?precio_barato -1)
      (foreach ?candidato ?todos
         (if (eq (send ?candidato get-sigue_dieta) Halal) then
            (bind ?p (send ?candidato get-precio))
            (bind ?pr (send ?candidato get-tiene_primero))
            (bind ?sg (send ?candidato get-tiene_segundo))
            (bind ?po (send ?candidato get-tiene_postre))
            (bind ?prn (instance-name ?pr))
            (bind ?sgn (instance-name ?sg))
            (bind ?pon (instance-name ?po))
            (if (and (<= ?p ?objetivo)
                     (neq ?candidato ?menu_medio)
                     (neq ?prn (instance-name ?primero_caro)) (neq ?sgn (instance-name ?segundo_caro)) (neq ?pon (instance-name ?postre_caro)))
                then
                (if (> ?p ?precio_barato) then
                   (bind ?precio_barato ?p)
                   (bind ?menu_barato ?candidato)))))


      ;; 6) Salida y almacenamiento
      (if (neq ?menu_barato nil) then 
         (printout t crlf "-- BARATO " crlf
                        "   Primero: " (instance-name (send ?menu_barato get-tiene_primero)) crlf
                        "   Bebida para el primero: " (instance-name (send ?menu_barato get-tiene_bebida_primero)) crlf
                        "   Segundo: " (instance-name (send ?menu_barato get-tiene_segundo)) crlf
                        "   Bebida para el segundo: " (instance-name (send ?menu_barato get-tiene_bebida_segundo)) crlf
                        "   Postre: " (instance-name (send ?menu_barato get-tiene_postre)) crlf
                        "   Bebidas extras: " (send ?menu_barato get-bebidas_extras) crlf
                        "   Precio por persona: " (send ?menu_barato get-precio) crlf)

         (bind ?menus (create$ ?menus_halal (instance-name ?menu_barato)))
         (send ?menu_barato put-tipo_segun_precio barato)
         (send ?e put-menus_halal ?menus)
      
      else
         (printout t crlf "No se han encontrado menus más baratos." crlf)
      )
   )
)

(defrule REFINAMIENTO::preguntar-menu_halal
   ?e <- (object (is-a Evento) (dietas $?dietas) (menus_halal $?menus_halal))
   ?c <- (control_refinamiento (estado menu_barato_halal))
   ?menus <- (menus_elegidos)
   =>
   (if (member$ [Halal] ?dietas) then
   (bind ?valido FALSE)
   (bind ?precio 0.0)
   (while (eq ?valido FALSE)
      (printout t "¿Qué tipo de menú quieres? (caro, medio, barato) " crlf)
      (bind ?resp (read))
      (if (or (eq ?resp caro) (eq ?resp medio) (eq ?resp barato))
         then
            (foreach ?m ?menus_halal 
               (if (eq (send ?m get-tipo_segun_precio) ?resp)
               then
                  (bind ?precio (send ?m get-precio))
               )
            )
            (if (> ?precio 0.0) then
               (modify ?menus (halal ?precio))
               (bind ?valido TRUE)
               (printout t crlf)
            else
               (printout t "Respuesta incorrecta. No hay ese tipo de menú." crlf)
            )
         else
            (printout t "Respuesta incorrecta. Debe ser caro, medio, barato." crlf)
      )
   )
   )
   (modify ?c (estado menu_halal_completado))
   
)
(deftemplate pastel_recomendado
  (slot dieta      (type SYMBOL) (allowed-symbols Omnivora Vegetariano Vegano Halal))
  (slot categoria  (type SYMBOL) (allowed-symbols barato medio caro))
  (slot nombre)
  (slot coste     (type FLOAT)))

(deffunction precio-pastel (?x)
  (bind ?addr (if (instance-addressp ?x) then ?x else (instance-address ?x)))
  (if (neq ?addr nil) then (return (send ?addr get-Precio)) else (return 0.0)))

(deffunction pastel-orden-precio-asc (?a ?b)
  (< (precio-pastel ?a) (precio-pastel ?b)))

(deffunction indice-medio (?n)
  (if (= (mod ?n 2) 0)
      then (return (integer (/ ?n 2)))
      else (return (+ (integer (/ ?n 2)) 1))))

(defrule REFINAMIENTO::recomendar-3-pasteles-solo-dieta
  ?c <- (control_refinamiento (estado menu_halal_completado))
  ?cond <- (condiciones_evento (dieta_pastel ?dp&~Indefinido) (tipo ?tipo))
  ?comp <- (comida_compatible
             (pasteles_omnivoros    $?po)
             (pasteles_vegetarianos $?pveg)
             (pasteles_veganos      $?pvegan)
             (pasteles_halal        $?phal))
   ?m <- (menus_elegidos)
  =>
   (modify ?c (estado pasteles_buscados))
   (if (eq ?tipo Evento_familiar) then
      ;; Limpia recomendaciones previas
      (do-for-all-facts ((?r pastel_recomendado)) TRUE (retract ?r))

      ;; Elige la lista según la dieta seleccionada
      (bind ?lista
         (if (eq ?dp Omnivora) then ?po
         else (if (eq ?dp Vegetariano) then ?pveg
            else (if (eq ?dp Vegano) then ?pvegan
            else ?phal))))

      (printout t crlf "---- OPCIONES DE PASTELES ----" crlf)

      (if (= (length$ ?lista) 0) then
         (printout t "No hay pasteles disponibles para la dieta seleccionada." crlf)
         else
         ;; Ordena por precio (el comparador puede devolver asc/desc, por eso comprobamos extremos)
         (bind ?ord (sort pastel-orden-precio-asc ?lista))
         (bind ?n   (length$ ?ord))

         ;; extremos y sus precios
         (bind ?first  (nth$ 1 ?ord))
         (bind ?last   (nth$ ?n ?ord))
         (bind ?pFirst (precio-pastel ?first))
         (bind ?pLast  (precio-pastel ?last))

         ;; decide barato/caro mirando el precio real de los extremos
         (if (<= ?pFirst ?pLast)
            then (bind ?barato ?first) (bind ?caro ?last)
            else (bind ?barato ?last)  (bind ?caro ?first))

         ;; barato
         (bind ?pBarato (precio-pastel ?barato))
         (assert (pastel_recomendado (dieta ?dp) (categoria barato) (nombre ?barato) (coste ?pBarato)))
         (printout t "  barato: " ?barato " (" ?pBarato "€)" crlf)

         ;; medio (si hay >= 3)
         (if (>= ?n 3) then
            (bind ?mid  (nth$ (indice-medio ?n) ?ord))
            (bind ?pMid (precio-pastel ?mid))
            (if (and (neq ?mid ?barato) (neq ?mid ?caro)) then
            (assert (pastel_recomendado (dieta ?dp) (categoria medio) (nombre ?mid) (coste ?pMid))))
            (printout t "  medio : " ?mid " (" ?pMid "€)" crlf))

         ;; caro (si hay >= 2)
         (if (>= ?n 2) then
            (bind ?pCaro (precio-pastel ?caro))
            (assert (pastel_recomendado (dieta ?dp) (categoria caro) (nombre ?caro) (coste ?pCaro)))
            (printout t "  caro  : " ?caro " (" ?pCaro "€)" crlf))
      
      (bind ?fin FALSE)
      (while (eq ?fin FALSE)
         (printout t crlf "¿Qué tipo de pastel quieres? (caro, medio, barato)" crlf)
         (bind ?resp (read))
         (if (or (eq ?resp caro) (eq ?resp medio) (eq ?resp barato)) then
            (if (or (and (eq ?resp caro) (< ?n 2)) (and (eq ?resp medio) ( < ?n 3))) 
               then
                  (printout t crlf "Respuesta incorrecta. No tenemos de ese tipo. " crlf)
               else
                  (bind ?fin TRUE)
                  (if (eq ?resp caro) then  (modify ?m (pastel ?pCaro)))
                  (if (eq ?resp medio) then  (modify ?m (pastel ?pMid)))
                  (if (eq ?resp barato) then  (modify ?m (pastel ?pBarato)))
            )
         else
            (printout t crlf "Respuesta incorrecta. Debe ser caro, medio o barato. " crlf)
         )
      )
      )
   )
)


(deffunction REFINAMIENTO::_addr (?x)
  (if (instance-addressp ?x) then (return ?x)
   else (if (instance-namep ?x) then (return (instance-address ?x)) else (return ?x))))

(deffunction REFINAMIENTO::_instname (?x)
  (if (instance-addressp ?x) then (return (instance-name ?x))
   else (if (instance-namep ?x) then (return ?x) else (return ?x))))

(deffunction REFINAMIENTO::_normaliza-lista-nombres (?xs)
  (bind ?xs (create$ ?xs)) 
  (bind ?res (create$))
  (progn$ (?x ?xs)
    (bind ?res (create$ ?res (REFINAMIENTO::_instname ?x))))
  (return ?res))

(deffunction REFINAMIENTO::_underscores->spaces (?s)
  (bind ?out "")
  (bind ?n (str-length ?s))
  (bind ?i 1)
  (while (<= ?i ?n)
    (bind ?ch (sub-string ?i ?i ?s))
    (bind ?out (str-cat ?out (if (eq ?ch "_") then " " else ?ch)))
    (bind ?i (+ ?i 1)))
  (return ?out))

(deffunction REFINAMIENTO::pretty-name (?x)
  (bind ?raw (str-cat (REFINAMIENTO::_instname ?x)))
  (if (and (> (str-length ?raw) 0) (eq (sub-string 1 1 ?raw) "[")) then
      (bind ?raw (sub-string 2 (- (str-length ?raw) 1) ?raw)))
  (return (REFINAMIENTO::_underscores->spaces ?raw)))

(deffunction REFINAMIENTO::pretty-list$ (?xs)
  (bind ?xs (create$ ?xs)) 
  (bind ?tmp (create$))
  (progn$ (?x ?xs)
    (bind ?tmp (create$ ?tmp (REFINAMIENTO::pretty-name ?x))))
  (return ?tmp))

(deffunction REFINAMIENTO::join$ (?xs)
  (bind ?xs (create$ ?xs)) 
  (bind ?n (length$ ?xs))
  (if (= ?n 0) then (return "—"))
  (if (= ?n 1) then (return (nth$ 1 ?xs)))
  (bind ?out "")
  (bind ?i 1)
  (while (<= ?i ?n)
    (bind ?w (nth$ ?i ?xs))
    (bind ?out (str-cat ?out ?w
                (if (< ?i (- ?n 1)) then ", "
                 else (if (= ?i (- ?n 1)) then " y " else ""))))
    (bind ?i (+ ?i 1)))
  (return ?out))

;; ----- alcohol
(deffunction REFINAMIENTO::bebida-es-sin-alcohol (?b)
  (bind ?a (REFINAMIENTO::_addr ?b))
  (bind ?c (class ?a))
  (return (or (eq ?c Sin_alcohol)
              (member$ Sin_alcohol (class-superclasses ?c inherit)))))

;; ----- ingredientes de un plato (instance-names)
(deffunction REFINAMIENTO::lista-ingredientes-nombres (?plato)
  (bind ?p (REFINAMIENTO::_addr ?plato))
  (bind ?res (create$))
  (progn$ (?ing (create$ (send ?p get-usa_ingrediente)))
    (bind ?res (create$ ?res (instance-name ?ing))))
  (return ?res))

;; ----- alérgenos  -> instance-names
(deffunction REFINAMIENTO::lista-alergenos-nombres (?x)
  (bind ?a (REFINAMIENTO::_addr ?x))
  (bind ?res (create$))
  (if (slot-existp (class ?a) contiene_alergenos inherit) then
    (progn$ (?al (create$ (send ?a get-contiene_alergenos)))
      (bind ?res (create$ ?res (instance-name ?al)))))
  (return ?res))

;; ----- estilos/temperaturas/épocas de un plato 
(deffunction REFINAMIENTO::_estilos$ (?p)
  (REFINAMIENTO::pretty-list$ (create$ (send (REFINAMIENTO::_addr ?p) get-tiene_estilo))))
(deffunction REFINAMIENTO::_temps$ (?p)
  (REFINAMIENTO::pretty-list$ (create$ (send (REFINAMIENTO::_addr ?p) get-tiene_temperatura))))
(deffunction REFINAMIENTO::_epocas$ (?p)
  (REFINAMIENTO::pretty-list$ (create$ (send (REFINAMIENTO::_addr ?p) get-se_sirve_en))))

;; ----- ingredientes del plato que maridan con la bebida
(deffunction REFINAMIENTO::ingredientes-que-maridan (?bebida ?plato)
  (bind ?b (REFINAMIENTO::_addr ?bebida))
  (bind ?p (REFINAMIENTO::_addr ?plato))

  ;; ingredientes del plato (addresses)
  (bind ?ingsP (create$))
  (progn$ (?i (create$ (send ?p get-usa_ingrediente)))
    (bind ?ingsP (create$ ?ingsP ?i)))

  (bind ?targets (create$))
  (if (slot-existp (class ?b) marida_con_ingredientes inherit) then
    (progn$ (?x (create$ (send ?b get-marida_con_ingredientes)))
      (bind ?targets (create$ ?targets (REFINAMIENTO::_instname ?x)))))
  (if (slot-existp (class ?b) marida_con_ingrediente inherit) then
    (progn$ (?x (create$ (send ?b get-marida_con_ingrediente)))
      (bind ?targets (create$ ?targets (REFINAMIENTO::_instname ?x)))))
  (if (slot-existp (class ?b) marida_con inherit) then
    (progn$ (?x (create$ (send ?b get-marida_con)))
      (bind ?targets (create$ ?targets (REFINAMIENTO::_instname ?x)))))

  ;; cruce directo bebida->ingrediente por nombre
  (bind ?match (create$))
  (progn$ (?i ?ingsP)
    (bind ?iname (instance-name ?i))
    (if (member$ ?iname ?targets) then
      (bind ?match (create$ ?match ?i))))

  ;; desde el ingrediente hacia la bebida
  (progn$ (?i ?ingsP)
    (bind ?cls (class ?i))
    (if (slot-existp ?cls marida_con_bebidas inherit) then
      (progn$ (?bx (create$ (send ?i get-marida_con_bebidas)))
        (if (or (eq ?bx ?b)
                (eq (REFINAMIENTO::_instname ?bx) (REFINAMIENTO::_instname ?b)))
          then (bind ?match (create$ ?match ?i))))))

  (return (REFINAMIENTO::pretty-list$ ?match))
)

(deffunction REFINAMIENTO::_plato-tiene-clase (?plato ?clase)
  (bind ?p (REFINAMIENTO::_addr ?plato))
  (progn$ (?ing (create$ (send ?p get-usa_ingrediente)))
    (bind ?cls    (class ?ing))
    (bind ?supers (create$ ?cls (class-superclasses ?cls inherit)))
    (if (member$ ?clase ?supers) then (return TRUE)))
  (return FALSE)
)

;; =========================================================
;; Explicación concisa de un menú
;; =========================================================
(deffunction REFINAMIENTO::_explica-uno (?menu ?alc ?epoca ?prohibidos ?alergenos)
  (bind ?m (REFINAMIENTO::_addr ?menu))
  (bind ?prim (send ?m get-tiene_primero))
  (bind ?seg  (send ?m get-tiene_segundo))
  (bind ?pos  (send ?m get-tiene_postre))
  (bind ?b1   (send ?m get-tiene_bebida_primero))
  (bind ?b2   (send ?m get-tiene_bebida_segundo))

  (bind ?tipo   (send ?m get-tipo_segun_precio))
  (bind ?dieta  (send ?m get-sigue_dieta))
  (bind ?precio (send ?m get-precio))

  ;; Nombres bonitos
  (bind ?epocaN (REFINAMIENTO::pretty-name ?epoca))
  (bind ?primN  (REFINAMIENTO::pretty-name ?prim))
  (bind ?segN   (REFINAMIENTO::pretty-name ?seg))
  (bind ?posN   (REFINAMIENTO::pretty-name ?pos))
  (bind ?b1N    (REFINAMIENTO::pretty-name ?b1))
  (bind ?b2N    (REFINAMIENTO::pretty-name ?b2))
  (bind ?dietaN (REFINAMIENTO::pretty-name ?dieta))
  (bind ?tipoN  (REFINAMIENTO::pretty-name ?tipo))

  (bind ?prohN      (REFINAMIENTO::pretty-list$ (REFINAMIENTO::_normaliza-lista-nombres ?prohibidos)))
  (bind ?alergUserN (REFINAMIENTO::pretty-list$ (REFINAMIENTO::_normaliza-lista-nombres ?alergenos)))

  (bind ?ingPrimN (REFINAMIENTO::pretty-list$ (REFINAMIENTO::lista-ingredientes-nombres ?prim)))
  (bind ?ingSegN  (REFINAMIENTO::pretty-list$ (REFINAMIENTO::lista-ingredientes-nombres ?seg)))
  (bind ?ingPosN  (REFINAMIENTO::pretty-list$ (REFINAMIENTO::lista-ingredientes-nombres ?pos)))

  (bind ?alPrimN (REFINAMIENTO::pretty-list$ (REFINAMIENTO::lista-alergenos-nombres ?prim)))
  (bind ?alSegN  (REFINAMIENTO::pretty-list$ (REFINAMIENTO::lista-alergenos-nombres ?seg)))
  (bind ?alPosN  (REFINAMIENTO::pretty-list$ (REFINAMIENTO::lista-alergenos-nombres ?pos)))

  ;; Ingredientes concretos que maridan
  (bind ?maridaB1 (REFINAMIENTO::ingredientes-que-maridan ?b1 ?prim))
  (bind ?maridaB2 (REFINAMIENTO::ingredientes-que-maridan ?b2 ?seg))

  (printout t crlf "*** " ?dietaN " (" ?tipoN ") — " ?precio "€ ***" crlf)
  (printout t "Evento en " ?epocaN "." crlf)

  ;; 1) Bebidas (con ingrediente de maridaje)
  (printout t "1) Bebidas: " crlf)
  (printout t "   - El evento "
             (if (or (eq ?alc si) (eq ?alc yes) (eq ?alc TRUE) (eq ?alc Si))
                 then "permite" else "no permite") " alcohol." crlf)
  (printout t "   - Para el primero: " ?b1N " ("
             (if (REFINAMIENTO::bebida-es-sin-alcohol ?b1) then "sin alcohol" else "con alcohol")
             "). Marida con: "
             (if (> (length$ ?maridaB1) 0)
                 then (REFINAMIENTO::join$ ?maridaB1)
                 else (if (marida-con-plato ?b1 ?prim) then "maridaje general del plato" else "no marida"))
             "." crlf)
  (printout t "   - Para el segundo: " ?b2N " ("
             (if (REFINAMIENTO::bebida-es-sin-alcohol ?b2) then "sin alcohol" else "con alcohol")
             "). Marida con: "
             (if (> (length$ ?maridaB2) 0)
                 then (REFINAMIENTO::join$ ?maridaB2)
                 else (if (marida-con-plato ?b2 ?seg) then "maridaje general del plato" else "no marida"))
             "." crlf)

  ;; 2) Platos: características básicas
  (printout t "2) Platos (características básicas):" crlf)
  (printout t "   - Primero: " ?primN crlf)
  (printout t "     · Estilo: "       (REFINAMIENTO::join$ (REFINAMIENTO::_estilos$ ?prim)) crlf)
  (printout t "     · Temperatura: "  (REFINAMIENTO::join$ (REFINAMIENTO::_temps$   ?prim)) crlf)
  (printout t "     · Época: "        (REFINAMIENTO::join$ (REFINAMIENTO::_epocas$  ?prim)) crlf)
  (printout t "     · Ingredientes: " (REFINAMIENTO::join$ ?ingPrimN) crlf)

  (printout t "   - Segundo: " ?segN crlf)
  (printout t "     · Estilo: "       (REFINAMIENTO::join$ (REFINAMIENTO::_estilos$ ?seg)) crlf)
  (printout t "     · Temperatura: "  (REFINAMIENTO::join$ (REFINAMIENTO::_temps$   ?seg)) crlf)
  (printout t "     · Época: "        (REFINAMIENTO::join$ (REFINAMIENTO::_epocas$  ?seg)) crlf)
  (printout t "     · Ingredientes: " (REFINAMIENTO::join$ ?ingSegN) crlf)

  (printout t "   - Postre: " ?posN crlf)
  (printout t "     · Estilo: "       (REFINAMIENTO::join$ (REFINAMIENTO::_estilos$ ?pos)) crlf)
  (printout t "     · Temperatura: "  (REFINAMIENTO::join$ (REFINAMIENTO::_temps$   ?pos)) crlf)
  (printout t "     · Época: "        (REFINAMIENTO::join$ (REFINAMIENTO::_epocas$  ?pos)) crlf)
  (printout t "     · Ingredientes: " (REFINAMIENTO::join$ ?ingPosN) crlf)

  ;; 3) Alérgenos
  (printout t "3) Alérgenos:" crlf)
  (printout t "   - Primero: " (REFINAMIENTO::join$ ?alPrimN) crlf)
  (printout t "   - Segundo: " (REFINAMIENTO::join$ ?alSegN)  crlf)
  (printout t "   - Postre: "  (REFINAMIENTO::join$ ?alPosN)  crlf)
  (printout t "   - No contienen: " (REFINAMIENTO::join$ ?alergUserN) crlf)

  ;; ====== NUEVO: 4) Equilibrio entre platos ======
  (bind ?primCarne (REFINAMIENTO::_plato-tiene-clase ?prim Carne))
  (bind ?segCarne  (REFINAMIENTO::_plato-tiene-clase ?seg  Carne))
  (bind ?primPesc  (REFINAMIENTO::_plato-tiene-clase ?prim Pescado))
  (bind ?segPesc   (REFINAMIENTO::_plato-tiene-clase ?seg  Pescado))
  (bind ?primMar   (REFINAMIENTO::_plato-tiene-clase ?prim Marisco))
  (bind ?segMar    (REFINAMIENTO::_plato-tiene-clase ?seg  Marisco))
  (bind ?primLeg   (REFINAMIENTO::_plato-tiene-clase ?prim Legumbre))
  (bind ?segLeg    (REFINAMIENTO::_plato-tiene-clase ?seg  Legumbre))
  (bind ?primHue   (REFINAMIENTO::_plato-tiene-clase ?prim Huevos))
  (bind ?segHue    (REFINAMIENTO::_plato-tiene-clase ?seg  Huevos))

  (printout t "4) Equilibrio entre platos:" crlf)
  (printout t "   - No se repite carne: " (not (and ?primCarne ?segCarne)) crlf)
  (printout t "   - No se repite pescado/marisco simultáneos: "
               (not (or (and ?primPesc ?segPesc)
                        (and ?primMar  ?segMar)
                        (and ?primPesc ?segMar)
                        (and ?primMar  ?segPesc))) crlf)
  (printout t "   - No se repiten legumbres: " (not (and ?primLeg ?segLeg)) crlf)
  (printout t "   - No se repite huevo: " (not (and ?primHue ?segHue)) crlf)

  ;; 5) Prohibidos (mostrar si hay)
  (if (> (length$ ?prohN) 0) then
    (printout t "5) Ingredientes prohibidos: " (REFINAMIENTO::join$ ?prohN) crlf))
)

(deffunction REFINAMIENTO::_explica-desde-lista (?menus ?precio ?alc ?epoca ?proh ?alerg)
  (bind ?menus (create$ ?menus)) 
  (bind ?sel nil)
  (progn$ (?m ?menus)
    (bind ?addr (REFINAMIENTO::_addr ?m))
    (if (= (send ?addr get-precio) ?precio) then (bind ?sel ?addr)))
  (if (neq ?sel nil) then
    (REFINAMIENTO::_explica-uno ?sel ?alc ?epoca ?proh ?alerg))
)

;;; =========================================================
;;; Regla de explicación 
;;; =========================================================
(defrule REFINAMIENTO::explicar-eleccion-menus
  ?ctrl <- (control_refinamiento (estado pasteles_buscados))
  ?e <- (object (is-a Evento)
                (sucede_en ?epoca)
                (alergias $?alergenos)
                (prohibe_ingredientes $?prohibidos))
  ?cond <- (condiciones_evento (alcohol ?alc))
  ?m <- (menus_elegidos
          (omnivoro ?p_omn)
          (vegetariano ?p_veg)
          (vegano ?p_vega)
          (halal ?p_hal))
  =>
  (modify ?ctrl (estado explicacion_realizada))
  (printout t crlf "========== EXPLICACIÓN DE LAS ELECCIONES ==========" crlf)
  (if (> ?p_omn 0.0)  then (REFINAMIENTO::_explica-desde-lista (send ?e get-menus_omnivoros)     ?p_omn  ?alc ?epoca ?prohibidos ?alergenos))
  (if (> ?p_veg 0.0)  then (REFINAMIENTO::_explica-desde-lista (send ?e get-menus_vegetarianos)  ?p_veg  ?alc ?epoca ?prohibidos ?alergenos))
  (if (> ?p_vega 0.0) then (REFINAMIENTO::_explica-desde-lista (send ?e get-menus_veganos)       ?p_vega ?alc ?epoca ?prohibidos ?alergenos))
  (if (> ?p_hal 0.0)  then (REFINAMIENTO::_explica-desde-lista (send ?e get-menus_halal)         ?p_hal  ?alc ?epoca ?prohibidos ?alergenos))
  (printout t "===================================================" crlf)
)

;;; =========================================================
;;; Regla de cálculo del presupuesto final
;;; =========================================================

(defrule REFINAMIENTO::acabar
   ?m <- (menus_elegidos (omnivoro ?precio_omnivoro)
                         (vegetariano ?precio_vegetariano)
                         (vegano ?precio_vegano)
                         (halal ?precio_halal)
                         (pastel ?precio_pastel))
   ?cond <- (condiciones_evento  (dietas_omnivoras ?omn)
                                 (dietas_vegetarianas ?veget)
                                 (dietas_veganas ?vega)
                                 (dietas_halal ?hal))
   ?c <- (control_refinamiento (estado explicacion_realizada))
   =>
   (modify ?c (estado acabado))
   (bind ?precio_menus 0.0)
   (bind ?precio_menus (+ ?precio_menus (* ?omn ?precio_omnivoro)))
   (bind ?precio_menus (+ ?precio_menus (* ?veget ?precio_vegetariano)))
   (bind ?precio_menus (+ ?precio_menus (* ?vega ?precio_vegano)))
   (bind ?precio_menus (+ ?precio_menus (* ?hal ?precio_halal)))
   (bind ?precio_total (+ ?precio_menus ?precio_pastel))
   (printout t crlf "PRESUPUESTO FINAL: " ?precio_total "€" crlf)
   (if (> ?precio_pastel 0) then
      (printout t crlf "- Precio de los menús: " ?precio_menus "€" crlf)
      (printout t crlf "- Precio del pastel: " ?precio_pastel "€" crlf)
   )
)