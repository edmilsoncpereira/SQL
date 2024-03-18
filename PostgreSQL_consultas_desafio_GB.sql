create DATABASE BIBLIOTECA
	WITH
    owner = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;
;
-- criando tabela editora
CREATE TABLE EDITORA (
  IdEditora SERIAL PRIMARY KEY,
  Nome VARCHAR(255) NOT NULL UNIQUE);
--inserindo dados na tabela editora
INSERT INTO EDITORA (
  Nome
) 
VALUES 
	('Bookman'), 
  	('Edgard Blusher'), 
    ('Nova Terra'), 
  	('Brasport');
-- criando tabela categoria
CREATE TABLE CATEGORIA (
  IdCategoria SERIAL PRIMARY KEY,
  Nome VARCHAR(255) NOT NULL UNIQUE);
-- inserindo dados na tabela categoria
INSERT INTO CATEGORIA (
  Nome
) 
VALUES 
	('Banco de Dados'),
	('HTML'),
	('Java'),
	('PHP');
-- criando tabela autor
CREATE TABLE AUTOR (
  IdAutor SERIAL PRIMARY KEY,
  Nome VARCHAR(255) NOT NULL);
-- inserindo dados na tabela autor
INSERT INTO AUTOR (
  Nome
) 
VALUES 
	('Waldemar Setzer'),
	('Flávio Soares'),
	('John Watson'),
	('Rui Rossi dos Santos'),
	('Antonio Pereira de Resende'),
	('Claudiney Calixto Lima'),
	('Evandro Carlos Teruel'),
	('Ian Graham'),
	('Fabrício Xavier'),
	('Pablo Dalloglio');
-- criando tabela livro
--drop table livro
CREATE TABLE LIVRO (
  IdLivro SERIAL PRIMARY KEY, -- QUAL A DIFERENÇA DE USAR INTEGER OU INT?
  IdEditora INTEGER NOT NULL,
  IdCategoria INTEGER NOT NULL,
  FOREIGN key (IdEditora) -- chave estrangeira impede que sejam adicionados editora e categoria que não exista na tabela Editora e Categoria, evita inconsistência no banco de dados
  REFERENCES editora (ideditora),
  FOREIGN key (idcategoria) -- chave estrangeira impede que sejam adicionados editora e categoria que não exista na tabela Editora e Categoria
  REFERENCES categoria (IdCategoria),
  Nome VARCHAR(255) NOT NULL UNIQUE);
-- inserindo dados na tabela livro
INSERT INTO Livro (
  ideditora, idcategoria, Nome
) 
VALUES 
	(2,1,'Banco de Dados – 1 Edição'),
	(1,1,'Oracle DataBase 11G Administração'),
	(3,3,'Programação de Computadores em Java'),
	(4,3,'Programação Orientada a Aspectos em Java'),
	(4,2,'HTML5 – Guia Prático'),
	(3,2,'XHTML: Guia de Referência para Desenvolvimento na Web'),
	(1,4,'PHP para Desenvolvimento Profissional'),
	(2,4,'PHP com Programação Orientada a Objetos');
-- criando tabela AUTOR
CREATE TABLE LIVRO_AUTOR (
  idlivro INTEGER NOT NULL,
  idautor INTEGER NOT NULL,
  FOREIGN KEY (idlivro)
  REFERENCES LIVRO (idlivro),
  FOREIGN KEY (idautor)
  REFERENCES AUTOR (idautor),
  PRIMARY KEY (idlivro, idautor)
  );
-- inserir dados na tabela livro_autor
insert INTO LIVRO_AUTOR (
	idlivro, 
	idautor) 
    VALUES 
    (1,1),
	(1,2),
	(2,3),
	(3,4),
	(4,5),
	(4,6),
	(5,7),
	(6,8),
	(7,9),
	(8,10);
--crie tabela aluno
create table ALUNO (
  IdAluno serial PRIMARY key,
  Nome VARCHAR(255) NOT NULL
  );
--inserindo dados na tabela Alunos
INSERT INTO ALUNO (
  Nome)
  VALUES(
    'Mario'),
	('João'),
	('Paulo'),
	('Pedro'),
	('Maria');
--criandot tb emprestimos
create table EMPRESTIMO (
	IdEmprestimo serial PRIMARY key,
  	IdAluno INTEGER NOT NULL,
  FOREIGN KEY (idaluno)
  references aluno (idaluno),
  Data_Emprestimo DATE Not NULL DEFAULT CURRENT_DATE,
  Data_Devolucao DATE NOT NULL,
  Valor NUMERIC (10,2),
  Devolvido CHAR(1) NOT NULL);
  --inserindo dados tb emprestimo
insert into emprestimo (IdAluno, data_emprestimo, data_devolucao, valor, devolvido)
  		VALUES (1,'2023-05-02','2023-05-12',10,'S'),
			   (1,'2023-04-23','2023-05-03',5,'N'),
			   (2,'2023-05-10','2023-05-20',12,'N'),
			   (3,'2023-05-10','2023-05-20',8,'S'),
			   (4,'2023-05-05','2023-05-15',15,'N'),
               (4,'2023-05-07','2023-05-17',20,'S'),
			   (4,'2023-05-08','2023-05-18',5,'S');
--criacao tb EMPRESTIMO_LIVRO
CREATE TABLE EMPRESTIMO_LIVRO (
  idemprestimo INT NOT NULL,
  FOREIGN KEY (idemprestimo)
  REFERENCES emprestimo (idemprestimo),
  idlivro INT NOT NULL,
  FOREIGN KEY (idlivro)
  REFERENCES livro (idlivro),
  PRIMARY KEY (idemprestimo, idlivro));
 --inserindo dados em tb emprestimo_livro
 INSERT INTO emprestimo_livro (idemprestimo, idlivro)
	VALUES	
         (1,1),
         (2,4),
         (2,3),
         (3,2),
         (3,7),
         (4,5),
         (5,4),
         (6,6),
         (6,1),
         (7,8);
--criando indices | o indice é sobre o id emprestimo ou sobre a data? como o indice na criacao de tabela funciona? não sai no output... ele vai ordernar os dados?
create INDEX idx_emprestimo on emprestimo (data_emprestimo, data_devolucao);

--CONSULTAS SIMPLES
SELECT  nome
from autor
order by nome 

SELECT nome
from aluno
where nome like 'P%'

select nome
from livro
where idcategoria in (SELECT idcategoria from categoria where nome in ('Banco de Dados','Java'))

SELECT nome
from livro
where ideditora in (SELECT ideditora from editora where nome = 'Bookman')

select*
from emprestimo
where data_emprestimo BETWEEN '2023-05-05' and '2023-05-10' 

select*
from emprestimo
where data_emprestimo not BETWEEN '2023-05-05' and '2023-05-10' 

select*
from emprestimo
where devolvido = 'S'

--CONSULTAS COM AGRUPAMENTO SIMPLES
SELECT COUNT(*) qtde_de_livros
from livro

select sum(valor)
from emprestimo

SELECT round(AVG(valor),2)
from emprestimo

SELECT MAX(valor)
from emprestimo

SELECT MIN(valor)
from emprestimo

select sum(valor)
from emprestimo
where data_emprestimo BETWEEN '2023-05-05' and '2023-05-10' 

select COUNT(*)
from emprestimo
where data_emprestimo BETWEEN '2023-05-01' and '2023-05-05'

--Consultas com JOIN
--drop view vw_livro_catergoria_editora
create view vw_livro as 
select aa.nome as Livro, bb.nome as Categoria, cc.nome as Editora 
from livro aa
left join categoria bb
on aa.idcategoria = bb.idcategoria
left join editora cc
on aa.ideditora = cc.ideditora

create view vw_livro_autor as 
select aa.nome as Livro, cc.nome as Autor 
from livro aa
left join livro_autor bb
on aa.idlivro = bb.idlivro
left join autor cc
on bb.idautor = cc.idautor

SELECT Livro 
from vw_livro_autor
where Autor = 'Ian Graham' 

SELECT aa.nome as Aluno, bb.data_emprestimo, bb.data_devolucao
from aluno aa
LEFT join emprestimo bb
on aa.idaluno=bb.idaluno

select aa.nome as livros_emprestados
from livro aa
left join emprestimo_livro bb
on aa.idlivro=bb.idlivro
where bb.idemprestimo is not null

--CONSULTAS COM AGRUPAMENTO + JOIN
SELECT aa.nome as Editora, count(idlivro) qtde_livros
from editora aa
LEFT join livro bb
on aa.ideditora=bb.ideditora
group by 1

SELECT aa.nome as Categoria, count(idlivro) qtde_livros
from categoria aa
LEFT join livro bb
on aa.idcategoria=bb.idcategoria
group by 1

SELECT aa.nome as Autor, count(bb.idlivro) qtde_livros
from autor aa
LEFT join livro_autor bb
on aa.idautor=bb.idautor
group by 1

SELECT aa.nome as Aluno, count(bb.idemprestimo) qtde_emprestimo
from aluno aa
LEFT join emprestimo bb
on aa.idaluno=bb.idaluno
group by 1

SELECT aa.nome as Aluno, sum(COALESCE(bb.valor,0)) vl_emprestimo
from aluno aa
LEFT join emprestimo bb
on aa.idaluno=bb.idaluno
group by 1

SELECT aa.nome as Aluno, sum(COALESCE(bb.valor,0)) vl_emprestimo
from aluno aa
LEFT join emprestimo bb
on aa.idaluno=bb.idaluno
group by 1
HAVING sum(COALESCE(bb.valor,0)) > 7

--CONSULTAS COMANDOS DIVERSOS
SELECT UPPER(nome) as Aluno
from aluno
order by aluno DESC

SELECT*
from emprestimo
where to_char(data_emprestimo, 'yyyy-mm') = '2023-04' 

SELECT*, case when devolvido = 'S' then 'Devolução completa' else 'Em atraso' end status_devolucao
from emprestimo

SELECT SUBSTRING(nome,5,6) caracteres
from autor

SELECT valor, to_char(data_emprestimo, 'TMMonth','NLS_DATE_LANGUAGE=Portuguese') as "Mês"
from emprestimo

--SUBCONSULTAS
SELECT data_emprestimo, valor
from emprestimo
where valor > (SELECT avg(valor)
from emprestimo
)

with emprestimo_qtd_livro as (
SELECT idemprestimo, COUNT(idemprestimo) over (PARTITION by idemprestimo) as qtd_livro
from emprestimo_livro
)  
SELECT data_emprestimo, valor
from emprestimo
where idemprestimo in (SELECT DISTINCT idemprestimo
from emprestimo_qtd_livro
where qtd_livro > 1
)

SELECT data_emprestimo, valor
from emprestimo
where valor < (SELECT sum(valor)
from emprestimo
)

-- QUERY database
SELECT * 
FROM emprestimo;