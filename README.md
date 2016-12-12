### Getting started

```bash
git clone https://github.com/luk4z7/plpgsql-tools.git
```

**Execute the file `init.sh` and enter your name of database for deploy**

```bash

https://github.com/luk4z7/plpgsql-tools for the canonical source repository
Helpers for PL/pgSQL applications

 ____  _        __           ____   ___  _
|  _ \| |      / / __   __ _/ ___| / _ \| |
| |_) | |     / / '_ \ / _` \___ \| | | | |
|  __/| |___ / /| |_) | (_| |___) | |_| | |___
|_|   |_____/_/ | .__/ \__, |____/ \__\_\_____|
                |_|    |___/

PostgreSQL
Enter the database name:

```

Then just connect to the database and run a query
```sql
SELECT * FROM helper_functions;
```

```bash
            function             |                                      description                                      |          parameters           |      return
---------------------------------+---------------------------------------------------------------------------------------+-------------------------------+-------------------
 pg_get_definition_tables_json() | Return all metadata of tables in the specific schema                                  | {"schema CHARACTER VARYING"}  | TEXT
 pg_search_table()               | Return all tables that match a name of table or column                                | {"keyword CHARACTER VARYING"} | CHARACTER VARYING
 pg_show_activity()              | Show activity of all users and transactions in all databases                          | {""}                          | TEXT
 pg_show_larger_object()         | Show size of all objects in database                                                  | {"size INTEGER (in bytes)"}   | CHARACTER VARYING
 pg_show_size_databases()        | Show size of all databases                                                            | {""}                          | CHARACTER VARYING
 pg_show_tables_with_oid_lo()    | Show all tables with column type oid or lo                                            | {""}                          | CHARACTER VARYING
 pg_size_object()                | Show information about object, size, entries, type, pages                             | {"objectName TEXT"}           | CHARACTER VARYING
 pg_terminate_backend()          | Terminate processes by status                                                         | {"status CHARACTER VARYING"}  | BOOLEAN
 pg_terminate_backend_all()      | Terminate all processes except the that executing the function                        | {""}                          | BOOLEAN
 pg_truncate_larger_tables()     | Truncate all data of large tables, WARNING, don't execute this function in production | {"size INTEGER (in bytes)"}   | BOOLEAN
```