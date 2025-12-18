# 💾 Database Migration Rule

## 🚨 **CRITICAL AUTOMATION RULE**

**When AI detects database schema changes, ALWAYS auto-apply this migration pattern.**

## 📋 **Detection Triggers**

### Code Changes That Require Migration:
- New column added to existing table in `onCreate()`
- New table added to `onCreate()`
- ContentValues using new field names
- UPDATE/INSERT queries with new columns
- Model classes with new fields

### Detection Commands:
```powershell
# Check for new columns in CREATE TABLE statements
Get-Content "app\src\main\java\**\DatabaseHelper.java" | Select-String "ADD COLUMN|ALTER TABLE"

# Check for ContentValues with new fields
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String "ContentValues.*put.*new_field" -Context 2,2

# Check if DATABASE_VERSION needs update
Get-Content "app\src\main\java\**\DatabaseHelper.java" | Select-String "DATABASE_VERSION.*="
```

## ⚡ **Auto-Migration Workflow**

### Step 1: Detect Schema Changes
```java
// BEFORE (version 6)
CREATE TABLE news_articles (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    // ... existing columns
);

// AFTER (user added new columns)
CREATE TABLE news_articles (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    status TEXT DEFAULT 'unread',        // NEW
    updated_at INTEGER DEFAULT 0,        // NEW
    // ... existing columns
);
```

### Step 2: Auto-Apply Migration Pattern

**AI MUST automatically:**

1. **Increment DATABASE_VERSION**:
   ```java
   // Change from:
   private static final int DATABASE_VERSION = 6;
   // To:
   private static final int DATABASE_VERSION = 7; // Updated for [description]
   ```

2. **Add Migration Block**:
   ```java
   if (oldVersion < 7) {
       // Add [description] to [table_name]
       LogHelper.d(TAG, "Adding [new_columns] to [table_name]...");
       
       try {
           db.execSQL("ALTER TABLE " + TABLE_NAME + " ADD COLUMN new_column1 TEXT DEFAULT 'default_value'");
           db.execSQL("ALTER TABLE " + TABLE_NAME + " ADD COLUMN new_column2 INTEGER DEFAULT 0");
           LogHelper.d(TAG, "Added [new_columns] successfully");
       } catch (Exception e) {
           LogHelper.e(TAG, "Error adding columns to [table_name]: " + e.getMessage());
       }
   }
   ```

### Step 3: Insert Before Performance Indexes
**ALWAYS place new migration before `createPerformanceIndexes(db)` call**

```java
if (oldVersion < [current_version - 1]) {
    // Previous migrations...
}

if (oldVersion < [new_version]) {
    // NEW MIGRATION HERE
    LogHelper.d(TAG, "Adding [description]...");
    
    try {
        // Migration SQL statements
        LogHelper.d(TAG, "[description] completed successfully");
    } catch (Exception e) {
        LogHelper.e(TAG, "Error in migration: " + e.getMessage());
    }
}

// Always ensure performance indexes are created/updated
createPerformanceIndexes(db);
```

## 🛠️ **Migration Templates**

### Add Single Column:
```java
if (oldVersion < X) {
    try {
        db.execSQL("ALTER TABLE " + TABLE_NAME + " ADD COLUMN column_name DATA_TYPE DEFAULT 'default_value'");
        LogHelper.d(TAG, "Added column_name to " + TABLE_NAME);
    } catch (Exception e) {
        LogHelper.e(TAG, "Error adding column: " + e.getMessage());
    }
}
```

### Add Multiple Columns:
```java
if (oldVersion < X) {
    try {
        db.execSQL("ALTER TABLE " + TABLE_NAME + " ADD COLUMN status TEXT DEFAULT 'active'");
        db.execSQL("ALTER TABLE " + TABLE_NAME + " ADD COLUMN updated_at INTEGER DEFAULT " + System.currentTimeMillis());
        LogHelper.d(TAG, "Added status and updated_at columns to " + TABLE_NAME);
    } catch (Exception e) {
        LogHelper.e(TAG, "Error adding columns to " + TABLE_NAME + ": " + e.getMessage());
    }
}
```

### Add New Table:
```java
if (oldVersion < X) {
    db.execSQL("CREATE TABLE IF NOT EXISTS " + TABLE_NEW + " (" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT," +
            "name TEXT NOT NULL," +
            "created_at INTEGER NOT NULL" +
            ")");
    LogHelper.d(TAG, "Created " + TABLE_NEW + " table");
}
```

### Complex Migration (Recreate Table):
```java
if (oldVersion < X) {
    // Backup data
    db.execSQL("ALTER TABLE " + TABLE_NAME + " RENAME TO " + TABLE_NAME + "_backup");
    
    // Create new table with updated schema
    db.execSQL("CREATE TABLE " + TABLE_NAME + " (" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT," +
            "new_column TEXT," +
            "existing_column TEXT" +
            ")");
    
    // Migrate data
    db.execSQL("INSERT INTO " + TABLE_NAME + " (existing_column) " +
            "SELECT existing_column FROM " + TABLE_NAME + "_backup");
    
    // Drop backup
    db.execSQL("DROP TABLE " + TABLE_NAME + "_backup");
    
    LogHelper.d(TAG, "Migrated " + TABLE_NAME + " with new schema");
}
```

## ⚠️ **Common Migration Scenarios**

### 1. Adding Status Tracking
**When**: User adds status field to existing records
**Migration**:
```java
db.execSQL("ALTER TABLE news_articles ADD COLUMN status TEXT DEFAULT 'unread'");
db.execSQL("ALTER TABLE news_articles ADD COLUMN updated_at INTEGER DEFAULT " + System.currentTimeMillis());
```

### 2. Adding User Association
**When**: Adding user_id to existing tables
**Migration**:
```java
db.execSQL("ALTER TABLE table_name ADD COLUMN user_id INTEGER DEFAULT 0");
```

### 3. Adding Feature Flags
**When**: New boolean features added
**Migration**:
```java
db.execSQL("ALTER TABLE table_name ADD COLUMN is_favorite INTEGER DEFAULT 0");
db.execSQL("ALTER TABLE table_name ADD COLUMN is_downloaded INTEGER DEFAULT 0");
```

### 4. Adding Metadata
**When**: Analytics or tracking data needed
**Migration**:
```java
db.execSQL("ALTER TABLE table_name ADD COLUMN last_accessed INTEGER DEFAULT 0");
db.execSQL("ALTER TABLE table_name ADD COLUMN access_count INTEGER DEFAULT 0");
```

## 🔍 **Validation Checklist**

Before applying auto-migration:
- ✅ **DATABASE_VERSION incremented** by 1
- ✅ **Migration block added** with correct version check
- ✅ **LogHelper.d() statements** for success/error tracking
- ✅ **try-catch block** around all SQL statements
- ✅ **Default values specified** for new columns
- ✅ **Migration placed before** `createPerformanceIndexes(db)`
- ✅ **Comment explains** what the migration does
- ✅ **No breaking changes** to existing data

## 🚨 **Never Do**

❌ **Change existing column types** (requires complex migration)  
❌ **Remove columns** without data migration  
❌ **Change PRIMARY KEY structure**  
❌ **Skip version numbers** (always increment by 1)  
❌ **Forget try-catch** around SQL execution  
❌ **Hardcode timestamps** (use System.currentTimeMillis())  

## 🔄 **Auto-Apply Trigger**

**AI should automatically apply this rule when detecting:**

1. New fields in ContentValues
2. New columns in CREATE TABLE statements
3. UPDATE queries with non-existent columns
4. Model classes with new properties that should persist

**No user confirmation needed for standard migrations** - this is boilerplate that should always be done.

---

**Example Success Case:**

```
🔍 Detected: ContentValues.put("status", "read") in NewsService.java
🔍 Detected: status column missing in news_articles CREATE TABLE
✅ Auto-applied migration: DATABASE_VERSION 6 → 7
✅ Added migration block: ALTER TABLE news_articles ADD COLUMN status TEXT DEFAULT 'unread'
✅ Migration ready for next app update
```