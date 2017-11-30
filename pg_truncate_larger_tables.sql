CREATE OR REPLACE FUNCTION pg_truncate_larger_tables(
    size INTEGER
) RETURNS BOOL AS $$
DECLARE
    size        ALIAS FOR $1;
    records     RECORD;
    consulta    TEXT;
    execution   TEXT;

BEGIN

    consulta := 'SELECT * FROM (' ||
                'SELECT ' ||
                    'relpages as tretre,
                    relname AS objectname,
                    relkind AS objecttype,
                    reltuples AS "#entries", pg_size_pretty(relpages::bigint*8*1024) AS size
                FROM pg_class
                WHERE relpages >= '||size||'
                ORDER BY ' ||
                'relpages DESC' ||
    ') AS CV;';

    FOR records IN EXECUTE consulta LOOP
        execution := 'TRUNCATE ' || records.objectname || ' CASCADE';
        IF records.objecttype = 'r' AND records.objectname <> 'pg_largeobject' THEN
            EXECUTE execution;
		   RAISE NOTICE 'removing table: % size: %', records.objectname, records.size;
        END IF;
    END LOOP;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;