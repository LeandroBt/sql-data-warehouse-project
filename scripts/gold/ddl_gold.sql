/*
============================================================
DDL Script: Criar Views Gold
============================================================

Propósito do Script:
   Este script cria views para a camada Gold no data warehouse.
   A camada Gold representa as tabelas finais de dimensões e fatos (Star Schema).

   Cada view realiza transformações e combina dados da camada Silver
   para produzir um dataset limpo, enriquecido e pronto para uso.

Uso:
   - Essas views podem ser consultadas diretamente para análises e relatórios.
============================================================
*/

/* ============================================================
   Criação da View: gold.dim_customers
   Descrição: Dimensão de clientes unificando dados do CRM e ERP
   ============================================================ */
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW gold.dim_customers; -- Remove a view caso já exista
GO

CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Chave substituta (surrogate key)
	ci.cst_id AS customer_id,	                         -- ID do cliente no CRM
	ci.cst_key AS customer_number,                      -- Código único do cliente
	ci.cst_firstname AS first_name,	                   -- Primeiro nome
	ci.cst_lastname AS last_name,                       -- Sobrenome
	la.cntry AS country,                                -- País do cliente
	ci.cst_marital_status AS marital_status,	           -- Estado civil
	CASE 
		WHEN ci.cst_gndr != 'n/a' 
			THEN ci.cst_gndr                             -- Gênero do CRM (prioritário)
		ELSE COALESCE(ca.gen, 'n/a')                     -- Caso CRM não tenha, pega do ERP
	END AS gender,
	ca.bdate AS birthdate,                              -- Data de nascimento (ERP)
	ci.cst_create_date AS create_date                   -- Data de criação do cliente
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
	   ON ci.cst_key = ca.cid                           -- Join com ERP (dados adicionais de cliente)
LEFT JOIN silver.erp_loc_a101 AS la
	   ON ci.cst_key = la.cid                           -- Join para país/localização
GO


/* ============================================================
   Criação da View: gold.dim_products
   Descrição: Dimensão de produtos com dados do CRM e ERP
   ============================================================ */
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products; -- Remove a view caso já exista
GO

CREATE VIEW gold.dim_products AS 
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key do produto
	pn.prd_id AS product_id,	                        -- ID do produto (CRM)
	pn.prd_key AS product_number,	                    -- Código único do produto
	pn.prd_nm AS product_name,	                        -- Nome do produto
	pn.cat_id AS category_id,	                        -- ID da categoria
	pc.cat AS category,	                                -- Categoria (ERP)
	pc.subcat AS subcategory,	                        -- Subcategoria (ERP)
	pc.maintenance,	                                    -- Indicador de manutenção (ERP)
	pn.prd_cost AS cost,	                            -- Custo do produto
	pn.prd_line AS product_line,                        -- Linha do produto
	CAST(pn.prd_start_dt AS DATE) AS start_date         -- Data inicial de vigência
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
	   ON pn.cat_id = pc.id                             -- Join para categorias de produto
WHERE prd_end_dt IS NULL                                -- Considera apenas produtos ativos
GO


/* ============================================================
   Criação da View: gold.fact_sales
   Descrição: Fato de vendas, integrando clientes e produtos
   ============================================================ */
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales; -- Remove a view caso já exista
GO

CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num AS order_number,     -- Número do pedido
	pr.product_key,                     -- Chave do produto (dim_products)
	cu.customer_key,                    -- Chave do cliente (dim_customers)
	sd.sls_order_dt AS order_date,      -- Data do pedido
	sd.sls_ship_dt AS shipping_date,    -- Data de envio
	sd.sls_due_dt AS due_date,          -- Data de vencimento
	sd.sls_sales AS sales_amout,        -- Valor da venda
	sd.sls_quantity AS quantity,        -- Quantidade vendida
	sd.sls_price AS price               -- Preço unitário
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products pr
	   ON sd.sls_prd_key = pr.product_number -- Relaciona produto vendido com dimensão
LEFT JOIN gold.dim_customers cu
	   ON sd.sls_cust_id = cu.customer_id    -- Relaciona cliente com dimensão
GO
