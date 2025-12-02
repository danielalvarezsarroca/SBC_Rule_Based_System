"""
Convierte un CSV de bebidas a definstances CLIPS.

Uso:
  python convertidor_bebidas.py input.csv output.clp [--emit-restrictions]

CSV esperado (encabezados exactos):
  Nombre,Tipo,Precio (€),Alergia,Ingredientes_clasificados,Recomendado_para

- Tipo: Con_alcohol | Sin_alcohol
- Alergia: lista separada por comas (e.g., "Lácteos, Gluten, Sulfitos" o "Ninguno")
- Ingredientes_clasificados: "NombreIng | Categoria; OtroIng | Categoria; ..."
- Recomendado_para: Omnívora | Vegetariano | Vegano | Todos
"""

import argparse
import csv
import re
import unicodedata

# ---------- Utilidades de normalización ----------

def normalize_symbol(s: str) -> str:
    """Convierte a identificador de instancia CLIPS: ASCII, alfanumérico y _."""
    s = (s or "").strip()
    s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode("ascii")
    s = re.sub(r"[^\w]+", "_", s)
    s = re.sub(r"_+", "_", s).strip("_")
    if not s:
        s = "Anon"
    if not re.match(r"^[A-Za-z_]", s):
        s = "X_" + s
    return s

def norm_txt(s: str) -> str:
    s = (s or "").strip().lower()
    s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode("ascii")
    s = re.sub(r"\s+", " ", s).strip()
    return s

# ---------- Mapas de categorías / clases ----------

TYPE_MAP = {
    "con_alcohol": "Con_alcohol",
    "con alcohol": "Con_alcohol",
    "sin_alcohol": "Sin_alcohol",
    "sin alcohol": "Sin_alcohol",
}

# Categorías de ingredientes → clases de tu ontología
ING_CATEGORY_MAP = {
    "ingredientes": "Ingredientes",
    "condimento": "Ingredientes",
    "condimentos": "Ingredientes",

    "fruta": "Fruta",
    "verdura": "Verdura",

    "cereal": "Cereal",
    "cereales": "Cereal",

    "lacteos": "Lacteos",
    "lacteo": "Lacteos",

    "frutos_secos": "Frutos_secos",
    "frutos secos": "Frutos_secos",

    "pescado": "Pescado",
    "marisco": "Marisco",
    "carne": "Carne",

    # por si aparecen en los datos
    "te": "Ingredientes",
    "cafe": "Ingredientes",
    "hierbas": "Ingredientes",
    "tonica": "Ingredientes",
    "refresco": "Ingredientes",
    "vino": "Ingredientes",
}

# Alergias de texto → clases de tu ontología
ALLERGY_CLASS_MAP = {
    "altramuces": "Alergia_a_altramuces",
    "apio": "Alergia_a_apio",
    "cacahuetes": "Alergia_a_cacahuetes",
    "crustaceos": "Alergia_a_crustaceos",
    "crustaceo": "Alergia_a_crustaceos",
    "frutos_con_cascara": "Alergia_a_frutos_con_cascara",
    "frutos con cascara": "Alergia_a_frutos_con_cascara",
    "frutos_secos": "Alergia_a_frutos_con_cascara",
    "frutos secos": "Alergia_a_frutos_con_cascara",
    "huevos": "Alergia_a_huevos",
    "lacteos": "Alergia_a_lactosa",
    "lacteas": "Alergia_a_lactosa",
    "lactosa": "Alergia_a_lactosa",
    "moluscos": "Alergia_a_moluscos",
    "mostaza": "Alergia_a_mostaza",
    "sesamo": "Alergia_a_sesamo",
    "soja": "Alergia_a_soja",
    "sulfitos": "Alergia_a_sulfitos",
    "gluten": "Alergia_al_gluten",
    "pescado": "Alergia_al_pescado",
    "ninguno": None,  # se omite en salida
}

# Recomendación de dieta → clases Dieta
DIET_CLASS_MAP = {
    "omnivora": "Omnivora",
    "omnivoro": "Omnivora",
    "omnívora": "Omnivora",
    "omnívoro": "Omnivora",
    "vegetariano": "Vegetariano",
    "vegano": "Vegano",
    "todos": "Todos",  # caso especial (expandimos a varias)
}

# ---------- Parseo del campo de ingredientes ----------

def parse_ingredient_field(field: str):
    """
    'NombreIng | Categoria; OtroIng | Categoria'
    -> lista de tuplas (instancia_normalizada, clase_de_ontologia, etiqueta_original)
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

        cat_norm = norm_txt(cat_raw)
        # mapear categoría
        if cat_norm:
            mapped_cat = ING_CATEGORY_MAP.get(cat_norm)
            if not mapped_cat:
                mapped_cat = "Ingredientes"
                print(f"[WARN] Categoría de ingrediente no reconocida: '{cat_raw}' -> usando 'Ingredientes'.")
        else:
            mapped_cat = "Ingredientes"

        inst_name = normalize_symbol(name)
        results.append((inst_name, mapped_cat, name))
    return results

# ---------- Conversión principal ----------

def main():
    parser = argparse.ArgumentParser(description="Convierte bebidas CSV a definstances CLIPS.")
    parser.add_argument("input_csv", help="Ruta al CSV de entrada")
    parser.add_argument("output_clp", help="Ruta .clp de salida")
    parser.add_argument("--emit-restrictions", action="store_true",
                        help="Emitir instancias sueltas de Dieta/Alergia detectadas (no vinculadas)")
    args = parser.parse_args()

    beverages = []
    all_ingredients = {}  # inst_name -> (clase, etiqueta)
    referenced_diets = set()
    referenced_allergies = set()

    with open(args.input_csv, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        required = ["Nombre", "Tipo", "Precio (€)", "Alergia", "Ingredientes_clasificados", "Recomendado_para"]
        for col in required:
            if col not in reader.fieldnames:
                raise ValueError(f"Falta la columna requerida: {col}")

        for row in reader:
            nombre = (row["Nombre"] or "").strip()
            if not nombre:
                continue

            # Tipo -> clase concreta (Con_alcohol / Sin_alcohol)
            tipo_norm = norm_txt(row["Tipo"])
            tipo_cls = TYPE_MAP.get(tipo_norm)
            if not tipo_cls:
                raise ValueError(f"Tipo desconocido para '{nombre}': {row['Tipo']} (Con_alcohol/Sin_alcohol)")

            # Precio
            precio_str = (row["Precio (€)"] or "").strip().replace(",", ".")
            try:
                precio = float(precio_str)
            except Exception as e:
                raise ValueError(f"Precio inválido para '{nombre}': {row['Precio (€)']}") from e

            # Ingredientes
            ing_list = parse_ingredient_field(row["Ingredientes_clasificados"])
            for inst_name, ing_class, label in ing_list:
                all_ingredients.setdefault(inst_name, (ing_class, label))

            # Alergias (lista)
            alergia_raw = (row["Alergia"] or "").strip()
            alergias_classes = []
            if alergia_raw:
                if norm_txt(alergia_raw) != "ninguno":
                    for a in re.split(r"[;,/]+", alergia_raw):
                        a = a.strip()
                        if not a:
                            continue
                        a_norm = norm_txt(a)
                        cls = ALLERGY_CLASS_MAP.get(a_norm)
                        if cls:
                            alergias_classes.append(cls)
                            referenced_allergies.add(cls)
                        else:
                            print(f"[WARN] Alergia no reconocida '{a}' para '{nombre}' - se ignora en 'contiene_alergenos'.")

            # Recomendado_para → Dietas
            rec_norm = norm_txt(row["Recomendado_para"])
            diet_list = []
            if rec_norm == "todos":
                diet_list = ["Omnivora", "Vegetariano", "Vegano"]
            else:
                dc = DIET_CLASS_MAP.get(rec_norm)
                if not dc:
                    raise ValueError(f"Recomendado_para desconocido para '{nombre}': {row['Recomendado_para']} (Omnívora/Vegetariano/Vegano/Todos)")
                if dc != "Todos":
                    diet_list = [dc]
            referenced_diets.update(diet_list)

            beverages.append({
                "inst": normalize_symbol(nombre),
                "tipo_cls": tipo_cls,
                "precio": precio,
                "ingredients": [x[0] for x in ing_list],
                "allergies": alergias_classes,
                "diets": diet_list,
            })

    # ---------- Emisión CLP ----------
    lines = []
    lines.append(";;; Archivo generado automáticamente desde CSV de bebidas\n")
    lines.append("(definstances bebidas_generadas\n")

    # Ingredientes como instancias
    if all_ingredients:
        lines.append("  \n  ;;; Ingredientes referenciados por bebidas\n")
    for inst_name, (ing_class, _label) in sorted(all_ingredients.items()):
        lines.append(f"  ([{inst_name}] of {ing_class})\n")

    # Bebidas
    if beverages:
        lines.append("\n  ;;; Bebidas\n")
    for b in beverages:
        ing_str = " ".join(f"[{i}]" for i in b["ingredients"])
        diet_str = " ".join(f"[{d}]" for d in b["diets"])
        alerg_str = " ".join(f"[{a}]" for a in b["allergies"])

        lines.append(f"  ([{b['inst']}] of {b['tipo_cls']}\n")
        lines.append(f"     (Precio {b['precio']})\n")
        if ing_str:
            lines.append(f"     (usa_ingrediente {ing_str})\n")
        if diet_str:
            lines.append(f"     (es_apta_para {diet_str})\n")
        if alerg_str:
            lines.append(f"     (contiene_alergenos {alerg_str})\n")
        lines.append("  )\n\n")

    # Instancias sueltas de restricciones (opcional)
    if args.emit_restrictions and (referenced_diets or referenced_allergies):
        lines.append("  ;;; Restricciones (instancias no vinculadas a Bebida)\n")
        for dc in sorted(set(referenced_diets)):
            lines.append(f"  ([Dieta_{dc}] of {dc})\n")
        for ac in sorted(set(referenced_allergies)):
            lines.append(f"  ([Al_{ac}] of {ac})\n")

    lines.append(")\n")

    with open(args.output_clp, "w", encoding="utf-8") as out:
        out.write("".join(lines))

if __name__ == "__main__":
    main()
