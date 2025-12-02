# README — Rule Based System & How to Run the System in CLIPS

## Project Overview

This project implements a rule-based system in CLIPS that addresses the problem described in the official assignment statement of the course *Sistemes Basats en el Coneixement* (UPC) :contentReference[oaicite:0]{index=0}.

The goal of the system is to assist the catering company **Rico Rico** in generating personalized menus for events such as weddings, baptisms, communions, and conference dinners. According to the problem description (pages 4–6 of the assignment statement), the system must:

- Collect general information about the event (type, season of the year, number of guests, etc.).
- Receive the client's constraints and preferences (price range, vegetarian options, forbidden ingredients, wine preferences, desired culinary style such as classic, modern, regional, etc.).
- Use culinary knowledge about dishes and beverages, including:
  - ingredients,
  - whether a dish is a first course, second course, or dessert,
  - seasonal availability,
  - compatibility between dishes,
  - dietary categories (meat, fish, vegetarian, cold/hot dishes, typical cuisine, etc.),
  - prices,
  - beverage–course pairing compatibility.

Based on this structured knowledge, the system must construct **three complete menu proposals** for the client, each consisting of:
- a first course,
- a second course,
- a dessert,
- beverage(s) (shared or specific for each course),

and the menus should ideally differ in price so the client can choose among a cheap, medium, and expensive option.

The solution is implemented following the knowledge-engineering methodology required in the assignment, which involves identification, conceptualization, formalization, and implementation phases (pages 2–3 of the statement). The system is divided into modular CLIPS rule files that reflect these reasoning stages:
- information recap,
- abstraction of key constraints,
- association of dishes and beverages according to compatibility,
- refinement of menu construction.

This README explains how to execute the system once all modules have been implemented.

---

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
