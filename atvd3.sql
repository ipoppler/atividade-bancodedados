create table funcionarios (
id serial primary key,
nome varchar(150) not null,
cargo varchar (150) not null,
salario decimal(10,2) not null check (salario > 0)
);

create table historico_carreira (
id serial primary ke
)