# UI Resource Workflow Guidelines

[← Back to AI Guidelines](../ai-guidelines.md)

## 🎨 UI Resource Management Workflow

### 📚 Universal Documentation Pattern
For any project, reference these standard documentation files:
- **Android UI Architecture:** `[project]/DOCS/android/architecture.md`
- **iOS UI Architecture:** `[project]/DOCS/ios/architecture.md`
- **Android Setup Guide:** `[project]/DOCS/android/setup-guide.md`
- **iOS Setup Guide:** `[project]/DOCS/ios/setup-guide.md`

### 🔧 Advanced Resource Tools
- **[Text Extraction & Theme HTML](../implementation/text-theme-resource-management.md)** - Extract text resources and generate HTML theme editors

### Resource Creation Standards
1. **Colors**: Use theme-based color system
2. **Dimensions**: Follow Material Design spacing scale  
3. **Strings**: Maintain multi-language support
4. **Icons**: Vector drawables preferred
5. **Animations**: Use consistent duration/easing

### File Naming Conventions
```
Colors: color_[purpose]_[variant]
Dimensions: dimen_[component]_[property]  
Strings: string_[screen]_[element]_[action]
Drawables: ic_[category]_[name]_[size]
Layouts: layout_[type]_[purpose]
```

### Resource Organization Structure
```
res/
  values/
    colors.xml (theme colors only)
    dimens.xml (standard spacing)
    strings.xml (app strings)
    styles.xml (component styles)
  values-night/ (dark theme variants)
  drawable/ (vector icons)
  layout/ (screen layouts)
  menu/ (navigation/context menus)
```

## 📱 Component Resource Standards

### Color System Integration
- Primary colors from theme attributes only
- Surface colors for containers and backgrounds
- On-surface colors for text and icons
- Accent colors for interactive elements
- Error/success colors from system palette

### Typography Standards  
- Use Material Design type scale
- Consistent line heights and letter spacing
- Proper contrast ratios for accessibility
- Support for dynamic text sizing

### Spacing & Layout Standards
- 8dp grid system for all measurements
- Standard margins: 16dp, 24dp, 32dp
- Component padding: 8dp, 12dp, 16dp
- Consistent elevation values across components

## 🔄 Resource Update Workflow

### Adding New Resources
1. **Check existing**: Verify resource doesn't already exist
2. **Follow naming**: Use established naming conventions
3. **Add to theme**: Include theme variants if applicable
4. **Test accessibility**: Verify contrast and sizing
5. **Update documentation**: Add to resource reference

### Modifying Existing Resources
1. **Impact analysis**: Check all usages before changing
2. **Backward compatibility**: Maintain for existing components
3. **Theme consistency**: Ensure changes work across themes
4. **Test all variants**: Light/dark theme validation
5. **Update references**: Fix any broken dependencies

### Resource Cleanup
1. **Usage audit**: Find unused resources monthly
2. **Duplicate detection**: Merge similar resources
3. **Naming alignment**: Update to current conventions
4. **Performance impact**: Minimize resource file sizes
5. **Version control**: Track resource changes properly

## 🎯 Quality Standards

### Resource Quality Criteria
- **Consistency**: Same naming pattern across all files
- **Accessibility**: Proper contrast and sizing
- **Performance**: Optimized file sizes and formats
- **Maintainability**: Clear organization and documentation
- **Scalability**: Support for different screen sizes

### Validation Checklist
- [ ] Follows naming conventions
- [ ] Supports light/dark themes  
- [ ] Meets accessibility standards
- [ ] No duplicate resources
- [ ] Proper fallback values
- [ ] Documentation updated

## 📊 Resource Monitoring

### Usage Tracking
Monitor which resources are:
- **Frequently used**: Keep and optimize
- **Rarely used**: Consider removal  
- **Duplicated**: Consolidate into single resource
- **Outdated**: Update to current standards
- **Missing**: Add based on usage patterns

### Performance Metrics
- Resource load times
- Memory usage of drawable resources
- Build time impact of resource changes
- APK size impact of new resources
- Theme switching performance

### Maintenance Schedule
- **Weekly**: Check for new unused resources
- **Monthly**: Full resource audit and cleanup
- **Quarterly**: Update to latest Material Design standards
- **Release**: Validate all resources before shipping
- **Post-release**: Monitor resource usage analytics