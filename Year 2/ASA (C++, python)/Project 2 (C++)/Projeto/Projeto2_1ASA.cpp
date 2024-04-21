#pragma GCC diagnostic ignored "-Wunused-result"
#include <cstdio>
#include <vector>
#include <iostream>
#include <stack>
#include <algorithm>

#define MAX_N 20001
#define ll long long int
using namespace std;

int n, m;

struct Node {
    vector<int> adj;
    vector<int> rev_adj;
};

Node g[MAX_N];

stack<int> S;
bool visited[MAX_N];

int component[MAX_N];
vector<int> components[MAX_N];
int numComponents;
vector<vector<int>> dag;
vector<int> dp(MAX_N, -1); // DP array to store the longest path for each node

int longest_path(int node) {
    if (dp[node] != -1) {
        return dp[node];
    }

    int max_path = 0;
    for (int neighbor : dag[node]) {
        max_path = max(max_path, longest_path(neighbor) + 1);
    }

    dp[node] = max_path;
    return max_path;
}

void dfs_1_iterative(int start) {
    stack<int> s;
    s.push(start);

    while (!s.empty()) {
        int x = s.top();
        s.pop();

        if (!visited[x]) {
            visited[x] = true;
            s.push(x);  // Push the node back onto the stack
            for (int i = 0; i < (int)g[x].adj.size(); i++) {
                int neighbor = g[x].adj[i];
                if (!visited[neighbor]) {
                    s.push(neighbor);
                }
            }
        } else {
            S.push(x);
        }
    }
}

void dfs_2_iterative(int start) {
    stack<int> s;
    s.push(start);

    while (!s.empty()) {
        int x = s.top();
        s.pop();

        if (!visited[x]) {
            printf("%d ", x + 1); // Corrected index for output
            component[x] = numComponents;
            components[numComponents].push_back(x);
            visited[x] = true;
            s.push(x);  // Push the node back onto the stack
            for (int i = 0; i < (int)g[x].rev_adj.size(); i++) {
                int neighbor = g[x].rev_adj[i];
                if (!visited[neighbor]) {
                    s.push(neighbor);
                }
            }
        }
    }
}

void Kosaraju_iterative() {
    for (int i = 0; i < n; i++) {
        if (!visited[i]) {
            dfs_1_iterative(i);
        }
    }

    for (int i = 0; i < n; i++) {
        visited[i] = false;
    }

    while (!S.empty()) {
        int v = S.top();
        S.pop();
        if (!visited[v]) {
            printf("Component %d: ", numComponents);
            dfs_2_iterative(v);
            numComponents++;
            printf("\n");
        }
    }
}

void collect_data() {
    scanf("%d%d", &n, &m);

    int a, b;
    while (m--) {
        scanf("%d%d", &a, &b);
        g[a - 1].adj.push_back(b - 1);
        g[b - 1].rev_adj.push_back(a - 1);
    }
}

void build_dag() {
    dag.resize(numComponents);

    // Iterate through original graph nodes
    for (int i = 0; i < n; i++) {
        int current_component = component[i];

        // Iterate through neighbors of the current node
        for (int neighbor : g[i].adj) {
            int neighbor_component = component[neighbor];

            // Add edge in the DAG only if the components are different
            if (current_component != neighbor_component) {
                dag[current_component].push_back(neighbor_component);
            }
        }
    }
}

void print_dag() {
    printf("DAG (each line represents a node and its outgoing edges):\n");
    for (int i = 0; i < numComponents - 1; i++) {
        printf("%d:", i + 1); // Corrected index for output
        for (int neighbor : dag[i]) {
            printf(" %d", neighbor + 1); // Corrected index for output
        }
        printf("\n");
    }
}

int main() {
    collect_data();

    Kosaraju_iterative();
    build_dag();
    print_dag();

    // Find the longest path in the DAG
    int max_length = 0;
    for (int i = 0; i < numComponents - 1; i++) {
        max_length = max(max_length, longest_path(i));
    }

    printf("Longest Path Length: %d\n", max_length);

    return 0;
}
