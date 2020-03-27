# pucrs-sim-t1

Neste tarbalho criei um simulador capaz de simular uma realidade com um numero N de filas interligadas,
com probabilidades de roteamento para uma das filas, para fora do sistema e/ou para a mesma fila. 

Cada fila pode ser especificada para:
- possuir múltiplos servidores, 
- diferentes capacidades (finita ou infinita)
- diferentes tempos de chegada e atendimento

O simulador contem as seguintes estruturas:
- geração de números pseudo-aleatórios utilizando o Método da Congruência Linear;
- a semente utilizada (X0), e outros parâmetros que se fizerem necessários tem valores default, mas podem ser alterados;
- controle de eventos, avanço do tempo, teste de fim da simulação;
- disparo de rotinas de tratamento de eventos;
- contabilização de perda de clientes nas filas; e
- contabilização dos resultados de simulação.

Rodamos as seguintes simulações:
- fila simples com lista mockada, para validar o algoritmo
- fila simples com dados randomicos

Resultados da simulação

# Simulação com lista mockada

rndnumbersPerSeed:  8
seeds:              Mock list
Queue:              F1 (G/G/1/3)
Arrival:            1.0 ... 2.0
Service:            3.0 ... 6.0

## FilaSimples1-teste.yml                                       ## Simulacao
=========================================================       =========================================================
   State               Time               Probability               State               Time               Probability
      0               2,0000                24,02%                     0               2,0000                24,02%
      1               1,8851                22,64%                     1               1,8851                22,64%
      2               1,7851                21,44%                     2               1,7851                21,44%
      3               2,6555                31,90%                     3               2,6555                31,90%

Number of losses: 1                                                 Number of losses: 1
Simulation average time: 8,3257                                     Simulation average time: 8.33
=========================================================       =========================================================

-
--
-------------------------------------------------------------------------------------------------------------------------
--
-

# Simulação com dados randomicos

rndnumbersPerSeed:  100.000
seeds:              29
Queue:              F1 (G/G/1/3)
Arrival:            1.0 ... 2.0
Service:            3.0 ... 6.0

## FilaSimples1.yml                                             ## Simulacao
=========================================================       =========================================================
   State               Time               Probability               State               Time               Probability
      0               2,0000                 0,00%                     0               1.4544                 0.00%
      1               1,1991                 0,00%                     1               1.4310                 0.00%
      2           19384,3395                17,23%                     2           19449.8230                17.29%
      3           93094,7673                82,76%                     3           93021.2707                82.70%

Number of losses: 49963                                             Number of losses: 50015
Simulation average time: 112482,3059                                Simulation average time: 112473.9791
=========================================================       =========================================================

-
--
-------------------------------------------------------------------------------------------------------------------------
--
-