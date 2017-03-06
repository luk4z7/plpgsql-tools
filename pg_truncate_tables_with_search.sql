CREATE OR REPLACE FUNCTION pg_truncate_tables_with_search(IN _schema TEXT, IN _parttionbase TEXT, preview BOOLEAN)
    RETURNS VOID
LANGUAGE plpgsql AS $$
DECLARE
    row RECORD;
BEGIN
    FOR row IN
    SELECT
        table_schema,
        table_name
    FROM
        information_schema.tables
    WHERE
        table_type = 'BASE TABLE' AND
        table_schema = _schema AND
        table_name ILIKE (_parttionbase || '%')
    LOOP
        IF preview = FALSE THEN
            EXECUTE 'TRUNCATE ' || quote_ident(row.table_schema) || '.' || quote_ident(row.table_name) || ' CASCADE';
        END IF;
        RAISE INFO 'TRUNCATE %', quote_ident(row.table_schema) || '.' || quote_ident(row.table_name) || ' MODO PREVIEW: ' || preview;
    END LOOP;
END;
$$;