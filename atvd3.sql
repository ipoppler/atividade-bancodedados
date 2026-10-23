create table funcionarios (
id serial primary key,
nome varchar(150) not null,
cargo varchar (150) not null,
salario decimal(10,2) not null check (salario > 0)
);

CREATE TABLE historico_carreira (
    id SERIAL PRIMARY KEY,
    funcionario_id INT NOT NULL,
    cargo_antigo VARCHAR(50),
    cargo_novo VARCHAR(50),
    salario_antigo DECIMAL(10, 2),
    salario_novo DECIMAL(10, 2),
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION fn_log_alteracao_carreira()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.cargo IS DISTINCT FROM NEW.cargo OR OLD.salario IS DISTINCT FROM NEW.salario THEN
        INSERT INTO historico_carreira (funcionario_id, cargo_antigo, cargo_novo, salario_antigo, salario_novo)
        VALUES (OLD.id, OLD.cargo, NEW.cargo, OLD.salario, NEW.salario);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_carreira
AFTER UPDATE ON funcionarios
FOR EACH ROW
EXECUTE FUNCTION fn_log_alteracao_carreira();

INSERT INTO funcionarios (nome, cargo, salario) values 
('Paula', 'Desenvolvedora JR', 4250);

update funcionarios set cargo = 'Desenvolvedora Pleno', salario = 5500 where id= 1;

