#pragma GCC diagnostic ignored "-Wunused-result"
#include <iostream>
#include <vector>
#include <unordered_set>
#include <algorithm>
#include <unordered_map>
#include <queue>
#include <stack>
#include <limits>
using namespace std;

class GFG {
public:
    // dfs Function to reach destination
    bool dfs(int curr, int des, vector<vector<int>>& adj, vector<int>& vis)
    {
        // If curr node is destination return true
        if (curr == des) {
            return true;
        }
        vis[curr] = 1;
        for (auto x : adj[curr]) {
            if (!vis[x]) {
                if (dfs(x, des, adj, vis)) {
                    return true;
                }
            }
        }
        return false;
    }

    // To tell whether there is a path from source to destination

	/* bool isPath(int src, int des, vector<vector<int>>& adj)
    {
        vector<int> vis(adj.size() + 1, 0);
        return dfs(src, des, adj, vis);
    }
	*/

	bool isPath(int src, int des, vector<vector<int>>& adj)
{
    vector<int> vis(adj.size() + 1, 0);
    stack<int> s;
    s.push(src);

    while (!s.empty()) {
        int curr = s.top();
        s.pop();

        // If curr node is destination return true
        if (curr == des) {
            return true;
        }

        vis[curr] = 1;

        for (auto x : adj[curr]) {
            if (!vis[x]) {
                s.push(x);
            }
        }
    }

    return false;
}


    // Function to return all the strongly connected components of a graph.
    vector<vector<int>> findSCC(int n, vector<vector<int>>& a)
    {
        // Stores all the strongly connected components.
        vector<vector<int>> ans;

        // Stores whether a vertex is a part of any Strongly Connected Component
        vector<int> is_scc(n + 1, 0);

        vector<vector<int>> adj(n + 1);

        // Build adjacency list using the provided edges
        for (int i = 0; i < (int)a.size(); i++) {
            adj[a[i][0]].push_back(a[i][1]);
        }

        // Traversing all the vertices
        for (int i = 1; i <= n; i++) {

            if (!is_scc[i]) {
				
                // If a vertex i is not a part of any SCC
                // insert it into a new SCC list and check
                // for other vertices whether they can be
                // the part of this list.
                vector<int> scc;
                scc.push_back(i);

                for (int j = i + 1; j <= n; j++) {

                    // If there is a path from vertex i to
                    // vertex j and vice versa, put vertex j
                    // into the current SCC list.
                    if (!is_scc[j] && isPath(i, j, adj) && isPath(j, i, adj)) {
                        is_scc[j] = 1;
                        scc.push_back(j);
                    }
                }

                // Insert the SCC containing vertex i into
                // the final list.


                ans.push_back(scc);
				
            }
        }
        return ans;
    }

    // Function to build a Directed Acyclic Graph (DAG) by collapsing SCCs
    vector<vector<int>> buildDAG(const vector<vector<int>>& edges, const vector<vector<int>>& collapsedSCCs)
    {
        unordered_map<int, int> vertexToSCC;  // Map each vertex to its SCC index
        for (int i = 0; i < (int)collapsedSCCs.size(); ++i) {
            for (int vertex : collapsedSCCs[i]) {
                vertexToSCC[vertex] = i;
            }
        }

        vector<vector<int>> dag(collapsedSCCs.size(), vector<int>());

        for (const vector<int>& edge : edges) {
            int fromSCC = vertexToSCC[edge[0]];
            int toSCC = vertexToSCC[edge[1]];

            if (fromSCC != toSCC && find(dag[fromSCC].begin(), dag[fromSCC].end(), toSCC) == dag[fromSCC].end()) {
                dag[fromSCC].push_back(toSCC);
            }
        }

        return dag;
    }

int longest_path_dag(const vector<vector<int>>& dag, int source) {
        vector<int> top_order;
        topological_sort_dag(dag, top_order);

        vector<int> distance(dag.size(), numeric_limits<int>::min());
        distance[source] = 0;

        for (int u : top_order) {
            for (int v : dag[u]) {
                // Assuming all edges have weight 1
                if (distance[u] + 1 > distance[v]) {
                    distance[v] = distance[u] + 1;
                }
            }
        }

        int maxDistance = numeric_limits<int>::min();
        for (int d : distance) {
            if (d > maxDistance) {
                maxDistance = d;
            }
        }

        return maxDistance;
    }

	int longest_path_dag_for_all(const vector<vector<int>>& dag) {
        int max_length = numeric_limits<int>::min();

        for (int source = 0; source < (int)dag.size(); ++source) {
            int length = longest_path_dag(dag, source);
            if (length > max_length) {
                max_length = length;
            }
        }

        return max_length;
    }

private:
    // Helper function for topological sort of a DAG
    void topological_sort_dag(const vector<vector<int>>& dag, vector<int>& result) {
        vector<int> in_degree(dag.size(), 0);
        for (int i = 0; i < (int)dag.size(); ++i) {
            for (int j : dag[i]) {
                in_degree[j]++;
            }
        }

        queue<int> q;
        for (int i = 0; i < (int)dag.size(); ++i) {
            if (in_degree[i] == 0) {
                q.push(i);
            }
        }

        while (!q.empty()) {
            int current = q.front();
            q.pop();
            result.push_back(current);

            for (int neighbor : dag[current]) {
                if (--in_degree[neighbor] == 0) {
                    q.push(neighbor);
                }
            }
        }
    }
};

void collect_data(vector<vector<int>>& edges, int& Nodes_num, int& Edges_num) {
    scanf("%d%d", &Nodes_num, &Edges_num);
    edges.resize(Edges_num, vector<int>(2, 0));

    for (int i = 0; i < Edges_num; i++) {
        scanf("%d%d", &edges[i][0], &edges[i][1]);
    }
}


int main() {
    GFG obj;
    int Nodes_num, Edges_num;
    vector<vector<int>> edges;

    collect_data(edges, Nodes_num, Edges_num);

    // Find SCCs
    vector<vector<int>> collapsedSCCs = obj.findSCC(Nodes_num, edges);

    // Build DAG by collapsing SCCs
    vector<vector<int>> dag = obj.buildDAG(edges, collapsedSCCs);

    // Find the longest path for all vertices and display the maximum length
    int max_length = obj.longest_path_dag_for_all(dag);
    printf("%d\n", max_length);

    return 0;
}