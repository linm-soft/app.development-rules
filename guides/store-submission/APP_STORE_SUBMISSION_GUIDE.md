# App Store Submission Guide / Hướng Dẫn Nộp App Lên Apple Store

> Complete bilingual guide for submitting iOS apps to Apple App Store
> Hướng dẫn đầy đủ song ngữ để nộp ứng dụng iOS lên Apple App Store

---

## 🌍 Language Selection / Lựa Chọn Ngôn Ngữ

- **[English Guide](#english-guide)** - Complete English instructions
- **[Hướng Dẫn Tiếng Việt](#vietnamese-guide)** - Hướng dẫn đầy đủ tiếng Việt

---

# English Guide

## 🎯 Overview

This guide covers the complete process of submitting iOS apps to the Apple App Store, including preparation, review guidelines, and submission steps.

### Prerequisites Checklist
- [ ] **Apple Developer Account** ($99/year for individuals, $299/year for organizations)
- [ ] **Completed iOS app** with all features working
- [ ] **App tested** on multiple devices and iOS versions
- [ ] **App Store Connect access** with proper permissions
- [ ] **Privacy Policy** and terms of service prepared
- [ ] **App Store assets** (icons, screenshots, descriptions) ready

---

## 📋 Pre-Submission Preparation

### Step 1: Apple Developer Account Setup

#### Individual Developer Account
1. Visit [developer.apple.com](https://developer.apple.com)
2. Click **Account** → **Enroll**
3. Choose **Individual** enrollment
4. Complete identity verification
5. Pay $99 annual fee
6. Wait for approval (usually 24-48 hours)

#### Organization Developer Account
1. Same process but choose **Organization**
2. Requires business verification
3. D-U-N-S Number required
4. $299 annual fee
5. Longer approval process (up to 2 weeks)

### Step 2: App Store Connect Setup

1. **Access App Store Connect**:
   - Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   - Sign in with Apple Developer account

2. **Create New App**:
   - Click **My Apps** → **+** → **New App**
   - Choose **iOS** platform
   - Fill in app information:
     - **Name**: [Your App Name]
     - **Primary Language**: English (or your preference)
     - **Bundle ID**: `com.yourcompany.yourapp` (must match Xcode project)
     - **SKU**: Unique identifier (e.g., `YourApp-iOS-001`)

### Step 3: App Information Setup

#### App Store Listing Template
```
App Name: [Your App Name - max 30 characters]
Subtitle: [Brief description - max 30 characters]
Category: [Choose appropriate category]
Content Rating: [Age rating based on content]
```

#### App Description Template
```
[Your app description should include:]

[Main Value Proposition - What problem does your app solve?]

FEATURES:
• [Feature 1 - Main functionality]
• [Feature 2 - Core capability] 
• [Feature 3 - User benefit]
• [Feature 4 - UI/UX highlight]
• [Feature 5 - Performance benefit]
• [Feature 6 - Additional value]

PRIVACY & SECURITY:
• [Data storage approach]
• [Privacy protection measures]
• [iOS-specific security features]
• [Permission usage explanation]

[Call to action - Why users should download your app]
```

#### Example for Call Blocking Apps:
```
App Name: [Your Call Blocker Name]
Subtitle: Block Unwanted Calls
Category: Utilities
Content Rating: 4+ (Low Maturity)

Description:
Block unwanted calls with [App Name], a powerful iOS app that uses Apple's CallKit framework to provide native call blocking functionality.

FEATURES:
• Block specific phone numbers from calling
• Automatically block unknown numbers
• View detailed call statistics
• Modern iOS design with SwiftUI
• Call history tracking
• Secure local data storage

PRIVACY & SECURITY:
• All data stored locally on your device
• No personal information sent to external servers
• Uses iOS native CallKit for system-level blocking
• Optional contact access for enhanced features

Perfect for avoiding spam calls, telemarketers, and unwanted interruptions.
```

#### Keywords Template (comma-separated)
```
[primary keyword], [secondary keyword], [feature keyword], [category keyword], [benefit keyword], [target audience], [solution keyword]
```

#### Example for Call Blocking Apps:
```
call block, spam block, telemarketer, unwanted calls, privacy, security, callkit
```

### Step 4: Prepare App Store Assets

#### Required Screenshots
- **6.7" Display (iPhone 15 Pro Max)**: 1290 x 2796 pixels
- **6.5" Display (iPhone 14 Plus)**: 1242 x 2688 pixels  
- **5.5" Display (iPhone 8 Plus)**: 1242 x 2208 pixels

#### Screenshot Content Template (recommend 3-5 screenshots):
1. **Main Screen** - Primary app interface showcasing key features
2. **Core Feature** - Demonstrating primary functionality
3. **Secondary Feature** - Additional capabilities or settings
4. **User Workflow** - Step-by-step usage demonstration
5. **Results/Output** - Showing app benefits or results

#### Example for Call Blocking Apps:
1. **Home Screen** - Main interface with statistics
2. **Block Number** - Add number to block list
3. **Blocked Numbers List** - List of blocked numbers
4. **Statistics** - Detailed call blocking statistics
5. **Settings** - Extension management and configuration

#### App Icon Requirements
- **App Store**: 1024 x 1024 pixels (required)
- **All other sizes** handled by Xcode automatically

#### Optional Assets
- **App Preview Video**: 15-30 seconds demonstrating key features
- **Apple Watch Screenshots**: If watch app included

---

## 🔧 Technical Preparation

### Step 1: Code Preparation

#### Version and Build Numbers
```bash
# Update using build script
./build-ios.sh
# Choose option 2 to enter new version (e.g., v1.0.0)
```

#### Required iOS Features for Call Blocking Apps

1. **CallKit Integration**:
   ```swift
   // Ensure CallDirectoryHandler.swift is properly implemented
   class CallDirectoryHandler: CXCallDirectoryProvider {
       // Implementation must be complete and functional
   }
   ```

2. **Privacy Usage Descriptions**:
   ```xml
   <!-- In Info.plist -->
   <key>NSContactsUsageDescription</key>
   <string>This app needs access to contacts to identify unknown callers and provide enhanced blocking features.</string>
   ```

3. **App Groups Configuration**:
   ```xml
   <!-- Both main app and extension must have same App Groups -->
   <key>com.apple.security.application-groups</key>
   <array>
       <string>group.com.smartcallblock.ios</string>
   </array>
   ```

### Step 2: Testing Requirements

#### Device Testing Checklist
- [ ] iPhone (multiple models and iOS versions)
- [ ] iPad (if supporting iPad)
- [ ] Call blocking functionality works
- [ ] Extension enables properly in Settings
- [ ] All features work offline
- [ ] No crashes or memory leaks
- [ ] Proper error handling

#### Automated Testing
```bash
# Run all tests before submission
xcodebuild test -project SmartCallBlock.xcodeproj -scheme SmartCallBlock
```

### Step 3: Create Distribution Archive

#### Using Build Script (Recommended)
```bash
./build-ios.sh
# Script will create release archive automatically
```

#### Manual Archive Process
```bash
# Clean and archive
xcodebuild clean archive \
  -project SmartCallBlock.xcodeproj \
  -scheme SmartCallBlock \
  -configuration Release \
  -archivePath ./SmartCallBlock.xcarchive
```

---

## 🚀 Submission Process

### Step 1: Upload to App Store Connect

#### Method 1: Xcode Organizer (Recommended)
1. **Open Xcode**
2. **Window** → **Organizer**
3. **Select your archive**
4. **Click "Distribute App"**
5. **Choose "App Store Connect"**
6. **Follow upload wizard**

#### Method 2: Application Loader (Alternative)
1. Export IPA from Xcode
2. Use Application Loader or Transporter app
3. Upload IPA file

### Step 2: Complete App Store Connect Information

#### App Store Listing
1. **Add Screenshots**: Upload all required screenshots
2. **App Description**: Copy prepared description
3. **Keywords**: Add comma-separated keywords
4. **App Category**: Utilities
5. **Content Rating**: Complete questionnaire

#### Pricing and Availability
- **Price**: Free (recommended for call blocking apps)
- **Availability**: All territories (unless restricted)
- **Release**: Manual release after approval

#### App Review Information
```
Contact Information:
- First Name: [Your first name]
- Last Name: [Your last name]
- Phone: [Your phone number]
- Email: [Your email address]

Notes for Review:
"Smart Call Block uses Apple's CallKit framework to provide native call blocking functionality. The app includes a Call Directory Extension that integrates with iOS's built-in call blocking system. 

To test the call blocking feature:
1. Install the app on a test device
2. Go to Settings → Phone → Call Blocking & Identification
3. Enable 'Smart Call Block Extension'
4. Add a test number to the blocked list in the app
5. Call from that number to verify blocking works

The app stores all data locally and does not send any personal information to external servers."
```

#### Privacy Policy
Create a privacy policy covering:
- What data is collected (minimal for this app)
- How data is used (local storage only)
- Contact access usage
- Data sharing (none for this app)
- User rights and controls

### Step 3: Submit for Review

1. **Review all information** for accuracy
2. **Click "Submit for Review"**
3. **Wait for Apple's review** (typically 1-7 days)
4. **Respond to any rejection feedback** if needed
5. **Release when approved**

---

## ⚠️ Common App Store Review Guidelines for Call Blocking Apps

### Must-Have Features
- [ ] **Clear functionality description** in app and metadata
- [ ] **Proper CallKit integration** (no private APIs)
- [ ] **User control** over blocking settings
- [ ] **Privacy compliance** - minimal data collection
- [ ] **No misleading claims** about blocking capabilities

### Potential Rejection Reasons
1. **Incomplete CallKit implementation**
2. **Privacy policy missing or inadequate**
3. **Misleading app description**
4. **UI/UX not following iOS guidelines**
5. **Crashes or significant bugs**
6. **Inappropriate content rating**

### Review Response Best Practices
- **Respond quickly** to review feedback
- **Provide detailed explanations** of functionality
- **Include test instructions** for reviewers
- **Fix all reported issues** before resubmission

---

## 📊 Post-Submission Management

### After Approval
1. **Release the app** when ready
2. **Monitor crash reports** in App Store Connect
3. **Respond to user reviews** professionally
4. **Plan app updates** based on feedback

### Analytics and Monitoring
- **App Store Connect Analytics**: Download and usage metrics
- **Xcode Crash Reports**: Technical issue tracking
- **User Reviews**: Feature requests and issues
- **Rating Monitoring**: Maintain high ratings

### Update Process
1. **Prepare new version** with bug fixes or features
2. **Update version number** in Xcode
3. **Create new archive** and upload
4. **Update "What's New" description**
5. **Submit update for review**

---

# Vietnamese Guide

## 🎯 Tổng Quan

Hướng dẫn này bao gồm toàn bộ quy trình nộp ứng dụng Smart Call Block iOS lên Apple App Store, bao gồm chuẩn bị, quy định đánh giá, và các bước nộp hồ sơ.

### Danh Sách Kiểm Tra Trước Khi Bắt Đầu
- [ ] **Tài khoản Apple Developer** ($99/năm cho cá nhân, $299/năm cho tổ chức)
- [ ] **Ứng dụng iOS hoàn thiện** với tất cả tính năng hoạt động
- [ ] **App đã được test** trên nhiều thiết bị và phiên bản iOS
- [ ] **Quyền truy cập App Store Connect** với đầy đủ quyền hạn
- [ ] **Chính sách bảo mật** và điều khoản dịch vụ đã chuẩn bị
- [ ] **Tài liệu App Store** (icon, ảnh chụp màn hình, mô tả) đã sẵn sàng

---

## 📋 Chuẩn Bị Trước Khi Nộp

### Bước 1: Thiết Lập Tài Khoản Apple Developer

#### Tài Khoản Developer Cá Nhân
1. Truy cập [developer.apple.com](https://developer.apple.com)
2. Nhấp **Account** → **Enroll**
3. Chọn đăng ký **Individual**
4. Hoàn thành xác minh danh tính
5. Thanh toán phí $99/năm
6. Chờ phê duyệt (thường 24-48 giờ)

#### Tài Khoản Developer Tổ Chức
1. Quy trình tương tự nhưng chọn **Organization**
2. Yêu cầu xác minh doanh nghiệp
3. Cần có D-U-N-S Number
4. Phí $299/năm
5. Thời gian phê duyệt lâu hơn (tối đa 2 tuần)

### Bước 2: Thiết Lập App Store Connect

1. **Truy Cập App Store Connect**:
   - Vào [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   - Đăng nhập bằng tài khoản Apple Developer

2. **Tạo App Mới**:
   - Nhấp **My Apps** → **+** → **New App**
   - Chọn platform **iOS**
   - Điền thông tin ứng dụng:
     - **Name**: Smart Call Block
     - **Primary Language**: English (hoặc theo preference)
     - **Bundle ID**: `com.smartcallblock.ios` (phải khớp với project Xcode)
     - **SKU**: Mã định danh duy nhất (ví dụ: `SCB-iOS-001`)

### Bước 3: Thiết Lập Thông Tin Ứng Dụng

#### Thông Tin App Store
```
Tên App: Smart Call Block
Phụ đề: Chặn Cuộc Gọi Không Mong Muốn
Danh mục: Tiện ích (Utilities)
Xếp hạng nội dung: 4+ (Độ tuổi thấp)
```

#### Mô Tả Ứng Dụng
```
Chặn cuộc gọi không mong muốn với Smart Call Block, một ứng dụng iOS mạnh mẽ sử dụng framework CallKit của Apple để cung cấp tính năng chặn cuộc gọi tích hợp.

TÍNH NĂNG:
• Chặn các số điện thoại cụ thể
• Tự động chặn số không xác định
• Xem thống kê cuộc gọi chi tiết
• Thiết kế iOS hiện đại với SwiftUI
• Theo dõi lịch sử cuộc gọi
• Lưu trữ dữ liệu an toàn cục bộ

BẢO MẬT & AN TOÀN:
• Tất cả dữ liệu được lưu cục bộ trên thiết bị
• Không gửi thông tin cá nhân ra máy chủ bên ngoài
• Sử dụng CallKit bản địa iOS để chặn ở cấp độ hệ thống
• Truy cập danh bạ tùy chọn cho tính năng nâng cao

Hoàn hảo để tránh cuộc gọi spam, nhân viên telesales và những cuộc gọi làm phiền.
```

#### Từ Khóa (phân cách bằng dấu phẩy)
```
chặn cuộc gọi, chặn spam, telesales, cuộc gọi không mong muốn, bảo mật, callkit
```

### Bước 4: Chuẩn Bị Tài Liệu App Store

#### Ảnh Chụp Màn Hình Bắt Buộc
- **Màn hình 6.7" (iPhone 15 Pro Max)**: 1290 x 2796 pixels
- **Màn hình 6.5" (iPhone 14 Plus)**: 1242 x 2688 pixels  
- **Màn hình 5.5" (iPhone 8 Plus)**: 1242 x 2208 pixels

#### Nội Dung Ảnh Chụp Màn Hình (đề xuất 3-5 ảnh):
1. **Màn Hình Chính** - Giao diện chính với thống kê
2. **Chặn Số** - Thêm số vào danh sách chặn
3. **Danh Sách Số Bị Chặn** - Danh sách các số đã chặn
4. **Thống Kê** - Thống kê chi tiết về chặn cuộc gọi
5. **Cài Đặt** - Quản lý extension và cấu hình

#### Yêu Cầu Icon Ứng Dụng
- **App Store**: 1024 x 1024 pixels (bắt buộc)
- **Tất cả kích thước khác** do Xcode tự động xử lý

#### Tài Liệu Tùy Chọn
- **Video Xem Trước**: 15-30 giây demo các tính năng chính
- **Ảnh Chụp Apple Watch**: Nếu có ứng dụng watch

---

## 🔧 Chuẩn Bị Kỹ Thuật

### Bước 1: Chuẩn Bị Code

#### Số Phiên Bản và Build
```bash
# Cập nhật bằng build script
./build-ios.sh
# Chọn tùy chọn 2 để nhập phiên bản mới (ví dụ: v1.0.0)
```

#### Tính Năng iOS Bắt Buộc Cho App Chặn Cuộc Gọi

1. **Tích Hợp CallKit**:
   ```swift
   // Đảm bảo CallDirectoryHandler.swift được implement đầy đủ
   class CallDirectoryHandler: CXCallDirectoryProvider {
       // Implementation phải hoàn chỉnh và functional
   }
   ```

2. **Mô Tả Sử Dụng Privacy**:
   ```xml
   <!-- Trong Info.plist -->
   <key>NSContactsUsageDescription</key>
   <string>Ứng dụng cần truy cập danh bạ để nhận diện cuộc gọi không xác định và cung cấp tính năng chặn nâng cao.</string>
   ```

3. **Cấu Hình App Groups**:
   ```xml
   <!-- Cả main app và extension phải có cùng App Groups -->
   <key>com.apple.security.application-groups</key>
   <array>
       <string>group.com.smartcallblock.ios</string>
   </array>
   ```

### Bước 2: Yêu Cầu Testing

#### Danh Sách Kiểm Tra Testing Thiết Bị
- [ ] iPhone (nhiều model và phiên bản iOS)
- [ ] iPad (nếu hỗ trợ iPad)
- [ ] Tính năng chặn cuộc gọi hoạt động
- [ ] Extension enable được trong Settings
- [ ] Tất cả tính năng hoạt động offline
- [ ] Không crash hoặc memory leak
- [ ] Xử lý lỗi đúng cách

#### Automated Testing
```bash
# Chạy tất cả test trước khi nộp
xcodebuild test -project SmartCallBlock.xcodeproj -scheme SmartCallBlock
```

### Bước 3: Tạo Distribution Archive

#### Sử Dụng Build Script (Đề Xuất)
```bash
./build-ios.sh
# Script sẽ tự động tạo release archive
```

#### Quy Trình Archive Thủ Công
```bash
# Clean và archive
xcodebuild clean archive \
  -project SmartCallBlock.xcodeproj \
  -scheme SmartCallBlock \
  -configuration Release \
  -archivePath ./SmartCallBlock.xcarchive
```

---

## 🚀 Quy Trình Nộp Hồ Sơ

### Bước 1: Upload Lên App Store Connect

#### Phương Pháp 1: Xcode Organizer (Đề Xuất)
1. **Mở Xcode**
2. **Window** → **Organizer**
3. **Chọn archive của bạn**
4. **Nhấp "Distribute App"**
5. **Chọn "App Store Connect"**
6. **Theo dõi upload wizard**

#### Phương Pháp 2: Application Loader (Thay Thế)
1. Export IPA từ Xcode
2. Sử dụng Application Loader hoặc app Transporter
3. Upload file IPA

### Bước 2: Hoàn Thành Thông Tin App Store Connect

#### App Store Listing
1. **Thêm Screenshots**: Upload tất cả ảnh chụp màn hình bắt buộc
2. **Mô Tả App**: Copy mô tả đã chuẩn bị
3. **Từ Khóa**: Thêm từ khóa phân cách bằng dấu phẩy
4. **Danh Mục App**: Utilities
5. **Content Rating**: Hoàn thành questionnaire

#### Giá Cả và Khả Dụng
- **Giá**: Miễn phí (đề xuất cho app chặn cuộc gọi)
- **Khả dụng**: Tất cả vùng lãnh thổ (trừ khi bị hạn chế)
- **Phát hành**: Phát hành thủ công sau khi được phê duyệt

#### Thông Tin App Review
```
Thông Tin Liên Lạc:
- Tên: [Tên của bạn]
- Họ: [Họ của bạn]  
- Điện thoại: [Số điện thoại của bạn]
- Email: [Email của bạn]

Ghi Chú Cho Review:
"Smart Call Block sử dụng framework CallKit của Apple để cung cấp tính năng chặn cuộc gọi tích hợp. App bao gồm Call Directory Extension tích hợp với hệ thống chặn cuộc gọi built-in của iOS.

Để test tính năng chặn cuộc gọi:
1. Cài đặt app trên thiết bị test
2. Vào Settings → Phone → Call Blocking & Identification  
3. Enable 'Smart Call Block Extension'
4. Thêm một số test vào danh sách chặn trong app
5. Gọi từ số đó để xác minh chặn hoạt động

App lưu trữ tất cả dữ liệu cục bộ và không gửi thông tin cá nhân nào ra máy chủ bên ngoài."
```

#### Chính Sách Bảo Mật
Tạo chính sách bảo mật bao gồm:
- Dữ liệu nào được thu thập (tối thiểu cho app này)
- Dữ liệu được sử dụng như thế nào (chỉ lưu cục bộ)
- Sử dụng truy cập danh bạ
- Chia sẻ dữ liệu (không có cho app này)
- Quyền và kiểm soát của người dùng

### Bước 3: Nộp Để Review

1. **Kiểm tra tất cả thông tin** về tính chính xác
2. **Nhấp "Submit for Review"**
3. **Chờ Apple review** (thường 1-7 ngày)
4. **Phản hồi feedback từ chối** nếu cần
5. **Phát hành khi được phê duyệt**

---

## ⚠️ Quy Định App Store Review Thường Gặp Cho App Chặn Cuộc Gọi

### Tính Năng Bắt Buộc
- [ ] **Mô tả chức năng rõ ràng** trong app và metadata
- [ ] **Tích hợp CallKit đúng cách** (không dùng private API)
- [ ] **Kiểm soát của người dùng** đối với cài đặt chặn
- [ ] **Tuân thủ privacy** - thu thập dữ liệu tối thiểu
- [ ] **Không tuyên bố sai lệch** về khả năng chặn

### Lý Do Từ Chối Có Thể Xảy Ra
1. **CallKit implementation không đầy đủ**
2. **Thiếu hoặc chính sách bảo mật không đầy đủ**
3. **Mô tả app gây hiểu lầm**
4. **UI/UX không tuân thủ guidelines iOS**
5. **Crash hoặc bug nghiêm trọng**
6. **Content rating không phù hợp**

### Best Practices Phản Hồi Review
- **Phản hồi nhanh** với feedback review
- **Cung cấp giải thích chi tiết** về chức năng
- **Bao gồm hướng dẫn test** cho reviewer
- **Sửa tất cả vấn đề được báo cáo** trước khi nộp lại

---

## 📊 Quản Lý Sau Khi Nộp

### Sau Khi Được Phê Duyệt
1. **Phát hành app** khi sẵn sàng
2. **Monitor crash reports** trong App Store Connect
3. **Phản hồi user reviews** một cách chuyên nghiệp
4. **Lên kế hoạch cập nhật app** dựa trên feedback

### Analytics và Monitoring
- **App Store Connect Analytics**: Metrics download và usage
- **Xcode Crash Reports**: Theo dõi vấn đề kỹ thuật
- **User Reviews**: Feature requests và issues
- **Rating Monitoring**: Duy trì rating cao

### Quy Trình Update
1. **Chuẩn bị phiên bản mới** với bug fixes hoặc features
2. **Cập nhật version number** trong Xcode
3. **Tạo archive mới** và upload
4. **Cập nhật "What's New" description**
5. **Nộp update để review**

---

## 🔗 Tài Liệu Tham Khảo

### Tài Liệu Chính Thức
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [App Store Connect Help](https://developer.apple.com/help/app-store-connect/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

### Tài Liệu Dự Án
- [Build Guide](./BUILD_GUIDE.md) - Hướng dẫn build hoàn chỉnh
- [Setup Guide](./SETUP_GUIDE.md) - Hướng dẫn setup ban đầu
- [iOS Documentation](./IOS_DOCUMENTATION.md) - Tài liệu iOS đầy đủ
- [API Reference](./API_REFERENCE.md) - Tài liệu API

---

## ✅ Checklist Tổng Hợp

### Trước Khi Nộp
- [ ] Apple Developer account đã thiết lập
- [ ] App Store Connect project đã tạo
- [ ] App đã test đầy đủ
- [ ] Screenshots và assets đã chuẩn bị
- [ ] Mô tả và metadata hoàn chỉnh
- [ ] Privacy policy đã tạo
- [ ] Archive distribution đã sẵn sàng

### Trong Quá Trình Review
- [ ] Monitor email từ Apple
- [ ] Phản hồi nhanh với feedback
- [ ] Chuẩn bị giải thích bổ sung nếu cần
- [ ] Test build cuối cùng trước release

### Sau Khi Được Phê Duyệt
- [ ] Phát hành app
- [ ] Monitor analytics và crash reports
- [ ] Phản hồi user reviews
- [ ] Lên kế hoạch updates tương lai

---

**💡 Lưu Ý**: Quy trình App Store review có thể thay đổi theo thời gian. Luôn tham khảo tài liệu chính thức mới nhất từ Apple Developer.