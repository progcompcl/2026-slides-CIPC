---
marp: true
paginate: true
header: Hashing y prefix function
footer: Campamento Invernal de Programación Competitiva
---

<!-- _class: title -->

# Hashing y prefix function

<ul class="author">
  <li>Carlos Lagos</li>
  <li>carlos.lagos@progcomp.cl / carlos.lagosc@usm.cl</li>
</ul>

---

# Problema

Dado un string S y un patrón T, tu tarea es contar la cantidad de posiciones donde el patrón aparece en el string.

**Ejemplo**:
- S = "blacarcarbla"
- T = "car"

Output: 2

---

# Solución naive

Para cada posición i en S, verificar si T coincide con S[i...i+|T|−1].

Complejidad: O(|S| · |T|)

---

# Rolling Hash (Hashing de strings)

Un **rolling hash** nos permite calcular el hash de cualquier substring en O(1) después de un preprocesamiento O(|S|).

Idea: Representar el string como un número en base B módulo M.

hash(S) = (S[0] · B^(n−1) + S[1] · B^(n−2) + ... + S[n−1]) mod M

---

# Implementación

```cpp
struct RollingHash {
    const long long B = 911382323;
    const long long M = 972663749;
    vector<long long> h, p;

    RollingHash(string &s) {
        int n = s.size();
        h.resize(n + 1, 0);
        p.resize(n + 1, 1);
        for (int i = 0; i < n; i++) {
            h[i + 1] = (h[i] * B + s[i]) % M;
            p[i + 1] = (p[i] * B) % M;
        }
    }

    long long get(int l, int r) {
        return (h[r] - h[l] * p[r - l] % M + M) % M;
    }
};
```

---

# Aplicación: String Matching con Hashing

```cpp
int count_matches(string &s, string &t) {
    RollingHash hs(s), ht(t);
    int n = s.size(), m = t.size();
    int ans = 0;
    long long target = ht.get(0, m);
    for (int i = 0; i + m <= n; i++) {
        if (hs.get(i, i + m) == target) {
            ans++;
        }
    }
    return ans;
}
```

Complejidad: O(|S| + |T|)

---

# Prefix Function (KMP)

La **prefix function** π(i) para un string S es la longitud del mayor prefijo propio de S[0...i] que también es sufijo de S[0...i].

Nos permite buscar patrones en O(|S| + |T|) sin usar hashing.

---

# Implementación de Prefix Function

```cpp
vector<int> prefix_function(string &s) {
    int n = s.size();
    vector<int> pi(n, 0);
    for (int i = 1; i < n; i++) {
        int j = pi[i - 1];
        while (j > 0 && s[i] != s[j])
            j = pi[j - 1];
        if (s[i] == s[j])
            j++;
        pi[i] = j;
    }
    return pi;
}
```

---

# KMP Search

```cpp
int count_matches_kmp(string &s, string &t) {
    string combined = t + '#' + s;
    vector<int> pi = prefix_function(combined);
    int ans = 0;
    for (int i = t.size() + 1; i < combined.size(); i++) {
        if (pi[i] == t.size())
            ans++;
    }
    return ans;
}
```
