USE biblioteca;

-- 1. Inserir usuário, autor e livro (aciona triggers 1, 3 e 9)
INSERT INTO Usuarios (nome, email) VALUES ('Ana Silva', 'ana@email.com');
INSERT INTO Autores (nome, biografia) VALUES ('Machado de Assis', 'Escritor brasileiro.');
INSERT INTO Livros (titulo, autor_id) VALUES ('Dom Casmurro', 1);

-- 2. Aumentar estoque para testar múltiplos empréstimos
UPDATE InventarioLivros SET quantidade = 10 WHERE livro_id = 1;

-- 3. Registrar empréstimo e devolver com atraso de 25 dias
-- (aciona triggers 2, 4, 5, 6, 7, 8, 12, 13, 14, 16, 17, 18 e 19)
INSERT INTO Emprestimos (usuario_id, livro_id, data_emprestimo, data_retorno_prevista)
VALUES (1, 1, '2026-10-01', '2026-10-10');

UPDATE Emprestimos SET data_devolucao = '2026-11-04' WHERE id = 1;

-- 4. Conferir resultados gerados automaticamente pelos triggers
SELECT * FROM Autores;
SELECT * FROM InventarioLivros;
SELECT * FROM HistoricoUsuarios;
SELECT * FROM HistoricoEmprestimos;
SELECT * FROM HistoricoMultas;
SELECT * FROM Notificacoes;