CREATE OR REPLACE FUNCTION pg_terminate_backend_all()
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $function$
DECLARE
  records RECORD;
BEGIN
    FOR records IN SELECT pid, datname, usename FROM pg_stat_activity WHERE pid <> pg_backend_pid()
    LOOP
        RAISE NOTICE 'Process kill in database: % - pid: % - username: %', records.datname, records.pid, records.usename;
        PERFORM pg_terminate_backend(records.pid);
    END LOOP;
RETURN true;
END;
$function$;