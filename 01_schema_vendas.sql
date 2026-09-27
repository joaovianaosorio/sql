-- 1. CRIAÇÃO DO BANCO DE DADOS E TABELAS

CREATE DATABASE IF NOT EXISTS BD_Vendas;
USE BD_Vendas;

-- Tabela Clientes
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(50),
    estado CHAR(2)
);

-- Tabela Pedidos
CREATE TABLE Pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    data_pedido DATE NOT NULL,
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

-- Tabela Produtos
CREATE TABLE Produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    preco DECIMAL(10,2)
);

-- Tabela Itens_Pedido
CREATE TABLE Itens_Pedido (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

-- 2. INSERÇÃO DOS DADOS

INSERT INTO Clientes (nome, cidade, estado) VALUES
('Ana Silva', 'São Paulo', 'SP'),
('Bruno Souza', 'Guarulhos', 'SP'),
('Carla Oliveira', 'Campinas', 'SP'),
('Daniel Santos', 'Rio de Janeiro', 'RJ'),
('Elisa Costa', 'São Paulo', 'SP');

INSERT INTO Pedidos (data_pedido, id_cliente) VALUES
('2026-08-01', 1),
('2026-08-02', 2),
('2026-08-03', 1),
('2026-08-04', 3),
('2026-08-05', 4),
('2026-08-06', 5);

INSERT INTO Produtos (nome_produto, categoria, preco) VALUES
('Notebook', 'Informática', 3500.00),
('Mouse', 'Informática', 80.00),
('Teclado', 'Informática', 150.00),
('Monitor', 'Informática', 900.00),
('Impressora', 'Periféricos', 750.00),
('Webcam', 'Periféricos', 250.00);

INSERT INTO Itens_Pedido (id_pedido, id_produto, quantidade) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(2, 2, 1),
(3, 4, 2),
(3, 6, 1),
(4, 5, 1),
(4, 2, 3),
(5, 1, 1),
(5, 3, 2),
(6, 4, 1),
(6, 6, 2);

-- 3. RESOLUÇÃO DAS QUESTÕES (UTILIZANDO AS 4 TABELAS COM INNER JOIN)

-- Questão 1
-- Quais clientes realizaram pedidos e quais produtos foram comprados por cada cliente?
-- (Nome do cliente, identificação do pedido, nome do produto e quantidade)
SELECT C.nome AS Cliente, P.id_pedido AS ID_Pedido, PR.nome_produto AS Produto, IP.quantidade AS Quantidade
FROM Clientes C
INNER JOIN Pedidos P ON C.id_cliente = P.id_cliente
INNER JOIN Itens_Pedido IP ON P.id_pedido = IP.id_pedido
INNER JOIN Produtos PR ON IP.id_produto = PR.id_produto;


-- Questão 2
-- Mostre o nome do cliente, a data do pedido, o produto comprado e a quantidade adquirida.
SELECT C.nome AS Cliente, P.data_pedido AS Data_Pedido, PR.nome_produto AS Produto, IP.quantidade AS Quantidade
FROM Clientes C
INNER JOIN Pedidos P ON C.id_cliente = P.id_cliente
INNER JOIN Itens_Pedido IP ON P.id_pedido = IP.id_pedido
INNER JOIN Produtos PR ON IP.id_produto = PR.id_produto;


-- Questão 3
-- Quais produtos foram comprados pelos clientes da cidade de São Paulo?
-- (Nome cliente, cidade, identificação do pedido, nome do produto e quantidade)
SELECT C.nome AS Cliente, C.cidade AS Cidade, P.id_pedido AS ID_Pedido, PR.nome_produto AS Produto, IP.quantidade AS Quantidade
FROM Clientes C
INNER JOIN Pedidos P ON C.id_cliente = P.id_cliente
INNER JOIN Itens_Pedido IP ON P.id_pedido = IP.id_pedido
INNER JOIN Produtos PR ON IP.id_produto = PR.id_produto
WHERE C.cidade = 'São Paulo';


-- Questão 4
-- Mostre todos os pedidos realizados, apresentando a identificação do pedido, o cliente, o produto e a categoria do produto.
SELECT P.id_pedido AS ID_Pedido, C.nome AS Cliente, PR.nome_produto AS Produto, PR.categoria AS Categoria
FROM Clientes C
INNER JOIN Pedidos P ON C.id_cliente = P.id_cliente
INNER JOIN Itens_Pedido IP ON P.id_pedido = IP.id_pedido
INNER JOIN Produtos PR ON IP.id_produto = PR.id_produto;


-- Questão 5
-- Quais clientes compraram produtos da categoria Informática? (Explicando o uso do DISTINCT)
/*
Explicação sobre o DISTINCT:
O comando DISTINCT remove as linhas duplicadas do resultado de uma consulta. 
Se um cliente comprou vários produtos da categoria 'Informática' em pedidos diferentes, 
ele apareceria repetidas vezes na listagem. O DISTINCT garante que cada cliente 
apareça apenas uma única vez na resposta.
*/
-- Com o uso do DISTINCT:
SELECT DISTINCT C.nome AS Cliente, C.cidade AS Cidade, PR.categoria AS Categoria
FROM Clientes C
INNER JOIN Pedidos P ON C.id_cliente = P.id_cliente
INNER JOIN Itens_Pedido IP ON P.id_pedido = IP.id_pedido
INNER JOIN Produtos PR ON IP.id_produto = PR.id_produto
WHERE PR.categoria = 'Informática';


-- Questão 6
-- Mostre os clientes que compraram produtos com preço superior a R$ 500,00.
-- (Nome do cliente, identificação do pedido, nome do produto, preço do produto e quantidade)
SELECT C.nome AS Cliente, P.id_pedido AS ID_Pedido, PR.nome_produto AS Produto, PR.preco AS Preço, IP.quantidade AS Quantidade
FROM Clientes C
INNER JOIN Pedidos P ON C.id_cliente = P.id_cliente
INNER JOIN Itens_Pedido IP ON P.id_pedido = IP.id_pedido
INNER JOIN Produtos PR ON IP.id_produto = PR.id_produto
WHERE PR.preco > 500.00;


-- Questão 7
-- Qual foi o valor total de cada item comprado por cada cliente? (Preço × Quantidade)
-- (Nome do cliente, identificação do pedido, nome do produto, preço, quantidade e valor total)
SELECT C.nome AS Cliente, P.id_pedido AS ID_Pedido, PR.nome_produto AS Produto, PR.preco AS Preço, IP.quantidade AS Quantidade, (PR.preco * IP.quantidade) AS Valor_Total_Item
FROM Clientes C
INNER JOIN Pedidos P ON C.id_cliente = P.id_cliente
INNER JOIN Itens_Pedido IP ON P.id_pedido = IP.id_pedido
INNER JOIN Produtos PR ON IP.id_produto = PR.id_produto;


-- Questão 8
-- Qual foi o valor total gasto por cada cliente, considerando todos os seus pedidos?
SELECT C.nome AS Cliente, SUM(PR.preco * IP.quantidade) AS Total_Gasto
FROM Clientes C
INNER JOIN Pedidos P ON C.id_cliente = P.id_cliente
INNER JOIN Itens_Pedido IP ON P.id_pedido = IP.id_pedido
INNER JOIN Produtos PR ON IP.id_produto = PR.id_produto
GROUP BY C.id_cliente, C.nome;


-- Questão 9
-- Quantas unidades de cada produto foram compradas, mostrando também os produtos e os clientes que realizaram as compras?
SELECT PR.id_produto, PR.nome_produto AS Produto, C.id_cliente, C.nome AS Cliente, SUM(IP.quantidade) AS Total_Unidades
FROM Clientes C
INNER JOIN Pedidos P ON C.id_cliente = P.id_cliente
INNER JOIN Itens_Pedido IP ON P.id_pedido = IP.id_pedido
INNER JOIN Produtos PR ON IP.id_produto = PR.id_produto
GROUP BY PR.id_produto, PR.nome_produto, C.id_cliente, C.nome;


-- Questão 10
-- Quais clientes realizaram pedidos no mês de agosto de 2026 e quais produtos compraram?
-- (Nome do cliente, data do pedido, nome do produto e quantidade)
SELECT C.nome AS Cliente, P.data_pedido AS Data_Pedido, PR.nome_produto AS Produto, IP.quantidade AS Quantidade
FROM Clientes C
INNER JOIN Pedidos P ON C.id_cliente = P.id_cliente
INNER JOIN Itens_Pedido IP ON P.id_pedido = IP.id_pedido
INNER JOIN Produtos PR ON IP.id_produto = PR.id_produto
WHERE P.data_pedido BETWEEN '2026-08-01' AND '2026-08-31';


-- Questão 11
-- Mostre o cliente que realizou a maior compra (utilizando LIMIT para restringir os resultados).
SELECT C.nome AS Cliente, SUM(PR.preco * IP.quantidade) AS Total_Gasto
FROM Clientes C
INNER JOIN Pedidos P ON C.id_cliente = P.id_cliente
INNER JOIN Itens_Pedido IP ON P.id_pedido = IP.id_pedido
INNER JOIN Produtos PR ON IP.id_produto = PR.id_produto
GROUP BY C.id_cliente, C.nome
ORDER BY Total_Gasto DESC
LIMIT 1; 