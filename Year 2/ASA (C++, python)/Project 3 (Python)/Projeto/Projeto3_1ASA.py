from pulp import *

prob = LpProblem("example", LpMaximize)
num_toys, num_packages, num_max_toys = [int(x) for x in input().split()]
toy_list = []
for i in range(1, num_toys + 1):
    toy_line = input().split()
    toy_list.append([int(toy_line[0]), int(toy_line[1]), [], LpVariable("x" + str(i), lowBound=0, cat="Integer", upBound=int(toy_line[1]))])
package_list = []
for i in range(1, num_packages + 1): 
    package_line = input().split()
    toy_list[int(package_line[0])-1][2].append(i)
    toy_list[int(package_line[1])-1][2].append(i)
    toy_list[int(package_line[2])-1][2].append(i)
    package_list.append([int(package_line[3])])
packages = [LpVariable(f"p{i}", lowBound=0, cat="Integer") for i in range(1, num_packages + 1)]

for i in range(1, num_toys + 1):
    if toy_list[i - 1][2] != []:
        prob += toy_list[i - 1][3] + lpSum(packages[j - 1] for j in toy_list[i - 1][2]) <= toy_list[i - 1][1]
    else:
        continue
    
prob += lpSum(toy_list[i - 1][3] * toy_list[i -1][0]  for i in range(1, num_toys + 1)) + lpSum(package_list[i-1][0] * packages[i-1] for i in range(1, num_packages + 1)), "Total_Profit"
prob += lpSum(toy_list[i - 1][3] for i in range(1, num_toys + 1)) + 3 * lpSum(packages) <= num_max_toys
prob.solve(GLPK(msg=0))
print(int(value(prob.objective)))
