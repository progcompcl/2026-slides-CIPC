---
marp: true
paginate: true
header: Grafos II
footer: Campamento Invernal de Programación Competitiva
---

<!-- _class: title -->

# Grafos II: From hero to hero

<ul class="author">
  <li>V. Benjamín Letelier Lazo</li>
  <li>benjamin.letelier@progcomp.cl</li>
</ul>

---

# Retomando conexidad

Vimos que para obtener las componentes conexas, podemos hacer DFS/BFS iniciando en cada vértice del grafo que no haya sido visitado anteriormente.

---

# Retomando conexidad

---

# Retomando conexidad

Código para identificar la cantidad de componentes conexas:

```cpp
// tengo una lista de adyacencia ya leída,
// con n nodos y m aristas.
// al inicio ningún nodo ha sido visitado.
vector<bool> visitados(n, false);
int n_comp_conexas = 0;
for (int i = 0; i < n; ++i) {
    if (visitados[i] == false) {
        dfs(i);  // bfs(i)
        n_comp_conexas++;
    }
}
cout << "Existen " << n_comp_conexas << " en el grafo.\n";
```

---

# Retomando conexidad

¿Existirá una manera más sencilla de obtener información de las componentes conexas de un grafo?

---

# Retomando conexidad

**¡SÍ, SE PUEDE!**

---

# Estructura de datos Union-Find (DSU)

Union-Find es una estructura para representar, consultar y modificar conjuntos.

---

# ¿Qué?

---

# ¿Qué?

- ¿Fruta ∈ Frutas? = Verdadero
- ¿Lechuga ∈ Frutas? = Falso
- ¿Lechuga ∈ Verduras? = Verdadero
- ¿Repollo ∈ Verduras? = Falso

| Frutas |
|---|
| | Manzana | Pera | Naranja | Banana | Uva | Kiwi | Mango |

¿|Frutas|? = 7 (luego de añadir Mango)

---

# ¿Y qué tiene que ver con componentes conexas?

---

# ¿Y qué tiene que ver con componentes conexas?

- ¿A ∈ G₁? = Verdadero
- ¿B ∈ G₂? = Verdadero
- ¿C ∈ G₁? = Falso
- ¿|G₁|? = 4

---

# ¿Qué pasa si justo llega una nueva arista?

Imaginen que de un momento a otro, se crea la arista (C, F).

Tenemos que unir los elementos de G₁ con los de G₂.

---

# ¿Qué pasa si justo llega una nueva arista?

¿|G₁|? = 11

---

# Mucho texto 🤏 → poco texto 🗣️

La estructura Union-Find es súper adaptable a lo que queramos.

Como mínimo debe soportar lo siguiente:

1. **Unión** de dos conjuntos que son diferentes (`union`)
2. **Encontrar** a qué conjunto pertenece un elemento (`find`)

---

# Mucho texto 🤏 → poco texto 🗣️ (ejercicio 1, la venganza)

Resolvamos este problema mientras aprendemos sobre el Union-Find.

---

# Complejidad

| Operación | Union-Find |
|---|---|
| Union | |
| Find | |

---

# Distancia en un grafo (retomando la clase pasada xd)

Es común encontrarse ejercicios donde tenemos que encontrar la distancia mínima para ir de un lugar a otro.

Primero comenzaremos cuando la distancia de moverse sobre una arista es igual a 1. Luego, veremos el caso general.

---

# Código para la distancia mínima sobre un grafo/digrafo con BFS

```cpp
// Usando lista de adyacencia
// ¡Cuidado con usar int, puede causar overflow!
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

---

# Camino mínimo en este digrafo, iniciando en el vértice 1

---

# Código Dijkstra sobre un grafo/digrafo ponderado

```cpp
// Usando lista de adyacencia
// ¡Cuidado con usar int, puede causar overflow!
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

# Complejidad

| | Matriz | Lista |
|---|---|---|
| Dijkstra | | |

---

# Ejercicio en vivo 2

Resolviendo este ejercicio usando Dijkstra.

---

# ¿Siempre debo usar Dijkstra?

Dijkstra **no puede usarse** cuando existen pesos negativos.

¿Por qué?
- Se rompe la invariante con la que aseguramos la correctitud del procedimiento

¿Qué hacer en ese caso?
- Usar **Bellman-Ford** o **Floyd-Warshall** (si el grafo no posee ciclos negativos)

---

# Una nueva forma de representar un grafo

Podemos representar grafos ponderados utilizando sus aristas. Es útil para poder crear el **árbol de cobertura mínimo** del grafo.

---

# Lista de aristas ordenadas para representar un grafo ponderado

```cpp
int n, m;
cin >> n >> m;
vector<pair<int, pair<int, int>>> lst_aristas(m);
for (int e = 0; e < m; ++e) {
    int u, v, w;
    cin >> u >> v >> w;
    u--; v--;
    lst_aristas[e] = {w, {u, v}};
}
// Ordenar las aristas en orden creciente, por el peso
sort(lst_aristas.begin(), lst_aristas.end());
```

---

# Árbol de cobertura mínimo (Minimum Spanning Tree)

---

# Árbol de cobertura mínimo con el algoritmo de Kruskal

1. Obtener la lista de aristas ordenadas del grafo
2. Crear una estructura Union-Find vacía
3. Crear un grafo ponderado vacío (matriz/lista de adyacencia)
4. Por cada arista en la lista de aristas:
   - Si los vértices u y v NO están conectados en el Union-Find, creamos la arista en el grafo ponderado
   - Si no, ignoramos la arista

---

# ¿Cuál es la gracia del árbol de cobertura mínimo?

Obtenemos un árbol cuya suma de pesos de aristas es el **mínimo posible**.

---

# ¿Cuál es la gracia del árbol de cobertura mínimo?

---

# ¿Cuál es la gracia del árbol de cobertura mínimo?

1. El MST del grafo es **único**, si y sólo sí todos los pesos de las aristas son distintos. En otro caso, existen múltiples MST posibles
2. Es un **árbol**, por lo tanto existe un único camino entre todo par de nodos (DFS/BFS for the win)
3. El peso de cada arista de este árbol es el mínimo entre todos los árboles de cobertura posibles

---

# ¿Cuál es la gracia del árbol de cobertura mínimo?

**NO CONFUNDIR CON EL ÁRBOL QUE GENERA EL ALGORITMO DE DIJKSTRA.**

---

# Ejercicio en vivo 3

Resolviendo este ejercicio usando el algoritmo de Kruskal.

---

# Complejidad

| Algoritmo | Complejidad |
|---|---|
| Kruskal (MST) | |

---

# Transformando problemas a grafos

Muchas veces podemos tener un problema de grafos y transformarlo en otro grafo más sencillo, como también tener un problema que no es de grafos y transformarlo a grafos.

---

# Transformando problemas a grafos

¿Este problema era un grafo? 🤔

---

# Ejercicio en vivo 4

Resolviendo este ejercicio transformando una grilla a un grafo ponderado.
