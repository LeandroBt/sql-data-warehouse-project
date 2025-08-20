/*
====================================================
Verificações de Qualidade (Quality Checks)
====================================================

Propósito do Script:
    Este script executa várias verificações de qualidade para consistência,
    precisão e padronização nos esquemas 'silver'. Inclui verificações de:
    - Chaves primárias nulas ou duplicadas
    - Espaços indesejados em campos de texto
    - Padronização e consistência de dados
    - Intervalos e ordens de datas inválidas
    - Consistência de dados entre campos relacionados

Notas de Uso:
    - Execute estas verificações após o carregamento da camada Silver
    - Investigue e resolva quaisquer discrepâncias encontradas durante as verificações
====================================================
*/

----------------------------------------------------
-- Verificando 'silver.crm_cust_info'
----------------------------------------------------

-- Verificar valores NULL ou duplicados na chave primária
-- Expectativa: Nenhum resultado
SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Verificar por espaços indesejados
-- Expectativa: Nenhum resultado
SELECT
    cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Padronização e Consistência de Dados
SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info;

----------------------------------------------------
-- Verificando 'silver.crm_prd_info'
----------------------------------------------------

-- Verificar valores NULL ou duplicados na chave primária
-- Expectativa: Nenhum resultado
SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Verificar por espaços indesejados
-- Expectativa: Nenhum resultado
SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Verificar valores NULL ou negativos em custos
-- Expectativa: Nenhum resultado
SELECT
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Padronização e Consistência de Dados
SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;

----------------------------------------------------
-- Verificando 'silver.crm_prd_info' (datas inválidas)
----------------------------------------------------

-- Verificar ordens de datas inválidas (Data inicial > Data final)
-- Expectativa: Nenhum resultado
SELECT
    *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

----------------------------------------------------
-- Verificando 'silver.crm_sales_details'
----------------------------------------------------

-- Verificar datas inválidas
-- Expectativa: Nenhuma data inválida
SELECT
    NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
   OR LEN(sls_due_dt) != 8
   OR sls_due_dt > 20500101
   OR sls_due_dt < 19000101;

-- Verificar ordens de datas inválidas (Data do pedido > Envio/Vencimento)
-- Expectativa: Nenhum resultado
SELECT
    *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Verificar consistência dos dados: Vendas = Quantidade * Preço
-- Expectativa: Nenhum resultado
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

----------------------------------------------------
-- Verificando 'silver.erp_cust_az12'
----------------------------------------------------

-- Identificar datas fora do intervalo
-- Expectativa: Nenhuma data maior doque o dia atual
SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Padronização e Consistência de Dados
SELECT DISTINCT
    gen
FROM silver.erp_cust_az12;

----------------------------------------------------
-- Verificando 'silver.erp_loc_a101'
----------------------------------------------------

-- Padronização e Consistência de Dados
SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

----------------------------------------------------
-- Verificando 'silver.erp_px_cat_g1v2'
----------------------------------------------------

-- Verificar por espaços indesejados
-- Expectativa: Nenhum resultado
SELECT
    *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);

-- Padronização e Consistência de Dados
SELECT DISTINCT
    maintenance
FROM silver.erp_px_cat_g1v2;
