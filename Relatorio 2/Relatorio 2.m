%% RELATORIO 2 - AULAS 3 E 4
% MATLAB
% Sistemas Caixa Branca, Caixa Cinza e Caixa Preta

clear;
clc;
close all;


%% ============================================================
% 1. SISTEMA MASSA-ATRITO E COMPARACAO GRAFICA - CAIXA BRANCA
% =============================================================

% Sistema 1
M1 = 2;
B1 = 3;

% Sistema 2
M2 = 4;
B2 = 6;

% Funcao de transferencia:
% G(s) = 1 / (M*s + B)

G1 = tf(1, [M1 B1]);
G2 = tf(1, [M2 B2]);

disp('============================================================');
disp('1. SISTEMA MASSA-ATRITO');
disp('============================================================');

disp('Funcao de transferencia - Sistema 1:');
G1

disp('Funcao de transferencia - Sistema 2:');
G2

% Vetor de tempo
t1 = 0:0.01:20;

% Respostas ao degrau
[y1, t1] = step(G1, t1);
[y2, ~] = step(G2, t1);

% Forca unitaria
u1 = ones(size(t1));

% Figura com as duas respostas e a forca unitaria
figure;

plot(t1, y1, 'LineWidth', 1.5);
hold on;
plot(t1, y2, 'LineWidth', 1.5);
plot(t1, u1, '--', 'LineWidth', 1.5);

xlabel('Tempo (s)');
ylabel('Resposta');
title('Resposta ao Degrau - Sistemas Massa-Atrito');
legend('Sistema 1', 'Sistema 2', 'Forca unitaria');
grid on;

% Janela de ampliacao dos primeiros 5 segundos
axes('Position', [0.58 0.52 0.28 0.30]);

plot(t1, y1, 'LineWidth', 1.2);
hold on;
plot(t1, y2, 'LineWidth', 1.2);
plot(t1, u1, '--', 'LineWidth', 1.2);

xlim([0 5]);
grid on;
title('Primeiros 5 segundos');


% Segunda figura com dois graficos separados
figure;

subplot(2,1,1);
plot(t1, y1, 'LineWidth', 1.5);
xlabel('Tempo (s)');
ylabel('Resposta');
title('Sistema 1 - Massa-Atrito');
grid on;

subplot(2,1,2);
plot(t1, y2, 'LineWidth', 1.5);
xlabel('Tempo (s)');
ylabel('Resposta');
title('Sistema 2 - Massa-Atrito');
grid on;


%% ============================================================
% 2. CIRCUITO RC E COMPARACAO DE ESCALAS - CAIXA CINZA
% =============================================================

% Dados
R = 2000;
tau = 2.5;

% Calculo da capacitancia
C = tau / R;

% Funcao de transferencia do circuito RC
% G(s) = 1 / (R*C*s + 1)

G_RC = tf(1, [R*C 1]);

disp(' ');
disp('============================================================');
disp('2. CIRCUITO RC');
disp('============================================================');

fprintf('Capacitancia C = %.6f F\n', C);

disp('Funcao de transferencia:');
G_RC

% Resposta ao degrau durante 15 segundos
figure;

step(G_RC, 15);
xlabel('Tempo (s)');
ylabel('Resposta');
title('Resposta ao Degrau - Circuito RC');
grid on;


% Vetor de resistencias
Rteste = 100:100:10000;

% Constante de tempo para cada resistencia
tau_teste = Rteste * C;

% Quatro graficos em uma unica janela
figure;

% 1 - Escala comum
subplot(2,2,1);
plot(Rteste, tau_teste, 'LineWidth', 1.5);
xlabel('Resistencia (Ohm)');
ylabel('Constante de tempo (s)');
title('Escala comum');
grid on;

% 2 - Escala logaritmica no eixo vertical
subplot(2,2,2);
semilogy(Rteste, tau_teste, 'LineWidth', 1.5);
xlabel('Resistencia (Ohm)');
ylabel('Constante de tempo (s)');
title('Escala logaritmica no eixo vertical');
grid on;

% 3 - Escala logaritmica no eixo horizontal
subplot(2,2,3);
semilogx(Rteste, tau_teste, 'LineWidth', 1.5);
xlabel('Resistencia (Ohm)');
ylabel('Constante de tempo (s)');
title('Escala logaritmica no eixo horizontal');
grid on;

% 4 - Escala logaritmica nos dois eixos
subplot(2,2,4);
loglog(Rteste, tau_teste, 'LineWidth', 1.5);
xlabel('Resistencia (Ohm)');
ylabel('Constante de tempo (s)');
title('Escala logaritmica nos dois eixos');
grid on;


%% ============================================================
% 3. IDENTIFICACAO E VISUALIZACAO DE DADOS EXPERIMENTAIS
%    CAIXA PRETA
% =============================================================

% Dados experimentais
t = (0:25)';

u = [0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]';

y = [0.008 0.012 0.006 0.010 0.020 0.382 0.671 0.903 ...
     1.082 1.226 1.335 1.425 1.492 1.547 1.587 1.618 ...
     1.642 1.660 1.674 1.684 1.692 1.698 1.702 1.706 ...
     1.709 1.711]';

% Tempo de amostragem
Ts = 1;

disp(' ');
disp('============================================================');
disp('3. IDENTIFICACAO DE DADOS EXPERIMENTAIS');
disp('============================================================');

% Figura com entrada e saida
figure;

subplot(2,1,1);
plot(t, u, 'LineWidth', 1.5);
xlabel('Tempo (s)');
ylabel('Entrada u');
title('Entrada Experimental');
grid on;

subplot(2,1,2);
plot(t, y, 'LineWidth', 1.5);
xlabel('Tempo (s)');
ylabel('Saida y');
title('Saida Experimental');
grid on;


% Grafico 3D
figure;

plot3(t, u, y, 'LineWidth', 1.5);
xlabel('Tempo (s)');
ylabel('Entrada u');
zlabel('Saida y');
title('Dados Experimentais em 3D');
grid on;


% Criacao do conjunto de dados
dados = iddata(y, u, Ts);

% Estimacao da funcao de transferencia
% 1 polo e 0 zeros
modelo = tfest(dados, 1, 0);

% Mostra a funcao de transferencia estimada
disp('Funcao de transferencia estimada:');
modelo

% Comparacao entre dados experimentais e modelo
figure;
compare(dados, modelo);
grid on;
title('Comparacao - Dados Experimentais e Modelo Identificado');

% Resposta ao degrau durante 25 segundos
figure;
step(modelo, 25);
xlabel('Tempo (s)');
ylabel('Resposta');
title('Resposta ao Degrau - Modelo Identificado');
grid on;


%% ============================================================
% 4. ANALISE DE DIFERENTES CIRCUITOS RC - CAIXA CINZA
% =============================================================

% Dados dos quatro experimentos
R1 = 1000;
tau1 = 1.2;

R2 = 2000;
tau2 = 2.8;

R3 = 3000;
tau3 = 3.9;

R4 = 5000;
tau4 = 7.0;

% Calculo das capacitancias
C1 = tau1 / R1;
C2 = tau2 / R2;
C3 = tau3 / R3;
C4 = tau4 / R4;

disp(' ');
disp('============================================================');
disp('4. ANALISE DE DIFERENTES CIRCUITOS RC');
disp('============================================================');

fprintf('C1 = %.6f F\n', C1);
fprintf('C2 = %.6f F\n', C2);
fprintf('C3 = %.6f F\n', C3);
fprintf('C4 = %.6f F\n', C4);

% Vetores solicitados
R = [R1 R2 R3 R4];
tau = [tau1 tau2 tau3 tau4];
C = [C1 C2 C3 C4];

% Grafico 3D dos quatro experimentos
figure;

plot3(R, tau, C, 'o-', 'LineWidth', 1.5);
xlabel('Resistencia (Ohm)');
ylabel('Constante de tempo (s)');
zlabel('Capacitancia (F)');
title('Analise dos Quatro Experimentos RC');
grid on;


% Experimento 3
G_RC3 = tf(1, [R3*C3 1]);

disp(' ');
disp('Funcao de transferencia - Experimento 3:');
G_RC3

% Resposta ao degrau durante 20 segundos
t4 = 0:0.01:20;
[y4, t4] = step(G_RC3, t4);

figure;

plot(t4, y4, 'LineWidth', 1.5);
xlabel('Tempo (s)');
ylabel('Resposta');
title('Resposta ao Degrau - Experimento 3');
grid on;

% Janela de ampliacao dos primeiros 5 segundos
axes('Position', [0.58 0.52 0.28 0.30]);

plot(t4, y4, 'LineWidth', 1.2);
xlim([0 5]);
grid on;
title('Primeiros 5 segundos');


%% ============================================================
% 5. ANALISE COMPLETA DE TRES TIPOS DE MODELAGEM
% =============================================================

% ------------------------------------------------------------
% SISTEMA A - CAIXA BRANCA
% ------------------------------------------------------------

M_A = 3;
B_A = 5;

% Funcao de transferencia
G_A = tf(1, [M_A B_A]);


% ------------------------------------------------------------
% SISTEMA B - CAIXA CINZA
% ------------------------------------------------------------

R_B = 1500;
tau_B = 3;

% Capacitancia
C_B = tau_B / R_B;

% Funcao de transferencia
G_B = tf(1, [R_B*C_B 1]);


% ------------------------------------------------------------
% SISTEMA C - CAIXA PRETA
% ------------------------------------------------------------

t_C = (0:20)';

u_C = [0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]';

y_C = [0.010 0.006 0.012 0.018 0.408 0.706 0.934 1.103 ...
       1.229 1.322 1.391 1.441 1.479 1.505 1.526 1.540 ...
       1.551 1.558 1.564 1.568 1.571]';

Ts_C = 1;

% Conjunto de dados
dados_C = iddata(y_C, u_C, Ts_C);

% Estimacao com 1 polo e 0 zeros
modelo_C = tfest(dados_C, 1, 0);


% ------------------------------------------------------------
% RESULTADOS NO COMMAND WINDOW
% ------------------------------------------------------------

disp(' ');
disp('============================================================');
disp('5. ANALISE COMPLETA DE TRES TIPOS DE MODELAGEM');
disp('============================================================');

disp('Funcao de transferencia - Sistema A:');
G_A

fprintf('Capacitancia do Sistema B = %.6f F\n', C_B);

disp('Funcao de transferencia - Sistema B:');
G_B

disp('Funcao de transferencia estimada - Sistema C:');
modelo_C


% ------------------------------------------------------------
% FIGURA COM AS TRES RESPOSTAS AO DEGRAU
% ------------------------------------------------------------

figure;

subplot(3,1,1);
step(G_A, 20);
xlabel('Tempo (s)');
ylabel('Resposta');
title('Sistema A - Caixa Branca');
grid on;

subplot(3,1,2);
step(G_B, 20);
xlabel('Tempo (s)');
ylabel('Resposta');
title('Sistema B - Caixa Cinza');
grid on;

subplot(3,1,3);
step(modelo_C, 20);
xlabel('Tempo (s)');
ylabel('Resposta');
title('Sistema C - Caixa Preta');
grid on;


% ------------------------------------------------------------
% ENTRADA E SAIDA DO SISTEMA C
% ------------------------------------------------------------

figure;

subplot(2,1,1);
plot(t_C, u_C, 'LineWidth', 1.5);
xlabel('Tempo (s)');
ylabel('Entrada u');
title('Entrada - Sistema C');
grid on;

subplot(2,1,2);
plot(t_C, y_C, 'LineWidth', 1.5);
xlabel('Tempo (s)');
ylabel('Saida y');
title('Saida - Sistema C');
grid on;


% ------------------------------------------------------------
% COMPARACAO DOS DADOS COM O MODELO DO SISTEMA C
% ------------------------------------------------------------

figure;
compare(dados_C, modelo_C);
grid on;
title('Comparacao - Sistema C');


%% ============================================================
% CLASSIFICACAO DOS SISTEMAS
% ============================================================

% Sistema A - Caixa Branca:
% E caixa branca porque o modelo matematico do sistema e conhecido,
% incluindo a massa M e o coeficiente de atrito B.

% Sistema B - Caixa Cinza:
% E caixa cinza porque parte das informacoes do modelo e conhecida,
% enquanto a constante de tempo foi obtida experimentalmente.

% Sistema C - Caixa Preta:
% E caixa preta porque o modelo do sistema nao e conhecido,
% sendo necessario utilizar dados experimentais para identifica-lo.