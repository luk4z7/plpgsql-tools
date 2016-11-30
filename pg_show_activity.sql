CREATE OR REPLACE FUNCTION pg_show_activity()
    RETURNS TEXT AS $$
DECLARE
    records     RECORD;
    queryString TEXT;
	returnData  TEXT DEFAULT '';
BEGIN
    queryString := 'select * from pg_stat_activity';
    FOR records IN EXECUTE queryString LOOP
    	returnData := returnData || ''||
    		'datname: '|| rpad(records.datname, 40, ' ') ||
           	' | pid: ' || rpad(records.pid::text, 6, ' ') ||
           	' | usename: ' || rpad(records.usename, 20, ' ') ||
           	' | application: '|| rpad(records.application_name, 25, ' ') ||
           	' | state: ' || rpad(records.state, 21, ' ') || '\n';
    END LOOP;
    RETURN returnData;
END;
$$ LANGUAGE plpgsql;