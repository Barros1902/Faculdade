def eh_territorio(PossivelTerritorio):

    if not isinstance(PossivelTerritorio, tuple):

        return False
    for coluna in PossivelTerritorio:
        if not isinstance(coluna, tuple):
       
            return False
        if len(PossivelTerritorio[0]) != len(coluna):

            return False
        for num in coluna:
            if num != 0 and num != 1:

                return False
    return True



"""t =  ((0,1,0,0),(0,0,0,0),(0,0,1,0),(1,0,0,0),(0,0,0,0))"""
"""
if eh_territorio(t):
    print("Territorio")
if not eh_territorio(t):
    print("Not Territorio")
    
"""
def obtem_ultima_intersecao(Territorio):
    if eh_territorio(Territorio):
        colunas = chr(len(Territorio) + ord("A") -1)
        linhas = len(Territorio[0])
    return (colunas, linhas)

"""print(obtem_ultima_intersecao(t))"""

def eh_intersecao(Intersecao):
    if not isinstance(Intersecao, tuple) or not len(Intersecao) == 2:
        return False
    if not isinstance(Intersecao[0], str) or not len(Intersecao[0]) == 1 or not ord("A") <= ord(Intersecao[0]) <= ord("Z"): 
        return False
    if not isinstance(Intersecao[1], int) or not 1 <= Intersecao[1] <= 99:
        return False
    return True

"""Intersecao = ("A", 1)"""

"""print(eh_intersecao(Intersecao))"""

def eh_intersecao_valida(Territorio, Intersecao):
    if not eh_territorio(Territorio) or not eh_intersecao(Intersecao):
        return False
    if not ord("A") <= ord(Intersecao[0]) <= ord("A") + len(Territorio) - 1 or not 1 <= Intersecao[1] <= len(Territorio[0]):
        return False
    return True

"""i = ("F", 4)
t =  ((0,1,0,0),(0,0,0,0),(0,0,1,0),(1,0,0,0),(0,0,0,0))
print(eh_intersecao_valida(t, i))"""

def eh_intersecao_livre(Territorio, Intersecao):
    if not eh_intersecao_valida(Territorio, Intersecao):
        return False
    if Territorio[ord(Intersecao[0]) - ord("A")][Intersecao[1]-1] == 0:
        return True
    return False

"""i = ("C", 1)
t =  ((0,1,0,0),(0,0,0,0),(0,0,1,0),(1,0,0,0),(0,0,0,0))
print(eh_intersecao_livre(t, i))"""

def obtem_intersecoes_adjacentes(Territorio, Intersecao):
    adjacentesverdadeiros = ()
    adjacentebaixo = (Intersecao[0], Intersecao[1]-1)
    adjacenteesquerda = (chr(ord(Intersecao[0])-1), Intersecao[1])
    adjacentedireita = (chr(ord(Intersecao[0])+1), Intersecao[1])
    adjacentecima = (Intersecao[0], Intersecao[1]+1)
    adjacentesfalsos = ((adjacentebaixo),(adjacenteesquerda), (adjacentedireita), (adjacentecima))
    for adjacente in adjacentesfalsos:
        if eh_intersecao_valida(Territorio, adjacente):
            adjacentesverdadeiros+= (adjacente,)
    return adjacentesverdadeiros

"""i = ("E", 1)
t =  ((0,1,0,0),(0,0,0,0),(0,0,1,0),(1,0,0,0),(0,0,0,0))

print(obtem_intersecoes_adjacentes(t, i))"""

def ordena_intersecoes(TuplodeIntersecoes):
    ListadeIntersecoes = list(TuplodeIntersecoes)
    ListaOrdenadadeIntersecoes = sorted(ListadeIntersecoes, key=lambda x: (x[1], x[0]))
    TuploOrdenadadeIntersecoes = tuple(ListaOrdenadadeIntersecoes)
    return TuploOrdenadadeIntersecoes

"""tup = (('A',1), ('A',2), ('A',3), ('B',1), ('B',2), ('B',3))
print(ordena_intersecoes(tup))"""

def territorio_para_str(Territorio):
    i = len(Territorio[0])
    j = "A"
    colunas_para_string(Territorio)
    while j != chr(ord(obtem_ultima_intersecao(Territorio)[0])+1):
        while i > 0:
            print(i, end = "")
            if eh_intersecao_livre(Territorio, (j, i)):
                print(" .", end = "")
            else: 
                print(" X", end = "")
            print(f"{i}")
            i-=1
        i = len(Territorio[0])
        j = chr(ord(j)+1)
    colunas_para_string(Territorio)


def colunas_para_string(Territorio):
    if eh_territorio(Territorio):
        ultima_intersecao = obtem_ultima_intersecao(Territorio)
        colunas = ord(ultima_intersecao[0]) - (ord("A"))
        print("  ", end = "")
        for i in range(colunas):
            print(chr(ord("A")+i), end= " ")
        print("")

t =  ((0,1,0,0),(0,0,0,0),(0,0,1,0),(1,0,0,0),(0,0,0,0))
territorio_para_str(t)

