---
marp: true
paginate: true
header: Fuerza bruta
footer: Campamento Invernal de Programación Competitiva
---

<!-- _class: title -->

# Fuerza bruta

---

# ¿Qué es la fuerza bruta?

Fuerza bruta es una técnica que consiste en realizar una búsqueda completa del espacio del problema, ya sea para encontrar una solución óptima o simplemente una solución factible.

---

# Búsqueda completa

Para realizar una búsqueda completa pueden existir distintos métodos, dentro de estos tipos, podemos destacar dos:

- Búsqueda sobre las **permutaciones**
- Búsqueda sobre los **subconjuntos**

Cabe aclarar que existen más métodos de búsqueda, tales como realizar un simple `for` para iterar sobre todos los números.

---

# Permutaciones

**Definición**: Es una forma de ordenar los elementos de un conjunto de forma específica.

La cantidad de permutaciones posibles con n elementos diferentes es **n!**, lo que crece rápidamente:

| n | n! |
|---|---|
| 1 | 1 |
| 2 | 2 |
| 3 | 6 |
| 4 | 24 |
| 5 | 120 |
| 6 | 720 |
| 7 | 5040 |
| 8 | 40320 |
| 9 | 362880 |
| 10 | 3628800 |
| 11 | 39916800 |

---

# Permutaciones

Podemos listar todas las permutaciones posibles de forma ordenada, dando prioridad a los índices menores. Para esto existe `next_permutation` en C++, este comando nos permite iterar sobre todas las permutaciones posibles.

---

# next_permutation

Aquí un código que imprime todas las permutaciones posibles de largo 4:

```cpp
vector<int> perm = {1, 2, 3, 4};
do {
    for (auto c : perm)
        cout << c << " ";
    cout << endl;
} while (next_permutation(perm.begin(), perm.end()));
```

---

# Subconjuntos

Un subconjunto es una serie de elementos que pertenecen a un conjunto original, pero no necesariamente conserva todos los elementos.

La cantidad de subconjuntos diferentes de un conjunto de n elementos son **2ⁿ**, lo cual crece exponencialmente:

| n | 2ⁿ |
|---|---|
| 1 | 2 |
| 2 | 4 |
| 3 | 8 |
| 4 | 16 |
| 5 | 32 |
| 6 | 64 |
| 7 | 128 |
| 8 | 256 |
| 19 | 524288 |
| 20 | 1048576 |
| 21 | 2097152 |

---

# Subconjuntos

Podemos codificar cada subconjunto como una **máscara de bits**: si el elemento está dentro del conjunto el bit es 1, en caso contrario 0.

Cada máscara representa un número natural desde 0 hasta 2ⁿ − 1, entonces para pasar por todos los subsets, simplemente podemos usar un `for` en C++.

---

# Máscaras

Este código de C++ obtiene la suma de cada subconjunto de arr:

```cpp
int n = 3;
vector<int> arr = {1, 2, 3};
vector<int> sum(1 << n);
for (int i = 0; i < (1 << n); i++) {
    int num = 0;
    for (int j = 0; j < n; j++) {
        if (i & (1 << j)) {
            num += arr[j];
        }
    }
    sum[i] = num;
}
```

---

# Backtracking

Backtracking es una técnica que consiste en construir la solución paso a paso, y si en algún punto la solución se vuelve infactible, se retorna a un estado anterior, hasta encontrar una solución factible.

---

# Problema Prefiprimos

**Enunciado**: Se busca contar la cantidad de números de tres dígitos, de forma que cumplen que cada prefijo es también un número primo.

**Solución con fuerza bruta**:

```cpp
int cnt = 0;
for (int a = 1; a <= 9; a++) {
    for (int b = 0; b <= 9; b++) {
        for (int c = 0; c <= 9; c++) {
            if (es_primo(a) && es_primo(a + 10 * b) && es_primo(a + 10 * b + 100 * c)) {
                cnt++;
            }
        }
    }
}
```

---

# Problema Prefiprimos

**Solución con backtracking**:

```cpp
int cnt = 0;
for (int a = 1; a <= 9; a++) {
    if (!es_primo(a)) continue;
    for (int b = 0; b <= 9; b++) {
        if (!es_primo(a + 10 * b)) continue;
        for (int c = 0; c <= 9; c++) {
            if (!es_primo(a + 10 * b + 100 * c)) continue;
            cnt++;
        }
    }
}
```

En lugar de probar todas las posibilidades, si en un paso se encuentra con un estado inválido regresa al dígito anterior, lo que reduce significativamente el tiempo de búsqueda.

---

# CSES - Chessboard and Queens

La tarea es colocar 8 reinas en un tablero de ajedrez de forma que las reinas no se ataquen entre sí. Además, existen cuadrados ocupados, y no se puede colocar una reina en esos espacios.

Una solución con backtracking:

```cpp
#include<bits/stdc++.h>
using namespace std;

string a[8];
bool col[8], row1[15], row2[15];
int res = 0;

void backtrack(int i) {
    if (i == 8) {
        res++;
        return;
    }
    for (int j = 0; j < 8; j++) {
        if (col[j] || row1[i - j + 8 - 1] || row2[i + j] || a[i][j] == '*')
            continue;
        col[j] = row1[i - j + 8 - 1] = row2[i + j] = true;
        backtrack(i + 1);
        col[j] = row1[i - j + 8 - 1] = row2[i + j] = false;
    }
}

int main() {
    for (int i = 0; i < 8; i++) cin >> a[i];
    backtrack(0);
    cout << res << endl;
    return 0;
}
```


<!-- _class: title -->

# Matemática para programación competitiva

---

# ¿Cómo representamos números muy grandes?

En C++, el tipo de dato `int` funciona con números de 32 bits, pero el primer bit se reserva para el signo, entonces este tipo de dato sólo puede representar enteros hasta 2³¹ − 1.

Si uno quisiera representar números más grandes, se puede utilizar el tipo de dato `long long`, que lo representa con 64 bits, osea el número representable más grande es 2⁶³ − 1.

Pero, ¿y si quisieramos representar números aún más grandes?

---

# Aritmética modular

En varios problemas de matemática se pide calcular un número en un módulo específico. Esto es debido a que estos valores crecen rápidamente. ¿Qué es un módulo?

Se dice que un número a es congruente a b módulo m, si es que a deja resto b al dividirse por m. En lenguaje matemático, a ≡ b (mod m).

En C++ podemos realizar esta operación utilizando el operador `%`:

```cpp
// (a + b) % mod
long long ans = ((a % mod) + (b % mod)) % mod;
// (a - b) % mod
long long ans = ((a % mod) - (b % mod)) % mod;
// (a * b) % mod
long long ans = ((a % mod) * (b % mod)) % mod;
```

---

# Exponenciación binaria

Podemos calcular aᵇ multiplicando a el resultado b veces, pero esto tomaría O(b) operaciones. ¿Existe una forma más rápida de calcularlo?

La respuesta es sí, se puede realizar **exponenciación binaria** en O(log b), y el algoritmo consiste en lo siguiente:

---

# Exponenciación binaria

```cpp
using ll = long long;

ll bin_pow(ll a, ll b, ll mod) {
    a %= mod;
    ll res = 1;
    while (b != 0) {
        if (b % 2 != 0)
            res = (res * a) % mod;
        a = (a * a) % mod;
        b /= 2ll;
    }
    return res;
}
```

---

# Inverso modular

Hemos visto como hacer sumas, multiplicaciones, potencias y restas. Ahora, ¿cómo realizamos división?

El **inverso modular** de a se define como a⁻¹, y se cumple que a · a⁻¹ ≡ 1 (mod m). Para calcular este valor nos vamos a aprovechar del **Pequeño Teorema de Fermat**, que dice, dado un número primo p:

aᵖ ≡ a (mod p) ⇒ aᵖ⁻² ≡ a⁻¹ (mod p)

Que se puede calcular usando **exponenciación binaria** :)

---

# Combinatoria básica

En combinatoria, los dos principios fundamentales para contar el número de formas de elegir o construir objetos son el **Principio de la Suma** y el **Principio de la Multiplicación**.

---

# Principio de la Suma

**Definición**

Si tenemos dos (o más) conjuntos disjuntos de opciones, y queremos contar todas las formas de elegir exactamente una opción de entre todos ellos, entonces el número total de formas es la suma de las cantidades de cada conjunto.

Si un experimento puede realizarse de n₁ formas o, alternativamente, de n₂ formas (pero no ambas al mismo tiempo), entonces en total hay n₁ + n₂ formas de realizar el experimento.

---

# Principio de la Suma — Ejemplos

**Ejemplo 1**: Tienes 3 camisas rojas y 5 camisas azules. ¿Cuántas camisas puedes elegir si solo puedes escoger una?

- Opciones para camisas rojas: 3
- Opciones para camisas azules: 5
- Total: 3 + 5 = 8 camisas

**Ejemplo 2**: Dispones de dos rutas para ir al trabajo:
- Ruta A: 4 variaciones posibles
- Ruta B: 3 variaciones posibles
- Total: 4 + 3 = 7 maneras distintas

---

# Principio de la Multiplicación

**Definición**

Si un proceso se descompone en una secuencia de etapas, donde la etapa 1 ofrece n₁ posibilidades y, para cada opción de la etapa 1, la etapa 2 ofrece n₂ posibilidades (y así sucesivamente), entonces el número total de resultados posibles es el producto de las cantidades de cada etapa.

Si un experimento consta de dos subexperimentos independientes, el primero con n₁ resultados y, para cada uno de esos resultados, el segundo con n₂ resultados, entonces el número total de formas es n₁ · n₂.

---

# Principio de la Multiplicación — Ejemplos

**Ejemplo 1**: Formar un código de 2 dígitos donde cada dígito puede ser del 0 al 9.
- Total: 10 · 10 = 100 códigos posibles

**Ejemplo 2**: Seleccionar un entrante y un plato principal de un menú:
- Entrantes: 4 opciones
- Platos principales: 6 opciones
- Total: 4 · 6 = 24 menús posibles

---

# Problema: construcción de caminos en grafo

**Enunciado**: Tenemos que construir un grafo dirigido con a lo más 200 nodos, de forma que la cantidad de caminos desde el nodo 1 hasta el nodo k sean exactamente K.

---

# Permutaciones

Aplicando el Principio de la Multiplicación para ordenar n objetos distintos:

1. Para la primera posición hay n opciones
2. Una vez elegida, para la segunda quedan n − 1 opciones
3. Así sucesivamente hasta la última posición, con 1 opción

Por tanto, **P(n) = n!**

---

# Binomio

Queremos elegir un subconjunto de k objetos de un total de n, sin importar el orden:

1. Primero, contamos las permutaciones de elegir un subconjunto de tamaño k: n! / (n − k)!
2. Luego, como el orden dentro del grupo de k no importa, dividimos por las k! maneras de ordenar esos k:

**C(n, k) = n! / (k! · (n − k)!)**

---

# CSES - Distributing Apples

**Enunciado**: Tenemos que contar de cuantas formas podemos repartir n manzanas entre k niños.

---

# Descomposición en Factores Primos

La **descomposición prima** (o factorización prima) de un entero n ≥ 2 consiste en expresar n como el producto de números primos, únicos salvo el orden:

n = p₁^{α₁} · p₂^{α₂} · … · p_k^{α_k}

donde cada p_i es un número primo y cada α_i es un entero positivo.

**Ejemplo**: 84 = 2² · 3 · 7

---

# Factorización por División

El método más sencillo es probar divisores crecientes hasta √n:

```cpp
vector<ll> primeFactors(ll n) {
    vector<ll> factors;
    for (ll i = 2; (i * i) <= n; i++) {
        while (n % i == 0) {
            factors.push_back(i);
            n /= i;
        }
    }
    if (n > 1) factors.push_back(n);
    return factors;
}
```

---

# Funciones de divisores

Para un entero positivo n = p₁^{α₁} · p₂^{α₂} · … · p_k^{α_k}:

**Número de divisores** (τ(n) o d(n)):

τ(n) = (α₁ + 1)(α₂ + 1)…(α_k + 1)

**Suma de divisores** (σ(n)):

σ(n) = (p₁^{α₁+1} − 1)/(p₁ − 1) · … · (p_k^{α_k+1} − 1)/(p_k − 1)

---

# Criba de Eratóstenes

Si quisieramos obtener todos los primos hasta n con el método anterior, nos tomaría tiempo O(n√n). Para esto existe la **criba de Eratóstenes**, que nos permite hacer lo mismo, pero en O(n log log n).

```cpp
struct eratosthenes_sieve {
    vector<ll> primes;
    vector<bool> isPrime;

    eratosthenes_sieve(ll n) {
        isPrime.resize(n + 1, true);
        isPrime[0] = isPrime[1] = false;
        for (ll i = 2; i <= n; i++) {
            if (isPrime[i]) {
                primes.push_back(i);
                for (ll j = i * i; j <= n; j += i)
                    isPrime[j] = false;
            }
        }
    }
};
```

---

# Gcd y lcm en C++

El **máximo común divisor** de dos enteros a y b es el número más grande que divide a ambos sin dejar resto.

```cpp
int a = 48, b = 18;
cout << "gcd(" << a << ", " << b << ") = " << __gcd(a, b) << "\n";
```

El **mínimo común múltiplo** de dos enteros a y b es el número más pequeño que es múltiplo de ambos.

```cpp
int a = 48, b = 18;
cout << "lcm(" << a << ", " << b << ") = " << lcm(a, b) << "\n";
```
