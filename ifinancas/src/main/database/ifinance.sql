DROP DATABASE IF EXISTS ifinance;

CREATE DATABASE ifinance
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE ifinance;

CREATE TABLE perfil_acesso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome ENUM('COORDENADOR', 'ADMINISTRADOR') NOT NULL DEFAULT 'COORDENADOR'
);

CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    perfil_id INT NOT NULL, 
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    status_usuario ENUM('ATIVO', 'INATIVO') NOT NULL DEFAULT 'ATIVO',
    CONSTRAINT fk_usuario_perfil FOREIGN KEY (perfil_id) REFERENCES perfil_acesso(id) 
);

CREATE TABLE projeto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    coordenador_id INT NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    status_projeto ENUM('PENDENTE', 'APROVADO', 'REPROVADO', 'FINALIZADO') NOT NULL DEFAULT 'PENDENTE',
    descricao VARCHAR(255) NOT NULL,
    CONSTRAINT fk_projeto_coordenador FOREIGN KEY (coordenador_id) REFERENCES usuario(id)
);

CREATE TABLE financiador (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome ENUM('EMPRESA', 'EMBRAPII', 'FOMENTO (LC/SEBRAE/ETC)', 'IFBA') NOT NULL
);

CREATE TABLE projeto_financiador (
    projeto_id INT NOT NULL,
    financiador_id INT NOT NULL,
    investimento DECIMAL(14,4) NOT NULL,
    PRIMARY KEY (projeto_id, financiador_id),
    CONSTRAINT fk_projeto_financiador_projeto FOREIGN KEY (projeto_id) REFERENCES projeto(id) ON DELETE CASCADE,
    CONSTRAINT fk_projeto_financiador_financiador FOREIGN KEY (financiador_id) REFERENCES financiador(id) ON DELETE CASCADE
);

CREATE TABLE macroetapa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    projeto_id INT NOT NULL,
    numero VARCHAR(20) NOT NULL,
    descricao VARCHAR(255),
    duracao INT NOT NULL, /* meses de duração */
    CONSTRAINT fk_macroetapa_projeto FOREIGN KEY (projeto_id) REFERENCES projeto(id) ON DELETE CASCADE,
    CONSTRAINT uk_macroetapa_projeto_numero UNIQUE (projeto_id, numero)
);

CREATE TABLE item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE rubrica (
    id INT AUTO_INCREMENT PRIMARY KEY,
    categoria ENUM('RH', 'SERVICO TERCEIRO PJ', 'SERVICO TERCEIRO PF', 'MATERIAIS', 'DIARIAS', 'PASSAGENS', 'SUPORTE OPERACIONAL', 'CONTRAPARTIDA') NOT NULL,
    fk_item INT NOT NULL,
    CONSTRAINT fk_rubrica_item FOREIGN KEY (fk_item) REFERENCES item(id)
);

CREATE TABLE item_orcamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    macroetapa_id INT NOT NULL,
    fk_item_id INT NOT NULL,
    financiador_id INT NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL DEFAULT 1,
    valor_unitario DECIMAL(14,4) NOT NULL,
    CONSTRAINT fk_item_macroetapa FOREIGN KEY (macroetapa_id) REFERENCES macroetapa(id) ON DELETE CASCADE,
    CONSTRAINT fk_item_orcamento_item FOREIGN KEY (fk_item_id) REFERENCES item(id),
    CONSTRAINT fk_item_financiador FOREIGN KEY (financiador_id) REFERENCES financiador(id)
);

-- Views
CREATE VIEW view_item_orcamento AS
SELECT 
    id,
    macroetapa_id,
    fk_item_id,
    financiador_id,
    quantidade,
    valor_unitario,
    (quantidade * valor_unitario) AS valor_total
FROM item_orcamento;

CREATE VIEW view_duracao_projeto AS
SELECT 
    p.id AS projeto_id,
    COALESCE(SUM(m.duracao), 0) AS duracao_total
FROM projeto p
LEFT JOIN macroetapa m
    ON m.projeto_id = p.id
GROUP BY p.id;

-- Selects
SELECT * FROM view_item_orcamento;
SELECT * FROM view_duracao_projeto;


INSERT INTO perfil_acesso (nome) VALUES ('COORDENADOR');
INSERT INTO perfil_acesso (nome) VALUES ('ADMINISTRADOR');


INSERT INTO financiador (nome) VALUES ('FOMENTO (LC/SEBRAE/ETC)');


INSERT INTO usuario (perfil_id, nome, email, senha_hash) VALUES ('2','Lucas','admin@ifinance.com','123456');
INSERT INTO usuario (perfil_id, nome, email, senha_hash) VALUES ('1','Lucas','admin2@ifinance.com','123456');

