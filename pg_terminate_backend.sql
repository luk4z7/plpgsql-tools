CREATE OR REPLACE FUNCTION pg_terminate_backend(
    status CHARACTER VARYING DEFAULT ''
) RETURNS BOOLEAN AS $$
DECLARE
    status   ALIAS FOR $1;
    records RECORD;
BEGIN
    FOR records IN SELECT pid, datname, usename FROM pg_stat_activity WHERE state = status
    LOOP
        RAISE NOTICE 'Process kill in database: % - pid: % - username: %', records.datname, records.pid, records.usename;
        PERFORM pg_terminate_backend(records.pid);
    END LOOP;
    RETURN true;
END;
$$ LANGUAGE plpgsql;