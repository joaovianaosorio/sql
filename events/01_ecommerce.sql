-- ============================================================
-- ARQUIVO: 01_ecommerce.sql
-- DESCRICAO: Banco de dados e rotinas Scheduler para E-Commerce
-- ============================================================

-- Ativação global do MySQL Event Scheduler
SET GLOBAL event_scheduler = ON;

-- Criação e seleção do banco de dados
CREATE DATABASE IF NOT EXISTS db_ecommerce;
USE db_ecommerce;

-- ------------------------------------------------------------
-- CRIAÇÃO DAS TABELAS
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    valor DECIMAL(15,2),
    data_venc DATETIME,
    status VARCHAR(30) DEFAULT 'NO PRAZO',
    views_hoje INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    valor_total DECIMAL(15,2),
    data_pedido DATETIME,
    status VARCHAR(30) DEFAULT 'PENDENTE'
);

CREATE TABLE IF NOT EXISTS carrinho_compras (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    produto_id INT,
    data_adicao DATETIME
);

CREATE TABLE IF NOT EXISTS resumo_vendas_diarias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_resumo DATE UNIQUE,
    total_pedidos INT,
    total_faturado DECIMAL(15,2)
);

-- ------------------------------------------------------------
-- EVENTOS SCHEDULER (1 a 5)
-- ------------------------------------------------------------

-- Evento 1: Atualiza status dos produtos vencidos
DROP EVENT IF EXISTS atualiza_status_produtos_vencidos;
CREATE EVENT atualiza_status_produtos_vencidos
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '00:00:00')
DO
  UPDATE produtos
  SET status = 'VENCIDO'
  WHERE data_venc <= CURDATE() AND status != 'VENCIDO';

-- Evento 2: Cancela pedidos pendentes após 24 horas
DROP EVENT IF EXISTS cancela_pedidos_pendentes_expirados;
CREATE EVENT cancela_pedidos_pendentes_expirados
ON SCHEDULE EVERY 1 HOUR
DO
  UPDATE pedidos
  SET status = 'CANCELADO'
  WHERE status = 'PENDENTE' AND data_pedido < NOW() - INTERVAL 24 HOUR;

-- Evento 3: Limpa carrinhos abandonados há mais de 7 dias
DROP EVENT IF EXISTS limpa_carrinhos_abandonados;
CREATE EVENT limpa_carrinhos_abandonados
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '03:00:00')
DO
  DELETE FROM carrinho_compras
  WHERE data_adicao < NOW() - INTERVAL 7 DAY;

-- Evento 4: Consolida resumo diário de vendas do dia
DROP EVENT IF EXISTS gerar_resumo_vendas_diario;
CREATE EVENT gerar_resumo_vendas_diario
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '23:59:00')
DO
  INSERT INTO resumo_vendas_diarias (data_resumo, total_pedidos, total_faturado)
  SELECT 
    CURDATE(), 
    COUNT(id), 
    IFNULL(SUM(valor_total), 0.00)
  FROM pedidos
  WHERE DATE(data_pedido) = CURDATE() AND status = 'PAGO'
  ON DUPLICATE KEY UPDATE 
    total_pedidos = VALUES(total_pedidos),
    total_faturado = VALUES(total_faturado);

-- Evento 5: Zera contador de visualizações diárias dos produtos
DROP EVENT IF EXISTS reset_contador_visualizacoes;
CREATE EVENT reset_contador_visualizacoes
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '00:00:00')
DO
  UPDATE produtos
  SET views_hoje = 0;
