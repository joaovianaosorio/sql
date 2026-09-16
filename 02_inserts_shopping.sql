USE Shopping;

INSERT INTO Shopping (Codigo_Shopping, Nome_Shopping, Endereco_Shopping, Bairro_Shopping, Cidade_Shopping, Uf_Shopping, Fone_Adminstrativo) 
VALUES 
('S01', 'Shopping Center Plaza', 'Av. Paulista, 1000', 'Bela Vista', 'São Paulo', 'SP', '1133334444'),
('S02', 'Grand Plaza Shopping', 'Rua das Flores, 500', 'Centro', 'Campinas', 'SP', '1932325555');

INSERT INTO Tb_Cargo (Codigo_Cargo, Nome_do_Cargo, Comissao_Cargo) 
VALUES 
('C0001', 'Geren', 1500.00),
('C0002', 'Vende', 500.00),
('C0003', 'Caixa', 200.00);

INSERT INTO TB_Lojas (Codigo_Loja, Nome_Loja, Codigo_Shopping, CNPJ_Loja) 
VALUES 
('L01', 'Loja Tech Games', 'S01', '12345678000199'),
('L02', 'Moda & Estilo', 'S01', '98765432000188'),
('L03', 'Livraria Central', 'S02', '11223344000177');

INSERT INTO Tb_Funcionarios (Codigo_Funcionario, Nome_do_Funcionario, Sexo, Data_Nascimento, cpf, Cod_Cargo, Cod_loja, Data_Admissao) 
VALUES 
('F01', 'Carlos Silva', 'M', '1990-05-15', '12345678901', 'C0001', 'L01', '2023-01-10'),
('F02', 'Ana Souza', 'F', '1995-08-22', '98765432100', 'C0002', 'L01', '2023-03-15'),
('F03', 'Mariana Oliveira', 'F', '1998-12-01', '45678912300', 'C0003', 'L02', '2024-02-01');