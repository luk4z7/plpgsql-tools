CREATE OR REPLACE FUNCTION pg_get_definition_tables_json(
    schema CHARACTER VARYING
) RETURNS TEXT AS $$
DECLARE
    schema ALIAS FOR $1;
BEGIN
	RETURN (
		SELECT array_to_json(array_agg(row_to_json(data))) FROM (
			SELECT
				oid AS oid,
				nspname AS schema_name,
				nspowner AS owner_id,
				(
					SELECT array_to_json(array_agg(row_to_json(class)))
					FROM (
						SELECT
							oid AS oid,
							relnamespace AS namespace_oid,
							relkind AS relation_kind,
							relname AS relation_name,
							(
								SELECT array_to_json(array_agg(row_to_json(attr)))
								FROM (
									SELECT
										a.attrelid AS class_oid,
										a.attname AS attr_name,
										a.attnum AS attr_num,
										t.typname AS type_name,
										(
											SELECT n.nspname
											FROM pg_namespace n
											WHERE n.oid = t.typnamespace
										) AS type_schema,
										t.oid AS type_oid,
										COALESCE((
											SELECT (a.attnum = ANY(indkey))
											FROM pg_index i
											WHERE indrelid = a.attrelid AND indisprimary
										), false) AS is_primary_key
									FROM pg_attribute a
									INNER JOIN pg_type t
										ON a.atttypid = t.oid
								) attr
								WHERE
									attr.class_oid = class.oid AND
									attr.attr_num > 0
							) AS columns,
							(
								SELECT array_to_json(array_agg(row_to_json(ind)))
								FROM (
									SELECT
										i.indexrelid AS index_oid,
										i.indrelid AS class_oid,
										ic.relname AS index_name,
										(
											SELECT indexdef
											FROM pg_indexes
											WHERE
												indexname = ic.relname AND
												tablename = class.relname AND
												schemaname = namespace.nspname
										) AS index_def
									FROM pg_index i
									INNER JOIN pg_class ic
										ON ic.oid = i.indexrelid
									WHERE i.indisprimary = false
								) ind
								WHERE
									ind.class_oid = class.oid
							) AS indexes
						FROM pg_class class
						WHERE class.relkind IN ('r', 'i')
					) class
					WHERE class.namespace_oid = namespace.oid
				) AS classes,
				(
					SELECT array_to_json(array_agg(row_to_json(pgtype)))
					FROM (
						SELECT
							pgtype.oid AS oid,
							pgtype.typnamespace AS namespace_oid,
							pgtype.typtype AS type_type,
							pgtype.typname AS type_name,
							(
								SELECT array_to_json(array_agg(row_to_json(enum)))
								FROM (
									SELECT
										oid AS oid,
										enumtypid AS type_oid,
										enumlabel AS name
									FROM pg_enum
								) enum
								WHERE
									enum.type_oid = pgtype.oid
							) AS enums,
							(
								SELECT array_to_json(array_agg(row_to_json(attr)))
								FROM (
									SELECT
										a.attrelid AS class_oid,
										a.attname AS attr_name,
										a.attnum AS attr_num,
										t.typname AS type_name,
										(
											SELECT n.nspname
											FROM pg_namespace n
											WHERE n.oid = t.typnamespace
										) AS type_schema,
										t.oid AS type_oid
									FROM pg_attribute a
									INNER JOIN pg_type t
										ON a.atttypid = t.oid
								) attr
								WHERE
									attr.class_oid = pgtype.typrelid AND
									attr.attr_num > 0
							) AS attributes
						FROM pg_type pgtype
						LEFT JOIN pg_class class
							ON class.oid = pgtype.typrelid
						WHERE
							(pgtype.typtype = 'e') OR
							(pgtype.typtype = 'c' AND class.relkind = 'c')
					) pgtype
					WHERE pgtype.namespace_oid = namespace.oid
				) AS types,
				(
					SELECT array_to_json(array_agg(row_to_json(proc)))
					FROM (
						SELECT
							proc.oid AS oid,
							proc.pronamespace AS namespace_oid,
							proc.proname AS function_name,
							pg_get_function_arguments(proc.oid) AS function_arguments,
							pg_get_functiondef(proc.oid) AS function_def
						FROM pg_proc proc
						WHERE proc.proisagg = false
						AND proc.proname NOT LIKE schema ||'%'
						AND proc.prolang IN (
							SELECT oid FROM pg_language WHERE lanname IN ('plpgsql', 'sql')
						)
					) proc
					WHERE proc.namespace_oid = namespace.oid
				) AS functions,
				(
					SELECT array_to_json(array_agg(row_to_json(extension)))
					FROM (
						SELECT
							ext.oid AS oid,
							ext.extnamespace AS namespace_oid,
							ext.extname AS extension_name
						FROM pg_extension ext
					) extension
					WHERE extension.namespace_oid = namespace.oid
				) AS extensions
			FROM pg_namespace namespace
			WHERE
				namespace.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast', ''||schema||'')
		) data
	);
END;
$$ LANGUAGE plpgsql;