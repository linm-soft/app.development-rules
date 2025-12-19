# 📋 Naming Conventions

[← Back to Implementation](../)

---

## File Naming

| Type | Pattern | Example |
|------|---------|---------|
| Activity | `[Feature]Activity.java` | `AlarmRingActivity.java` |
| Fragment | `Main[Feature].java` | `MainSchedule.java` |
| Adapter | `[Entity]Adapter.java` | `AlarmAdapter.java` |
| Service | `[Feature]Service.java` | `AlarmService.java` |
| Receiver | `[Feature]Receiver.java` | `BootReceiver.java` |
| Helper | `[Feature]Helper.java` | `AlarmHelper.java` |
| Model | `[Entity].java` | `Alarm.java` |
| Utils | `[Feature]Utils.java` | `DialogUtils.java` |

## Layout File Naming

| Type | Pattern | Example |
|------|---------|---------|
| Activity | `activity_[feature].xml` | `activity_alarm_ring.xml` |
| Fragment | `main_[feature].xml` | `main_schedule.xml` |
| Dialog | `dialog_[action].xml` | `dialog_add_alarm.xml` |
| List Item | `item_[entity].xml` | `item_alarm.xml` |
| Custom View | `view_[name].xml` | `view_time_picker.xml` |
| Include/Shared | `layout_[name].xml` | `layout_header.xml` |

## Resource Naming

| Type | Pattern | Example |
|------|---------|---------|
| Icons | `ic_[name]` | `ic_alarm`, `ic_settings` |
| Backgrounds | `bg_[name]` | `bg_button`, `bg_card` |
| Selectors | `selector_[name]` | `selector_day_toggle` |
| Colors | `[category]_[variant]` | `text_primary`, `button_danger` |
| Dimensions | `[type]_[size]` | `spacing_normal`, `text_size_large` |
| Strings | `[screen]_[element]` | `alarm_title`, `dialog_confirm` |
| Styles | `[Component].[Variant]` | `Button.Primary`, `Text.Title` |

## View ID Naming

| Component | Prefix | Example |
|-----------|--------|---------|
| Button | `btn` | `btnSave`, `btnCancel` |
| TextView | `tv` | `tvTitle`, `tvMessage` |
| EditText | `et` | `etName`, `etPhone` |
| ImageView | `iv` | `ivIcon`, `ivAvatar` |
| ImageButton | `btn` | `btnBack`, `btnDelete` |
| RecyclerView | `recycler` | `recyclerAlarms` |
| LinearLayout | `layout` | `layoutHeader` |
| CardView | `card` | `cardAlarm` |
| Switch/Toggle | `switch` / `toggle` | `switchEnabled`, `toggleMon` |
| CheckBox | `cb` | `cbVibrate` |
| SeekBar | `seek` | `seekVolume` |
| ProgressBar | `progress` | `progressLoading` |
| FloatingActionButton | `fab` | `fabAdd` |
| View (divider) | `divider` / `view` | `dividerTop` |
| Row/Container | `row` | `rowAlarmSound` |
