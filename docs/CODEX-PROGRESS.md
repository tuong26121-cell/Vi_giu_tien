# Tiến độ Tuto

Cập nhật: 02/11/2026, múi giờ Việt Nam.

## Mã nguồn và bản web

- Mã web, Flutter gốc và cấu hình Codespaces đã lưu tại commit `88c6e2d9f6362e0a2d2775b619897fa8673fccad` trên nhánh main.
- Bản web đã vượt qua build và 9 kiểm thử logic trong môi trường xây dựng trước đó. Đây không phải bằng chứng rằng kiểm thử đã chạy trong Codespace của người dùng.
- Website Sites đã xuất bản: https://tuto-tui-tiet-kiem.mysticpuppy65.chatgpt.site
- Nhánh tài liệu hiện tại: `codex/tuto-codespace-status`. Không thay đổi mã ứng dụng hoặc main trong bước ghi nhận này.

## Codespace: đạt một phần

Editor: https://super-duper-space-garbanzo-96wx46544x5r2vx6.github.dev/

- TinyFish đã mở được VS Code và báo xác minh đúng kho `tuong26121-cell/Vi_giu_tien`.
- File explorer đã hiển thị package.json, build.mjs, index.html, main.js, model.js, style.css cùng các thư mục assets, dist, flutter, qa.
- Cổng 4180 xuất hiện trong Ports, cấu hình Private. Việc cổng được cấu hình không chứng minh máy chủ đang chạy.
- Lệnh dự kiến: `cd /workspaces/Vi_giu_tien && npm test && npm run build && npm run preview`.
- Chưa có bằng chứng lệnh này đã được thực thi trong Codespace. Các lần thử tạo/focus Terminal qua Command Palette và phím tắt đã hiển thị panel, nhưng TinyFish không xác nhận được nhập lệnh hoặc kết quả đầu ra.
- URL cổng 4180 trả HTTP 401 trong phiên TinyFish. Đây là giới hạn xác thực truy cập; không đủ để kết luận máy chủ không chạy hoặc mã nguồn lỗi.
- Chưa xác minh được giao diện Tuto hoặc kiểm thử điều hướng trong Codespace.

## Bằng chứng lần chạy TinyFish

- https://agent.tinyfish.ai/runs/900924eb-7011-4b0c-b91c-6dfcc3330dc4 — editor/files/cổng đã quan sát; lệnh chạy và app chưa xác minh.
- https://agent.tinyfish.ai/runs/c41a5af8-6027-40b2-ac1b-da4be63c7f3e — thử Terminal bằng phím tắt, không xác nhận thực thi; URL preview trả HTTP 401.

Không lưu cookie, token hoặc bí mật trong tài liệu này.

## Việc còn lại

1. Khi có phiên truy cập Codespace/port hợp lệ và công cụ Terminal hoạt động, chạy hoặc xác minh máy chủ preview rồi kiểm tra Tuto.
2. Giữ trạng thái bước Codespace là BỊ CHẶN / CHƯA XÁC MINH, không đánh dấu hoàn thành.
3. Flutter APK: chưa build và chưa kiểm thử trong Codespace.
4. Ngân hàng thật: chưa triển khai; bản hiện tại dùng dữ liệu và tiền mô phỏng.


## Bổ sung lộ trình và tự khởi động — 02/11/2026

Nhánh triển khai: `codex/tuto-roadmap-and-startup`.

- Đã viết `docs/ROADMAP.md`: 5 mốc, phụ thuộc và tiêu chí nghiệm thu.
- Cấu hình hiện tại trên main chỉ có postCreate build và forwardPorts, chưa có lệnh tự chạy server. Đây là thiếu sót về tiện ích khởi động, không chứng minh nó gây HTTP 401.
- Bổ sung postStartCommand, script khởi động idempotent và tác vụ VS Code.
- Kiểm thử cục bộ: build thành công; 9 kiểm thử tài chính đạt; thử khởi động preview thật, gọi lại để tái sử dụng, từ chối cổng đang phục vụ ứng dụng khác, từ chối cổng không hợp lệ. Máy chủ thử nghiệm do kiểm thử tạo được dừng sau kiểm tra.
- Chưa có bằng chứng thay đổi này chạy trong Codespace của người dùng. Lỗi HTTP 401 vẫn là điểm chặn xác thực riêng. Không đánh dấu mốc 1 hoàn thành.
- Không sửa main, không merge, không triển khai Sites hoặc Vercel trong bước này.

## Xác minh trực tiếp Codespace — 02/11/2026

Cập nhật này thay thế trạng thái “chưa xác minh mở app” ở các lần thử trước, nhưng giữ lịch sử để đối chiếu:

- TinyFish báo đã lấy main và chọn tác vụ `Tuto: khởi động bản xem` trong Codespace.
- Run `886f3052-2dce-4512-a597-f1efb591e74c` mở trực tiếp cổng 4180, thấy giao diện Tuto cùng số dư mẫu 12.750.000 ₫ và điều hướng qua các màn hình chính.
- Không gặp HTTP 401 trong lần xác minh này. Không khẳng định mọi phiên sau đều không cần đăng nhập.
- Đã chạy lại 9 kiểm thử logic, build và kiểm thử startup trong môi trường cục bộ; chưa có log tương ứng trong Codespace.
- Chi tiết giới hạn SonarQube, Plugin Eval và bằng chứng: `docs/TOOL-VERIFICATION.md`.
