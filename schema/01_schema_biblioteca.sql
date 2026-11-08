-- Criar o Banco de Dados
CREATE DATABASE Biblioteca;
USE Biblioteca;

-- Criar a Tabela Livros
CREATE TABLE Livros (
    id_livro INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100),
    autor VARCHAR(80),
    categoria VARCHAR(50)
);

-- Criar a Tabela Emprestimos
CREATE TABLE Emprestimos (
    id_emprestimo INT PRIMARY KEY AUTO_INCREMENT,
    id_livro INT,
    nome_leitor VARCHAR(80),
    data_emprestimo DATE,
    data_devolucao DATE,
    FOREIGN KEY (id_livro) REFERENCES Livros(id_livro)
);

-- Inserir dados na tabela Livros
INSERT INTO Livros (titulo, autor, categoria) VALUES
('Dom Casmurro', 'Machado de Assis', 'Romance'),
('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 'Infantil'),
('Clean Code', 'Robert C. Martin', 'Tecnologia'),
('Banco de Dados', 'Carlos Heuser', 'Tecnologia'),
('Capitães da Areia', 'Jorge Amado', 'Romance');

-- Inserir dados na tabela Emprestimos
INSERT INTO Emprestimos (id_livro, nome_leitor, data_emprestimo, data_devolucao) VALUES
(1, 'Ana Souza', '2026-08-01', '2026-08-10'),
(3, 'Carlos Lima', '2026-08-02', '2026-08-12'),
(2, 'Mariana Alves', '2026-08-03', '2026-08-13'),
(4, 'João Pereira', '2026-08-04', '2026-08-14'),
(5, 'Fernanda Silva', '2026-08-05', '2026-08-15');

-- Questão 01
SELECT l.titulo AS Livro, e.nome_leitor AS Leitor
FROM Livros l
INNER JOIN Emprestimos e ON l.id_livro = e.id_livro;

-- Questão 02
SELECT e.nome_leitor AS Leitor
FROM Emprestimos e
INNER JOIN Livros l ON e.id_livro = l.id_livro
WHERE l.titulo = 'Clean Code';

-- Questão 03
SELECT l.titulo AS Título, l.autor AS Autor, e.data_emprestimo AS Data_Empréstimo
FROM Livros l
INNER JOIN Emprestimos e ON l.id_livro = e.id_livro;

-- Questão 04
SELECT l.titulo AS Livro, l.categoria AS Categoria, e.nome_leitor AS Leitor
FROM Livros l
INNER JOIN Emprestimos e ON l.id_livro = e.id_livro
WHERE l.categoria = 'Tecnologia';

-- Questão 05
SELECT e.nome_leitor AS Leitor, l.titulo AS Livro, e.data_devolucao AS Data_Devolução
FROM Emprestimos e
INNER JOIN Livros l ON e.id_livro = l.id_livro
ORDER BY e.nome_leitor ASC;