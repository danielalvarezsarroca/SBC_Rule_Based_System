"""
Genera definstances CLIPS de Pastel desde un CSV.

Uso:
  python generar_pasteles_desde_csv.py pasteles.csv pasteles.clp

CSV esperado (encabezados exactos o compatibles):
  Nombre | Pastel | (acepta cualquiera de ambos)
  Estilo_de_comida
  Temperatura
  Época_del_año
  Precio (€)
  Dieta
  Alergia
  Ingredientes_clasificados

Formato de 'Ingredientes_clasificados':
  'Harina | Cereal; Huevo | Huevos; Azúcar | Condimento'
"""

import argparse
import csv
import re
import unicodedata

# ----- Mapeos y utilidades -----

SEASONS_ALL = ["Invierno", "Primavera", "Verano", "Otono"]

TEMP_MAP = {
    "frio": "Frio",
    "frío": "Frio",
    "caliente": "Caliente",
}

STYLE_MAP = {
    "clasico": "Clasico",
    "clásico": "Clasico",
    "moderno": "Moderno",
    "sibarita": "Sibarita",
}

TYPE_MAP = {"pastel": "Pastel"}

DIET_CLASS_MAP = {
    "halal": "Halal",
    "omnivora": "Omnivora",
    "omnívora": "Omnivora",
    "omnivoro": "Omnivora",
    "omnívoro": "Omnivora",
    "vegano": "Vegano",
    "vegetariano": "Vegetariano",
}

ALLERGY_CLASS_MAP = {
    "altramuces": "Alergia_a_altramuces",
    "apio": "Alergia_a_apio",
    "cacahuetes": "Alergia_a_cacahuetes",
    "crustaceos": "Alergia_a_crustaceos",
    "crustáceos": "Alergia_a_crustaceos",
    "frutos_con_cascara": "Alergia_a_frutos_con_cascara",
    "frutos con cascara": "Alergia_a_frutos_con_cascara",
    "frutos con cáscara": "Alergia_a_frutos_con_cascara",
    "frutos secos": "Alergia_a_frutos_con_cascara",
    "frutos_secos": "Alergia_a_frutos_con_cascara",
    "huevos": "Alergia_a_huevos",
    "lactosa": "Alergia_a_lactosa",
    "moluscos": "Alergia_a_moluscos",
    "mostaza": "Alergia_a_mostaza",
    "sesamo": "Alergia_a_sesamo",
    "sésamo": "Alergia_a_sesamo",
    "soja": "Alergia_a_soja",
    "sulfitos": "Alergia_a_sulfitos",
    "gluten": "Alergia_al_gluten",
    "pescado": "Alergia_al_pescado",
}

# Categoría de ingrediente -> clase de la ontología
ING_CATEGORY_MAP = {
    "ingredientes": "Ingredientes",
    "condimento": "Ingredientes",

    "carne": "Carne",
    "cereal": "Cereal",
    "fruta": "Fruta",
    "frutos secos": "Frutos_secos",
    "frutos_secos": "Frutos_secos",
    "lacteos": "Lacteos",
    "lácteos": "Lacteos",
    "legumbre": "Legumbre",
    "marisco": "Marisco",
    "pescado": "Pescado",
    "verdura": "Verdura",
    "huevo": "Huevos",
    "huevos": "Huevos",
}

def normalize_symbol(s: str) -> str:
    """Normaliza a símbolo de instancia CLIPS seguro (ASCII, guiones bajos, empieza por letra/_)."""
    s = (s or "").strip()
    s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode("ascii")
    s = re.sub(r"[^\w]+", "_", s)
    s = re.sub(r"_+", "_", s).strip("_")
    if not s:
        s = "Anon"
    if not re.match(r"^[A-Za-z_]", s):
        s = "X_" + s
    return s

def parse_ingredient_field(field: str):
    """
    Parsea 'Ingredientes_clasificados':
      'Harina | Cereal; Huevo | Huevos; Azúcar | Condimento'
    Devuelve lista de tuplas: (instancia, clase_mapeada, etiqueta_original)
    """
    if not field:
        return []
    parts = [p for p in re.split(r"[;,\n]+", field) if p is not None]
    results = []
    for p in parts:
        p = p.strip()
        if not p:
            continue
        if "|" in p:
            left, _, right = p.partition("|")
            name = left.strip()
            cat_raw = (right or "").strip()
        else:
            name, cat_raw = p, ""

        if not name:
            continue

        # Normaliza la categoría
        cat_norm = cat_raw.lower()
        cat_norm = unicodedata.normalize("NFKD", cat_norm).encode("ascii", "ignore").decode("ascii")
        cat_norm = cat_norm.replace("_", " ")
        cat_norm = re.sub(r"\s+", " ", cat_norm).strip()

        if cat_norm:
            mapped_cat = ING_CATEGORY_MAP.get(cat_norm)
            if not mapped_cat:
                mapped_cat = ING_CATEGORY_MAP["ingredientes"]
                print(f"[WARN] Categoría de ingrediente no reconocida: '{cat_raw}' -> usando 'Ingredientes'.")
        else:
            mapped_cat = ING_CATEGORY_MAP["ingredientes"]

        inst_name = normalize_symbol(name)
        results.append((inst_name, mapped_cat, name))
    return results

def season_list_from_field(field: str):
    if not field:
        return []
    txt = field.strip().lower()
    if txt in {"anual", "todo el ano", "todo el año", "todas"}:
        return SEASONS_ALL[:]
    tokens = [t.strip() for t in re.split(r"[;,]+", field) if t.strip()]
    mapped = []
    for t in tokens:
        t_norm = unicodedata.normalize("NFKD", t).encode("ascii", "ignore").decode("ascii").lower()
        t_norm = t_norm.strip().capitalize()
        if t_norm in SEASONS_ALL:
            mapped.append(t_norm)
    return mapped

# ----- Conversor principal -----

def main():
    parser = argparse.ArgumentParser(description="Genera definstances CLIPS (Pastel) desde un CSV.")
    parser.add_argument("input_csv", help="Ruta al CSV de entrada")
    parser.add_argument("output_clp", help="Ruta .clp de salida")
    args = parser.parse_args()

    # Estructuras acumuladas
    cakes = []
    all_ingredients = {}      # inst_name -> (class, label)
    ref_styles = set()
    ref_temps = set()
    ref_seasons = set()
    ref_diets = set()
    ref_allergies = set()

    with open(args.input_csv, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)

        # Acepta 'Nombre' o 'Plato' o 'Pastel' como columna de nombre
        name_col = None
        for cand in ("Nombre", "Pastel", "Plato"):
            if cand in reader.fieldnames:
                name_col = cand
                break
        if not name_col:
            raise ValueError("No encuentro columna de nombre: usa 'Nombre' o 'Pastel' (también sirve 'Plato').")

        required = [
            "Estilo_de_comida", "Temperatura", "Época_del_año",
            "Precio (€)", "Dieta", "Alergia", "Ingredientes_clasificados"
        ]
        for col in required:
            if col not in reader.fieldnames:
                raise ValueError(f"Falta la columna requerida: {col}")

        for row in reader:
            nombre = (row[name_col] or "").strip()
            if not nombre:
                continue

            # Estilo
            estilo = STYLE_MAP.get((row["Estilo_de_comida"] or "").strip().lower())
            if not estilo:
                raise ValueError(f"Estilo_de_comida desconocido para '{nombre}': {row['Estilo_de_comida']} (Clasico/Moderno/Sibarita)")

            # Temperatura
            temp = TEMP_MAP.get((row["Temperatura"] or "").strip().lower())
            if not temp:
                raise ValueError(f"Temperatura desconocida para '{nombre}': {row['Temperatura']} (Caliente/Frio)")

            # Precio
            precio_str = (row["Precio (€)"] or "").strip().replace(",", ".")
            try:
                precio = float(precio_str)
            except Exception as e:
                raise ValueError(f"Precio inválido para '{nombre}': {row['Precio (€)']}") from e

            # Estación/es
            seasons = season_list_from_field(row["Época_del_año"])
            if not seasons:
                seasons = SEASONS_ALL[:]

            # Ingredientes
            ing_list = parse_ingredient_field(row["Ingredientes_clasificados"])
            for inst_name, ing_class, original in ing_list:
                all_ingredients.setdefault(inst_name, (ing_class, original))

            diet_raw = (row["Dieta"] or "").strip()
            diets_this = []
            if diet_raw:
                for d in re.split(r"[;,/]+", diet_raw):
                    d = d.strip()
                    if not d:
                        continue
                    d_norm = unicodedata.normalize("NFKD", d).encode("ascii", "ignore").decode("ascii").lower()
                    dc = DIET_CLASS_MAP.get(d_norm)
                    if dc:
                        diets_this.append(dc)
                        ref_diets.add(dc)

            # Alergia/s
            alergia_raw = (row["Alergia"] or "").strip()
            allergies_this = []
            if alergia_raw:
                for a in re.split(r"[;,/]+", alergia_raw):
                    a = a.strip()
                    if not a:
                        continue
                    a_norm = unicodedata.normalize("NFKD", a).encode("ascii", "ignore").decode("ascii").lower()
                    a_norm = a_norm.replace("-", " ")
                    a_norm = re.sub(r"\s+", " ", a_norm)
                    ac = ALLERGY_CLASS_MAP.get(a_norm)
                    if ac:
                        allergies_this.append(ac)
                        ref_allergies.add(ac)

            # Acumula referencias globales
            ref_styles.add(estilo)
            ref_temps.add(temp)
            ref_seasons.update(seasons)

            # Guarda pastel
            cake_inst = normalize_symbol(nombre)
            cakes.append({
                "inst": cake_inst,
                "precio": precio,
                "estilo": estilo,
                "temp": temp,
                "seasons": seasons,
                "ingredients": [x[0] for x in ing_list],
                "diets": diets_this,
                "allergies": allergies_this,
            })

    # ----- Emisión CLIPS -----

    lines = []
    lines.append(";;; Archivo generado automáticamente desde CSV (Pasteles)\n")
    lines.append("(definstances pasteles_generados\n")

    # Estaciones
    for s in sorted(ref_seasons, key=lambda x: SEASONS_ALL.index(x)):
        lines.append(f"  ([{s}] of {s})\n")

    # Temperaturas
    for t in sorted(ref_temps):
        lines.append(f"  ([{t}] of {t})\n")

    # Estilos
    for e in sorted(ref_styles):
        lines.append(f"  ([{e}] of {e})\n")

    # Dietas (instancias sueltas)
    if ref_diets:
        lines.append("\n  ;;; Dietas (instancias)\n")
    for d in sorted(ref_diets):
        lines.append(f"  ([{d}] of {d})\n")

    # Alergias (instancias sueltas)
    if ref_allergies:
        lines.append("\n  ;;; Alergias (instancias)\n")
    for a in sorted(ref_allergies):
        lines.append(f"  ([{a}] of {a})\n")

    # Ingredientes
    if all_ingredients:
        lines.append("\n  ;;; Ingredientes (instancias)\n")
    for inst_name, (ing_class, _label) in sorted(all_ingredients.items()):
        lines.append(f"  ([{inst_name}] of {ing_class})\n")

    # Pasteles
    if cakes:
        lines.append("\n  ;;; Pasteles\n")
    for c in cakes:
        ing_str = " ".join(f"[{i}]" for i in c["ingredients"])
        seas_str = " ".join(f"[{s}]" for s in c["seasons"])
        diets_str = " ".join(f"[{d}]" for d in c["diets"])
        alerg_str = " ".join(f"[{a}]" for a in c["allergies"])

        lines.append(f"  ([{c['inst']}] of Pastel\n")
        lines.append(f"     (Precio {c['precio']})\n")
        lines.append(f"     (tiene_estilo [{c['estilo']}])\n")
        lines.append(f"     (tiene_temperatura [{c['temp']}])\n")
        if seas_str:
            lines.append(f"     (se_sirve_en {seas_str})\n")
        if ing_str:
            lines.append(f"     (usa_ingrediente {ing_str})\n")
        if diets_str:
            lines.append(f"     (es_apto_para {diets_str})\n")
        if alerg_str:
            lines.append(f"     (contiene_alergenos {alerg_str})\n")
        lines.append("  )\n\n")

    lines.append(")\n")

    with open(args.output_clp, "w", encoding="utf-8") as out:
        out.write("".join(lines))

if __name__ == "__main__":
    main()
