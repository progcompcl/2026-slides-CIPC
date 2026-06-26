---
marp: true
paginate: true
header: FFT y Convoluciones
footer: Campamento Invernal de Programación Competitiva
---

<!-- _class: title -->

# Convoluciones y FFT

---

# Prerrequisitos

- Aritmética modular
- Combinatoria elemental

---

# Resumen de la clase

**Teoría:**
- FFT
- NTT (FFT en 𝔽ₚ)

**Aplicaciones:**
- Interpretación del producto de polinomios
- String matching con wildcards
- Probabilidades

---

# Enfoque de la clase

Los problemas de FFT / convoluciones en sí son inusuales.

Lo que es más usual son los **problemas de polinomios**: problemas que se pueden resolver modelándolos con polinomios (extraer el k-ésimo coeficiente, retornar la suma de sus coeficientes, etc).

Muy frecuentemente aparecen multiplicaciones de polinomios. Usando FFT podemos calcular el producto de dos polinomios en O(n log n) y resolver problemas que a simple vista parecen imposibles.

---

# Problema de motivación

Dados 2 arreglos a con |a| = n y b con |b| = m, imprime el número de formas de sumar k con un elemento de a y otro de b para k entre 0 y n + m. Dos formas se consideran distintas si los índices son distintos.

**Ejemplo:**
a = [1, 2, 3], b = [1, 2]
Respuesta: [0, 1, 1, 1, 1, 0]

---

# Solución Naive

Iterar sobre todos los pares y sumar 1 a ans[aᵢ + bⱼ].

Complejidad: O(n · m)

---

# Herramienta nueva: Multiplicación de polinomios!

**Problema:** Se te entregan los coeficientes de dos polinomios A, B, ambos de grado n. Imprime los coeficientes de C = A · B.

Recordar que C[k] = Σ A[i] · B[k − i]

Restricciones: n ≤ 10⁵

---

# Representación de polinomios en computador

Los polinomios se guardan como una secuencia de coeficientes.

Por ejemplo, el polinomio P(x) = 3 + 2x + 5x² se representa mediante el arreglo [3, 2, 5].

P[i] guarda el coeficiente de xⁱ en el polinomio P.

---

# Abuso de notación

C[k] = Σ A[i] · B[k − i]

Si trato a P como un arreglo, me estaré refiriendo a su lista de coeficientes.

---

# ¿De dónde sale esa ecuación rara?

La fórmula C[k] = Σ A[i] · B[k − i] se llama **convolución**.

---

# Solución mala (que mejoraremos)

Iteramos sobre i y j, sumamos A[i] · B[j] a C[i + j]. Complejidad: O(n²).

La FFT nos permite resolver esto en O(n log n).

---

# Forma punto-valor

La lista de coeficientes no es la única forma de representar un polinomio.

Recordemos que un polinomio P(x) de grado n está definido únicamente por n+1 puntos (xᵢ, P(xᵢ)). Si en vez de listas de coeficientes se nos hubiera entregado esto, podríamos multiplicar punto a punto en O(n).

---

# Ejemplo point-value form

Como lista de coeficientes: P(x) = x² + 1

Forma punto-valor (en −1, 0, 1): {(−1, 2), (0, 1), (1, 2)}

---

# Idea de algoritmo

1. Convertir ambos polinomios a forma punto-valor (evaluación)
2. Multiplicar punto a punto
3. Convertir de vuelta a coeficientes (interpolación)

Mandar un polinomio de un lado al otro cuesta O(n²) de forma naive. La FFT hace esto mismo pero en O(n log n).

---

# Problema de juguete

Sea P(x) un polinomio de grado n. ¿Cómo calculamos P(1) y P(−1) eficientemente?

P(1) = suma de coeficientes pares + suma de coeficientes impares
P(−1) = suma de coeficientes pares − suma de coeficientes impares

Esto es como decir que, en vez de evaluar un polinomio en 1 y −1, evaluamos dos polinomios (exp. pares e impares) de grado n/2 en la mitad de puntos (¡de 1 y −1 a solo 1)!

---

# ¿Por qué pasa esto?

Escribamos P(x) como la suma de sus coeficientes pares e impares:

P(x) = Pₚ(x²) + x · Pᵢ(x²)

**Ejemplo:** P(x) = 3 + 2x + 5x² → Pₚ(y) = 3 + 5y, Pᵢ(y) = 2

P(1) = Pₚ(1) + Pᵢ(1) = 8 + 2 = 10
P(−1) = Pₚ(1) − Pᵢ(1) = 8 − 2 = 6

---

# Esta cuestión grita divide and conquer...

¿Podemos evaluar un polinomio en n puntos utilizando n/2? ¿Qué puntos usamos?

---

# Raíces de la unidad

**Definiciones:**

Una raíz n-ésima de la unidad es un número complejo ω tal que ωⁿ = 1.

Una raíz n-ésima de la unidad ω es **primitiva** si genera el resto de raíces n-ésimas; es decir, elevar ω a todos los k entre 0 y n−1 da todas las raíces n-ésimas.

Equivalentemente, ω es primitiva ssi ωᵏ ≠ 1 para todo k entre 1 y n−1.

---

# DFT - Discrete Fourier Transform

Definimos la DFT del vector de coeficientes de un polinomio P como:

DFT(P)[k] = P(ωₙᵏ), para k = 0, ..., n−1

que será la transformación que ocuparemos para ir desde el espacio de coeficientes hasta la forma punto-valor.

---

# El algoritmo hasta ahora

---

# Mergear las llamadas recursivas — Lema útil

Usaremos este resultado:

P(ωₙᵏ) = Pₚ(ω_{n/2}ᵏ) + ωₙᵏ · Pᵢ(ω_{n/2}ᵏ)

---

# Mergear las llamadas recursivas — Lema útil

---

# Mergear las llamadas recursivas — Lema útil

---

# Mergear las llamadas recursivas — Ahora sí

Sabemos que P(x) = Pₚ(x²) + x · Pᵢ(x²).

¿Cómo podemos escribir P(ωₙᵏ) en términos de Pₚ(ω_{n/2}ᵏ) y Pᵢ(ω_{n/2}ᵏ)?

P(ωₙᵏ) = Pₚ(ωₙ²ᵏ) + ωₙᵏ · Pᵢ(ωₙ²ᵏ)
        = Pₚ(ω_{n/2}ᵏ) + ωₙᵏ · Pᵢ(ω_{n/2}ᵏ)

---

# Análisis de complejidad

La complejidad del merge es O(n) y por teorema maestro, la complejidad del algoritmo es O(n log n) (igual que merge sort).

---

# ¿Cómo me devuelvo? (FFT Inversa)

La DFT es una transformación lineal. Cada evaluación P(ωₙᵏ) es una combinación lineal de coeficientes y potencias de raíces primitivas.

Por lo tanto, podemos escribir DFT(P) = F · P donde F es una matriz.

---

# La matriz en cuestión

F_{j,k} = ωₙʲᵏ

---

# Matrices de Vandermonde

Esta matriz pertenece a una familia conocida como **Matrices de Vandermonde**, que guardan progresiones geométricas en cada fila.

La inversa de F está dada por:

F⁻¹_{j,k} = (1/n) · ωₙ^{-jk}

¡Esto es lo mismo que F pero dividido por n y utilizando los inversos de las raíces!

---

# Factor

Esto significa que para calcular la FFT inversa podemos hacer lo mismo pero utilizando ω⁻¹ en vez de ω en cada paso, recordando dividir por n al final.

---

# Algunos problemas

- Al usar raíces de la unidad, estamos obligados a usar floats, lo que puede causar errores de precisión
- Esta implementación es recursiva, pero se puede mejorar implementándola iterativamente (leer cp-algorithms)

---

# NTT — ¿chao floats?

En algunos problemas de conteo, nos piden imprimir la respuesta módulo algún primo P.

Esto es muy útil ya que podemos calcular la convolución evitando completamente el uso de floats.

---

# ¿Qué necesitamos realmente para hacer FFT?

Recordemos la fórmula que usamos antes:

P(ωₙᵏ) = Pₚ(ω_{n/2}ᵏ) + ωₙᵏ · Pᵢ(ω_{n/2}ᵏ)

**Ingredientes:**
- Un ω tal que ωⁿ = 1 (Raíz n-ésima)
- Otro ω' tal que ω'ⁿᐟ² = 1 para la segunda llamada recursiva (Raíz n/2-ésima)
- y así sucesivamente...

El resto son potencias de estos elementos.

---

# ¿Qué necesitamos realmente para hacer FFT?

Cuando trabajamos en ℂ, los únicos valores que sirven son las raíces de la unidad complejas. Pero cuando trabajamos en 𝔽ₚ la cosa cambia: ¡las raíces de la unidad pueden ser enteros!

**Ejemplo:** Una raíz 4-ésima de la unidad mod 7 es 6, ya que 6⁴ = 1296 ≡ 1 (mod 7).

¡Cuidado! Las raíces primitivas podrían no existir para ciertos módulos.

---

# Una pizca de teoría de números

Las raíces primitivas n-ésimas módulo p existen solo si n divide a p−1.

Para que existan raíces 2ᵏ-ésimas para todas las potencias de 2, p−1 debe ser divisible por 2ᵏ.

Esto significa que p debe tener la forma p = c · 2ᵏ + 1

---

# El mejor número que existe

998244353 = 119 · 2²³ + 1

---

# NTT

Sea p = 998244353 y sea g = 3 una raíz primitiva.

Por Pequeño Teorema de Fermat, g^{p−1} ≡ 1 (mod p).

Y como g es raíz primitiva, g^{(p−1)/n} también es una raíz n-ésima primitiva mod p. Si usamos estos valores en lugar de las raíces complejas, obtendremos la convolución con coeficientes módulo p.

---

# Aplicaciones — Interpretación combinatorial

Volvamos al problema con el que partimos la clase.

El problema se puede resolver calculando el producto de dos polinomios: C[k] = Σ aᵢ · b_{k−i}

---

# Interpretación combinatorial del producto de polinomios

**Ejemplo — Variante de knapsack:** Se tienen n objetos con pesos wᵢ y una mochila de capacidad W, ¿cuánto es lo máximo que puedo llevar?

---

# Cross correlation

Convolución del tipo: C[k] = Σ A[i] · B[i + k]

Podemos pensarla como: C[k] = (A * reverse(B))[n − 1 + k]

La implementación es hacer la convolución normal de A al revés y B y luego extraer el coeficiente k-ésimo.

---

# String matching

Sea S una string sobre un alfabeto Σ, y sea T otra string sobre el mismo alfabeto. ¿En qué posiciones aparece T en S?

¿Y si permitimos wildcards?

---

# String matching sin wildcards

Resolvemos el problema para cada caracter c por separado.

Calculamos un score de similitud para cada offset. Si sumamos sobre todos los caracteres y obtenemos |T| en la posición i, hay un match.

Complejidad: O(|Σ| · n log n)

---

# String matching sin wildcards — Optimización

Usamos la misma idea de calcular un puntaje de similitud:

Score(k) = Σ (S[i] − T[i − k])²

Si Score(k) = 0, necesariamente todas las diferencias fueron cero.

Score(k) = Σ S[i]² + Σ T[i]² − 2 · Σ S[i] · T[i − k]

El tercer término es una **convolución**.

Complejidad: O(n log n)

---

# Ahora con wildcards

Asignamos valor 0 a las wildcards.

Queda: Score(k) = Σ (S[i] − T[i − k])² · S[i] · T[i − k]

Todos estos términos se pueden calcular con convoluciones.

---

# Problema de probabilidades

**Enunciado:** Hay un juego donde participan N jugadores que se dividen en dos equipos: rojo y azul. Si hay k jugadores en el equipo rojo, el equipo rojo tendrá una probabilidad de P(k) de ganar. Si los jugadores se asignan completamente al azar, ¿cuál es la probabilidad de que el equipo rojo gane si hay k jugadores en su equipo, para cada k entre 0 y N?

**Restricciones:** N ≤ 2·10⁵

---

# Solución — Problema de probabilidades

Para un k fijo la respuesta es:

ans[k] = (1 / C(N, k)) · Σ P(i) · C(X, i) · C(N−X, k−i)

La última ecuación es el coeficiente k-ésimo de la convolución de dos secuencias.

Complejidad: O(N log N)

---

# DP con polinomios

Link: https://codeforces.com/problemset/problem/300/D

---

# DP con polinomios

Las potencias se pueden calcular con FFT.

Shifteamos el polinomio porque queremos el coeficiente de n−4 en vez de n.
