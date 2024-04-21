% Numero ist 106588   Nome Tomas Barros 
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % para listas completas
:- ["dados.pl"], ["keywords.pl"]. % ficheiros a importar.


ambiguadorDePeriodos(p1,[p1, p1_2]).    % Caso 1 do Predicado que ambigua os Periodos 
ambiguadorDePeriodos(p2,[p2, p1_2]).    % Caso 2 do Predicado que ambigua os Periodos
ambiguadorDePeriodos(p3,[p3, p3_4]).    % Caso 3 do Predicado que ambigua os Periodos
ambiguadorDePeriodos(p4,[p4, p3_4]).    % Caso 4 do Predicado que ambigua os Periodos


eventosSemSalas(EventosOrdenada):-
     
    findall(N_Evento, evento(N_Evento, _, _, _, semSala), EventosDesordenada),    % Procura os IDs dos eventos sem sala
    sort(EventosDesordenada, EventosOrdenada).    % Ordena os IDs encontrados anteriormente e remove repetidos se estes existirem


eventosSemSalasDiaSemana(DiaDaSemana, EventosOrdenada):-

    findall(N_Evento, (evento(N_Evento, _, _, _, semSala), horario(N_Evento,DiaDaSemana, _, _, _, _)), EventosDesordenada), %Procura os IDs dos eventos sem sala num dia da semana especifico
    sort(EventosDesordenada, EventosOrdenada). % Ordena os IDs encontrados anteriormente e remove repetidos se estes existirem


eventosSemSalasPeriodo(Periodos, ListaEventosOrdenada):- 

    maplist(eventosSemSalasPeriodoAux, Periodos, ListaEventosNosPeriodos), % Maplist torna possivel Periodos ser uma lisa
    flatten(ListaEventosNosPeriodos, ListaEventos), % Da flat a lista, ou seja, tira as listas dentro de listas
    sort(ListaEventos, ListaEventosOrdenada).  % Ordena os IDs encontrados e remove repetidos se estes existirem

eventosSemSalasPeriodoAux(Periodo, EventoSemSalaNoPeriodoOrdenada):-  % Funcao auxiliar que ve os eventos sem sala num so periodo
    ambiguadorDePeriodos(Periodo, PossiveisPeriodos),
    findall(ID, ((member(Periodos, PossiveisPeriodos), horario(ID, _, _, _, _, Periodos)), 
    evento(ID, _, _, _, semSala)), EventoSemSalaNoPeriodo),  % Descobre todos os eventos sem sala no periodo desejado
    sort(EventoSemSalaNoPeriodo, EventoSemSalaNoPeriodoOrdenada). % Ordena os IDs encontrados e remove repetidos se estes existirem



organizaEventos(ListaEventos, Periodo, Eventos):-
    organizaEventos(ListaEventos, Periodo, Eventos, []).  % Engorda predicado

organizaEventos([], _, Acc, Ac):-   % Base da recursao
    sort(Ac, Acc).   % Ordena os IDs encontrados e remove repetidos se estes existirem

organizaEventos([ID | RestoIDs], Periodo, Eventos, Acc):-  % Caso em que o evento pertence ao periodo pedido
    ambiguadorDePeriodos(Periodo, PossiveisPeriodos),
    (horario(ID, _, _, _, _, Periodos), member(Periodos, PossiveisPeriodos)),

    append(Acc, [ID], Acc1),    % O ID do evento e guardado no acumulador
    organizaEventos(RestoIDs, Periodo, Eventos, Acc1).  % Volta a chamar o predicado com o resto dos IDs


organizaEventos([_ | RestoIDs], Periodo, Eventos, Acc):- % Caso o ID nao pertenca ao periodo volta a chamar o predicado com o resto dos IDs
    organizaEventos(RestoIDs, Periodo, Eventos, Acc).


eventosMenoresQue(TempoMax, ListaEventosMenoresQue):-
    findall(N_Evento, (horario(N_Evento, _, _, _, Tempo, _), TempoMax >= Tempo), ListaEventosMenoresQue). % Encontra todos os eventos com duracao menor ou igual a TempoMax


eventosMenoresQueBool(ID, DuracaoMax):-
    (horario(ID, _, _, _, Duracao, _), Duracao =< DuracaoMax). % Verifica se a duracao de um evento e menor que DuracaoMax


procuraDisciplinas(Curso, ListaDisciplinasLimpa):-   
    findall(Disciplina, (turno(ID, Curso, _, _), evento(ID, Disciplina, _, _, _)), ListaDisciplinas),  % Encontra todas as disciplinas de um Curso desejado
    sort(ListaDisciplinas, ListaDisciplinasLimpa).  % Remove entradas duplicadas e ordena por ordem alfabetica

organizaDisciplinas(ListaDisciplinas, Curso, Semestres):-   % Da as disciplinas divididas por semestres de um curso desejado
    procuraDisciplinas(Curso, DisciplinasDoCurso),  % Procura todas as disciplinas do curso desejado
    subtract(ListaDisciplinas, DisciplinasDoCurso, RestoDeDisciplina),  % Tira das disciplinas introduzidas as que pertencem ao curso
    RestoDeDisciplina = [], % Se todas as disciplinas introduzidas tiverem no curso a lista e vazia caso contrario falha
    organizaDisciplinas1(ListaDisciplinas, Curso, Semestres1Aux),   
    sort(Semestres1Aux, Semestres1),    % Ordena por ordem alfabetica
    organizaDisciplinas2(ListaDisciplinas, Curso, Semestres2Aux),
    sort(Semestres2Aux, Semestres2),    % ordena por ordem alfabetica
    subtract(Semestres2, Semestres1, Semestres2Final),   % Garante que nao se repetem disciplinas subtraindo do segundo as do primeiro
    Semestres =[Semestres1, Semestres2Final].

organizaDisciplinas1(ListaDisciplinas, Curso, Semestres):-  % Verifica se a disciplina pertence ao primeiro periodo
    organizaDisciplinas1(ListaDisciplinas, Curso, Semestres, []).   % Engorda predicado

organizaDisciplinas1([], _, Ac, Ac).    % Base da recursao 
organizaDisciplinas1([H|T], Curso, Semestres, Ac):-
    evento(ID, H, _, _, _), (horario(ID, _, _, _, _, Periodos), member(Periodos, [p1, p2, p1_2])), turno(ID, Curso, _, _),

    append(Ac, [H], Acc),   % Se H pertencer ao primeiro semestre entra no acumulador
    organizaDisciplinas1(T, Curso, Semestres, Acc).
organizaDisciplinas1([_ | T], Curso, Semestres, Acc):-  % Se H nao for do primeiro periodo esquece esse elemento
    organizaDisciplinas1(T, Curso, Semestres, Acc).

organizaDisciplinas2(ListaDisciplinas, Curso, Semestres):-  % Verifica se a disciplina pertence ao segundo periodo
    organizaDisciplinas2(ListaDisciplinas, Curso, Semestres, []).   % Engorda predicado
    
organizaDisciplinas2([], _, Ac, Ac).    % Base da recursao 
organizaDisciplinas2([H|T], Curso, Semestres, Ac):-
    evento(ID, H, _, _, _), (horario(ID, _, _, _, _, Periodos), member(Periodos, [p3, p4, p3_4])), turno(ID, Curso, _, _),
    append(Ac, [H], Acc),   % Se H pertencer ao segundo semestre entra no acumulador
    organizaDisciplinas2(T, Curso, Semestres, Acc).
organizaDisciplinas2([_ | T], Curso, Semestres, Acc):-  % Se H nao for do segundo periodo esquece esse elemento
    organizaDisciplinas2(T, Curso, Semestres, Acc).


horasCurso(Periodo, Curso, Ano, TotalHoras):-   
    ambiguadorDePeriodos(Periodo, PossiveisPeriodos),
    findall([ID,Horas], ((member(Periodos, PossiveisPeriodos), horario(ID, _, _, _, Horas, Periodos)),
    turno(ID, Curso, Ano, _)), ListaTotalHoras),
    sort(ListaTotalHoras, ListaTotalTurma), % Remove os horarios com IDs repetidos, ou seja, nao conta duplicados do turno 
    sumlistsegel(ListaTotalTurma, TotalHoras).

sumlistsegel([], 0).    % Funcao auxiliar que soma o segundo elemento de cada lista de uma lista de listas
sumlistsegel([H | T], Result):-
    sumlistsegel(T, Result1),
    nth0(1, H, Elem),
    Result is Result1 + Elem. 

evolucaoHorasCurso(Curso, Evolucao):-
    maplist(horasCurso(p1, Curso), [1, 2, 3], EvolucaoHoras1),  % Ve as horas do primeiro periodo de cada ano e poe nas numa lista
    maplist(horasCurso(p2, Curso), [1, 2, 3], EvolucaoHoras2),  % Ve as horas do segundo periodo de cada ano e poe nas numa lista
    maplist(horasCurso(p3, Curso), [1, 2, 3], EvolucaoHoras3),  % Ve as horas do terceiro periodo de cada ano e poe nas numa lista
    maplist(horasCurso(p4, Curso), [1, 2, 3], EvolucaoHoras4),  % Ve as horas do quarto periodo de cada ano e poe nas numa lista
    nth0(0, EvolucaoHoras1, Dado_p1_ano1),
    nth0(1, EvolucaoHoras1, Dado_p1_ano2),
    nth0(2, EvolucaoHoras1, Dado_p1_ano3),            
    nth0(0, EvolucaoHoras2, Dado_p2_ano1),          
    nth0(1, EvolucaoHoras2, Dado_p2_ano2),          
    nth0(2, EvolucaoHoras2, Dado_p2_ano3),          %  Predicado para encontrar cada uma das horas nas listas por periodo 
    nth0(0, EvolucaoHoras3, Dado_p3_ano1),
    nth0(1, EvolucaoHoras3, Dado_p3_ano2),
    nth0(2, EvolucaoHoras3, Dado_p3_ano3),
    nth0(0, EvolucaoHoras4, Dado_p4_ano1),
    nth0(1, EvolucaoHoras4, Dado_p4_ano2),
    nth0(2, EvolucaoHoras4, Dado_p4_ano3),

    Evolucao = [
        (1, p1, Dado_p1_ano1),(1, p2, Dado_p2_ano1),(1, p3, Dado_p3_ano1),(1, p4, Dado_p4_ano1),
        (2, p1, Dado_p1_ano2),(2, p2, Dado_p2_ano2),(2, p3, Dado_p3_ano2),(2, p4, Dado_p4_ano2),
        (3, p1, Dado_p1_ano3),(3, p2, Dado_p2_ano3),(3, p3, Dado_p3_ano3),(3, p4, Dado_p4_ano3)].


ocupaSlot(HoraInicioDada, HoraFimDada, HoraInicioEvento, HoraFimEvento, Horas):-
    HoraFimEvento < HoraInicioDada -> fail; %  Verifica se o evento se sobrepoe a hora dada caso contrario falha
    HoraInicioEvento > HoraFimDada -> fail; %  Verifica se o evento se sobrepoe a hora dada caso contrario falha
    HoraInicioDada =< HoraInicioEvento , HoraFimDada >= HoraFimEvento -> Horas is (HoraFimEvento - HoraInicioEvento);   
    HoraInicioDada >= HoraInicioEvento , HoraFimDada =< HoraFimEvento -> Horas is (HoraFimDada - HoraInicioDada);
    HoraInicioDada =< HoraInicioEvento , HoraFimDada =< HoraFimEvento -> Horas is (HoraFimDada - HoraInicioEvento);
    HoraInicioDada >= HoraInicioEvento , HoraFimDada >= HoraFimEvento -> Horas is (HoraFimEvento - HoraInicioDada).


numHorasOcupadas(Periodo, TipoSala, DiaSemana, HoraInicio, HoraFim, SomaHoras):-
    ambiguadorDePeriodos(Periodo, PossiveisPeriodos),
    salas(TipoSala, Salas),
    findall(Horas, ((evento(ID, _, _, _, TipoSalas), member(TipoSalas, Salas)),                         % Encontra as horas utilizadas por um determinado
    (horario(ID, DiaSemana, InicioAula, FimAula, _, Periodos), member(Periodos, PossiveisPeriodos)),    % tipo de sala num determinado periodo e num
    ocupaSlot(HoraInicio, HoraFim, InicioAula, FimAula, Horas)), ListaHoras),                           % determinado dia da semana
    
    sumlist(ListaHoras, SomaHoras). % Soma as horas ocupadas
    

ocupacaoMax(TipoSala, HoraInicio, HoraFim, Max):-
    salas(TipoSala, Salas), % Encontra todas salas do tipo de sala desejado
    length(Salas, N_Salas), % Ve a quantidade de salas do tipo de sala desejado
    Max is (HoraFim - HoraInicio) * N_Salas. 
    
percentagem(SomaHoras, Max, Percentagem):-
    Percentagem is (SomaHoras/Max)*100. 



ocupacaoCritica(HoraInicio, HoraFim, Threshold, Resultados):-
    findall(TipoSala, salas(TipoSala, _), ListaTiposSala), 
    ListaDiasDaSemana = [segunda-feira,terca-feira,quarta-feira,quinta-feira,sexta-feira],
    findall((casosCriticos(DiaSemana, TipoSalas, PercentagemInteira)), (member(Periodos, [p1, p1_2, p2, p3, p3_4, p4]), member(TipoSalas, ListaTiposSala), member(DiaSemana, ListaDiasDaSemana), numHorasOcupadas(Periodos, TipoSalas, DiaSemana, HoraInicio, HoraFim, SomaHoras), ocupacaoMax(TipoSalas, HoraInicio, HoraFim,Max), percentagem(SomaHoras, Max, Percentagem), Percentagem > Threshold, ceiling(Percentagem, PercentagemInteira)), Lista),
    sort(Lista, Resultados).