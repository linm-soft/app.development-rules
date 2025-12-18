# ☕ Java Code Organization

## Class Structure Order

```java
public class ExampleActivity extends AppCompatActivity {
    
    // 1. Constants
    private static final String TAG = "ExampleActivity";
    private static final int REQUEST_CODE = 100;
    
    // 2. Static fields
    
    // 3. Instance fields - UI components
    private TextView tvTitle;
    private Button btnSave;
    private RecyclerView recyclerList;
    
    // 4. Instance fields - Data
    private DatabaseHelper databaseHelper;
    private List<Item> items;
    
    // 5. Instance fields - Launchers/Callbacks
    private ActivityResultLauncher<Intent> pickerLauncher;
    
    // 6. Lifecycle methods (in order)
    @Override
    protected void onCreate(Bundle savedInstanceState) { }
    
    @Override
    protected void onStart() { }
    
    @Override
    protected void onResume() { }
    
    @Override
    protected void onPause() { }
    
    @Override
    protected void onStop() { }
    
    @Override
    protected void onDestroy() { }
    
    // 7. Override methods
    @Override
    public void onBackPressed() { }
    
    // 8. Public methods
    public void refreshData() { }
    
    // 9. Private methods - Setup/Init
    private void initViews() { }
    private void setupListeners() { }
    
    // 10. Private methods - Business logic
    private void loadData() { }
    private void saveData() { }
    
    // 11. Private methods - UI updates
    private void updateUI() { }
    private void showLoading() { }
    
    // 12. Inner classes/interfaces
    private class ItemAdapter extends RecyclerView.Adapter { }
}
```

## Model Class Structure

```java
public class Alarm {
    
    // 1. Constants
    public static final int REPEAT_ONCE = 0;
    public static final int REPEAT_DAILY = 1;
    
    // 2. Private fields
    private long id;
    private String name;
    private int hour;
    private int minute;
    private boolean enabled;
    
    // 3. Constructors
    public Alarm() { }
    
    public Alarm(String name, int hour, int minute) {
        this.name = name;
        this.hour = hour;
        this.minute = minute;
        this.enabled = true;
    }
    
    // 4. Getters & Setters (grouped by field)
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    // 5. Helper/Utility methods
    public String getTimeFormatted() {
        return String.format(Locale.getDefault(), "%02d:%02d", hour, minute);
    }
    
    public boolean isDoubleTapEnabled() {
        return (dismissGesture & GESTURE_DOUBLE_TAP) != 0;
    }
    
    // 6. Object methods
    @Override
    public String toString() { }
    
    @Override
    public boolean equals(Object o) { }
    
    @Override
    public int hashCode() { }
}
```

## Database Helper Structure

```java
public class DatabaseHelper extends SQLiteOpenHelper {
    
    // 1. Constants
    private static final String DATABASE_NAME = "app.db";
    private static final int DATABASE_VERSION = 1;
    
    // Table names
    private static final String TABLE_ALARMS = "alarms";
    
    // Column names
    private static final String COL_ID = "id";
    private static final String COL_NAME = "name";
    
    // 2. Singleton instance
    private static DatabaseHelper instance;
    
    // 3. Constructor (private for singleton)
    private DatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
    
    public static synchronized DatabaseHelper getInstance(Context context) {
        if (instance == null) {
            instance = new DatabaseHelper(context.getApplicationContext());
        }
        return instance;
    }
    
    // 4. Override methods
    @Override
    public void onCreate(SQLiteDatabase db) { }
    
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) { }
    
    // 5. CRUD methods - Create
    public long insertAlarm(Alarm alarm) { }
    
    // 6. CRUD methods - Read
    public Alarm getAlarmById(long id) { }
    public List<Alarm> getAllAlarms() { }
    
    // 7. CRUD methods - Update
    public int updateAlarm(Alarm alarm) { }
    
    // 8. CRUD methods - Delete
    public int deleteAlarm(long id) { }
    
    // 9. Helper methods
    private Alarm cursorToAlarm(Cursor cursor) { }
}
```
