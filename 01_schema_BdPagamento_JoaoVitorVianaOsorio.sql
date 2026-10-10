-- ============================================================
-- Atividade - Criação de Tabelas e Consultas SQL
-- Aluno: João Vitor Viana Osório
-- ============================================================

-- 1. Criar o banco de dados com o nome 'BdPagamento_JoaoVitorVianaOsorio'
CREATE DATABASE BdPagamento_JoaoVitorVianaOsorio;

-- 2. Abrir o banco de dados criado
USE BdPagamento_JoaoVitorVianaOsorio;

-- 3. Criar a tabela Forma_Pagto
CREATE TABLE Forma_Pagto (
    FormaPagto VARCHAR(1),
    Descricao_Pagto VARCHAR(20),
    PRIMARY KEY (FormaPagto)
);

-- 4. Inserir os tipos de pagamento
INSERT INTO Forma_Pagto (FormaPagto, Descricao_Pagto) VALUES ('1', 'A vista Dinheiro');
INSERT INTO Forma_Pagto (FormaPagto, Descricao_Pagto) VALUES ('2', 'Débito no Cartão');
INSERT INTO Forma_Pagto (FormaPagto, Descricao_Pagto) VALUES ('3', 'Crédito no Cartão');

-- 5. Criar a tabela Compras
CREATE TABLE Compras (
    cod_cliente VARCHAR(4),
    Forma_Pagto VARCHAR(1),
    comprador VARCHAR(30),
    Data_Compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    Vl_compra DECIMAL(13,2),
    CONSTRAINT FK_Cliente_Compra FOREIGN KEY (Forma_Pagto) REFERENCES Forma_Pagto(FormaPagto)
);

-- 6. Inserir os registros na tabela Compras
INSERT INTO Compras VALUES ('C01','1','Ana Maria da Cruz', STR_TO_DATE('23/03/2026','%d/%m/%Y'), 500);
INSERT INTO Compras VALUES ('C01','2','Ana Maria da Cruz', STR_TO_DATE('24/03/2026','%d/%m/%Y'), 1500);
INSERT INTO Compras VALUES ('C01','3','Ana Maria da Cruz', STR_TO_DATE('20/02/2026','%d/%m/%Y'), 2500);
INSERT INTO Compras VALUES ('C01','3','Ana Maria da Cruz', STR_TO_DATE('25/01/2026','%d/%m/%Y'), 500);

INSERT INTO Compras VALUES ('C02','1','Maria de Sousa', STR_TO_DATE('23/02/2026','%d/%m/%Y'), 7500);
INSERT INTO Compras VALUES ('C02','1','Maria de Sousa', STR_TO_DATE('03/05/2026','%d/%m/%Y'), 3500);
INSERT INTO Compras VALUES ('C02','2','Maria de Sousa', STR_TO_DATE('03/05/2026','%d/%m/%Y'), 5500);
INSERT INTO Compras VALUES ('C02','2','Maria de Sousa', STR_TO_DATE('05/03/2026','%d/%m/%Y'), 6500);
INSERT INTO Compras VALUES ('C02','2','Maria de Sousa', STR_TO_DATE('23/02/2026','%d/%m/%Y'), 7500);

INSERT INTO Compras VALUES ('C03','1','Amelia da Paz', STR_TO_DATE('01/02/2026','%d/%m/%Y'), 4500);
INSERT INTO Compras VALUES ('C03','1','Amelia da Paz', STR_TO_DATE('02/02/2026','%d/%m/%Y'), 600);
INSERT INTO Compras VALUES ('C03','1','Amelia da Paz', STR_TO_DATE('21/03/2026','%d/%m/%Y'), 780);
INSERT INTO Compras VALUES ('C03','2','Amelia da Paz', STR_TO_DATE('04/04/2026','%d/%m/%Y'), 1500);
INSERT INTO Compras VALUES ('C03','2','Amelia da Paz', STR_TO_DATE('23/04/2026','%d/%m/%Y'), 3500);
INSERT INTO Compras VALUES ('C03','3','Amelia da Paz', STR_TO_DATE('25/04/2026','%d/%m/%Y'), 7500);
INSERT INTO Compras VALUES ('C03','3','Amelia da Paz', STR_TO_DATE('27/04/2026','%d/%m/%Y'), 5500);
INSERT INTO Compras VALUES ('C03','3','Amelia da Paz', STR_TO_DATE('30/01/2026','%d/%m/%Y'), 8500);

INSERT INTO Compras VALUES ('C04','2','Americo Antonio', STR_TO_DATE('03/01/2026','%d/%m/%Y'), 12500);
INSERT INTO Compras VALUES ('C04','2','Americo Antonio', STR_TO_DATE('23/02/2026','%d/%m/%Y'), 1500);
INSERT INTO Compras VALUES ('C04','2','Americo Antonio', STR_TO_DATE('25/02/2026','%d/%m/%Y'), 15500);
INSERT INTO Compras VALUES ('C04','3','Americo Antonio', STR_TO_DATE('26/02/2026','%d/%m/%Y'), 22500);
INSERT INTO Compras VALUES ('C04','3','Americo Antonio', STR_TO_DATE('23/03/2026','%d/%m/%Y'), 32500);
INSERT INTO Compras VALUES ('C04','3','Americo Antonio', STR_TO_DATE('30/03/2026','%d/%m/%Y'), 25000);
INSERT INTO Compras VALUES ('C04','3','Americo Antonio', STR_TO_DATE('30/03/2026','%d/%m/%Y'), 500);
INSERT INTO Compras VALUES ('C04','1','Americo Antonio', STR_TO_DATE('30/03/2026','%d/%m/%Y'), 4500);
INSERT INTO Compras VALUES ('C04','1','Americo Antonio', STR_TO_DATE('04/04/2026','%d/%m/%Y'), 2500);
INSERT INTO Compras VALUES ('C04','2','Americo Antonio', STR_TO_DATE('30/04/2026','%d/%m/%Y'), 7500);

INSERT INTO Compras VALUES ('C05','3','Elizabeth Mangaduba', STR_TO_DATE('30/03/2026','%d/%m/%Y'), 8500);
INSERT INTO Compras VALUES ('C05','3','Elizabeth Mangaduba', STR_TO_DATE('05/04/2026','%d/%m/%Y'), 3500);

INSERT INTO Compras VALUES ('C06','1','Mario Brosser', STR_TO_DATE('23/03/2026','%d/%m/%Y'), 8900);
INSERT INTO Compras VALUES ('C06','2','Mario Brosser', STR_TO_DATE('05/04/2026','%d/%m/%Y'), 15500);
INSERT INTO Compras VALUES ('C06','1','Mario Brosser', STR_TO_DATE('30/04/2026','%d/%m/%Y'), 10500);

INSERT INTO Compras VALUES ('C07','1','Carlos Magdo de Souza', STR_TO_DATE('23/02/2026','%d/%m/%Y'), 7500);
INSERT INTO Compras VALUES ('C07','2','Carlos Magdo de Souza', STR_TO_DATE('26/02/2026','%d/%m/%Y'), 890);
INSERT INTO Compras VALUES ('C07','3','Carlos Magdo de Souza', STR_TO_DATE('27/02/2026','%d/%m/%Y'), 980);
INSERT INTO Compras VALUES ('C07','2','Carlos Magdo de Souza', STR_TO_DATE('28/02/2026','%d/%m/%Y'), 7500);
INSERT INTO Compras VALUES ('C07','2','Carlos Magdo de Souza', STR_TO_DATE('30/03/2026','%d/%m/%Y'), 4500);
INSERT INTO Compras VALUES ('C07','1','Carlos Magdo de Souza', STR_TO_DATE('30/04/2026','%d/%m/%Y'), 2500);

INSERT INTO Compras VALUES ('C08','1','Bianca Souza', STR_TO_DATE('23/02/2026','%d/%m/%Y'), 6500);
INSERT INTO Compras VALUES ('C08','2','Bianca Souza', STR_TO_DATE('01/04/2026','%d/%m/%Y'), 500);
INSERT INTO Compras VALUES ('C08','3','Bianca Souza', STR_TO_DATE('05/04/2026','%d/%m/%Y'), 9500);
INSERT INTO Compras VALUES ('C08','3','Bianca Souza', STR_TO_DATE('09/04/2026','%d/%m/%Y'), 15500);

INSERT INTO Compras VALUES ('C09','1','Maria Silva e Sousa', STR_TO_DATE('23/01/2026','%d/%m/%Y'), 7500);
INSERT INTO Compras VALUES ('C09','1','Maria Silva e Sousa', STR_TO_DATE('03/03/2026','%d/%m/%Y'), 17500);
INSERT INTO Compras VALUES ('C09','1','Maria Silva e Sousa', STR_TO_DATE('04/03/2026','%d/%m/%Y'), 37500);
INSERT INTO Compras VALUES ('C09','1','Maria Silva e Sousa', STR_TO_DATE('13/04/2026','%d/%m/%Y'), 550);
INSERT INTO Compras VALUES ('C09','1','Maria Silva e Sousa', STR_TO_DATE('23/04/2026','%d/%m/%Y'), 8500);

INSERT INTO Compras VALUES ('C10','1','Amalia Suzete da Costa', STR_TO_DATE('03/01/2026','%d/%m/%Y'), 2500);

INSERT INTO Compras VALUES ('C11','1','Maria Catarina da silva', STR_TO_DATE('13/02/2026','%d/%m/%Y'), 3500);

INSERT INTO Compras VALUES ('C12','3','Catarina do Branco', STR_TO_DATE('17/04/2026','%d/%m/%Y'), 2500);

INSERT INTO Compras VALUES ('C13','3','Juca Xaves', STR_TO_DATE('13/01/2026','%d/%m/%Y'), 3700);
INSERT INTO Compras VALUES ('C13','3','Juca Xaves', STR_TO_DATE('23/04/2026','%d/%m/%Y'), 3700);

INSERT INTO Compras VALUES ('C14','1','Mariano Chaves', STR_TO_DATE('30/04/2026','%d/%m/%Y'), 3700);
INSERT INTO Compras VALUES ('C14','1','Mariano Chaves', STR_TO_DATE('03/05/2026','%d/%m/%Y'), 3700);


-- ============================================================
-- RESOLUÇÃO DAS QUESTÕES
-- ============================================================

-- 1) Selecionar o código, nome, data da compra, descrição do pagto e valor da compra dos com valores de Compras de R$ 3000.00 a R$ 5500.00
-- Em ordem crescente de nome:
SELECT c.cod_cliente, c.comprador, f.Descricao_Pagto, c.Vl_compra 
FROM Compras c
INNER JOIN Forma_Pagto f ON c.Forma_Pagto = f.FormaPagto 
WHERE c.Vl_compra BETWEEN 3000.00 AND 5500.00 
ORDER BY c.comprador ASC; 

-- Em ordem crescente de código de cliente:
SELECT c.cod_cliente, c.comprador, f.Descricao_Pagto, c.Vl_compra 
FROM Compras c
INNER JOIN Forma_Pagto f ON c.Forma_Pagto = f.FormaPagto 
WHERE c.Vl_compra BETWEEN 3000.00 AND 5500.00 
ORDER BY c.cod_cliente ASC; 


-- 2) Selecionar o código, nome, data da compra, descrição do pagto e valor da compra os registros com valores de Compras entre R$ 6000.00 a R$ 15000.00 em ordem crescente de valores de compra
SELECT c.cod_cliente, c.comprador, c.Data_Compra, f.Descricao_Pagto, c.Vl_compra
FROM Compras c
INNER JOIN Forma_Pagto f ON c.Forma_Pagto = f.FormaPagto
WHERE c.Vl_compra BETWEEN 6000.00 AND 15000.00
ORDER BY c.Vl_compra ASC;


-- 3) Selecionar os registros com Compras a "vista Dinheiro"
SELECT c.*, f.Descricao_Pagto
FROM Compras c
INNER JOIN Forma_Pagto f ON c.Forma_Pagto = f.FormaPagto
WHERE f.Descricao_Pagto = 'A vista Dinheiro';


-- 4) Selecionar os registros das Compras a "vista dinheiro" e a "Débito no Cartão"
SELECT c.*, f.Descricao_Pagto
FROM Compras c
INNER JOIN Forma_Pagto f ON c.Forma_Pagto = f.FormaPagto
WHERE f.Descricao_Pagto IN ('A vista Dinheiro', 'Débito no Cartão');


-- 5) Selecionar Total de Compra, descrição do pagto agrupando por tipo de pagto
SELECT f.Descricao_Pagto, SUM(c.Vl_compra) AS Total_Compra
FROM Compras c
INNER JOIN Forma_Pagto f ON c.Forma_Pagto = f.FormaPagto
GROUP BY f.Descricao_Pagto;


-- 6) Selecionar todos os dados dos compradores cujo nome iniciam com 'A'
SELECT DISTINCT cod_cliente, comprador
FROM Compras
WHERE comprador LIKE 'A%';


-- 7) Selecionar todos os dados dos compradores cujo nome termiman com 'A' em ordem descrecente
SELECT DISTINCT cod_cliente, comprador
FROM Compras
WHERE comprador LIKE '%a'
ORDER BY comprador DESC;


-- 8) Selecionar todos os dados dos compradores cujo nome começam com 'Am' em ordem descrecente de compras
SELECT c.*
FROM Compras c
WHERE c.comprador LIKE 'Am%'
ORDER BY c.Vl_compra DESC;


-- 9) Selecionar todos os dados dos compradores cujo nome começam com 'Am' tenham qualquer caracter na 3ª posição e l na 4ª posição
SELECT DISTINCT cod_cliente, comprador
FROM Compras
WHERE comprador LIKE 'Am_l%';


-- 10) Selecionar todos os dados dos compradores que tenham a letra 'D' no nome (em qualquer posição)
SELECT DISTINCT cod_cliente, comprador
FROM Compras
WHERE comprador LIKE '%D%' OR comprador LIKE '%d%';


-- 11) Selecionar todos os dados dos compradores que tenham a inicam com 'A' OU 'E' em ordem alfabética
SELECT DISTINCT cod_cliente, comprador
FROM Compras
WHERE comprador LIKE 'A%' OR comprador LIKE 'E%'
ORDER BY comprador ASC;


-- 12) Selecionar todos os dados dos compradores que tenham a inicam com 'A', 'B', 'C' ,'D' OU 'E'
SELECT DISTINCT cod_cliente, comprador
FROM Compras
WHERE comprador REGEXP '^[A-Ea-e]';


-- 13) Selecionar todos os dados dos compradores que tenham a inicam com 'A','C',OU 'E' e tenhan compras acima de R$ 5000.00
SELECT *
FROM Compras
WHERE (comprador LIKE 'A%' OR comprador LIKE 'C%' OR comprador LIKE 'E%')
  AND Vl_compra > 5000.00;


-- 14) Selecionar a quantidade de compras
SELECT COUNT(*) AS Quantidade_Total_Compras
FROM Compras;


-- 15) Selecionar o total das compras
SELECT SUM(Vl_compra) AS Total_Compras
FROM Compras;


-- 16) Selecionar o valor da maior compra
SELECT MAX(Vl_compra) AS Maior_Compra
FROM Compras;


-- 17) Selecionar o valor da menor compra
SELECT MIN(Vl_compra) AS Menor_Compra
FROM Compras;


-- 18) Selecionar a médias das compra
SELECT AVG(Vl_compra) AS Media_Compras
FROM Compras;


-- 19) Selecionar o valor da maior compra do cliente 'C02'
SELECT MAX(Vl_compra) AS Maior_Compra_C02
FROM Compras
WHERE cod_cliente = 'C02';


-- 20) Selecionar o codigo e valor da maior compra compra de cada cliente
SELECT cod_cliente, MAX(Vl_compra) AS Maior_Compra
FROM Compras
GROUP BY cod_cliente;


-- 21) Selecionar o codigom nome e valor da maior compra compra de cada cliente
SELECT cod_cliente, comprador, MAX(Vl_compra) AS Maior_Compra
FROM Compras
GROUP BY cod_cliente, comprador;


-- 22) Selecionar o codigo, nome, quantidade de compras e total de compras de cada cliente em ordem crescente de comprador
SELECT cod_cliente, comprador, COUNT(*) AS Qtd_Compras, SUM(Vl_compra) AS Total_Compras
FROM Compras
GROUP BY cod_cliente, comprador
ORDER BY comprador ASC;


-- 23) Selecionar o codigo, nome, quantidade , maior , menor , total e média de compras de cada cliente em ordem crescente de codigo do comprador
SELECT cod_cliente, 
       comprador, 
       COUNT(*) AS Qtd_Compras, 
       MAX(Vl_compra) AS Maior_Compra, 
       MIN(Vl_compra) AS Menor_Compra, 
       SUM(Vl_compra) AS Total_Compras, 
       AVG(Vl_compra) AS Media_Compras
FROM Compras
GROUP BY cod_cliente, comprador
ORDER BY cod_cliente ASC;


-- 24) Selecionar o tipo e total de compras por tipo de compra
SELECT Forma_Pagto, SUM(Vl_compra) AS Total_Compras
FROM Compras
GROUP BY Forma_Pagto;


-- 25) Selecionar o tipo, descrição de compras e total de compras por tipo de compra do comprador 'c03'
SELECT c.Forma_Pagto, f.Descricao_Pagto, SUM(c.Vl_compra) AS Total_Compras
FROM Compras c
INNER JOIN Forma_Pagto f ON c.Forma_Pagto = f.FormaPagto
WHERE LOWER(c.cod_cliente) = 'c03'
GROUP BY c.Forma_Pagto, f.Descricao_Pagto;


-- 26) Selecionar o tipo, descrição da compra e total de compras para as compras com cartão (débito e crédito)
SELECT c.Forma_Pagto, f.Descricao_Pagto, SUM(c.Vl_compra) AS Total_Compras
FROM Compras c
INNER JOIN Forma_Pagto f ON c.Forma_Pagto = f.FormaPagto
WHERE c.Forma_Pagto IN ('2', '3')
GROUP BY c.Forma_Pagto, f.Descricao_Pagto;


-- 26.5) Selecionar a quantidade de compras e Total de compras a Débito no cartão
SELECT COUNT(*) AS Qtd_Compras, SUM(Vl_compra) AS Total_Compras
FROM Compras
WHERE Forma_Pagto = '2';


-- 27) Selecionar a quantidade de clientes e Total de compras que compraram a crédito no cartão
SELECT COUNT(DISTINCT cod_cliente) AS Qtd_Clientes, SUM(Vl_compra) AS Total_Compras
FROM Compras
WHERE Forma_Pagto = '3';


-- 28) Selecionar a quantidade de compras, media e total de valores das compras crédito no cartão por cliente
SELECT cod_cliente, 
       comprador, 
       COUNT(*) AS Qtd_Compras, 
       AVG(Vl_compra) AS Media_Compras, 
       SUM(Vl_compra) AS Total_Compras
FROM Compras
WHERE Forma_Pagto = '3'
GROUP BY cod_cliente, comprador;


-- 29) Selecionar a maior e a menor compra de cada cliente
SELECT comprador, MAX(Vl_compra) AS Maior_Compra, MIN(Vl_compra) AS Menor_Compra
FROM Compras
GROUP BY comprador;


-- 30) Selecionar o código, maior e a menor compra de cada cliente
SELECT cod_cliente, MAX(Vl_compra) AS Maior_Compra, MIN(Vl_compra) AS Menor_Compra
FROM Compras
GROUP BY cod_cliente;


-- 31) Selecionar todos os dados dos compradores com sobrenome souza ou sousa
SELECT *
FROM Compras
WHERE comprador LIKE '%Souza%' OR comprador LIKE '%Sousa%';