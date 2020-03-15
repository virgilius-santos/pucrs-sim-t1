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
