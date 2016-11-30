CREATE OR REPLACE FUNCTION pg_size_object(
    objectName TEXT
) RETURNS CHARACTER VARYING AS $$

DECLARE
    objectName  ALIAS FOR $1;
    queryString TEXT;
    returnData  RECORD;
BEGIN
    queryString := ''||
        'SELECT
            COUNT(*) OVER(),
            relpages,
            relname,
            relkind,
            reltuples,
            pg_size_pretty(pg_total_relation_size(relname::text)) AS size
        FROM pg_class
        WHERE ' ||
            'relname = \''||objectName||'\'';

    EXECUTE queryString INTO returnData;

    IF returnData.count IS NULL THEN
        RAISE EXCEPTION 'Object not found: % \n', objectName;
    END IF;

    RETURN 'Object: '|| returnData.relname ||
           ' | Type: ' || returnData.relkind ||
           ' | Entries: ' || returnData.reltuples ||
           ' | Pages: '|| returnData.relpages ||
           ' | Size: ' ||returnData.size;
END;
$$ LANGUAGE plpgsql;
