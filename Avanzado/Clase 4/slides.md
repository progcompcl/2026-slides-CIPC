---
marp: true
paginate: true
header: Programación Dinámica Avanzada
footer: Campamento Invernal de Programación Competitiva
---

<!-- _class: title -->

# Programación Dinámica Avanzada

---

# Resumen de la clase

- Repaso DP - Estados
- Bitmask DP
- DP + Segment Tree / estructuras
- Rerooting
- Recurrencias lineales con matrices
- Recurrencias lineales con matrices de polinomios

---

# Subproblemas y todo eso

Cuando hablamos de programación dinámica, normalmente pensamos en recurrencias o agarrar problemas chicos y mezclarlos para resolver un problema grande.

Una manera de formalizar esto, es pensando en términos de **estados**.

---

# Hablemos de estados

Pensemos en el siguiente problema:

Tenemos una grilla de n × m con algunas casillas bloqueadas y queremos llegar desde (0, 0) hasta (n−1, m−1).

---

# Hablemos de estados

Un **estado** es una forma de representar únicamente una configuración del problema mediante un conjunto de variables.

Por ejemplo, en este problema, podemos caracterizar cada configuración con la posición en las filas y las columnas; es decir, una tupla (i, j).

---

# Otro ejemplo: CSES 1635

Hay un sistema monetario con n monedas con algún valor.

Dada una cantidad objetivo x, calcula el número de formas distintas de sumar x utilizando alguna cantidad de las monedas.

---

# Transiciones

Aquí los estados son un poco más implícitos.

Podemos caracterizar cada configuración del problema según la suma que tengamos hasta el momento.

Ahora, ¿cómo nos movemos entre los estados?

---

# Transiciones

Supongamos que tenemos las monedas {2, 3, 5}.

Cuando tenemos suma s = 0, por ejemplo, podemos escoger alguna de estas monedas y movernos al estado con s = 2, s = 3 o s = 5. A esto se le llama **transición**: movernos de un estado al otro.

**¡El espacio de estados de un problema se puede modelar como un grafo!**

---

# Espacio de estados

---

# Espacio de estados

Viéndolo de esta forma, el problema de las monedas se reduce a contar caminos entre el estado inicial 0 y x (¡sabemos hacer eso! :D)

---

# Ciclos en el grafo de estados

Muchas veces el grafo de estados es acíclico; es decir, no podemos visitar un estado dos veces. Sin embargo, hay casos en los que esto sí ocurre y no podemos hacer DP de forma estándar.

**Ejemplo (PdA 2025 - Problem A):**

Dado un grafo dirigido con caracteres en las aristas, contar el número de pares (u, v) tal que existe un paseo palíndromo entre u y v.

---

# Ejemplo (PdA 2025 - Problem A)

Los palíndromos tienen una estructura recursiva:

caracter + palíndromo + mismo caracter

Podemos pensar en que cada tupla (u, v) es un estado: Tenemos un palíndromo formado entre u y v.

Si encontramos una arista entrante hacia u y otra saliente desde v con el mismo caracter hacia vértices u', v' respectivamente, podemos movernos al estado (u', v').

**Idea preliminar:** BFS desde los casos base (u, u) y (u, v) si hay arista directa.

---

# Ejemplo (PdA 2025 - Problem A)

---

# Ejemplo (PdA 2025 - Problem A)

**Problema:** ¡Pueden haber ciclos!

---

# Caso feo

---

# Caso feo

---

# Caso feo

---

# Caso feo

---

# Caso feo

---

# Ejemplo (PdA 2025 - Problem A)

Como tal no podemos hacer DP, pero podemos implementar esta misma idea revisando qué estados son alcanzables desde los casos base.

Las restricciones del problema no nos permiten construir el grafo explícito, hay que hacer un BFS implícito pero la idea no cambia.

---

# Ideas

- No hay una forma fácil de deducir los estados; en general hay muchas representaciones de un mismo problema
- Si tenemos alguna idea para los estados de un problema pero no entra en tiempo, tratar de simplificar información redundante
- Para modelar los estados de un problema, construir una solución de a poquito y observar

---

# Bitmask DP

Cuando las constraints son pequeñas, podemos usar cantidades exponenciales de estados.

**Ejemplo:** TSP (Problema del vendedor viajero)

---

# Traveling Salesman Problem

**Enunciado:**

Se te da un grafo de n nodos y m aristas con n ≤ 20 y m ≤ n·(n−1)/2. Calcula el costo de un **camino hamiltoniano de costo mínimo**.

---

# TSP

Pensemos en generar una solución de a poco: Tomemos un nodo y empecemos a agregar vecinos al camino.

---

# TSP

---

# TSP

---

# TSP

---

# TSP

---

# TSP

---

# TSP

Necesitamos saber qué nodos hemos visitado y cuál es nuestro nodo actual.

Hay **n · 2ⁿ** estados posibles. Pero n es chico, así que se puede hacer.

Las transiciones quedan así:

dp[mask][v] = min(dp[mask ^ (1<<v)][u] + dist[u][v])

y la respuesta es min(dp[(1<<n)−1][v])

---

# Ideas principales

Esto es casi como hacer backtracking pero memoizando los estados.

Otro problema que aplica esta idea:
https://codeforces.com/problemset/problem/1431/G

---

# Backtracking + memo

Alicia y Bob están jugando un juego. Parten con un set de n enteros y juegan por turnos. En cada turno:

- Alicia escoge un número del conjunto distinto del máximo
- Bob escoge un número más grande que x, llamémoslo y
- x e y son borrados del set y se suma x al puntaje

Si Alicia quiere maximizar su puntaje y Bob lo quiere minimizar, calcule el puntaje resultante si juegan óptimamente.

---

# DP + data structures

**Enunciado:**

Vi le regaló a Arias un arreglo con n elementos para su cumpleaños y Arias quiere encontrar la subsecuencia creciente más larga pero no quiere implementar porque perdió todo en el casino así que te pidió ayuda.

---

# Solución subóptima

dp[i] = max(dp[j] + 1) para todo j < i con a[j] < a[i]

Corre en O(n²). ¿Podemos hacerlo mejor?

---

# Solución optimizada

Recorramos el arreglo de izquierda a derecha.

Si solo consideramos los elementos colocados hasta el momento, la restricción a[j] < a[i] es trivial.

Solo debemos revisar el máximo sobre todos los a[j] donde a[j] < a[i]. ¿Cómo podemos hacer esto eficientemente?

---

# Solución optimizada

Guardaremos en un arreglo best[x] lo siguiente:

Si existe una subsecuencia creciente de tamaño k que termina en un valor x, actualizaremos best[x] = max(best[x], k).

Calcular dp[i] se convierte en encontrar el máximo en el rango [0, a[i]−1].

Necesitamos actualizar el arreglo y responder estas queries rápidamente.

**Respuesta:** Segment Tree

Complejidad final: O(n log n)

---

# Optimización con sumas de prefijos

**Enunciado:**

Tienes n bloques y quieres colocarlos en niveles tal que cada nivel esté encima del otro.

¿De cuántas formas se puede hacer esto? (imprimir módulo M)

---

# ¿Es realmente O(n³)?

Usamos dp(i, j):

dp(i, j) cuenta el número de formas de colocar i bloques donde el piso de abajo tiene j bloques.

dp(i, j) = Σₖ₌₁^{min(j, i−j)} dp(i−j, k)

Formas de colocar el piso de largo k encima del piso de largo j = formas de colocar el resto de bloques cuando el piso tiene largo k.

---

# ¿Es realmente O(n³)?

Las sumatorias se pueden calcular al mismo tiempo que la DP. En total queda O(n²).

---

# Rerooting

Hay DPs en árboles que dependen de la raíz.

En algunos problemas debemos calcular algo de este estilo para **todas** las raíces.

¿Cómo lo hacemos sin que nos quede cuadrático?

---

# Rerooting - Idea superficial

Mover la raíz a un nodo adyacente es muy barato.

Movemos la raíz en orden DFS y queda O(n). Solo hay que recalcular dos valores.

---

# Problema: Tree Painting

Jugamos un juego en un árbol de n vértices. En el primer turno, escogemos un vértice y lo pintamos de negro. En los turnos siguientes, escogemos un vértice adyacente a algún vértice negro y lo pintamos, sumando a nuestro puntaje el tamaño del componente conexo de vértices blancos al que pertenecía.

¿Cuál es el puntaje máximo que se puede obtener?

Link: https://codeforces.com/contest/1187/problem/E

---

# Recurrencias lineales

Una **recurrencia lineal** es una recurrencia donde el k-ésimo término es una combinación lineal de términos anteriores.

**Ejemplos:**

- Fibonacci: F(n) = F(n−1) + F(n−2)

Esto significa que podemos escribirlas utilizando **matrices**!

---

# Ejemplo: Fibonacci

F(n) = F(n−1) + F(n−2)

---

# Recurrencias lineales

| F(n) | = | 1 | 1 | · | F(n−1) |
|---|---|---|---|---|---|
| F(n−1) |   | 1 | 0 |   | F(n−2) |

---

# Fibonacci revisited

Queremos calcular F(n), el n-ésimo número de Fibonacci.

- Recurrencia sin memoizar: O(2ⁿ)
- DP normal: O(n)
- **Exponenciación binaria:** O(log n)

---

# Fibonacci revisited

Si tenemos el vector con los valores [F(n−1), F(n−2)], al multiplicarlo por la matriz M de recién shifteamos los valores en uno:

M · [F(n−1), F(n−2)] = [F(n), F(n−1)]

Intuitivamente, multiplicar por M² los shiftea en 2 y así sucesivamente. Se tiene que Mⁿ · [F(1), F(0)] = [F(n+1), F(n)]

---

# Fibonacci revisited

Calcular la k-ésima potencia de una matriz de m × m tiene complejidad O(m³ log k):

- Multiplicar matrices tiene complejidad O(m³)
- En total se hacen O(log k) multiplicaciones

En conclusión, como la matriz es de 2×2, hacemos aproximadamente O(8 log n) operaciones.

---

# Problema con la misma idea

Estás peleando contra un boss con h de vida y tienes n hechizos distintos representados por una tupla (d, c), que significa que el hechizo quita d de vida y solo se puede usar si los últimos c bits de la vida restante son cero.

¿De cuántas formas se puede hacer que h llegue a cero? (módulo M)

Restricciones: h ≤ 10¹⁸, n ≤ 100

Link: https://codeforces.com/gym/105327/problem/D

---

# Recurrencias lineales con polinomios

¿Se puede usar esta misma idea cuando las recurrencias son bidimensionales?

Link: https://codeforces.com/gym/103960/problem/K
