/*
===============================================
Criar Banco de Dados e Schemas
===============================================

Propósito do Script:
Este script cria um novo banco de dados chamado 'DataWarehouse' após verificar se ele já existe.
Se o banco de dados existir, ele será excluído e recriado.
Além disso, o script cria três schemas dentro do banco de dados: 'bronze', 'silver' e 'gold'.

⚠️ AVISO:
A execução deste script irá excluir completamente o banco de dados 'DataWarehouse' se ele existir.
Todos os dados do banco de dados serão permanentemente apagados.
Prossiga com cautela e certifique-se de ter backups adequados antes de rodar este script.
*/

USE master;
GO

-- Excluir e recriar o banco de dados 'DataWarehouse'
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Criar o banco de dados 'DataWarehouse'
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Criar Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
