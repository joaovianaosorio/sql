CREATE DATABASE Loja;

USE Loja;

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    idade INT CHECK (idade >= 18),
    status VARCHAR(20) DEFAULT 'Ativo'
);

CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL CHECK (preco > 0),
    estoque INT DEFAULT 0,
    codigo_barras VARCHAR(50) UNIQUE,
    categoria VARCHAR(50)
);

CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido DATE DEFAULT (CURRENT_DATE),
    status VARCHAR(20) DEFAULT 'Pendente' CHECK (status IN ('Pendente', 'Pago', 'Enviado', 'Entregue', 'Cancelado')),
    CONSTRAINT FK_Pedidos_Clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE itens_pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario > 0),
    CONSTRAINT FK_Itens_Pedidos FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    CONSTRAINT FK_Itens_Produtos FOREIGN KEY (id_produto) REFERENCES produtos(id_produto),
    CONSTRAINT UQ_Pedido_Produto UNIQUE (id_pedido, id_produto)
);