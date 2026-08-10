
% Relatorio 1 - Aulas 1 e 2

clc;
clear;


%% Exercicio 1 - Analise de tres medicoes

medicao1 = input('Digite a primeira medicao: ');
medicao2 = input('Digite a segunda medicao: ');
medicao3 = input('Digite a terceira medicao: ');

A = [medicao1, medicao2, medicao3];

media = mean(A);
maior = max(A);
menor = min(A);

fprintf('\nMedia: %.2f\n', media);
fprintf('Maior valor: %.2f\n', maior);
fprintf('Menor valor: %.2f\n', menor);

if media >= 8
    disp('Resultado alto')
elseif media >= 5
    disp('Resultado intermediario')
else
    disp('Resultado baixo')
end


%% Exercicio 2 - Processamento de um vetor com for

A = [3 8 2 10 5 7 1 6];

B = zeros(size(A));

for i = 1:length(A)
    if A(i) >= 6
        B(i) = A(i) * 2;
    else
        B(i) = A(i) + 3;
    end
end

disp('Vetor A:')
disp(A)

disp('Vetor B:')
disp(B)

soma = sum(B);
media = mean(B);
maior = max(B);
menor = min(B);

fprintf('Soma de B: %.2f\n', soma);
fprintf('Media de B: %.2f\n', media);
fprintf('Maior valor de B: %.2f\n', maior);
fprintf('Menor valor de B: %.2f\n', menor);


%% Exercicio 3 - Identificacao de numeros pares

A = [14 7 20 9 6 11 18 5];

B = zeros(size(A));
contador = 0;

for i = 1:length(A)
    if rem(A(i), 2) == 0
        B(i) = A(i);
        contador = contador + 1;
    else
        B(i) = 0;
    end
end

disp('Vetor B:')
disp(B)

fprintf('Quantidade de numeros pares: %d\n', contador);


%% Exercicio 4 - Calculadora com menu

valor1 = input('Digite o primeiro valor: ');
valor2 = input('Digite o segundo valor: ');

disp('1 - Soma')
disp('2 - Subtracao')
disp('3 - Multiplicacao')
disp('4 - Divisao')

opcao = input('Escolha uma opcao: ');

switch opcao
    case 1
        resultado = valor1 + valor2;
        fprintf('Resultado: %.2f\n', resultado);

    case 2
        resultado = valor1 - valor2;
        fprintf('Resultado: %.2f\n', resultado);

    case 3
        resultado = valor1 * valor2;
        fprintf('Resultado: %.2f\n', resultado);

    case 4
        if valor2 == 0
            disp('A operacao nao pode ser realizada')
        else
            resultado = valor1 / valor2;
            fprintf('Resultado: %.2f\n', resultado);
        end

    otherwise
        disp('Opcao invalida')
end


%% Exercicio 5 - Acumulador com while

soma = 0;
contador = 0;

while soma <= 4
    valor = rand;
    soma = soma + valor;
    contador = contador + 1;

    fprintf('Valor sorteado: %.4f | Soma: %.4f\n', valor, soma);
end

if contador > 8
    disp('Muitas repeticoes')
else
    disp('Poucas repeticoes')
end

fprintf('Total de repeticoes: %d\n', contador);


%% Exercicio 6 - Processamento de uma matriz

A = [2 7 4 9;
     6 1 8 3];

B = zeros(size(A));

[linhas, colunas] = size(A);

for j = 1:linhas
    for i = 1:colunas
        if A(j,i) > 5
            B(j,i) = A(j,i) * 2;
        else
            B(j,i) = A(j,i) + 5;
        end
    end
end

disp('Matriz A:')
disp(A)

disp('Matriz B:')
disp(B)

disp('Transposta de B:')
disp(B')

disp('Primeira linha de B:')
disp(B(1,:))

disp('Terceira coluna de B:')
disp(B(:,3))


%% Exercicio 7 - Funcao para analisar um vetor

A = [5 12 7 3 9 14];

[soma, media] = analisa_vetor(A);

fprintf('Soma: %.2f\n', soma);
fprintf('Media: %.2f\n', media);

if media >= 8
    disp('Media elevada')
else
    disp('Media abaixo de 8')
end


%% Exercicio 8 - Funcao para transformar uma matriz

A = [1 5 3 8;
     6 2 7 4];

B = zeros(size(A));

B = transforma_matriz(A, B);

disp('Matriz resultante B:')
disp(B)


%% Exercicio 9 - Entrada como texto

valor1 = input('Digite o primeiro valor: ', 's');
valor2 = input('Digite o segundo valor: ', 's');

disp('Primeiro valor digitado:')
disp(valor1)

disp('Segundo valor digitado:')
disp(valor2)

valor1 = str2num(valor1);
valor2 = str2num(valor2);

soma = valor1 + valor2;
multiplicacao = valor1 * valor2;

fprintf('Soma: %.2f\n', soma);
fprintf('Multiplicacao: %.2f\n', multiplicacao);

if soma > 20
    disp('Soma alta')
elseif soma == 20
    disp('Soma igual a 20')
else
    disp('Soma baixa')
end


%% Exercicio 10 - Analise de dados e grafico

dados = [12 18 10 25 15];

soma = sum(dados);
media = mean(dados);
maior = max(dados);
menor = min(dados);

fprintf('Soma: %.2f\n', soma);
fprintf('Media: %.2f\n', media);
fprintf('Maior valor: %.2f\n', maior);
fprintf('Menor valor: %.2f\n', menor);

contador = 0;

for i = 1:length(dados)
    if dados(i) >= media
        contador = contador + 1;
    end
end

fprintf('Valores maiores ou iguais a media: %d\n', contador);

disp('1 - Grafico de barras')
disp('2 - Grafico de pizza')

opcao = input('Escolha uma opcao: ');

switch opcao
    case 1
        bar(dados)
        title('Grafico de barras')

    case 2
        pie3(dados)
        title('Grafico de pizza')

    otherwise
        warning('Nenhum grafico foi criado.')
end

if contador > length(dados) / 2
    disp('Maioria dos valores acima ou igual a media')
else
    disp('Menos da metade dos valores acima ou igual a media')
end


%% Funcoes

function [soma, media] = analisa_vetor(A)

soma = sum(A);
media = mean(A);

end


function B = transforma_matriz(A, B)

[linhas, colunas] = size(A);

for j = 1:linhas
    for i = 1:colunas
        if A(j,i) >= 5
            B(j,i) = A(j,i) * 2 * exp(1);
        else
            B(j,i) = A(j,i) * 2;
        end
    end
end

end


%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
