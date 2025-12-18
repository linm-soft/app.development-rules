# Database Documentation Standards

## Overview

**When to Apply:** Only when app uses SQLite/Room databases
**User Confirmation Required:** Ask before creating/updating documentation

## Detection Logic

### Skip Rule (No Database)
- No `DatabaseHelper.java` or `*Database.java` files found
- No `@Database` annotations in project
- No SQLite imports detected

### Ask User Confirmation (Has Database)
```
"Detected database usage in {app_name}. 
Create/Update database documentation in docs/dev/DATABASE_SCHEMA.md? (y/n)"
```

**Additional confirmation for updates:**
```
"Database schema changes detected. 
Update docs/dev/DATABASE_SCHEMA.md documentation? (y/n)"
```

## Documentation Structure

### Required File Location
- **Path:** `docs/dev/DATABASE_SCHEMA.md`
- **Create directory** if doesn't exist

### Template Structure

```markdown
# Database Schema: {App Name}

**Last Updated:** {Current Date}

## 1. Database Information
- **Database Name:** `{database_name}.db`
- **Database Version:** `{version}`

## 2. Tables

### Table: `{table_name}`

**Columns:**

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| `id` | `INTEGER` | `PRIMARY KEY AUTOINCREMENT` | Unique identifier |

**Relationships:**
- `table.foreign_key` -> `other_table.id` (ON DELETE CASCADE)

## 3. Performance Indexes

### Single Column Indexes
| Index Name | Table | Column(s) | Purpose |
|------------|-------|-----------|---------|

### Composite Indexes  
| Index Name | Table | Column(s) | Purpose |
|------------|-------|-----------|---------|

## 4. Query Patterns & Performance

### Common Query Patterns
```sql
-- Main queries with optimization notes
SELECT * FROM table WHERE indexed_column = ? ORDER BY indexed_date DESC;
```

### Performance Benefits
- **Query Type:** Expected improvement description
```

## Information to Extract

### From DatabaseHelper/Database Classes
1. **Database name and version**
2. **Table schemas** with columns, types, constraints
3. **Foreign key relationships** 
4. **Indexes created** (single and composite)
5. **Common query patterns** from helper methods

### From DAO Classes (Room)
1. **Query methods** and their SQL patterns
2. **Relationship annotations** (@Relation, @Embedded)
3. **Index definitions** from @Entity annotations

### From Usage Patterns
1. **Frequent WHERE clauses** → Index recommendations
2. **ORDER BY patterns** → Sort optimization
3. **JOIN operations** → Relationship documentation
4. **Performance bottlenecks** → Optimization notes

## Content Examples

### Table Documentation
```markdown
### Table: `news_articles`

**Columns:**

| Column Name | Data Type | Constraints | Description |
|-------------|-----------|-------------|-------------|
| `id` | `INTEGER` | `PRIMARY KEY AUTOINCREMENT` | Unique identifier |
| `title` | `TEXT` | `NOT NULL` | Article title |
| `pub_date` | `INTEGER` | `NOT NULL` | Publication timestamp |
| `is_favorite` | `INTEGER` | `DEFAULT 0` | User favorite flag |

**Relationships:**
- `news_articles.feed_id` -> `news_feeds.id` (ON DELETE CASCADE)
```

### Index Documentation
```markdown
## 3. Performance Indexes

### Single Column Indexes
| Index Name | Table | Column(s) | Purpose |
|------------|-------|-----------|---------|
| `idx_articles_pub_date` | `news_articles` | `pub_date DESC` | Optimize date sorting |
| `idx_articles_favorite` | `news_articles` | `is_favorite` | Optimize favorite filtering |

### Composite Indexes  
| Index Name | Table | Column(s) | Purpose |
|------------|-------|-----------|---------|
| `idx_articles_category_date` | `news_articles` | `category`, `pub_date DESC` | Optimize category + date queries |
```

### Query Pattern Documentation
```markdown
## 4. Query Patterns & Performance

### Common Query Patterns

#### Main Feed Loading
```sql
-- Optimized by: idx_articles_pub_date
SELECT * FROM news_articles ORDER BY pub_date DESC LIMIT 25 OFFSET ?;
```

#### Category Filtering  
```sql
-- Optimized by: idx_articles_category_date
SELECT * FROM news_articles WHERE category = ? ORDER BY pub_date DESC;
```

### Performance Benefits
- **Main Feed:** 10x faster with pub_date index on large datasets
- **Category Filter:** Instant response with composite index
- **Search Queries:** 2-3x improvement with text indexes
```

## Maintenance Guidelines

### When to Update Documentation
1. **Schema changes:** New tables, columns, constraints
2. **Index additions/modifications**
3. **New query patterns** in app code
4. **Performance optimizations**
5. **Database version increments**

### Update Process
1. **Detect changes** in database files
2. **Ask user confirmation** for updates
3. **Preserve existing content** where possible  
4. **Add new sections** for new features
5. **Update version numbers** and dates

### Automation Opportunities
- **Schema extraction** from CREATE TABLE statements
- **Index detection** from CREATE INDEX statements  
- **Query pattern analysis** from DAO/Helper methods
- **Version tracking** from database version constants

## Benefits

### For Development
- **Quick reference** for schema understanding
- **Index guidance** for query optimization  
- **Onboarding support** for new developers
- **Migration planning** for schema changes

### For Maintenance  
- **Performance troubleshooting** 
- **Query optimization** decisions
- **Schema evolution** tracking
- **Documentation consistency**

### For Collaboration
- **Clear database contract** between team members
- **Review guidelines** for database changes
- **Standards enforcement** across projects
