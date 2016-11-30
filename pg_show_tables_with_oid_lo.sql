CREATE OR REPLACE FUNCTION pg_show_tables_with_oid_lo() RETURNS CHARACTER VARYING AS $$
DECLARE
    records     RECORD;
    queryString TEXT;
	returnData  TEXT DEFAULT '';
BEGIN
    queryString := '' ||
                   'SELECT ' ||
                        'nspname,' ||
                        'relname,' ||
                        'attname,' ||
                        'typname
                    FROM pg_type t
                        JOIN pg_attribute a  ON a.atttypid = t.oid
                        JOIN pg_class c      ON a.attrelid = c.oid
                        JOIN pg_namespace n  ON c.relnamespace = n.oid
                    WHERE
                        typname IN  (''oid'',''lo'') AND
                        attname NOT IN (''oid'', ''tableoid'') AND
                        nspname NOT IN (''pg_catalog'', ''pg_toast'', ''information_schema'')';

    FOR records IN EXECUTE queryString LOOP
    	returnData := returnData || ''||
    		'Schema: '|| rpad(records.nspname, 30, ' ') ||
           	' | Table: ' || rpad(records.relname, 45, ' ') ||
           	' | Column: ' || rpad(records.attname, 30, ' ') ||
            ' | Type: ' || rpad(records.typname, 10, ' ') || '\n';
    END LOOP;
    RETURN returnData;
END;
$$ LANGUAGE plpgsql;