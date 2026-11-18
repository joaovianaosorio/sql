-- ==========================================================
-- AMBIENTE: BANCO DE DADOS E TABELAS
-- ==========================================================
CREATE DATABASE IF NOT EXISTS loja_udf;
USE loja_udf;

CREATE TABLE Clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cidade VARCHAR(100) NOT NULL
);

CREATE TABLE Produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT UNSIGNED NOT NULL
);

CREATE TABLE Pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    data_pedido DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);

-- Dados iniciais para testar as funções
INSERT INTO Clientes (nome, cidade) VALUES
('Mariana Costa', 'São Paulo'),
('Lucas Almeida', 'Campinas'),
('Beatriz Rocha', 'Santos');

INSERT INTO Produtos (nome, preco, estoque) VALUES
('Teclado Mecânico', 350.00, 12),
('Mouse Sem Fio', 120.00, 3),
('Monitor 24 Polegadas', 890.00, 0);

INSERT INTO Pedidos (cliente_id, data_pedido, valor_total) VALUES
(1, '2026-11-10', 350.00),
(1, '2026-11-12', 120.00),
(2, '2026-11-14', 890.00);

-- ==========================================================
-- 5 EXEMPLOS DE FUNÇÕES UDF
-- ==========================================================
DELIMITER $$

-- Exemplo 1: Calcular preço com desconto percentual (cálculo puro)
CREATE FUNCTION fn_preco_com_desconto(
    p_preco DECIMAL(10,2),
    p_desconto_pct DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN ROUND(p_preco - (p_preco * (p_desconto_pct / 100)), 2);
END$$

-- Exemplo 2: Classificar situação do estoque com base na quantidade
CREATE FUNCTION fn_status_estoque(p_quantidade INT)
RETURNS VARCHAR(20)
DETERMINISTIC
NO SQL
BEGIN
    IF p_quantidade = 0 THEN
        RETURN 'ESGOTADO';
    ELSEIF p_quantidade <= 5 THEN
        RETURN 'ESTOQUE BAIXO';
    ELSE
        RETURN 'DISPONIVEL';
    END IF;
END$$

-- Exemplo 3: Somar o valor total já gasto por um cliente (consulta tabela)
CREATE FUNCTION fn_total_gasto_cliente(p_cliente_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2) DEFAULT 0.00;

    SELECT COALESCE(SUM(valor_total), 0.00) INTO v_total
    FROM Pedidos
    WHERE cliente_id = p_cliente_id;

    RETURN v_total;
END$$

-- Exemplo 4: Verificar se um pedido tem direito a frete grátis (pedidos >= R$ 200,00)
CREATE FUNCTION fn_elegivel_frete_gratis(p_pedido_id INT)
RETURNS VARCHAR(5)
READS SQL DATA
BEGIN
    DECLARE v_valor DECIMAL(10,2) DEFAULT 0.00;

    SELECT valor_total INTO v_valor
    FROM Pedidos
    WHERE id = p_pedido_id;

    IF v_valor >= 200.00 THEN
        RETURN 'SIM';
    ELSE
        RETURN 'NAO';
    END IF;
END$$

-- Exemplo 5: Gerar etiqueta formatada com nome e preço do produto
CREATE FUNCTION fn_etiqueta_produto(p_produto_id INT)
RETURNS VARCHAR(200)
READS SQL DATA
BEGIN
    DECLARE v_etiqueta VARCHAR(200);

    SELECT CONCAT(nome, ' - R$ ', FORMAT(preco, 2, 'pt_BR')) INTO v_etiqueta
    FROM Produtos
    WHERE id = p_produto_id;

    RETURN v_etiqueta;
END$$

DELIMITER ;

-- ==========================================================
-- TESTANDO AS 5 FUNÇÕES NAS TABELAS CRIADAS
-- ==========================================================

-- Testa Exemplos 1, 2 e 5 na tabela Produtos
SELECT
    id,
    fn_etiqueta_produto(id) AS etiqueta,
    preco AS preco_original,
    fn_preco_com_desconto(preco, 15) AS preco_com_15pct_desconto,
    estoque,
    fn_status_estoque(estoque) AS situacao_estoque
FROM Produtos;

-- Testa Exemplo 3 na tabela Clientes
SELECT
    id,
    nome,
    cidade,
    fn_total_gasto_cliente(id) AS total_acumulado
FROM Clientes;

-- Testa Exemplo 4 na tabela Pedidos
SELECT
    id AS numero_pedido,
    cliente_id,
    valor_total,
    fn_elegivel_frete_gratis(id) AS frete_gratis
FROM Pedidos;