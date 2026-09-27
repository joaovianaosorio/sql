-- 1. CRIAÇÃO DO BANCO DE DADOS E TABELAS

CREATE DATABASE IF NOT EXISTS BD_Universidade;
USE BD_Universidade;

-- Tabela Alunos
CREATE TABLE Alunos (
    id_aluno INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idade INT,
    cidade VARCHAR(50)
);

-- Tabela Cursos
CREATE TABLE Cursos (
    id_curso INT PRIMARY KEY,
    nome_curso VARCHAR(100) NOT NULL,
    duracao INT
);

-- Tabela Matriculas
CREATE TABLE Matriculas (
    id_matricula INT PRIMARY KEY,
    id_aluno INT,
    id_curso INT,
    semestre VARCHAR(10),
    nota DECIMAL(4,2),
    FOREIGN KEY (id_aluno) REFERENCES Alunos(id_aluno),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
);

-- 2. INSERÇÃO DOS DADOS

INSERT INTO Alunos (id_aluno, nome, idade, cidade) 
VALUES
(1, 'Ana Silva', 20, 'São Paulo'),
(2, 'João Souza', 22, 'Guarulhos'),
(3, 'Carlos Oliveira', 21, 'Osasco'),
(4, 'Mariana Santos', 23, 'São Paulo'),
(5, 'Pedro Costa', 19, 'Guarulhos'),
(6, 'Juliana Alves', 24, 'Santo André'),
(7, 'Lucas Pereira', 20, 'São Paulo'),
(8, 'Fernanda Lima', 22, 'Osasco');

INSERT INTO Cursos (id_curso, nome_curso, duracao)
VALUES
(101, 'Análise e Desenvolvimento de Sistemas', 3),
(102, 'Engenharia da Computação', 5),
(103, 'Sistemas de Informação', 4),
(104, 'Tecnologia em Banco de Dados', 2);

INSERT INTO Matriculas (id_matricula, id_aluno, id_curso, semestre, nota)
VALUES
(1, 1, 101, '2026.1', 8.5),
(2, 2, 101, '2026.1', 7.8),
(3, 3, 102, '2026.1', 9.0),
(4, 4, 103, '2026.1', 8.2),
(5, 5, 102, '2026.2', 9.2),
(6, 6, 102, '2026.2', 9.2),
(7, 7, 103, '2026.2', 6.8),
(8, 8, 104, '2026.1', 8.9),
(9, 1, 103, '2026.2', 9.1),
(10, 2, 104, '2026.2', 8.0),
(11, 3, 101, '2026.2', 7.7),
(12, 4, 102, '2026.2', 8.8);

-- 3. RESOLUÇÃO DAS QUESTÕES (COM INNER JOIN)

-- Questão 01
SELECT A.nome AS Aluno, C.nome_curso AS Curso, M.semestre AS Semestre
FROM Alunos A
INNER JOIN Matriculas M ON A.id_aluno = M.id_aluno
INNER JOIN Cursos C ON M.id_curso = C.id_curso
WHERE A.nome = 'Ana Silva' AND M.semestre = '2026.1';


-- Questão 02
SELECT A.nome AS Aluno, C.nome_curso AS Curso, M.semestre AS Semestre, M.nota AS Nota
FROM Alunos A
INNER JOIN Matriculas M ON A.id_aluno = M.id_aluno
INNER JOIN Cursos C ON M.id_curso = C.id_curso
WHERE A.nome = 'João Souza' AND M.semestre = '2026.2';


-- Questão 03
SELECT A.nome AS Aluno, C.nome_curso AS Curso, M.semestre AS Semestre
FROM Alunos A
INNER JOIN Matriculas M ON A.id_aluno = M.id_aluno
INNER JOIN Cursos C ON M.id_curso = C.id_curso
WHERE C.nome_curso = 'Análise e Desenvolvimento de Sistemas';


-- Questão 04
SELECT A.nome AS Aluno, A.cidade AS Cidade, C.nome_curso AS Curso, M.semestre AS Semestre
FROM Alunos A
INNER JOIN Matriculas M ON A.id_aluno = M.id_aluno
INNER JOIN Cursos C ON M.id_curso = C.id_curso
WHERE A.cidade = 'São Paulo' AND C.nome_curso = 'Sistemas de Informação';


-- Questão 05
SELECT A.nome AS Aluno, C.nome_curso AS Curso, M.nota AS Nota
FROM Alunos A
INNER JOIN Matriculas M ON A.id_aluno = M.id_aluno
INNER JOIN Cursos C ON M.id_curso = C.id_curso
WHERE M.nota >= 8.5
ORDER BY M.nota DESC;


-- Questão 06
SELECT A.nome AS Aluno, C.nome_curso AS Curso, M.semestre AS Semestre
FROM Alunos A
INNER JOIN Matriculas M ON A.id_aluno = M.id_aluno
INNER JOIN Cursos C ON M.id_curso = C.id_curso
WHERE M.semestre = '2026.2';


-- Questão 07
SELECT A.nome AS Aluno, A.cidade AS Cidade, C.nome_curso AS Curso, M.semestre AS Semestre
FROM Alunos A
INNER JOIN Matriculas M ON A.id_aluno = M.id_aluno
INNER JOIN Cursos C ON M.id_curso = C.id_curso
WHERE A.cidade = 'Guarulhos';


-- Questão 08
SELECT A.nome AS Aluno, C.nome_curso AS Curso, C.duracao AS Duração, M.nota AS Nota
FROM Alunos A
INNER JOIN Matriculas M ON A.id_aluno = M.id_aluno
INNER JOIN Cursos C ON M.id_curso = C.id_curso
WHERE C.duracao >= 4
ORDER BY C.duracao ASC, M.nota ASC;


-- Questão 09
SELECT A.nome AS Aluno, C.nome_curso AS Curso, M.nota AS Nota
FROM Alunos A
INNER JOIN Matriculas M ON A.id_aluno = M.id_aluno
INNER JOIN Cursos C ON M.id_curso = C.id_curso
WHERE C.nome_curso = 'Engenharia da Computação';


-- Questão 10
SELECT A.nome AS Aluno, C.nome_curso AS Curso, M.semestre AS Semestre, M.nota AS Nota
FROM Alunos A
INNER JOIN Matriculas M ON A.id_aluno = M.id_aluno
INNER JOIN Cursos C ON M.id_curso = C.id_curso
WHERE M.nota < 8.0
ORDER BY M.nota ASC;