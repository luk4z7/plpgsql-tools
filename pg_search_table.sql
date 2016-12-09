CREATE OR REPLACE FUNCTION pg_search_table(
    keyword CHARACTER VARYING
) RETURNS CHARACTER VARYING AS $$
DECLARE
    keyword     ALIAS FOR $1;
    queryString TEXT;
    returnData  TEXT DEFAULT '';
    records     RECORD;
    final       TEXT;
    quantity    TEXT;
    tableName   TEXT;

BEGIN

    -- A consulta é feira filtrando campos e tabelas que podem ser identificados no banco
    -- a partir da keyword especificada
    queryString := ''||
        'SELECT
            *,
            DENSE_RANK() OVER(ORDER BY relname) AS rank,
            COUNT(*) OVER(PARTITION BY relname) AS count,
            ROW_NUMBER() OVER(PARTITION BY relname) AS row
        FROM (
            SELECT
                c.relname,
                a.attname,
                pg_catalog.format_type(a.atttypid, a.atttypmod) AS Datatype
            FROM pg_catalog.pg_attribute a
                INNER JOIN pg_stat_user_tables c ON a.attrelid = c.relid
            WHERE c.relname LIKE \'%'|| keyword ||'%\' AND
                  a.attnum > 0 AND NOT a.attisdropped
            UNION
            SELECT
                c.relname,
                a.attname,
                pg_catalog.format_type(a.atttypid, a.atttypmod) AS Datatype
            FROM pg_catalog.pg_attribute a
                INNER JOIN pg_stat_user_tables c ON a.attrelid = c.relid
            WHERE a.attname LIKE \'%'|| keyword ||'%\' AND
                  a.attnum > 0 AND
                  NOT a.attisdropped
            GROUP BY
                relname,
                attname,
                Datatype
            ORDER BY
                relname,
                attname
        ) AS cv';

    FOR records IN EXECUTE queryString LOOP

        -- Gerando quebra de linha sempre quando a tabela possuir somente um campo
        if records.count = 1 THEN
            final := '\n'||rpad('-', 160, '-')||'\n';
        ELSE
            -- Geradando quebra de linha quando o contador for igual ao total de campos da tabela
            IF records.count = records.row THEN
                final := '\n'||rpad('-', 160, '-')||'\n';
            ELSE
                final := '\n';
            END IF;
        END IF;

        -- Informações que são apresentadas somente no inicio de cada tabela retornada
        IF records.row = 1 THEN
            -- Quantidade de campos
            quantity := rpad(records.count::text, 5, ' ');
            -- Nome da tabela
            tableName := '\n' || 'Table: ' || rpad(records.relname, 50, ' ') ||
            '\n'||rpad('-', 160, '-')||'\n';
        ELSE
            quantity := rpad(' ', 5, ' ');
            tableName := '';
        END IF;

        -- Montando a estrutura para retorno
    	returnData := returnData || ''||
    		tableName ||
           	rpad(records.attname, 45, ' ') ||
            ' | ' || rpad(records.Datatype, 30, ' ') ||
            ' ' || quantity || final;
    END LOOP;

    RETURN returnData;
END;
$$ LANGUAGE plpgsql;