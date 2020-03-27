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

<table align="center" cellpadding="10">
    <thead>
        <tr>
            <th colspan=3>FilaSimples1-teste.yml</th>
            <th colspan=3>Simulacao</th>
        </tr>
    </thead>
    <tbody>
        <tr align="center">
            <td>State</td>
            <td>Time</td>
            <td>Probability</td>
            <td>State</td>
            <td>Time</td>
            <td>Probability</td>
        </tr>
        <tr align="center">
            <td>0</td>
            <td>2,0000</td>
            <td>24,02%</td>
            <td>0</td>
            <td>2,0000</td>
            <td>24,02%</td>
        </tr>
        <tr align="center">
            <td>1</td>
            <td>1,8851</td>
            <td>22,64%</td>
            <td>1</td>
            <td>1,8851</td>
            <td>22,64%</td>
        </tr>
        <tr align="center">
            <td>2</td>
            <td>1,7851</td>
            <td>21,44%</td>
            <td>2</td>
            <td>1,7851</td>
            <td>21,44%</td>
        </tr>
         <tr align="center">
            <td>3</td>
            <td>2,6555</td>
            <td>31,90%</td>
            <td>3</td>
            <td>2,6555</td>
            <td>31,90%</td>
        </tr>
        <tr>
            <td colspan=6></td>
        </tr>
        <tr>
            <td colspan=3>Number of losses: 1</td>
            <td colspan=3>Number of losses: 1</td>
        </tr>
        <tr>
            <td colspan=3>Simulation average time: 8,3257</td>
            <td colspan=3>Simulation average time: 8,3257</td>
        </tr>
    </tbody>
</table>

-

# Simulação com dados randomicos

rndnumbersPerSeed:  100.000  
seeds:              29  
Queue:              F1 (G/G/1/3)  
Arrival:            1.0 ... 2.0  
Service:            3.0 ... 6.0  

<table align="center" cellpadding="10">
    <thead>
        <tr>
            <th colspan=3>FilaSimples1.yml</th>
            <th colspan=3>Simulacao</th>
        </tr>
    </thead>
    <tbody>
        <tr align="center">
            <td>State</td>
            <td>Time</td>
            <td>Probability</td>
            <td>State</td>
            <td>Time</td>
            <td>Probability</td>
        </tr>
        <tr align="center">
            <td>0</td>
            <td>2,0000</td>
            <td>0,00%</td>
            <td>0</td>
            <td>1.4544</td>
            <td>0,00%</td>
        </tr>
        <tr align="center">
            <td>1</td>
            <td>1,1991</td>
            <td>0,00%</td>
            <td>1</td>
            <td>1.4310</td>
            <td>0,00%</td>
        </tr>
        <tr align="center">
            <td>2</td>
            <td>19384,3395</td>
            <td>17,23%</td>
            <td>2</td>
            <td>19449.8230</td>
            <td>17.29%</td>
        </tr>
         <tr align="center">
            <td>3</td>
            <td>93094,7673</td>
            <td>82,76%</td>
            <td>3</td>
            <td>93021.2707</td>
            <td>82.70%</td>
        </tr>
        <tr>
            <td colspan=6></td>
        </tr>
        <tr>
            <td colspan=3>Number of losses: 49963</td>
            <td colspan=3>Number of losses: 50015</td>
        </tr>
        <tr>
            <td colspan=3>Simulation average time: 112482,3059</td>
            <td colspan=3>Simulation average time: 112473.9791</td>
        </tr>
    </tbody>
</table>

-
