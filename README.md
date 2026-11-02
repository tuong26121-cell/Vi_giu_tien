# Vi_giu_tien
Tiết kiệm tài chính

---

# Tuto — Túi giữ tiền thông minh

Ứng dụng web quản lý tài chính mô phỏng bằng tiếng Việt. Giao diện xanh nước với thẻ kính, nút 3D nhẹ, túi tiền tím và nền sóng.

**Website Sites:** https://tuto-tui-tiet-kiem.mysticpuppy65.chatgpt.site

Tất cả giao dịch sử dụng tiền mô phỏng, không kết nối ngân hàng hoặc xử lý tiền thật. Dữ liệu dùng localStorage của từng trình duyệt; kho mã không chứa dữ liệu giao dịch cá nhân.

## Chức năng

- Trang chủ tổng hợp số dư, thu chi và phần tiết kiệm trong tháng.
- Tạo túi, theo dõi số dư và tiến độ của từng túi.
- Ghi thu, ghi chi, tìm và lọc giao dịch; xuất CSV.
- Tạo mục tiêu, góp từ túi vào mục tiêu, xem các mục tiêu hoàn thành.
- Biểu đồ chi tiêu theo tuần, tháng và năm, tính từ lịch sử giao dịch.
- Chuyển nội bộ giữa hai túi với bước xác nhận và kiểm tra số dư.
- Đổi tên hiển thị, ẩn số dư; giao diện máy tính và điện thoại.

Chuyển nội bộ giữ nguyên tổng số dư túi. Góp mục tiêu trừ khỏi số dư túi và cộng vào mục tiêu. Hai loại này không được tính thành thu nhập hoặc chi tiêu trong biểu đồ.

## Chạy bản web trên máy tính hoặc GitHub Codespaces

Cần Node.js 22+ và Python 3. Bản web không cần cài thư viện npm.

```sh
npm test
npm run build
npm run preview
```

Mở http://localhost:4180. Trong Codespaces, mở tab **Ports**, tìm cổng **4180** và chọn mở trong trình duyệt. Cổng được cấu hình riêng tư.

Sau khi sửa mã, chạy lại `npm run build` rồi tải lại trang. Máy chủ preview đọc thư mục `dist/`.

## Mở không gian mã Codespaces

[Mở Tuto trong GitHub Codespaces](https://codespaces.new/tuong26121-cell/Vi_giu_tien), hoặc chọn **Code → Codespaces → Create codespace on main** trong kho này. Cấu hình trong `.devcontainer/devcontainer.json` sẽ chuẩn bị môi trường, chạy kiểm thử và tạo bản build. Sau khi không gian mã sẵn sàng, chạy `npm run preview` để mở ứng dụng. Codespaces có thể sử dụng hạn mức hoặc phát sinh phí theo tài khoản GitHub.

## Cấu trúc mã

| Tệp/thư mục | Nội dung |
| --- | --- |
| `index.html` | Khung ứng dụng, điều hướng và hộp thoại |
| `main.js` | Các màn hình và thao tác giao diện |
| `model.js` | Logic số dư, giao dịch, túi và mục tiêu |
| `style.css` | Giao diện và bố cục responsive |
| `assets/` | Túi tiền SVG và nền sóng SVG |
| `qa/model.test.mjs` | Kiểm thử tính toán và bảo toàn số dư |
| `build.mjs` | Kiểm tra cú pháp và tạo thư mục `dist/` |
| `.devcontainer/` | Cấu hình GitHub Codespaces |
| `flutter/` | Mã Flutter gốc từ ZIP người dùng cung cấp |

## Bản Flutter gốc

Thư mục `flutter/` giữ nguyên mã nguồn của ZIP được cung cấp, kèm README và kiểm thử của bản gốc. Đây là phiên bản độc lập với bản web; giao diện web được dựng từ ảnh tham chiếu và logic Flutter. Chưa build hoặc kiểm thử Flutter/APK trong môi trường này. Xem `flutter/README.md` để biết các bước chạy với Flutter SDK.

## Xác minh

Bản web đã build thành công và đạt 9 kiểm thử logic. Bản triển khai cũng đã được kiểm tra bằng trình duyệt cho các luồng chuyển nội bộ, thu chi, mục tiêu, lưu dữ liệu, CSV và bố cục màn hình từ 320 đến 1440 px.

Cấu hình Codespaces được cung cấp để tái tạo môi trường; trạng thái khởi động thực tế phụ thuộc quyền và hạn mức GitHub của tài khoản.
