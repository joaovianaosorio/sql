CREATE DATABASE Shopping;

USE Shopping;

CREATE TABLE Shopping (
    Codigo_Shopping VARCHAR(3) PRIMARY KEY,
    Nome_Shopping VARCHAR(40) NOT NULL,
    Endereco_Shopping VARCHAR(30) NOT NULL,
    Bairro_Shopping VARCHAR(30),
    Cidade_Shopping VARCHAR(30),
    Uf_Shopping CHAR(2),
    Fone_Adminstrativo VARCHAR(13)
);

CREATE TABLE TB_Lojas (
    Codigo_Loja VARCHAR(3) PRIMARY KEY,
    Nome_Loja VARCHAR(30) NOT NULL,
    Codigo_Shopping VARCHAR(3),
    CNPJ_Loja VARCHAR(17) UNIQUE,
    CONSTRAINT FK_Lojas_Shopping FOREIGN KEY (Codigo_Shopping) REFERENCES Shopping(Codigo_Shopping)
);

CREATE TABLE Tb_Cargo (
    Codigo_Cargo VARCHAR(5) PRIMARY KEY,
    Nome_do_Cargo VARCHAR(5) NOT NULL,
    Comissao_Cargo DECIMAL(15,2)
);

CREATE TABLE Tb_Funcionarios (
    Codigo_Funcionario VARCHAR(3) PRIMARY KEY,
    Nome_do_Funcionario VARCHAR(40) NOT NULL,
    Sexo CHAR(1) CHECK (Sexo IN ('F', 'M')),
    Data_Nascimento DATE,
    cpf VARCHAR(12) UNIQUE,
    Cod_Cargo VARCHAR(5),
    Cod_loja VARCHAR(3),
    Data_Admissao DATE,
    CONSTRAINT FK_Funcionarios_Cargo FOREIGN KEY (Cod_Cargo) REFERENCES Tb_Cargo(Codigo_Cargo),
    CONSTRAINT FK_Funcionarios_Loja FOREIGN KEY (Cod_loja) REFERENCES TB_Lojas(Codigo_Loja)
);