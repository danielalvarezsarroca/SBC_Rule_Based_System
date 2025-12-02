"""
Genera definstances CLIPS desde un CSV de platos.

Uso:
  python generador_clips_desde_csv.py input.csv output.clp

CSV esperado (encabezados exactos):
  Plato,Estilo_de_comida,Tipo,Dieta,Precio (€),Época_del_año,Alergia,Ingredientes_clasificados,Temperatura
"""

import argparse
import csv
import re
import unicodedata

SEASONS_ALL = ["Invierno", "Primavera", "Verano", "Otono"]
TEMP_MAP = {"caliente": "Caliente", "frio": "Frio", "frío": "Frio"}
STYLE_MAP = {"clasico": "Clasico", "clásico": "Clasico", "moderno": "Moderno", "sibarita": "Sibarita"}
TYPE_MAP = {"primero": "Primero", "segundo": "Segundo", "postre": "Postre"}

# Map categoría de ingrediente -> clase de la ontología
ING_CATEGORY_MAP = {
    "ingredientes": "Ingredientes",
    "carne": "Carne",
    "cereal": "Cereal",
    "fruta": "Fruta",
    "frutos_secos": "Frutos_secos",
    "frutos secos": "Frutos_secos",
    "lacteos": "Lacteos",
    "lácteos": "Lacteos",
    "legumbre": "Legumbre",
    "marisco": "Marisco",
    "pescado": "Pescado",
    "verdura": "Verdura",
    "condimento": "Ingredientes",
    "huevo": "Huevos",   
    "huevos": "Huevos",
}

# Alergias y dietas
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
    "lacteos": "Alergia_a_lactosa",
    "lácteos": "Alergia_a_lactosa",
    "moluscos": "Alergia_a_moluscos",
    "mostaza": "Alergia_a_mostaza",
    "sesamo": "Alergia_a_sesamo",
    "sésamo": "Alergia_a_sesamo",
    "soja": "Alergia_a_soja",
    "sulfitos": "Alergia_a_sulfitos",
    "gluten": "Alergia_al_gluten",
    "pescado": "Alergia_al_pescado",
}

DIET_CLASS_MAP = {
    "halal": "Halal",
    "omnivora": "Omnivora",
    "omnívora": "Omnivora",
    "omnivoro": "Omnivora",
    "omnívoro": "Omnivora",
    "vegano": "Vegano",
    "vegetariano": "Vegetariano",
}

def normalize_symbol(s: str) -> str:
    """Normaliza a nombre seguro de instancia CLIPS: ASCII, guiones bajos, alfanumérico."""
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
    Parsea 'Ingredientes_clasificados' con formato:
      'Sal | Condimento; Naranja | Fruta; Merluza | Pescado'
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

        # Normaliza la categoría para mapear de forma robusta
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

def main():
    parser = argparse.ArgumentParser(description="Genera definstances CLIPS desde un CSV de platos.")
    parser.add_argument("input_csv", help="Ruta al CSV de entrada")
    parser.add_argument("output_clp", help="Ruta .clp de salida")
    args = parser.parse_args()

    dishes = []
    all_ingredients = {}  # nombre_inst -> (clase, etiqueta)
    referenced_styles = set()
    referenced_temps = set()
    referenced_seasons = set()
    referenced_diets = set()
    referenced_allergies = set()

    with open(args.input_csv, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        required = ["Plato","Estilo_de_comida","Tipo","Dieta","Precio (€)","Época_del_año","Alergia","Ingredientes_clasificados","Temperatura"]
        for col in required:
            if col not in reader.fieldnames:
                raise ValueError(f"Falta la columna requerida: {col}")

        for row in reader:
            nombre = (row["Plato"] or "").strip()
            tipo = TYPE_MAP.get((row["Tipo"] or "").strip().lower())
            if not tipo:
                raise ValueError(f"Tipo desconocido para '{nombre}': {row['Tipo']} (Primero/Segundo/Postre)")

            estilo = STYLE_MAP.get((row["Estilo_de_comida"] or "").strip().lower())
            if not estilo:
                raise ValueError(f"Estilo_de_comida desconocido para '{nombre}': {row['Estilo_de_comida']} (Clasico/Moderno/Sibarita)")

            temp = TEMP_MAP.get((row["Temperatura"] or "").strip().lower())
            if not temp:
                raise ValueError(f"Temperatura desconocida para '{nombre}': {row['Temperatura']} (Caliente/Frio)")

            precio_str = (row["Precio (€)"] or "").strip().replace(",", ".")
            try:
                precio = float(precio_str)
            except Exception as e:
                raise ValueError(f"Precio inválido para '{nombre}': {row['Precio (€)']}") from e

            seasons = season_list_from_field(row["Época_del_año"])
            if not seasons:
                seasons = SEASONS_ALL[:]

            ing_list = parse_ingredient_field(row["Ingredientes_clasificados"])
            for inst_name, ing_class, original in ing_list:
                all_ingredients.setdefault(inst_name, (ing_class, original))

            referenced_styles.add(estilo)
            referenced_temps.add(temp)
            referenced_seasons.update(seasons)

            # Dieta por plato
            diet = (row["Dieta"] or "").strip()
            dc_for_row = None
            if diet:
                dc_for_row = DIET_CLASS_MAP.get(
                    unicodedata.normalize("NFKD", diet).encode("ascii", "ignore").decode("ascii").lower()
                )
                if dc_for_row:
                    referenced_diets.add(dc_for_row)

            # Alergias por plato
            row_allergies = []
            alergia = (row["Alergia"] or "").strip()
            if alergia:
                for a in re.split(r"[;,/]+", alergia):
                    a = a.strip()
                    if not a or a.lower() == "ninguno":
                        continue
                    a_norm = unicodedata.normalize("NFKD", a).encode("ascii", "ignore").decode("ascii").lower()
                    a_norm = a_norm.replace("-", " ")
                    a_norm = re.sub(r"\s+", " ", a_norm)
                    cls = ALLERGY_CLASS_MAP.get(a_norm)
                    if cls:
                        referenced_allergies.add(cls)
                        row_allergies.append(cls)

            dish_inst = normalize_symbol(nombre)
            dishes.append({
                "inst": dish_inst,
                "tipo": tipo,
                "precio": precio,
                "estilo": estilo,
                "temp": temp,
                "seasons": seasons,
                "ingredients": [x[0] for x in ing_list],
                "diet": dc_for_row,                        
                "allergies": sorted(set(row_allergies)),   
            })

    lines = []
    lines.append(";;; Archivo generado automáticamente desde CSV\n")
    lines.append("(definstances generado\n")

    # Temporadas
    for s in sorted(referenced_seasons, key=lambda x: SEASONS_ALL.index(x)):
        lines.append(f"  ([{s}] of {s})\n")

    # Temperaturas
    for t in sorted(referenced_temps):
        lines.append(f"  ([{t}] of {t})\n")

    # Estilos
    for e in sorted(referenced_styles):
        lines.append(f"  ([{e}] of {e})\n")

    # Dietas referenciadas
    for dcls in sorted(referenced_diets):
        lines.append(f"  ([{dcls}] of {dcls})\n")

    # Alergias referenciadas
    for acls in sorted(referenced_allergies):
        lines.append(f"  ([{acls}] of {acls})\n")

    # Ingredientes
    if all_ingredients:
        lines.append("\n  ;;; Ingredientes\n")
    for inst_name, (ing_class, _label) in sorted(all_ingredients.items()):
        lines.append(f"  ([{inst_name}] of {ing_class})\n")

    # Platos
    if dishes:
        lines.append("\n  ;;; Platos\n")
    for d in dishes:
        ing_str = " ".join(f"[{i}]" for i in d['ingredients'])
        seas_str = " ".join(f"[{s}]" for s in d['seasons'])
        lines.append(f"  ([{d['inst']}] of {d['tipo']}\n")
        lines.append(f"     (Precio {d['precio']})\n")
        lines.append(f"     (tiene_estilo [{d['estilo']}])\n")
        lines.append(f"     (tiene_temperatura [{d['temp']}])\n")

        if d.get("diet"):
            lines.append(f"     (es_apto_para [{d['diet']}])\n")

        if d.get("allergies"):
            algos = " ".join(f"[{a}]" for a in d["allergies"])
            lines.append(f"     (contiene_alergenos {algos})\n")

        if seas_str:
            lines.append(f"     (se_sirve_en {seas_str})\n")
        if ing_str:
            lines.append(f"     (usa_ingrediente {ing_str})\n")
        lines.append("  )\n\n")

    lines.append(")\n")

    with open(args.output_clp, "w", encoding="utf-8") as out:
        out.write("".join(lines))

if __name__ == "__main__":
    main()
