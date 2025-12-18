# Checklist: Database Documentation

This checklist ensures that the application's database schema is properly documented according to the project rules.

## ✅ Verification Steps

| # | Check | Command / Verification Method | Expected Result |
|---|---|---|---|
| 1 | **Documentation File Exists** | Check for the existence of `docs/dev/DATABASE_SCHEMA.md`. | The file must exist if the app uses a database. |
| 2 | **Database Info** | Open the `DATABASE_SCHEMA.md` file and check the "Database Information" section. | Must contain the correct database name and version, matching the values in `DatabaseHelper.java`. |
| 3 | **All Tables Listed** | Compare the list of tables in `DATABASE_SCHEMA.md` with the `CREATE TABLE` statements in `DatabaseHelper.java`. | All tables defined in the code must be documented in the markdown file. |
| 4 | **Column Details** | For each table, review the "Columns" section. | All columns must be listed with their correct `Data Type`, `Constraints`, and a clear `Description`. |
| 5 | **Keys and Indexes** | For each table, review the "Indexes" section. | All primary keys, foreign keys, and indexes must be documented. |
| 6 | **Relationships** | For each table, review the "Relationships" section. | All foreign key relationships between tables must be clearly described. |

## 📝 Review Notes

- A well-documented database schema is essential for team collaboration and for the AI assistant to perform accurate data-related tasks.
- If the schema changes (e.g., in a database migration), this documentation **must** be updated accordingly.
