---
marp: true
paginate: true
header: Grafos y Flujo
footer: Campamento Invernal de Programación Competitiva
---

<!-- _class: title -->

# Grafos y Flujo

<ul class="author">
  <li>Marcelo Lemus</li>
  <li>marcelo.lemus@progcomp.cl</li>
</ul>

---

# Importancia de flujo en ICPC

- En casi todas las regionales ICPC hay un problema de flujo
- La solución siempre suele ser armar el grafo y correr un algoritmo de flujo
- Muchos no saben/manejan flujo
- El problema de flujo no parece que sea de flujo
- Junto con geometría computacional, el equipo que tenga a alguien que se maneje especialmente bien en alguno de estos temas, puede llegar a garantizar la victoria sobre los demás equipos

---

# Redes de flujo

Una **red de flujo** consiste en:
- Un grafo dirigido G = (V, E) con pesos en las aristas
- Dos nodos especiales: s (fuente) y t (sumidero)

Nuestro objetivo es mandar la mayor cantidad de unidades de flujo de s a t.

Los pesos en las aristas representan la cantidad máxima de flujo que soportan (**capacidad**).

---

# Flujo sobre una Red

Es una asignación de un real no negativo a cada arista tal que:
- Para cada arista, decimos cuántas unidades de flujo pasan por ella
- No asignamos a una arista más de su capacidad máxima
- En cada nodo (excepto s y t) el flujo que entra tiene que ser igual al que sale

El **valor del flujo** es:
- La cantidad de flujo que sale de s
- La cantidad de flujo que entra a t

Ambos números siempre coinciden. Queremos encontrar el mayor valor posible.

---

# Ejemplo

---

# Red Residual

La **red residual** de un flujo es un grafo dirigido tal que:
- Los nodos son los mismos que en la red original
- Hay una arista de u a v con capacidad la suma de:
  - Lo que me falta para llenar la capacidad de u a v en el grafo original
  - El flujo que estoy mandando de v a u

---

# Augmenting Path (Camino de aumento)

Un **camino de aumento** es un camino de s a t en la red residual.

Dado un camino de aumento podemos conseguir un flujo mayor mandando todo lo posible por este camino.

---

# Cómo calcular el flujo máximo — Ford Fulkerson

1. Empiezo con el flujo vacío (el flujo de cada arista es 0)
2. Construyo la red residual
3. Mientras haya camino de s a t en la red residual:
   - Busco la arista con menor peso (m) del camino
   - Actualizo el flujo para mandar m unidades de flujo por ese camino
   - Actualizo la red residual
4. Devuelvo el flujo obtenido

---

# Ejemplo de flujo con Ford Fulkerson

Empezamos con 0 en todas las aristas (flujo enviado)

---

# Ejemplo de flujo con Ford Fulkerson

Encontramos un camino aumentante en la red residual

---

# Ejemplo de flujo con Ford Fulkerson

Mandamos todo lo que podemos por ese camino

---

# Ejemplo de flujo con Ford Fulkerson

Actualizamos la red residual

---

# Ejemplo de flujo con Ford Fulkerson

Volvemos a buscar un camino aumentante y mandamos flujo

---

# Ejemplo de flujo con Ford Fulkerson

Actualizamos la red residual y repetimos

---

# Ejemplo de flujo con Ford Fulkerson

Actualizamos la red residual y repetimos

---

# Ejemplo de flujo con Ford Fulkerson

No hay más caminos aumentantes, paramos

---

# Edmond Karp y Dinitz (Dinic)

Si además buscamos el camino de s a t con **BFS**:
- El algoritmo queda O(V · E²) — **Edmond Karp**

También existe el algoritmo de **Dinic**:
- Construye los niveles usando BFS y luego encuentra todas las rutas disjuntas posibles de esa capa utilizando DFS
- El algoritmo queda O(V² · E)
- Es más rápido que Edmond Karp

Siempre debemos considerar la cota O(E · |f|) para todo algoritmo de máximo flujo, donde |f| es el valor del flujo máximo.

---

# Definición de corte

Un **corte** en una red es una partición de los nodos en dos conjuntos U y V tal que s ∈ U y t ∈ V.

Dado un corte, su **valor** es la suma de las capacidades de todas las aristas que van de un nodo de U a uno de V.

---

# Teorema de Max-Flow Min-Cut

- El valor del **corte mínimo** coincide con el del **flujo máximo**
- Podemos encontrar un corte mínimo definiendo:
  - U como los nodos alcanzables desde s en la red residual del flujo máximo
  - V como el resto de los nodos

---

# Trucos de Modelación

---

# Múltiples fuentes / sumideros

Supongamos que tenemos un problema donde hay varios nodos de los que "sale" flujo y/o varios nodos a los que tiene que llegar flujo.

1. Creamos dos nodos s y t nuevos
2. Conectamos s a todos los nodos de los que "sale" flujo con capacidad ∞
3. Conectamos todos los nodos a los que llega flujo con t con capacidad ∞

---

# Restricciones sobre los nodos

¿Qué pasa si tenemos restricciones de flujo que pasa por un nodo v en lugar de por una arista?

1. Duplicamos el nodo en v_in y v_out
2. Conectamos todas las aristas que entraban a v a v_in
3. Conectamos todas las aristas que salían de v a v_out
4. Conectamos v_in a v_out con una arista de la capacidad máxima del nodo

---

# Los 4 jinetes del matching bipartito

---

# Matching máximo

Dado un grafo G = (V, E), un **matching** es un conjunto de aristas tal que no haya dos que incidan sobre el mismo vértice.

El problema de **matching máximo** pide el mayor conjunto de aristas que cumpla esto.

La versión general se puede resolver con el algoritmo de Blossom.

---

# Matching máximo bipartito

Si el grafo es bipartito se puede modelar con un flujo:

- Sean A y B los conjuntos de nodos de cada lado
- Creo un nodo s y lo conecto con capacidad 1 a cada nodo de A
- Creo un nodo t y conecto cada nodo de B a t con capacidad 1
- Por cada arista (u, v) del grafo, uno u ∈ A con v ∈ B con capacidad ∞

El flujo máximo sobre esta red nos da el matching máximo.

---

# Minimal Edge Cover

Dado un grafo, un **cubrimiento por aristas** es un conjunto de aristas tal que todo nodo sea extremo de alguna arista del conjunto.

Queremos el cubrimiento de menor tamaño.

Si el grafo es bipartito:
- Agrego al cubrimiento todas las aristas de un matching máximo
- Por cada nodo que quedó sin cubrir, agrego una arista cualquiera que incida en el nodo

Tamaño del cubrimiento mínimo: |V| − |matching máximo|

---

# Minimal Edge Cover — Ejemplo

---

# Minimal Vertex Cover

Dado un grafo, un **cubrimiento por nodos** es un conjunto de nodos tal que toda arista tenga algún extremo en el conjunto. Queremos el cubrimiento de menor tamaño.

---

# Minimal Vertex Cover — Caso bipartito

Si el grafo es bipartito, el **Teorema de König** nos dice que el tamaño del cubrimiento mínimo coincide con el del matching máximo.

---

# Maximal Independent Set

Dado un grafo, un **conjunto independiente** es un conjunto de nodos tal que no hay dos adyacentes. Queremos el conjunto independiente más grande.

---

# Maximal Independent Set — Caso bipartito

- Tomo un Vertex Cover mínimo
- Los nodos que no están en el cubrimiento forman un conjunto independiente máximo

Tamaño: |V| − |vertex cover mínimo| = |V| − |matching máximo|

---

# Complejidad de flujo en un grafo bipartito

A la hora de calcular un matching máximo con flujo:

Si uso **Edmond-Karp**:
- El flujo máximo es a lo mucho |V|
- Usando la cota O(E · |f|), el matching máximo es O(V · E)

Si uso **Dinic**:
- La complejidad es O(E · √V)

---

# Problemas con Tableros (Ajedrez)

Es muy común tener alguno de estos problemas escondido en un problema de tableros.

**Modelo:**
- Creo un grafo bipartito
- Creo un nodo en A por cada fila del tablero
- Creo un nodo en B por cada columna del tablero
- Una arista entre un nodo fila y un nodo columna representa la casilla de esa fila y columna

Muchas veces el problema se reduce a alguno de los 4 que vimos.

---

# Algoritmos extra

---

# Min-Cost Max-Flow

Una variante del problema de flujo máximo:
- A cada arista le agregamos un **costo** de mandar una unidad de flujo por esa arista
- El costo de un flujo es la suma de los costos de las aristas multiplicado por el flujo que mandamos por cada una
- Queremos encontrar, entre todos los flujos máximos, aquel que **minimice** el costo total

---

# ¿Cómo encontrar el Min-Cost Max-Flow?

Intentar correr Ford Fulkerson y al momento de buscar un camino aumentante, utilizar **Dijkstra** (o **Bellman-Ford** si los pesos son negativos).

---

# ¿Y si nos preguntan Min-Cost Max-Flow para un matching máximo?

- Podemos modelar el problema exactamente igual y usar Min-Cost Max-Flow
- (Opción más rápida) Usar el **Hungarian algorithm** que lo resuelve en O(n³)

---

# Dilworth

Dado un **grafo acíclico dirigido (DAG)**:
- Una **cadena** es una secuencia de nodos tal que de cada uno puedo llegar al siguiente
- Una **anticadena** es un conjunto de nodos tal que no hay camino entre ningún par de ellos

---

# Teorema de Dilworth

El teorema de Dilworth nos dice que los tamaños de estas cosas coinciden:
- La **anticadena de mayor tamaño**
- La **menor cantidad de cadenas** que cubren todos los nodos

---

# Grafo Auxiliar (Dilworth)

Construimos el siguiente grafo bipartito:
- Ponemos una copia de cada nodo del grafo de cada lado del bipartito
- Unimos un nodo del lado izquierdo uᵢ con uno del derecho vⱼ si hay camino de i a j en el grafo original

---

# Minimal Chain Cover

Para el cubrimiento por cadenas:
- Obtenemos un matching máximo del grafo
- Si una arista de uᵢ a vⱼ está en el matching, agregamos la cadena formada por el camino de i a j en el grafo
- Si las dos copias de un nodo están en el matching, unimos las dos cadenas con extremos en este nodo

---

# Anticadena máxima

Para la máxima anticadena:
- Obtenemos un Minimal Vertex Cover del grafo
- Tomamos los nodos que no tienen ninguna copia en el cubrimiento

---

# Felicitaciones a Ustedes

Gracias por asistir al campamento. Estamos muy orgullosos del crecimiento de la comunidad y nos alegra ver su motivación.
