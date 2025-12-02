# README — How to Run the System in CLIPS

## Requirements
- CLIPS  
- All `.clp` files must be in the same directory.

---

## Standard Execution (full interactive flow)

1) Open CLIPS in the project folder.  
2) Load the modules in this order (the order matters):

    (load "main.clp")
    (load "recap_info.clp")
    (load "abstraccion.clp")
    (load "asociacion.clp")
    (load "refinamiento.clp")

3) Initialize the fact and rule base:

    (reset)

4) Execute:

    (run)

---

## Execution with predefined constraints (testing shortcut)

If you want to skip the dialog and use the default conditions from the **ABSTRACCION** module:

1) Load everything exactly as above:

    (load "main.clp")
    (load "recap_info.clp")
    (load "abstraccion.clp")
    (load "asociacion.clp")
    (load "refinamiento.clp")

2) Initialize:

    (reset)

3) Focus the ABSTRACCION module so it inserts the default conditions and triggers the workflow:

    (focus ABSTRACCION)
    (run)
