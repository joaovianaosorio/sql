-- ============================================================
-- BANCO DE DADOS: Bd_Teste
-- CONTEÚDO: Criação de Tabelas, Procedures e Validações T-SQL
-- ============================================================

-- e) Criar o banco de dados com o Nome Bd_Teste
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Bd_Teste')
BEGIN
    CREATE DATABASE Bd_Teste;
END;
GO

USE Bd_Teste;
GO

-- ------------------------------------------------------------
-- CRIAÇÃO DAS TABELAS
-- ------------------------------------------------------------

-- f) Tabela de Funcionários: (Nome = Tb_Funcionario)
IF OBJECT_ID('Tb_Funcionario', 'U') IS NOT NULL DROP TABLE Tb_Funcionario;
CREATE TABLE Tb_Funcionario (
    codfunc SMALLINT PRIMARY KEY NOT NULL,
    nomefunc VARCHAR(30) NOT NULL,
    salariofunc SMALLMONEY NOT NULL,
    CodDepto SMALLINT
);
GO

-- g) Tabela de Arquivo Morto: (Nome = Tb_Morto)
IF OBJECT_ID('Tb_Morto', 'U') IS NOT NULL DROP TABLE Tb_Morto;
CREATE TABLE Tb_Morto (
    codfunc SMALLINT PRIMARY KEY NOT NULL,
    nomefunc VARCHAR(30) NOT NULL,
    salariofunc SMALLMONEY NOT NULL,
    CodDepto SMALLINT,
    DataDemissao DATE DEFAULT GETDATE()
);
GO

-- h) Tabela de Depto: (Nome = Tb_Depto)
IF OBJECT_ID('Tb_Depto', 'U') IS NOT NULL DROP TABLE Tb_Depto;
CREATE TABLE Tb_Depto (
    Coddep SMALLINT PRIMARY KEY NOT NULL,
    nomedep VARCHAR(30) NOT NULL
);
GO

-- ------------------------------------------------------------
-- PROCEDURES ALGORÍTMICAS (SEM UTILIZAR SELECT)
-- ------------------------------------------------------------

-- a) Receber dois Números e mostrar o produto deles (sem SELECT)
CREATE OR ALTER PROCEDURE sp_ProdutoDoisNumeros
    @num1 INT,
    @num2 INT
AS
BEGIN
    DECLARE @produto INT;
    SET @produto = @num1 * @num2;
    PRINT 'O produto dos números é: ' + CAST(@produto AS VARCHAR(20));
END;
GO

-- b) Receber dois Números inteiros e mostrar em ordem decrescente (sem SELECT)
CREATE OR ALTER PROCEDURE sp_OrdemDecrescenteDois
    @n1 INT,
    @n2 INT
AS
BEGIN
    IF @n1 >= @n2
        PRINT 'Ordem decrescente: ' + CAST(@n1 AS VARCHAR(10)) + ', ' + CAST(@n2 AS VARCHAR(10));
    ELSE
        PRINT 'Ordem decrescente: ' + CAST(@n2 AS VARCHAR(10)) + ', ' + CAST(@n1 AS VARCHAR(10));
END;
GO

-- c) Receber três Números inteiros e mostrar em ordem crescente (sem SELECT)
CREATE OR ALTER PROCEDURE sp_OrdemCrescenteTres
    @a INT,
    @b INT,
    @c INT
AS
BEGIN
    DECLARE @temp INT;
    
    IF @a > @b
    BEGIN
        SET @temp = @a;
        SET @a = @b;
        SET @b = @temp;
    END;
    
    IF @b > @c
    BEGIN
        SET @temp = @b;
        SET @b = @c;
        SET @c = @temp;
    END;
    
    IF @a > @b
    BEGIN
        SET @temp = @a;
        SET @a = @b;
        SET @b = @temp;
    END;
    
    PRINT 'Ordem crescente: ' + CAST(@a AS VARCHAR(10)) + ', ' + CAST(@b AS VARCHAR(10)) + ', ' + CAST(@c AS VARCHAR(10));
END;
GO

-- d) Receber um Nº Inteiro menor que 100 e mostrar os seus divisores (sem SELECT)
CREATE OR ALTER PROCEDURE sp_MostrarDivisores
    @num INT
AS
BEGIN
    IF @num >= 100 OR @num <= 0
    BEGIN
        PRINT 'Erro: O número deve ser maior que 0 e menor que 100.';
        RETURN;
    END;
    
    DECLARE @i INT = 1;
    PRINT 'Divisores de ' + CAST(@num AS VARCHAR(10)) + ':';
    
    WHILE @i <= @num
    BEGIN
        IF @num % @i = 0
            PRINT CAST(@i AS VARCHAR(10));
        SET @i = @i + 1;
    END;
END;
GO

-- ------------------------------------------------------------
-- PROCEDURES CRUD E OPERACIONAIS
-- ------------------------------------------------------------

-- i) Fazer inclusão de dados na tabela Depto
CREATE OR ALTER PROCEDURE sp_InserirDepto
    @Coddep SMALLINT,
    @nomedep VARCHAR(30)
AS
BEGIN
    INSERT INTO Tb_Depto (Coddep, nomedep)
    VALUES (@Coddep, @nomedep);
END;
GO

-- j) Fazer inclusão de dados na tabela Funcionários
CREATE OR ALTER PROCEDURE sp_InserirFuncionario
    @codfunc SMALLINT,
    @nomefunc VARCHAR(30),
    @salariofunc SMALLMONEY,
    @CodDepto SMALLINT
AS
BEGIN
    INSERT INTO Tb_Funcionario (codfunc, nomefunc, salariofunc, CodDepto)
    VALUES (@codfunc, @nomefunc, @salariofunc, @CodDepto);
END;
GO

-- k) Consulta de todos os dados do funcionário pelo código
CREATE OR ALTER PROCEDURE sp_ConsultarFuncionarioPorCodigo
    @codfunc SMALLINT
AS
BEGIN
    SELECT codfunc, nomefunc, salariofunc, CodDepto
    FROM Tb_Funcionario
    WHERE codfunc = @codfunc;
END;
GO

-- l) Alteração dos dados do funcionário pelo código
CREATE OR ALTER PROCEDURE sp_AlterarFuncionario
    @codfunc SMALLINT,
    @nomefunc VARCHAR(30),
    @salariofunc SMALLMONEY,
    @CodDepto SMALLINT
AS
BEGIN
    UPDATE Tb_Funcionario
    SET nomefunc = @nomefunc,
        salariofunc = @salariofunc,
        CodDepto = @CodDepto
    WHERE codfunc = @codfunc;
END;
GO

-- m) Exclusão de registro pelo código do funcionário
CREATE OR ALTER PROCEDURE sp_ExcluirFuncionario
    @codfunc SMALLINT
AS
BEGIN
    DELETE FROM Tb_Funcionario
    WHERE codfunc = @codfunc;
END;
GO

-- n) Consulta de código, nome e salário do funcionário pelo código
CREATE OR ALTER PROCEDURE sp_ConsultarCodigoNomeSalario
    @codfunc SMALLINT
AS
BEGIN
    SELECT codfunc, nomefunc, salariofunc
    FROM Tb_Funcionario
    WHERE codfunc = @codfunc;
END;
GO

-- o) Consulta de todos os funcionários em ordem crescente de nome
CREATE OR ALTER PROCEDURE sp_ListarFuncionariosPorNome
AS
BEGIN
    SELECT codfunc, nomefunc, salariofunc, CodDepto
    FROM Tb_Funcionario
    ORDER BY nomefunc ASC;
END;
GO

-- ------------------------------------------------------------
-- PROCEDURES DE AGREGAÇÃO E ESTATÍSTICA
-- ------------------------------------------------------------

-- p) Quantidade de funcionários cadastrados por departamento
CREATE OR ALTER PROCEDURE sp_QtdFuncionariosPorDepto
AS
BEGIN
    SELECT d.Coddep, d.nomedep, COUNT(f.codfunc) AS QtdFuncionarios
    FROM Tb_Depto d
    LEFT JOIN Tb_Funcionario f ON d.Coddep = f.CodDepto
    GROUP BY d.Coddep, d.nomedep;
END;
GO

-- q) Total de salário de todos os funcionários
CREATE OR ALTER PROCEDURE sp_TotalSalarioFuncionarios
AS
BEGIN
    SELECT SUM(salariofunc) AS TotalSalarios
    FROM Tb_Funcionario;
END;
GO

-- r) Total de salário dos funcionários agrupados por departamento
CREATE OR ALTER PROCEDURE sp_TotalSalarioPorDepto
AS
BEGIN
    SELECT d.Coddep, d.nomedep, SUM(f.salariofunc) AS TotalSalario
    FROM Tb_Depto d
    INNER JOIN Tb_Funcionario f ON d.Coddep = f.CodDepto
    GROUP BY d.Coddep, d.nomedep;
END;
GO

-- s) Código do depto, quantidade de funcionários e total de salário por depto
CREATE OR ALTER PROCEDURE sp_ResumoDepto
AS
BEGIN
    SELECT 
        d.Coddep,
        COUNT(f.codfunc) AS QtdFuncionarios,
        ISNULL(SUM(f.salariofunc), 0) AS TotalSalarios
    FROM Tb_Depto d
    LEFT JOIN Tb_Funcionario f ON d.Coddep = f.CodDepto
    GROUP BY d.Coddep;
END;
GO

-- ------------------------------------------------------------
-- PROCEDURES DE REGRA DE NEGÓCIO E VALIDAÇÃO
-- ------------------------------------------------------------

-- t) Aumentar o salário dos funcionários em x%
CREATE OR ALTER PROCEDURE sp_AumentarSalarioPercentual
    @percentual DECIMAL(5,2)
AS
BEGIN
    UPDATE Tb_Funcionario
    SET salariofunc = salariofunc * (1 + (@percentual / 100.0));
END;
GO

-- u) Excluir funcionário e mover cópia para tabela Tb_Morto (Arquivo Morto)
CREATE OR ALTER PROCEDURE sp_DemitirFuncionario
    @codfunc SMALLINT
AS
BEGIN
    BEGIN TRANSACTION;
    
    INSERT INTO Tb_Morto (codfunc, nomefunc, salariofunc, CodDepto, DataDemissao)
    SELECT codfunc, nomefunc, salariofunc, CodDepto, GETDATE()
    FROM Tb_Funcionario
    WHERE codfunc = @codfunc;
    
    DELETE FROM Tb_Funcionario
    WHERE codfunc = @codfunc;
    
    COMMIT TRANSACTION;
END;
GO

-- v) Receber um CPF e retornar 'CPF VÁLIDO' ou 'CPF INVÁLIDO'
CREATE OR ALTER PROCEDURE sp_ValidarCPF
    @cpfInput VARCHAR(20)
AS
BEGIN
    DECLARE @cpf VARCHAR(11);
    SET @cpf = REPLACE(REPLACE(@cpfInput, '.', ''), '-', '');
    
    -- Validação inicial de formato e tamanho
    IF LEN(@cpf) <> 11 OR ISNUMERIC(@cpf) = 0
    BEGIN
        PRINT 'CPF INVÁLIDO';
        RETURN;
    END;
    
    -- Validação de sequências repetidas inválidas
    IF @cpf IN ('00000000000','11111111111','22222222222','33333333333',
                '44444444444','55555555555','66666666666','77777777777',
                '88888888888','99999999999')
    BEGIN
        PRINT 'CPF INVÁLIDO';
        RETURN;
    END;
    
    DECLARE @i INT = 1;
    DECLARE @soma INT = 0;
    DECLARE @resto INT;
    DECLARE @digito1 INT, @digito2 INT;
    
    -- Cálculo do 1º dígito verificador
    WHILE @i <= 9
    BEGIN
        SET @soma = @soma + (CAST(SUBSTRING(@cpf, @i, 1) AS INT) * (11 - @i));
        SET @i = @i + 1;
    END;
    
    SET @resto = (@soma * 10) % 11;
    IF @resto = 10 OR @resto = 11 SET @resto = 0;
    SET @digito1 = @resto;
    
    IF @digito1 <> CAST(SUBSTRING(@cpf, 10, 1) AS INT)
    BEGIN
        PRINT 'CPF INVÁLIDO';
        RETURN;
    END;
    
    -- Cálculo do 2º dígito verificador
    SET @i = 1;
    SET @soma = 0;
    WHILE @i <= 10
    BEGIN
        SET @soma = @soma + (CAST(SUBSTRING(@cpf, @i, 1) AS INT) * (12 - @i));
        SET @i = @i + 1;
    END;
    
    SET @resto = (@soma * 10) % 11;
    IF @resto = 10 OR @resto = 11 SET @resto = 0;
    SET @digito2 = @resto;
    
    IF @digito2 <> CAST(SUBSTRING(@cpf, 11, 1) AS INT)
    BEGIN
        PRINT 'CPF INVÁLIDO';
        RETURN;
    END;
    
    PRINT 'CPF VÁLIDO';
END;
GO
