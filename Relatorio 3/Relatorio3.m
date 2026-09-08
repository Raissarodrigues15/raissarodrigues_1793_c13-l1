%% RELATORIO 3 - SISTEMAS DE PRIMEIRA E SEGUNDA ORDEM
% Sistemas de Controle
% Tempo de subida: criterio de 10% a 90%
% Tempo de acomodacao: tolerancia de 2%

clear;
clc;
close all;

%% 1. IDENTIFICACAO DE UM SISTEMA DE PRIMEIRA ORDEM

K1 = 1.8;
tau1 = 1.2;

% Funcao de transferencia
% G(s) = K/(tau*s + 1)
G1 = tf(K1, [tau1 1]);

% Polo
polos_G1 = pole(G1);

% Informacoes da resposta
info_G1 = stepinfo(G1);

tempo_subida_G1 = info_G1.RiseTime;
tempo_acomodacao_G1 = info_G1.SettlingTime;
ganho_regime_G1 = dcgain(G1);

fprintf('\n==================================================\n');
fprintf('EXERCICIO 1 - SISTEMA DE PRIMEIRA ORDEM\n');
fprintf('==================================================\n');

fprintf('Ganho K = %.4f\n', K1);
fprintf('Constante de tempo tau = %.4f s\n', tau1);

fprintf('\nFuncao de transferencia:\n');
disp(G1);

fprintf('Polo = %.4f\n', polos_G1);
fprintf('Tempo de subida = %.4f s\n', tempo_subida_G1);
fprintf('Tempo de acomodacao = %.4f s\n', tempo_acomodacao_G1);
fprintf('Ganho em regime permanente = %.4f\n', ganho_regime_G1);

% Resposta ao degrau unitario durante 8 segundos
t = linspace(0,8,1000);

[y1,t1] = step(G1,t);

figure;
plot(t1,y1,'LineWidth',1.5);
grid on;

title('Exercicio 1 - Resposta ao degrau unitario');
xlabel('Tempo (s)');
ylabel('Saida');

legend('G(s) = 1,8/(1,2s + 1)', ...
       'Location','southeast');


% Degrau de amplitude 2,5

amplitude = 2.5;

[y1_amp,t1_amp] = step(G1,t);

y1_amp = amplitude*y1_amp;

valor_final_amp = dcgain(G1)*amplitude;

fprintf('\n--- Degrau de amplitude 2,5 ---\n');
fprintf('Novo valor final = %.4f\n',valor_final_amp);

figure;

plot(t1_amp,y1_amp,'LineWidth',1.5);
grid on;

title('Exercicio 1 - Degrau de amplitude 2,5');
xlabel('Tempo (s)');
ylabel('Saida');

legend('Resposta','Location','southeast');


% Comentarios:
% A constante de tempo determina a rapidez da resposta.
% Quanto menor a constante de tempo, mais rapida e a resposta.
%
% Quanto mais a esquerda estiver o polo no plano-s,
% mais rapida tende a ser a resposta do sistema.


%% 2. ESCOLHA ENTRE TRES SISTEMAS DE SEGUNDA ORDEM

GA = tf(25,[1 3 25]);

GB = tf(25,[1 10 25]);

GC = tf(25,[1 16 25]);

sistemas2 = {GA,GB,GC};

nomes2 = {'Sistema A','Sistema B','Sistema C'};

fprintf('\n==================================================\n');
fprintf('EXERCICIO 2 - TRES SISTEMAS DE SEGUNDA ORDEM\n');
fprintf('==================================================\n');

for i = 1:3

    G = sistemas2{i};

    [wn,zeta,~] = damp(G);

    info = stepinfo(G);

    polos = pole(G);

    fprintf('\n%s\n',nomes2{i});

    fprintf('Funcao de transferencia:\n');
    disp(G);

    fprintf('Polos:\n');
    disp(polos);

    fprintf('Frequencia natural wn = %.4f rad/s\n',wn(1));

    fprintf('Coeficiente de amortecimento zeta = %.4f\n',zeta(1));

    if zeta(1) < 1

        tipo = 'Subamortecido';

    elseif abs(zeta(1)-1) < 1e-10

        tipo = 'Criticamente amortecido';

    else

        tipo = 'Superamortecido';

    end

    fprintf('Tipo de resposta = %s\n',tipo);

    fprintf('Ganho em regime permanente = %.4f\n',dcgain(G));

    fprintf('Valor final = %.4f\n',info.SteadyStateValue);

    fprintf('Sobressinal = %.4f %%\n',info.Overshoot);

    fprintf('Tempo de subida = %.4f s\n',info.RiseTime);

    fprintf('Tempo de acomodacao = %.4f s\n',info.SettlingTime);

end


% Resposta dos tres sistemas

figure;

hold on;

for i = 1:3

    [y,tt] = step(sistemas2{i},t);

    plot(tt,y,'LineWidth',1.5);

end

grid on;

title('Exercicio 2 - Resposta ao degrau');

xlabel('Tempo (s)');
ylabel('Saida');

legend('Sistema A','Sistema B','Sistema C', ...
       'Location','southeast');

hold off;


% Posicao dos polos

figure;

hold on;

for i = 1:3

    p = pole(sistemas2{i});

    plot(real(p),imag(p),'x', ...
         'MarkerSize',10, ...
         'LineWidth',2);

end

xline(0,'--');
yline(0,'--');

grid on;

title('Exercicio 2 - Posicao dos polos');

xlabel('Parte real');
ylabel('Parte imaginaria');

legend('Sistema A','Sistema B','Sistema C', ...
       'Location','best');

hold off;


% Comentario:
% O Sistema B e o mais adequado porque nao apresenta sobressinal
% e possui resposta mais rapida que o Sistema C.
%
% Portanto, entre os sistemas sem sobressinal, o Sistema B
% apresenta o melhor comportamento temporal.


%% 3. AVALIACAO DE DESEMPENHO DE DOIS SISTEMAS

G_1 = tf(16,[1 2.8 16]);

G_2 = tf(25,[1 6.5 25]);

sistemas3 = {G_1,G_2};

nomes3 = {'Sistema 1','Sistema 2'};

fprintf('\n==================================================\n');
fprintf('EXERCICIO 3 - AVALIACAO DOS SISTEMAS\n');
fprintf('==================================================\n');

for i = 1:2

    G = sistemas3{i};

    info = stepinfo(G);

    [wn,zeta,~] = damp(G);

    polos = pole(G);

    % Resposta

    [y_temp,t_temp] = step(G,t);

    valor_final = dcgain(G);

    % Tempo para atingir 50%

    indice50 = find(y_temp >= 0.5*valor_final,1,'first');

    if ~isempty(indice50)

        if indice50 > 1

            t50 = interp1( ...
                y_temp(indice50-1:indice50), ...
                t_temp(indice50-1:indice50), ...
                0.5*valor_final);

        else

            t50 = t_temp(indice50);

        end

    else

        t50 = NaN;

    end


    fprintf('\n%s\n',nomes3{i});

    fprintf('Funcao de transferencia:\n');
    disp(G);

    fprintf('Valor final = %.4f\n',valor_final);

    fprintf('Tempo para atingir 50%% = %.4f s\n',t50);

    fprintf('Tempo de subida = %.4f s\n',info.RiseTime);

    fprintf('Tempo de pico = %.4f s\n',info.PeakTime);

    fprintf('Valor do primeiro pico = %.4f\n',info.Peak);

    fprintf('Sobressinal = %.4f %%\n',info.Overshoot);

    fprintf('Tempo de acomodacao = %.4f s\n',info.SettlingTime);

    fprintf('Frequencia natural = %.4f rad/s\n',wn(1));

    fprintf('Coeficiente de amortecimento = %.4f\n',zeta(1));

    fprintf('Polos:\n');
    disp(polos);

end


% Comparacao dos dois sistemas

figure;

hold on;

for i = 1:2

    [y,tt] = step(sistemas3{i},t);

    plot(tt,y,'LineWidth',1.5);

end

grid on;

title('Exercicio 3 - Comparacao das respostas');

xlabel('Tempo (s)');
ylabel('Saida');

legend('Sistema 1','Sistema 2', ...
       'Location','southeast');

hold off;


% Verificacao dos requisitos

info1 = stepinfo(G_1);
info2 = stepinfo(G_2);

atende1 = ...
    (info1.Overshoot < 10) && ...
    (info1.SettlingTime < 1.5);

atende2 = ...
    (info2.Overshoot < 10) && ...
    (info2.SettlingTime < 1.5);


fprintf('\n--- VERIFICACAO DOS REQUISITOS ---\n');

fprintf('Sistema 1 atende? %s\n',ternario(atende1));

fprintf('Sistema 2 atende? %s\n',ternario(atende2));


% Comentarios:
% O Sistema 1 possui menor amortecimento e, por isso,
% apresenta maior oscilacao e maior sobressinal.
%
% O Sistema 2 atende aos requisitos de sobressinal inferior a 10%%
% e tempo de acomodacao inferior a 1,5 s.


%% 4. SELECAO DE PARAMETROS

zeta_cfg = [0.35 0.55 0.70 0.80];

wn_cfg = [6 5 4 3.2];

nomes_cfg = ...
    {'Configuracao A', ...
     'Configuracao B', ...
     'Configuracao C', ...
     'Configuracao D'};


sistemas4 = cell(1,4);

fprintf('\n==================================================\n');
fprintf('EXERCICIO 4 - SELECAO DE PARAMETROS\n');
fprintf('==================================================\n');


for i = 1:4

    zeta = zeta_cfg(i);

    wn = wn_cfg(i);


    % Forma padrao:
    %
    % G(s) = wn^2 /
    %        (s^2 + 2*zeta*wn*s + wn^2)

    sistemas4{i} = ...
        tf(wn^2,[1 2*zeta*wn wn^2]);


    G = sistemas4{i};

    info = stepinfo(G);

    polos = pole(G);


    fprintf('\n%s\n',nomes_cfg{i});

    fprintf('zeta = %.4f\n',zeta);

    fprintf('wn = %.4f rad/s\n',wn);

    fprintf('Funcao de transferencia:\n');
    disp(G);

    fprintf('Polos:\n');
    disp(polos);

    fprintf('Sobressinal = %.4f %%\n',info.Overshoot);

    fprintf('Tempo de subida = %.4f s\n',info.RiseTime);

    fprintf('Tempo de pico = %.4f s\n',info.PeakTime);

    fprintf('Tempo de acomodacao = %.4f s\n',info.SettlingTime);

    fprintf('Valor final = %.4f\n',info.SteadyStateValue);

end


% Resposta dos quatro sistemas

figure;

hold on;

for i = 1:4

    [y,tt] = step(sistemas4{i},t);

    plot(tt,y,'LineWidth',1.5);

end

grid on;

title('Exercicio 4 - Resposta dos quatro sistemas');

xlabel('Tempo (s)');
ylabel('Saida');

legend('Configuracao A', ...
       'Configuracao B', ...
       'Configuracao C', ...
       'Configuracao D', ...
       'Location','southeast');

hold off;


% Verificacao dos requisitos

validas4 = false(1,4);

fprintf('\n--- VERIFICACAO DOS REQUISITOS ---\n');


for i = 1:4

    info = stepinfo(sistemas4{i});

    validas4(i) = ...
        (info.Overshoot < 10) && ...
        (info.SettlingTime < 1.5);

    fprintf('%s atende? %s\n', ...
        nomes_cfg{i}, ...
        ternario(validas4(i)));

end


% Escolha da configuracao

tempos_subida = inf(1,4);


for i = 1:4

    if validas4(i)

        tempos_subida(i) = ...
            stepinfo(sistemas4{i}).RiseTime;

    end

end


[menor_tr,indice_melhor4] = ...
    min(tempos_subida);


fprintf('\nConfiguracao escolhida: %s\n', ...
    nomes_cfg{indice_melhor4});

fprintf('Menor tempo de subida = %.4f s\n', ...
    menor_tr);


% Comentarios:
% A configuracao C apresenta um bom compromisso entre
% sobressinal e rapidez.
%
% A escolha considera somente as configuracoes que atendem
% simultaneamente aos limites especificados.


%% 5. COMPARACAO ENTRE PRIMEIRA E SEGUNDA ORDEM

GA5 = tf(2,[1.2 1]);

GB5 = tf(32,[1 5.6 16]);


fprintf('\n==================================================\n');
fprintf('EXERCICIO 5 - PRIMEIRA ORDEM X SEGUNDA ORDEM\n');
fprintf('==================================================\n');


%% EQUIPAMENTO A

infoA5 = stepinfo(GA5);

polosA5 = pole(GA5);


fprintf('\nEQUIPAMENTO A - PRIMEIRA ORDEM\n');

fprintf('Funcao de transferencia:\n');
disp(GA5);

fprintf('Polo = %.4f\n',polosA5);

fprintf('Ganho em regime permanente = %.4f\n',dcgain(GA5));

fprintf('Valor final = %.4f\n', ...
    infoA5.SteadyStateValue);

fprintf('Tempo de subida = %.4f s\n', ...
    infoA5.RiseTime);

fprintf('Tempo de acomodacao = %.4f s\n', ...
    infoA5.SettlingTime);


%% EQUIPAMENTO B

infoB5 = stepinfo(GB5);

[wnB5,zetaB5,~] = damp(GB5);

polosB5 = pole(GB5);


fprintf('\nEQUIPAMENTO B - SEGUNDA ORDEM\n');

fprintf('Funcao de transferencia:\n');
disp(GB5);

fprintf('Polos:\n');
disp(polosB5);

fprintf('Ganho em regime permanente = %.4f\n', ...
    dcgain(GB5));

fprintf('Valor final = %.4f\n', ...
    infoB5.SteadyStateValue);

fprintf('Tempo de subida = %.4f s\n', ...
    infoB5.RiseTime);

fprintf('Tempo de acomodacao = %.4f s\n', ...
    infoB5.SettlingTime);

fprintf('Frequencia natural = %.4f rad/s\n', ...
    wnB5(1));

fprintf('Coeficiente de amortecimento = %.4f\n', ...
    zetaB5(1));

fprintf('Tempo de pico = %.4f s\n', ...
    infoB5.PeakTime);

fprintf('Valor do primeiro pico = %.4f\n', ...
    infoB5.Peak);

fprintf('Sobressinal = %.4f %%\n', ...
    infoB5.Overshoot);


%% COMPARACAO PARA DEGRAU UNITARIO

figure;

hold on;

[yA5,tA5] = step(GA5,t);

[yB5,tB5] = step(GB5,t);

plot(tA5,yA5,'LineWidth',1.5);

plot(tB5,yB5,'LineWidth',1.5);

grid on;

title('Exercicio 5 - Degrau unitario');

xlabel('Tempo (s)');
ylabel('Saida');

legend('Equipamento A - 1a ordem', ...
       'Equipamento B - 2a ordem', ...
       'Location','southeast');

hold off;


%% DEGRAU DE AMPLITUDE 1,5

amplitude5 = 1.5;


[yA5_amp,tA5_amp] = step(GA5,t);

[yB5_amp,tB5_amp] = step(GB5,t);


yA5_amp = amplitude5*yA5_amp;

yB5_amp = amplitude5*yB5_amp;


valor_final_A5 = ...
    dcgain(GA5)*amplitude5;

valor_final_B5 = ...
    dcgain(GB5)*amplitude5;


fprintf('\n--- DEGRAU DE AMPLITUDE 1,5 ---\n');

fprintf('Equipamento A - valor final = %.4f\n', ...
    valor_final_A5);

fprintf('Equipamento B - valor final = %.4f\n', ...
    valor_final_B5);


figure;

hold on;

plot(tA5_amp,yA5_amp,'LineWidth',1.5);

plot(tB5_amp,yB5_amp,'LineWidth',1.5);

grid on;

title('Exercicio 5 - Degrau de amplitude 1,5');

xlabel('Tempo (s)');
ylabel('Saida');

legend('Equipamento A - 1a ordem', ...
       'Equipamento B - 2a ordem', ...
       'Location','southeast');

hold off;


% Comentarios:
% O Equipamento A possui resposta de primeira ordem e nao apresenta
% sobressinal.
%
% O Equipamento B possui resposta de segunda ordem e apresenta
% sobressinal devido ao seu coeficiente de amortecimento.
%
% Os dois equipamentos possuem o mesmo ganho em regime permanente,
% portanto atingem o mesmo valor final para a mesma entrada.


fprintf('\n==================================================\n');
fprintf('FIM DO RELATORIO 3\n');
fprintf('==================================================\n');


%% FUNCAO AUXILIAR

function texto = ternario(condicao)

    if condicao

        texto = 'SIM';

    else

        texto = 'NAO';

    end

end