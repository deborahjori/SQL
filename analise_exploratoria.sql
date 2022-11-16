-- Conhecendo os dados nas tabelas

SELECT *
FROM dados_mutuarios LIMIT 10;

SELECT *
FROM emprestimos LIMIT 10;

SELECT *
FROM historicos_banco LIMIT 10;

SELECT *
FROM ids LIMIT 10;

-- Analisando tabela dados_mutuarios
-- Verificando campos duplicados na coluna person_id ( PK )

SELECT 
	person_id,
    COUNT(*) as Qtd_duplicada
FROM dados_mutuarios 
GROUP BY person_id
HAVING COUNT(*) > 1
;

-- Após identificação de campos vazios como duplicados, passamos a seguinte análise:
-- Campos vazios serão transformados em nulos para contagem e verificação total

SELECT
	*
FROM dados_mutuarios
WHERE
	NULLIF(ltrim(rtrim(person_id)), '') IS NULL ;
    
-- Aplicando em todas as colunas

SELECT 
	SUM(person_id_validade) AS person_id_validade,
    SUM(person_age_validade) AS person_age_validade,
	SUM(person_income_validade) AS person_income_validade,
    SUM(person_home_ownership_validade) AS person_home_ownership_validade,
    SUM(person_emp_length_validade) AS person_emp_length_validade
FROM (
		SELECT
			CASE WHEN NULLIF(ltrim(rtrim(person_id)), '') IS NULL THEN 1 ELSE 0 END AS person_id_validade,
			CASE WHEN NULLIF(ltrim(rtrim(person_age)), '') IS NULL THEN 1 ELSE 0 END AS person_age_validade,
			CASE WHEN NULLIF(ltrim(rtrim(person_income)), '') IS NULL THEN 1 ELSE 0 END AS person_income_validade,
			CASE WHEN NULLIF(ltrim(rtrim(person_home_ownership)), '') IS NULL THEN 1 ELSE 0 END AS person_home_ownership_validade,
			CASE WHEN NULLIF(ltrim(rtrim(person_emp_length)), '') IS NULL THEN 1 ELSE 0 END AS person_emp_length_validade
		FROM dados_mutuarios
	 ) AS Tabela_Validacao;

-- Calculando percentual de nulos por coluna 

SELECT 
	SUM(person_id_validade) AS person_id_validade,
    COUNT(person_id_validade) AS person_id_total,
	(SUM(person_id_validade)/COUNT(person_id_validade))* 100 AS person_id_percentual_nulos,
    SUM(person_age_validade) AS person_age_validade,
    COUNT(person_age_validade) AS person_age_total,
	(SUM(person_age_validade)/COUNT(person_age_validade))* 100 AS person_age_percentual_nulos,
    SUM(person_income_validade) AS person_income_validade,
    COUNT(person_income_validade) AS person_income_total,
	(SUM(person_income_validade)/COUNT(person_income_validade))* 100 AS person_income_percentual_nulos,
    SUM(person_home_ownership_validade) AS person_home_ownership_validade,
    COUNT(person_home_ownership_validade) AS person_home_ownership_total,
	(SUM(person_home_ownership_validade)/COUNT(person_home_ownership_validade))* 100 AS person_home_ownership_percentual_nulos, 
	SUM(person_emp_length_validade) AS person_emp_length_validade,
    COUNT(person_emp_length_validade) AS person_emp_length_total,
	(SUM(person_emp_length_validade)/COUNT(person_emp_length_validade))* 100 AS person_emp_length_percentual_nulos
FROM (
		SELECT
			CASE WHEN NULLIF(ltrim(rtrim(person_id)), '') IS NULL THEN 1 ELSE 0 END AS person_id_validade,
			CASE WHEN NULLIF(ltrim(rtrim(person_age)), '') IS NULL THEN 1 ELSE 0 END AS person_age_validade,
			CASE WHEN NULLIF(ltrim(rtrim(person_income)), '') IS NULL THEN 1 ELSE 0 END AS person_income_validade,
			CASE WHEN NULLIF(ltrim(rtrim(person_home_ownership)), '') IS NULL THEN 1 ELSE 0 END AS person_home_ownership_validade,
			CASE WHEN NULLIF(ltrim(rtrim(person_emp_length)), '') IS NULL THEN 1 ELSE 0 END AS person_emp_length_validade
		FROM dados_mutuarios
	 ) AS Tabela_Validacao;

-- PERCENTUAL DE CAMPOS NULOS NAS COLUNAS

SELECT
		(SUM(person_id_validade)/COUNT(person_id_validade))* 100 AS person_id_percentual_nulos,
        (SUM(person_age_validade)/COUNT(person_age_validade))* 100 AS person_age_percentual_nulos,
        (SUM(person_income_validade)/COUNT(person_income_validade))* 100 AS person_income_percentual_nulos,
        (SUM(person_home_ownership_validade)/COUNT(person_home_ownership_validade))* 100 AS person_home_ownership_percentual_nulos, 
        (SUM(person_emp_length_validade)/COUNT(person_emp_length_validade))* 100 AS person_emp_length_percentual_nulos      
		
FROM (
		SELECT
			CASE WHEN NULLIF(ltrim(rtrim(person_id)), '') IS NULL THEN 1 ELSE 0 END AS person_id_validade,
			CASE WHEN NULLIF(ltrim(rtrim(person_age)), '') IS NULL THEN 1 ELSE 0 END AS person_age_validade,
			CASE WHEN NULLIF(ltrim(rtrim(person_income)), '') IS NULL THEN 1 ELSE 0 END AS person_income_validade,
			CASE WHEN NULLIF(ltrim(rtrim(person_home_ownership)), '') IS NULL THEN 1 ELSE 0 END AS person_home_ownership_validade,
			CASE WHEN NULLIF(ltrim(rtrim(person_emp_length)), '') IS NULL THEN 1 ELSE 0 END AS person_emp_length_validade
		FROM dados_mutuarios
	 )AS Tabela_Validacao;
     
-- CALCULANDO MEDIAS DE IDADE E SALÁRIO_ANO

SELECT
	avg(person_age) AS MEDIA_IDADE,
    avg(person_income) AS MEDIA_SALARIAL_ANO,
    avg(person_emp_length) AS MEDIA_ANOS_TRABALHADOS
FROM dados_mutuarios
WHERE 
	person_age >= 1 OR
    person_income >= 1 OR
    person_emp_length >= 1 
 ;


-- QUANTIDADE DE PROPRIEDADES POR NICHO
    
SELECT
	person_home_ownership,    
    COUNT(*) AS QUANTIDADE_TOTAL
FROM dados_mutuarios 
GROUP BY person_home_ownership
ORDER BY QUANTIDADE_TOTAL DESC
;

/* PERCENTUAL POR NICHO */

SELECT DISTINCT
	person_home_ownership,    
	COUNT(*) OVER() AS qtd,
	COUNT(*) OVER(partition by person_home_ownership) AS qtd_total,
	(COUNT(*) OVER(partition by person_home_ownership) / COUNT(*) OVER()) * 100 AS PERCENTUAL
FROM dados_mutuarios;


/* ANALISANDO TABELA EMPRESTIMOS */

SELECT *
FROM emprestimos LIMIT 10;

/* VERIFICANDO DUPLICIDADE E CAMPOS VAZIOS E NULOS */

SELECT 
	loan_id,
    COUNT(*) as Qtd_duplicada
FROM emprestimos 
GROUP BY loan_id
HAVING COUNT(*) > 1
;

SELECT
	*
FROM emprestimos
WHERE
	NULLIF(ltrim(rtrim(loan_id)), '') IS NULL ;

/* QUANTIDADE DE EMPRÉSTIMOS POR MOTIVO */

SELECT
	loan_intent,    
    COUNT(*) AS QUANTIDADE_TOTAL
FROM emprestimos 
GROUP BY loan_intent
ORDER BY QUANTIDADE_TOTAL DESC
;


SELECT DISTINCT
	loan_intent,    
	COUNT(*) OVER() AS qtd,
	COUNT(*) OVER(partition by loan_intent) AS qtd_total,
	(COUNT(*) OVER(partition by loan_intent) / COUNT(*) OVER()) * 100 AS PERCENTUAL
FROM emprestimos;


/* QUANTIDADE POR PONTUAÇÃO */

SELECT
	loan_grade,    
    COUNT(*) AS QUANTIDADE_TOTAL
FROM emprestimos 
GROUP BY loan_grade
ORDER BY QUANTIDADE_TOTAL DESC 
;


/* MAIOR E MENOR VALORES TOTAL EMPRESTIMO */

SELECT
	MAX(loan_amnt) AS MAIOR_VALOR_SOLICITADO,
    MIN(loan_amnt) AS MENOR_VALOR_SOLICITADO
FROM emprestimos 
;

/* VARIAÇÃO TAXA DE JUROS */

SELECT
	MAX(loan_int_rate) AS MAIOR_TAXA,
    MIN(loan_int_rate) AS MENOR_TAXA,
    VARIANCE(loan_int_rate) AS VARIACAO_TAXA,
    --
    AVG(loan_int_rate) AS MEDIA_TAXA
FROM emprestimos 
;

/* VARIAÇÃO TAXA DE JUROS POR MOTIVO DO EMPRÉSTIMO*/

SELECT
	loan_intent,
	MAX(loan_int_rate) AS MAIOR_TAXA,
    MIN(loan_int_rate) AS MENOR_TAXA,
    VARIANCE(loan_int_rate) AS VARIACAO_TAXA,
    AVG(loan_int_rate) AS MEDIA_TAXA
FROM emprestimos 
GROUP BY loan_intent
;

/* INADIMPLÊNCIA*/

SELECT
	loan_status,    
    COUNT(*) AS QUANTIDADE_TOTAL,
    CASE 
		WHEN loan_status = 0 THEN 'BAIXO RISCO'
        WHEN loan_status = 1 THEN 'ALTO RISCO'
		ELSE 'SEM HISTÓRICO'
	END AS RISCO_INADIMPLENCIA
FROM emprestimos 
GROUP BY loan_status
ORDER BY QUANTIDADE_TOTAL DESC 
;


/* ANALISANDO TABELA HISTORICOS_BANCO */

SELECT *
FROM historicos_banco LIMIT 10;

/* RELAÇÃO HISTÓRICO INADIMPLENTE */

SELECT
	cb_person_default_on_file,    
    COUNT(*) AS QUANTIDADE_TOTAL
FROM historicos_banco 
GROUP BY cb_person_default_on_file
ORDER BY QUANTIDADE_TOTAL DESC 
;


SELECT DISTINCT
	cb_person_default_on_file,    
	COUNT(*) OVER() AS qtd,
	COUNT(*) OVER(partition by cb_person_default_on_file) AS qtd_total,
	(COUNT(*) OVER(partition by cb_person_default_on_file) / COUNT(*) OVER()) * 100 AS PERCENTUAL
FROM historicos_banco;


/* RELAÇÃO TEMPO CLIENTE EM ANOS ( MAIS ANTIGO, MAIS NOVO, MÉDIA) */

SELECT 
	AVG(cb_person_cred_hist_length) AS MEDIA_ANOS_CLIENTE,
    MAX(cb_person_cred_hist_length) AS MAIS_ANTIGO,
    MIN(cb_person_cred_hist_length) AS MAIS_NOVO
FROM historicos_banco 
;


	

