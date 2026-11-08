-- ============================================================
-- ARQUIVO: 03_financeiro.sql
-- DESCRICAO: Banco de dados e rotinas Scheduler para Financeiro
-- ============================================================

-- Ativação global do MySQL Event Scheduler
SET GLOBAL event_scheduler = ON;

-- Criação e seleção do banco de dados
CREATE DATABASE IF NOT EXISTS db_financeiro;
USE db_financeiro;

-- ------------------------------------------------------------
-- CRIAÇÃO DAS TABELAS
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS assinaturas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    plano VARCHAR(50),
    status VARCHAR(20) DEFAULT 'ATIVA'
);

CREATE TABLE IF NOT EXISTS faturas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    assinatura_id INT,
    valor DECIMAL(10,2),
    data_vencimento DATE,
    status_pagamento VARCHAR(20) DEFAULT 'PENDENTE'
);

CREATE TABLE IF NOT EXISTS faturas_historico (
    id INT PRIMARY KEY,
    assinatura_id INT,
    valor DECIMAL(10,2),
    data_vencimento DATE,
    status_pagamento VARCHAR(20),
    data_arquivamento DATETIME
);

CREATE TABLE IF NOT EXISTS parcelas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    contrato_id INT,
    valor DECIMAL(10,2),
    data_vencimento DATE,
    status VARCHAR(20) DEFAULT 'EM_ABERTO'
);

CREATE TABLE IF NOT EXISTS tokens_sessao (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    token VARCHAR(128),
    data_expiracao DATETIME
);

CREATE TABLE IF NOT EXISTS contratos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    valor_mensal DECIMAL(10,2),
    dia_vencimento INT,
    status VARCHAR(20) DEFAULT 'ATIVO'
);

-- ------------------------------------------------------------
-- EVENTOS SCHEDULER (11 a 15)
-- ------------------------------------------------------------

-- Evento 11: Suspende assinaturas com faturas atrasadas há mais de 10 dias
DROP EVENT IF EXISTS suspender_assinaturas_inadimplentes;
CREATE EVENT suspender_assinaturas_inadimplentes
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '02:00:00')
DO
  UPDATE assinaturas a
  JOIN faturas f ON a.id = f.assinatura_id
  SET a.status = 'SUSPENSA'
  WHERE f.status_pagamento = 'PENDENTE' 
    AND f.data_vencimento < CURDATE() - INTERVAL 10 DAY
    AND a.status = 'ATIVA';

-- Evento 12: Arquiva faturas pagas há mais de 5 anos
DROP EVENT IF EXISTS arquivar_faturas_antigas;
DELIMITER //
CREATE EVENT arquivar_faturas_antigas
ON SCHEDULE EVERY 1 YEAR
STARTS '2026-01-01 03:00:00'
ENDS '2030-12-31 23:59:59'
DO
BEGIN
  INSERT INTO faturas_historico (id, assinatura_id, valor, data_vencimento, status_pagamento, data_arquivamento)
  SELECT id, assinatura_id, valor, data_vencimento, status_pagamento, NOW()
  FROM faturas
  WHERE status_pagamento = 'PAGO' 
    AND data_vencimento < NOW() - INTERVAL 5 YEAR;

  DELETE FROM faturas
  WHERE status_pagamento = 'PAGO' 
    AND data_vencimento < NOW() - INTERVAL 5 YEAR;
END //
DELIMITER ;

-- Evento 13: Aplica 1% de juros em parcelas atrasadas
DROP EVENT IF EXISTS aplicar_juros_parcelas_atrasadas;
CREATE EVENT aplicar_juros_parcelas_atrasadas
ON SCHEDULE EVERY 1 MONTH
STARTS TIMESTAMP(CURRENT_DATE, '00:30:00')
DO
  UPDATE parcelas
  SET valor = valor * 1.01
  WHERE status = 'EM_ABERTO' 
    AND data_vencimento < CURDATE();

-- Evento 14: Elimina tokens de sessão expirados
DROP EVENT IF EXISTS purga_tokens_expirados;
CREATE EVENT purga_tokens_expirados
ON SCHEDULE EVERY 15 MINUTE
DO
  DELETE FROM tokens_sessao
  WHERE data_expiracao < NOW();

-- Evento 15: Gera faturas mensais na data de vencimento do contrato
DROP EVENT IF EXISTS gerar_faturas_mensais_contratos;
CREATE EVENT gerar_faturas_mensais_contratos
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '00:05:00')
DO
  INSERT INTO faturas (assinatura_id, valor, data_vencimento, status_pagamento)
  SELECT 
    c.id, 
    c.valor_mensal, 
    CURDATE(), 
    'PENDENTE'
  FROM contratos c
  WHERE c.status = 'ATIVO' 
    AND c.dia_vencimento = DAY(CURDATE());
