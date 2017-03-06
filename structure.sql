DROP TABLE IF EXISTS helper_functions;
CREATE TABLE helper_functions (
    function VARCHAR,
	description TEXT,
	parameters TEXT[],
	return TEXT
);
TRUNCATE helper_functions;

-- Descriptions
INSERT INTO helper_functions VALUES('pg_get_definition_tables_json()', 'Return all metadata of tables in the specific schema', ARRAY['schema CHARACTER VARYING'], 'TEXT');
INSERT INTO helper_functions VALUES('pg_search_table()', 'Return all tables that match a name of table or column', ARRAY['keyword CHARACTER VARYING'], 'CHARACTER VARYING');
INSERT INTO helper_functions VALUES('pg_show_activity()', 'Show activity of all users and transactions in all databases', ARRAY[''], 'TEXT');
INSERT INTO helper_functions VALUES('pg_show_larger_object()', 'Show size of all objects in database', ARRAY['size INTEGER (in bytes)'], 'CHARACTER VARYING');
INSERT INTO helper_functions VALUES('pg_show_size_databases()', 'Show size of all databases', ARRAY[''], 'CHARACTER VARYING');
INSERT INTO helper_functions VALUES('pg_show_tables_with_oid_lo()', 'Show all tables with column type oid or lo', ARRAY[''], 'CHARACTER VARYING');
INSERT INTO helper_functions VALUES('pg_size_object()', 'Show information about object, size, entries, type, pages', ARRAY['objectName TEXT'], 'CHARACTER VARYING');
INSERT INTO helper_functions VALUES('pg_terminate_backend()', 'Terminate processes by status', ARRAY['status CHARACTER VARYING'], 'BOOLEAN');
INSERT INTO helper_functions VALUES('pg_terminate_backend_all()', 'Terminate all processes except the that executing the function', ARRAY[''], 'BOOLEAN');
INSERT INTO helper_functions VALUES('pg_truncate_larger_tables()', 'Truncate all data of large tables, WARNING, don\'t execute this function in production', ARRAY['size INTEGER (in bytes)'], 'BOOLEAN');
INSERT INTO helper_functions VALUES('pg_truncate_tables_with_search()', 'Truncate all tables with ilike, WARNING, don\'t execute this function in production', ARRAY['schema TEXT', 'key for search TEXT', 'preview BOOLEAN'], 'VOID');

-- Executing the functions
\i ./pg_get_definition_tables_json.sql
\i ./pg_search_table.sql
\i ./pg_show_activity.sql
\i ./pg_show_larger_object.sql
\i ./pg_show_size_databases.sql
\i ./pg_show_tables_with_oid_lo.sql
\i ./pg_size_object.sql
\i ./pg_terminate_backend.sql
\i ./pg_terminate_backend_all.sql