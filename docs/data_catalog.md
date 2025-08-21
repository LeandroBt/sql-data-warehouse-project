                                          Dicionário de Dados da Camada Gold

A Camada Gold é a representação de dados em nível para negócios, estruturada para dar suporte a casos de uso analíticos e de relatórios.
Ela consiste em tabelas de dimensão e tabelas fato para métricas específicas de negócio.

1. gold.dim_customers

Propósito: Armazena detalhes dos clientes enriquecidos com dados demográficos e geográficos.

| Nome da Coluna  | Tipo de Dado | Descrição                                                                                      |
| ----------------| ------------ | ---------------------------------------------------------------------------------------------- |
| customer_key    | INT          | Chave que identifica exclusivamente cada registro de cliente na tabela                         |
| customer_id     | INT          | Identificador numérico único atribuído a cada cliente.                                         |
| customer_number | NVARCHAR(50) | Identificador alfanumérico que representa o cliente, usado para rastreamento e referência.     |
| first_name      | NVARCHAR(50) | O primeiro nome do cliente, conforme registrado no sistema.                                    |
| last_name       | NVARCHAR(50) | O sobrenome ou nome de família do cliente.                                                     |
| country         | NVARCHAR(50) | O país de residência do cliente (ex.: 'Austrália').                                            |
| marital_status  | NVARCHAR(50) | O estado civil do cliente (ex.: 'Casado', 'Solteiro').                                         |
| gender          | NVARCHAR(50) | O gênero do cliente (ex.: 'Masculino', 'Feminino', 'n/a').                                     |
| birthdate       | DATE         | A data de nascimento do cliente, formatada como AAAA-MM-DD (ex.: 1971-10-06).                  |
| create_date     | DATE         | A data e hora em que o registro do cliente foi criado no sistema.                              |

2. gold.dim_products

Propósito: Fornece informações sobre os produtos e seus atributos.

| Nome da Coluna        | Tipo de Dado | Descrição                                                                                                        |
| --------------------- | ------------ | ---------------------------------------------------------------------------------------------------------------- |
| product_key           | INT          | Chave que identifica exclusivamente cada registro de produto na tabela de dimensão de produtos.                  |
| product_id            | INT          | Identificador único atribuído ao produto para rastreamento e referência interna.                                 |
| product_number        | NVARCHAR(50) | Código alfanumérico estruturado que representa o produto, frequentemente usado para categorização ou inventário. |
| product_name          | NVARCHAR(50) | Nome descritivo do produto, incluindo detalhes como tipo, cor e tamanho.                                         |
| category_id           | NVARCHAR(50) | Identificador único para a categoria do produto, vinculando-o à sua classificação de alto nível.                 |
| category              | NVARCHAR(50) | Classificação mais ampla do produto (ex.: Bicicletas, Componentes) para agrupar itens relacionados.              |
| subcategory           | NVARCHAR(50) | Classificação mais detalhada do produto dentro da categoria, como tipo de produto.                               |
| maintenance_required  | NVARCHAR(50) | Indica se o produto requer manutenção (ex.: 'Sim', 'Não').                                                       |
| cost                  | INT          | O custo ou preço base do produto, medido em unidades monetárias.                                                 |
| product_line          | NVARCHAR(50) | A linha ou série específica de produto à qual pertence (ex.: Estrada, Montanha).                                 |
| start_date            | DATE         | A data em que o produto passou a estar disponível para venda ou uso, armazenada no sistema.                      |

3. gold.fact_sales

Propósito: Armazena dados transacionais de vendas para fins analíticos.

| Nome da Coluna | Tipo de Dado | Descrição                                                                                     |
| -------------- | ------------ | --------------------------------------------------------------------------------------------- |
| order_number  | NVARCHAR(50) | Identificador alfanumérico único para cada pedido de venda (ex.: 'SO54496').                  |
| product_key   | INT          | Chave que vincula o pedido à tabela de dimensão de produtos.                                  |
| customer_key  | INT          | Chave que vincula o pedido à tabela de dimensão de clientes.                                  |
| order_date    | DATE         | Data em que o pedido foi realizado.                                                           |
| shipping_date | DATE         | Data em que o pedido foi enviado ao cliente.                                                  |
| due_date      | DATE         | Data em que o pagamento do pedido venceu.                                                     |
| sales_amount  | INT          | Valor monetário total da venda para o item de linha, em unidades inteiras de moeda (ex.: 25). |
| quantity      | INT          | Número de unidades do produto solicitado para o item de linha (ex.: 1).                       |
| price         | INT          | Preço por unidade do produto para o item de linha, em unidades inteiras de moeda (ex.: 25).   |
