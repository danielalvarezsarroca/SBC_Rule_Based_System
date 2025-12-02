# README — Cómo ejecutar el sistema en CLIPS

## Requisitos
- CLIPS 
- Todos los archivos `.clp` en el mismo directorio.

---

## Ejecución estándar (flujo completo interactivo)

1) Abrir CLIPS en la carpeta del proyecto.  
2) Cargar los módulos en este orden (el orden importa):

    (load "main.clp")
    (load "recap_info.clp")
    (load "abstraccion.clp")
    (load "asociacion.clp")
    (load "refinamiento.clp")

3) Inicializar la base de hechos y reglas:

    (reset)

4) Ejecutar:

    (run)

---

## Ejecución con restricciones predefinidas (atajo para pruebas)

Si quiere saltar el diálogo y usar las condiciones por defecto del módulo **ABSTRACCION**:

1) Cargar todo exactamente igual que arriba:

    (load "main.clp")
    (load "recap_info.clp")
    (load "abstraccion.clp")
    (load "asociacion.clp")
    (load "refinamiento.clp")

2) Inicializar:

    (reset)

3) Enfocar el módulo ABSTRACCION para que inserte las condiciones por defecto y dispare el flujo de trabajo:

    (focus ABSTRACCION)
    (run)


