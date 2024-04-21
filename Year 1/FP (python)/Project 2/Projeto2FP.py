"""
Projeto realizado no ambito da disciplina de Fundamentos da Programação
Projeto numero 2
Tomás Barros
ist1106588
11/11/2022
"""


# ---------------------------------------------------Construtores------------------------------------------------------#

def cria_gerador(bits, seed):

    """
    :param bits: Numero de bits (32 ou 64)
    :param seed: Numero correspondente à seed ou estado inicial
    :return: lista correspondente a um gerador do tipo [bits, seed]
    """

    if not (bits == 32 or bits == 64) or not isinstance(seed, int) or seed <= 0 or not isinstance(bits, int):
        raise ValueError('cria_gerador: argumentos invalidos')
    if bits == 32:
        if seed > 2**32:
            raise ValueError('cria_gerador: argumentos invalidos')
    if bits == 64:
        if seed > 2**64:
            raise ValueError('cria_gerador: argumentos invalidos')

    return [bits, seed]


def cria_copia_gerador(gerador):

    """
    :param gerador: Recebe um gerador
    :return cop_g: Copia não shallow do gerador recebido
    """
    cop_g = []
    for e in gerador:  # Por cada elemento do gerador adiciona um novo elemento à sua cópia
        cop_g += [e]
    return cop_g


# ----------------------------------------------------Seletores--------------------------------------------------------#
def obtem_estado(gerador):

    """
    :param gerador: Recebe um gerador
    :return: Seed ou estado do gerador recebido
    """
    return gerador[1]


# --------------------------------------------------Modificadores------------------------------------------------------#
def define_estado(gerador, seed):

    """
    :param gerador: Recebe um gerador
    :param seed: Valor que vai substituir a seed ou estado atual
    :return: seed: Nova seed ou estado do gerador
    """
    del gerador[1]
    gerador += [seed]
    return seed


def atualiza_estado(gerador):

    """
    :param gerador: Recebe um gerador
    :return: Devolve o estado atualizado de acordo com o método xorshift do gerador inicial
    """

    if gerador[0] == 32:  # Condição caso seja 32 bits do metodo xorshift
        gerador[1] ^= (gerador[1] << 13) & 0xFFFFFFFF
        gerador[1] ^= (gerador[1] >> 17) & 0xFFFFFFFF
        gerador[1] ^= (gerador[1] << 5) & 0xFFFFFFFF
    elif gerador[0] == 64:  # Condição caso seja 64 bits do metodo xorshift
        gerador[1] ^= (gerador[1] << 13) & 0xFFFFFFFFFFFFFFFF
        gerador[1] ^= (gerador[1] >> 7) & 0xFFFFFFFFFFFFFFFF
        gerador[1] ^= (gerador[1] << 17) & 0xFFFFFFFFFFFFFFFF
    return gerador[1]


# -------------------------------------------------Reconhecedor--------------------------------------------------------#
def eh_gerador(arg):

    """
    :param arg: Recebe algo
    :return: Retorna um valor de verdade correspondente a "O parametro recebido é um gerador?"
    """
    if isinstance(arg, list) and isinstance(arg[0], int) and len(arg) == 2 and ((arg[0] == 32 and isinstance(arg[1], int) and 0 < arg[1] < 10000000000) or \
       arg[0] == 64 and isinstance(arg[1], int) and 0 < arg[1] < 1.8446744e19):  # 10000000000 = 2**32 e 1.8446744e19 = 2**64
        return True
    return False


# -------------------------------------------------------Teste---------------------------------------------------------#
def geradores_iguais(gerador1, gerador2):

    """
    :param gerador1: Primeiro gerador recebido
    :param gerador2: Segundo gerador recebido
    :return: Retorna o valor de verdade correspondente a "Os geradores recebidos são iguais?"
    """
    if gerador1[0] == gerador2[0] and gerador1[1] == gerador2[1]:
        return True
    return False


# --------------------------------------------------Transformador------------------------------------------------------#
def gerador_para_str(gerador):

    """
    :param gerador: Recebe um gerador
    :return: Retorna o gerador em forma de string
    """

    if gerador[0] == 32:
        return 'xorshift32(s={})'.format(gerador[1])
    return 'xorshift64(s={})'.format(gerador[1])


# ---------------------------------------------------Alto-nivel--------------------------------------------------------#
def gera_numero_aleatorio(gerador, n):

    """
    :param gerador: Recebe um gerador
    :param n: Numero inteiro positovo
    :return: Retorna um numero aleatorio no intervalo [1,n]
    """
    return 1 + atualiza_estado(gerador) % n


def gera_carater_aleatorio(gerador, c):

    """
    :param gerador: Recebe um gerador
    :param c: Caracter entre [A,Z]
    :return: Retorna un caracter entre [A, c]
    """
    tamanho = ord(c) - 64
    return chr(65 + (atualiza_estado(gerador) % tamanho))


# ---------------------------------------------------Construtor--------------------------------------------------------#
def cria_coordenada(string, inteiro):

    """

    :param string: Recebe uma string
    :param inteiro: Recebe um inteiro
    :return: Retorna uma coordenada do tipo [string, inteiro]
    """
    if not isinstance(string, str) or len(string) != 1 or not 65 <= ord(string) <= 90:
        raise ValueError('cria_coordenada: argumentos invalidos')
    if not isinstance(inteiro, int) or not 1 <= inteiro <= 99 or len(string) > 2:
        raise ValueError('cria_coordenada: argumentos invalidos')
    return [string, inteiro]


# ---------------------------------------------------Seletores---------------------------------------------------------#
def obtem_coluna(coordenada):

    """
    :param coordenada: Recebe uma coordenada
    :return: Retorna a coluna correspondente a essa coordenada
    """

    return coordenada[0]


def obtem_linha(coordenada):

    """
    :param coordenada: Recebe uma coordenada
    :return: Retorna a linha correspondente a essa coordenada
    """
    return coordenada[1]


# ---------------------------------------------------Reconhecedo-------------------------------------------------------#
def eh_coordenada(arg):

    """
    :param arg: Recebe algo
    :return: Retorna o valor de verdade correspondente à pergunta "O recebido é uma coordenada?"
    """
    if not isinstance(arg, list) or not isinstance(arg[0], str) or not isinstance(arg[1], int)\
     or len(arg) != 2 or len(arg[0]) != 1 or not isinstance(arg[1], int):
        return False
    return True


# ------------------------------------------------------Teste----------------------------------------------------------#
def coordenadas_iguais(coordenada1, coordenada2):

    """
    :param coordenada1: Recebe a primeira coordenada
    :param coordenada2: Recebe a segunda coordenada
    :return: Retorna o valor de verdade correspondente a "As coordenadas recebidas são iguais?"
    """
    if coordenada1[0] == coordenada2[0] and coordenada1[1] == coordenada2[1]:
        return True
    return False


# --------------------------------------------------Transformador------------------------------------------------------#
def coordenada_para_str(coordenada):

    """
    :param coordenada: Recebe uma coordenada
    :return: Retorna a coordenada em forma de str(texto)
    """

    if len(str(coordenada[1])) == 1:
        return "{}0{}".format(coordenada[0], coordenada[1])
    return "{}{}".format(coordenada[0], coordenada[1])


def str_para_coordenada(string):
    """
    :param string: Recebe uma string
    :return: Retorna a coordenada do tipo ex:["A", 1]
    """
    if isinstance(string, str) and isinstance(string[0], str) and len(string) == 3 and\
            (string[1] and string[2] == "0" or "1" or "2" or "3" or "4" or "5" or "6" or "7" or "8" or "9"):
        return [string[0], int(string[1] + string[2])]


# --------------------------------------------------Transformador------------------------------------------------------#
def obtem_coordenadas_vizinhas(coordenada):

    """
    :param coordenada: Recebe uma coordenada
    :return: Retorna todas as coordenadas vizinhas
    """
    tuplo = [chr(ord(coordenada[0]) - 1), coordenada[1] - 1], [coordenada[0], coordenada[1] - 1], [chr(ord(coordenada[0]) + 1), coordenada[1] - 1], \
            [chr(ord(coordenada[0]) + 1), coordenada[1]], [chr(ord(coordenada[0]) + 1), coordenada[1] + 1], \
            [coordenada[0], coordenada[1] + 1], [chr(ord(coordenada[0]) - 1), coordenada[1] + 1], [chr(ord(coordenada[0]) - 1), coordenada[1]]
    tuplo_filtrado = tuple(filter(lambda x: 65 <= ord(x[0]) <= 90 and 1 <= x[1] <= 99, tuplo))
    return tuplo_filtrado


def obtem_coordenada_aleatoria(coordenada, gerador):

    """
    :param coordenada: Recebe uma coordenada
    :param gerador: Recebe um gerador
    :return: Retorna uma coordenada aleatoria obtida apartir do metodo xorshift
    """
    char_alt = gera_carater_aleatorio(gerador, coordenada[0])
    num_alt = gera_numero_aleatorio(gerador, coordenada[1])
    return [char_alt, num_alt]


# ---------------------------------------------------Construtores------------------------------------------------------#
def cria_parcela():

    """
    :return: Retorna uma parcela do tipo ['tapadas', 's/mina']
    """

    return ['tapadas', 's/mina']


def cria_copia_parcela(parcela):

    """

    :param parcela: Recebe uma parcela
    :return: Retorna uma copia não shallow da parcela recebida
    """

    cop_p = []
    for e in parcela:
        cop_p += [e]
    return cop_p


# ---------------------------------------------------Modificadores------------------------------------------------------#
def limpa_parcela(parcela):

    """
    :param parcela: Recebe uma parcela
    :return: Retorna a mesma parcela mas "limpa"
    """

    parcela[0] = 'limpas'
    return parcela


def marca_parcela(parcela):

    """
    :param parcela: Recebe uma parcela
    :return: Retorna a mesma parcela mas "marcadas"
    """
    parcela[0] = 'marcadas'
    return parcela


def desmarca_parcela(parcela):

    """
    :param parcela: Recebe uma parcela
    :return: Retorna a mesma parcela mas "tapadas"
    """
    parcela[0] = 'tapadas'
    return parcela


def esconde_mina(parcela):

    """
    :param parcela: Recebe uma parcela
    :return: Retorna a mesma parcela mas "minadas"
    """
    parcela[1] = 'minadas'
    return parcela
# ---------------------------------------------------Reconhecedores----------------------------------------------------#


def eh_parcela(arg):
    """
    :param arg: Recebe algo
    :return: Retorna o valor de verdade correspondente à pergunta "O recebido é uma parcela?"
    """
    if isinstance(arg, list) and len(arg) == 2 and (arg[0] == 'tapadas' or arg[0] == 'limpas' or arg[0] == 'marcadas')\
            and (arg[1] == 's/mina' or arg[1] == 'minadas'):
        return True
    return False


def eh_parcela_tapada(parcela):
    """
    :param parcela: Recebe uma parcela
    :return: Retorna o valor de verdade correspondente à pergunta "O recebido é uma parcela tapada?"
     """
    if eh_parcela(parcela):
        if parcela[0] == 'tapadas':
            return True
        else:
            return False


def eh_parcela_marcada(parcela):
    """
    :param parcela: Recebe uma parcela
    :return: Retorna o valor de verdade correspondente à pergunta "O recebido é uma parcela marcada?"
    """
    if eh_parcela(parcela):
        if parcela[0] == 'marcadas':
            return True
        else:
            return False


def eh_parcela_limpa(parcela):
    """
    :param parcela: Recebe uma parcela
    :return: Retorna o valor de verdade correspondente à pergunta "O recebido é uma parcela limpa?"
    """
    if eh_parcela(parcela):
        if parcela[0] == 'limpas':
            return True
        else:
            return False


def eh_parcela_minada(parcela):
    """
        :param parcela: Recebe uma parcela
        :return: Retorna o valor de verdade correspondente à pergunta "O recebido é uma parcela minada?"
         """
    if eh_parcela(parcela):
        if parcela[1] == 'minadas':
            return True
        else:
            return False


# ---------------------------------------------------Teste-------------------------------------------------------------#
def parcelas_iguais(parcela1, parcela2):
    """

    :param parcela1: Primeria parcela recebida
    :param parcela2: Segunda parcela recebida
    :return: Retorna o valor de verdade correspondente à pergunta "As parcelas recebidas são iguais?"
    """
    if parcela1 == parcela2:
        return True
    return False


# ---------------------------------------------------Transformadores---------------------------------------------------#
def parcela_para_str(parcela):
    """

    :param parcela: Recebe uma parcela
    :return: Retorna um caracter especifico que representa a parcela
    """
    if eh_parcela(parcela):
        if parcela[0] == 'tapadas':
            return '#'
        elif parcela[0] == 'marcadas':
            return '@'
        else:
            if parcela[1] == "s/mina":
                return '?'
            else:
                return 'X'


def alterna_bandeira(parcela):

    """

    :param parcela: Recebe uma parcela
    :return: Retorna um valor de verdade depois de alterar a bandeira caso esta esteja marcada ou tapada
    """
    if eh_parcela(parcela):
        if parcela[0] == 'marcadas':
            parcela[0] = 'tapadas'
            return True
        elif parcela[0] == 'tapadas':
            parcela[0] = 'marcadas'
            return True
        return False


# ---------------------------------------------------Construtores------------------------------------------------------#
def cria_campo(comprimento, largura):
    """

    :param comprimento: Recebe um comprimento
    :param largura: Recebe uma largura
    :return: Retorna um "campo" com dimensões comprimento por largura
    """
    if not isinstance(comprimento, str) or len(comprimento) != 1 or not 65 <= ord(comprimento) <= 90:
        raise ValueError('cria_campo: argumentos invalidos')
    if not isinstance(largura, int) or not 1 <= largura <= 99 or len(comprimento) > 2:
        raise ValueError('cria_campo: argumentos invalidos')
    co = ord(comprimento) - 64  # Comprimento de cada linha
    campo = []
    letras = []
    for coluna in range(ord(comprimento) - 64):  # Gera as letras
        letras += [chr(65 + coluna)]

    campo.append(letras)
    campo.append(["  +", "-" * (ord(comprimento) - 64), "+"])
    for linhas in range(largura):
        if linhas <= 8:  # Caso em que o numero da linha é inferior a 10 serve para adicionar o 0 antes
            campo.append(["0{}".format(1 + linhas), "|", [cria_copia_parcela(cria_parcela()) for gg in range(co)], "|"])
        else:  # Caso em que o numero da linha é maior que 9
            campo.append(["{}".format(1 + linhas), "|", [cria_copia_parcela(cria_parcela()) for gg in range(co)], "|"])
    campo.append(["  +", "-" * (ord(comprimento) - 64), "+"])
    return campo


def cria_copia_campo(campo):
    """

    :param campo: Recebe um campo
    :return: Retorna uma copia não shallow do campo recebido
    """
    parcelas = []
    campo_copia = []
    campo_copia += [campo[0]] + [campo[1]]
    for linha in campo[2:-1]:
        for parcela in linha[2]:
            parcelas += [cria_copia_parcela(parcela)]

        uma_linha = [linha[0], linha[1], parcelas, linha[-1]]
        parcelas = []
        campo_copia += [uma_linha]
    campo_copia += [campo[-1]]
    return campo_copia


# ---------------------------------------------------Seletores---------------------------------------------------------#
def obtem_ultima_coluna(campo):
    """
    :param campo: Recebe um campo
    :return: A ultima coluna desse campo
    """
    return campo[0][-1]


def obtem_ultima_linha(m):
    """
    :param campo: Recebe um campo
    :return: A ultima linha desse campo
    """
    return int(m[-2][0])


def obtem_parcela(campo, coordenada):
    """
    :param campo: Recebe um campo
    :param coordenada: Recebe uma coordenada
    :return: Retorna a parcela do campo associada à coordenada recebida
    """
    return campo[coordenada[1] + 1][2][ord(coordenada[0]) - 65]


def obtem_coordenadas(campo, possibilidades):
    """
    :param campo: Recebe um campo
    :param possibilidades: Recebe uma string
    :return: Retorna um tuplo com as coordenadas com a string recebida
    """
    tuplo = ()
    todas_coords = []
    for i in range(1, (int(campo[-2][0]) + 1)):
        for e in campo[0]:
            todas_coords.append([e, i])
    for coord in todas_coords:
        if obtem_parcela(campo, coord)[0] == possibilidades or obtem_parcela(campo, coord)[1] == possibilidades:
            tuplo += (coord,)
    return tuplo


def obtem_numero_minas_vizinhas(campo, coordenada):
    """

    :param campo: Recebe um campo
    :param coordenada: Recebe uma coordenada
    :return: Retorna as coordenadas vizinhas da coordenada recebida nesse campo
    """
    num_minas_vizinhas = 0
    c_viz = obtem_coordenadas_vizinhas(coordenada)
    ult_linha = obtem_ultima_linha(campo)
    c_viz = tuple(filter(lambda x: 65 <= ord(x[0]) <= ord(obtem_ultima_coluna(campo)) and 1 <= x[1] <= ult_linha, c_viz))
    for coord in c_viz:
        if obtem_parcela(campo, coord)[1] == "minadas":
            num_minas_vizinhas += 1

    return num_minas_vizinhas


# ---------------------------------------------------reconhecedores----------------------------------------------------#
def eh_campo(arg):
    """

    :param arg: Recebe algo
    :return: Retorna o valor de verdade correspondente a "O recebido é um campo?"
    """
    if not isinstance(arg, list) or arg == []:
        return False
    if not len(arg) == obtem_ultima_linha(arg) + 3 or not len(arg[0]) == ord(obtem_ultima_coluna(arg)) - 64:
        return False
    if not len(arg[1]) == 3 or not len(arg[-1]) == 3:
        return False

    for e in arg[0]:
        if not isinstance(e, str) or len(e) != 1 or not 64 < ord(e) <= 90:
            return False
    if not arg[1][0] == '  +' or not arg[1][-1] == '+' or not arg[-1][0] == '  +' or not arg[-1][-1] == '+':
        return False

    for x in range(obtem_ultima_linha(arg)):
        if x < 9:
            if not arg[x+2][0] == '0{}'.format(x+1) or not arg[x+2][1] == '|' or not arg[x+2][-1] == '|':
                return False
        if x >= 9:
            if not arg[x + 2][0] == '{}'.format(x + 1) or not arg[x + 2][1] == '|' or not arg[x + 2][-1] == '|':
                return False
        if not len(arg[x+2][2]) == ord(obtem_ultima_coluna(arg)) - 64:
            return False
        for y in range(ord(obtem_ultima_coluna(arg)) - 64):
            if not eh_parcela(arg[x+2][2][y]):
                return False
    for menos in arg[1][1]:
        if not menos == "-":
            return False
    if not arg[1] == arg[-1]:
        return False

    return True


def eh_coordenada_do_campo(campo, coordenada):
    """

    :param campo: Recebe um campo
    :param coordenada: Recebe uma coordenada
    :return: Retorna o valor de verdade de "A coordenada recebida pertence ao campo?"
    """
    todas_coords = []
    for i in range(1, (int(campo[-2][0]) + 1)):
        for e in campo[0]:
            todas_coords.append([e, i])
    if coordenada in todas_coords:
        return True
    return False


# ---------------------------------------------------Teste-------------------------------------------------------------#
def campos_iguais(m1, m2):
    if m1 == m2:
        return True
    return False


# ---------------------------------------------------Transformador-----------------------------------------------------#
def campo_para_str(m):
    y = 0
    caracteres = ""
    x = 0
    todas_coords = []
    for i in range(1, (int(m[-2][0]) + 1)):
        for e in m[0]:
            todas_coords.append([e, i])
    string_final = "   " + "".join(m[0]) + "\n" + "".join(m[1]) + "\n"
    while y != int(m[-2][0]):
        for linha in range(len(m[0])):
            if parcela_para_str(obtem_parcela(m, todas_coords[x])) == "?":
                if obtem_numero_minas_vizinhas(m, todas_coords[x]) == 0:
                    caracteres += " "
                else:
                    caracteres += str(obtem_numero_minas_vizinhas(m, todas_coords[x]))
            else:
                caracteres += parcela_para_str(obtem_parcela(m, todas_coords[x]))
            x += 1
        string_final += m[2 + y][0] + "|" + caracteres + "|" + "\n"
        caracteres = ""
        y += 1
    string_final += "".join(m[1])
    return string_final


def coloca_minas(m, c, g, n):
    lista_coords = []

    for coord in (cria_coordenada(gera_carater_aleatorio(g, obtem_ultima_coluna(m)),
                                  gera_numero_aleatorio(g, int(obtem_ultima_linha(m)))) for x in range(10000)):
        if (coord != c) and (coord not in lista_coords) and (coord not in obtem_coordenadas_vizinhas(c)):
            lista_coords += [coord]
            if len(lista_coords) == n:
                for coordenada in lista_coords:
                    esconde_mina(obtem_parcela(m, coordenada))
                return m


def limpa_campo(m, c):

    if not eh_parcela_limpa(obtem_parcela(m, c)):
        limpa_parcela(obtem_parcela(m, c))
    if obtem_numero_minas_vizinhas(m, c) == 0:
        coord_viz = obtem_coordenadas_vizinhas(c)
        coord_viz = tuple(filter(lambda x: 65 <= ord(x[0]) <= ord(obtem_ultima_coluna(m)) and 1 <= x[1] <= obtem_ultima_linha(m), coord_viz))
        for e in coord_viz:
            if e in obtem_coordenadas(m, "tapadas") and c not in obtem_coordenadas(m, "minadas"):

                limpa_campo(m, e)
    return m


# ------------------------------------------Funcoes_adicionais----------------------------------------------------------
def jogo_ganho(m):
    if obtem_coordenadas(m, "s/mina") == obtem_coordenadas(m, "limpas"):
        return True
    return False


def turno_jogador(m):
    todas_coords = []
    for i in range(1, (int(m[-2][0]) + 1)):
        for e in m[0]:
            todas_coords.append([e, i])
    escolha = input("Escolha uma ação, [L]impar ou [M]arcar:")
    if escolha == "L":
        def escolha_l():
            escolha2 = input("Escolha uma coordenada:")

            if eh_coordenada(str_para_coordenada(escolha2)) and str_para_coordenada(escolha2) in todas_coords:
                if eh_parcela_minada(obtem_parcela(m, str_para_coordenada(escolha2))):
                    limpa_parcela(obtem_parcela(m, str_para_coordenada(escolha2)))
                    return False
                limpa_campo(m, str_para_coordenada(escolha2))
                return True
            return escolha_l()

        return escolha_l()
    elif escolha == "M":
        def escolha_m():
            escolha2 = input("Escolha uma coordenada:")
            if eh_coordenada(str_para_coordenada(escolha2)) and str_para_coordenada(escolha2) in todas_coords:
                if eh_parcela_marcada(obtem_parcela(m, str_para_coordenada(escolha2))):
                    desmarca_parcela(obtem_parcela(m, str_para_coordenada(escolha2)))
                    return True
                else:
                    marca_parcela(obtem_parcela(m, str_para_coordenada(escolha2)))
                    return True
            else:
                return escolha_m()
        return escolha_m()
    else:
        return turno_jogador(m)


def minas(comprimento, largura, n_minas, bits, seed):
    if not isinstance(comprimento, str) or len(comprimento) != 1 or not isinstance(largura, int) or not 0 < largura <=99:
        raise ValueError("minas: argumentos invalidos")
    if not 64 < ord(comprimento) <= 90:
        raise ValueError("minas: argumentos invalidos")
    if (largura*(ord(comprimento) - 64)) < 5:
        raise ValueError("minas: argumentos invalidos")
    elif comprimento == "A" or largura == 1:
        if ord(comprimento) - 64 < 5 and largura < 5:
            raise ValueError("minas: argumentos invalidos")
        if not isinstance(n_minas, int) or not 0 < n_minas < (largura*(ord(comprimento) - 64)) - 3:
            raise ValueError("minas: argumentos invalidos")
    elif comprimento == "B" or largura == 2:
        if ord(comprimento) - 64 < 4 and largura < 4:
            raise ValueError("minas: argumentos invalidos")
        if not isinstance(n_minas, int) or not 0 < n_minas < (largura * (ord(comprimento) - 64)) - 6:
            raise ValueError("minas: argumentos invalidos")
    elif comprimento == "C" and largura == 3:
        raise ValueError("minas: argumentos invalidos")
    elif (largura*(ord(comprimento) - 64)) > 9:
        if not isinstance(n_minas, int) or not 0 < n_minas < (largura*(ord(comprimento) - 64)) - 8:
            raise ValueError("minas: argumentos invalidos")

    if not (bits == 32 or bits == 64) or not isinstance(seed, int) or seed <= 0 or not isinstance(bits, int):
        raise ValueError('minas: argumentos invalidos')
    if bits == 32:
        if seed > 2**32:
            raise ValueError('minas: argumentos invalidos')
    if bits == 64:
        if seed > 2**64:
            raise ValueError('minas: argumentos invalidos')
    m = cria_campo(comprimento, largura)
    todas_coords = []
    for i in range(1, (int(m[-2][0]) + 1)):
        for e in m[0]:
            todas_coords.append([e, i])
    gerador = cria_gerador(bits, seed)
    print("   [Bandeiras 0/{}]".format(n_minas))
    print(campo_para_str(m))

    def limpa_primeira():
        primeira_parcela = input("Escolha uma coordenada:")
        if eh_coordenada(str_para_coordenada(primeira_parcela)):
            if str_para_coordenada(primeira_parcela) not in todas_coords:
                limpa_primeira()
            return primeira_parcela
        return limpa_primeira()
    primeira_parcela = limpa_primeira()
    limpa_parcela(obtem_parcela(m, str_para_coordenada(primeira_parcela)))

    coloca_minas(m, str_para_coordenada(primeira_parcela), gerador, n_minas)
    limpa_campo(m, str_para_coordenada(primeira_parcela))
    print("   [Bandeiras {}/{}]".format(len(obtem_coordenadas(m, "marcadas")), n_minas))
    print(campo_para_str(m))
    if jogo_ganho(m):
        print("VITORIA!!!")
        return True

    while True:

        if not turno_jogador(m):
            print("   [Bandeiras {}/{}]".format(len(obtem_coordenadas(m, "marcadas")), n_minas))
            print(campo_para_str(m))
            print("BOOOOOOOM!!!")
            return False
        print("   [Bandeiras {}/{}]".format(len(obtem_coordenadas(m, "marcadas")), n_minas))
        print(campo_para_str(m))
        if jogo_ganho(m):
            print("VITORIA!!!")
            return True"""
Projeto realizado no ambito da disciplina de Fundamentos da Programação
Projeto numero 2
Tomás Barros
ist1106588
11/11/2022
"""


# ---------------------------------------------------Construtores------------------------------------------------------#

def cria_gerador(bits, seed):

    """
    :param bits: Numero de bits (32 ou 64)
    :param seed: Numero correspondente à seed ou estado inicial
    :return: lista correspondente a um gerador do tipo [bits, seed]
    """

    if not (bits == 32 or bits == 64) or not isinstance(seed, int) or seed <= 0 or not isinstance(bits, int):
        raise ValueError('cria_gerador: argumentos invalidos')
    if bits == 32:
        if seed > 2**32:
            raise ValueError('cria_gerador: argumentos invalidos')
    if bits == 64:
        if seed > 2**64:
            raise ValueError('cria_gerador: argumentos invalidos')

    return [bits, seed]


def cria_copia_gerador(gerador):

    """
    :param gerador: Recebe um gerador
    :return cop_g: Copia não shallow do gerador recebido
    """
    cop_g = []
    for e in gerador:  # Por cada elemento do gerador adiciona um novo elemento à sua cópia
        cop_g += [e]
    return cop_g


# ----------------------------------------------------Seletores--------------------------------------------------------#
def obtem_estado(gerador):

    """
    :param gerador: Recebe um gerador
    :return: Seed ou estado do gerador recebido
    """
    return gerador[1]


# --------------------------------------------------Modificadores------------------------------------------------------#
def define_estado(gerador, seed):

    """
    :param gerador: Recebe um gerador
    :param seed: Valor que vai substituir a seed ou estado atual
    :return: seed: Nova seed ou estado do gerador
    """
    del gerador[1]
    gerador += [seed]
    return seed


def atualiza_estado(gerador):

    """
    :param gerador: Recebe um gerador
    :return: Devolve o estado atualizado de acordo com o método xorshift do gerador inicial
    """

    if gerador[0] == 32:  # Condição caso seja 32 bits do metodo xorshift
        gerador[1] ^= (gerador[1] << 13) & 0xFFFFFFFF
        gerador[1] ^= (gerador[1] >> 17) & 0xFFFFFFFF
        gerador[1] ^= (gerador[1] << 5) & 0xFFFFFFFF
    elif gerador[0] == 64:  # Condição caso seja 64 bits do metodo xorshift
        gerador[1] ^= (gerador[1] << 13) & 0xFFFFFFFFFFFFFFFF
        gerador[1] ^= (gerador[1] >> 7) & 0xFFFFFFFFFFFFFFFF
        gerador[1] ^= (gerador[1] << 17) & 0xFFFFFFFFFFFFFFFF
    return gerador[1]


# -------------------------------------------------Reconhecedor--------------------------------------------------------#
def eh_gerador(arg):

    """
    :param arg: Recebe algo
    :return: Retorna um valor de verdade correspondente a "O parametro recebido é um gerador?"
    """
    if isinstance(arg, list) and isinstance(arg[0], int) and len(arg) == 2 and ((arg[0] == 32 and isinstance(arg[1], int) and 0 < arg[1] < 10000000000) or \
       arg[0] == 64 and isinstance(arg[1], int) and 0 < arg[1] < 1.8446744e19):  # 10000000000 = 2**32 e 1.8446744e19 = 2**64
        return True
    return False


# -------------------------------------------------------Teste---------------------------------------------------------#
def geradores_iguais(gerador1, gerador2):

    """
    :param gerador1: Primeiro gerador recebido
    :param gerador2: Segundo gerador recebido
    :return: Retorna o valor de verdade correspondente a "Os geradores recebidos são iguais?"
    """
    if gerador1[0] == gerador2[0] and gerador1[1] == gerador2[1]:
        return True
    return False


# --------------------------------------------------Transformador------------------------------------------------------#
def gerador_para_str(gerador):

    """
    :param gerador: Recebe um gerador
    :return: Retorna o gerador em forma de string
    """

    if gerador[0] == 32:
        return 'xorshift32(s={})'.format(gerador[1])
    return 'xorshift64(s={})'.format(gerador[1])


# ---------------------------------------------------Alto-nivel--------------------------------------------------------#
def gera_numero_aleatorio(gerador, n):

    """
    :param gerador: Recebe um gerador
    :param n: Numero inteiro positovo
    :return: Retorna um numero aleatorio no intervalo [1,n]
    """
    return 1 + atualiza_estado(gerador) % n


def gera_carater_aleatorio(gerador, c):

    """
    :param gerador: Recebe um gerador
    :param c: Caracter entre [A,Z]
    :return: Retorna un caracter entre [A, c]
    """
    tamanho = ord(c) - 64
    return chr(65 + (atualiza_estado(gerador) % tamanho))


# ---------------------------------------------------Construtor--------------------------------------------------------#
def cria_coordenada(string, inteiro):

    """

    :param string: Recebe uma string
    :param inteiro: Recebe um inteiro
    :return: Retorna uma coordenada do tipo [string, inteiro]
    """
    if not isinstance(string, str) or len(string) != 1 or not 65 <= ord(string) <= 90:
        raise ValueError('cria_coordenada: argumentos invalidos')
    if not isinstance(inteiro, int) or not 1 <= inteiro <= 99 or len(string) > 2:
        raise ValueError('cria_coordenada: argumentos invalidos')
    return [string, inteiro]


# ---------------------------------------------------Seletores---------------------------------------------------------#
def obtem_coluna(coordenada):

    """
    :param coordenada: Recebe uma coordenada
    :return: Retorna a coluna correspondente a essa coordenada
    """

    return coordenada[0]


def obtem_linha(coordenada):

    """
    :param coordenada: Recebe uma coordenada
    :return: Retorna a linha correspondente a essa coordenada
    """
    return coordenada[1]


# ---------------------------------------------------Reconhecedo-------------------------------------------------------#
def eh_coordenada(arg):

    """
    :param arg: Recebe algo
    :return: Retorna o valor de verdade correspondente à pergunta "O recebido é uma coordenada?"
    """
    if not isinstance(arg, list) or not isinstance(arg[0], str) or not isinstance(arg[1], int)\
     or len(arg) != 2 or len(arg[0]) != 1 or not isinstance(arg[1], int):
        return False
    return True


# ------------------------------------------------------Teste----------------------------------------------------------#
def coordenadas_iguais(coordenada1, coordenada2):

    """
    :param coordenada1: Recebe a primeira coordenada
    :param coordenada2: Recebe a segunda coordenada
    :return: Retorna o valor de verdade correspondente a "As coordenadas recebidas são iguais?"
    """
    if coordenada1[0] == coordenada2[0] and coordenada1[1] == coordenada2[1]:
        return True
    return False


# --------------------------------------------------Transformador------------------------------------------------------#
def coordenada_para_str(coordenada):

    """
    :param coordenada: Recebe uma coordenada
    :return: Retorna a coordenada em forma de str(texto)
    """

    if len(str(coordenada[1])) == 1:
        return "{}0{}".format(coordenada[0], coordenada[1])
    return "{}{}".format(coordenada[0], coordenada[1])


def str_para_coordenada(string):
    """
    :param string: Recebe uma string
    :return: Retorna a coordenada do tipo ex:["A", 1]
    """
    if isinstance(string, str) and isinstance(string[0], str) and len(string) == 3 and\
            (string[1] and string[2] == "0" or "1" or "2" or "3" or "4" or "5" or "6" or "7" or "8" or "9"):
        return [string[0], int(string[1] + string[2])]


# --------------------------------------------------Transformador------------------------------------------------------#
def obtem_coordenadas_vizinhas(coordenada):

    """
    :param coordenada: Recebe uma coordenada
    :return: Retorna todas as coordenadas vizinhas
    """
    tuplo = [chr(ord(coordenada[0]) - 1), coordenada[1] - 1], [coordenada[0], coordenada[1] - 1], [chr(ord(coordenada[0]) + 1), coordenada[1] - 1], \
            [chr(ord(coordenada[0]) + 1), coordenada[1]], [chr(ord(coordenada[0]) + 1), coordenada[1] + 1], \
            [coordenada[0], coordenada[1] + 1], [chr(ord(coordenada[0]) - 1), coordenada[1] + 1], [chr(ord(coordenada[0]) - 1), coordenada[1]]
    tuplo_filtrado = tuple(filter(lambda x: 65 <= ord(x[0]) <= 90 and 1 <= x[1] <= 99, tuplo))
    return tuplo_filtrado


def obtem_coordenada_aleatoria(coordenada, gerador):

    """
    :param coordenada: Recebe uma coordenada
    :param gerador: Recebe um gerador
    :return: Retorna uma coordenada aleatoria obtida apartir do metodo xorshift
    """
    char_alt = gera_carater_aleatorio(gerador, coordenada[0])
    num_alt = gera_numero_aleatorio(gerador, coordenada[1])
    return [char_alt, num_alt]


# ---------------------------------------------------Construtores------------------------------------------------------#
def cria_parcela():

    """
    :return: Retorna uma parcela do tipo ['tapadas', 's/mina']
    """

    return ['tapadas', 's/mina']


def cria_copia_parcela(parcela):

    """

    :param parcela: Recebe uma parcela
    :return: Retorna uma copia não shallow da parcela recebida
    """

    cop_p = []
    for e in parcela:
        cop_p += [e]
    return cop_p


# ---------------------------------------------------Modificadores------------------------------------------------------#
def limpa_parcela(parcela):

    """
    :param parcela: Recebe uma parcela
    :return: Retorna a mesma parcela mas "limpa"
    """

    parcela[0] = 'limpas'
    return parcela


def marca_parcela(parcela):

    """
    :param parcela: Recebe uma parcela
    :return: Retorna a mesma parcela mas "marcadas"
    """
    parcela[0] = 'marcadas'
    return parcela


def desmarca_parcela(parcela):

    """
    :param parcela: Recebe uma parcela
    :return: Retorna a mesma parcela mas "tapadas"
    """
    parcela[0] = 'tapadas'
    return parcela


def esconde_mina(parcela):

    """
    :param parcela: Recebe uma parcela
    :return: Retorna a mesma parcela mas "minadas"
    """
    parcela[1] = 'minadas'
    return parcela
# ---------------------------------------------------Reconhecedores----------------------------------------------------#


def eh_parcela(arg):
    """
    :param arg: Recebe algo
    :return: Retorna o valor de verdade correspondente à pergunta "O recebido é uma parcela?"
    """
    if isinstance(arg, list) and len(arg) == 2 and (arg[0] == 'tapadas' or arg[0] == 'limpas' or arg[0] == 'marcadas')\
            and (arg[1] == 's/mina' or arg[1] == 'minadas'):
        return True
    return False


def eh_parcela_tapada(parcela):
    """
    :param parcela: Recebe uma parcela
    :return: Retorna o valor de verdade correspondente à pergunta "O recebido é uma parcela tapada?"
     """
    if eh_parcela(parcela):
        if parcela[0] == 'tapadas':
            return True
        else:
            return False


def eh_parcela_marcada(parcela):
    """
    :param parcela: Recebe uma parcela
    :return: Retorna o valor de verdade correspondente à pergunta "O recebido é uma parcela marcada?"
    """
    if eh_parcela(parcela):
        if parcela[0] == 'marcadas':
            return True
        else:
            return False


def eh_parcela_limpa(parcela):
    """
    :param parcela: Recebe uma parcela
    :return: Retorna o valor de verdade correspondente à pergunta "O recebido é uma parcela limpa?"
    """
    if eh_parcela(parcela):
        if parcela[0] == 'limpas':
            return True
        else:
            return False


def eh_parcela_minada(parcela):
    """
        :param parcela: Recebe uma parcela
        :return: Retorna o valor de verdade correspondente à pergunta "O recebido é uma parcela minada?"
         """
    if eh_parcela(parcela):
        if parcela[1] == 'minadas':
            return True
        else:
            return False


# ---------------------------------------------------Teste-------------------------------------------------------------#
def parcelas_iguais(parcela1, parcela2):
    """

    :param parcela1: Primeria parcela recebida
    :param parcela2: Segunda parcela recebida
    :return: Retorna o valor de verdade correspondente à pergunta "As parcelas recebidas são iguais?"
    """
    if parcela1 == parcela2:
        return True
    return False


# ---------------------------------------------------Transformadores---------------------------------------------------#
def parcela_para_str(parcela):
    """

    :param parcela: Recebe uma parcela
    :return: Retorna um caracter especifico que representa a parcela
    """
    if eh_parcela(parcela):
        if parcela[0] == 'tapadas':
            return '#'
        elif parcela[0] == 'marcadas':
            return '@'
        else:
            if parcela[1] == "s/mina":
                return '?'
            else:
                return 'X'


def alterna_bandeira(parcela):

    """

    :param parcela: Recebe uma parcela
    :return: Retorna um valor de verdade depois de alterar a bandeira caso esta esteja marcada ou tapada
    """
    if eh_parcela(parcela):
        if parcela[0] == 'marcadas':
            parcela[0] = 'tapadas'
            return True
        elif parcela[0] == 'tapadas':
            parcela[0] = 'marcadas'
            return True
        return False


# ---------------------------------------------------Construtores------------------------------------------------------#
def cria_campo(comprimento, largura):
    """

    :param comprimento: Recebe um comprimento
    :param largura: Recebe uma largura
    :return: Retorna um "campo" com dimensões comprimento por largura
    """
    if not isinstance(comprimento, str) or len(comprimento) != 1 or not 65 <= ord(comprimento) <= 90:
        raise ValueError('cria_campo: argumentos invalidos')
    if not isinstance(largura, int) or not 1 <= largura <= 99 or len(comprimento) > 2:
        raise ValueError('cria_campo: argumentos invalidos')
    co = ord(comprimento) - 64  # Comprimento de cada linha
    campo = []
    letras = []
    for coluna in range(ord(comprimento) - 64):  # Gera as letras
        letras += [chr(65 + coluna)]

    campo.append(letras)
    campo.append(["  +", "-" * (ord(comprimento) - 64), "+"])
    for linhas in range(largura):
        if linhas <= 8:  # Caso em que o numero da linha é inferior a 10 serve para adicionar o 0 antes
            campo.append(["0{}".format(1 + linhas), "|", [cria_copia_parcela(cria_parcela()) for gg in range(co)], "|"])
        else:  # Caso em que o numero da linha é maior que 9
            campo.append(["{}".format(1 + linhas), "|", [cria_copia_parcela(cria_parcela()) for gg in range(co)], "|"])
    campo.append(["  +", "-" * (ord(comprimento) - 64), "+"])
    return campo


def cria_copia_campo(campo):
    """

    :param campo: Recebe um campo
    :return: Retorna uma copia não shallow do campo recebido
    """
    parcelas = []
    campo_copia = []
    campo_copia += [campo[0]] + [campo[1]]
    for linha in campo[2:-1]:
        for parcela in linha[2]:
            parcelas += [cria_copia_parcela(parcela)]

        uma_linha = [linha[0], linha[1], parcelas, linha[-1]]
        parcelas = []
        campo_copia += [uma_linha]
    campo_copia += [campo[-1]]
    return campo_copia


# ---------------------------------------------------Seletores---------------------------------------------------------#
def obtem_ultima_coluna(campo):
    """
    :param campo: Recebe um campo
    :return: A ultima coluna desse campo
    """
    return campo[0][-1]


def obtem_ultima_linha(m):
    """
    :param campo: Recebe um campo
    :return: A ultima linha desse campo
    """
    return int(m[-2][0])


def obtem_parcela(campo, coordenada):
    """
    :param campo: Recebe um campo
    :param coordenada: Recebe uma coordenada
    :return: Retorna a parcela do campo associada à coordenada recebida
    """
    return campo[coordenada[1] + 1][2][ord(coordenada[0]) - 65]


def obtem_coordenadas(campo, possibilidades):
    """
    :param campo: Recebe um campo
    :param possibilidades: Recebe uma string
    :return: Retorna um tuplo com as coordenadas com a string recebida
    """
    tuplo = ()
    todas_coords = []
    for i in range(1, (int(campo[-2][0]) + 1)):
        for e in campo[0]:
            todas_coords.append([e, i])
    for coord in todas_coords:
        if obtem_parcela(campo, coord)[0] == possibilidades or obtem_parcela(campo, coord)[1] == possibilidades:
            tuplo += (coord,)
    return tuplo


def obtem_numero_minas_vizinhas(campo, coordenada):
    """

    :param campo: Recebe um campo
    :param coordenada: Recebe uma coordenada
    :return: Retorna as coordenadas vizinhas da coordenada recebida nesse campo
    """
    num_minas_vizinhas = 0
    c_viz = obtem_coordenadas_vizinhas(coordenada)
    ult_linha = obtem_ultima_linha(campo)
    c_viz = tuple(filter(lambda x: 65 <= ord(x[0]) <= ord(obtem_ultima_coluna(campo)) and 1 <= x[1] <= ult_linha, c_viz))
    for coord in c_viz:
        if obtem_parcela(campo, coord)[1] == "minadas":
            num_minas_vizinhas += 1

    return num_minas_vizinhas


# ---------------------------------------------------reconhecedores----------------------------------------------------#
def eh_campo(arg):
    """

    :param arg: Recebe algo
    :return: Retorna o valor de verdade correspondente a "O recebido é um campo?"
    """
    if not isinstance(arg, list) or arg == []:
        return False
    if not len(arg) == obtem_ultima_linha(arg) + 3 or not len(arg[0]) == ord(obtem_ultima_coluna(arg)) - 64:
        return False
    if not len(arg[1]) == 3 or not len(arg[-1]) == 3:
        return False

    for e in arg[0]:
        if not isinstance(e, str) or len(e) != 1 or not 64 < ord(e) <= 90:
            return False
    if not arg[1][0] == '  +' or not arg[1][-1] == '+' or not arg[-1][0] == '  +' or not arg[-1][-1] == '+':
        return False

    for x in range(obtem_ultima_linha(arg)):
        if x < 9:
            if not arg[x+2][0] == '0{}'.format(x+1) or not arg[x+2][1] == '|' or not arg[x+2][-1] == '|':
                return False
        if x >= 9:
            if not arg[x + 2][0] == '{}'.format(x + 1) or not arg[x + 2][1] == '|' or not arg[x + 2][-1] == '|':
                return False
        if not len(arg[x+2][2]) == ord(obtem_ultima_coluna(arg)) - 64:
            return False
        for y in range(ord(obtem_ultima_coluna(arg)) - 64):
            if not eh_parcela(arg[x+2][2][y]):
                return False
    for menos in arg[1][1]:
        if not menos == "-":
            return False
    if not arg[1] == arg[-1]:
        return False

    return True


def eh_coordenada_do_campo(campo, coordenada):
    """

    :param campo: Recebe um campo
    :param coordenada: Recebe uma coordenada
    :return: Retorna o valor de verdade de "A coordenada recebida pertence ao campo?"
    """
    todas_coords = []
    for i in range(1, (int(campo[-2][0]) + 1)):
        for e in campo[0]:
            todas_coords.append([e, i])
    if coordenada in todas_coords:
        return True
    return False


# ---------------------------------------------------Teste-------------------------------------------------------------#
def campos_iguais(m1, m2):
    if m1 == m2:
        return True
    return False


# ---------------------------------------------------Transformador-----------------------------------------------------#
def campo_para_str(m):
    y = 0
    caracteres = ""
    x = 0
    todas_coords = []
    for i in range(1, (int(m[-2][0]) + 1)):
        for e in m[0]:
            todas_coords.append([e, i])
    string_final = "   " + "".join(m[0]) + "\n" + "".join(m[1]) + "\n"
    while y != int(m[-2][0]):
        for linha in range(len(m[0])):
            if parcela_para_str(obtem_parcela(m, todas_coords[x])) == "?":
                if obtem_numero_minas_vizinhas(m, todas_coords[x]) == 0:
                    caracteres += " "
                else:
                    caracteres += str(obtem_numero_minas_vizinhas(m, todas_coords[x]))
            else:
                caracteres += parcela_para_str(obtem_parcela(m, todas_coords[x]))
            x += 1
        string_final += m[2 + y][0] + "|" + caracteres + "|" + "\n"
        caracteres = ""
        y += 1
    string_final += "".join(m[1])
    return string_final


def coloca_minas(m, c, g, n):
    lista_coords = []

    for coord in (cria_coordenada(gera_carater_aleatorio(g, obtem_ultima_coluna(m)),
                                  gera_numero_aleatorio(g, int(obtem_ultima_linha(m)))) for x in range(10000)):
        if (coord != c) and (coord not in lista_coords) and (coord not in obtem_coordenadas_vizinhas(c)):
            lista_coords += [coord]
            if len(lista_coords) == n:
                for coordenada in lista_coords:
                    esconde_mina(obtem_parcela(m, coordenada))
                return m


def limpa_campo(m, c):

    if not eh_parcela_limpa(obtem_parcela(m, c)):
        limpa_parcela(obtem_parcela(m, c))
    if obtem_numero_minas_vizinhas(m, c) == 0:
        coord_viz = obtem_coordenadas_vizinhas(c)
        coord_viz = tuple(filter(lambda x: 65 <= ord(x[0]) <= ord(obtem_ultima_coluna(m)) and 1 <= x[1] <= obtem_ultima_linha(m), coord_viz))
        for e in coord_viz:
            if e in obtem_coordenadas(m, "tapadas") and c not in obtem_coordenadas(m, "minadas"):

                limpa_campo(m, e)
    return m


# ------------------------------------------Funcoes_adicionais----------------------------------------------------------
def jogo_ganho(m):
    if obtem_coordenadas(m, "s/mina") == obtem_coordenadas(m, "limpas"):
        return True
    return False


def turno_jogador(m):
    todas_coords = []
    for i in range(1, (int(m[-2][0]) + 1)):
        for e in m[0]:
            todas_coords.append([e, i])
    escolha = input("Escolha uma ação, [L]impar ou [M]arcar:")
    if escolha == "L":
        def escolha_l():
            escolha2 = input("Escolha uma coordenada:")

            if eh_coordenada(str_para_coordenada(escolha2)) and str_para_coordenada(escolha2) in todas_coords:
                if eh_parcela_minada(obtem_parcela(m, str_para_coordenada(escolha2))):
                    limpa_parcela(obtem_parcela(m, str_para_coordenada(escolha2)))
                    return False
                limpa_campo(m, str_para_coordenada(escolha2))
                return True
            return escolha_l()

        return escolha_l()
    elif escolha == "M":
        def escolha_m():
            escolha2 = input("Escolha uma coordenada:")
            if eh_coordenada(str_para_coordenada(escolha2)) and str_para_coordenada(escolha2) in todas_coords:
                if eh_parcela_marcada(obtem_parcela(m, str_para_coordenada(escolha2))):
                    desmarca_parcela(obtem_parcela(m, str_para_coordenada(escolha2)))
                    return True
                else:
                    marca_parcela(obtem_parcela(m, str_para_coordenada(escolha2)))
                    return True
            else:
                return escolha_m()
        return escolha_m()
    else:
        return turno_jogador(m)


def minas(comprimento, largura, n_minas, bits, seed):
    if not isinstance(comprimento, str) or len(comprimento) != 1 or not isinstance(largura, int) or not 0 < largura <=99:
        raise ValueError("minas: argumentos invalidos")
    if not 64 < ord(comprimento) <= 90:
        raise ValueError("minas: argumentos invalidos")
    if (largura*(ord(comprimento) - 64)) < 5:
        raise ValueError("minas: argumentos invalidos")
    elif comprimento == "A" or largura == 1:
        if ord(comprimento) - 64 < 5 and largura < 5:
            raise ValueError("minas: argumentos invalidos")
        if not isinstance(n_minas, int) or not 0 < n_minas < (largura*(ord(comprimento) - 64)) - 3:
            raise ValueError("minas: argumentos invalidos")
    elif comprimento == "B" or largura == 2:
        if ord(comprimento) - 64 < 4 and largura < 4:
            raise ValueError("minas: argumentos invalidos")
        if not isinstance(n_minas, int) or not 0 < n_minas < (largura * (ord(comprimento) - 64)) - 6:
            raise ValueError("minas: argumentos invalidos")
    elif comprimento == "C" and largura == 3:
        raise ValueError("minas: argumentos invalidos")
    elif (largura*(ord(comprimento) - 64)) > 9:
        if not isinstance(n_minas, int) or not 0 < n_minas < (largura*(ord(comprimento) - 64)) - 8:
            raise ValueError("minas: argumentos invalidos")

    if not (bits == 32 or bits == 64) or not isinstance(seed, int) or seed <= 0 or not isinstance(bits, int):
        raise ValueError('minas: argumentos invalidos')
    if bits == 32:
        if seed > 2**32:
            raise ValueError('minas: argumentos invalidos')
    if bits == 64:
        if seed > 2**64:
            raise ValueError('minas: argumentos invalidos')
    m = cria_campo(comprimento, largura)
    todas_coords = []
    for i in range(1, (int(m[-2][0]) + 1)):
        for e in m[0]:
            todas_coords.append([e, i])
    gerador = cria_gerador(bits, seed)
    print("   [Bandeiras 0/{}]".format(n_minas))
    print(campo_para_str(m))

    def limpa_primeira():
        primeira_parcela = input("Escolha uma coordenada:")
        if eh_coordenada(str_para_coordenada(primeira_parcela)):
            if str_para_coordenada(primeira_parcela) not in todas_coords:
                limpa_primeira()
            return primeira_parcela
        return limpa_primeira()
    primeira_parcela = limpa_primeira()
    limpa_parcela(obtem_parcela(m, str_para_coordenada(primeira_parcela)))

    coloca_minas(m, str_para_coordenada(primeira_parcela), gerador, n_minas)
    limpa_campo(m, str_para_coordenada(primeira_parcela))
    print("   [Bandeiras {}/{}]".format(len(obtem_coordenadas(m, "marcadas")), n_minas))
    print(campo_para_str(m))
    if jogo_ganho(m):
        print("VITORIA!!!")
        return True

    while True:

        if not turno_jogador(m):
            print("   [Bandeiras {}/{}]".format(len(obtem_coordenadas(m, "marcadas")), n_minas))
            print(campo_para_str(m))
            print("BOOOOOOOM!!!")
            return False
        print("   [Bandeiras {}/{}]".format(len(obtem_coordenadas(m, "marcadas")), n_minas))
        print(campo_para_str(m))
        if jogo_ganho(m):
            print("VITORIA!!!")
            return True