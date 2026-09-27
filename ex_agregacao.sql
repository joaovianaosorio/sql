-- 1. Criação do Banco de Dados e Tabelas
CREATE DATABASE IF NOT EXISTS BD_Agregacao_Exemplo;
USE BD_Agregacao_Exemplo;

CREATE TABLE Produtos (
    id_produto INT PRIMARY KEY,
    nome_produto VARCHAR(50),
    categoria VARCHAR(30),
    preco DECIMAL(10,2),
    estoque INT
);

-- 2. Inserção de Dados
INSERT INTO Produtos (id_produto, nome_produto, categoria, preco, estoque) VALUES
(1, 'Notebook Gamer', 'Informática', 4500.00, 10),
(2, 'Mouse sem Fio', 'Informática', 120.00, 50),
(3, 'Teclado Mecânico', 'Informática', 300.00, 30),
(4, 'Cadeira de Escritório', 'Móveis', 850.00, 15),
(5, 'Mesa para Computador', 'Móveis', 600.00, 8),
(6, 'Monitor Ultrawide', 'Informática', 1500.00, 12);

-- DEMONSTRAÇÃO DAS FUNÇÕES DE AGREGAÇÃO E GROUP BY (2 Exemplos cada)

-- 1. FUNÇÃO SUM (Soma)

-- Exemplo 1: Somar o valor total de todo o estoque (Preço x Estoque) da loja inteira.
SELECT SUM(preco * estoque) AS Valor_Total_Estoque 
FROM Produtos;

-- Exemplo 2 (Com GROUP BY): Somar a quantidade total de itens em estoque agrupados por Categoria.
SELECT categoria, SUM(estoque) AS Total_Estoque_Categoria 
FROM Produtos 
GROUP BY categoria;


-- 2. FUNÇÃO AVG (Média)

-- Exemplo 1: Calcular a média de preço de todos os produtos cadastrados.
SELECT AVG(preco) AS Media_Precos_Geral 
FROM Produtos;

-- Exemplo 2 (Com GROUP BY): Calcular a média de preço dos produtos agrupados por Categoria.
SELECT categoria, AVG(preco) AS Media_Preco_Categoria 
FROM Produtos 
GROUP BY categoria;


-- 3. FUNÇÃO COUNT (Contagem)

-- Exemplo 1: Contar o número total de produtos cadastrados na tabela.
SELECT COUNT(*) AS Total_Produtos 
FROM Produtos;

-- Exemplo 2 (Com GROUP BY): Contar quantos produtos existem em cada Categoria.
SELECT categoria, COUNT(*) AS Qtd_Produtos_Por_Categoria 
FROM Produtos 
GROUP BY categoria;


-- 4. FUNÇÃO MIN (Mínimo)

-- Exemplo 1: Encontrar o menor preço entre todos os produtos.
SELECT MIN(preco) AS Menor_Preco_Geral 
FROM Produtos;

-- Exemplo 2 (Com GROUP BY): Encontrar o menor preço de produto em cada Categoria.
SELECT categoria, MIN(preco) AS Menor_Preco_Categoria 
FROM Produtos 
GROUP BY categoria;


-- 5. FUNÇÃO MAX (Máximo)

-- Exemplo 1: Encontrar o maior preço entre todos os produtos da loja.
SELECT MAX(preco) AS Maior_Preco_Geral 
FROM Produtos;

-- Exemplo 2 (Com GROUP BY): Encontrar o maior preço de produto em cada Categoria.
SELECT categoria, MAX(preco) AS Maior_Preco_Categoria 
FROM Produtos 
GROUP BY categoria;