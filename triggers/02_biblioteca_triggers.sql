USE biblioteca;

DELIMITER $$

-- 1. Registro de Usuário no Histórico
CREATE TRIGGER trg_01_registro_usuario_historico
AFTER INSERT ON Usuarios
FOR EACH ROW
BEGIN
    INSERT INTO HistoricoUsuarios (usuario_id, livros_em_emprestimo, status)
    VALUES (NEW.id, 0, 'LIVRE');
END$$

-- 2. Registro de Empréstimo no Histórico
CREATE TRIGGER trg_02_registro_emprestimo_historico
AFTER INSERT ON Emprestimos
FOR EACH ROW
BEGIN
    INSERT INTO HistoricoEmprestimos (
        emprestimo_id, data_emprestimo, emprestimo_vencido, status_emprestimo, dias_atraso
    )
    VALUES (NEW.id, NEW.data_emprestimo, 'NAO', 'EM USO', 0);
END$$

-- 3. Registro de Novos Livros no Inventário (inicia com 1 exemplar disponível)
CREATE TRIGGER trg_03_registro_novo_livro_inventario
AFTER INSERT ON Livros
FOR EACH ROW
BEGIN
    INSERT INTO InventarioLivros (livro_id, quantidade)
    VALUES (NEW.id, 1);
END$$

-- 4. Atualização de Estado na Devolução
CREATE TRIGGER trg_04_atualizacao_estado_devolucao
AFTER UPDATE ON Emprestimos
FOR EACH ROW
BEGIN
    IF NEW.data_devolucao IS NOT NULL AND OLD.data_devolucao IS NULL THEN
        UPDATE HistoricoEmprestimos
        SET status_emprestimo = 'DEVOLVIDO',
            data_devolucao = NEW.data_devolucao
        WHERE emprestimo_id = NEW.id;
    END IF;
END$$

-- 5. Aumentar Estoque de Livros na Devolução
CREATE TRIGGER trg_05_aumentar_estoque_devolucao
AFTER UPDATE ON Emprestimos
FOR EACH ROW
BEGIN
    IF NEW.data_devolucao IS NOT NULL AND OLD.data_devolucao IS NULL THEN
        UPDATE InventarioLivros
        SET quantidade = quantidade + 1
        WHERE livro_id = NEW.livro_id;
    END IF;
END$$

-- 6. Diminuir Livros em Empréstimo na Devolução
CREATE TRIGGER trg_06_diminuir_livros_emprestimo
AFTER UPDATE ON Emprestimos
FOR EACH ROW
BEGIN
    IF NEW.data_devolucao IS NOT NULL AND OLD.data_devolucao IS NULL THEN
        UPDATE HistoricoUsuarios
        SET livros_em_emprestimo = livros_em_emprestimo - 1
        WHERE usuario_id = NEW.usuario_id AND livros_em_emprestimo > 0;
    END IF;
END$$

-- 7. Diminuir Estoque de Livros ao Registrar Empréstimo
CREATE TRIGGER trg_07_diminuir_estoque_emprestimo
AFTER INSERT ON Emprestimos
FOR EACH ROW
BEGIN
    DECLARE qtd_estoque INT DEFAULT 0;

    SELECT quantidade INTO qtd_estoque
    FROM InventarioLivros
    WHERE livro_id = NEW.livro_id;

    IF qtd_estoque <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Livro indisponível no inventário para empréstimo.';
    ELSE
        UPDATE InventarioLivros
        SET quantidade = quantidade - 1
        WHERE livro_id = NEW.livro_id;
    END IF;
END$$

-- 8. Aumentar Livros em Empréstimo ao Registrar Empréstimo
CREATE TRIGGER trg_08_aumentar_livros_emprestimo
AFTER INSERT ON Emprestimos
FOR EACH ROW
BEGIN
    UPDATE HistoricoUsuarios
    SET livros_em_emprestimo = livros_em_emprestimo + 1
    WHERE usuario_id = NEW.usuario_id;
END$$

-- 9. Contagem de Livros por Autor
CREATE TRIGGER trg_09_contagem_livros_autor
AFTER INSERT ON Livros
FOR EACH ROW
BEGIN
    UPDATE Autores
    SET quantidade_obras = quantidade_obras + 1
    WHERE id = NEW.autor_id;
END$$

-- 10. Restrição de Empréstimos Simultâneos (máximo 5 livros)
CREATE TRIGGER trg_10_restricao_emprestimos_simultaneos
BEFORE INSERT ON Emprestimos
FOR EACH ROW
BEGIN
    DECLARE qtd_atual INT DEFAULT 0;

    SELECT livros_em_emprestimo INTO qtd_atual
    FROM HistoricoUsuarios
    WHERE usuario_id = NEW.usuario_id;

    IF qtd_atual >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Usuário atingiu o limite máximo de 5 empréstimos simultâneos.';
    END IF;
END$$

-- 11. Verificação de Status (BANIDO ou RESTRITO) para Empréstimo
CREATE TRIGGER trg_11_verificacao_status_emprestimo
BEFORE INSERT ON Emprestimos
FOR EACH ROW
BEGIN
    DECLARE status_usuario VARCHAR(20);

    SELECT status INTO status_usuario
    FROM HistoricoUsuarios
    WHERE usuario_id = NEW.usuario_id;

    IF status_usuario IN ('BANIDO', 'RESTRITO') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Empréstimo negado: usuário está RESTRITO ou BANIDO.';
    END IF;
END$$

-- 12. Verificação de Atraso no Empréstimo ao Devolver
CREATE TRIGGER trg_12_verificacao_atraso_emprestimo
AFTER UPDATE ON Emprestimos
FOR EACH ROW
BEGIN
    IF NEW.data_devolucao IS NOT NULL AND OLD.data_devolucao IS NULL THEN
        IF NEW.data_retorno_prevista IS NOT NULL AND NEW.data_devolucao > NEW.data_retorno_prevista THEN
            UPDATE HistoricoEmprestimos
            SET emprestimo_vencido = 'SIM',
                dias_atraso = DATEDIFF(NEW.data_devolucao, NEW.data_retorno_prevista)
            WHERE emprestimo_id = NEW.id;
        ELSE
            UPDATE HistoricoEmprestimos
            SET emprestimo_vencido = 'NAO',
                dias_atraso = 0
            WHERE emprestimo_id = NEW.id;
        END IF;
    END IF;
END$$

-- 13. Bloqueio de Usuário por Vencimento
CREATE TRIGGER trg_13_bloqueio_usuario_vencimento
AFTER UPDATE ON HistoricoEmprestimos
FOR EACH ROW
BEGIN
    DECLARE v_usuario_id INT;

    IF NEW.emprestimo_vencido = 'SIM' AND (OLD.emprestimo_vencido IS NULL OR OLD.emprestimo_vencido <> 'SIM') THEN
        SELECT usuario_id INTO v_usuario_id
        FROM Emprestimos
        WHERE id = NEW.emprestimo_id;

        UPDATE HistoricoUsuarios
        SET status = 'RESTRITO'
        WHERE usuario_id = v_usuario_id AND status <> 'BANIDO';
    END IF;
END$$

-- 14. Cálculo e Registro de Multa (R$ 2,50 por dia de atraso)
CREATE TRIGGER trg_14_calculo_registro_multa
AFTER UPDATE ON HistoricoEmprestimos
FOR EACH ROW
BEGIN
    DECLARE v_usuario_id INT;
    DECLARE v_dias INT;
    DECLARE v_valor_multa DECIMAL(10,2);

    IF NEW.emprestimo_vencido = 'SIM' AND (OLD.emprestimo_vencido IS NULL OR OLD.emprestimo_vencido <> 'SIM') THEN
        SELECT usuario_id INTO v_usuario_id
        FROM Emprestimos
        WHERE id = NEW.emprestimo_id;

        SET v_dias = GREATEST(NEW.dias_atraso, 1);
        SET v_valor_multa = v_dias * 2.50;

        INSERT INTO HistoricoMultas (usuario_id, valor, status, emprestimo_id)
        VALUES (v_usuario_id, v_valor_multa, 'NAO_PAGA', NEW.emprestimo_id);
    END IF;
END$$

-- 15. Atualização de Status ao Zerar Penalidades
CREATE TRIGGER trg_15_atualizacao_status_zerar_penalidades
AFTER UPDATE ON HistoricoMultas
FOR EACH ROW
BEGIN
    DECLARE multas_pendentes INT DEFAULT 0;

    IF NEW.status = 'PAGA' AND OLD.status <> 'PAGA' THEN
        SELECT COUNT(*) INTO multas_pendentes
        FROM HistoricoMultas
        WHERE usuario_id = NEW.usuario_id AND status = 'NAO_PAGA';

        IF multas_pendentes = 0 THEN
            UPDATE HistoricoUsuarios
            SET status = 'LIVRE'
            WHERE usuario_id = NEW.usuario_id;
        END IF;
    END IF;
END$$

-- 16. Controle de Penalidades (banimento se multas não pagas > R$ 50,00)
CREATE TRIGGER trg_16_controle_penalidades
AFTER INSERT ON HistoricoMultas
FOR EACH ROW
BEGIN
    DECLARE total_multas DECIMAL(10,2) DEFAULT 0.00;

    SELECT COALESCE(SUM(valor), 0.00) INTO total_multas
    FROM HistoricoMultas
    WHERE usuario_id = NEW.usuario_id AND status = 'NAO_PAGA';

    IF total_multas > 50.00 THEN
        UPDATE HistoricoUsuarios
        SET status = 'BANIDO'
        WHERE usuario_id = NEW.usuario_id;
    END IF;
END$$

-- 17. Notificação de Banimento
CREATE TRIGGER trg_17_notificacao_banimento
AFTER UPDATE ON HistoricoUsuarios
FOR EACH ROW
BEGIN
    IF NEW.status = 'BANIDO' AND OLD.status <> 'BANIDO' THEN
        INSERT INTO Notificacoes (usuario_id, tipo_notificacao, mensagem)
        VALUES (
            NEW.usuario_id,
            'PENALIDADE_ALTA',
            'Você foi BANIDO por ultrapassar o limite máximo de R$ 50,00 em multas pendentes.'
        );
    END IF;
END$$

-- 18. Atualização Automática de Empréstimos Vencidos
CREATE TRIGGER trg_18_atualizacao_automatica_vencidos
AFTER UPDATE ON Emprestimos
FOR EACH ROW
BEGIN
    IF NEW.data_retorno_prevista IS NOT NULL THEN
        IF NEW.data_devolucao IS NULL AND CURDATE() > NEW.data_retorno_prevista THEN
            UPDATE HistoricoEmprestimos
            SET emprestimo_vencido = 'SIM',
                status_emprestimo = 'ATRASADO',
                dias_atraso = DATEDIFF(CURDATE(), NEW.data_retorno_prevista)
            WHERE emprestimo_id = NEW.id;
        ELSEIF NEW.data_devolucao IS NOT NULL AND NEW.data_devolucao > NEW.data_retorno_prevista THEN
            UPDATE HistoricoEmprestimos
            SET emprestimo_vencido = 'SIM',
                status_emprestimo = 'ATRASADO'
            WHERE emprestimo_id = NEW.id;
        END IF;
    END IF;
END$$

-- 19. Notificação de Empréstimo Vencido
CREATE TRIGGER trg_19_notificacao_emprestimo_vencido
AFTER UPDATE ON HistoricoEmprestimos
FOR EACH ROW
BEGIN
    DECLARE v_usuario_id INT;

    IF NEW.emprestimo_vencido = 'SIM' AND (OLD.emprestimo_vencido IS NULL OR OLD.emprestimo_vencido <> 'SIM') THEN
        SELECT usuario_id INTO v_usuario_id
        FROM Emprestimos
        WHERE id = NEW.emprestimo_id;

        INSERT INTO Notificacoes (usuario_id, tipo_notificacao, mensagem)
        VALUES (
            v_usuario_id,
            'EMPRESTIMO_PENDENTE',
            'Seu empréstimo está vencido. Você foi RESTRITO para novos empréstimos até a regularização.'
        );
    END IF;
END$$

-- 20. Notificação de Empréstimo Próximo ao Vencimento (faltando 3 dias)
CREATE TRIGGER trg_20_notificacao_proximo_vencimento
AFTER UPDATE ON Emprestimos
FOR EACH ROW
BEGIN
    IF NEW.data_devolucao IS NULL
       AND NEW.data_retorno_prevista IS NOT NULL
       AND DATEDIFF(NEW.data_retorno_prevista, CURDATE()) = 3 THEN
        INSERT INTO Notificacoes (usuario_id, tipo_notificacao, mensagem)
        VALUES (
            NEW.usuario_id,
            'EMPRESTIMO_PENDENTE',
            'Atenção: faltam 3 dias para o vencimento do seu empréstimo.'
        );
    END IF;
END$$

DELIMITER ;