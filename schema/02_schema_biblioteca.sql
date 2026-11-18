CREATE DATABASE IF NOT EXISTS biblioteca;
USE biblioteca;

-- 1. Tabela de Usuários
CREATE TABLE Usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- 2. Tabela de Autores
CREATE TABLE Autores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    biografia TEXT,
    quantidade_obras INT DEFAULT 0
);

-- 3. Tabela de Livros
CREATE TABLE Livros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    autor_id INT,
    FOREIGN KEY (autor_id) REFERENCES Autores(id)
);

-- 4. Tabela de Inventário de Livros
CREATE TABLE InventarioLivros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    livro_id INT,
    quantidade INT UNSIGNED NOT NULL,
    FOREIGN KEY (livro_id) REFERENCES Livros(id)
);

-- 5. Tabela de Empréstimos
CREATE TABLE Emprestimos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    livro_id INT,
    data_emprestimo DATE NOT NULL,
    data_devolucao DATE,
    data_retorno_prevista DATE,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (livro_id) REFERENCES Livros(id)
);

-- 6. Tabela de Histórico de Usuários
CREATE TABLE HistoricoUsuarios (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    usuario_id INT NOT NULL,
    livros_em_emprestimo INT UNSIGNED DEFAULT 0,
    status ENUM('BANIDO', 'RESTRITO', 'LIVRE') DEFAULT 'LIVRE',
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

-- 7. Tabela de Histórico de Empréstimos
CREATE TABLE HistoricoEmprestimos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emprestimo_id INT,
    data_emprestimo DATE NOT NULL,
    data_devolucao DATE,
    emprestimo_vencido ENUM('SIM', 'NAO'),
    status_emprestimo ENUM('ATRASADO', 'EM USO', 'DEVOLVIDO') DEFAULT 'EM USO',
    dias_atraso INT UNSIGNED DEFAULT 0,
    FOREIGN KEY (emprestimo_id) REFERENCES Emprestimos(id)
);

-- 8. Tabela de Histórico de Multas
CREATE TABLE HistoricoMultas (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    usuario_id INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status ENUM('NAO_PAGA', 'PAGA') DEFAULT 'NAO_PAGA',
    emprestimo_id INT NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (emprestimo_id) REFERENCES Emprestimos(id)
);

-- 9. Tabela de Notificações
CREATE TABLE Notificacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    tipo_notificacao ENUM('EMPRESTIMO_PENDENTE', 'PENALIDADE_ALTA') NOT NULL,
    mensagem TEXT NOT NULL,
    data_notificacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);