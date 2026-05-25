CREATE DATABASE petvida;
USE petvida;

CREATE TABLE veterinarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    crmv VARCHAR(20) NOT NULL UNIQUE,
    especialidade VARCHAR(50) NOT NULL,
    telefone VARCHAR(20) NOT NULL
);


CREATE TABLE tutores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL
);


CREATE TABLE animais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    especie VARCHAR(30) NOT NULL,
    raca VARCHAR(30) NOT NULL,
    data_nascimento DATE NOT NULL,
    tutor_id INT NOT NULL,
    FOREIGN KEY (tutor_id) REFERENCES tutores(id)
);

CREATE TABLE consultas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    animal_id INT NOT NULL,
    veterinario_id INT NOT NULL,
    data_hora DATETIME NOT NULL,
    diagnostico TEXT,
    valor DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (animal_id) REFERENCES animais(id),
    FOREIGN KEY (veterinario_id) REFERENCES veterinarios(id)
);


-- INSERT

INSERT INTO veterinarios (nome, crmv, especialidade, telefone) VALUES
('Dr. Robert Cefas', 'CRMV-BA1234', 'Clínica Geral', '(71) 98422-4699'),
('Dr. Roberto Carlos', 'CRMV-BA5678', 'Felinos', '(71) 98888-2222'),
('Dr. Pedro Lucas', 'CRMV-BA9012', 'Ortopedia', '(71) 98888-3333');


INSERT INTO tutores (nome, cpf, email, telefone) VALUES
('Juliana Amorin', '111.111.111-11', 'juliana@email.com', '(71) 99999-9991'),
('Henrique Lucas', '222.222.222-22', 'harrypotter@gmail.com', '(71) 99999-9992'),
('Alberth Tailon', '333.333.333-33', 'Albert@gmail.com', '(71) 99999-9993'),
('Daiane Bispo', '444.444.444-44', 'daiane@gmail.com', '(71) 99999-9994'),
('Carlos Nigga', '555.555.555-55', 'carlos@gmail.com', '(71) 99999-9995');

-- Animais (Juliana e Henrique com mais de 1 animal)
INSERT INTO animais (nome, especie, raca, data_nascimento, tutor_id) VALUES
('Beethoven', 'Cachorro', 'São-bernardo', '2021-05-10', 1),
('Frajola', 'Gato', 'SRD', '2022-03-15', 1),
('Milo', 'Cachorro', 'Jack Russell Terrier', '2019-08-20', 2),
('Scooby-Doo', 'Cachorro', 'Dogue Alemão', '2020-11-02', 2),
('Garfield', 'Gato', 'Persa', '2023-01-12', 3),
('Rex', 'Cachorro', 'Vira-lata', '2018-04-30', 4),
('Manda-Chuva', 'Gato', 'SRD', '2024-02-14', 5),
('Bidu', 'Cachorro', 'Schnauzer', '2022-07-22', 1);


INSERT INTO consultas (animal_id, veterinario_id, data_hora, diagnostico, valor) VALUES
(1, 1, '2026-01-10 10:00:00', 'Check-up anual, saudavel.', 150.00),
(2, 2, '2026-01-12 14:30:00', 'Vacina aplicada.', 120.00),
(3, 1, '2026-01-15 09:00:00', 'Infeccao no ouvido.', 180.00),
(4, 3, '2026-01-18 16:00:00', 'Dor na pata traseira.', 250.00),
(5, 2, '2026-01-20 11:15:00', 'Exame de rotina.', 130.00),
(1, 3, '2026-02-02 10:30:00', 'Retorno ortopedico.', 140.00),
(2, 2, '2026-02-05 15:00:00', 'Alergia de pele.', 160.00),
(3, 1, '2026-02-10 08:30:00', 'Retorno da infeccao, curado.', 100.00),
(4, 3, '2026-02-12 14:00:00', 'Prescricao de remedio.', 200.00),
(6, 1, '2026-02-15 17:00:00', 'Limpeza de tartaro.', 110.00);


-- SELECTS, JOINS E WHERE

SELECT animais.nome AS Animal, tutores.nome AS Tutor
FROM animais
JOIN tutores ON animais.tutor_id = tutores.id;

SELECT consultas.id, animais.nome AS Animal, tutores.nome AS Tutor, veterinarios.nome AS Veterinario, consultas.data_hora, consultas.valor
FROM consultas
JOIN animais ON consultas.animal_id = animais.id
JOIN tutores ON animais.tutor_id = tutores.id
JOIN veterinarios ON consultas.veterinario_id = veterinarios.id;

-- Consultas de um veterinario especifico
SELECT consultas.id, veterinarios.nome, consultas.data_hora
FROM consultas
JOIN veterinarios ON consultas.veterinario_id = veterinarios.id
WHERE veterinarios.nome = 'Dr. Robert Cefas';

-- Animais de uma especie especifica
SELECT * FROM animais 
WHERE especie = 'Cachorro';

-- Tutores com mais de 1 animal
SELECT tutores.nome, COUNT(animais.id) AS Qtd_Animais
FROM tutores
JOIN animais ON animais.tutor_id = tutores.id
GROUP BY tutores.nome
HAVING COUNT(animais.id) > 1;

-- Faturamento total
SELECT SUM(valor) AS Faturamento_Total FROM consultas;

-- Faturamento por veterinario
SELECT v.nome, SUM(c.valor) AS Total
FROM consultas c
JOIN veterinarios v ON c.veterinario_id = v.id
GROUP BY v.nome
ORDER BY Total DESC;

-- Animais que NUNCA tiveram consulta
SELECT animais.id, animais.nome
FROM animais
LEFT JOIN consultas ON animais.id = consultas.animal_id
WHERE consultas.id IS NULL;


-- UPDATE E DELETE

UPDATE tutores 
SET telefone = '(71) 97777-5555' 
WHERE id = 1;

UPDATE consultas 
SET diagnostico = 'Otite totalmente curada.' 
WHERE id = 3;

DELETE FROM consultas 
WHERE id = 10;


-- STORED PROCEDURE E FUNCTION

DELIMITER $$
CREATE PROCEDURE agendar_consulta(
    p_animal_id INT,
    p_veterinario_id INT,
    p_data_hora DATETIME,
    p_valor DECIMAL(10,2)
)
BEGIN
    -- Verifica se o animal nao existe
    IF (SELECT COUNT(*) FROM animais WHERE id = p_animal_id) = 0 THEN
        SELECT 'Erro: O animal nao existe!' AS Msg_Erro;
    ELSE
        -- Se existe, insere a consulta
        INSERT INTO consultas (animal_id, veterinario_id, data_hora, diagnostico, valor)
        VALUES (p_animal_id, p_veterinario_id, p_data_hora, 'Agendada', p_valor);
        
        SELECT 'Consulta agendada com sucesso!' AS Sucesso;
    END IF;
END $$
DELIMITER ;

-- Teste da Procedure
CALL agendar_consulta(1, 2, '2026-05-10 15:00:00', 150.00);


-- Function Total Consultas do Animal
DELIMITER $$
CREATE FUNCTION total_consultas_animal(p_animal_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM consultas WHERE animal_id = p_animal_id;
    RETURN total;
END $$
DELIMITER ;

-- Teste da Function
SELECT nome, total_consultas_animal(id) AS Total_Consultas FROM animais;


-- GRANT E REVOKE

-- Permissoes da recepcionista
GRANT SELECT, INSERT ON petvida.tutores TO recepcionista;
GRANT SELECT, INSERT ON petvida.animais TO recepcionista;
GRANT SELECT, INSERT ON petvida.consultas TO recepcionista;

-- Permissoes do veterinario
GRANT SELECT ON petvida.* TO veterinario_sistema;
GRANT UPDATE (diagnostico) ON petvida.consultas TO veterinario_sistema;

-- Permissoes do admin
GRANT ALL PRIVILEGES ON petvida.* TO admin_clinica;

-- Revoke da recepcionista
REVOKE ALL PRIVILEGES, GRANT OPTION FROM recepcionista;