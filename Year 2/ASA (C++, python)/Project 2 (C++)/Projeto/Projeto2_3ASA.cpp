#include <iostream>
#include <vector>
#include <stack>
#include <algorithm>
#include <unordered_set>
#include <unordered_map>
#include <limits>
using namespace std;

class SCCFinder {
public:
    vector<vector<int>> findSCCs(int n, vector<vector<int>>& edges) {
        vector<vector<int>> adj(n + 1);
        for (const auto& edge : edges) {
            adj[edge[0]].push_back(edge[1]);
        }

        vector<int> order; // Stores the order of nodes based on their finish times
        vector<int> vis(n + 1, 0);

        // First DFS to get the order
        for (int i = 1; i <= n; ++i) {
            if (!vis[i]) {
                dfs(i, adj, vis, order);
            }
        }

        // Transpose the graph
        vector<vector<int>> transpose(n + 1);
        for (int i = 1; i <= n; ++i) {
            for (int neighbor : adj[i]) {
                transpose[neighbor].push_back(i);
            }
        }

        // Second DFS to find SCCs
        fill(vis.begin(), vis.end(), 0);
        vector<vector<int>> sccs;
        for (int i = order.size() - 1; i >= 0; --i) {
            int node = order[i];
            if (!vis[node]) {
                vector<int> scc;
                dfs(node, transpose, vis, scc);
                sccs.push_back(scc);
            }
        }

        return sccs;
    }

    vector<vector<int>> buildDAG(const vector<vector<int>>& edges, const vector<vector<int>>& sccs) {
        int numSCCs = sccs.size();
        unordered_map<int, int> vertexToSCC;  // Map each vertex to its SCC index
        for (int i = 0; i < numSCCs; ++i) {
            for (int vertex : sccs[i]) {
                vertexToSCC[vertex] = i;
            }
        }

        vector<vector<int>> dag(numSCCs);

        for (const vector<int>& edge : edges) {
            int fromSCC = vertexToSCC[edge[0]];
            int toSCC = vertexToSCC[edge[1]];

            if (fromSCC != toSCC) {
                dag[fromSCC].push_back(toSCC);
            }
        }

        return dag;
    }

    int longestPathDAG(const vector<vector<int>>& dag) {
        int numSCCs = dag.size();
        if (numSCCs == 0) {
            return 0; // No SCCs, the graph is acyclic
        }

        vector<int> dp(numSCCs, 0);
        int maxPath = numeric_limits<int>::min();

        for (int i = 0; i < numSCCs; ++i) {
            int pathLength = dfsLongestPath(i, dag, dp);
            maxPath = max(maxPath, pathLength);
        }

        return maxPath;
    }

private:

    int dfsLongestPath(int curr, const vector<vector<int>>& dag, vector<int>& dp) {
        if (dp[curr] != 0) {
            return dp[curr];
        }

        int maxPath = 0;
        for (int neighbor : dag[curr]) {
            int pathLength = dfsLongestPath(neighbor, dag, dp);
            maxPath = max(maxPath, pathLength);
        }

        dp[curr] = maxPath + 1; // Assuming all edges have weight 1

        return dp[curr];
    }

    // Helper function for DFS
    void dfs(int curr, const vector<vector<int>>& adj, vector<int>& vis, vector<int>& result) {
        vis[curr] = 1;
        for (int neighbor : adj[curr]) {
            if (!vis[neighbor]) {
                dfs(neighbor, adj, vis, result);
            }
        }
        result.push_back(curr);
    }
};

int main() {
    int n, m; // Number of nodes and edges
    cin >> n >> m;

    vector<vector<int>> edges(m, vector<int>(2));
    for (int i = 0; i < m; ++i) {
        cin >> edges[i][0] >> edges[i][1];
    }

    SCCFinder sccFinder;
    vector<vector<int>> sccs = sccFinder.findSCCs(n, edges);

    // Build DAG by collapsing SCCs
    vector<vector<int>> dag = sccFinder.buildDAG(edges, sccs);

    int maxPathLength = sccFinder.longestPathDAG(dag);
    cout << maxPathLength -1 << "\n";

    return 0;
}