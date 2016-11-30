CREATE OR REPLACE FUNCTION pg_show_larger_object(
    size INTEGER
) RETURNS TEXT AS $$
DECLARE
    size        ALIAS FOR $1;
    records     RECORD;
    queryString TEXT;
	returnData  TEXT DEFAULT '';

BEGIN
    queryString := ''||
		'SELECT ' ||
			'cast(relpages as text),
			relname,
			relkind,
			cast(reltuples as text),
			pg_size_pretty(relpages::bigint*8*1024) AS size
		FROM pg_class
		WHERE
			relpages >= '||size||'
		ORDER BY ' ||
			'relpages DESC';

    FOR records IN EXECUTE queryString LOOP

    	returnData := returnData || ''||
    		'Object: '|| rpad(records.relname, 60, ' ') ||
           	' | Type: ' || rpad(records.relkind, 2, ' ') ||
           	' | Entries: ' || rpad(records.reltuples, 15, ' ') ||
           	' | Pages: '|| rpad(records.relpages, 10, ' ') ||
           	' | Size: ' || rpad(records.size, 12, ' ') || '\n';
    END LOOP;
    RETURN returnData;
END;
$$ LANGUAGE plpgsql;