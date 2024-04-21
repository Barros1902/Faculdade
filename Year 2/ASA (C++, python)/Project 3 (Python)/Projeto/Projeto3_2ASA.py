from pulp import *
num_toys, num_packages, num_max_toys = map(int, input().split())
toy_list = [list(map(int, input().split())) for _ in range(num_toys)]
package_list = [list(map(int, input().split())) for _ in range(num_packages)]  
toy_packages = {i: [] for i in range(1, num_toys + 1)}
for j, package in enumerate(package_list, start=1):
    for i in package[:3]:
        toy_packages[i].append(j)
prob = LpProblem("example", LpMaximize)
toys = [LpVariable(f"x{i}", lowBound=0, cat="Integer", upBound=toy[1]) for i, toy in enumerate(toy_list, start=1)]
packages = [LpVariable(f"p{i}", lowBound=0, cat="Integer") for i in range(1, num_packages + 1)]
for i, toy in enumerate(toy_list, start=1):
    prob += toys[i-1] + lpSum(packages[j-1] for j in toy_packages[i]) <= toy[1]
prob += lpSum(toy[0] * x for x, toy in zip(toys, toy_list)) + lpSum(package[3] * p for p, package in zip(packages, package_list))
prob += lpSum(toys) + 3 * lpSum(packages) <= num_max_toys
prob.solve(GLPK(msg=0))
print(int(value(prob.objective)))