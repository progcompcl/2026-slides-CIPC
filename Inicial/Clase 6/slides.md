---
marp: true
paginate: true
header: Grafos I
footer: Campamento Invernal de Programación Competitiva
---

<!-- _class: title -->

# Grafos I: From zero to hero

<ul class="author">
  <li>V. Benjamín Letelier Lazo</li>
  <li>vletelier@udec.cl / benjamin.letelier@udc.es</li>
</ul>

---

# ¿Grafos?

- Los grafos son un modelo matemático ampliamente utilizado
- Permiten modelar conexiones e interacciones entre distintos entes de un sistema

---

# Definición

Un **grafo** es un par ordenado G = (V, E), donde:
- V es un conjunto finito y no vacío, cuyos elementos llamamos **vértices**
- E ⊆ V × V, cuyos elementos llamamos **aristas**

---

# Fome, veamos ejemplos mejor

---

# ¿Cómo leo un grafo en ProgComp?

```cpp
// n = |V|, m = |E|
int n, m;
cin >> n >> m;
for (int e = 0; e < m; ++e) {
    // E_e es un elemento de E, tal que E_e = (u, v)
    int u, v;
    cin >> u >> v;
}
```

---

# ¿Y cómo los almaceno?

Usando **matrices de adyacencia** o **listas de adyacencia**.

---

# Matriz de adyacencia

---

# ¿Cómo creo una matriz de adyacencia?

```cpp
// n = |V|, m = |E|
int n, m;
cin >> n >> m;
vector<vector<int>> mtz_ady(n, vector<int>(n, 0));
for (int e = 0; e < m; ++e) {
    int u, v;
    cin >> u >> v;
    u--; v--;
    // Como E es un conjunto de pares no ordenados,
    // añadimos la arista en ambas direcciones
    mtz_ady[u][v] = 1;
    mtz_ady[v][u] = 1;
}
```

---

# Lista de adyacencia

---

# ¿Cómo creo una lista de adyacencia?

```cpp
// n = |V|, m = |E|
int n, m;
cin >> n >> m;
vector<vector<int>> lst_ady(n);
for (int e = 0; e < m; ++e) {
    int u, v;
    cin >> u >> v;
    u--; v--;
    // Como E es un conjunto de pares no ordenados,
    // añadimos la arista en ambas direcciones
    lst_ady[u].push_back(v);
    lst_ady[v].push_back(u);
}
```

---

# ¿Cuáles son las ventajas entre usar matriz y lista de adyacencia?

| Operación | Matriz | Lista |
|---|---|---|
| Creación de la estructura | | |
| ¿Existe la arista (u, v)? | | |
| ¿Cuántos vecinos tiene el vértice v? | | |
| ¿Cuáles son los vecinos del vértice v? | | |

---

# Representemos el siguiente grafo (ejemplo en vivo 1)

```
10 8
1 2
3 2
3 4
6 8
1 5
5 4
7 8
6 7
```

---

# Subgrafos

---

# Recorrido en un grafo

Definiremos el **recorrido** desde el vértice u hasta v en G, como una secuencia ordenada de vértices de V, tal que v₀ = u, v_k = v.

- **Recorrido** (v₀, v₁, …, v_k), con un largo k
- Si el recorrido es tal que v₀ = v_k, lo denominaremos **circuito**
- Si el recorrido no contiene vértices repetidos, lo denominaremos **camino**
- Si el circuito no contiene vértices repetidos (excepto por v₀ y v_k), lo denominaremos **ciclo**

---

# Mucho texto, veamos ejemplos (ejemplo en vivo 2)

---

# Conexidad

- Un grafo se dice **conexo** si es trivial o ∀ u, v ∈ V existe un camino en G
- Si un grafo no es conexo, se dice **disconexo**
- Una **componente conexa** de G es un subgrafo maximal en la propiedad de conexidad

---

# Retomando el ejemplo 1

---

# Eliminamos subgrafos no maximales del ejemplo 1

---

# Resumiendo el ejemplo 1

- G es disconexo, pero posee 4 componentes conexas
- Cada componente conexa es un subgrafo conexo maximal de G
- G₁ y G₂ son grafos triviales (tienen un único vértice y ninguna arista)
- G₃ es el grafo completo K₃ (cada vértice tiene 2 vecinos)
- G₄ y G₅ son grafos 2-regular (cada vértice tiene exactamente 2 vecinos)

---

# Árboles

Si un grafo G es conexo y sin ciclos, entonces diremos que G es un **árbol**.

Las siguientes proposiciones son equivalentes:
- G es árbol
- ∀ u, v ∈ V, existe un único camino entre ellos en G
- G es conexo y |E| = |V| − 1
- G no tiene ciclos y |E| = |V| − 1

---

# No entendí, ejemplo please (ejemplo en vivo 3)

---

# Bosque

Cuando un grafo G únicamente cumpla con no poseer ciclos, lo llamaremos **bosque**.

---

# Grafos dirigidos (digrafos)

Casi todo lo que vimos aplica a los digrafos, excepto las definiciones de conexidad, árboles y bosques.

---

# Definición

Un **digrafo** es un par ordenado D = (V, A), donde:
- V es un conjunto finito y no vacío, cuyos elementos llamamos **vértices**
- A ⊆ V × V es un conjunto de pares ordenados de V llamados **arcos**

---

# Ejemplo de digrafo

---

# Código de matriz y lista de adyacencia para digrafos

```cpp
int n, m;
cin >> n >> m;
vector<vector<int>> mtx_ady(n, vector<int>(n, 0));
vector<vector<int>> lst_ady(n);
for (int e = 0; e < m; ++e) {
    int u, v;
    cin >> u >> v;
    u--; v--;
    // Como A es un conjunto de pares ordenados,
    // añadimos el arco en la dirección dada
    mtx_ady[u][v] = 1;
    lst_ady[u].push_back(v);
}
```

---

# Algoritmo de recorrido Depth First Search (DFS)

La idea principal es avanzar lo máximo posible hacia adelante y cuando no podemos seguir avanzando, retrocedemos hasta el vértice más cercano a nuestra posición que tenga un camino que no haya sido recorrido. Utilizaremos 3 estados para diferenciar los vértices.

**¡Este algoritmo entrega muchísima información del grafo!**

---

# Recorrido DFS en un grafo (ejemplo en vivo 4)

---

# Implementación

```cpp
int NO_VISITADO = 0, PARCIALMENTE_VISITADO = 1, TOTALMENTE_VISITADO = 2;
vector<int> estado(n, NO_VISITADO);

void dfs(int vertice) {
    estado[vertice] = PARCIALMENTE_VISITADO;

    for (auto &vecino : lst_ady[vertice]) {
        if (estado[vecino] == NO_VISITADO)
            dfs(vecino);
        else if (estado[vecino] == PARCIALMENTE_VISITADO)
            // Vecino que vuelve a otro vértice ya explorado, pero no por completo
            ;
        else if (estado[vecino] == TOTALMENTE_VISITADO)
            // Vecino que vuelve a otro vértice ya explorado por completo
            ;
    }
    estado[vertice] = TOTALMENTE_VISITADO;
}
```

---

# Ejercicio en vivo 1

Resolviendo este ejercicio usando DFS

---

# Ejercicio en vivo 2 y 3

Resolviendo estos dos ejercicios usando DFS

---

# Algoritmo de recorrido Breadth First Search (BFS)

La idea principal es, a partir de un vértice, "inundar" a todos sus vecinos antes de pasar a la siguiente iteración.

---

# Recorrido BFS en un grafo (ejemplo en vivo 5)

---

# Implementación

```cpp
int NO_VISITADO = 0, PARCIALMENTE_VISITADO = 1, TOTALMENTE_VISITADO = 2;
vector<int> estado(n, NO_VISITADO);

void bfs(int vertice) {
    queue<int> cola;
    cola.push(vertice);

    while (!cola.empty()) {
        int enfrente = cola.front();
        cola.pop();
        estado[enfrente] = PARCIALMENTE_VISITADO;

        for (auto vecino : lst_ady[enfrente]) {
            if (estado[vecino] == NO_VISITADO)
                cola.push(vecino);
        }
        estado[enfrente] = TOTALMENTE_VISITADO;
    }
}
```

---

# Ejercicio en vivo 4

Resolviendo este ejercicio usando BFS

---

# ¿Cuál es la complejidad de usar DFS o BFS?

| | Matriz | Lista |
|---|---|---|
| DFS | | |
| BFS | | |

---

# Distancia en un grafo

Es común encontrarse ejercicios donde tenemos que encontrar la distancia mínima para ir de un lugar a otro.

Primero comenzaremos cuando la distancia de moverse sobre una arista es igual a 1. Luego, finalizaremos la clase con el caso general.

---

# Implementación

```cpp
vector<int> distancia(n, 1'000'000'000);

void bfs(int vertice) {
    distancia[vertice] = 0;
    queue<int> cola;
    cola.push(vertice);

    while (!cola.empty()) {
        int enfrente = cola.front();
        cola.pop();

        for (auto vecino : lst_ady[enfrente]) {
            if (distancia[vecino] > distancia[enfrente] + 1) {
                distancia[vecino] = distancia[enfrente] + 1;
                cola.push(vecino);
            }
        }
    }
}
```

---

# Ejercicio en vivo 5

Resolviendo este ejercicio usando BFS

---

# ¿Qué hacemos si la distancia de la arista varía?

Se debe aplicar una técnica similar a las ya vistas, pero primero hay que saber como almacenar esto en una matriz y lista de adyacencia. A estos grafos y digrafos que poseen diferentes pesos/distancias en las aristas, los llamaremos **ponderados**.

---

# Matriz de adyacencia para un grafo ponderado

```cpp
int n, m;
cin >> n >> m;
int NO_EXISTE = 1'000'000'007;
vector<vector<int>> mtz_ady(n, vector<int>(n, NO_EXISTE));
for (int e = 0; e < m; ++e) {
    int u, v, w;
    cin >> u >> v >> w;
    u--; v--;
    mtz_ady[u][v] = w;
    // Comentar si es digrafo
    mtz_ady[v][u] = w;
}
```

---

# Lista de adyacencia para un grafo ponderado

```cpp
int n, m;
cin >> n >> m;
vector<vector<pair<int, int>>> lst_ady(n);
for (int e = 0; e < m; ++e) {
    int u, v, w;
    cin >> u >> v >> w;
    u--; v--;
    lst_ady[u].push_back({v, w});
    // Comentar si es digrafo
    lst_ady[v].push_back({u, w});
}
```

---

# Algoritmo de Dijkstra

Sirve para la determinación del camino más corto desde un vértice de origen al resto de vértices de un grafo o digrafo ponderado. Se basa en una estrategia greedy.

Antes de programarlo, pensemos como podría funcionar basándonos en el caso particular cuando el peso/distancia en cada arista era 1.

---

# Algoritmo de Dijkstra

¿Cuál es el camino mínimo en este digrafo, iniciando en el vértice 1? (ejemplo en vivo 6)

---

# Algoritmo de Dijkstra

```cpp
vector<int> distancia(n, 1'000'000'000);

void dijkstra(int vertice) {
    distancia[vertice] = 0;
    priority_queue<pair<int,int>, vector<pair<int,int>>, greater<pair<int,int>>> min_heap;
    min_heap.push({distancia[vertice], vertice});

    while (!min_heap.empty()) {
        auto [distancia_enfrente, enfrente] = min_heap.top();
        min_heap.pop();

        if (distancia_enfrente > distancia[enfrente]) continue;

        for (auto [vecino, peso_vecino] : lst_ady[enfrente]) {
            if (distancia[vecino] > distancia_enfrente + peso_vecino) {
                distancia[vecino] = distancia_enfrente + peso_vecino;
                min_heap.push({distancia[vecino], vecino});
            }
        }
    }
}
```

---

# Algoritmo de Dijkstra — Complejidad

| | Matriz | Lista |
|---|---|---|
| Dijkstra | | |

---

# Algoritmo de Dijkstra — Ejercicio

Resolviendo este ejercicio usando Dijkstra (ejercicio en vivo 6)

---

# Algoritmo de Dijkstra

**¿Siempre debo usar Dijkstra?**

Dijkstra **no puede usarse** cuando existen pesos negativos.

¿Por qué?
- Se rompe la invariante con la que aseguramos la correctitud del procedimiento

¿Qué hacer en ese caso?
- Usar **Bellman-Ford** o **Floyd-Warshall** (si el grafo no posee ciclos negativos)
