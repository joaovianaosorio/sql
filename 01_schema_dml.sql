-- 1. CRIAÇÃO E ABERTURA DO BANCO DE DADOS
CREATE DATABASE Bd_Turma;
USE Bd_Turma;

-- 2. CRIAÇÃO DAS TABELAS

-- Tabela de Departamentos
CREATE TABLE Depto (
    DEPTO CHAR(3) PRIMARY KEY,
    DESC_DEPTO VARCHAR(20) NOT NULL
);

-- Tabela de Funcionários
CREATE TABLE Funcionario (
    NUM_FUNC CHAR(6) PRIMARY KEY,
    NOME VARCHAR(12) NOT NULL,
    SOBRENOME VARCHAR(25) NOT NULL,
    DEPT CHAR(3),
    FONE CHAR(14),
    DTADIM DATE DEFAULT CURRENT_DATE, -- Data atual do sistema como padrão
    NIVEL INT,
    SEXO CHAR(1) CHECK (SEXO IN ('M', 'F')),
    DATANAS DATE,
    SALARIO DECIMAL(10,2),
    BONUS DECIMAL(10,2) DEFAULT 0.00,
    COMIS DECIMAL(10,2),
    FOREIGN KEY (DEPT) REFERENCES Depto(DEPTO)
);

-- 3. INSERÇÃO DE DADOS

-- Inserir dados na tabela Depto
INSERT INTO Depto (DEPTO, DESC_DEPTO) VALUES
('001', 'DIRETORIA'),
('002', 'GERÊNCIA'),
('003', 'ENGENHARIA'),
('004', 'PRODUÇÃO'),
('005', 'INFORMATICA'),
('006', 'GERÊNCIA INFORMÁTICA'); -- (Nenhum funcionário será inserido aqui conforme regra)

-- Inserindo Funcionários (F001 a F020)

-- 2 Funcionários para Diretoria (001)
INSERT INTO Funcionario (NUM_FUNC, NOME, SOBRENOME, DEPT, FONE, NIVEL, SEXO, DATANAS, SALARIO, COMIS) VALUES
('F001', 'Carlos', 'Silva', '001', '(11)91111-1111', 4, 'M', '1975-03-12', 15000.00, 2000.00),
('F002', 'Ana', 'Souza', '001', '(11)92222-2222', 4, 'F', '1980-07-22', 14000.00, 1800.00);

-- 3 Funcionários para Gerência (002)
INSERT INTO Funcionario (NUM_FUNC, NOME, SOBRENOME, DEPT, FONE, NIVEL, SEXO, DATANAS, SALARIO, COMIS) VALUES
('F003', 'Bruno', 'Lima', '002', '(11)93333-3333', 3, 'M', '1982-05-14', 9000.00, 1000.00),
('F004', 'Mariana', 'Costa', '002', '(11)94444-4444', 3, 'F', '1988-11-05', 8500.00, 900.00),
('F005', 'Marcos', 'Pereira', '002', '(11)95555-5555', 2, 'M', '1990-01-30', 7500.00, 500.00);

-- 3 Funcionários para Engenharia (003)
INSERT INTO Funcionario (NUM_FUNC, NOME, SOBRENOME, DEPT, FONE, NIVEL, SEXO, DATANAS, SALARIO, COMIS) VALUES
('F006', 'Lucas', 'Oliveira', '003', '(11)96666-6666', 3, 'M', '1985-09-18', 8000.00, 1200.00),
('F007', 'Juliana', 'Martins', '003', '(11)97777-7777', 4, 'F', '1983-12-02', 11000.00, 1500.00),
('F008', 'Rafael', 'Almeida', '003', '(11)98888-8888', 3, 'M', '1987-04-25', 7800.00, 800.00);

-- 7 Funcionários para Produção (004)
INSERT INTO Funcionario (NUM_FUNC, NOME, SOBRENOME, DEPT, FONE, NIVEL, SEXO, DATANAS, SALARIO, COMIS) VALUES
('F009', 'Pedro', 'Santos', '004', '(11)99999-1111', 2, 'M', '1992-06-15', 3500.00, 200.00),
('F010', 'Camila', 'Ribeiro', '004', '(11)99999-2222', 1, 'F', '1994-08-20', 1800.00, 100.00),
('F011', 'João', 'Ferreira', '004', '(11)99999-3383', 2, 'M', '1991-02-10', 4200.00, 300.00),
('F012', 'Beatriz', 'Gomes', '004', '(11)99999-4444', 2, 'F', '1993-10-05', 2500.00, 150.00),
('F013', 'Thiago', 'Barbosa', '004', '(11)99999-5555', 1, 'M', '1995-12-19', 1900.00, 100.00),
('F014', 'Larissa', 'Rocha', '004', '(11)99999-6666', 2, 'F', '1990-07-08', 3100.00, 250.00),
('F015', 'Diego', 'Cavalcanti', '004', '(11)99999-7777', 2, 'M', '1989-03-03', 4500.00, 400.00);

-- 5 Funcionários para Informática (005)
INSERT INTO Funcionario (NUM_FUNC, NOME, SOBRENOME, DEPT, FONE, NIVEL, SEXO, DATANAS, SALARIO, COMIS) VALUES
('F016', 'Renata', 'Carvalho', '005', '(11)98888-1111', 3, 'F', '1986-06-11', 7000.00, 1000.00),
('F017', 'Gustavo', 'Mendes', '005', '(11)98888-2222', 3, 'M', '1984-01-19', 6500.00, 900.00),
('F018', 'Vanessa', 'Nogueira', '005', '(11)98888-3333', 4, 'F', '1981-09-30', 8200.00, 1200.00),
('F019', 'Eduardo', 'Monteiro', '005', '(11)98888-4444', 2, 'M', '1992-11-21', 5800.00, 600.00),
('F020', 'Patrícia', 'Azevedo', '005', '(11)98888-5555', 3, 'F', '1989-05-14', 7200.00, 1100.00);

-- 4. COMANDOS DE ATUALIZAÇÃO (UPDATE)

-- Alterar o Depto de um dos funcionários do Depto de Informática para Depto de Engenharia
UPDATE Funcionario SET DEPT = '003' WHERE NUM_FUNC = 'F016';

-- Aumentar o Salário dos funcionários em 17%
UPDATE Funcionario SET SALARIO = SALARIO * 1.17;

-- Alterar o campo Bonus com 5% de Salário para todos os funcionários
UPDATE Funcionario SET BONUS = SALARIO * 0.05;

-- Alterar o campo Bonus com 15% de Salário para todos os funcionários de Engenharia
UPDATE Funcionario SET BONUS = SALARIO * 0.15 WHERE DEPT = '003';

-- Aumentar em 5% todos os Salários
UPDATE Funcionario SET SALARIO = SALARIO * 1.05;

-- Aumentar em 6% o Salário dos funcionários do Depto da Gerência (002)
UPDATE Funcionario SET SALARIO = SALARIO * 1.06 WHERE DEPT = '002';

-- Diminuir em 2% o Salário dos funcionários de Engenharia (003)
UPDATE Funcionario SET SALARIO = SALARIO * 0.98 WHERE DEPT = '003';

-- Alterar a Descrição do Depto de “INFORMATICA” para “INFORMÁTICA”
UPDATE Depto SET DESC_DEPTO = 'INFORMÁTICA' WHERE DEPTO = '005';

-- Alterar o fone do Funcionário com código “F004”, para “3643-4576”
UPDATE Funcionario SET FONE = '3643-4576' WHERE NUM_FUNC = 'F004';

-- 5. COMANDOS DE EXCLUSÃO (DELETE) E EXPLICAÇÃO

/*
  - Excluir todos os registros de Depto (Conseguiu? Se não, explicar o porquê):
    RESPOSTA: Não é possível excluir diretamente todos os registros da tabela 
    Depto enquanto houver funcionários vinculados a eles (devido à Restrição de 
    Chave Estrangeira / Foreign Key). Para conseguir, seria necessário excluir 
    primeiro os funcionários ou remover a restrição de integridade referencial.
*/

-- Excluir o registro do Depto “GERENCIA INFORMÁTICA” (006) - Este é possível pois não tem funcionários vinculados
DELETE FROM Depto WHERE DEPTO = '006';

-- Excluir todos os registros de funcionários
DELETE FROM Funcionario;

-- Incluir novamente os registros de Depto e Funcionários (Caso queira re-popular, basta rodar os comandos de INSERT acima novamente).
-- (Simulando a reinserção rápida dos dados para continuar os testes de select...)

-- Excluir os registros dos funcionários do departamento de INFORMÁTICA (005)
DELETE FROM Funcionario WHERE DEPT = '005';

-- Excluir o registro do Depto de GERÊNCIA INFORMÁTICA (Caso ainda exista)
DELETE FROM Depto WHERE DESC_DEPTO = 'GERÊNCIA INFORMÁTICA';

-- 6. COMANDOS DE CONSULTA (SELECT)

-- Listar todos os campos de todos os funcionários
SELECT * FROM Funcionario;

-- Listar todos os campos de todos os Departamentos
SELECT * FROM Depto;

-- Listar os campos Numero, Nome e Salário (Colocar um Alias para cada campo) de todos os funcionários
SELECT NUM_FUNC AS 'Número', NOME AS 'Nome do Funcionário', SALARIO AS 'Salário Atual' 
FROM Funcionario;

-- Listar os campos Número, Nome e Salário de todos funcionários do Departamento de Informática (005)
SELECT NUM_FUNC AS 'Número', NOME AS 'Nome', SALARIO AS 'Salário' 
FROM Funcionario WHERE DEPT = '005';

-- Listar os campos Número, Nome e Salário de todos funcionários do Departamento de Produção (004) com salário maior que R$ 2.000,00
SELECT NUM_FUNC AS 'Número', NOME AS 'Nome', SALARIO AS 'Salário' 
FROM Funcionario WHERE DEPT = '004' AND SALARIO > 2000.00;

-- Listar os campos Número, Nome e Salário de todos funcionários do Departamento de Produção (004) com salário menor que R$ 20.000,00
SELECT NUM_FUNC AS 'Número', NOME AS 'Nome', SALARIO AS 'Salário' 
FROM Funcionario WHERE DEPT = '004' AND SALARIO < 20000.00;

-- Listar os campos Número, Nome e Salário de todos funcionários do Departamento de Informática (005) com salário menor ou igual a R$ 7.000,00
SELECT NUM_FUNC AS 'Número', NOME AS 'Nome', SALARIO AS 'Salário' 
FROM Funcionario WHERE DEPT = '005' AND SALARIO <= 7000.00;

-- Listar os campos Número, Nome e Salário de todos funcionários do Departamento de Produção (004) com salário entre R$ 600,00 e R$ 2.000,00
SELECT NUM_FUNC AS 'Número', NOME AS 'Nome', SALARIO AS 'Salário' 
FROM Funcionario WHERE DEPT = '004' AND SALARIO BETWEEN 600.00 AND 2000.00;

-- Listar os campos Número, Nome e Salário de todos funcionários do Departamento de Produção (004)
SELECT NUM_FUNC AS 'Número', NOME AS 'Nome', SALARIO AS 'Salário' 
FROM Funcionario WHERE DEPT = '004';

-- Listar os campos Número, Nome, Salário em ordem crescente de salário
SELECT NUM_FUNC AS 'Número', NOME AS 'Nome', SALARIO AS 'Salário' 
FROM Funcionario ORDER BY SALARIO ASC;

-- Listar os campos Número, Nome, Salário do Departamento de Produção em ordem decrescente de salário
SELECT NUM_FUNC AS 'Número', NOME AS 'Nome', SALARIO AS 'Salário' 
FROM Funcionario WHERE DEPT = '004' ORDER BY SALARIO DESC;

-- Listar os campos Número, Nome, Data de Nascimento e Bônus dos funcionários de Informática (005)
SELECT NUM_FUNC AS 'Número', NOME AS 'Nome', DATANAS AS 'Data de Nascimento', BONUS AS 'Bônus' 
FROM Funcionario WHERE DEPT = '005';

-- Listar todos os dados dos funcionários com curso Superior (Graduação - Nível 3) em ordem alfabética de nome (Colocar um apelido para campo)
SELECT NUM_FUNC AS 'Matrícula', NOME AS 'Primeiro Nome', SOBRENOME, DEPT, FONE, DTADIM, NIVEL, SEXO, DATANAS, SALARIO, BONUS, COMIS 
FROM Funcionario WHERE NIVEL = 3 ORDER BY NOME ASC;

-- Listar todos os dados dos funcionários com curso Pós-Graduação (Nível 4) em ordem decrescente de nome
SELECT NUM_FUNC AS 'Matrícula', NOME AS 'Primeiro Nome', SOBRENOME, DEPT, FONE, DTADIM, NIVEL, SEXO, DATANAS, SALARIO, BONUS, COMIS 
FROM Funcionario WHERE NIVEL = 4 ORDER BY NOME DESC;

-- Listar os campos dos funcionários do Departamento de Informática com salário entre R$ 5.600,00 e R$ 8.000,00 usando BETWEEN
SELECT * 
FROM Funcionario 
WHERE DEPT = '005' AND SALARIO BETWEEN 5600.00 AND 8000.00;