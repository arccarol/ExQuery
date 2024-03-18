CREATE DATABASE ExQuery
GO 
USE ExQuery

CREATE TABLE Produto (
codigo INT NOT NULL,
nome VARCHAR(100),
valor NUMERIC(7, 2)
PRIMARY KEY(codigo)
)
GO 
CREATE TABLE Entrada (
codigo_transacao INT NOT NULL,
codigo_produto INT NOT NULL,
quantidade INT,
valor_total NUMERIC(7,2)
PRIMARY KEY(codigo_transacao)
FOREIGN KEY(codigo_produto) REFERENCES Produto(codigo)
)
GO
CREATE TABLE Saida (
codigo_transacao INT NOT NULL,
codigo_produto INT NOT NULL,
quantidade INT,
valor_total NUMERIC(7,2)
PRIMARY KEY(codigo_transacao)
FOREIGN KEY(codigo_produto) REFERENCES Produto(codigo)
)

DECLARE @query	VARCHAR(200),
		@codigo		INT,
		@nome	VARCHAR(40),
		@valor	DECIMAL(7,2)
SET @codigo = 1
SET @nome = 'Caderno'
SET @valor = 20.30
/*Query Dinâmica*/
SET @query = 'INSERT INTO produto VALUES ('+CAST(@codigo AS VARCHAR(5))
				+','''+ @nome + ''', ' + CAST(@valor AS VARCHAR(10)) + ')'
PRINT @query
EXEC (@query)
 
CREATE PROCEDURE sp_insereTransacao (
    @codigo CHAR(1),
    @codigo_Transacao INT,
    @codigo_Produto INT,
    @quantidade INT,
    @erro VARCHAR(100) OUTPUT
)
AS
BEGIN
    DECLARE @valor_Total DECIMAL(7,2)
    
    IF @codigo NOT IN ('E', 'S')
    BEGIN
        SET @erro = 'Código inválido.'
        RETURN
    END
    -- Calcula o valor total da transação
    SET @valor_Total = (SELECT valor * @quantidade FROM produto WHERE codigo = @codigo_Produto)
    -- Insere na tabela de entrada se o código for 'e', senão, insere na tabela de saída
    IF @codigo = 'E'
    BEGIN
        INSERT INTO Entrada (codigo_Transacao, codigo_Produto, quantidade, valor_Total)
        VALUES (@codigo_Transacao, @codigo_Produto, @quantidade, @valor_Total)
    END
    ELSE
    BEGIN
        INSERT INTO Saida (codigo_Transacao, codigo_Produto, quantidade, valor_Total)
        VALUES (@codigo_Transacao, @codigo_Produto, @quantidade, @valor_Total)
    END
    SET @erro = NULL
END
 
DECLARE @out1 VARCHAR(100)
EXEC sp_insereTransacao 'E', 1, 1, 5, @out1 OUTPUT
PRINT @out1
 
DECLARE @out2 VARCHAR(100)
EXEC sp_insereTransacao 'S', 2, 2, 3, @out2 OUTPUT
PRINT @out2