-- ============================================================
-- ARQUIVO: 02_biblioteca.sql
-- DESCRICAO: Banco de dados e rotinas Scheduler para Biblioteca
-- ============================================================

-- Ativação global do MySQL Event Scheduler
SET GLOBAL event_scheduler = ON;

-- Criação e seleção do banco de dados
CREATE DATABASE IF NOT EXISTS db_biblioteca;
USE db_biblioteca;

-- ------------------------------------------------------------
-- CRIAÇÃO DAS TABELAS
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS alunos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    ultimo_acesso DATETIME,
    status VARCHAR(20) DEFAULT 'ATIVO'
);

CREATE TABLE IF NOT EXISTS emprestimos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    aluno_id INT,
    livro_id INT,
    data_emprestimo DATETIME,
    data_devolucao_prevista DATE,
    status VARCHAR(20) DEFAULT 'EM_ANDAMENTO'
);

CREATE TABLE IF NOT EXISTS multas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    emprestimo_id INT,
    valor DECIMAL(10,2),
    data_geracao DATETIME
);

CREATE TABLE IF NOT EXISTS reservas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    livro_id INT,
    aluno_id INT,
    data_reserva DATETIME,
    status VARCHAR(30) DEFAULT 'AGUARDANDO_RETIRADA'
);

CREATE TABLE IF NOT EXISTS logs_catraca (
    id INT PRIMARY KEY AUTO_INCREMENT,
    aluno_id INT,
    data_hora DATETIME
);

CREATE TABLE IF NOT EXISTS notificacoes_pendentes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    aluno_id INT,
    mensagem VARCHAR(255),
    data_criacao DATETIME
);

-- ------------------------------------------------------------
-- EVENTOS SCHEDULER (6 a 10)
-- ------------------------------------------------------------

-- Evento 6: Aplica multa diária para empréstimos em atraso
DROP EVENT IF EXISTS gerar_multa_emprestimos_atrasados;
CREATE EVENT gerar_multa_emprestimos_atrasados
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '01:00:00')
DO
  INSERT INTO multas (emprestimo_id, valor, data_geracao)
  SELECT id, 2.00, NOW()
  FROM emprestimos
  WHERE data_devolucao_prevista < CURDATE() AND status = 'EM_ANDAMENTO';

-- Evento 7: Inativa alunos sem acesso há mais de 2 anos
DROP EVENT IF EXISTS inativar_alunos_ausentes;
CREATE EVENT inativar_alunos_ausentes
ON SCHEDULE EVERY 1 MONTH
STARTS TIMESTAMP(CURRENT_DATE, '02:00:00')
DO
  UPDATE alunos
  SET status = 'INATIVO'
  WHERE ultimo_acesso < NOW() - INTERVAL 2 YEAR AND status = 'ATIVO';

-- Evento 8: Remove logs de catraca mais antigos que 90 dias
DROP EVENT IF EXISTS expurgar_logs_catraca_antigos;
CREATE EVENT expurgar_logs_catraca_antigos
ON SCHEDULE EVERY 1 WEEK
STARTS TIMESTAMP(CURRENT_DATE, '04:00:00')
DO
  DELETE FROM logs_catraca
  WHERE data_hora < NOW() - INTERVAL 90 DAY;

-- Evento 9: Expira reservas não retiradas em até 48 horas
DROP EVENT IF EXISTS expirar_reservas_nao_retiradas;
CREATE EVENT expirar_reservas_nao_retiradas
ON SCHEDULE EVERY 30 MINUTE
DO
  UPDATE reservas
  SET status = 'EXPIRADA'
  WHERE status = 'AGUARDANDO_RETIRADA' 
    AND data_reserva < NOW() - INTERVAL 48 HOUR;

-- Evento 10: Gera notificações para devoluções com vencimento no dia seguinte
DROP EVENT IF EXISTS gerar_alerta_devolucao_amanha;
CREATE EVENT gerar_alerta_devolucao_amanha
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '07:00:00')
DO
  INSERT INTO notificacoes_pendentes (aluno_id, mensagem, data_criacao)
  SELECT 
    aluno_id, 
    CONCAT('Aviso: A devolução do livro referente ao empréstimo #', id, ' vence amanhã.'), 
    NOW()
  FROM emprestimos
  WHERE data_devolucao_prevista = CURDATE() + INTERVAL 1 DAY 
    AND status = 'EM_ANDAMENTO';
