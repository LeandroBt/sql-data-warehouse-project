-- ===============================================
-- Camada Silver: Tabelas consolidadas para análise
-- ===============================================

-- ================================
-- Tabelas CRM (Customer Relationship Management)
-- ================================

-- Criando tabela de informações de clientes
-- Se já existir, remove para recriar
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
    cst_id INT,                          -- ID único do cliente
    cst_key NVARCHAR(50),                -- Chave de integração
    cst_firstname NVARCHAR(50),          -- Primeiro nome
    cst_lastname NVARCHAR(50),           -- Sobrenome
    cst_marital_status NVARCHAR(50),     -- Estado civil
    cst_gndr NVARCHAR(50),               -- Gênero
    cst_create_date DATE,                -- Data de criação no sistema original
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- Data de carga no Data Warehouse
);

-- Criando tabela de informações de produtos
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info(
    prd_id INT,                           -- ID do produto
	cat_id NVARCHAR(50),				  -- ID da categoria
    prd_key NVARCHAR(50),                 -- Chave de integração
    prd_nm NVARCHAR(50),                  -- Nome do produto
    prd_cost INT,                         -- Custo do produto
    prd_line NVARCHAR(50),                -- Linha do produto
    prd_start_dt DATETIME,                -- Data de início da validade
    prd_end_dt DATETIME,                  -- Data de fim da validade
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- Data de carga no Data Warehouse
);

-- Criando tabela de detalhes de vendas
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details(
    sls_ord_num NVARCHAR(50),            -- Número do pedido
    sls_prd_key NVARCHAR(50),            -- Chave do produto vendido
    sls_cust_id INT,                      -- ID do cliente
    sls_order_dt DATE,                     -- Data do pedido
    sls_ship_dt DATE,                      -- Data de envio
    sls_due_dt DATE,                       -- Data de vencimento
    sls_sales INT,                        -- Valor da venda
    sls_quantity INT,                     -- Quantidade vendida
    sls_price INT,                        -- Preço unitário
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- Data de carga no Data Warehouse
);

-- ================================
-- Tabelas ERP (Enterprise Resource Planning)
-- ================================

-- Informações adicionais de clientes ERP
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12(
    cid NVARCHAR(50),                     -- Chave do cliente
    bdate DATE,                           -- Data de nascimento
    gen NVARCHAR(50),                     -- Gênero
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- Data de carga no Data Warehouse
);

-- Localização dos clientes ERP
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101(
    cid NVARCHAR(50),                     -- Chave do cliente
    cntry NVARCHAR(50),                   -- País
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- Data de carga no Data Warehouse
);

-- Categoria de produtos ERP
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2(
    id NVARCHAR(50),                      -- ID do produto
    cat NVARCHAR(50),                     -- Categoria principal
    subcat NVARCHAR(50),                  -- Subcategoria
    maintenance NVARCHAR(50),             -- Informação de manutenção
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- Data de carga no Data Warehouse
);
