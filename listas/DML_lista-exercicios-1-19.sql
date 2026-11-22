create database empresa;

use empresa;
create table Empregado(
rg varchar(20) primary key,
sexo enum('Feminino','Mascuino', 'Outro') not null,
dt_nasc date not null,
pnome varchar(15) not null,
unome varchar(50) not null,
rua varchar(100),
cidade varchar(50),
estado char(2),
salario decimal(10, 2),
dnum int,
supRG varchar(20)
);

create table Departamento(
dnum int primary key,
dnome varchar(50) not null,
gerRG varchar(20),
dt_inicio date not null
);

create table Projeto (
pnum int primary key,
pnome varchar(50) not null,
localizacao varchar(100),
dnum int
);

create table Dependente(
empRG varchar(20),
dep_nome varchar(100) not null,
dep_sexo char(1),
dp_dt_nasc date,
primary key(empRG, dep_nome)
);

create table trabalha_em(
RG varchar(20) not null,
pnum int not null,
horas decimal(5, 2),
primary key(RG, pnum)
);

create table localizacao(
dnum int not null,
localizacao varchar(100) not null,
primary key(dnum, localizacao)
);
-- Chaves da tabela Empregado
ALTER TABLE Empregado ADD CONSTRAINT fk_emp_supervisor FOREIGN KEY (supRG) REFERENCES Empregado(RG);
ALTER TABLE Empregado ADD CONSTRAINT fk_emp_depto FOREIGN KEY (dnum) REFERENCES Departamento(dnum);

-- Chave da tabela Departamento
ALTER TABLE Departamento ADD CONSTRAINT fk_depto_gerente FOREIGN KEY (gerRG) REFERENCES Empregado(RG);

-- Chave da tabela Projeto
ALTER TABLE Projeto ADD CONSTRAINT fk_proj_depto FOREIGN KEY (dnum) REFERENCES Departamento(dnum);

-- Chave da tabela Dependente
ALTER TABLE Dependente ADD CONSTRAINT fk_dep_empregado FOREIGN KEY (empRG) REFERENCES Empregado(RG);

-- Chaves da tabela Trabalha_em
ALTER TABLE Trabalha_em ADD CONSTRAINT fk_trab_empregado FOREIGN KEY (RG) REFERENCES Empregado(RG);
ALTER TABLE Trabalha_em ADD CONSTRAINT fk_trab_projeto FOREIGN KEY (pnum) REFERENCES Projeto(pnum);

-- Chave da tabela Localizacao
ALTER TABLE Localizacao ADD CONSTRAINT fk_loc_depto FOREIGN KEY (dnum) REFERENCES Departamento(dnum);

-- retornos do exercicio
-- retorno 1
select *
from Empregado
where dnum = 5;

-- retorno 2
select *
from Empregado
where salario > 3000;

-- retorno 3
select *
from Empregado
where dnum = 5 and salario > 3000;

-- retorno 4
select *
from Empregado
where (dnum = 5 and salario > 3000) or (dnum = 4 and salario > 2000);

-- retorno 5
select pnome, salario
from Empregado;

-- retorno 6
select pnome, salario
from Empregado
where dnum = 5;

-- retorno 7
select rg
from Empregado
where (dnum = 5)

union

select supRG
from Empregado
where (dnum = 5);

-- retorno 8
select distinct E.pnome -- seleciona o pnome da tabela de empregados a partir do resulta desta juncao
from Empregado AS E
INNER JOIN Dependente AS D ON E.pnome = D.dep_nome; -- juntar as tabelas empregado (apelidado de E) e depedentende(apelidada de D)
-- um inner join cria uma tabela temporaria combinando apenas as linhas que satisfazem a condicao de juncao 

-- retorno 9
select E.pnome, D.dep_nome
from Empregado AS E
CROSS JOIN Dependente AS D; -- essa instrucao diz ao bd para pegar a primeira linha da tabela
-- e combina-la com todas(produto cartesiano q fiz na algebra relacional)

-- retorno 10
select E.pnome, E.unome, D.dep_nome
from Empregado AS E
INNER JOIN Dependente AS D ON E.RG = D.empRG;

-- retorrno 11
select D.dnome, E.pnome, E.unome
from Empregado AS E 
INNER JOIN Departamento AS D ON E.RG = D.gerRG;

-- retorno 12
select dnome, localizacao
from Departamento 
NATURAL JOIN Localizacao; -- juncao natural

-- retorno 13
select E.pnome, E.unome, P.pnome
from Empregado AS E
INNER JOIN Trabalha_em AS T ON E.RG = T.RG 
INNER JOIN Projeto AS P ON T.pnum = P.pnum
ORDER BY E.pnome, E.unome, P.pnome;


-- retorno 14
select distinct E.pnome, E.unome -- distinct garante q cada empregado seja listado apenas uma vez
from Empregado AS E
INNER JOIN Trabalha_em AS T ON E.RG = T.RG
INNER JOIN Projeto AS P ON T.pnum = P.pnum
where p.dnum = 5;


-- retorno 15
select COUNT(*) AS num_empregados -- count() é uma funcao de agregacao que conta numero de linhas correspondem a um criterio, o * é todas as linhas
from Empregado;

-- retorno 16
select dnum AS num_departamento,
COUNT(*) AS quantdd_empregados
from Empregado
GROUP BY dnum -- instrui o bd para primeiro organizar todas as linhas da tabela empegado onde cada grupo contem mesmo valor dnum
ORDER BY dnum; -- organiza o resultado final em ordem crescente

-- retorno 17
select dnum AS num_departamento,
AVG(salario) AS media_salario -- calcular media
from Empregado
GROUP BY dnum
ORDER BY dnum;

-- retorno 18
select E.pnome, E.unome, E.rua, E.cidade, E.estado
from Empregado AS E
INNER JOIN Departamento AS D ON E.dnum = D.dnum
where D.dnome = 'Pesquisa';

-- retorno 19
select P.pnum AS num_projeto, P.dnum AS num_departamento, E.pnome AS nome_gerente, E.sexo AS sexo_gerente
from Projeto AS P 
INNER JOIN Departamento AS D ON P.dnum = D.dnum
INNER JOIN Empregado AS E ON D.gerRG = E.RG
where P.localizacao = 'Londrina';













