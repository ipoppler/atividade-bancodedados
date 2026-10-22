create table contas (
id serial primary key,
cliente varchar(150) not null,
saldo decimal(10,2) not null check (saldo > 0)
);

create table movimentacoes (
id serial primary key,
conta_id int not null,
foreign key (conta_id)
references contas(id),
tipo_mov varchar(2) default 'D' check (tipo_mov in('D', 'C')),
valor decimal(10,2) not null check (valor > 0)
);

insert into contas (cliente, saldo) values
('Fabricia', 8000.00),
('Monica', 10000.00),
('Felipe', 5600.00);

insert into movimentacoes(conta_id, tipo_mov, valor) values
(2, 'D', 5000.00),
(1, 'C', 4000.90);

CREATE OR REPLACE FUNCTION fn_atualiza_saldo_conta()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tipo_mov = 'C' THEN
        UPDATE contas SET saldo = saldo + NEW.valor WHERE id = NEW.conta_id;
    ELSIF NEW.tipo_mov = 'D' THEN
        UPDATE contas SET saldo = saldo - NEW.valor WHERE id = NEW.conta_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualiza_saldo
AFTER INSERT ON movimentacoes
FOR EACH ROW
EXECUTE FUNCTION fn_atualiza_saldo_conta();

insert into contas (cliente, saldo) values
('João Silva', 500);

insert into movimentacoes (conta_id, tipo_mov, valor) values
(1, 'D', 150.00);

select * from contas where id = 1;