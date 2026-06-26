---
marp: true
paginate: true
header: Búsqueda Binaria
footer: Campamento Invernal de Programación Competitiva
---

<!-- _class: title -->

# Búsqueda Binaria Avanzada

<ul class="author">
  <li>Enzo Vivallo</li>
  <li>enzovivallo@estudiante.uc.cl</li>
</ul>

---

# ¿Qué es la búsqueda binaria?

Es un algoritmo para encontrar un valor en funciones booleanas monótonas.

Funciona en O(log n), con n el tamaño del dominio de la función.

La estrategia es dividir el dominio en dos partes y descartar una de ellas.

---

# Funciones booleanas monótonas

Booleana o binaria significa que la función devuelve `true` o `false`.

Monótona significa que la función es creciente o decreciente, es decir, si x₁ ≤ x₂ entonces f(x₁) ≤ f(x₂) o f(x₁) ≥ f(x₂).

El dominio de la función en la práctica puede ser una lista de valores explícitos o un rango de valores.

Por ejemplo para f(x) = (x ≥ 2) el dominio puede ser un rango [1, 10] o también una lista de valores [−5, 0, 1, 2, 3, ...].

---

# Ejemplo

El ejemplo clásico es buscar un elemento en una lista ordenada. Si queremos buscar el elemento 5 en la lista [1, 3, 4, 5, 8, 9], la función sería f(x) = (x ≥ 5) y el dominio sería los valores ordenados de la lista.

Para la lista [1, 3, 4, 5, 8, 9] y el objetivo 5:

| x | 1 | 3 | 4 | 5 | 8 | 9 |
|---|---|---|---|---|---|---|
| f(x) | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |

---

# Ejemplo

La función raíz cuadrada entera o ⌊√n⌋ también tiene ese comportamiento. Si queremos encontrar la raíz cuadrada de un número entero n, la función sería f(x) = (x² ≥ n) y el dominio sería [0, n].

Para n = 10:

| x | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|---|---|---|---|---|---|---|---|---|---|---|
| f(x) | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

---

# ¿Cómo funciona?

1. Se define un rango inicial [l, r] que contiene el valor buscado
2. Se calcula el punto medio m = (l + r) / 2
3. Se evalúa la función f(m)
4. Si f(m) es `false`, significa que el valor buscado está en el rango [m + 1, r], por lo que se actualiza l = m + 1
5. Si f(m) es `true`, significa que el valor buscado está en el rango [l, m], por lo que se actualiza r = m
6. Se repite el proceso hasta que l = r

---

# ¿Cómo funciona?

Para el primer ejemplo, si buscamos el 5 en la lista [1, 3, 4, 5, 8, 9] con la función f(x) = (x ≥ 5):

---

# Complejidad

Para un rango de tamaño n, lo que vamos haciendo es dividirlo a la mitad en cada iteración, por lo que el número de iteraciones es O(log n).

También ocupamos una función para evaluar si la condición se cumple, entonces si la complejidad de esa función es O(f), la complejidad total del algoritmo es O(f · log n).

---

# Implementación

Siendo f una función que retorna un booleano para buscar el primer valor donde la condición es verdadera, un ejemplo de código sería:

```cpp
int binary_search(int l, int r) {
    while (l < r) {
        int m = (l + r) / 2;
        if (f(m)) {
            r = m;
        } else {
            l = m + 1;
        }
    }
    return l;
}
```
