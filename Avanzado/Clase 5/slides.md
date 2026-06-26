---
marp: true
paginate: true
header: LCA y Binary Lifting
footer: Campamento Invernal de Programación Competitiva
---

<!-- _class: title -->

# LCA y Binary Lifting

<ul class="author">
  <li>Marcelo Lemus</li>
  <li>marcelo.lemus@progcomp.cl</li>
</ul>

---

# Repaso de Grafos

---

# Repaso de Grafos

**Definición de grafo**

Un grafo G consiste en:
- V: Conjunto de vértices (nodos)
- E: Conjunto de aristas (pares de vértices)

Las aristas implican una relación entre los pares de vértices que conecta.

---

# Repaso de Grafos

**Definición de árbol**

Un árbol es un grafo que es conexo, sin ciclos y para cada par de vértices, existe solo 1 camino simple que conecta estos vértices.

---

# Repaso de Grafos — Matriz de adyacencia

La matriz de adyacencia, es una matriz de n × n en la cual n es la cantidad de nodos que posee el grafo. En la posición (i, j) posee un 1 (o true) si hay una arista desde el nodo i hacia el nodo j, y un 0 (o false) en caso contrario.

Uso de memoria: O(n²)

---

# Repaso de Grafos — Matriz de adyacencia

```cpp
int main() {
    int n, m;
    cin >> n >> m;

    int adj[n][n];
    for (int i = 0; i < m; i++) {
        int a, b;
        cin >> a >> b; // 0-index
        adj[a][b] = 1;
        adj[b][a] = 1; // si el grafo es NO dirigido
    }
}
```

---

# Repaso de Grafos — Lista de adyacencia

La lista de adyacencia, es un vector de vectores de enteros. En la i-ésima posición del vector, se encuentra un vector que indica hacia qué nodos apunta el nodo i.

Uso de memoria: O(n + m), siendo m la cantidad de aristas del grafo.

---

# Repaso de Grafos — Lista de adyacencia

```cpp
int main() {
    int n, m;
    cin >> n >> m;
    vector<vector<int>> adj;
    adj.resize(n);

    for (int i = 0; i < m; i++) {
        int a, b;
        cin >> a >> b; // indexado en 0
        adj[a].push_back(b);
        adj[b].push_back(a); // si el grafo es NO dirigido
    }
}
```

---

# Repaso de Grafos — DFS

Como indica su nombre, se realiza un recorrido en profundidad:

- Seleccionamos un nodo inicial, elegimos un vecino aún no procesado, y procedemos a procesarlo
- Aplicamos la lógica anterior al nodo seleccionado, y cuando terminamos, procesamos el siguiente en la lista

Complejidad: O(n + m)

---

# Repaso de Grafos — DFS

```cpp
vector<vector<int>> adj;
vector<bool> vis;

void dfs(int u) {
    vis[u] = true;
    for (int v : adj[u]) {
        if (!vis[v]) {
            dfs(v);
        }
    }
}

int main() {
    int n, m;
    cin >> n >> m;
    adj.resize(n);
    vis.resize(n);
    // leer el grafo
    dfs(0);
}
```

---

# Problema: Ice Cave

Estás en un juego donde tu personaje está en una cueva de hielo con múltiples niveles. Para avanzar, debes caer al nivel inferior rompiendo el hielo.

**Descripción del nivel:**
- Una cuadrícula de n filas y m columnas
- Cada celda tiene hielo intacto (.) o agrietado (X)
- Movimientos válidos: a celdas adyacentes (arriba, abajo, izquierda, derecha)
  - Si te mueves a hielo agrietado, caes al siguiente nivel
  - Si te mueves a hielo intacto, este se agrieta (pero no caes)

**Objetivo:** Determinar si es posible llegar de (x₁, y₁) a (x₂, y₂) y caer.

---

# Problema: Ice Cave

```
  1 2 3 4 5 6
1 X . . . X X
2 . . . X X .
3 . X . . X .
4 . . . . . .
```

---

# Problema: Ice Cave — Solución

```cpp
bool e(int i, int j) {
    return i >= 0 && i < n && j >= 0 && j < m;
}

int dx[4] = {-1, 0, 1, 0};
int dy[4] = {0, 1, 0, -1};

void dfs(int i, int j, int ffi, int ffj) {
    vis[i][j] = true;
    for (int k = 0; k < 4; k++) {
        int ni = i + dx[k];
        int nj = j + dy[k];
        if (e(ni, nj) && !vis[ni][nj]) {
            if (ni == ffi && nj == ffj) vis[ni][nj] = true;
            if (a[ni][nj] == 'X') continue;
            dfs(ni, nj, ffi, ffj);
        }
    }
}
```

---

# Problema: Ice Cave — Verificación

```cpp
if (x1 == x2 && y1 == y2) {
    bool can = false;
    for (int k = 0; k < 4; k++) {
        int ni = x1 + dx[k], nj = y1 + dy[k];
        if (e(ni, nj) && a[ni][nj] == '.')
            can = true;
    }
    cout << (can ? "YES\n" : "NO\n");
    return;
}

dfs(x1, y1, x2, y2);

if (vis[x2][y2]) {
    if (a[x2][y2] == 'X') {
        cout << "YES\n";
    } else {
        int cnt = 0;
        for (int k = 0; k < 4; k++) {
            int ni = x2 + dx[k], nj = y2 + dy[k];
            cnt += (e(ni, nj) && a[ni][nj] == '.');
        }
        cout << (cnt >= 2 ? "YES\n" : "NO\n");
    }
} else {
    cout << "NO\n";
}
```

---

# Breadth First Search (BFS)

La propiedad de este recorrido es que se realiza una búsqueda "por niveles":

- Seleccionamos un nodo inicial, y procesamos todos los nodos a distancia 1
- Luego, procesamos todos los vecinos (no procesados aún) de los anteriores (distancia 2)
- Repetimos hasta procesar todos los nodos

Complejidad: O(n + m)

---

# BFS — Implementación

```cpp
vector<int> dis; // inicialmente todas las posiciones en -1
vector<vector<int>> adj;

void bfs(int start) {
    queue<int> q;
    dis[start] = 0;
    q.push(start);

    while (!q.empty()) {
        int nodoActual = q.front();
        q.pop();

        for (int vecino : adj[nodoActual]) {
            if (dis[vecino] == -1) {
                dis[vecino] = dis[nodoActual] + 1;
                q.push(vecino);
            }
        }
    }
}
```

---

# Problema: Trapmigiano Reggiano

Un ratón hambriento comienza en el vértice s de un árbol con n vértices. Dada una permutación p de longitud n, en cada paso i:

- Aparece queso en el vértice pᵢ
- Si el ratón ya está en pᵢ, se queda ahí
- Si no, se mueve un paso hacia pᵢ por el camino más corto

**Objetivo:** Imprimir una permutación p tal que después de n pasos, el ratón termine en el vértice t (trampa).

---

# Problema: Trapmigiano Reggiano — Solución

```cpp
int n, dis[mxN], p[mxN];
vector<int> adj[mxN];

void init() {
    for (int i = 0; i < n; ++i) {
        dis[i] = 1e9;
        p[i] = i;
    }
}

void solve() {
    int st, en;
    cin >> n >> st >> en, --st, --en;
    init();
    for (int i = 0; i < n - 1; i++) {
        int a, b;
        cin >> a >> b, --a, --b;
        adj[a].push_back(b);
        adj[b].push_back(a);
    }
    bfs(en);
    sort(p, p + n, [&](int x, int y) {
        return dis[x] > dis[y];
    });
    for (int i = 0; i < n; ++i) cout << p[i] + 1 << " ";
}
```

---

# Dijkstra

**Problema:** Dado un grafo ponderado (pesos no negativos) y un vértice de inicio s, calcular la distancia mínima de s hacia todos los nodos.

---

# Dijkstra — Algoritmo

**Inicialmente:**
- La distancia de s a sí mismo es 0: dist[s] = 0
- La distancia de s a cualquier otro vértice v es infinito: dist[v] = ∞

**En cada paso:**
- Elegimos un vértice u (no procesado) con dist[u] mínima
- Por cada vecino v de u, actualizamos: dist[v] = min(dist[v], dist[u] + w(u,v))

---

# Dijkstra — Complejidad

- Sin optimización: O(n²)
- Con priority queue (heap): O((n + m) log n)

---

# Dijkstra — Implementación

```cpp
vector<int> dis;
vector<vector<pair<int, int>>> adj;

void dijkstra(int st) {
    for (int i = 0; i < n; ++i) dis[i] = 1e9;
    dis[st] = 0;
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq;
    pq.push({0, st});

    while (!pq.empty()) {
        auto [dx, x] = pq.top(); pq.pop();
        if (dx > dis[x]) continue;
        for (auto &[w_xy, y] : adj[x]) {
            if (dis[y] > dx + w_xy) {
                dis[y] = dx + w_xy;
                pq.push({dis[y], y});
            }
        }
    }
}
```

---

# Binary Lifting & LCA

---

# Binary Lifting

**Problema:** Dado un árbol, queremos obtener el k-ésimo ancestro de un nodo u de forma eficiente. Queremos hacer muchas consultas de este tipo.

---

# Problema

---

# Problema

---

# Problema

---

# Problema

**Solución naive:** Iterar k veces, subiendo un nodo cada vez.

```cpp
for (int i = 0; i < k; ++i)
    u = parent[u];
```

O(k) por consulta. Con muchas consultas, O(n · k). Muy lento.

---

# Problema

**Solución óptima — Binary Lifting:**

Podemos tomar la representación binaria de k, sabiendo que tiene a lo mucho log₂(n) bits y precalcular los "saltos" en potencias de 2.

k = 19 = 10011₂ = 16 + 2 + 1

Si precalculamos estos saltos en potencias de 2 por cada nodo, podemos resolver cada consulta en O(log n).

---

# Binary Lifting

---

# Binary Lifting

---

# Binary Lifting — Preprocesamiento

```cpp
const int LOG = 25, mxN = 2e5 + 5;
int parent[mxN], depth[mxN], up[LOG][mxN];

void preprocess(int u = 0, int p = 0) {
    parent[u] = up[0][u] = p;
    for (int x = 1; x < LOG; ++x) {
        up[x][u] = up[x - 1][up[x - 1][u]];
    }
    for (int v : adj[u]) {
        if (v == p) continue;
        depth[v] = depth[u] + 1;
        preprocess(v, u);
    }
}
```

---

# Binary Lifting — K-ésimo ancestro

```cpp
int k_ancestro(int u, int k) {
    for (int bit = 0; bit < LOG; ++bit) {
        if (k & (1 << bit)) {
            u = up[bit][u];
        }
    }
    return u;
}
```

---

# LCA (Lowest Common Ancestor)

**Problema:** Dado un árbol, obtener el ancestro común más bajo de dos nodos (LCA).

El LCA de dos nodos es el primer ancestro común de ambos.

**Algoritmo:**
1. Igualar ambos nodos en altura (usando binary lifting)
2. Si quedan en la misma altura, uno es LCA del otro
3. Sino, iterar desde la potencia más grande a la más pequeña:
   - Si el 2ⁱ-ancestro de ambos es el mismo → estamos arriba del LCA
   - Si no → actualizar ambos nodos al 2ⁱ-ancestro
4. Retornar el padre de cualquiera de los dos

---

# LCA

---

# LCA

---

# LCA

---

# LCA

---

# LCA

---

# LCA

---

# LCA — Implementación

```cpp
int lca(int a, int b) {
    if (depth[a] < depth[b]) swap(a, b);
    int diff = depth[a] - depth[b];
    for (int i = 0; i < LOG; ++i) {
        if (diff & (1 << i))
            a = up[i][a];
    }
    if (a == b) return a;

    for (int i = LOG - 1; i >= 0; --i) {
        if (up[i][a] != up[i][b]) {
            a = up[i][a];
            b = up[i][b];
        }
    }
    return up[0][a];
}

int distancia(int a, int b) {
    return depth[a] + depth[b] - 2 * depth[lca(a, b)];
}
```

---

# Problema: A and B and Lecture Rooms

**Descripción:**

La universidad donde estudian A y B tiene n salas conectadas por n−1 pasillos, formando un árbol. Cada día:

- A y B escriben concursos en salas distintas (u y v)
- Luego, se reúnen en una sala x tal que:
  - La distancia de x a u sea igual a la distancia de x a v

**Objetivo:** Para cada uno de los q días, calcular el número de salas x que cumplen la condición.
