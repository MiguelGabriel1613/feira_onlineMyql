-- Criando o banco de dados
CREATE DATABASE feira_online;
USE feira_online;

-- Tabela para armazenar os dados pessoais dos agricultores
CREATE TABLE agricultores (
    id_agricultor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    endereco_pessoal VARCHAR(255)
);

-- Tabela para armazenar os dados da população (usuários)
CREATE TABLE populacao (
    id_populacao INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    telefone VARCHAR(20)
);

-- Tabela para as feiras, postadas por um agricultor (o organizador)
CREATE TABLE feiras (
    id_feira INT PRIMARY KEY AUTO_INCREMENT,
    id_agricultor_organizador INT, -- O agricultor que criou a feira
    nome_feira VARCHAR(100) NOT NULL,
    descricao TEXT,
    data_feira DATE NOT NULL,
    horario_inicio TIME,
    horario_fim TIME,
    endereco_feira VARCHAR(255) NOT NULL,
    cep_feira VARCHAR(10) NOT NULL,
    FOREIGN KEY (id_agricultor_organizador) REFERENCES agricultores(id_agricultor)
);

-- Tabela para gerenciar a participação de outros agricultores nas feiras
-- Esta tabela cria uma relação de muitos-para-muitos entre agricultores e feiras
CREATE TABLE participacoes_feira (
    id_participacao INT PRIMARY KEY AUTO_INCREMENT,
    id_feira INT,
    id_agricultor INT,
    data_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_feira) REFERENCES feiras(id_feira),
    FOREIGN KEY (id_agricultor) REFERENCES agricultores(id_agricultor),
    UNIQUE (id_feira, id_agricultor) -- Garante que um agricultor não se registre duas vezes na mesma feira
);

-- Tabela para os produtos que os agricultores levarão para as feiras
CREATE TABLE produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    id_agricultor INT,
    nome_produto VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    unidade_medida VARCHAR(50),
    FOREIGN KEY (id_agricultor) REFERENCES agricultores(id_agricultor)
);

-- Tabela para vincular produtos a feiras específicas
CREATE TABLE feiras_produtos (
    id_feira INT,
    id_produto INT,
    PRIMARY KEY (id_feira, id_produto),
    FOREIGN KEY (id_feira) REFERENCES feiras(id_feira),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- Tabela para registrar as pré-compras
CREATE TABLE pre_compras (
    id_pre_compra INT PRIMARY KEY AUTO_INCREMENT,
    id_populacao INT,
    id_produto INT,
    id_agricultor INT, -- O agricultor dono do produto
    quantidade INT NOT NULL,
    data_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_pedido ENUM('pendente', 'confirmado', 'cancelado') NOT NULL,
    FOREIGN KEY (id_populacao) REFERENCES populacao(id_populacao),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto),
    FOREIGN KEY (id_agricultor) REFERENCES agricultores(id_agricultor)
);