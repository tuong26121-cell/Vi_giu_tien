# Tuto – Túi giữ tiền thông minh

Ứng dụng Flutter Android, giao diện xanh nước nhẹ. **Dữ liệu mô phỏng, không kết nối ngân hàng thật.**

## 6 chức năng
1. Quản lý số dư: tổng hợp số dư các túi.
2. Túi tiết kiệm: tạo túi, theo dõi số dư.
3. Thu chi: ghi nhận giao dịch thu/chi theo túi, từ chối chi vượt số dư.
4. Mục tiêu: tạo mục tiêu, góp tiền từ túi (tiền được trừ khỏi số dư túi).
5. Thống kê: biểu đồ thanh tổng thu/chi và phân loại chi.
6. Chuyển tiền: chuyển mô phỏng giữa hai túi, kiểm tra số dư.

## Cài đặt và chạy (Android / Codespaces / máy tính có Flutter)
Cài Flutter SDK (Dart >=3.3) và Android SDK. Tại thư mục dự án:

```bash
flutter create --platforms=android .
flutter pub get
flutter analyze
flutter test
flutter run
flutter build apk --debug
```

APK sau khi build thành công: `build/app/outputs/flutter-apk/app-debug.apk`.

**Lưu ý:** Gói ZIP chứa toàn bộ mã Dart, cấu hình Flutter, kiểm thử và hướng dẫn. Thư mục Android native được tạo bởi `flutter create` để khớp với phiên bản Flutter SDK của máy build. Không có APK được build sẵn.

## Lưu trữ và giới hạn
- `shared_preferences` lưu JSON vào bộ nhớ ứng dụng, khóa `tuto_data_v1`; dữ liệu tồn tại sau khi đóng/mở app nhưng có thể mất khi gỡ app/xóa dữ liệu.
- Không đồng bộ cloud, không đăng nhập, không mã hóa dữ liệu tài chính. Chỉ dùng số tiền giả lập, không nhập dữ liệu tài chính nhạy cảm.
- Tiền góp mục tiêu được theo dõi riêng, không cộng vào tổng số dư túi; thống kê thu/chi không tính chuyển nội bộ hoặc góp mục tiêu.
- Không có kết nối mạng hoặc thanh toán thật.
- Mã nguồn chưa được chạy `flutter analyze`, `flutter test` hoặc build APK trong môi trường bàn giao vì Flutter SDK không được cài đặt.
