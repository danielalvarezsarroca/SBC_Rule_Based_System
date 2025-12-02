;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main.clp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule MAIN (export ?ALL))

; --------------------------
; TEMPLATE EVENTO
; --------------------------

(deftemplate condiciones_evento
    (slot tipo  (type SYMBOL) (allowed-symbols Evento_familiar Congreso Indefinido) (default Indefinido))
    (slot epoca (type SYMBOL) (allowed-symbols Verano Invierno Primavera Otono Indefinido) (default Indefinido))
    (slot asistentes (type INTEGER) (default 0))
    (slot alcohol (type SYMBOL) (allowed-symbols si no Indefinido) (default si))
    (slot estilo (type SYMBOL) (allowed-symbols Sibarita Moderno Clasico Any Indefinido) (default Any))   
    (slot presupuesto (type FLOAT) (default 0.0))
    (slot presupuesto_pastel (type FLOAT) (default 0.0))
    (slot dietas_omnivoras (type INTEGER) (default 0))
    (slot dietas_veganas (type INTEGER) (default 0))
    (slot dietas_vegetarianas (type INTEGER) (default 0))
    (slot dietas_halal (type INTEGER) (default 0))
    (slot alergias_a_altramuces (type SYMBOL) (default FALSE))
    (slot alergias_a_apio (type SYMBOL) (default FALSE))
    (slot alergias_a_cacahuetes (type SYMBOL) (default FALSE))
    (slot alergias_a_crustaceos (type SYMBOL) (default FALSE))
    (slot alergias_a_frutos_cascara (type SYMBOL) (default FALSE))
    (slot alergias_a_huevo (type SYMBOL) (default FALSE))
    (slot alergias_a_lactosa (type SYMBOL) (default FALSE))
    (slot alergias_a_moluscos (type SYMBOL) (default FALSE))
    (slot alergias_a_mostaza (type SYMBOL) (default FALSE))
    (slot alergias_a_sesamo (type SYMBOL) (default FALSE))
    (slot alergias_a_soja (type SYMBOL) (default FALSE))
    (slot alergias_a_sulfitos (type SYMBOL) (default FALSE))
    (slot alergias_a_gluten (type SYMBOL) (default FALSE))
    (slot alergias_a_pescado (type SYMBOL) (default FALSE))
    (slot temperatura_primero (type SYMBOL) (allowed-symbols Frio Caliente Any Indefinido) (default Any))
    (slot temperatura_segundo (type SYMBOL) (allowed-symbols Frio Caliente Any Indefinido) (default Any))
    (slot temperatura_postre (type SYMBOL) (allowed-symbols Frio Caliente Any Indefinido) (default Any))
    (multislot ingredientes_prohibidos (type SYMBOL))
    (slot dieta_pastel (type SYMBOL) (allowed-symbols Omnivora Vegano Vegetariano Halal Indefinido))
)

; --------------------------
; ONTOLOGÍA
; --------------------------

(defclass Bebida
  (is-a USER)
  (role concrete)
  (pattern-match reactive)

  ; Precio de la bebida
  (slot Precio
    (type FLOAT)
    (create-accessor read-write))

  ; Ingredientes que componen la bebida (para razonar igual que con platos)
  (multislot usa_ingrediente
    (type INSTANCE)
    (allowed-classes Ingredientes)
    (create-accessor read-write))

  ; A qué dietas es apta / recomendada (Omnivora, Vegetariano, Vegano, Halal...)
  (multislot es_apta_para
    (type INSTANCE)
    (allowed-classes Dieta)
    (create-accessor read-write))

  ; Alérgenos que contiene (Alergia_a_huevos, Alergia_a_lactosa, etc.)
  (multislot contiene_alergenos
    (type INSTANCE)
    (allowed-classes Alergia)
    (create-accessor read-write))

  ; Ingredientes o tipos de ingredientes con los que esta bebida marida bien
  (multislot marida_con
    (type INSTANCE)
    (allowed-classes Ingredientes)
    (create-accessor read-write))

  ; Épocas del año en las que la bebida está disponible o se suele consumir
  (multislot disponible_en
    (type INSTANCE)
    (allowed-classes Epoca_del_ano)
    (create-accessor read-write))
)


(defclass Con_alcohol
    (is-a Bebida)
    (role concrete)
    (pattern-match reactive)
)

(defclass Sin_alcohol
    (is-a Bebida)
    (role concrete)
    (pattern-match reactive)
)

(defclass Epoca_del_ano
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Plato
    (is-a USER)
    (role concrete)
    (pattern-match reactive)

    ; Bebidas con las que se suele servir el plato
    (multislot se_sirve_con
        (type INSTANCE)
        (allowed-classes Bebida)
        (create-accessor read-write))

    ; Épocas del año en las que se sirve tradicionalmente el plato
    (multislot se_sirve_en
        (type INSTANCE)
        (allowed-classes Epoca_del_ano)
        (create-accessor read-write))

    ; Épocas del año en las que el plato está disponible (por ingredientes o temporada)
    (multislot disponible_en
        (type INSTANCE)
        (allowed-classes Epoca_del_ano)
        (create-accessor read-write))

    ; Estilo de comida (Clasico, Moderno, Sibarita...)
    (slot tiene_estilo
        (type INSTANCE)
        (allowed-classes Estilo_de_comida)
        (create-accessor read-write))

    ; Temperatura a la que se sirve (Caliente o Frio)
    (slot tiene_temperatura
        (type INSTANCE)
        (allowed-classes Temperatura)
        (create-accessor read-write))

    ; Ingredientes que usa el plato
    (multislot usa_ingrediente
        (type INSTANCE)
        (allowed-classes Ingredientes)
        (create-accessor read-write))

    ; Alérgenos que contiene el plato
    (multislot contiene_alergenos
        (type INSTANCE)
        (allowed-classes Alergia)
        (create-accessor read-write))

    ; Dietas para las que es apto (Omnivora, Vegetariano, Vegano, Halal...)
    (multislot es_apto_para
        (type INSTANCE)
        (allowed-classes Dieta)
        (create-accessor read-write))

    ; Precio del plato
    (slot Precio
        (type FLOAT)
        (create-accessor read-write))
)


(defclass Postre
    (is-a Plato)
    (role concrete)
    (pattern-match reactive)
)

(defclass Primero
    (is-a Plato)
    (role concrete)
    (pattern-match reactive)
)

(defclass Segundo
    (is-a Plato)
    (role concrete)
    (pattern-match reactive)
)

(defclass Restriccion
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Estilo_de_comida
    (is-a Restriccion)
    (role concrete)
    (pattern-match reactive)
)

(defclass Restriccion_del_tipo_de_comida
    (is-a Restriccion)
    (role concrete)
    (pattern-match reactive)
)

(defclass Alergia
    (is-a Restriccion_del_tipo_de_comida)
    (role concrete)
    (pattern-match reactive)
)

(defclass Dieta
    (is-a Restriccion_del_tipo_de_comida)
    (role concrete)
    (pattern-match reactive)
)

(defclass Temperatura
    (is-a Restriccion)
    (role concrete)
    (pattern-match reactive)
)


(defclass Evento
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot menus_omnivoros
        (type INSTANCE)
        (allowed-classes Menu)
        (create-accessor read-write)
        (default (create$)))
    (multislot menus_vegetarianos
        (type INSTANCE)
        (allowed-classes Menu)
        (create-accessor read-write)
        (default (create$)))
    (multislot menus_veganos
        (type INSTANCE)
        (allowed-classes Menu)
        (create-accessor read-write)
        (default (create$)))
    (multislot menus_halal
        (type INSTANCE)
        (allowed-classes Menu)
        (create-accessor read-write)
        (default (create$)))
    (slot sucede_en
        (type INSTANCE)
        (allowed-classes Epoca_del_ano)
        (create-accessor read-write))
    (slot tiene_restriccion_estilo
        (type INSTANCE)
        (allowed-classes Estilo_de_comida)
        (create-accessor read-write))
    (slot tiene_restriccion_temperatura_primero
        (type INSTANCE)
        (allowed-classes Temperatura)
        (create-accessor read-write))
    (slot tiene_restriccion_temperatura_segundo
        (type INSTANCE)
        (allowed-classes Temperatura)
        (create-accessor read-write))
    (slot tiene_restriccion_temperatura_postre
        (type INSTANCE)
        (allowed-classes Temperatura)
        (create-accessor read-write))
    (multislot prohibe_ingredientes
        (type INSTANCE)
        (allowed-classes Ingredientes)
        (create-accessor read-write))
   (multislot dietas
        (type INSTANCE)
        (allowed-classes Dieta)
        (create-accessor read-write))
   (multislot alergias
        (type INSTANCE)
        (allowed-classes Alergia)
        (create-accessor read-write))
)


(defclass Congreso
    (is-a Evento)
    (role concrete)
    (pattern-match reactive)
)

(defclass Evento_familiar
    (is-a Evento)
    (role concrete)
    (pattern-match reactive)
    (slot tiene_pastel
        (type INSTANCE)
        (allowed-classes Pastel)
        (create-accessor read-write))
)

(defclass Ingredientes
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot disponible_en
        (type INSTANCE)
        (allowed-classes Epoca_del_ano)
        (create-accessor read-write))
)

(defclass Carne
    (is-a Ingredientes)
    (role concrete)
    (pattern-match reactive)
)

(defclass Cereal
    (is-a Ingredientes)
    (role concrete)
    (pattern-match reactive)
)

(defclass Fruta
    (is-a Ingredientes)
    (role concrete)
    (pattern-match reactive)
)

(defclass Frutos_secos
    (is-a Ingredientes)
    (role concrete)
    (pattern-match reactive)
)

(defclass Lacteos
    (is-a Ingredientes)
    (role concrete)
    (pattern-match reactive)
)

(defclass Legumbre
    (is-a Ingredientes)
    (role concrete)
    (pattern-match reactive)
)

(defclass Marisco
    (is-a Ingredientes)
    (role concrete)
    (pattern-match reactive)
)

(defclass Pescado
    (is-a Ingredientes)
    (role concrete)
    (pattern-match reactive)
)

(defclass Verdura
    (is-a Ingredientes)
    (role concrete)
    (pattern-match reactive)
)

(defclass Huevos
    (is-a Ingredientes)
    (role concrete)
    (pattern-match reactive)
)

(defclass Agua
    (is-a Ingredientes)
    (role concrete)
    (pattern-match reactive)
)

(defclass Menu
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot tiene_postre
        (type INSTANCE)
        (allowed-classes Postre)
        (create-accessor read-write))
    (slot tiene_primero
        (type INSTANCE)
        (allowed-classes Primero)
        (create-accessor read-write))
    (slot tiene_bebida_primero
        (type INSTANCE)
        (allowed-classes Bebida)
        (create-accessor read-write))
    (slot tiene_segundo
        (type INSTANCE)
        (allowed-classes Segundo)
        (create-accessor read-write))
    (slot tiene_bebida_segundo
        (type INSTANCE)
        (allowed-classes Bebida)
        (create-accessor read-write))
    (multislot bebidas_extras
        (type INSTANCE)
        (allowed-classes Bebida)
        (create-accessor read-write))
    (slot sigue_dieta
        (type SYMBOL)
        (create-accessor read-write))
    (slot precio 
        (type FLOAT)
        (create-accessor read-write))
    (slot tipo_segun_precio 
        (type SYMBOL)
        (create-accessor read-write))
)

(defclass Pastel
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot tiene_temperatura
        (type INSTANCE)
        (allowed-classes Temperatura)
        (create-accessor read-write))
    (slot tiene_estilo
        (type INSTANCE)
        (allowed-classes Estilo_de_comida)
        (create-accessor read-write))
    (multislot se_sirve_en
        (type INSTANCE)
        (allowed-classes Epoca_del_ano)
        (create-accessor read-write))
    (multislot usa_ingrediente
        (type INSTANCE)
        (allowed-classes Ingredientes)
        (create-accessor read-write))
    (multislot es_apto_para
        (type INSTANCE)
        (allowed-classes Dieta)
        (create-accessor read-write))
    (multislot contiene_alergenos
        (type INSTANCE)
        (allowed-classes Alergia)
        (create-accessor read-write))
    (slot Precio
        (type FLOAT)
        (create-accessor read-write))
)

; --------------------------
; INSTANCIAS VARIAS
; --------------------------
(definstances generado
  ([Invierno] of Epoca_del_ano)
  ([Primavera] of Epoca_del_ano)
  ([Verano] of Epoca_del_ano)
  ([Otono] of Epoca_del_ano)
  ([Caliente] of Temperatura)
  ([Frio] of Temperatura)
  ([Clasico] of Estilo_de_comida)
  ([Moderno] of Estilo_de_comida)
  ([Sibarita] of Estilo_de_comida)
  ([AnyEstilo] of Estilo_de_comida)
  ([Halal] of Dieta)
  ([Omnivora] of Dieta)
  ([Vegano] of Dieta)
  ([Vegetariano] of Dieta)
  ([Alergia_a_frutos_con_cascara] of Alergia)
  ([Alergia_a_huevos] of Alergia)
  ([Alergia_a_lactosa] of Alergia)
  ([Alergia_a_soja] of Alergia)
  ([Alergia_a_sulfitos] of Alergia)
  ([Alergia_al_gluten] of Alergia)
  ([Alergia_al_pescado] of Alergia)
  ([Alergia_a_altramuces] of Alergia)
  ([Alergia_a_apio] of Alergia)
  ([Alergia_a_cacahuetes] of Alergia)
  ([Alergia_a_crustaceos] of Alergia)
  ([Alergia_a_moluscos] of Alergia)
  ([Alergia_a_mostaza] of Alergia)
  ([Alergia_a_sesamo] of Alergia)
)

; --------------------------
; INSTANCIAS DE INGREDIENTES
; --------------------------

(definstances ingredientes
  ;;; Ingredientes
  ([Aceitunas] of Fruta
     (disponible_en [Otono])
  )
  ([Acelgas] of Verdura
     (disponible_en [Invierno] [Primavera])
  )
  ([Ajo] of Verdura
     (disponible_en [Primavera] [Verano])
  )
  ([Albahaca] of Verdura
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Alcachofa] of Verdura
     (disponible_en [Invierno] [Primavera])
  )
  ([Almendras] of Frutos_secos
     (disponible_en [Otono])
  )
  ([Altramuces] of Legumbre
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Alubias_blancas] of Legumbre
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Apio] of Verdura
     (disponible_en [Otono] [Invierno] [Primavera])
  )
  ([Arroz] of Cereal
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Atun] of Pescado
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Avellanas] of Frutos_secos
     (disponible_en [Otono])
  )
  ([Bacalao] of Pescado
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Berenjena] of Verdura
     (disponible_en [Verano])
  )
  ([Bonito] of Pescado
     (disponible_en [Verano])
  )
  ([Bulgur] of Cereal
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Cacahuetes] of Frutos_secos
     (disponible_en [Otono])
  )
  ([Calabacin] of Verdura
     (disponible_en [Verano] [Otono])
  )
  ([Calamar] of Marisco
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Cebada] of Cereal
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Cebolla] of Verdura
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Centeno] of Cereal
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Cerdo] of Carne
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Champinones] of Verdura
     (disponible_en [Otono] [Invierno])
  )
  ([Cordero] of Carne
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Cuscus] of Cereal
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Dorada] of Pescado
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Espinacas] of Verdura
     (disponible_en [Invierno] [Primavera])
  )
  ([Gamba] of Marisco
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Garbanzos] of Legumbre
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Granada] of Fruta
     (disponible_en [Otono])
  )
  ([Habas] of Legumbre
     (disponible_en [Primavera])
  )
  ([Harina_de_trigo] of Cereal
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Higo] of Fruta
     (disponible_en [Verano])
  )
  ([Hinojo] of Verdura
     (disponible_en [Otono] [Invierno] [Verano])
  )
  ([Huevo] of Huevos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Judiones] of Legumbre
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Langostino] of Marisco
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Leche] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Lechuga_romana] of Verdura
     (disponible_en [Primavera] [Verano])
  )
  ([Lentejas] of Legumbre
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Limon] of Fruta
     (disponible_en [Invierno] [Primavera])
  )
  ([Lubina] of Pescado
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Maiz] of Cereal
     (disponible_en [Verano] [Otono])
  )
  ([Manzana] of Fruta
     (disponible_en [Otono] [Invierno])
  )
  ([Masa_de_pizza] of Cereal
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Mejillon] of Marisco
     (disponible_en [Otono] [Invierno] [Primavera])
  )
  ([Melocoton] of Fruta
     (disponible_en [Verano])
  )
  ([Melon] of Fruta
     (disponible_en [Verano])
  )
  ([Menta] of Verdura
     (disponible_en [Primavera] [Verano])
  )
  ([Merluza] of Pescado
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Mozzarella] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Naranja] of Fruta
     (disponible_en [Invierno])
  )
  ([Nueces] of Frutos_secos
     (disponible_en [Otono])
  )
  ([Oregano] of Verdura
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Pan_de_trigo] of Cereal
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Pasta] of Cereal
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Patata] of Verdura
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Pepino] of Verdura
     (disponible_en [Verano])
  )
  ([Pera] of Fruta
     (disponible_en [Otono])
  )
  ([Perejil] of Verdura
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Pimiento_rojo] of Verdura
     (disponible_en [Verano] [Otono])
  )
  ([Pimiento_verde] of Verdura
     (disponible_en [Verano] [Otono])
  )
  ([Pinones] of Frutos_secos
     (disponible_en [Otono])
  )
  ([Pistachos] of Frutos_secos
     (disponible_en [Otono])
  )
  ([Pollo] of Carne
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Pulpo] of Marisco
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Queso_feta] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Queso_manchego] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Quinoa] of Cereal
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Remolacha] of Verdura
     (disponible_en [Otono] [Invierno])
  )
  ([Ricotta] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Rucula] of Verdura
     (disponible_en [Primavera] [Otono])
  )
  ([Sandia] of Fruta
     (disponible_en [Verano])
  )
  ([Sardinas] of Pescado
     (disponible_en [Verano])
  )
  ([Sesamo] of Frutos_secos
     (disponible_en [Otono] [Verano])
  )
  ([Setas] of Verdura
     (disponible_en [Otono])
  )
  ([Ternera] of Carne
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Tofu_de_soja] of Legumbre
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Tomate] of Verdura
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Tomillo] of Verdura
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Uva] of Fruta
     (disponible_en [Otono])
  )
  ([Yogur_griego] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Zanahoria] of Verdura
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
)

(definstances ingredientes_bebidas
  ;;; Ingredientes usados en bebidas con su disponibilidad estacional

  ([Uva] of Fruta
     (disponible_en [Otono])
  )
  ([Cebada] of Cereal
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Centeno] of Cereal
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Limon] of Fruta
     (disponible_en [Invierno] [Primavera])
  )
  ([Naranja] of Fruta
     (disponible_en [Invierno])
  )
  ([Menta] of Verdura
     (disponible_en [Primavera] [Verano])
  )
  ([Tomillo] of Verdura
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Oregano] of Verdura
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Manzana] of Fruta
     (disponible_en [Otono] [Invierno])
  )
  ([Pera] of Fruta
     (disponible_en [Otono])
  )
  ([Melocoton] of Fruta
     (disponible_en [Verano])
  )
  ([Melon] of Fruta
     (disponible_en [Verano])
  )
  ([Granada] of Fruta
     (disponible_en [Otono])
  )
  ([Higo] of Fruta
     (disponible_en [Verano])
  )
  ([Pepino] of Verdura
     (disponible_en [Verano])
  )
  ([Tomate] of Verdura
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Apio] of Verdura
     (disponible_en [Otono] [Invierno] [Primavera])
  )
  ([Almendras] of Frutos_secos
     (disponible_en [Otono])
  )
  ([Agua] of Agua
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
)

; --------------------------
; INSTANCIAS DE BEBIDAS
; --------------------------
(definstances bebidas

  ;;; -------------------------
  ;;; BEBIDAS (75)
  ;;; -------------------------

  ;;; BEBIDAS CON ALCOHOL (1–25)

  ([Vino_tinto_crianza] of Con_alcohol
     (Precio 8.9)
     (usa_ingrediente [Uva])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Carne] [Lacteos] [Legumbre])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Vino_blanco_joven] of Con_alcohol
     (Precio 7.5)
     (usa_ingrediente [Uva])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Pescado] [Marisco] [Verdura])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Vino_rosado] of Con_alcohol
     (Precio 7.2)
     (usa_ingrediente [Uva])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Legumbre] [Verdura] [Pescado])
     (disponible_en [Primavera] [Verano])
  )

  ([Cava_brut] of Con_alcohol
     (Precio 9.8)
     (usa_ingrediente [Uva])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Pescado] [Marisco] [Verdura])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Prosecco] of Con_alcohol
     (Precio 8.2)
     (usa_ingrediente [Uva])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Marisco] [Pescado] [Verdura])
     (disponible_en [Primavera] [Verano])
  )

  ([Manzanilla_sherry] of Con_alcohol
     (Precio 8.0)
     (usa_ingrediente [Uva])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Marisco] [Pescado])
     (disponible_en [Primavera] [Verano] [Otono])
  )

  ([Fino_sherry] of Con_alcohol
     (Precio 8.3)
     (usa_ingrediente [Uva])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Pescado] [Marisco] [Verdura])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Vermut_rojo] of Con_alcohol
     (Precio 4.8)
     (usa_ingrediente [Uva] [Naranja])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Carne] [Pescado] [Verdura])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Vermut_blanco] of Con_alcohol
     (Precio 4.8)
     (usa_ingrediente [Uva] [Limon])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Pescado] [Marisco] [Verdura])
     (disponible_en [Primavera] [Verano] [Otono])
  )

  ([Tinto_de_verano] of Con_alcohol
     (Precio 4.2)
     (usa_ingrediente [Uva] [Limon])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Carne] [Verdura] [Cereal])
     (disponible_en [Verano])
  )

  ([Clara_con_limon] of Con_alcohol
     (Precio 3.8)
     (usa_ingrediente [Cebada] [Limon])
     (es_apta_para [Omnivora] [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
     (marida_con [Pescado] [Marisco] [Carne] [Verdura])
     (disponible_en [Primavera] [Verano])
  )

  ([Cerveza_lager] of Con_alcohol
     (Precio 3.5)
     (usa_ingrediente [Cebada])
     (es_apta_para [Omnivora] [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
     (marida_con [Carne] [Marisco] [Pescado] [Cereal])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Cerveza_ipa] of Con_alcohol
     (Precio 4.2)
     (usa_ingrediente [Cebada])
     (es_apta_para [Omnivora] [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
     (marida_con [Carne] [Legumbre] [Verdura])
     (disponible_en [Primavera] [Verano] [Otono])
  )

  ([Cerveza_trigo] of Con_alcohol
     (Precio 4.0)
     (usa_ingrediente [Cebada] [Centeno])
     (es_apta_para [Omnivora] [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
     (marida_con [Pescado] [Marisco] [Verdura])
     (disponible_en [Primavera] [Verano])
  )

  ([Spritz_mediterraneo] of Con_alcohol
     (Precio 6.5)
     (usa_ingrediente [Naranja] [Uva])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Marisco] [Pescado] [Verdura])
     (disponible_en [Primavera] [Verano])
  )

  ([Gintonic_clasico] of Con_alcohol
     (Precio 7.0)
     (usa_ingrediente [Limon])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (marida_con [Pescado] [Marisco] [Verdura])
     (disponible_en [Primavera] [Verano] [Otono])
  )

  ([Negroni] of Con_alcohol
     (Precio 7.8)
     (usa_ingrediente [Uva] [Naranja])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Carne] [Legumbre] [Verdura])
     (disponible_en [Otono] [Invierno])
  )

  ([Campari_soda] of Con_alcohol
     (Precio 6.2)
     (usa_ingrediente [Naranja])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Verdura] [Pescado] [Marisco])
     (disponible_en [Primavera] [Verano])
  )

  ([Aperitivo_herbal] of Con_alcohol
     (Precio 6.0)
     (usa_ingrediente [Menta] [Tomillo])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Verdura] [Legumbre] [Pescado])
     (disponible_en [Primavera] [Verano])
  )

  ([Vermut_en_sifon] of Con_alcohol
     (Precio 5.0)
     (usa_ingrediente [Uva])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Carne] [Pescado] [Verdura] [Cereal])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Txakoli] of Con_alcohol
     (Precio 8.1)
     (usa_ingrediente [Uva])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Pescado] [Marisco] [Verdura])
     (disponible_en [Primavera] [Verano] [Otono])
  )

  ([Albarino] of Con_alcohol
     (Precio 9.0)
     (usa_ingrediente [Uva])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Marisco] [Pescado] [Verdura])
     (disponible_en [Verano] [Otono] [Primavera])
  )

  ([Tempranillo_joven] of Con_alcohol
     (Precio 7.9)
     (usa_ingrediente [Uva])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Carne] [Legumbre] [Lacteos])
     (disponible_en [Invierno] [Otono] [Primavera] [Verano])
  )

  ([Gran_reserva_tinto] of Con_alcohol
     (Precio 12.5)
     (usa_ingrediente [Uva])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Carne] [Lacteos])
     (disponible_en [Invierno] [Otono])
  )

  ([Rosado_de_garnacha] of Con_alcohol
     (Precio 7.4)
     (usa_ingrediente [Uva])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Verdura] [Pescado] [Legumbre])
     (disponible_en [Primavera] [Verano])
  )

  ([Rebujito] of Con_alcohol
     (Precio 5.5)
     (usa_ingrediente [Uva] [Menta])
     (es_apta_para [Omnivora] [Vegetariano] [Vegano])
     (contiene_alergenos [Alergia_a_sulfitos])
     (marida_con [Marisco] [Pescado] [Verdura])
     (disponible_en [Primavera] [Verano])
  )

  ;;; BEBIDAS SIN ALCOHOL (26–75)

  ([Agua_mineral] of Sin_alcohol
     (Precio 2.0)
     (usa_ingrediente [Agua])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Carne] [Pescado] [Marisco] [Verdura] [Legumbre] [Cereal] [Lacteos] [Huevos] [Fruta] [Frutos_secos])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Agua_con_gas] of Sin_alcohol
     (Precio 2.2)
     (usa_ingrediente [Agua])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Pescado] [Marisco] [Verdura] [Lacteos] [Legumbre])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Tonica] of Sin_alcohol
     (Precio 2.6)
     (usa_ingrediente [Limon])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Pescado] [Marisco] [Verdura])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Gaseosa] of Sin_alcohol
     (Precio 2.1)
     (usa_ingrediente [Agua])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Carne] [Cereal] [Verdura])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Refresco_de_naranja] of Sin_alcohol
     (Precio 2.5)
     (usa_ingrediente [Naranja])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Carne] [Verdura] [Cereal])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Refresco_de_limon] of Sin_alcohol
     (Precio 2.5)
     (usa_ingrediente [Limon])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Pescado] [Marisco] [Verdura])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Refresco_cola_seco] of Sin_alcohol
     (Precio 2.5)
     (usa_ingrediente [Agua])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Carne] [Legumbre] [Cereal])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Bitter_herbal] of Sin_alcohol
     (Precio 2.9)
     (usa_ingrediente [Tomillo] [Menta] [Naranja])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Pescado] [Marisco] [Verdura])
     (disponible_en [Primavera] [Verano])
  )

  ([Kombucha_natural] of Sin_alcohol
     (Precio 3.2)
     (usa_ingrediente [Manzana])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora])
     (marida_con [Verdura] [Legumbre] [Cereal])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Mosto_blanco] of Sin_alcohol
     (Precio 2.8)
     (usa_ingrediente [Uva])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Pescado] [Marisco] [Lacteos])
     (disponible_en [Primavera] [Otono])
  )

  ([Zumo_naranja_natural] of Sin_alcohol
     (Precio 3.0)
     (usa_ingrediente [Naranja])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Verdura] [Pescado] [Marisco])
     (disponible_en [Invierno] [Primavera])
  )

  ([Zumo_de_tomate] of Sin_alcohol
     (Precio 2.9)
     (usa_ingrediente [Tomate] [Apio])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (contiene_alergenos [Alergia_a_apio])
     (marida_con [Marisco] [Pescado] [Carne] [Verdura])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Agua_con_limon] of Sin_alcohol
     (Precio 2.2)
     (usa_ingrediente [Limon])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Pescado] [Marisco] [Verdura] [Legumbre])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Tisana_de_hierbas] of Sin_alcohol
     (Precio 2.4)
     (usa_ingrediente [Tomillo] [Menta] [Oregano])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Verdura] [Legumbre] [Lacteos])
     (disponible_en [Otono] [Invierno] [Primavera])
  )

  ([Te_frio_limon] of Sin_alcohol
     (Precio 2.6)
     (usa_ingrediente [Limon])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Verdura] [Pescado] [Marisco])
     (disponible_en [Primavera] [Verano])
  )

  ([Te_frio_melocoton] of Sin_alcohol
     (Precio 2.6)
     (usa_ingrediente [Melocoton])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Verdura] [Cereal] [Lacteos])
     (disponible_en [Verano])
  )

  ([Soda_de_naranja_amarga] of Sin_alcohol
     (Precio 2.7)
     (usa_ingrediente [Naranja])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Pescado] [Marisco] [Verdura])
     (disponible_en [Primavera] [Verano])
  )

  ([Zumo_de_uva_blanca] of Sin_alcohol
     (Precio 2.9)
     (usa_ingrediente [Uva])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Pescado] [Marisco] [Lacteos])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Aquarius_limon_style] of Sin_alcohol
     (Precio 2.5)
     (usa_ingrediente [Limon])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Verdura] [Legumbre] [Cereal])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Tonica_con_romero] of Sin_alcohol
     (Precio 2.8)
     (usa_ingrediente [Tomillo])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Pescado] [Marisco] [Verdura])
     (disponible_en [Primavera] [Verano] [Otono])
  )

  ([Sifon] of Sin_alcohol
     (Precio 2.1)
     (usa_ingrediente [Agua])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Carne] [Pescado] [Verdura] [Cereal])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Zumo_de_manzana] of Sin_alcohol
     (Precio 2.7)
     (usa_ingrediente [Manzana])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Carne] [Lacteos] [Legumbre])
     (disponible_en [Otono] [Invierno])
  )

  ([Zumo_de_pera] of Sin_alcohol
     (Precio 2.7)
     (usa_ingrediente [Pera])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Lacteos] [Cereal] [Legumbre])
     (disponible_en [Otono] [Invierno])
  )

  ([Zumo_de_melocoton] of Sin_alcohol
     (Precio 2.8)
     (usa_ingrediente [Melocoton])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Lacteos] [Cereal] [Verdura])
     (disponible_en [Verano])
  )

  ([Agua_de_pepino_limon] of Sin_alcohol
     (Precio 2.3)
     (usa_ingrediente [Pepino] [Limon])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Verdura] [Pescado] [Marisco])
     (disponible_en [Primavera] [Verano])
  )

  ([Zumo_de_uva_tinta_suave] of Sin_alcohol
     (Precio 3.0)
     (usa_ingrediente [Uva])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Carne] [Lacteos] [Legumbre])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Zumo_de_granada_suave] of Sin_alcohol
     (Precio 3.2)
     (usa_ingrediente [Granada])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Lacteos] [Legumbre] [Verdura])
     (disponible_en [Otono])
  )

  ([Zumo_de_higo] of Sin_alcohol
     (Precio 3.1)
     (usa_ingrediente [Higo])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Lacteos] [Legumbre])
     (disponible_en [Verano])
  )

  ([Zumo_de_melon] of Sin_alcohol
     (Precio 2.9)
     (usa_ingrediente [Melon])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Verdura] [Pescado] [Marisco])
     (disponible_en [Verano])
  )

  ([Refresco_de_citricos] of Sin_alcohol
     (Precio 2.6)
     (usa_ingrediente [Limon] [Naranja])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Verdura] [Pescado])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Agua_de_naranja_y_menta] of Sin_alcohol
     (Precio 2.4)
     (usa_ingrediente [Naranja] [Menta])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Pescado] [Marisco] [Verdura])
     (disponible_en [Primavera] [Verano])
  )

  ([Agua_de_manzana_y_tomillo] of Sin_alcohol
     (Precio 2.4)
     (usa_ingrediente [Manzana] [Tomillo])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Carne] [Lacteos] [Cereal])
     (disponible_en [Otono] [Invierno])
  )

  ([Zumo_de_pepino_suave] of Sin_alcohol
     (Precio 2.5)
     (usa_ingrediente [Pepino])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Verdura] [Pescado] [Marisco])
     (disponible_en [Primavera] [Verano])
  )

  ([Zumo_de_tomate_con_apio] of Sin_alcohol
     (Precio 3.0)
     (usa_ingrediente [Tomate] [Apio])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (contiene_alergenos [Alergia_a_apio])
     (marida_con [Marisco] [Pescado] [Carne] [Verdura])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Horchata_de_almendras] of Sin_alcohol
     (Precio 3.1)
     (usa_ingrediente [Almendras])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (marida_con [Verdura] [Cereal] [Legumbre])
     (disponible_en [Verano])
  )

  ([Mosto_tinto_suave] of Sin_alcohol
     (Precio 2.9)
     (usa_ingrediente [Uva])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Carne] [Lacteos] [Legumbre])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Soda_de_granada] of Sin_alcohol
     (Precio 2.7)
     (usa_ingrediente [Granada])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Lacteos] [Verdura])
     (disponible_en [Otono])
  )

  ([Refresco_hierbas_citricos] of Sin_alcohol
     (Precio 2.6)
     (usa_ingrediente [Menta] [Tomillo] [Limon])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Pescado] [Marisco] [Verdura])
     (disponible_en [Primavera] [Verano])
  )

  ([Refresco_de_granada] of Sin_alcohol
     (Precio 2.8)
     (usa_ingrediente [Granada])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Lacteos] [Verdura] [Legumbre])
     (disponible_en [Otono])
  )

  ([Zumo_de_uva_roscado] of Sin_alcohol
     (Precio 2.9)
     (usa_ingrediente [Uva])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Pescado] [Lacteos] [Legumbre])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Refresco_de_manzana_seco] of Sin_alcohol
     (Precio 2.6)
     (usa_ingrediente [Manzana])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Carne] [Lacteos] [Cereal])
     (disponible_en [Otono] [Invierno])
  )

  ([Soda_citrica_suave] of Sin_alcohol
     (Precio 2.5)
     (usa_ingrediente [Limon] [Naranja])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Verdura] [Pescado])
     (disponible_en [Primavera] [Verano])
  )

  ([Refresco_de_pera] of Sin_alcohol
     (Precio 2.6)
     (usa_ingrediente [Pera])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Lacteos] [Cereal])
     (disponible_en [Otono] [Invierno])
  )

  ([Soda_de_melocoton] of Sin_alcohol
     (Precio 2.6)
     (usa_ingrediente [Melocoton])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Verdura] [Lacteos])
     (disponible_en [Verano])
  )

  ([Refresco_de_higo] of Sin_alcohol
     (Precio 2.9)
     (usa_ingrediente [Higo])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Lacteos] [Legumbre])
     (disponible_en [Verano])
  )

  ([Zumo_de_naranja_dulce_seco] of Sin_alcohol
     (Precio 2.7)
     (usa_ingrediente [Naranja])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Carne] [Verdura] [Cereal])
     (disponible_en [Invierno] [Primavera])
  )

  ([Soda_de_pepino] of Sin_alcohol
     (Precio 2.4)
     (usa_ingrediente [Pepino])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Verdura] [Pescado])
     (disponible_en [Primavera] [Verano])
  )

  ([Agua_de_manzana_y_oregano] of Sin_alcohol
     (Precio 2.4)
     (usa_ingrediente [Manzana] [Oregano])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Carne] [Cereal] [Lacteos])
     (disponible_en [Otono] [Invierno])
  )

  ([Refresco_de_tomate_suave] of Sin_alcohol
     (Precio 2.7)
     (usa_ingrediente [Tomate])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Carne] [Pescado] [Legumbre])
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )

  ([Soda_de_limon_y_menta] of Sin_alcohol
     (Precio 2.5)
     (usa_ingrediente [Limon] [Menta])
     (es_apta_para [Vegano] [Vegetariano] [Omnivora] [Halal])
     (marida_con [Pescado] [Verdura] [Marisco])
     (disponible_en [Primavera] [Verano])
  )
)


; ------------------------------------
; INSTANCIAS DE INGREDIENTES PASTELES
; ------------------------------------
(definstances ingredientes_generados
  
  ;;; Ingredientes únicos
  ([Aceite_vegetal] of Ingredientes
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Albaricoque] of Fruta
     (disponible_en [Verano])
  )
  ([Almendra] of Frutos_secos
     (disponible_en [Otono])
  )
  ([Arandanos] of Fruta
     (disponible_en [Verano])
  )
  ([Avellanas] of Frutos_secos
     (disponible_en [Otono])
  )
  ([Azucar] of Ingredientes
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Cacao] of Ingredientes
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Cafe] of Ingredientes
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Canela] of Ingredientes
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Cereza] of Fruta
     (disponible_en [Verano])
  )
  ([Chocolate] of Ingredientes
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Chocolate_blanco] of Ingredientes
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Chocolate_con_leche] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Chocolate_negro] of Ingredientes
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Clara_de_huevo] of Huevos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Coco] of Fruta
     (disponible_en [Verano])
  )
  ([Datil] of Fruta
     (disponible_en [Otono])
  )
  ([Frambuesas] of Fruta
     (disponible_en [Verano])
  )
  ([Fresas] of Fruta
     (disponible_en [Primavera])
  )
  ([Galleta] of Cereal
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Harina] of Cereal
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Huevo] of Huevos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Jengibre] of Ingredientes
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Leche] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Leche_condensada] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Leche_evaporada] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Limon] of Fruta
     (disponible_en [Invierno] [Primavera])
  )
  ([Mango] of Fruta
     (disponible_en [Verano])
  )
  ([Mantequilla] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Manzana] of Fruta
     (disponible_en [Otono])
  )
  ([Maracuya] of Fruta
     (disponible_en [Verano])
  )
  ([Miel] of Ingredientes
     (disponible_en [Primavera] [Verano])
  )
  ([Moras] of Fruta
     (disponible_en [Verano])
  )
  ([Naranja] of Fruta
     (disponible_en [Invierno])
  )
  ([Nata] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Nuez] of Frutos_secos
     (disponible_en [Otono])
  )
  ([Pera] of Fruta
     (disponible_en [Otono])
  )
  ([Pina] of Fruta
     (disponible_en [Verano])
  )
  ([Pistacho] of Frutos_secos
     (disponible_en [Otono])
  )
  ([Queso_crema] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Queso_mascarpone] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Sal] of Ingredientes
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Vainilla] of Ingredientes
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Yogur] of Lacteos
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
  ([Zanahoria] of Verdura
     (disponible_en [Invierno] [Primavera] [Verano] [Otono])
  )
)

; --------------------------
; INSTANCIAS DE PASTELES
; --------------------------
(definstances pasteles
  ([Pastel_de_boda_clasico_de_vainilla] of Pastel
     (Precio 180.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Harina] [Huevo] [Azucar] [Mantequilla] [Vainilla] [Nata])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_naked_de_frutos_rojos] of Pastel
     (Precio 220.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Harina] [Fresas] [Frambuesas] [Arandanos] [Queso_crema] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_red_velvet] of Pastel
     (Precio 240.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Harina] [Cacao] [Huevo] [Queso_crema] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_de_limon_y_merengue] of Pastel
     (Precio 205.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Harina] [Limon] [Azucar] [Clara_de_huevo] [Mantequilla])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_tres_leches] of Pastel
     (Precio 195.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Harina] [Leche_condensada] [Leche_evaporada] [Huevo] [Azucar])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_chocolate_intenso] of Pastel
     (Precio 250.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Harina] [Cacao] [Huevo] [Mantequilla] [Nata] [Azucar])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_citricos_y_amapola] of Pastel
     (Precio 210.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Harina] [Limon] [Naranja] [Huevo] [Yogur] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_queso_y_arandanos] of Pastel
     (Precio 230.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Queso_crema] [Harina] [Arandanos] [Azucar] [Nata])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_zanahoria_y_nuez] of Pastel
     (Precio 215.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Otono])
     (usa_ingrediente [Zanahoria] [Nuez] [Harina] [Huevo] [Queso_crema] [Azucar] [Canela])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_coco_y_pina] of Pastel
     (Precio 225.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Coco] [Pina] [Harina] [Huevo] [Azucar] [Mantequilla])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_frutos_del_bosque] of Pastel
     (Precio 260.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Fresas] [Frambuesas] [Moras] [Harina] [Queso_crema] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_moka] of Pastel
     (Precio 235.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Cafe] [Harina] [Mantequilla] [Huevo] [Azucar])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_vainilla_y_caramelo] of Pastel
     (Precio 205.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Otono])
     (usa_ingrediente [Harina] [Azucar] [Huevo] [Mantequilla] [Nata])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_pistacho_y_frambuesa] of Pastel
     (Precio 270.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pistacho] [Frambuesas] [Harina] [Queso_crema] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_sin_huevo_vegano] of Pastel
     (Precio 190.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Harina] [Aceite_vegetal] [Azucar] [Fresas] [Vainilla])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_de_almendra_y_naranja] of Pastel
     (Precio 225.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Otono])
     (usa_ingrediente [Almendra] [Naranja] [Harina] [Huevo] [Azucar])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_tiramisu] of Pastel
     (Precio 255.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Cafe] [Queso_mascarpone] [Cacao] [Azucar] [Huevo] [Harina])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_queso_y_fresa] of Pastel
     (Precio 220.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Queso_crema] [Fresas] [Harina] [Azucar] [Nata])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_pera_y_chocolate] of Pastel
     (Precio 215.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pera] [Cacao] [Harina] [Huevo] [Mantequilla])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_tres_chocolates] of Pastel
     (Precio 295.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Chocolate_negro] [Chocolate_con_leche] [Chocolate_blanco] [Harina] [Nata] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_limon_y_arandanos] of Pastel
     (Precio 210.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Limon] [Arandanos] [Harina] [Queso_crema] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_oreo_cheesecake] of Pastel
     (Precio 225.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Galleta] [Queso_crema] [Azucar] [Nata])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_manzana_y_canela] of Pastel
     (Precio 200.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (se_sirve_en [Otono])
     (usa_ingrediente [Manzana] [Canela] [Harina] [Azucar] [Huevo] [Mantequilla])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_frambuesa_y_vainilla] of Pastel
     (Precio 215.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Frambuesas] [Harina] [Queso_crema] [Azucar] [Vainilla])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_coco_y_lima] of Pastel
     (Precio 205.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Coco] [Limon] [Harina] [Huevo] [Mantequilla] [Azucar])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_crema_catalana] of Pastel
     (Precio 245.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Leche] [Azucar] [Huevo] [Harina] [Limon])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_toffee_y_nueces] of Pastel
     (Precio 230.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Otono])
     (usa_ingrediente [Nuez] [Harina] [Mantequilla] [Azucar] [Huevo])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_lavanda_y_limon] of Pastel
     (Precio 260.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Limon] [Harina] [Nata] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_sin_lacteos_vegano] of Pastel
     (Precio 200.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Harina] [Aceite_vegetal] [Azucar] [Frambuesas])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_vainilla_y_frambuesa] of Pastel
     (Precio 210.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Harina] [Vainilla] [Frambuesas] [Queso_crema] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_almendra_y_albaricoque] of Pastel
     (Precio 225.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Almendra] [Albaricoque] [Harina] [Azucar] [Huevo])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_pistacho_y_cereza] of Pastel
     (Precio 275.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Pistacho] [Cereza] [Harina] [Queso_crema] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_yogur_y_miel] of Pastel
     (Precio 205.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Yogur] [Miel] [Harina] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_chocolate_y_naranja] of Pastel
     (Precio 220.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Otono])
     (usa_ingrediente [Cacao] [Naranja] [Harina] [Huevo] [Mantequilla])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_red_velvet_blanco] of Pastel
     (Precio 285.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Harina] [Cacao] [Queso_crema] [Azucar] [Huevo] [Nata])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_mango_y_maracuya] of Pastel
     (Precio 235.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Mango] [Maracuya] [Harina] [Queso_crema] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_frutas_de_temporada] of Pastel
     (Precio 215.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Fresas] [Arandanos] [Harina] [Nata] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_brownie_y_crema] of Pastel
     (Precio 260.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Cacao] [Nuez] [Harina] [Mantequilla] [Huevo] [Azucar] [Queso_crema])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_galleta_y_nata] of Pastel
     (Precio 200.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Galleta] [Nata] [Azucar] [Leche])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_limon_y_yogur] of Pastel
     (Precio 210.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Limon] [Yogur] [Harina] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_perla_de_coco] of Pastel
     (Precio 275.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Coco] [Harina] [Queso_crema] [Nata] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_frutal_vegano] of Pastel
     (Precio 205.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Harina] [Aceite_vegetal] [Azucar] [Mango] [Fresas])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_stracciatella] of Pastel
     (Precio 235.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Chocolate] [Queso_crema] [Harina] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_vainilla_y_pistacho] of Pastel
     (Precio 265.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Vainilla] [Pistacho] [Harina] [Queso_crema] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_caramelo_salado] of Pastel
     (Precio 225.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Otono])
     (usa_ingrediente [Harina] [Azucar] [Mantequilla] [Nata] [Huevo] [Sal])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_pera_y_almendra] of Pastel
     (Precio 220.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pera] [Almendra] [Harina] [Huevo] [Mantequilla] [Azucar])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_chocolate_blanco_y_frambuesa] of Pastel
     (Precio 290.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Chocolate_blanco] [Frambuesas] [Harina] [Queso_crema] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_arce_y_nuez] of Pastel
     (Precio 230.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Otono])
     (usa_ingrediente [Nuez] [Harina] [Mantequilla] [Huevo] [Azucar])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_yogur_y_frutos_rojos] of Pastel
     (Precio 215.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Yogur] [Fresas] [Arandanos] [Harina] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_avellana_y_chocolate] of Pastel
     (Precio 285.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Avellanas] [Cacao] [Harina] [Huevo] [Mantequilla] [Azucar])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_flores_y_vainilla] of Pastel
     (Precio 225.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Harina] [Vainilla] [Queso_crema] [Azucar] [Nata])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_coco_y_frambuesa] of Pastel
     (Precio 235.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Coco] [Frambuesas] [Harina] [Queso_crema] [Azucar])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_chai_especiado] of Pastel
     (Precio 265.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Harina] [Canela] [Jengibre] [Huevo] [Mantequilla] [Azucar])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_vainilla_y_limon_halal] of Pastel
     (Precio 230.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Harina] [Limon] [Huevo] [Azucar] [Nata])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_fresa_y_nata_halal] of Pastel
     (Precio 240.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Fresas] [Harina] [Nata] [Azucar])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_datil_y_nuez_halal] of Pastel
     (Precio 255.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Otono])
     (usa_ingrediente [Datil] [Nuez] [Harina] [Azucar] [Huevo] [Mantequilla])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
  )

  ([Pastel_de_boda_vegano_chocolate_y_frambuesa] of Pastel
     (Precio 215.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Harina] [Cacao] [Azucar] [Aceite_vegetal] [Frambuesas])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
  )

  ([Pastel_de_boda_mango_y_coco_vegano] of Pastel
     (Precio 210.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (se_sirve_en [Verano])
     (usa_ingrediente [Mango] [Coco] [Harina] [Azucar] [Aceite_vegetal])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
  )

)

; --------------------------
; INSTANCIAS DE PLATOS
; --------------------------

(definstances platos
  ;;; Platos
  ([Sopa_de_Perejil_Hinojo_y_Sandia_levantina] of Primero
     (Precio 19.23)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_sesamo] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Cebolla] [Perejil] [Hinojo] [Queso_feta] [Bacalao] [Sesamo] [Sandia])
  )

  ([Sopa_de_Gamba_Pimiento_rojo_y_Patata_helenica] of Primero
     (Precio 9.12)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Remolacha] [Patata] [Pimiento_rojo] [Nueces] [Masa_de_pizza] [Gamba])
  )

  ([Ensalada_de_Ternera_Atun_y_Habas_helenica] of Primero
     (Precio 11.16)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Pan_de_trigo] [Ternera] [Habas] [Masa_de_pizza] [Atun])
  )

  ([Gazpacho_de_Lentejas_Pera_y_Menta_mediterranea] of Primero
     (Precio 19.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_sesamo] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Lentejas] [Pera] [Menta] [Sesamo] [Queso_feta] [Dorada])
  )

  ([Sopa_de_Judiones_Uva_y_Pepino_helenica] of Primero
     (Precio 20.16)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Pepino] [Mozzarella] [Uva] [Pasta] [Atun] [Judiones] [Ajo])
  )

  ([Timbal_de_Hinojo_Apio_y_Pepino_helenica] of Primero
     (Precio 14.35)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_apio] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pepino] [Hinojo] [Arroz] [Apio] [Pimiento_rojo] [Merluza])
  )

  ([Sopa_de_Atun_Pepino_y_Acelgas_levantina] of Primero
     (Precio 16.95)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Acelgas] [Masa_de_pizza] [Pepino] [Atun] [Ricotta])
  )

  ([Tabule_de_Zanahoria_Pimiento_verde_y_Cordero_iberica] of Primero
     (Precio 12.95)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Queso_manchego] [Pimiento_verde] [Cordero] [Perejil] [Bulgur] [Zanahoria] [Remolacha] [Leche])
  )

  ([Sopa_de_Menta_Atun_y_Tofu_de_soja_levantina] of Primero
     (Precio 12.03)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_lactosa] [Alergia_a_soja] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Atun] [Queso_feta] [Tofu_de_soja] [Champinones] [Menta] [Gamba])
  )

  ([Tabule_de_Pollo_Perejil_y_Habas_mediterranea] of Primero
     (Precio 13.16)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_soja] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Harina_de_trigo] [Pimiento_verde] [Perejil] [Tofu_de_soja] [Cacahuetes] [Pollo] [Habas])
  )

  ([Caprese_de_Judiones_Atun_y_Acelgas_mediterranea] of Primero
     (Precio 17.64)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Cacahuetes] [Pera] [Pan_de_trigo] [Calabacin] [Judiones] [Acelgas] [Atun])
  )

  ([Crema_de_Atun_Garbanzos_y_Hinojo_iberica] of Primero
     (Precio 12.71)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Atun] [Hinojo] [Garbanzos] [Alubias_blancas] [Pan_de_trigo] [Pimiento_verde])
  )

  ([Salpicon_de_Yogur_griego_Mejillon_y_Queso_feta_mediterranea] of Primero
     (Precio 13.32)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Queso_feta] [Bonito] [Champinones] [Cebolla] [Yogur_griego] [Arroz] [Mejillon] [Bulgur])
  )

  ([Salpicon_de_Zanahoria_Ricotta_y_Bacalao_mediterranea] of Primero
     (Precio 12.68)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Bacalao] [Ricotta] [Leche] [Zanahoria] [Nueces] [Champinones])
  )

  ([Timbal_de_Cerdo_Dorada_y_Sandia_iberica] of Primero
     (Precio 16.78)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Dorada] [Cacahuetes] [Sandia] [Centeno] [Melocoton] [Cebada] [Lubina] [Cerdo])
  )

  ([Ensalada_de_Calabacin_Atun_y_Remolacha_helenica] of Primero
     (Precio 14.13)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Patata] [Garbanzos] [Atun] [Calabacin] [Quinoa] [Merluza] [Remolacha] [Cacahuetes])
  )

  ([Crema_de_Sardinas_Menta_y_Zanahoria_levantina] of Primero
     (Precio 13.63)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Zanahoria] [Manzana] [Almendras] [Menta] [Bulgur] [Mozzarella] [Sardinas])
  )

  ([Sopa_de_Lechuga_romana_Lubina_y_Altramuces_italica] of Primero
     (Precio 15.47)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_frutos_con_cascara] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Alubias_blancas] [Maiz] [Higo] [Almendras] [Altramuces] [Lechuga_romana] [Alcachofa] [Lubina])
  )

  ([Salpicon_de_Mozzarella_Albahaca_y_Alubias_blancas_mediterranea] of Primero
     (Precio 14.82)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_lactosa] [Alergia_a_soja] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Cerdo] [Masa_de_pizza] [Tofu_de_soja] [Mozzarella] [Albahaca] [Alubias_blancas] [Hinojo] [Apio])
  )

  ([Crema_de_Sandia_Merluza_y_Calabacin_levantina] of Primero
     (Precio 16.7)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Calabacin] [Sandia] [Masa_de_pizza] [Nueces] [Oregano] [Merluza])
  )

  ([Timbal_de_Huevo_Higo_y_Espinacas_iberica] of Primero
     (Precio 16.04)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_huevos] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Higo] [Habas] [Masa_de_pizza] [Pan_de_trigo] [Bacalao] [Apio] [Huevo] [Espinacas])
  )

  ([Caprese_de_Mozzarella_Atun_y_Yogur_griego_helenica] of Primero
     (Precio 16.67)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_soja] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Cebada] [Tofu_de_soja] [Mozzarella] [Almendras] [Yogur_griego] [Atun])
  )

  ([Gazpacho_de_Oregano_Hinojo_y_Mejillon_iberica] of Primero
     (Precio 11.21)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Huevo] [Oregano] [Bulgur] [Patata] [Quinoa] [Hinojo] [Mejillon])
  )

  ([Gazpacho_de_Setas_Albahaca_y_Ternera_iberica] of Primero
     (Precio 9.29)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pasta] [Ajo] [Ternera] [Albahaca] [Setas] [Maiz])
  )

  ([Gazpacho_de_Lechuga_romana_Pepino_y_Queso_manchego_levantina] of Primero
     (Precio 7.49)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Remolacha] [Lechuga_romana] [Pepino] [Nueces] [Cacahuetes] [Pasta] [Queso_manchego] [Pulpo])
  )

  ([Timbal_de_Leche_Cerdo_y_Patata_levantina] of Primero
     (Precio 9.8)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Bulgur] [Bacalao] [Leche] [Cordero] [Patata] [Cerdo] [Berenjena])
  )

  ([Crema_de_Alcachofa_Espinacas_y_Langostino_helenica] of Primero
     (Precio 9.94)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Cebada] [Alcachofa] [Langostino] [Atun] [Limon] [Pasta] [Espinacas])
  )

  ([Caprese_de_Oregano_Apio_y_Pollo_levantina] of Primero
     (Precio 14.62)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Pimiento_verde] [Pollo] [Perejil] [Apio] [Yogur_griego] [Oregano] [Rucula])
  )

  ([Salpicon_de_Champinones_Pera_y_Atun_italica] of Primero
     (Precio 9.64)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_moluscos] [Alergia_a_soja] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Lechuga_romana] [Mejillon] [Pera] [Tofu_de_soja] [Sardinas] [Champinones] [Atun] [Pulpo])
  )

  ([Crema_de_Ternera_Melon_y_Naranja_italica] of Primero
     (Precio 9.24)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Huevo] [Tomate] [Bulgur] [Naranja] [Melon] [Ternera])
  )

  ([Caprese_de_Pimiento_verde_Lubina_y_Melocoton_helenica] of Primero
     (Precio 13.92)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Pimiento_verde] [Champinones] [Lubina] [Pan_de_trigo] [Melocoton])
  )

  ([Gazpacho_de_Calabacin_Limon_y_Alubias_blancas_helenica] of Primero
     (Precio 13.93)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Almendras] [Limon] [Harina_de_trigo] [Granada] [Alubias_blancas] [Calabacin] [Cordero])
  )

  ([Gazpacho_de_Espinacas_Atun_y_Yogur_griego_mediterranea] of Primero
     (Precio 7.72)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pasta] [Lubina] [Masa_de_pizza] [Atun] [Yogur_griego] [Espinacas])
  )

  ([Timbal_de_Ternera_Cebolla_y_Rucula_italica] of Primero
     (Precio 13.05)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Ternera] [Altramuces] [Rucula] [Cebolla] [Cuscus] [Quinoa])
  )

  ([Crema_de_Ternera_Yogur_griego_y_Albahaca_mediterranea] of Primero
     (Precio 12.65)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Albahaca] [Ternera] [Hinojo] [Bonito] [Avellanas] [Yogur_griego])
  )

  ([Caprese_de_Sandia_Sardinas_y_Cerdo_mediterranea] of Primero
     (Precio 14.48)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Cerdo] [Sandia] [Pollo] [Sardinas] [Garbanzos] [Pimiento_verde] [Leche] [Nueces])
  )

  ([Sopa_de_Tomillo_Dorada_y_Alcachofa_helenica] of Primero
     (Precio 14.8)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Leche] [Bulgur] [Tomillo] [Alcachofa] [Mejillon] [Espinacas] [Uva] [Dorada])
  )

  ([Crema_de_Garbanzos_Melon_y_Alcachofa_italica] of Primero
     (Precio 14.59)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Cerdo] [Melocoton] [Queso_feta] [Garbanzos] [Tomillo] [Melon] [Alcachofa] [Cebolla])
  )

  ([Caprese_de_Bacalao_Tomate_y_Aceitunas_italica] of Primero
     (Precio 14.9)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Lentejas] [Judiones] [Tomate] [Quinoa] [Albahaca] [Aceitunas] [Bacalao])
  )

  ([Ensalada_de_Lechuga_romana_Pepino_y_Setas_iberica] of Primero
     (Precio 8.91)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Lechuga_romana] [Cacahuetes] [Cebada] [Maiz] [Pepino] [Setas] [Berenjena] [Mozzarella] [Bacalao])
  )

  ([Sopa_de_Patata_Melocoton_y_Queso_manchego_helenica] of Primero
     (Precio 7.57)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Limon] [Quinoa] [Harina_de_trigo] [Pepino] [Queso_manchego] [Patata] [Melocoton] [Mozzarella] [Dorada])
  )

  ([Timbal_de_Zanahoria_Uva_y_Calamar_levantina] of Primero
     (Precio 10.71)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_a_sesamo] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Alubias_blancas] [Zanahoria] [Apio] [Oregano] [Queso_manchego] [Uva] [Sesamo] [Bulgur] [Calamar])
  )

  ([Caprese_de_Yogur_griego_Apio_y_Zanahoria_italica] of Primero
     (Precio 13.93)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Tomillo] [Apio] [Acelgas] [Zanahoria] [Harina_de_trigo] [Centeno] [Masa_de_pizza] [Yogur_griego])
  )

  ([Tabule_de_Pimiento_verde_Champinones_y_Yogur_griego_levantina] of Primero
     (Precio 12.65)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_sesamo])
     (se_sirve_en [Verano])
     (usa_ingrediente [Sesamo] [Oregano] [Champinones] [Pimiento_verde] [Yogur_griego])
  )

  ([Sopa_de_Berenjena_Yogur_griego_y_Naranja_iberica] of Primero
     (Precio 8.93)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Yogur_griego] [Higo] [Berenjena] [Quinoa] [Albahaca] [Naranja])
  )

  ([Crema_de_Melocoton_Acelgas_y_Leche_italica] of Primero
     (Precio 17.1)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Centeno] [Maiz] [Melocoton] [Masa_de_pizza] [Nueces] [Acelgas] [Pan_de_trigo] [Leche])
  )

  ([Timbal_de_Melocoton_Habas_y_Queso_manchego_italica] of Primero
     (Precio 8.4)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Bulgur] [Habas] [Cebada] [Melocoton] [Queso_manchego])
  )

  ([Sopa_de_Queso_manchego_Leche_y_Hinojo_iberica] of Primero
     (Precio 10.96)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Leche] [Maiz] [Hinojo] [Menta] [Queso_manchego])
  )

  ([Caprese_de_Cebolla_Leche_y_Apio_iberica] of Primero
     (Precio 13.67)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Nueces] [Apio] [Cebolla] [Pistachos] [Leche])
  )

  ([Salpicon_de_Acelgas_Queso_manchego_y_Sandia_mediterranea] of Primero
     (Precio 14.44)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Calabacin] [Rucula] [Sandia] [Queso_manchego] [Granada] [Acelgas])
  )

  ([Crema_de_Patata_Menta_y_Leche_helenica] of Primero
     (Precio 9.49)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Menta] [Centeno] [Patata] [Leche] [Pasta] [Pimiento_rojo])
  )

  ([Sopa_de_Limon_Perejil_y_Remolacha_mediterranea] of Primero
     (Precio 10.99)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Cebada] [Judiones] [Remolacha] [Limon] [Perejil] [Altramuces] [Queso_manchego])
  )

  ([Gazpacho_de_Espinacas_Melocoton_y_Uva_helenica] of Primero
     (Precio 15.52)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Uva] [Masa_de_pizza] [Espinacas] [Leche] [Melocoton])
  )

  ([Sopa_de_Queso_manchego_Espinacas_y_Lentejas_mediterranea] of Primero
     (Precio 9.59)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Cuscus] [Habas] [Avellanas] [Lentejas] [Espinacas] [Queso_manchego])
  )

  ([Gazpacho_de_Pera_Queso_feta_y_Patata_mediterranea] of Primero
     (Precio 14.63)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_sesamo] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Pera] [Sesamo] [Patata] [Cebada] [Maiz] [Avellanas] [Queso_feta])
  )

  ([Sopa_de_Alcachofa_Pepino_y_Altramuces_iberica] of Primero
     (Precio 12.17)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Altramuces] [Lechuga_romana] [Alcachofa] [Pepino] [Queso_manchego] [Leche])
  )

  ([Gazpacho_de_Perejil_Yogur_griego_y_Pera_helenica] of Primero
     (Precio 12.5)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Leche] [Ricotta] [Perejil] [Pera] [Yogur_griego] [Pan_de_trigo])
  )

  ([Crema_de_Melon_Queso_feta_y_Tomate_iberica] of Primero
     (Precio 8.07)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Cacahuetes] [Tomate] [Maiz] [Queso_feta] [Arroz] [Cebolla] [Melon])
  )

  ([Timbal_de_Aceitunas_Ajo_y_Yogur_griego_iberica] of Primero
     (Precio 9.08)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Aceitunas] [Pasta] [Quinoa] [Ajo] [Yogur_griego])
  )

  ([Salpicon_de_Yogur_griego_Menta_y_Aceitunas_italica] of Primero
     (Precio 11.95)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Lechuga_romana] [Yogur_griego] [Menta] [Bulgur] [Aceitunas] [Arroz])
  )

  ([Gazpacho_de_Calabacin_Leche_y_Patata_levantina] of Primero
     (Precio 7.58)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Calabacin] [Leche] [Patata] [Apio] [Higo] [Pimiento_rojo])
  )

  ([Crema_de_Queso_manchego_Granada_y_Tofu_de_soja_levantina] of Primero
     (Precio 10.62)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_lactosa] [Alergia_a_soja])
     (se_sirve_en [Otono])
     (usa_ingrediente [Tofu_de_soja] [Granada] [Apio] [Berenjena] [Queso_manchego])
  )

  ([Salpicon_de_Yogur_griego_Alcachofa_y_Uva_helenica] of Primero
     (Precio 12.7)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Leche] [Uva] [Yogur_griego] [Alcachofa] [Cebada])
  )

  ([Sopa_de_Menta_Sandia_y_Yogur_griego_levantina] of Primero
     (Precio 16.21)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Menta] [Limon] [Avellanas] [Yogur_griego] [Sandia])
  )

  ([Sopa_de_Alubias_blancas_Altramuces_y_Yogur_griego_italica] of Primero
     (Precio 16.42)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Leche] [Habas] [Yogur_griego] [Perejil] [Arroz] [Alubias_blancas] [Altramuces])
  )

  ([Timbal_de_Uva_Pimiento_verde_y_Queso_manchego_mediterranea] of Primero
     (Precio 12.12)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_sesamo])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Sesamo] [Pimiento_verde] [Naranja] [Uva] [Menta] [Queso_manchego])
  )

  ([Salpicon_de_Naranja_Cebolla_y_Queso_feta_iberica] of Primero
     (Precio 13.74)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Sandia] [Cebolla] [Alubias_blancas] [Queso_feta] [Naranja])
  )

  ([Ensalada_de_Oregano_Berenjena_y_Queso_feta_mediterranea] of Primero
     (Precio 14.86)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Mozzarella] [Berenjena] [Oregano] [Masa_de_pizza] [Queso_feta])
  )

  ([Crema_de_Melon_Apio_y_Manzana_helenica] of Primero
     (Precio 12.12)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_lactosa] [Alergia_a_sesamo])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Rucula] [Patata] [Sesamo] [Apio] [Manzana] [Melon] [Queso_manchego])
  )

  ([Crema_de_Setas_Queso_feta_y_Alcachofa_helenica] of Primero
     (Precio 13.24)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Garbanzos] [Melon] [Setas] [Harina_de_trigo] [Alcachofa] [Maiz] [Queso_feta])
  )

  ([Tabule_de_Acelgas_Rucula_y_Menta_helenica] of Primero
     (Precio 12.45)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Menta] [Acelgas] [Melocoton] [Pistachos] [Rucula] [Queso_manchego])
  )

  ([Ensalada_de_Acelgas_Leche_y_Sandia_italica] of Primero
     (Precio 13.88)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_sesamo] [Alergia_a_soja] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Acelgas] [Tofu_de_soja] [Pan_de_trigo] [Sandia] [Leche] [Sesamo])
  )

  ([Crema_de_Limon_Leche_y_Tofu_de_soja_levantina] of Primero
     (Precio 12.74)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_soja] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Rucula] [Quinoa] [Pan_de_trigo] [Limon] [Tofu_de_soja] [Leche])
  )

  ([Crema_de_Zanahoria_Aceitunas_y_Pera_italica] of Primero
     (Precio 12.33)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pera] [Zanahoria] [Centeno] [Pimiento_rojo] [Lechuga_romana] [Aceitunas] [Judiones] [Queso_feta])
  )

  ([Gazpacho_de_Limon_Menta_y_Leche_italica] of Primero
     (Precio 12.85)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Alubias_blancas] [Almendras] [Menta] [Limon] [Higo] [Leche])
  )

  ([Crema_de_Pimiento_rojo_Altramuces_y_Aceitunas_italica] of Primero
     (Precio 14.19)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_cacahuetes] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Cacahuetes] [Aceitunas] [Ricotta] [Pimiento_rojo] [Altramuces])
  )

  ([Timbal_de_Aceitunas_Rucula_y_Acelgas_levantina] of Primero
     (Precio 15.76)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_huevos])
     (se_sirve_en [Otono])
     (usa_ingrediente [Aceitunas] [Hinojo] [Sandia] [Acelgas] [Rucula] [Huevo])
  )

  ([Tabule_de_Higo_Pera_y_Leche_helenica] of Primero
     (Precio 10.66)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Leche] [Harina_de_trigo] [Berenjena] [Pera] [Higo] [Nueces] [Maiz])
  )

  ([Ensalada_de_Mozzarella_Melon_y_Acelgas_levantina] of Primero
     (Precio 13.51)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Almendras] [Acelgas] [Pasta] [Mozzarella] [Melon] [Bulgur])
  )

  ([Timbal_de_Queso_manchego_Ajo_y_Menta_helenica] of Primero
     (Precio 9.88)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Masa_de_pizza] [Menta] [Nueces] [Pistachos] [Avellanas] [Ajo] [Melon] [Cebada] [Queso_manchego])
  )

  ([Caprese_de_Leche_Champinones_y_Tomillo_helenica] of Primero
     (Precio 7.47)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pimiento_rojo] [Remolacha] [Champinones] [Tomillo] [Leche])
  )

  ([Sopa_de_Manzana_Granada_y_Rucula_iberica] of Primero
     (Precio 11.61)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Rucula] [Pimiento_verde] [Manzana] [Granada] [Huevo] [Queso_feta])
  )

  ([Sopa_de_Leche_Alubias_blancas_helenica] of Primero
     (Precio 13.42)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pinones] [Alubias_blancas] [Arroz] [Almendras] [Leche])
  )

  ([Salpicon_de_Pimiento_rojo_Naranja_y_Leche_iberica] of Primero
     (Precio 9.83)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Naranja] [Leche] [Pimiento_rojo] [Avellanas] [Alubias_blancas])
  )

  ([Tabule_de_Altramuces_Alcachofa_y_Higo_mediterranea] of Primero
     (Precio 8.39)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_apio])
     (se_sirve_en [Otono])
     (usa_ingrediente [Alcachofa] [Apio] [Limon] [Calabacin] [Higo] [Altramuces])
  )

  ([Crema_de_Acelgas_Pepino_italica] of Primero
     (Precio 14.5)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Acelgas] [Pepino] [Cacahuetes] [Pan_de_trigo] [Cuscus])
  )

  ([Tabule_de_Cebolla_Naranja_y_Tomate_levantina] of Primero
     (Precio 20.16)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Masa_de_pizza] [Lechuga_romana] [Naranja] [Cebolla] [Tomate])
  )

  ([Ensalada_de_Tofu_de_soja_Calabacin_y_Garbanzos_helenica] of Primero
     (Precio 12.52)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_soja])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Menta] [Tofu_de_soja] [Garbanzos] [Calabacin] [Avellanas])
  )

  ([Crema_de_Espinacas_Habas_y_Granada_levantina] of Primero
     (Precio 9.22)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Espinacas] [Granada] [Calabacin] [Habas] [Arroz])
  )

  ([Tabule_de_Menta_Sandia_y_Pimiento_rojo_levantina] of Primero
     (Precio 13.94)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Arroz] [Cuscus] [Sandia] [Pimiento_rojo] [Menta])
  )

  ([Caprese_de_Setas_Garbanzos_y_Hinojo_helenica] of Primero
     (Precio 19.23)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_cacahuetes])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Garbanzos] [Hinojo] [Cacahuetes] [Calabacin] [Setas])
  )

  ([Timbal_de_Higo_Alubias_blancas_mediterranea] of Primero
     (Precio 17.64)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Almendras] [Higo] [Cacahuetes] [Alubias_blancas] [Harina_de_trigo])
  )

  ([Timbal_de_Zanahoria_Champinones_y_Tomillo_levantina] of Primero
     (Precio 11.34)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Alubias_blancas] [Zanahoria] [Aceitunas] [Almendras] [Champinones] [Tomillo])
  )

  ([Ensalada_de_Melon_Habas_y_Tofu_de_soja_levantina] of Primero
     (Precio 8.48)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_soja] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Cebolla] [Cebada] [Tomillo] [Habas] [Melon] [Ajo] [Granada] [Tofu_de_soja])
  )

  ([Timbal_de_Cebolla_Oregano_y_Melon_helenica] of Primero
     (Precio 10.79)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Oregano] [Cacahuetes] [Cebolla] [Hinojo] [Harina_de_trigo] [Melon])
  )

  ([Gazpacho_de_Altramuces_Cebolla_y_Albahaca_italica] of Primero
     (Precio 7.52)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Albahaca] [Cebada] [Altramuces] [Cuscus] [Arroz] [Cebolla])
  )

  ([Sopa_de_Garbanzos_Cebolla_italica] of Primero
     (Precio 14.87)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Cebolla] [Pasta] [Maiz] [Arroz] [Garbanzos])
  )

  ([Sopa_de_Hinojo_Limon_y_Judiones_mediterranea] of Primero
     (Precio 10.56)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Harina_de_trigo] [Judiones] [Limon] [Cacahuetes] [Hinojo])
  )

  ([Tabule_de_Lentejas_Espinacas_y_Pimiento_verde_helenica] of Primero
     (Precio 13.84)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Pinones] [Lentejas] [Espinacas] [Pimiento_verde] [Oregano])
  )

  ([Caprese_de_Acelgas_Aceitunas_y_Higo_helenica] of Primero
     (Precio 9.91)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Higo] [Quinoa] [Acelgas] [Aceitunas] [Pinones])
  )

  ([Crema_de_Ajo_Garbanzos_y_Oregano_italica] of Primero
     (Precio 14.34)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_sesamo] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Garbanzos] [Oregano] [Centeno] [Sesamo] [Ajo])
  )

  ([Timbal_de_Hinojo_Albahaca_y_Alcachofa_iberica] of Primero
     (Precio 13.66)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_sesamo])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Hinojo] [Alcachofa] [Albahaca] [Espinacas] [Sesamo])
  )

  ([Timbal_de_Rucula_Champinones_y_Higo_helenica] of Primero
     (Precio 15.49)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Verano])
     (usa_ingrediente [Melocoton] [Cebolla] [Rucula] [Champinones] [Higo])
  )

  ([Caprese_de_Cebolla_Pepino_y_Tomillo_levantina] of Primero
     (Precio 16.52)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Nueces] [Cebolla] [Pepino] [Apio] [Tomillo])
  )

  ([Crema_de_Cebolla_Tofu_de_soja_y_Zanahoria_iberica] of Primero
     (Precio 11.92)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_soja] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Tofu_de_soja] [Zanahoria] [Pimiento_rojo] [Harina_de_trigo] [Nueces] [Cebolla] [Limon])
  )

  ([Caprese_de_Manzana_Apio_y_Altramuces_mediterranea] of Primero
     (Precio 12.2)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_apio] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Apio] [Cuscus] [Centeno] [Altramuces] [Manzana])
  )

  ([Ensalada_de_Patata_Pimiento_verde_y_Calabacin_helenica] of Primero
     (Precio 11.86)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Arroz] [Calabacin] [Albahaca] [Pimiento_verde] [Zanahoria] [Patata])
  )

  ([Timbal_de_Alubias_blancas_Limon_y_Higo_iberica] of Primero
     (Precio 13.74)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Setas] [Pan_de_trigo] [Higo] [Limon] [Alubias_blancas])
  )

  ([Caprese_de_Berenjena_Ajo_y_Aceitunas_mediterranea] of Primero
     (Precio 12.33)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (se_sirve_en [Otono])
     (usa_ingrediente [Berenjena] [Ajo] [Pimiento_rojo] [Judiones] [Aceitunas])
  )

  ([Caprese_de_Pera_Pimiento_verde_y_Tomillo_helenica] of Primero
     (Precio 8.14)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pera] [Patata] [Pimiento_verde] [Cuscus] [Pimiento_rojo] [Tomillo])
  )

  ([Gazpacho_de_Altramuces_italica] of Primero
     (Precio 18.83)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_cacahuetes] [Alergia_a_frutos_con_cascara] [Alergia_a_sesamo])
     (se_sirve_en [Otono])
     (usa_ingrediente [Sesamo] [Nueces] [Altramuces] [Cacahuetes] [Pinones])
  )

  ([Crema_de_Aceitunas_Oregano_y_Rucula_levantina] of Primero
     (Precio 20.04)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Oregano] [Pinones] [Rucula] [Garbanzos] [Aceitunas])
  )

  ([Tabule_de_Remolacha_Pera_y_Zanahoria_mediterranea] of Primero
     (Precio 17.39)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Verano])
     (usa_ingrediente [Tomate] [Quinoa] [Pera] [Zanahoria] [Remolacha])
  )

  ([Gazpacho_de_Tomate_Acelgas_y_Pimiento_rojo_helenica] of Primero
     (Precio 9.6)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Manzana] [Quinoa] [Acelgas] [Pimiento_rojo] [Tomate])
  )

  ([Timbal_de_Zanahoria_iberica] of Primero
     (Precio 12.3)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_sesamo] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Sesamo] [Zanahoria] [Nueces] [Masa_de_pizza] [Cuscus])
  )

  ([Sopa_de_Hinojo_Garbanzos_y_Higo_mediterranea] of Primero
     (Precio 16.71)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Almendras] [Higo] [Pinones] [Acelgas] [Hinojo] [Garbanzos])
  )

  ([Sopa_de_Espinacas_Apio_italica] of Primero
     (Precio 10.05)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Espinacas] [Apio] [Nueces] [Pasta])
  )

  ([Sopa_de_Garbanzos_Espinacas_y_Higo_helenica] of Primero
     (Precio 12.69)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Masa_de_pizza] [Garbanzos] [Espinacas] [Pan_de_trigo] [Nueces] [Higo])
  )

  ([Timbal_de_Habas_Setas_y_Altramuces_mediterranea] of Primero
     (Precio 8.7)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_frutos_con_cascara] [Alergia_a_sesamo])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Altramuces] [Habas] [Almendras] [Lentejas] [Setas] [Sesamo])
  )

  ([Sopa_de_Remolacha_Naranja_y_Rucula_levantina] of Primero
     (Precio 13.87)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Rucula] [Remolacha] [Judiones] [Cebolla] [Naranja])
  )

  ([Timbal_de_Tomate_Melocoton_y_Berenjena_mediterranea] of Primero
     (Precio 7.94)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Uva] [Berenjena] [Menta] [Tomate] [Melocoton])
  )

  ([Salpicon_de_Melon_Limon_y_Setas_italica] of Primero
     (Precio 9.27)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Maiz] [Masa_de_pizza] [Limon] [Acelgas] [Nueces] [Setas] [Melon])
  )

  ([Caprese_de_Naranja_Alubias_blancas_italica] of Primero
     (Precio 14.42)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Masa_de_pizza] [Almendras] [Pasta] [Naranja] [Alubias_blancas])
  )

  ([Sopa_de_Perejil_Sandia_y_Habas_iberica] of Primero
     (Precio 11.62)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Melocoton] [Pera] [Pan_de_trigo] [Habas] [Perejil] [Sandia])
  )

  ([Gazpacho_de_Alubias_blancas_Higo_y_Aceitunas_helenica] of Primero
     (Precio 10.5)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pera] [Alubias_blancas] [Aceitunas] [Higo] [Centeno] [Quinoa])
  )

  ([Ensalada_de_Uva_Pepino_y_Lubina_helenica] of Primero
     (Precio 11.3)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Uva] [Bulgur] [Espinacas] [Garbanzos] [Pepino] [Lubina])
  )

  ([Timbal_de_Leche_Aceitunas_y_Sandia_mediterranea] of Primero
     (Precio 9.93)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Sandia] [Cacahuetes] [Tomate] [Cuscus] [Manzana] [Aceitunas] [Leche])
  )

  ([Caprese_de_Uva_Lubina_y_Sandia_italica] of Primero
     (Precio 8.18)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_moluscos] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Menta] [Ternera] [Sandia] [Lubina] [Uva] [Quinoa] [Calamar])
  )

  ([Caprese_de_Bacalao_Espinacas_y_Sardinas_mediterranea] of Primero
     (Precio 13.43)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Espinacas] [Avellanas] [Patata] [Bacalao] [Sardinas] [Cacahuetes] [Cuscus] [Sandia])
  )

  ([Tabule_de_Calamar_Manzana_y_Pepino_italica] of Primero
     (Precio 16.37)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_moluscos])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Quinoa] [Manzana] [Calamar] [Pepino] [Zanahoria])
  )

  ([Caprese_de_Leche_Hinojo_y_Ajo_italica] of Primero
     (Precio 18.81)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Ajo] [Cacahuetes] [Atun] [Almendras] [Pepino] [Hinojo] [Leche])
  )

  ([Gazpacho_de_Pulpo_Tofu_de_soja_y_Sardinas_mediterranea] of Primero
     (Precio 14.54)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_huevos] [Alergia_a_moluscos] [Alergia_a_soja] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Langostino] [Tofu_de_soja] [Pulpo] [Huevo] [Sardinas] [Berenjena])
  )

  ([Ensalada_de_Rucula_Oregano_y_Gamba_iberica] of Primero
     (Precio 12.97)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Rucula] [Aceitunas] [Cebada] [Ternera] [Oregano] [Gamba])
  )

  ([Ensalada_de_Pollo_Naranja_y_Rucula_iberica] of Primero
     (Precio 12.77)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (se_sirve_en [Otono])
     (usa_ingrediente [Naranja] [Quinoa] [Rucula] [Pimiento_verde] [Pollo])
  )

  ([Tabule_de_Habas_Lentejas_y_Naranja_helenica] of Primero
     (Precio 10.86)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Lentejas] [Perejil] [Pimiento_rojo] [Habas] [Patata] [Naranja])
  )

  ([Timbal_de_Garbanzos_Calamar_y_Albahaca_iberica] of Primero
     (Precio 14.75)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_moluscos])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Garbanzos] [Setas] [Calamar] [Nueces] [Pimiento_verde] [Albahaca])
  )

  ([Crema_de_Pulpo_Bonito_y_Alcachofa_mediterranea] of Primero
     (Precio 14.97)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_moluscos] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Bonito] [Huevo] [Alcachofa] [Calabacin] [Manzana] [Habas] [Pulpo])
  )

  ([Gazpacho_de_Queso_feta_Rucula_y_Dorada_italica] of Primero
     (Precio 10.99)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Espinacas] [Champinones] [Dorada] [Queso_feta] [Arroz] [Rucula] [Granada])
  )

  ([Sopa_de_Merluza_Remolacha_y_Patata_mediterranea] of Primero
     (Precio 16.97)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Cebada] [Patata] [Remolacha] [Merluza] [Pan_de_trigo])
  )

  ([Salpicon_de_Ajo_Zanahoria_y_Pera_iberica] of Primero
     (Precio 11.04)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pasta] [Ajo] [Bacalao] [Pera] [Zanahoria])
  )

  ([Gazpacho_de_Habas_Gamba_y_Melon_iberica] of Primero
     (Precio 8.1)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Cacahuetes] [Melon] [Cuscus] [Habas] [Avellanas] [Gamba])
  )

  ([Ensalada_de_Menta_Pollo_y_Cebolla_mediterranea] of Primero
     (Precio 10.27)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Cebolla] [Centeno] [Pollo] [Menta] [Judiones])
  )

  ([Ensalada_de_Mozzarella_Hinojo_y_Huevo_helenica] of Primero
     (Precio 8.53)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Mozzarella] [Alubias_blancas] [Hinojo] [Perejil] [Oregano] [Huevo] [Cebolla])
  )

  ([Ensalada_de_Queso_feta_Ajo_y_Remolacha_mediterranea] of Primero
     (Precio 9.5)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Avellanas] [Pistachos] [Remolacha] [Pan_de_trigo] [Queso_feta] [Ajo] [Granada] [Ternera])
  )

  ([Ensalada_de_Remolacha_Hinojo_y_Espinacas_italica] of Primero
     (Precio 19.3)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_lactosa] [Alergia_a_soja] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Altramuces] [Leche] [Acelgas] [Bonito] [Hinojo] [Tofu_de_soja] [Espinacas] [Remolacha])
  )

  ([Tabule_de_Lubina_Albahaca_y_Granada_mediterranea] of Primero
     (Precio 18.48)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Alubias_blancas] [Granada] [Zanahoria] [Remolacha] [Pasta] [Rucula] [Lubina] [Albahaca])
  )

  ([Caprese_de_Albahaca_Lechuga_romana_y_Habas_helenica] of Primero
     (Precio 13.98)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Albahaca] [Quinoa] [Harina_de_trigo] [Habas] [Lechuga_romana] [Calabacin])
  )

  ([Salpicon_de_Menta_Pimiento_verde_y_Tofu_de_soja_levantina] of Primero
     (Precio 8.53)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_moluscos] [Alergia_a_soja])
     (se_sirve_en [Verano])
     (usa_ingrediente [Menta] [Tofu_de_soja] [Uva] [Limon] [Pimiento_verde] [Ajo] [Pulpo] [Pinones])
  )

  ([Salpicon_de_Albahaca_Melon_y_Mejillon_helenica] of Primero
     (Precio 14.29)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_moluscos])
     (se_sirve_en [Verano])
     (usa_ingrediente [Calamar] [Melon] [Albahaca] [Mejillon] [Menta])
  )

  ([Timbal_de_Pepino_Sardinas_y_Melon_helenica] of Primero
     (Precio 14.34)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Pepino] [Melon] [Sardinas] [Judiones] [Langostino])
  )

  ([Tabule_de_Cebolla_Pimiento_verde_y_Aceitunas_italica] of Primero
     (Precio 10.27)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Alubias_blancas] [Cebolla] [Habas] [Leche] [Pimiento_verde] [Aceitunas])
  )

  ([Ensalada_de_Gamba_Alubias_blancas_mediterranea] of Primero
     (Precio 18.98)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Avellanas] [Arroz] [Pistachos] [Alubias_blancas] [Gamba])
  )

  ([Salpicon_de_Higo_Granada_mediterranea] of Primero
     (Precio 7.94)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Pistachos] [Pasta] [Higo] [Granada] [Pan_de_trigo])
  )

  ([Timbal_de_Albahaca_Rucula_y_Perejil_mediterranea] of Primero
     (Precio 7.17)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_moluscos])
     (se_sirve_en [Otono])
     (usa_ingrediente [Menta] [Judiones] [Perejil] [Albahaca] [Calamar] [Rucula])
  )

  ([Gazpacho_de_Cordero_Merluza_y_Higo_iberica] of Primero
     (Precio 12.31)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Higo] [Pistachos] [Merluza] [Avellanas] [Cordero] [Nueces])
  )

  ([Timbal_de_Atun_Zanahoria_y_Bacalao_mediterranea] of Primero
     (Precio 13.39)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Maiz] [Atun] [Pistachos] [Bacalao] [Zanahoria])
  )

  ([Ensalada_de_Cebolla_Ricotta_y_Oregano_italica] of Primero
     (Precio 7.96)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_moluscos])
     (se_sirve_en [Verano])
     (usa_ingrediente [Acelgas] [Oregano] [Ricotta] [Ternera] [Mejillon] [Pimiento_verde] [Pimiento_rojo] [Cebolla])
  )

  ([Tabule_de_Albahaca_Habas_levantina] of Primero
     (Precio 14.69)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Harina_de_trigo] [Almendras] [Albahaca] [Habas] [Pinones])
  )

  ([Salpicon_de_Espinacas_Uva_y_Calabacin_helenica] of Primero
     (Precio 11.37)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Hinojo] [Calabacin] [Espinacas] [Pimiento_rojo] [Cuscus] [Uva] [Lubina])
  )

  ([Salpicon_de_Ricotta_Higo_y_Pimiento_rojo_helenica] of Primero
     (Precio 9.11)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Higo] [Pimiento_rojo] [Setas] [Ricotta] [Pepino])
  )

  ([Ensalada_de_Tomate_Langostino_y_Perejil_levantina] of Primero
     (Precio 16.69)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Ricotta] [Maiz] [Langostino] [Mejillon] [Cordero] [Centeno] [Tomate] [Perejil])
  )

  ([Salpicon_de_Queso_manchego_Higo_y_Cordero_iberica] of Primero
     (Precio 8.98)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Cordero] [Higo] [Alcachofa] [Cacahuetes] [Queso_manchego])
  )

  ([Ensalada_de_Calamar_Ternera_y_Tomillo_italica] of Primero
     (Precio 16.66)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Menta] [Sandia] [Tomillo] [Berenjena] [Ternera] [Apio] [Cuscus] [Calamar])
  )

  ([Tabule_de_Albahaca_Bonito_y_Patata_levantina] of Primero
     (Precio 12.47)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Almendras] [Maiz] [Pinones] [Albahaca] [Patata] [Bonito])
  )

  ([Ensalada_de_Berenjena_Uva_y_Limon_iberica] of Primero
     (Precio 16.24)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Berenjena] [Uva] [Merluza] [Zanahoria] [Limon])
  )

  ([Crema_de_Cebolla_Aceitunas_y_Remolacha_levantina] of Primero
     (Precio 17.24)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_sesamo] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Remolacha] [Cebolla] [Sesamo] [Cuscus] [Avellanas] [Maiz] [Aceitunas])
  )

  ([Gazpacho_de_Melocoton_Tomillo_y_Oregano_iberica] of Primero
     (Precio 7.71)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Melocoton] [Queso_feta] [Tomillo] [Oregano] [Calabacin] [Huevo] [Cuscus])
  )

  ([Plancha_de_Cordero_Huevo_y_Menta_iberica] of Segundo
     (Precio 24.39)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Tomillo] [Huevo] [Lechuga_romana] [Lentejas] [Menta] [Centeno] [Cordero])
  )

  ([Horno_de_Espinacas_Gamba_y_Perejil_levantina] of Segundo
     (Precio 20.31)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Quinoa] [Pistachos] [Espinacas] [Perejil] [Maiz] [Naranja] [Gamba])
  )

  ([Estofado_de_Espinacas_Oregano_y_Cerdo_helenica] of Segundo
     (Precio 22.33)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_sesamo])
     (se_sirve_en [Verano])
     (usa_ingrediente [Espinacas] [Maiz] [Nueces] [Alcachofa] [Almendras] [Sesamo] [Cerdo] [Oregano])
  )

  ([Estofado_de_Naranja_Zanahoria_y_Ricotta_levantina] of Segundo
     (Precio 27.89)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Zanahoria] [Champinones] [Ricotta] [Mejillon] [Naranja] [Cuscus])
  )

  ([Salteado_de_Cerdo_Zanahoria_italica] of Segundo
     (Precio 22.27)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pan_de_trigo] [Cerdo] [Zanahoria] [Bulgur] [Nueces])
  )

  ([Guiso_de_Atun_Sardinas_y_Merluza_helenica] of Segundo
     (Precio 14.1)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Merluza] [Calabacin] [Atun] [Sardinas] [Setas])
  )

  ([Parrillada_de_Lubina_Melocoton_y_Alubias_blancas_mediterranea] of Segundo
     (Precio 27.13)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Lubina] [Cerdo] [Bonito] [Melocoton] [Alubias_blancas])
  )

  ([Papillote_de_Ajo_Pepino_y_Lentejas_iberica] of Segundo
     (Precio 19.6)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_crustaceos])
     (se_sirve_en [Otono])
     (usa_ingrediente [Ajo] [Apio] [Langostino] [Espinacas] [Ternera] [Lentejas] [Pepino])
  )

  ([Plancha_de_Queso_feta_Apio_y_Remolacha_iberica] of Segundo
     (Precio 29.07)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_huevos] [Alergia_a_lactosa] [Alergia_a_moluscos])
     (se_sirve_en [Otono])
     (usa_ingrediente [Apio] [Remolacha] [Habas] [Queso_feta] [Huevo] [Calamar])
  )

  ([Salteado_de_Pulpo_Altramuces_y_Pepino_mediterranea] of Segundo
     (Precio 22.93)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Cebolla] [Yogur_griego] [Pulpo] [Altramuces] [Quinoa] [Arroz] [Pepino] [Harina_de_trigo])
  )

  ([Papillote_de_Acelgas_Pollo_y_Altramuces_helenica] of Segundo
     (Precio 24.22)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Acelgas] [Naranja] [Pinones] [Espinacas] [Altramuces] [Pollo])
  )

  ([Parrillada_de_Tomate_Dorada_y_Oregano_iberica] of Segundo
     (Precio 20.94)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Lubina] [Dorada] [Judiones] [Tomate] [Pimiento_rojo] [Oregano] [Cebada])
  )

  ([Plancha_de_Ajo_Naranja_y_Manzana_italica] of Segundo
     (Precio 17.5)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Alubias_blancas] [Manzana] [Ajo] [Naranja] [Bacalao])
  )

  ([Salteado_de_Alcachofa_Limon_y_Merluza_iberica] of Segundo
     (Precio 28.91)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_sesamo] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Limon] [Alcachofa] [Sesamo] [Merluza] [Nueces])
  )

  ([Parrillada_de_Atun_Limon_y_Merluza_helenica] of Segundo
     (Precio 24.32)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Uva] [Atun] [Limon] [Merluza] [Quinoa])
  )

  ([Parrillada_de_Ricotta_Zanahoria_y_Alcachofa_levantina] of Segundo
     (Precio 21.24)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Ricotta] [Melon] [Cebada] [Zanahoria] [Alcachofa] [Calamar])
  )

  ([Braseado_de_Champinones_Bacalao_y_Pulpo_levantina] of Segundo
     (Precio 27.27)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_moluscos] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Rucula] [Pulpo] [Bacalao] [Champinones] [Lentejas] [Alubias_blancas] [Pollo])
  )

  ([Papillote_de_Oregano_Cordero_y_Rucula_iberica] of Segundo
     (Precio 27.63)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Oregano] [Pinones] [Menta] [Cebada] [Rucula] [Cordero])
  )

  ([Horno_de_Granada_Merluza_y_Ajo_iberica] of Segundo
     (Precio 28.29)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Granada] [Pera] [Manzana] [Maiz] [Merluza] [Perejil] [Ajo])
  )

  ([Plancha_de_Pimiento_verde_Bacalao_y_Leche_mediterranea] of Segundo
     (Precio 31.04)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Avellanas] [Cordero] [Bacalao] [Leche] [Pimiento_verde] [Ricotta])
  )

  ([Estofado_de_Langostino_Ajo_y_Champinones_levantina] of Segundo
     (Precio 37.59)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Remolacha] [Ajo] [Patata] [Queso_feta] [Champinones] [Hinojo] [Langostino] [Pera])
  )

  ([Braseado_de_Pimiento_verde_Oregano_y_Alubias_blancas_italica] of Segundo
     (Precio 18.03)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Oregano] [Alubias_blancas] [Cebada] [Calamar] [Mejillon] [Arroz] [Pimiento_verde])
  )

  ([Plancha_de_Sardinas_Zanahoria_y_Calamar_mediterranea] of Segundo
     (Precio 25.76)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_moluscos] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Maiz] [Cuscus] [Zanahoria] [Sardinas] [Pinones] [Avellanas] [Calamar])
  )

  ([Salteado_de_Queso_manchego_Sardinas_y_Lentejas_mediterranea] of Segundo
     (Precio 21.88)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Cuscus] [Espinacas] [Quinoa] [Sardinas] [Queso_manchego] [Pimiento_rojo] [Lentejas])
  )

  ([Braseado_de_Ricotta_Pimiento_verde_y_Merluza_italica] of Segundo
     (Precio 36.3)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Bulgur] [Ricotta] [Pimiento_verde] [Merluza] [Habas] [Patata] [Alcachofa] [Remolacha])
  )

  ([Parrillada_de_Bacalao_Atun_y_Granada_italica] of Segundo
     (Precio 29.89)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Nueces] [Bacalao] [Atun] [Melon] [Granada])
  )

  ([Plancha_de_Atun_Berenjena_y_Calabacin_helenica] of Segundo
     (Precio 23.24)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Acelgas] [Berenjena] [Pistachos] [Pasta] [Judiones] [Ricotta] [Harina_de_trigo] [Calabacin] [Atun])
  )

  ([Salteado_de_Sardinas_Perejil_y_Zanahoria_levantina] of Segundo
     (Precio 14.09)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Perejil] [Sardinas] [Pimiento_rojo] [Patata] [Avellanas] [Zanahoria])
  )

  ([Estofado_de_Manzana_Acelgas_y_Albahaca_italica] of Segundo
     (Precio 26.59)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_soja] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Masa_de_pizza] [Sandia] [Acelgas] [Albahaca] [Pera] [Tofu_de_soja] [Lubina] [Manzana])
  )

  ([Horno_de_Calamar_Gamba_y_Alcachofa_mediterranea] of Segundo
     (Precio 27.64)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_moluscos])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Alcachofa] [Melon] [Cerdo] [Gamba] [Calamar])
  )

  ([Papillote_de_Rucula_Altramuces_y_Mozzarella_levantina] of Segundo
     (Precio 14.53)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_lactosa] [Alergia_a_moluscos])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Mozzarella] [Lechuga_romana] [Setas] [Rucula] [Altramuces] [Hinojo] [Calamar])
  )

  ([Salteado_de_Langostino_Remolacha_y_Higo_mediterranea] of Segundo
     (Precio 21.76)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Langostino] [Higo] [Centeno] [Remolacha] [Harina_de_trigo])
  )

  ([Papillote_de_Melon_Bacalao_y_Huevo_italica] of Segundo
     (Precio 25.27)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Huevo] [Bacalao] [Masa_de_pizza] [Melon] [Harina_de_trigo])
  )

  ([Salteado_de_Limon_Alcachofa_y_Cordero_helenica] of Segundo
     (Precio 29.84)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Limon] [Naranja] [Yogur_griego] [Pepino] [Alcachofa] [Mozzarella] [Cordero])
  )

  ([Guiso_de_Rucula_Queso_manchego_y_Dorada_iberica] of Segundo
     (Precio 19.38)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Quinoa] [Melocoton] [Rucula] [Pepino] [Queso_manchego] [Pera] [Pulpo] [Dorada])
  )

  ([Estofado_de_Atun_Queso_feta_y_Bacalao_iberica] of Segundo
     (Precio 14.41)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Acelgas] [Altramuces] [Bacalao] [Cebada] [Cuscus] [Queso_feta] [Atun])
  )

  ([Horno_de_Pimiento_rojo_Calamar_y_Pera_iberica] of Segundo
     (Precio 22.39)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Ricotta] [Calamar] [Harina_de_trigo] [Pimiento_rojo] [Almendras] [Pera] [Leche])
  )

  ([Plancha_de_Habas_Queso_feta_y_Yogur_griego_levantina] of Segundo
     (Precio 26.92)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Centeno] [Habas] [Queso_feta] [Judiones] [Quinoa] [Pan_de_trigo] [Cerdo] [Yogur_griego])
  )

  ([Plancha_de_Granada_Garbanzos_y_Pimiento_rojo_italica] of Segundo
     (Precio 21.69)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Patata] [Pimiento_rojo] [Hinojo] [Granada] [Garbanzos] [Uva] [Merluza] [Leche])
  )

  ([Salteado_de_Patata_Calamar_y_Pera_mediterranea] of Segundo
     (Precio 22.49)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_moluscos] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Calamar] [Alubias_blancas] [Naranja] [Patata] [Pera] [Apio] [Bonito])
  )

  ([Estofado_de_Calamar_Cebolla_y_Espinacas_italica] of Segundo
     (Precio 15.86)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_moluscos])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Cebolla] [Alcachofa] [Nueces] [Quinoa] [Ajo] [Espinacas] [Calamar])
  )

  ([Braseado_de_Sardinas_Lubina_y_Queso_feta_helenica] of Segundo
     (Precio 16.94)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Sardinas] [Centeno] [Queso_feta] [Almendras] [Lubina])
  )

  ([Papillote_de_Manzana_Lechuga_romana_y_Mozzarella_mediterranea] of Segundo
     (Precio 17.38)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Garbanzos] [Lechuga_romana] [Pimiento_verde] [Manzana] [Mozzarella])
  )

  ([Plancha_de_Altramuces_Alcachofa_y_Tomillo_italica] of Segundo
     (Precio 12.54)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_frutos_con_cascara] [Alergia_a_huevos])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Altramuces] [Nueces] [Maiz] [Alcachofa] [Tomillo] [Huevo])
  )

  ([Horno_de_Ricotta_Pepino_y_Zanahoria_mediterranea] of Segundo
     (Precio 20.96)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pepino] [Altramuces] [Almendras] [Hinojo] [Pimiento_verde] [Zanahoria] [Ricotta])
  )

  ([Salteado_de_Huevo_Calabacin_y_Aceitunas_levantina] of Segundo
     (Precio 25.57)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pan_de_trigo] [Maiz] [Aceitunas] [Huevo] [Calabacin] [Granada])
  )

  ([Horno_de_Ajo_Patata_y_Melon_mediterranea] of Segundo
     (Precio 16.33)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_sesamo])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Sesamo] [Ajo] [Tomillo] [Cebolla] [Pepino] [Patata] [Melon] [Huevo])
  )

  ([Braseado_de_Tomillo_Remolacha_y_Queso_feta_iberica] of Segundo
     (Precio 12.16)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Tomillo] [Altramuces] [Tomate] [Harina_de_trigo] [Cuscus] [Queso_feta] [Nueces] [Remolacha])
  )

  ([Parrillada_de_Tofu_de_soja_Perejil_y_Yogur_griego_italica] of Segundo
     (Precio 22.97)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_soja] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Espinacas] [Harina_de_trigo] [Perejil] [Tofu_de_soja] [Yogur_griego] [Berenjena])
  )

  ([Horno_de_Apio_Huevo_y_Yogur_griego_iberica] of Segundo
     (Precio 18.14)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_huevos] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Yogur_griego] [Queso_feta] [Cebada] [Oregano] [Apio] [Huevo])
  )

  ([Plancha_de_Tomillo_Queso_manchego_y_Alcachofa_mediterranea] of Segundo
     (Precio 17.26)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Alcachofa] [Queso_manchego] [Queso_feta] [Tomillo] [Pan_de_trigo] [Rucula] [Perejil])
  )

  ([Parrillada_de_Uva_Cebolla_y_Alcachofa_levantina] of Segundo
     (Precio 26.41)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Uva] [Ajo] [Cebolla] [Pistachos] [Champinones] [Alcachofa] [Yogur_griego])
  )

  ([Parrillada_de_Lentejas_Queso_feta_y_Espinacas_italica] of Segundo
     (Precio 12.03)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_sesamo])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Espinacas] [Queso_feta] [Lentejas] [Sesamo] [Queso_manchego])
  )

  ([Papillote_de_Huevo_Granada_y_Manzana_mediterranea] of Segundo
     (Precio 26.27)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_huevos])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Granada] [Patata] [Champinones] [Perejil] [Pimiento_rojo] [Huevo] [Manzana])
  )

  ([Braseado_de_Oregano_Melon_y_Apio_helenica] of Segundo
     (Precio 12.8)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Remolacha] [Melon] [Avellanas] [Apio] [Mozzarella] [Oregano])
  )

  ([Estofado_de_Limon_Espinacas_y_Queso_feta_iberica] of Segundo
     (Precio 17.26)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Higo] [Limon] [Espinacas] [Centeno] [Setas] [Rucula] [Queso_feta])
  )

  ([Plancha_de_Leche_Melocoton_y_Queso_manchego_italica] of Segundo
     (Precio 14.35)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Centeno] [Pinones] [Acelgas] [Bulgur] [Leche] [Queso_manchego] [Melocoton])
  )

  ([Parrillada_de_Calabacin_Melon_y_Yogur_griego_mediterranea] of Segundo
     (Precio 15.43)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Melon] [Cuscus] [Espinacas] [Calabacin] [Yogur_griego] [Pimiento_verde] [Uva] [Pistachos])
  )

  ([Plancha_de_Pimiento_rojo_Zanahoria_y_Yogur_griego_iberica] of Segundo
     (Precio 18.88)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Zanahoria] [Almendras] [Pimiento_rojo] [Pasta] [Granada] [Yogur_griego])
  )

  ([Guiso_de_Huevo_Tofu_de_soja_y_Sandia_helenica] of Segundo
     (Precio 22.36)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_soja])
     (se_sirve_en [Otono])
     (usa_ingrediente [Sandia] [Tofu_de_soja] [Albahaca] [Berenjena] [Zanahoria] [Huevo])
  )

  ([Papillote_de_Patata_Judiones_y_Higo_mediterranea] of Segundo
     (Precio 27.47)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pinones] [Oregano] [Judiones] [Melon] [Higo] [Patata] [Maiz] [Leche])
  )

  ([Horno_de_Leche_Mozzarella_y_Zanahoria_levantina] of Segundo
     (Precio 16.19)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Zanahoria] [Pasta] [Mozzarella] [Naranja] [Leche])
  )

  ([Plancha_de_Garbanzos_Remolacha_y_Yogur_griego_levantina] of Segundo
     (Precio 36.38)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pasta] [Yogur_griego] [Garbanzos] [Almendras] [Remolacha] [Cebada])
  )

  ([Estofado_de_Tomate_Granada_y_Leche_italica] of Segundo
     (Precio 25.79)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Maiz] [Tomate] [Granada] [Quinoa] [Hinojo] [Leche])
  )

  ([Guiso_de_Albahaca_Espinacas_y_Mozzarella_iberica] of Segundo
     (Precio 29.7)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Bulgur] [Rucula] [Mozzarella] [Espinacas] [Albahaca] [Judiones])
  )

  ([Estofado_de_Queso_feta_Remolacha_y_Manzana_helenica] of Segundo
     (Precio 31.72)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Queso_feta] [Queso_manchego] [Arroz] [Remolacha] [Ricotta] [Maiz] [Manzana])
  )

  ([Parrillada_de_Ajo_Calabacin_y_Mozzarella_italica] of Segundo
     (Precio 28.16)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Calabacin] [Berenjena] [Ajo] [Pasta] [Mozzarella])
  )

  ([Horno_de_Mozzarella_Manzana_y_Menta_italica] of Segundo
     (Precio 34.78)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Mozzarella] [Cebada] [Menta] [Arroz] [Manzana])
  )

  ([Plancha_de_Uva_Lentejas_y_Remolacha_helenica] of Segundo
     (Precio 17.79)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Uva] [Mozzarella] [Lentejas] [Albahaca] [Remolacha])
  )

  ([Plancha_de_Berenjena_Tofu_de_soja_y_Tomate_iberica] of Segundo
     (Precio 27.69)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_soja])
     (se_sirve_en [Verano])
     (usa_ingrediente [Naranja] [Uva] [Tofu_de_soja] [Tomate] [Pistachos] [Berenjena] [Mozzarella])
  )

  ([Plancha_de_Acelgas_Tomillo_y_Leche_italica] of Segundo
     (Precio 22.17)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Quinoa] [Acelgas] [Masa_de_pizza] [Apio] [Tomillo] [Leche])
  )

  ([Estofado_de_Yogur_griego_Apio_y_Berenjena_mediterranea] of Segundo
     (Precio 14.89)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_lactosa] [Alergia_a_sesamo])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Calabacin] [Maiz] [Apio] [Berenjena] [Sesamo] [Yogur_griego])
  )

  ([Braseado_de_Champinones_Queso_feta_y_Perejil_italica] of Segundo
     (Precio 13.06)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Harina_de_trigo] [Pan_de_trigo] [Champinones] [Berenjena] [Setas] [Queso_feta] [Perejil])
  )

  ([Parrillada_de_Ricotta_Huevo_y_Setas_levantina] of Segundo
     (Precio 15.94)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Ricotta] [Yogur_griego] [Huevo] [Centeno] [Setas])
  )

  ([Plancha_de_Pera_Mozzarella_y_Higo_helenica] of Segundo
     (Precio 21.52)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_soja] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Quinoa] [Mozzarella] [Aceitunas] [Pera] [Tofu_de_soja] [Pan_de_trigo] [Higo])
  )

  ([Parrillada_de_Patata_Rucula_y_Queso_manchego_mediterranea] of Segundo
     (Precio 29.76)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Patata] [Melon] [Cacahuetes] [Queso_manchego] [Rucula])
  )

  ([Guiso_de_Cebolla_Patata_y_Berenjena_italica] of Segundo
     (Precio 28.12)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Patata] [Berenjena] [Cebolla] [Alcachofa] [Yogur_griego])
  )

  ([Braseado_de_Patata_Habas_y_Melocoton_italica] of Segundo
     (Precio 17.81)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Granada] [Centeno] [Pinones] [Melocoton] [Patata] [Habas] [Queso_feta])
  )

  ([Horno_de_Rucula_Leche_y_Perejil_levantina] of Segundo
     (Precio 24.44)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Rucula] [Leche] [Perejil] [Nueces] [Centeno] [Aceitunas] [Champinones])
  )

  ([Estofado_de_Acelgas_Granada_y_Queso_manchego_levantina] of Segundo
     (Precio 24.96)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Acelgas] [Maiz] [Granada] [Nueces] [Queso_manchego])
  )

  ([Guiso_de_Sandia_Queso_manchego_y_Perejil_levantina] of Segundo
     (Precio 25.61)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Sandia] [Masa_de_pizza] [Espinacas] [Queso_manchego] [Perejil] [Quinoa])
  )

  ([Guiso_de_Melon_Queso_feta_y_Rucula_mediterranea] of Segundo
     (Precio 24.37)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Champinones] [Albahaca] [Lechuga_romana] [Rucula] [Patata] [Melon] [Queso_feta])
  )

  ([Braseado_de_Patata_Setas_y_Queso_feta_italica] of Segundo
     (Precio 24.18)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Aceitunas] [Patata] [Pinones] [Setas] [Cacahuetes] [Queso_feta])
  )

  ([Parrillada_de_Alcachofa_Hinojo_y_Pepino_italica] of Segundo
     (Precio 16.64)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Oregano] [Pepino] [Judiones] [Hinojo] [Alcachofa])
  )

  ([Horno_de_Garbanzos_Tomillo_y_Alcachofa_iberica] of Segundo
     (Precio 17.43)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Avellanas] [Arroz] [Alcachofa] [Tomillo] [Garbanzos])
  )

  ([Guiso_de_Ajo_Pimiento_verde_y_Patata_italica] of Segundo
     (Precio 29.1)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pistachos] [Lentejas] [Patata] [Pimiento_verde] [Ajo])
  )

  ([Papillote_de_Menta_Albahaca_y_Perejil_iberica] of Segundo
     (Precio 19.15)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Perejil] [Nueces] [Menta] [Arroz] [Albahaca])
  )

  ([Papillote_de_Albahaca_Higo_y_Garbanzos_italica] of Segundo
     (Precio 15.16)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Avellanas] [Garbanzos] [Albahaca] [Higo] [Naranja] [Cacahuetes] [Arroz])
  )

  ([Papillote_de_Oregano_Perejil_y_Rucula_mediterranea] of Segundo
     (Precio 15.89)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Rucula] [Perejil] [Pimiento_verde] [Oregano] [Pinones])
  )

  ([Parrillada_de_Tomillo_Oregano_y_Limon_helenica] of Segundo
     (Precio 17.25)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Tomillo] [Alcachofa] [Oregano] [Pasta] [Limon])
  )

  ([Papillote_de_Naranja_Zanahoria_y_Ajo_italica] of Segundo
     (Precio 19.34)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Pinones] [Remolacha] [Zanahoria] [Apio] [Sandia] [Naranja] [Ajo])
  )

  ([Plancha_de_Champinones_Melocoton_y_Setas_iberica] of Segundo
     (Precio 20.27)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Quinoa] [Champinones] [Melocoton] [Habas] [Pinones] [Setas] [Arroz] [Lentejas])
  )

  ([Estofado_de_Naranja_Patata_y_Champinones_italica] of Segundo
     (Precio 23.16)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Patata] [Masa_de_pizza] [Champinones] [Pan_de_trigo] [Naranja])
  )

  ([Horno_de_Apio_Perejil_iberica] of Segundo
     (Precio 21.59)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pistachos] [Arroz] [Perejil] [Pasta] [Apio])
  )

  ([Papillote_de_Alubias_blancas_Tomillo_y_Setas_helenica] of Segundo
     (Precio 13.49)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Tomillo] [Centeno] [Alubias_blancas] [Remolacha] [Setas])
  )

  ([Salteado_de_Pimiento_rojo_Garbanzos_y_Acelgas_levantina] of Segundo
     (Precio 12.17)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_sesamo] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Sesamo] [Acelgas] [Pimiento_rojo] [Quinoa] [Lentejas] [Garbanzos] [Masa_de_pizza])
  )

  ([Braseado_de_Pepino_Setas_y_Pera_levantina] of Segundo
     (Precio 24.62)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pepino] [Pera] [Calabacin] [Avellanas] [Habas] [Setas])
  )

  ([Salteado_de_Judiones_Manzana_y_Alubias_blancas_iberica] of Segundo
     (Precio 17.9)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Verano])
     (usa_ingrediente [Ajo] [Judiones] [Alubias_blancas] [Quinoa] [Manzana] [Alcachofa])
  )

  ([Horno_de_Habas_Calabacin_y_Aceitunas_italica] of Segundo
     (Precio 29.69)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Calabacin] [Centeno] [Bulgur] [Aceitunas] [Habas])
  )

  ([Salteado_de_Berenjena_Alcachofa_y_Habas_mediterranea] of Segundo
     (Precio 21.53)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_altramuces])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Habas] [Berenjena] [Altramuces] [Alcachofa] [Pimiento_rojo])
  )

  ([Papillote_de_Berenjena_Higo_y_Aceitunas_iberica] of Segundo
     (Precio 16.83)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Higo] [Zanahoria] [Aceitunas] [Pinones] [Berenjena])
  )

  ([Plancha_de_Setas_Tofu_de_soja_y_Calabacin_mediterranea] of Segundo
     (Precio 25.62)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_soja] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Tofu_de_soja] [Calabacin] [Tomate] [Masa_de_pizza] [Setas])
  )

  ([Salteado_de_Naranja_Lentejas_y_Tomate_mediterranea] of Segundo
     (Precio 14.88)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Otono])
     (usa_ingrediente [Garbanzos] [Naranja] [Lentejas] [Limon] [Tomate])
  )

  ([Parrillada_de_Pera_Setas_y_Cebolla_iberica] of Segundo
     (Precio 28.27)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pan_de_trigo] [Oregano] [Pera] [Cebolla] [Setas])
  )

  ([Braseado_de_Lentejas_Altramuces_y_Pimiento_verde_mediterranea] of Segundo
     (Precio 23.76)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Lentejas] [Altramuces] [Avellanas] [Pimiento_verde] [Pimiento_rojo])
  )

  ([Papillote_de_Manzana_Hinojo_y_Tofu_de_soja_levantina] of Segundo
     (Precio 28.8)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_soja])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Tofu_de_soja] [Manzana] [Nueces] [Hinojo])
  )

  ([Braseado_de_Remolacha_Champinones_y_Tofu_de_soja_helenica] of Segundo
     (Precio 22.7)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_soja] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Champinones] [Judiones] [Tofu_de_soja] [Remolacha] [Pasta])
  )

  ([Parrillada_de_Aceitunas_italica] of Segundo
     (Precio 19.26)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Quinoa] [Aceitunas] [Maiz] [Nueces] [Pinones])
  )

  ([Horno_de_Garbanzos_Cebolla_y_Pimiento_verde_levantina] of Segundo
     (Precio 27.61)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Garbanzos] [Hinojo] [Almendras] [Pimiento_verde] [Cebolla])
  )

  ([Estofado_de_Alubias_blancas_Champinones_y_Sandia_italica] of Segundo
     (Precio 31.22)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Champinones] [Oregano] [Lentejas] [Sandia] [Alubias_blancas])
  )

  ([Plancha_de_Perejil_Habas_y_Manzana_iberica] of Segundo
     (Precio 24.15)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_cacahuetes])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Manzana] [Alubias_blancas] [Perejil] [Cacahuetes] [Habas])
  )

  ([Plancha_de_Alubias_blancas_Rucula_y_Habas_levantina] of Segundo
     (Precio 16.61)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Hinojo] [Habas] [Pera] [Alubias_blancas] [Rucula])
  )

  ([Estofado_de_Pera_Menta_mediterranea] of Segundo
     (Precio 12.42)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Harina_de_trigo] [Menta] [Maiz] [Pera] [Cacahuetes])
  )

  ([Plancha_de_Pimiento_rojo_Pepino_y_Higo_levantina] of Segundo
     (Precio 22.66)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Quinoa] [Pistachos] [Pepino] [Granada] [Pimiento_rojo] [Higo] [Harina_de_trigo])
  )

  ([Estofado_de_Acelgas_Zanahoria_y_Alcachofa_iberica] of Segundo
     (Precio 37.37)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_sesamo] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Alcachofa] [Sesamo] [Zanahoria] [Acelgas] [Cebada])
  )

  ([Parrillada_de_Oregano_Remolacha_y_Tomillo_helenica] of Segundo
     (Precio 25.85)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Oregano] [Remolacha] [Tomillo] [Masa_de_pizza] [Altramuces])
  )

  ([Papillote_de_Pimiento_rojo_Pepino_y_Altramuces_levantina] of Segundo
     (Precio 16.97)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pepino] [Altramuces] [Quinoa] [Pimiento_rojo] [Harina_de_trigo])
  )

  ([Estofado_de_Oregano_Melon_y_Sandia_helenica] of Segundo
     (Precio 25.2)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Sandia] [Cacahuetes] [Cebada] [Patata] [Melon] [Oregano])
  )

  ([Estofado_de_Pimiento_rojo_Granada_y_Higo_italica] of Segundo
     (Precio 18.95)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pimiento_rojo] [Espinacas] [Higo] [Pera] [Granada] [Calabacin] [Hinojo])
  )

  ([Guiso_de_Limon_Lentejas_y_Altramuces_levantina] of Segundo
     (Precio 23.49)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_altramuces])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Limon] [Hinojo] [Pimiento_rojo] [Altramuces] [Lentejas])
  )

  ([Guiso_de_Pimiento_rojo_Lentejas_y_Perejil_italica] of Segundo
     (Precio 26.41)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Cuscus] [Cebolla] [Perejil] [Lentejas] [Pepino] [Pimiento_verde] [Pimiento_rojo])
  )

  ([Parrillada_de_Remolacha_Patata_y_Higo_levantina] of Segundo
     (Precio 13.56)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Patata] [Higo] [Nueces] [Pan_de_trigo] [Lechuga_romana] [Remolacha])
  )

  ([Salteado_de_Rucula_Pimiento_rojo_y_Ajo_iberica] of Segundo
     (Precio 34.55)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Albahaca] [Ajo] [Pan_de_trigo] [Rucula] [Perejil] [Pimiento_rojo])
  )

  ([Estofado_de_Garbanzos_Manzana_y_Naranja_helenica] of Segundo
     (Precio 31.22)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Naranja] [Manzana] [Pan_de_trigo] [Harina_de_trigo] [Garbanzos])
  )

  ([Horno_de_Melon_Alcachofa_y_Garbanzos_mediterranea] of Segundo
     (Precio 16.25)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Melon] [Alcachofa] [Nueces] [Garbanzos] [Judiones])
  )

  ([Plancha_de_Pulpo_Tofu_de_soja_y_Naranja_mediterranea] of Segundo
     (Precio 27.67)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_moluscos] [Alergia_a_soja] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Harina_de_trigo] [Melon] [Pulpo] [Tofu_de_soja] [Naranja] [Zanahoria])
  )

  ([Salteado_de_Pepino_Pulpo_y_Huevo_italica] of Segundo
     (Precio 14.91)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_huevos] [Alergia_a_moluscos] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pistachos] [Sardinas] [Pepino] [Quinoa] [Aceitunas] [Huevo] [Cuscus] [Pulpo])
  )

  ([Braseado_de_Merluza_Pimiento_verde_y_Tomate_levantina] of Segundo
     (Precio 30.55)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Merluza] [Sandia] [Cebada] [Tomate] [Leche] [Pasta] [Pimiento_verde])
  )

  ([Papillote_de_Sandia_Ternera_y_Altramuces_levantina] of Segundo
     (Precio 24.02)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_frutos_con_cascara] [Alergia_a_soja] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Altramuces] [Lubina] [Ternera] [Tofu_de_soja] [Avellanas] [Sandia] [Centeno])
  )

  ([Braseado_de_Albahaca_Espinacas_y_Alubias_blancas_mediterranea] of Segundo
     (Precio 26.49)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_sesamo])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Espinacas] [Sesamo] [Alubias_blancas] [Langostino] [Albahaca])
  )

  ([Guiso_de_Dorada_Garbanzos_y_Tomillo_levantina] of Segundo
     (Precio 14.49)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Espinacas] [Garbanzos] [Dorada] [Calabacin] [Bulgur] [Queso_feta] [Tomillo])
  )

  ([Salteado_de_Habas_Calamar_y_Setas_mediterranea] of Segundo
     (Precio 15.32)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Habas] [Albahaca] [Bulgur] [Acelgas] [Setas] [Calamar])
  )

  ([Plancha_de_Calabacin_Altramuces_y_Atun_italica] of Segundo
     (Precio 16.11)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_moluscos] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Calabacin] [Atun] [Limon] [Centeno] [Calamar] [Altramuces] [Berenjena])
  )

  ([Papillote_de_Champinones_Pulpo_y_Merluza_italica] of Segundo
     (Precio 20.71)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_moluscos] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Nueces] [Albahaca] [Pulpo] [Champinones] [Merluza] [Bacalao])
  )

  ([Horno_de_Pimiento_verde_Espinacas_y_Champinones_levantina] of Segundo
     (Precio 24.36)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_moluscos] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Champinones] [Naranja] [Mejillon] [Espinacas] [Bacalao] [Pimiento_verde] [Merluza])
  )

  ([Horno_de_Higo_Pollo_y_Melon_italica] of Segundo
     (Precio 35.27)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Verano])
     (usa_ingrediente [Cebada] [Pollo] [Higo] [Pan_de_trigo] [Aceitunas] [Habas] [Melon])
  )

  ([Estofado_de_Cebolla_Albahaca_y_Ternera_mediterranea] of Segundo
     (Precio 20.63)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Calabacin] [Almendras] [Cebolla] [Albahaca] [Naranja] [Ternera])
  )

  ([Guiso_de_Ternera_Ricotta_y_Remolacha_levantina] of Segundo
     (Precio 32.79)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Otono])
     (usa_ingrediente [Cuscus] [Ternera] [Champinones] [Remolacha] [Cacahuetes] [Ricotta])
  )

  ([Horno_de_Ajo_Apio_y_Higo_iberica] of Segundo
     (Precio 14.47)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Ricotta] [Espinacas] [Ajo] [Higo] [Pinones] [Apio] [Champinones] [Calabacin] [Merluza])
  )

  ([Horno_de_Huevo_Pollo_y_Tomate_levantina] of Segundo
     (Precio 15.66)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_huevos] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pimiento_verde] [Pan_de_trigo] [Pollo] [Tomate] [Huevo] [Ternera] [Almendras])
  )

  ([Guiso_de_Sandia_Pimiento_verde_y_Pollo_helenica] of Segundo
     (Precio 26.71)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Masa_de_pizza] [Quinoa] [Pimiento_verde] [Yogur_griego] [Sandia] [Pollo])
  )

  ([Guiso_de_Champinones_Mozzarella_y_Lentejas_levantina] of Segundo
     (Precio 24.75)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Hinojo] [Arroz] [Centeno] [Champinones] [Espinacas] [Mozzarella] [Lentejas])
  )

  ([Parrillada_de_Habas_Menta_y_Naranja_helenica] of Segundo
     (Precio 16.66)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_soja])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Habas] [Tofu_de_soja] [Naranja] [Pera] [Menta] [Remolacha] [Setas] [Aceitunas])
  )

  ([Papillote_de_Sardinas_Judiones_y_Berenjena_levantina] of Segundo
     (Precio 19.35)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Berenjena] [Sardinas] [Melon] [Higo] [Judiones] [Pistachos])
  )

  ([Horno_de_Tomate_Dorada_y_Aceitunas_iberica] of Segundo
     (Precio 28.24)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Yogur_griego] [Bonito] [Aceitunas] [Dorada] [Oregano] [Melocoton] [Tomate])
  )

  ([Parrillada_de_Aceitunas_Granada_y_Yogur_griego_levantina] of Segundo
     (Precio 26.81)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Yogur_griego] [Uva] [Aceitunas] [Centeno] [Granada] [Atun])
  )

  ([Papillote_de_Habas_Calamar_y_Leche_levantina] of Segundo
     (Precio 25.57)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_a_sesamo])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Leche] [Calamar] [Gamba] [Habas] [Maiz] [Sesamo])
  )

  ([Plancha_de_Bonito_Pollo_y_Calamar_helenica] of Segundo
     (Precio 23.69)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_crustaceos] [Alergia_a_moluscos] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Calamar] [Arroz] [Alcachofa] [Gamba] [Pollo] [Zanahoria] [Apio] [Bonito])
  )

  ([Estofado_de_Sandia_Tomate_y_Lubina_mediterranea] of Segundo
     (Precio 33.08)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Sandia] [Lubina] [Tomate] [Pistachos] [Habas])
  )

  ([Horno_de_Espinacas_Bacalao_y_Aceitunas_mediterranea] of Segundo
     (Precio 22.46)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_sesamo] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Masa_de_pizza] [Aceitunas] [Quinoa] [Sesamo] [Bacalao] [Espinacas] [Cacahuetes])
  )

  ([Parrillada_de_Yogur_griego_Tomate_y_Dorada_iberica] of Segundo
     (Precio 18.37)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Quinoa] [Yogur_griego] [Dorada] [Tomate] [Pan_de_trigo])
  )

  ([Plancha_de_Garbanzos_Mozzarella_italica] of Segundo
     (Precio 22.74)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Garbanzos] [Arroz] [Pistachos] [Cacahuetes] [Mozzarella])
  )

  ([Parrillada_de_Calabacin_Granada_y_Dorada_helenica] of Segundo
     (Precio 37.53)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Pinones] [Granada] [Avellanas] [Calabacin] [Masa_de_pizza] [Dorada])
  )

  ([Plancha_de_Manzana_Mozzarella_y_Judiones_helenica] of Segundo
     (Precio 16.02)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Almendras] [Pinones] [Mozzarella] [Manzana] [Judiones])
  )

  ([Plancha_de_Naranja_Uva_y_Manzana_iberica] of Segundo
     (Precio 21.44)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Bonito] [Hinojo] [Uva] [Manzana] [Naranja] [Bulgur])
  )

  ([Salteado_de_Habas_Naranja_y_Manzana_helenica] of Segundo
     (Precio 30.52)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_sesamo] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Uva] [Sesamo] [Cebada] [Higo] [Manzana] [Pimiento_rojo] [Naranja] [Habas])
  )

  ([Papillote_de_Menta_Naranja_y_Aceitunas_iberica] of Segundo
     (Precio 26.17)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_sesamo] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Aceitunas] [Naranja] [Centeno] [Sesamo] [Menta] [Gamba])
  )

  ([Guiso_de_Cordero_Sardinas_y_Lentejas_helenica] of Segundo
     (Precio 13.39)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Lentejas] [Nueces] [Bulgur] [Cordero] [Calabacin] [Sardinas])
  )

  ([Guiso_de_Pulpo_Hinojo_y_Cordero_iberica] of Segundo
     (Precio 34.72)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_moluscos])
     (se_sirve_en [Otono])
     (usa_ingrediente [Hinojo] [Pinones] [Tomate] [Cordero] [Pulpo])
  )

  ([Papillote_de_Pulpo_Tomillo_y_Manzana_iberica] of Segundo
     (Precio 32.72)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_moluscos] [Alergia_a_sesamo])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pulpo] [Sesamo] [Tomate] [Manzana] [Tomillo])
  )

  ([Plancha_de_Apio_Remolacha_y_Garbanzos_mediterranea] of Segundo
     (Precio 24.21)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_cacahuetes])
     (se_sirve_en [Verano])
     (usa_ingrediente [Albahaca] [Remolacha] [Apio] [Berenjena] [Maiz] [Cacahuetes] [Garbanzos])
  )

  ([Horno_de_Melocoton_Huevo_y_Mejillon_italica] of Segundo
     (Precio 22.61)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_huevos] [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Queso_feta] [Mejillon] [Pinones] [Pasta] [Huevo] [Lentejas] [Melocoton])
  )

  ([Braseado_de_Oregano_Hinojo_y_Sardinas_levantina] of Segundo
     (Precio 20.63)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Setas] [Quinoa] [Pinones] [Cordero] [Oregano] [Hinojo] [Sardinas] [Queso_manchego])
  )

  ([Salteado_de_Granada_Lechuga_romana_y_Judiones_italica] of Segundo
     (Precio 25.33)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Gamba] [Pollo] [Granada] [Lechuga_romana] [Judiones] [Espinacas] [Dorada])
  )

  ([Salteado_de_Garbanzos_Cebolla_y_Dorada_levantina] of Segundo
     (Precio 22.07)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_sesamo] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Cebolla] [Dorada] [Pasta] [Garbanzos] [Sesamo])
  )

  ([Parrillada_de_Pollo_Menta_y_Apio_mediterranea] of Segundo
     (Precio 22.24)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_cacahuetes] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pollo] [Menta] [Leche] [Cacahuetes] [Apio])
  )

  ([Tarta_de_Melocoton_Melon_y_Pollo_iberica] of Postre
     (Precio 8.28)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Almendras] [Melon] [Nueces] [Melocoton] [Pollo])
  )

  ([Tarta_de_Mozzarella_Melon_y_Cordero_iberica] of Postre
     (Precio 5.57)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Melon] [Mozzarella] [Pistachos] [Almendras] [Leche] [Ricotta] [Yogur_griego] [Cordero])
  )

  ([Mousse_de_Melocoton_Pulpo_y_Mozzarella_italica] of Postre
     (Precio 8.31)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_moluscos])
     (se_sirve_en [Otono])
     (usa_ingrediente [Uva] [Melocoton] [Melon] [Sandia] [Mozzarella] [Pinones] [Nueces] [Pulpo])
  )

  ([Mousse_de_Yogur_griego_Granada_y_Ricotta_iberica] of Postre
     (Precio 5.37)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pinones] [Avellanas] [Granada] [Ricotta] [Yogur_griego] [Cordero])
  )

  ([Tarta_de_Granada_Sandia_y_Mozzarella_levantina] of Postre
     (Precio 10.46)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_moluscos])
     (se_sirve_en [Verano])
     (usa_ingrediente [Leche] [Granada] [Mozzarella] [Pistachos] [Ricotta] [Sandia] [Nueces] [Calamar])
  )

  ([Sorbete_de_Uva_Manzana_y_Yogur_griego_italica] of Postre
     (Precio 5.43)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Almendras] [Ricotta] [Higo] [Sandia] [Uva] [Yogur_griego] [Manzana] [Lubina])
  )

  ([Tarta_de_Granada_Pera_y_Melocoton_helenica] of Postre
     (Precio 6.44)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Yogur_griego] [Ricotta] [Pistachos] [Melocoton] [Granada] [Pera] [Higo] [Dorada])
  )

  ([Mousse_de_Sandia_Granada_y_Cerdo_levantina] of Postre
     (Precio 8.75)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Granada] [Avellanas] [Sandia] [Ricotta] [Cerdo])
  )

  ([Helado_de_Granada_Bacalao_y_Mozzarella_mediterranea] of Postre
     (Precio 6.24)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Granada] [Pinones] [Avellanas] [Mozzarella] [Bacalao])
  )

  ([Panna_Cotta_de_Manzana_Uva_y_Yogur_griego_iberica] of Postre
     (Precio 8.84)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Uva] [Manzana] [Pistachos] [Yogur_griego] [Atun])
  )

  ([Panna_Cotta_de_Manzana_Ricotta_y_Yogur_griego_helenica] of Postre
     (Precio 6.13)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Melon] [Leche] [Ricotta] [Avellanas] [Manzana] [Yogur_griego] [Pera] [Lubina])
  )

  ([Tarta_de_Mozzarella_Pera_y_Higo_italica] of Postre
     (Precio 7.43)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Pera] [Mozzarella] [Melon] [Ricotta] [Higo] [Melocoton] [Avellanas] [Gamba])
  )

  ([Sorbete_de_Leche_Sandia_y_Pulpo_levantina] of Postre
     (Precio 12.24)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_moluscos])
     (se_sirve_en [Otono])
     (usa_ingrediente [Sandia] [Pinones] [Leche] [Granada] [Pistachos] [Manzana] [Pulpo])
  )

  ([Sorbete_de_Uva_Calamar_y_Higo_iberica] of Postre
     (Precio 4.15)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_moluscos])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pinones] [Manzana] [Mozzarella] [Avellanas] [Uva] [Yogur_griego] [Higo] [Calamar])
  )

  ([Mousse_de_Granada_Sandia_y_Dorada_italica] of Postre
     (Precio 10.72)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Granada] [Sandia] [Avellanas] [Pinones] [Dorada])
  )

  ([Panna_Cotta_de_Ricotta_Granada_y_Bacalao_mediterranea] of Postre
     (Precio 7.89)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Mozzarella] [Granada] [Pera] [Nueces] [Ricotta] [Bacalao])
  )

  ([Mousse_de_Melon_Leche_y_Langostino_levantina] of Postre
     (Precio 8.32)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Melon] [Leche] [Pinones] [Nueces] [Sandia] [Langostino])
  )

  ([Sorbete_de_Uva_Sandia_y_Pulpo_italica] of Postre
     (Precio 9.35)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_moluscos])
     (se_sirve_en [Verano])
     (usa_ingrediente [Melocoton] [Higo] [Sandia] [Uva] [Pistachos] [Pinones] [Pulpo])
  )

  ([Macedonia_de_Manzana_Pera_y_Bacalao_iberica] of Postre
     (Precio 9.98)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Melocoton] [Pera] [Pinones] [Manzana] [Yogur_griego] [Bacalao])
  )

  ([Macedonia_de_Cordero_Melon_y_Melocoton_italica] of Postre
     (Precio 7.02)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Granada] [Melon] [Uva] [Sandia] [Melocoton] [Pistachos] [Pinones] [Cordero])
  )

  ([Macedonia_de_Langostino_Mozzarella_y_Leche_iberica] of Postre
     (Precio 4.55)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Sandia] [Avellanas] [Leche] [Mozzarella] [Pera] [Nueces] [Langostino])
  )

  ([Macedonia_de_Dorada_Ricotta_y_Melocoton_italica] of Postre
     (Precio 9.5)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pera] [Pistachos] [Higo] [Uva] [Ricotta] [Melocoton] [Dorada])
  )

  ([Panna_Cotta_de_Pera_Uva_y_Cordero_helenica] of Postre
     (Precio 8.55)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Almendras] [Pera] [Avellanas] [Uva] [Cordero])
  )

  ([Panna_Cotta_de_Calamar_Leche_y_Yogur_griego_mediterranea] of Postre
     (Precio 8.73)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_moluscos])
     (se_sirve_en [Verano])
     (usa_ingrediente [Leche] [Melocoton] [Sandia] [Higo] [Yogur_griego] [Melon] [Almendras] [Calamar])
  )

  ([Crema_Dulce_de_Melon_Yogur_griego_y_Melocoton_helenica] of Postre
     (Precio 6.38)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Melon] [Pinones] [Melocoton] [Yogur_griego] [Pera] [Almendras] [Leche] [Merluza])
  )

  ([Sorbete_de_Gamba_Higo_y_Melocoton_helenica] of Postre
     (Precio 8.14)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Mozzarella] [Higo] [Ricotta] [Melocoton] [Manzana] [Pistachos] [Avellanas] [Gamba])
  )

  ([Macedonia_de_Melocoton_Ternera_y_Sandia_mediterranea] of Postre
     (Precio 4.96)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Pistachos] [Avellanas] [Sandia] [Melocoton] [Ternera])
  )

  ([Helado_de_Bacalao_Yogur_griego_y_Higo_levantina] of Postre
     (Precio 7.42)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pera] [Almendras] [Melon] [Higo] [Yogur_griego] [Bacalao])
  )

  ([Panna_Cotta_de_Gamba_Yogur_griego_italica] of Postre
     (Precio 10.72)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Nueces] [Yogur_griego] [Pinones] [Pistachos] [Gamba])
  )

  ([Crema_Dulce_de_Ricotta_Melon_y_Mejillon_levantina] of Postre
     (Precio 7.88)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_moluscos])
     (se_sirve_en [Verano])
     (usa_ingrediente [Sandia] [Melon] [Ricotta] [Higo] [Mejillon])
  )

  ([Crema_Dulce_de_Melocoton_Leche_y_Ricotta_levantina] of Postre
     (Precio 6.46)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Nueces] [Melocoton] [Ricotta] [Pinones] [Higo] [Granada] [Leche] [Langostino])
  )

  ([Panna_Cotta_de_Sandia_Ricotta_y_Leche_levantina] of Postre
     (Precio 8.19)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pistachos] [Granada] [Leche] [Sandia] [Ricotta] [Pinones] [Higo] [Gamba])
  )

  ([Crema_Dulce_de_Pera_Calamar_y_Manzana_helenica] of Postre
     (Precio 10.27)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_moluscos])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pera] [Higo] [Manzana] [Avellanas] [Calamar])
  )

  ([Tarta_de_Higo_Leche_y_Mejillon_italica] of Postre
     (Precio 5.3)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_moluscos])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Leche] [Higo] [Manzana] [Ricotta] [Nueces] [Avellanas] [Pinones] [Mejillon])
  )

  ([Tarta_de_Melocoton_Pollo_y_Manzana_levantina] of Postre
     (Precio 8.87)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Ricotta] [Avellanas] [Almendras] [Pistachos] [Manzana] [Melocoton] [Pollo])
  )

  ([Crema_Dulce_de_Higo_Leche_y_Gamba_mediterranea] of Postre
     (Precio 12.26)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Melon] [Pistachos] [Avellanas] [Leche] [Higo] [Gamba])
  )

  ([Tarta_de_Pera_Langostino_y_Melocoton_levantina] of Postre
     (Precio 10.82)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Uva] [Melon] [Pera] [Pistachos] [Avellanas] [Melocoton] [Yogur_griego] [Langostino])
  )

  ([Helado_de_Ricotta_Manzana_y_Sandia_helenica] of Postre
     (Precio 8.19)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Ricotta] [Pistachos] [Uva] [Manzana] [Sandia] [Cordero])
  )

  ([Crema_Dulce_de_Gamba_Melon_y_Yogur_griego_mediterranea] of Postre
     (Precio 7.72)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Avellanas] [Pistachos] [Yogur_griego] [Melon] [Almendras] [Gamba])
  )

  ([Compota_de_Pera_Uva_y_Yogur_griego_italica] of Postre
     (Precio 8.93)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pera] [Yogur_griego] [Uva] [Granada] [Leche] [Nueces] [Manzana] [Dorada])
  )

  ([Crema_Dulce_de_Pollo_Sandia_y_Leche_mediterranea] of Postre
     (Precio 12.27)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Mozzarella] [Granada] [Ricotta] [Leche] [Sandia] [Manzana] [Avellanas] [Pollo])
  )

  ([Compota_de_Pera_Sandia_y_Bacalao_mediterranea] of Postre
     (Precio 7.11)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_pescado])
     (se_sirve_en [Verano])
     (usa_ingrediente [Pera] [Pinones] [Melocoton] [Sandia] [Bacalao])
  )

  ([Panna_Cotta_de_Melocoton_Huevo_y_Higo_helenica] of Postre
     (Precio 8.68)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_huevos])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Melocoton] [Avellanas] [Melon] [Higo] [Huevo])
  )

  ([Mousse_de_Granada_Higo_y_Manzana_helenica] of Postre
     (Precio 10.1)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Nueces] [Granada] [Almendras] [Manzana] [Sandia] [Higo] [Uva] [Mozzarella])
  )

  ([Crema_Dulce_de_Leche_Uva_mediterranea] of Postre
     (Precio 4.03)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Almendras] [Uva] [Leche] [Pinones])
  )

  ([Macedonia_de_Leche_Ricotta_y_Sandia_helenica] of Postre
     (Precio 9.57)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Manzana] [Granada] [Melon] [Sandia] [Leche] [Ricotta])
  )

  ([Macedonia_de_Sandia_Yogur_griego_y_Granada_levantina] of Postre
     (Precio 7.62)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pistachos] [Sandia] [Granada] [Pinones] [Yogur_griego])
  )

  ([Tarta_de_Melon_Manzana_y_Leche_mediterranea] of Postre
     (Precio 8.75)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Melon] [Mozzarella] [Avellanas] [Manzana] [Nueces] [Leche] [Higo])
  )

  ([Panna_Cotta_de_Yogur_griego_Sandia_y_Higo_helenica] of Postre
     (Precio 9.01)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Higo] [Sandia] [Yogur_griego] [Melon] [Almendras] [Melocoton])
  )

  ([Tarta_de_Granada_Mozzarella_levantina] of Postre
     (Precio 6.0)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Almendras] [Mozzarella] [Nueces] [Granada])
  )

  ([Tarta_de_Pera_Sandia_y_Leche_italica] of Postre
     (Precio 6.11)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Leche] [Uva] [Pistachos] [Pera] [Sandia] [Nueces])
  )

  ([Tarta_de_Melocoton_Pera_y_Melon_mediterranea] of Postre
     (Precio 7.53)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Avellanas] [Melocoton] [Yogur_griego] [Melon] [Pistachos] [Pera] [Almendras])
  )

  ([Sorbete_de_Pera_Sandia_y_Yogur_griego_mediterranea] of Postre
     (Precio 9.56)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Avellanas] [Yogur_griego] [Sandia] [Pera])
  )

  ([Helado_de_Mozzarella_Melon_y_Sandia_helenica] of Postre
     (Precio 8.15)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Melon] [Pistachos] [Mozzarella] [Sandia] [Uva] [Ricotta])
  )

  ([Macedonia_de_Pera_Yogur_griego_y_Leche_levantina] of Postre
     (Precio 7.71)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Ricotta] [Leche] [Yogur_griego] [Pera] [Pistachos])
  )

  ([Crema_Dulce_de_Sandia_Yogur_griego_y_Leche_levantina] of Postre
     (Precio 8.95)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Leche] [Avellanas] [Sandia] [Yogur_griego] [Pistachos])
  )

  ([Macedonia_de_Ricotta_Melocoton_y_Mozzarella_italica] of Postre
     (Precio 6.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Melocoton] [Manzana] [Ricotta] [Higo] [Mozzarella])
  )

  ([Panna_Cotta_de_Melocoton_Pera_y_Leche_italica] of Postre
     (Precio 4.79)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Manzana] [Uva] [Pera] [Leche] [Melocoton] [Almendras] [Mozzarella])
  )

  ([Sorbete_de_Ricotta_Manzana_y_Sandia_italica] of Postre
     (Precio 6.54)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Ricotta] [Nueces] [Pistachos] [Manzana] [Almendras] [Sandia])
  )

  ([Compota_de_Granada_Pera_y_Ricotta_iberica] of Postre
     (Precio 8.61)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pera] [Higo] [Almendras] [Granada] [Ricotta])
  )

  ([Tarta_de_Mozzarella_Yogur_griego_y_Higo_iberica] of Postre
     (Precio 10.47)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Mozzarella] [Pinones] [Higo] [Yogur_griego] [Almendras])
  )

  ([Panna_Cotta_de_Mozzarella_Melocoton_y_Higo_iberica] of Postre
     (Precio 8.3)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Higo] [Nueces] [Avellanas] [Mozzarella] [Almendras] [Melocoton])
  )

  ([Macedonia_de_Leche_Sandia_y_Pera_mediterranea] of Postre
     (Precio 6.36)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Avellanas] [Leche] [Sandia] [Uva] [Nueces] [Pera] [Ricotta])
  )

  ([Crema_Dulce_de_Leche_Melon_y_Higo_mediterranea] of Postre
     (Precio 11.96)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Melon] [Leche] [Yogur_griego] [Higo] [Ricotta] [Mozzarella])
  )

  ([Helado_de_Manzana_Melon_y_Queso_manchego_mediterranea] of Postre
     (Precio 5.41)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pistachos] [Melon] [Nueces] [Manzana] [Queso_manchego])
  )

  ([Panna_Cotta_de_Ricotta_Manzana_y_Melon_mediterranea] of Postre
     (Precio 8.19)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Melon] [Nueces] [Pistachos] [Manzana] [Almendras] [Higo] [Avellanas] [Ricotta])
  )

  ([Compota_de_Uva_Leche_y_Higo_helenica] of Postre
     (Precio 5.67)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Higo] [Uva] [Leche] [Mozzarella] [Pistachos])
  )

  ([Compota_de_Leche_Manzana_y_Pera_italica] of Postre
     (Precio 8.27)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Leche] [Manzana] [Pinones] [Pera])
  )

  ([Tarta_de_Uva_Granada_y_Manzana_italica] of Postre
     (Precio 7.11)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pinones] [Granada] [Uva] [Manzana] [Ricotta] [Nueces])
  )

  ([Crema_Dulce_de_Granada_Mozzarella_y_Yogur_griego_levantina] of Postre
     (Precio 12.12)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Granada] [Mozzarella] [Yogur_griego] [Melon] [Almendras] [Avellanas])
  )

  ([Macedonia_de_Melocoton_Mozzarella_y_Uva_helenica] of Postre
     (Precio 4.54)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Uva] [Mozzarella] [Melocoton] [Pinones])
  )

  ([Tarta_de_Yogur_griego_Granada_y_Pera_levantina] of Postre
     (Precio 9.4)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Granada] [Yogur_griego] [Mozzarella] [Leche] [Pera] [Ricotta] [Avellanas])
  )

  ([Sorbete_de_Mozzarella_Pera_y_Leche_iberica] of Postre
     (Precio 6.78)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Nueces] [Pera] [Almendras] [Mozzarella] [Leche])
  )

  ([Macedonia_de_Ricotta_Granada_y_Manzana_mediterranea] of Postre
     (Precio 6.64)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Granada] [Pera] [Manzana] [Ricotta])
  )

  ([Macedonia_de_Melocoton_Manzana_y_Yogur_griego_helenica] of Postre
     (Precio 7.04)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Uva] [Avellanas] [Almendras] [Nueces] [Pistachos] [Manzana] [Melocoton] [Yogur_griego])
  )

  ([Panna_Cotta_de_Melocoton_Higo_y_Melon_mediterranea] of Postre
     (Precio 4.08)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Melon] [Pistachos] [Melocoton] [Higo] [Avellanas] [Leche])
  )

  ([Sorbete_de_Uva_Yogur_griego_y_Pera_iberica] of Postre
     (Precio 6.35)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Yogur_griego] [Uva] [Melon] [Nueces] [Pera] [Almendras])
  )

  ([Mousse_de_Melon_Higo_y_Melocoton_italica] of Postre
     (Precio 12.44)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pera] [Sandia] [Manzana] [Melocoton] [Melon] [Nueces] [Higo] [Leche])
  )

  ([Panna_Cotta_de_Uva_Higo_y_Yogur_griego_levantina] of Postre
     (Precio 5.23)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Higo] [Almendras] [Avellanas] [Pistachos] [Nueces] [Yogur_griego] [Uva])
  )

  ([Macedonia_de_Melocoton_Higo_y_Sandia_italica] of Postre
     (Precio 8.95)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Leche] [Granada] [Almendras] [Uva] [Higo] [Sandia] [Melocoton])
  )

  ([Panna_Cotta_de_Pera_Melocoton_y_Melon_iberica] of Postre
     (Precio 9.83)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Pera] [Melon] [Yogur_griego] [Melocoton])
  )

  ([Mousse_de_Manzana_Yogur_griego_y_Higo_iberica] of Postre
     (Precio 5.91)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Ricotta] [Avellanas] [Yogur_griego] [Almendras] [Manzana] [Higo])
  )

  ([Macedonia_de_Uva_Yogur_griego_y_Sandia_levantina] of Postre
     (Precio 8.95)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Uva] [Yogur_griego] [Sandia] [Melocoton] [Ricotta])
  )

  ([Macedonia_de_Sandia_Higo_helenica] of Postre
     (Precio 9.62)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Nueces] [Higo] [Almendras] [Sandia] [Pistachos])
  )

  ([Helado_de_Manzana_Melocoton_y_Uva_italica] of Postre
     (Precio 6.74)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pistachos] [Manzana] [Uva] [Melocoton])
  )

  ([Tarta_de_Uva_Habas_y_Melon_helenica] of Postre
     (Precio 5.11)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Pinones] [Melon] [Uva] [Habas])
  )

  ([Tarta_de_Manzana_Pera_y_Sandia_helenica] of Postre
     (Precio 10.2)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Nueces] [Pinones] [Pera] [Manzana] [Sandia])
  )

  ([Macedonia_de_Manzana_Uva_mediterranea] of Postre
     (Precio 9.61)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Uva] [Nueces] [Avellanas] [Manzana] [Pinones] [Pistachos])
  )

  ([Helado_de_Uva_Manzana_y_Higo_levantina] of Postre
     (Precio 8.93)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Pera] [Manzana] [Melocoton] [Pistachos] [Higo] [Uva])
  )

  ([Panna_Cotta_de_Melocoton_Granada_y_Higo_italica] of Postre
     (Precio 12.65)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Almendras] [Pinones] [Granada] [Melocoton] [Higo])
  )

  ([Mousse_de_Uva_Higo_y_Pera_italica] of Postre
     (Precio 6.81)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pera] [Avellanas] [Higo] [Uva])
  )

  ([Tarta_de_Tofu_de_soja_Manzana_y_Granada_iberica] of Postre
     (Precio 5.16)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_soja])
     (se_sirve_en [Otono])
     (usa_ingrediente [Almendras] [Granada] [Manzana] [Tofu_de_soja])
  )

  ([Tarta_de_Manzana_Pera_iberica] of Postre
     (Precio 12.04)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Manzana] [Pera] [Nueces])
  )

  ([Helado_de_Manzana_Melocoton_iberica] of Postre
     (Precio 8.59)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Manzana] [Pinones] [Melocoton] [Maiz])
  )

  ([Helado_de_Uva_Sandia_y_Melon_levantina] of Postre
     (Precio 4.49)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Avellanas] [Uva] [Pistachos] [Sandia] [Melon])
  )

  ([Macedonia_de_Granada_helenica] of Postre
     (Precio 5.08)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pistachos] [Almendras] [Granada] [Pinones] [Nueces])
  )

  ([Sorbete_de_Manzana_Pera_mediterranea] of Postre
     (Precio 4.55)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Nueces] [Manzana] [Almendras] [Pera])
  )

  ([Panna_Cotta_de_Perejil_Pera_iberica] of Postre
     (Precio 10.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Almendras] [Avellanas] [Pera] [Perejil])
  )

  ([Crema_Dulce_de_Higo_Sandia_y_Melocoton_iberica] of Postre
     (Precio 5.87)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Higo] [Almendras] [Pera] [Sandia] [Nueces] [Pinones] [Melocoton])
  )

  ([Mousse_de_Uva_Melon_y_Pera_iberica] of Postre
     (Precio 8.49)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Uva] [Pera] [Melon] [Pistachos] [Sandia])
  )

  ([Mousse_de_Uva_Sandia_italica] of Postre
     (Precio 7.41)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Avellanas] [Pinones] [Sandia] [Uva])
  )

  ([Panna_Cotta_de_Altramuces_Pimiento_verde_levantina] of Postre
     (Precio 5.67)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Nueces] [Altramuces] [Pimiento_verde] [Avellanas])
  )

  ([Mousse_de_Higo_Pimiento_verde_y_Pera_iberica] of Postre
     (Precio 5.04)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Higo] [Nueces] [Pera] [Pimiento_verde])
  )

  ([Sorbete_de_Pera_Melocoton_italica] of Postre
     (Precio 8.07)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Melocoton] [Pistachos] [Pera] [Maiz])
  )

  ([Crema_Dulce_de_Uva_Manzana_iberica] of Postre
     (Precio 9.21)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Avellanas] [Manzana] [Pistachos] [Uva])
  )

  ([Helado_de_Uva_Pera_y_Aceitunas_italica] of Postre
     (Precio 9.94)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Pistachos] [Uva] [Pera] [Aceitunas])
  )

  ([Macedonia_de_Pera_helenica] of Postre
     (Precio 5.43)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Nueces] [Pistachos] [Pera] [Avellanas])
  )

  ([Macedonia_de_Uva_Higo_y_Pimiento_rojo_helenica] of Postre
     (Precio 9.57)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Otono])
     (usa_ingrediente [Uva] [Melon] [Higo] [Pimiento_rojo])
  )

  ([Tarta_de_Remolacha_Pera_y_Alcachofa_italica] of Postre
     (Precio 6.15)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pera] [Melocoton] [Alcachofa] [Remolacha])
  )

  ([Mousse_de_Higo_Melocoton_y_Pera_levantina] of Postre
     (Precio 12.75)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Uva] [Higo] [Pera] [Nueces] [Melocoton])
  )

  ([Tarta_de_Pera_Melon_y_Higo_mediterranea] of Postre
     (Precio 9.28)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Avellanas] [Melon] [Granada] [Higo] [Almendras] [Pera])
  )

  ([Crema_Dulce_de_Melon_Sandia_y_Granada_iberica] of Postre
     (Precio 5.9)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Nueces] [Pera] [Sandia] [Melon] [Granada])
  )

  ([Tarta_de_Uva_Higo_y_Pera_levantina] of Postre
     (Precio 6.38)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Almendras] [Higo] [Pera] [Uva] [Avellanas])
  )

  ([Compota_de_Zanahoria_Higo_y_Melocoton_mediterranea] of Postre
     (Precio 10.88)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Almendras] [Melocoton] [Higo] [Zanahoria])
  )

  ([Sorbete_de_Uva_Manzana_y_Melon_mediterranea] of Postre
     (Precio 11.12)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Almendras] [Avellanas] [Uva] [Nueces] [Melon] [Manzana])
  )

  ([Crema_Dulce_de_Melon_Melocoton_italica] of Postre
     (Precio 8.72)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Nueces] [Almendras] [Melon] [Melocoton])
  )

  ([Tarta_de_Sandia_Melocoton_y_Melon_mediterranea] of Postre
     (Precio 7.55)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Sandia] [Melon] [Melocoton] [Manzana] [Pinones])
  )

  ([Sorbete_de_Granada_Uva_mediterranea] of Postre
     (Precio 9.31)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Uva] [Nueces] [Pinones] [Granada])
  )

  ([Panna_Cotta_de_Sandia_Higo_iberica] of Postre
     (Precio 10.56)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Sandia] [Higo] [Nueces] [Harina_de_trigo])
  )

  ([Tarta_de_Melon_Granada_italica] of Postre
     (Precio 9.65)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Melon] [Granada] [Nueces] [Pistachos])
  )

  ([Crema_Dulce_de_Pera_Granada_y_Uva_levantina] of Postre
     (Precio 4.08)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Granada] [Pinones] [Pera] [Uva])
  )

  ([Macedonia_de_Manzana_Champinones_y_Altramuces_iberica] of Postre
     (Precio 8.44)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pistachos] [Manzana] [Altramuces] [Champinones])
  )

  ([Mousse_de_Manzana_Higo_iberica] of Postre
     (Precio 6.92)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Higo] [Pistachos] [Manzana] [Pan_de_trigo])
  )

  ([Crema_Dulce_de_Manzana_Melocoton_y_Uva_levantina] of Postre
     (Precio 11.56)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Avellanas] [Uva] [Pistachos] [Melocoton] [Manzana])
  )

  ([Crema_Dulce_de_Melocoton_Sandia_y_Uva_helenica] of Postre
     (Precio 5.48)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Nueces] [Avellanas] [Uva] [Melocoton] [Sandia])
  )

  ([Sorbete_de_Pera_Leche_y_Melon_helenica] of Postre
     (Precio 5.83)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Mozzarella] [Avellanas] [Sandia] [Leche] [Melon] [Pera])
  )

  ([Tarta_de_Uva_Melon_y_Granada_iberica] of Postre
     (Precio 10.32)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Granada] [Pistachos] [Avellanas] [Uva] [Higo] [Melon])
  )

  ([Crema_Dulce_de_Granada_Uva_y_Sandia_levantina] of Postre
     (Precio 9.66)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Uva] [Sandia] [Granada] [Pinones] [Avellanas])
  )

  ([Helado_de_Ricotta_Mozzarella_y_Pera_helenica] of Postre
     (Precio 8.44)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Mozzarella] [Higo] [Pera] [Almendras] [Ricotta] [Yogur_griego] [Uva])
  )

  ([Tarta_de_Melon_Higo_y_Melocoton_iberica] of Postre
     (Precio 8.87)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Yogur_griego] [Almendras] [Avellanas] [Melon] [Higo] [Melocoton])
  )

  ([Panna_Cotta_de_Manzana_Higo_y_Granada_helenica] of Postre
     (Precio 7.63)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Almendras] [Manzana] [Higo] [Granada])
  )

  ([Compota_de_Mozzarella_Higo_y_Melon_helenica] of Postre
     (Precio 9.61)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Melon] [Higo] [Pinones] [Mozzarella] [Yogur_griego])
  )

  ([Mousse_de_Sandia_Yogur_griego_y_Higo_iberica] of Postre
     (Precio 8.91)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Higo] [Yogur_griego] [Sandia] [Avellanas])
  )

  ([Compota_de_Yogur_griego_Manzana_y_Sandia_iberica] of Postre
     (Precio 8.4)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Granada] [Yogur_griego] [Sandia] [Pinones] [Avellanas] [Manzana])
  )

  ([Helado_de_Higo_Manzana_y_Leche_helenica] of Postre
     (Precio 4.64)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Ricotta] [Melocoton] [Leche] [Pistachos] [Pinones] [Manzana] [Higo])
  )

  ([Sorbete_de_Ricotta_Pera_y_Higo_iberica] of Postre
     (Precio 6.97)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Pinones] [Higo] [Nueces] [Almendras] [Pera] [Ricotta])
  )

  ([Helado_de_Uva_Melocoton_y_Granada_iberica] of Postre
     (Precio 9.17)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Verano])
     (usa_ingrediente [Melocoton] [Uva] [Granada] [Pistachos])
  )

  ([Sorbete_de_Mozzarella_Higo_y_Sandia_italica] of Postre
     (Precio 10.1)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Higo] [Yogur_griego] [Sandia] [Mozzarella])
  )

  ([Crema_Dulce_de_Ricotta_Pera_y_Melon_mediterranea] of Postre
     (Precio 4.22)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Ricotta] [Nueces] [Pinones] [Pera] [Melon])
  )

  ([Tarta_de_Leche_Uva_y_Higo_levantina] of Postre
     (Precio 6.69)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Leche] [Nueces] [Granada] [Uva] [Higo])
  )

  ([Compota_de_Manzana_Higo_y_Sandia_mediterranea] of Postre
     (Precio 12.78)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Ricotta] [Pinones] [Manzana] [Avellanas] [Sandia] [Higo])
  )

  ([Mousse_de_Melon_Melocoton_y_Mozzarella_mediterranea] of Postre
     (Precio 9.01)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Pinones] [Melon] [Pistachos] [Mozzarella] [Avellanas] [Melocoton] [Yogur_griego])
  )

  ([Mousse_de_Uva_Melon_y_Melocoton_helenica] of Postre
     (Precio 8.54)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Pistachos] [Higo] [Nueces] [Melon] [Uva] [Melocoton])
  )

  ([Panna_Cotta_de_Ricotta_Mozzarella_iberica] of Postre
     (Precio 7.18)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Ricotta] [Nueces] [Almendras] [Mozzarella])
  )

  ([Sorbete_de_Yogur_griego_Sandia_y_Higo_levantina] of Postre
     (Precio 5.24)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Granada] [Avellanas] [Sandia] [Higo] [Yogur_griego])
  )

  ([Helado_de_Ricotta_Higo_y_Yogur_griego_italica] of Postre
     (Precio 7.51)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pinones] [Yogur_griego] [Nueces] [Ricotta] [Avellanas] [Higo])
  )

  ([Tarta_de_Higo_Manzana_levantina] of Postre
     (Precio 6.56)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Avellanas] [Manzana] [Higo] [Pistachos])
  )

  ([Mousse_de_Uva_Melon_y_Mozzarella_italica] of Postre
     (Precio 9.98)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pera] [Melon] [Avellanas] [Uva] [Sandia] [Mozzarella])
  )

  ([Mousse_de_Pera_Manzana_y_Melon_italica] of Postre
     (Precio 11.81)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Manzana] [Melon] [Avellanas] [Pera])
  )

  ([Macedonia_de_Mozzarella_Pera_y_Leche_mediterranea] of Postre
     (Precio 10.9)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Melon] [Pinones] [Almendras] [Leche] [Pera] [Mozzarella])
  )

  ([Tarta_de_Ricotta_Sandia_y_Manzana_helenica] of Postre
     (Precio 10.33)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Sandia] [Almendras] [Avellanas] [Manzana] [Melon] [Nueces] [Ricotta])
  )

  ([Compota_de_Pera_Manzana_y_Melon_iberica] of Postre
     (Precio 4.91)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Verano])
     (usa_ingrediente [Higo] [Pera] [Melon] [Almendras] [Uva] [Manzana] [Leche])
  )

  ([Compota_de_Uva_Melocoton_y_Ricotta_levantina] of Postre
     (Precio 7.83)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Ricotta] [Uva] [Melocoton] [Almendras] [Nueces])
  )

  ([Mousse_de_Yogur_griego_Melon_y_Pera_iberica] of Postre
     (Precio 9.0)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Yogur_griego] [Uva] [Melon] [Pera])
  )

  ([Crema_Dulce_de_Pera_Uva_y_Melocoton_levantina] of Postre
     (Precio 10.76)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Otono])
     (usa_ingrediente [Granada] [Uva] [Melocoton] [Manzana] [Pera] [Pistachos] [Higo])
  )

  ([Crema_Dulce_de_Ricotta_Leche_y_Melocoton_mediterranea] of Postre
     (Precio 11.88)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Manzana] [Leche] [Almendras] [Ricotta] [Melocoton] [Melon])
  )

  ([Crema_Dulce_de_Higo_Mozzarella_y_Ricotta_levantina] of Postre
     (Precio 11.84)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Pistachos] [Almendras] [Ricotta] [Higo] [Yogur_griego] [Mozzarella])
  )

  ([Crema_Dulce_de_Yogur_griego_Uva_y_Ricotta_iberica] of Postre
     (Precio 7.11)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Almendras] [Pinones] [Ricotta] [Uva] [Yogur_griego] [Avellanas])
  )

  ([Compota_de_Manzana_Yogur_griego_helenica] of Postre
     (Precio 8.65)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Avellanas] [Almendras] [Pinones] [Manzana] [Yogur_griego])
  )

  ([Tarta_de_Ricotta_Sandia_y_Higo_mediterranea] of Postre
     (Precio 9.07)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pistachos] [Pinones] [Sandia] [Ricotta] [Higo] [Manzana])
  )

  ([Mousse_de_Uva_Melocoton_y_Sandia_mediterranea] of Postre
     (Precio 7.34)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Pistachos] [Sandia] [Pera] [Melocoton] [Leche] [Almendras] [Uva])
  )

  ([Sorbete_de_Granada_Melocoton_helenica] of Postre
     (Precio 5.3)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Primavera])
     (usa_ingrediente [Granada] [Avellanas] [Pinones] [Melocoton] [Pistachos])
  )

  ([Mousse_de_Leche_Pera_y_Melon_italica] of Postre
     (Precio 12.02)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Pera] [Leche] [Yogur_griego] [Melon])
  )

  ([Crema_Dulce_de_Mozzarella_Ricotta_y_Manzana_iberica] of Postre
     (Precio 7.76)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Mozzarella] [Nueces] [Manzana] [Ricotta] [Avellanas] [Pinones])
  )

  ([Tarta_de_Granada_Uva_y_Sandia_mediterranea] of Postre
     (Precio 8.54)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Pistachos] [Ricotta] [Sandia] [Uva] [Granada] [Pinones])
  )

  ([Crema_Dulce_de_Higo_Yogur_griego_y_Uva_italica] of Postre
     (Precio 6.37)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Otono])
     (usa_ingrediente [Higo] [Almendras] [Uva] [Yogur_griego])
  )

  ([Sorbete_de_Melocoton_Mozzarella_y_Melon_helenica] of Postre
     (Precio 5.85)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno])
     (usa_ingrediente [Avellanas] [Melon] [Pistachos] [Melocoton] [Mozzarella] [Pinones])
  )

  ;;; Platos disponibles durante todo el año

  ([Ensalada_de_Altramuces_Tomillo_y_Tomate_mediterranea] of Primero
     (Precio 13.51)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_altramuces])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Ternera] [Garbanzos] [Tomillo] [Altramuces] [Tomate])
  )

  ([Salpicon_de_Pulpo_Cebolla_y_Ricotta_balear] of Primero
     (Precio 7.53)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Ricotta] [Rucula] [Cuscus] [Cebolla] [Pulpo] [Pimiento_verde])
  )

  ([Tabule_de_Setas_Merluza_y_Limon_balear] of Primero
     (Precio 10.29)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_soja] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Tofu_de_soja] [Pimiento_verde] [Langostino] [Setas] [Merluza] [Limon] [Naranja])
  )

  ([Ensalada_de_Altramuces_Atun_andalusi] of Primero
     (Precio 15.01)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_cacahuetes] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Cacahuetes] [Altramuces] [Centeno] [Atun] [Arroz] [Pasta])
  )

  ([Crema_de_Altramuces_Queso_manchego_y_Uva_helenica] of Primero
     (Precio 15.91)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Queso_manchego] [Uva] [Merluza] [Altramuces] [Langostino] [Pistachos])
  )

  ([Ensalada_de_Lubina_Merluza_y_Queso_manchego_levantina] of Primero
     (Precio 15.27)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Merluza] [Aceitunas] [Lubina] [Remolacha] [Tomate] [Queso_manchego] [Sardinas])
  )

  ([Gazpacho_de_Naranja_Ternera_y_Remolacha_iberica] of Primero
     (Precio 12.24)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Berenjena] [Naranja] [Ternera] [Cordero] [Granada] [Remolacha] [Cebada] [Dorada])
  )

  ([Salpicon_de_Albahaca_Pollo_y_Pera_iberica] of Primero
     (Precio 15.98)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Pera] [Hinojo] [Pollo] [Pinones] [Yogur_griego] [Albahaca] [Pan_de_trigo])
  )

  ([Salpicon_de_Cordero_Leche_y_Ternera_helenica] of Primero
     (Precio 10.44)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_soja])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Pepino] [Mozzarella] [Tofu_de_soja] [Ternera] [Leche] [Cordero])
  )

  ([Crema_de_Calamar_Cerdo_y_Pollo_mediterranea] of Primero
     (Precio 13.06)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_moluscos] [Alergia_a_sesamo])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Sesamo] [Cerdo] [Champinones] [Pollo] [Sandia] [Calamar] [Albahaca] [Manzana])
  )

  ([Salpicon_de_Tomate_Mozzarella_y_Ajo_andalusi] of Primero
     (Precio 10.46)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Ajo] [Tomate] [Champinones] [Mozzarella] [Avellanas])
  )

  ([Timbal_de_Limon_Melocoton_y_Aceitunas_andalusi] of Primero
     (Precio 17.59)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Almendras] [Melocoton] [Pinones] [Limon] [Aceitunas] [Arroz] [Cebolla] [Mozzarella])
  )

  ([Tabule_de_Queso_manchego_Lechuga_romana_y_Cebolla_mediterranea] of Primero
     (Precio 19.52)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Pasta] [Queso_manchego] [Bulgur] [Cebolla] [Lechuga_romana] [Almendras] [Rucula])
  )

  ([Caprese_de_Patata_Tofu_de_soja_y_Yogur_griego_mediterranea] of Primero
     (Precio 9.76)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_soja])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Yogur_griego] [Tofu_de_soja] [Pimiento_verde] [Patata] [Arroz] [Pistachos])
  )

  ([Crema_de_Calabacin_Pepino_y_Berenjena_andalusi] of Primero
     (Precio 11.48)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Calabacin] [Pepino] [Tomate] [Avellanas] [Masa_de_pizza] [Berenjena] [Queso_manchego])
  )

  ([Timbal_de_Alubias_blancas_Pimiento_verde_y_Pera_iberica] of Primero
     (Precio 8.61)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Melon] [Pera] [Pimiento_verde] [Alubias_blancas] [Quinoa] [Yogur_griego])
  )

  ([Salpicon_de_Altramuces_Ajo_y_Yogur_griego_levantina] of Primero
     (Precio 17.06)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Melocoton] 
[Melon] [Ajo] [Bulgur] [Altramuces] [Hinojo] [Yogur_griego])
  )

  ([Ensalada_de_Pimiento_rojo_Naranja_y_Mozzarella_iberica] of Primero
     (Precio 9.14)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Avellanas] [Hinojo] [Pimiento_rojo] [Naranja] [Mozzarella])
  )

  ([Caprese_de_Huevo_Albahaca_y_Rucula_mediterranea] of Primero
     (Precio 12.27)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_huevos])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Albahaca] [Lentejas] [Rucula] [Huevo] [Cebolla])
  )

  ([Caprese_de_Mozzarella_Patata_y_Menta_levantina] of Primero
     (Precio 8.55)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Patata] [Pinones] [Bulgur] [Alubias_blancas] [Sandia] [Menta] [Mozzarella])
  )

  ([Crema_de_Hinojo_Tomillo_y_Berenjena_levantina] of Primero
     (Precio 16.32)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Maiz] [Masa_de_pizza] [Berenjena] [Tomillo] [Hinojo])
  )

  ([Crema_de_Judiones_Setas_italica] of Primero
     (Precio 17.87)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Quinoa] [Judiones] [Cuscus] [Maiz] [Setas])
  )

  ([Sopa_de_Pimiento_rojo_Tomillo_y_Setas_mediterranea] of Primero
     (Precio 13.71)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Tomillo] [Setas] [Alcachofa] [Pimiento_rojo] [Pepino])
  )

  ([Crema_de_Hinojo_Calabacin_y_Tofu_de_soja_andalusi] of Primero
     (Precio 11.55)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_sesamo] [Alergia_a_soja])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Granada] [Calabacin] [Hinojo] [Tofu_de_soja] [Sesamo])
  )

  ([Timbal_de_Remolacha_Rucula_y_Tofu_de_soja_italica] of Primero
     (Precio 17.54)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_soja])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Tofu_de_soja] [Pistachos] [Rucula] [Remolacha] [Granada])
  )

  ([Sopa_de_Berenjena_Ajo_y_Menta_italica] of Primero
     (Precio 13.91)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_apio] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Menta] [Apio] [Ajo] [Masa_de_pizza] [Berenjena])
  )

  ([Sopa_de_Melocoton_Perejil_y_Patata_iberica] of Primero
     (Precio 16.77)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Quinoa] [Judiones] [Patata] [Pistachos] [Nueces] [Perejil] [Melocoton])
  )

  ([Gazpacho_de_Limon_Uva_y_Perejil_balear] of Primero
     (Precio 8.42)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Uva] [Perejil] [Cebada] [Sandia] [Limon])
  )

  ([Caprese_de_Berenjena_Hinojo_y_Rucula_italica] of Primero
     (Precio 15.14)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Hinojo] [Berenjena] [Pistachos] [Rucula] [Melocoton] [Avellanas] [Cacahuetes])
  )

  ([Caprese_de_Patata_Tofu_de_soja_y_Setas_iberica] of Primero
     (Precio 16.68)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_sesamo] [Alergia_a_soja] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Patata] [Harina_de_trigo] [Sesamo] [Tofu_de_soja] [Setas])
  )

  ([Salpicon_de_Queso_manchego_Pepino_y_Habas_helenica] of Primero
     (Precio 14.35)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Queso_manchego] [Pepino] [Habas] [Pan_de_trigo] [Rucula] [Bulgur])
  )

  ([Tabule_de_Alubias_blancas_Habas_y_Sardinas_mediterranea] of Primero
     (Precio 15.09)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_moluscos] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Calamar] [Cebada] [Alubias_blancas] [Habas] [Naranja] [Calabacin] [Sardinas] [Manzana])
  )

  ([Gazpacho_de_Hinojo_Queso_manchego_y_Calabacin_andalusi] of Primero
     (Precio 16.55)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Quinoa] [Calabacin] [Queso_manchego] [Maiz] [Hinojo] [Pasta] [Sandia] [Mejillon])
  )

  ([Sopa_de_Tofu_de_soja_Judiones_y_Dorada_mediterranea] of Primero
     (Precio 11.72)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_moluscos] [Alergia_a_soja] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Bulgur] [Pera] [Dorada] [Tofu_de_soja] [Melon] [Sardinas] [Judiones] [Mejillon])
  )

  ([Sopa_de_Tomate_Merluza_y_Setas_levantina] of Primero
     (Precio 7.37)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_moluscos] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Bulgur] [Tomate] [Oregano] [Berenjena] [Merluza] [Mejillon] [Setas] [Ajo])
  )

  ([Caprese_de_Bacalao_Altramuces_y_Calamar_italica] of Primero
     (Precio 9.25)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Altramuces] [Alcachofa] [Bacalao] [Nueces] [Ricotta] [Calamar] [Queso_feta])
  )

  ([Gazpacho_de_Queso_manchego_Espinacas_y_Menta_helenica] of Primero
     (Precio 11.34)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Mozzarella] [Espinacas] [Quinoa] [Queso_manchego] [Menta])
  )

  ([Sopa_de_Cebolla_Champinones_y_Setas_italica] of Primero
     (Precio 9.55)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Remolacha] [Habas] [Champinones] [Cebolla] [Setas])
  )

  ([Caprese_de_Garbanzos_Tofu_de_soja_y_Queso_manchego_balear] of Primero
     (Precio 9.89)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_soja])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Granada] [Cebolla] [Garbanzos] [Sandia] [Tofu_de_soja] [Lentejas] [Queso_manchego] [Queso_feta])
  )

  ([Caprese_de_Leche_Aceitunas_y_Champinones_italica] of Primero
     (Precio 11.93)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Langostino] [Aceitunas] [Leche] [Champinones] [Manzana] [Albahaca] [Pan_de_trigo])
  )

  ([Plancha_de_Pimiento_rojo_Alubias_blancas_y_Gamba_levantina] of Segundo
     (Precio 27.53)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Menta] [Merluza] [Pasta] [Pimiento_rojo] [Alubias_blancas] [Gamba] [Berenjena] [Quinoa])
  )

  ([Braseado_de_Patata_Sardinas_y_Hinojo_mediterranea] of Segundo
     (Precio 29.55)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Espinacas] [Patata] [Sardinas] [Sandia] [Hinojo] [Queso_manchego] [Garbanzos])
  )

  ([Parrillada_de_Yogur_griego_Mejillon_y_Berenjena_italica] of Segundo
     (Precio 33.56)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Uva] [Berenjena] [Yogur_griego] [Bulgur] [Avellanas] [Mejillon])
  )

  ([Salteado_de_Pepino_Lubina_y_Limon_mediterranea] of Segundo
     (Precio 22.75)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Lubina] [Hinojo] [Pepino] [Limon] [Lentejas])
  )

  ([Estofado_de_Huevo_Tomate_y_Naranja_italica] of Segundo
     (Precio 21.89)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_huevos] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Naranja] [Masa_de_pizza] [Menta] [Bulgur] [Tomate] [Huevo] [Zanahoria] [Sardinas])
  )

  ([Plancha_de_Granada_Uva_y_Langostino_helenica] of Segundo
     (Precio 16.86)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Granada] [Uva] [Langostino] [Harina_de_trigo] [Pasta])
  )

  ([Braseado_de_Pollo_Manzana_y_Uva_iberica] of Segundo
     (Precio 19.62)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Uva] [Manzana] [Hinojo] [Perejil] [Pollo])
  )

  ([Papillote_de_Dorada_Menta_y_Champinones_andalusi] of Segundo
     (Precio 35.11)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Arroz] [Champinones] [Nueces] [Acelgas] [Almendras] [Alcachofa] [Menta] [Dorada])
  )

  ([Guiso_de_Alubias_blancas_Calamar_y_Naranja_andalusi] of Segundo
     (Precio 18.28)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_moluscos])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Lentejas] [Pinones] [Albahaca] [Calamar] [Naranja] [Alubias_blancas])
  )

  ([Braseado_de_Alcachofa_Pollo_y_Pepino_iberica] of Segundo
     (Precio 16.15)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Tomillo] [Calabacin] [Pepino] [Pollo] [Alcachofa] [Lubina] [Maiz] [Ternera])
  )

  ([Parrillada_de_Patata_Queso_manchego_y_Perejil_andalusi] of Segundo
     (Precio 16.78)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Habas] [Patata] [Altramuces] [Naranja] [Harina_de_trigo] [Perejil] [Queso_manchego])
  )

  ([Horno_de_Zanahoria_Ricotta_y_Pimiento_verde_iberica] of Segundo
     (Precio 17.4)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_a_sesamo] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Zanahoria] [Sesamo] [Bulgur] [Pimiento_verde] [Nueces] [Ricotta])
  )

  ([Horno_de_Patata_Perejil_y_Yogur_griego_iberica] of Segundo
     (Precio 28.07)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_sesamo] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Yogur_griego] [Perejil] [Centeno] [Patata] [Sesamo])
  )

  ([Guiso_de_Manzana_Yogur_griego_y_Berenjena_iberica] of Segundo
     (Precio 21.97)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Pan_de_trigo] [Manzana] [Setas] [Yogur_griego] [Berenjena])
  )

  ([Horno_de_Pepino_Espinacas_y_Setas_helenica] of Segundo
     (Precio 15.29)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_sesamo])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Sesamo] [Setas] [Espinacas] [Ricotta] [Pepino])
  )

  ([Guiso_de_Ricotta_Patata_y_Calabacin_italica] of Segundo
     (Precio 24.85)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Pimiento_verde] [Patata] [Naranja] [Cacahuetes] [Calabacin] [Nueces] [Ricotta])
  )

  ([Salteado_de_Leche_Aceitunas_y_Pepino_mediterranea] of Segundo
     (Precio 12.69)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Aceitunas] [Bulgur] [Leche] [Perejil] [Pepino])
  )

  ([Plancha_de_Manzana_Lentejas_y_Yogur_griego_iberica] of Segundo
     (Precio 21.52)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Habas] [Manzana] [Pinones] [Lentejas] [Arroz] [Masa_de_pizza] [Cacahuetes] [Yogur_griego])
  )

  ([Plancha_de_Tofu_de_soja_Ajo_y_Acelgas_balear] of Segundo
     (Precio 29.23)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_a_soja])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Aceitunas] [Tofu_de_soja] [Mozzarella] [Acelgas] [Ajo])
  )

  ([Salteado_de_Aceitunas_Ajo_y_Manzana_helenica] of Segundo
     (Precio 25.82)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Manzana] [Alubias_blancas] [Aceitunas] [Yogur_griego] [Ajo])
  )

  ([Estofado_de_Uva_Lechuga_romana_y_Judiones_italica] of Segundo
     (Precio 17.79)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Nueces] [Lechuga_romana] [Uva] [Judiones] [Pistachos])
  )

  ([Horno_de_Perejil_Albahaca_andalusi] of Segundo
     (Precio 16.32)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Perejil] [Pasta] [Albahaca] [Centeno] [Avellanas])
  )

  ([Braseado_de_Melon_mediterranea] of Segundo
     (Precio 16.81)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Avellanas] [Pasta] [Quinoa] [Pistachos] [Melon])
  )

  ([Salteado_de_Lentejas_Garbanzos_y_Tomate_iberica] of Segundo
     (Precio 24.0)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_cacahuetes])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Garbanzos] [Cacahuetes] [Pepino] [Lentejas] [Tomate])
  )

  ([Plancha_de_Pimiento_rojo_Limon_mediterranea] of Segundo
     (Precio 21.92)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_cacahuetes] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Pimiento_rojo] [Pan_de_trigo] [Avellanas] [Pinones] [Cacahuetes] [Limon])
  )

  ([Plancha_de_Berenjena_Aceitunas_y_Perejil_italica] of Segundo
     (Precio 22.36)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Aceitunas] [Perejil] [Berenjena] [Espinacas] [Pera])
  )

  ([Braseado_de_Pepino_Pimiento_verde_y_Altramuces_helenica] of Segundo
     (Precio 23.78)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_sesamo])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Pepino] [Altramuces] [Garbanzos] [Sesamo] [Pimiento_verde])
  )

  ([Estofado_de_Pimiento_rojo_Altramuces_y_Pimiento_verde_mediterranea] of Segundo
     (Precio 29.32)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_altramuces])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Pimiento_verde] [Pimiento_rojo] [Altramuces] [Aceitunas] [Acelgas])
  )

  ([Guiso_de_Higo_Champinones_y_Acelgas_andalusi] of Segundo
     (Precio 15.38)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Acelgas] [Champinones] [Uva] [Menta] [Higo])
  )

  ([Braseado_de_Oregano_Rucula_y_Sandia_helenica] of Segundo
     (Precio 24.66)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_sesamo] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Oregano] [Harina_de_trigo] [Rucula] [Sesamo] [Sandia])
  )

  ([Guiso_de_Langostino_Aceitunas_y_Melocoton_levantina] of Segundo
     (Precio 28.15)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Melocoton] [Aceitunas] [Langostino] [Almendras] [Arroz])
  )

  ([Parrillada_de_Queso_feta_Acelgas_y_Bacalao_iberica] of Segundo
     (Precio 12.16)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Dorada] [Lechuga_romana] [Bacalao] [Leche] [Queso_feta] [Acelgas])
  )

  ([Papillote_de_Altramuces_Lentejas_y_Yogur_griego_italica] of Segundo
     (Precio 21.5)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_lactosa] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Cebada] [Altramuces] [Lentejas] [Yogur_griego] [Maiz])
  )

  ([Guiso_de_Bacalao_Perejil_y_Manzana_helenica] of Segundo
     (Precio 22.41)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Setas] [Bacalao] [Perejil] [Leche] [Manzana])
  )

  ([Plancha_de_Setas_Bacalao_y_Sandia_helenica] of Segundo
     (Precio 29.13)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_soja] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Setas] [Sandia] [Bacalao] [Higo] [Naranja] [Masa_de_pizza] [Pepino] [Tofu_de_soja])
  )

  ([Estofado_de_Calabacin_Uva_y_Pollo_mediterranea] of Segundo
     (Precio 32.24)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Granada] [Pollo] [Calabacin] [Uva] [Masa_de_pizza] [Pan_de_trigo] [Harina_de_trigo])
  )

  ([Guiso_de_Sardinas_Hinojo_y_Gamba_iberica] of Segundo
     (Precio 22.11)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_altramuces] [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Pera] [Centeno] [Hinojo] [Nueces] [Perejil] [Sardinas] [Gamba] [Altramuces])
  )

  ([Papillote_de_Dorada_Gamba_y_Apio_italica] of Segundo
     (Precio 25.63)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_al_gluten] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Merluza] [Dorada] [Apio] [Centeno] [Gamba] [Pistachos])
  )

  ([Guiso_de_Judiones_Tomate_y_Oregano_helenica] of Segundo
     (Precio 19.89)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Judiones] [Cuscus] [Limon] [Oregano] [Tomate])
  )

  ([Plancha_de_Alubias_blancas_Cordero_y_Mozzarella_helenica] of Segundo
     (Precio 22.13)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_apio] [Alergia_a_lactosa] [Alergia_a_moluscos] [Alergia_al_gluten])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Masa_de_pizza] [Apio] [Calamar] [Garbanzos] [Cordero] [Mozzarella] [Alubias_blancas])
  )

  ([Mousse_de_Yogur_griego_Sandia_y_Cordero_italica] of Postre
     (Precio 9.26)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Sandia] [Avellanas] [Yogur_griego] [Almendras] [Pistachos] [Cordero])
  )

  ([Panna_Cotta_de_Melon_Merluza_y_Yogur_griego_helenica] of Postre
     (Precio 6.55)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Yogur_griego] [Manzana] [Melon] [Granada] [Higo] [Melocoton] [Sandia] [Merluza])
  )

  ([Sorbete_de_Atun_Uva_y_Mozzarella_iberica] of Postre
     (Precio 6.33)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Melocoton] [Mozzarella] [Ricotta] [Uva] [Pinones] [Pistachos] [Atun])
  )

  ([Compota_de_Pera_Leche_y_Melocoton_mediterranea] of Postre
     (Precio 8.52)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Leche] [Manzana] [Almendras] [Pera] [Melon] [Melocoton] [Gamba])
  )

  ([Panna_Cotta_de_Yogur_griego_Leche_y_Mozzarella_helenica] of Postre
     (Precio 6.67)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Yogur_griego] [Mozzarella] [Ricotta] [Leche] [Higo] [Melon] [Pera] [Langostino])
  )

  ([Macedonia_de_Pera_Gamba_y_Ricotta_helenica] of Postre
     (Precio 7.69)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Ricotta] [Pera] [Granada] [Melocoton] [Gamba])
  )

  ([Helado_de_Yogur_griego_Granada_y_Sandia_mediterranea] of Postre
     (Precio 6.41)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Leche] [Yogur_griego] [Sandia] [Granada] [Almendras] [Avellanas] [Cordero])
  )

  ([Compota_de_Pera_Melocoton_y_Leche_italica] of Postre
     (Precio 5.92)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Manzana] [Yogur_griego] [Leche] [Ricotta] [Melocoton] [Pera] [Uva] [Atun])
  )

  ([Helado_de_Pera_Langostino_y_Leche_mediterranea] of Postre
     (Precio 8.8)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_crustaceos] [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Yogur_griego] [Leche] [Pistachos] [Pera] [Langostino])
  )

  ([Macedonia_de_Ricotta_Sardinas_y_Yogur_griego_levantina] of Postre
     (Precio 6.55)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Omnivora])
     (contiene_alergenos [Alergia_a_lactosa] [Alergia_al_pescado])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Yogur_griego] [Sandia] [Ricotta] [Pera] [Uva] [Sardinas])
  )

  ([Panna_Cotta_de_Sandia_Melocoton_y_Ricotta_levantina] of Postre
     (Precio 5.33)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Sandia] [Ricotta] [Yogur_griego] [Manzana] [Melocoton])
  )

  ([Sorbete_de_Manzana_Uva_y_Granada_italica] of Postre
     (Precio 6.99)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Sandia] [Manzana] [Pistachos] [Mozzarella] [Uva] [Granada])
  )

  ([Sorbete_de_Melocoton_Higo_y_Ricotta_italica] of Postre
     (Precio 5.88)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Nueces] [Ricotta] [Melocoton] [Higo])
  )

  ([Sorbete_de_Mozzarella_Pera_y_Granada_levantina] of Postre
     (Precio 8.14)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Melocoton] [Pera] [Granada] [Sandia] [Uva] [Mozzarella])
  )

  ([Helado_de_Pera_Sandia_y_Uva_iberica] of Postre
     (Precio 6.92)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Uva] [Pera] [Almendras] [Granada] [Sandia] [Yogur_griego])
  )

  ([Mousse_de_Yogur_griego_Mozzarella_y_Pera_levantina] of Postre
     (Precio 7.13)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Avellanas] [Pinones] [Yogur_griego] [Melocoton] [Pera] [Mozzarella] [Higo])
  )

  ([Helado_de_Sandia_Melon_y_Yogur_griego_helenica] of Postre
     (Precio 5.78)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Uva] [Nueces] [Sandia] [Yogur_griego] [Melon] [Pinones] [Avellanas])
  )

  ([Helado_de_Queso_manchego_Pera_y_Granada_italica] of Postre
     (Precio 11.17)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Granada] [Almendras] [Pistachos] [Pera] [Pinones] [Queso_manchego])
  )

  ([Panna_Cotta_de_Manzana_Granada_y_Sandia_levantina] of Postre
     (Precio 4.15)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Sandia] [Granada] [Manzana] [Ricotta])
  )

  ([Compota_de_Manzana_Mozzarella_y_Melocoton_levantina] of Postre
     (Precio 7.08)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegetariano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Pera] [Pinones] [Manzana] [Avellanas] [Melocoton] [Mozzarella])
  )

  ([Crema_Dulce_de_Granada_helenica] of Postre
     (Precio 5.9)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Almendras] [Pinones] [Avellanas] [Granada])
  )

  ([Compota_de_Granada_Manzana_y_Uva_iberica] of Postre
     (Precio 5.08)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Pinones] [Granada] [Nueces] [Manzana] [Uva])
  )

  ([Compota_de_Higo_Uva_balear] of Postre
     (Precio 10.7)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Uva] [Higo] [Nueces] [Quinoa])
  )

  ([Tarta_de_Granada_Melon_mediterranea] of Postre
     (Precio 5.5)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Granada] [Avellanas] [Pistachos] [Melon])
  )

  ([Helado_de_Granada_Uva_levantina] of Postre
     (Precio 7.26)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Nueces] [Pinones] [Granada] [Uva])
  )

  ([Tarta_de_Granada_Melon_y_Melocoton_italica] of Postre
     (Precio 6.42)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Melocoton] [Granada] [Pistachos] [Melon])
  )

  ([Sorbete_de_Pera_Melocoton_y_Uva_balear] of Postre
     (Precio 6.56)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Uva] [Pera] [Pistachos] [Melocoton] [Pinones])
  )

  ([Mousse_de_Pera_Manzana_y_Sandia_italica] of Postre
     (Precio 10.65)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Pera] [Almendras] [Sandia] [Manzana])
  )

  ([Mousse_de_Melocoton_Manzana_y_Melon_andalusi] of Postre
     (Precio 8.72)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Vegano])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Manzana] [Melon] [Melocoton] [Avellanas] [Almendras])
  )

  ([Sorbete_de_Manzana_Higo_y_Melocoton_balear] of Postre
     (Precio 4.66)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Vegano])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Manzana] [Melocoton] [Sandia] [Higo])
  )

  ([Crema_Dulce_de_Melocoton_Yogur_griego_y_Pera_mediterranea] of Postre
     (Precio 9.97)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Melon] [Yogur_griego] [Higo] [Pistachos] [Pera] [Melocoton] [Mozzarella])
  )

  ([Tarta_de_Yogur_griego_Melocoton_y_Higo_levantina] of Postre
     (Precio 7.79)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Leche] [Higo] [Ricotta] [Yogur_griego] [Melocoton] [Granada] [Pistachos])
  )

  ([Mousse_de_Melon_Pera_balear] of Postre
     (Precio 5.81)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Avellanas] [Melon] [Pinones] [Pera])
  )

  ([Tarta_de_Leche_Sandia_y_Mozzarella_levantina] of Postre
     (Precio 9.78)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Pinones] [Nueces] [Sandia] [Leche] [Mozzarella] [Melocoton])
  )

  ([Macedonia_de_Leche_Melon_y_Uva_balear] of Postre
     (Precio 5.44)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Uva] [Ricotta] [Nueces] [Leche] [Almendras] [Melon] [Pistachos])
  )

  ([Mousse_de_Ricotta_Melon_y_Pera_andalusi] of Postre
     (Precio 12.52)
     (tiene_estilo [Sibarita])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Manzana] [Pera] [Melon] [Ricotta] [Higo] [Nueces] [Uva])
  )

  ([Compota_de_Pera_Sandia_italica] of Postre
     (Precio 5.96)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Caliente])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Almendras] [Sandia] [Pera] [Pinones])
  )

  ([Panna_Cotta_de_Melon_Pera_y_Ricotta_andalusi] of Postre
     (Precio 9.41)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Almendras] [Ricotta] [Avellanas] [Melon] [Pinones] [Nueces] [Pera])
  )

  ([Macedonia_de_Uva_Yogur_griego_y_Sandia_balear] of Postre
     (Precio 9.25)
     (tiene_estilo [Clasico])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Yogur_griego] [Uva] [Sandia] [Mozzarella] [Melocoton])
  )

  ([Panna_Cotta_de_Leche_Uva_y_Sandia_mediterranea] of Postre
     (Precio 9.41)
     (tiene_estilo [Moderno])
     (tiene_temperatura [Frio])
     (es_apto_para [Halal])
     (contiene_alergenos [Alergia_a_frutos_con_cascara] [Alergia_a_lactosa])
     (se_sirve_en [Invierno] [Primavera] [Verano] [Otono])
     (usa_ingrediente [Sandia] [Mozzarella] [Avellanas] [Nueces] [Uva] [Pera] [Leche])
  )


)

; --------------------------
; CAMBIAR DE MÓDULO
; --------------------------

(defrule iniciar-recap-info
   (declare (salience 1001))
   =>
   (focus RECAP_INFO)
)