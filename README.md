# 🐾 PetVida - Sistema de Gerenciamento Clínico Veterinário

Este repositório contém o script de banco de dados SQL para o sistema **PetVida**, uma solução robusta para o gerenciamento de uma clínica veterinária. O projeto foi estruturado para cobrir desde o cadastro de tutores e pacientes até o controle de consultas, receitas médicas e permissões de acesso ao sistema.

---

## 📊 Estrutura do Banco de Dados

O banco de dados é composto por **6 tabelas principais**, totalmente relacionadas e validadas com restrições (`Constraints`):

* **`tutores`**: Cadastro de clientes com validação de `CPF` único.
* **`veterinarios`**: Registro dos profissionais da clínica com `CRMV` único.
* **`animais`**: Dados dos pets, utilizando restrição de `ENUM` para limitar as espécies permitidas (`Cachorro`, `Gato`, `Ave`, `Outros`).
* **`consultas`**: Histórico de atendimentos vinculando animal, veterinário, data e custos.
* **`medicamentos`**: Catálogo de remédios disponíveis para tratamentos.
* **`prescricoes`**: Tabela associativa (N:M) que liga as consultas aos medicamentos receitados, utilizando chaves primárias compostas.

### 📐 Modelo Relacional (DER)
ainda nao fiz pois meu SQL Bugou

## 🚀 Recursos Implementados no Script

Além da estrutura básica (DDL) e do povoamento inicial (DML/Seed), o projeto conta com recursos avançados de banco de dados:

### 1. Consultas Avançadas (DQL)
* Relatórios completos utilizando múltiplos `JOINs`.
* Análise de faturamento total e por profissional (`GROUP BY` e `ORDER BY`).
* Filtros dinâmicos com regras de negócio (`HAVING` e `LEFT JOIN` para identificar animais sem consultas).

### 2. Automação e Regras de Negócio
* **Stored Procedure (`agendar_consulta`)**: Automatiza a marcação de consultas, realizando uma validação prévia se o animal realmente existe no banco antes de efetuar o agendamento.
* **Stored Function (`total_consultas_animal`)**: Retorna de forma rápida e dinâmica o histórico de quantidade de consultas de um pet específico.

### 3. Segurança e Controle de Acesso (DCL)
Implementação de controle estrito de acessos baseado em papéis (RBAC):
* **Recepcionista**: Permissões de leitura e escrita apenas em dados cadastrais e consultas.
* **Veterinário**: Acesso de leitura geral e permissão de escrita *apenas* na coluna de diagnóstico.
* **Admin**: Controle total do banco de dados.

---

## 🛠️ Como Executar o Projeto

1. Certifique-se de ter o **MySQL Server** instalado na sua máquina.
2. Clone este repositório ou baixe o arquivo `.sql`.
3. Abra o terminal ou sua ferramenta de preferência (MySQL Workbench, DBeaver, CLI).
4. Execute o script principal para criar o banco de dados, tabelas, realizar a carga de dados de teste (Seed) e criar as procedures/functions.

```sql
source banco.sql;