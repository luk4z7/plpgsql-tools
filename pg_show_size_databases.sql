CREATE OR REPLACE FUNCTION pg_show_size_databases() RETURNS CHARACTER VARYING AS $$
DECLARE
    queryString TEXT;
    returnData  TEXT DEFAULT '';
    records     RECORD;
BEGIN
    queryString := '' ||
               'SELECT ' ||
                   'datname, ' ||
                   'pg_size_pretty(pg_database_size(datname))  ' ||
               'FROM pg_database ' ||
                   'WHERE ' ||
                        'datistemplate = false ' ||
                        'ORDER BY pg_size_pretty';

    FOR records IN EXECUTE queryString LOOP

    	returnData := returnData || ''||
            'Database: '|| rpad(records.datname, 60, ' ') ||
            ' | Size: ' || rpad(records.pg_size_pretty, 12, ' ') || '\n';

    END LOOP;

    RETURN returnData;
END;
$$ LANGUAGE plpgsql;