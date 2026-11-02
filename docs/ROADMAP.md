# Lộ trình dự án Tuto

Cập nhật 02/11/2026, giờ Việt Nam. Lộ trình triển khai theo bằng chứng, không cam kết ngày hoàn thành khi quyền truy cập hoặc dịch vụ tích hợp chưa sẵn sàng.

## Điểm xuất phát

Đã có bản web demo tiếng Việt trên Sites, mã trong GitHub, 9 kiểm thử logic và các kiểm thử trình duyệt cục bộ trước đó. Flutter gốc mới là nền tảng chức năng, chưa đồng nhất đầy đủ giao diện web và chưa build APK. Không có ngân hàng thật, backend tài chính hoặc đồng bộ dữ liệu người dùng.

Codespace đã mở đúng kho, nhưng điều khiển Terminal bằng TinyFish chưa xác nhận chạy lệnh. Cổng riêng tư trả HTTP 401 trong phiên trình duyệt; đây là vấn đề xác thực truy cập, không phải bằng chứng máy chủ dừng.

## Mốc 1 — Ổn định cách chạy và kiểm tra

**Ưu tiên hiện tại.**

- Tự khởi động preview khi Codespace start, kiểm tra máy chủ trước khi chạy để tránh trùng.
- Thêm tác vụ VS Code để chạy không cần gõ lệnh vào xterm.
- Giữ cổng 4180 riêng tư, ghi log trong thư mục tạm, không lưu thông tin xác thực.
- Xác minh build, kiểm thử, server, giao diện và các đường dẫn điều hướng trong chính Codespace.

**Đầu ra:** cấu hình chạy lặp lại được, log kết quả, URL app đã thực sự mở được.

**Nghiệm thu:** 9 kiểm thử logic đạt; server trả đúng Tuto; chạy lại không tạo máy chủ thứ hai; điều hướng đủ các màn hình. Kiểm thử cục bộ và xác minh Codespace ghi riêng. HTTP 401 vẫn là điểm chặn riêng, không được sửa bằng cách công khai cổng.

**Khi bị chặn:** lưu chính xác lỗi quyền/phiên truy cập và tiếp tục các công việc cục bộ không phụ thuộc Codespace. Không chờ vô hạn hoặc khẳng định hoàn thành.

## Mốc 2 — Hoàn thiện bản web MVP

- Rà soát thêm tiền vào/ra, chuyển nội bộ, góp mục tiêu, số dư và biểu đồ theo dữ liệu thực tế.
- Làm rõ trạng thái đang xử lý, thành công, lỗi, trống dữ liệu và số dư không đủ; tránh gửi lặp thao tác.
- Thử nghiệm nhiều tab, tải lại trang, localStorage không khả dụng hoặc dữ liệu lỗi.
- Thêm sao lưu/khôi phục dữ liệu có xác nhận và kiểm tra nội dung trước nhập.
- Kiểm tra bàn phím, cỡ chữ, tương phản và màn hình 320–1440 px.

**Đầu ra:** bản web MVP có thể dùng thử dài ngày với tiền mô phỏng, danh sách lỗi đã sửa và bằng chứng kiểm thử.

**Nghiệm thu:** không âm số dư; bảo toàn tiền khi chuyển nội bộ; góp mục tiêu đúng; không hiển thị thành công giả khi lỗi lưu; không tràn ngang; sao lưu/khôi phục đối chiếu đúng. Chưa đưa dữ liệu tài chính nhạy cảm vào bản localStorage.

## Mốc 3 — Android và APK

- Kiểm tra Flutter SDK, pubspec, API tương thích; giữ bản Flutter gốc để đối chiếu.
- Cập nhật giao diện Flutter theo mẫu Tuto xanh nước và thống nhất quy tắc tiền với web.
- Chạy flutter analyze, flutter test, kiểm thử thiết bị/emulator, build APK debug.
- Kiểm tra cài mới, mở lại app, lưu dữ liệu, thu chi, chuyển nội bộ và mục tiêu.
- Chuẩn bị quy trình ký bản phát hành; khóa ký được lưu ngoài repository.

**Đầu ra:** APK debug cài được, mã nguồn và log build/test; sau đó mới chuẩn bị APK/AAB phát hành.

**Nghiệm thu:** build thành công có artifact và checksum; cài, mở, dùng các luồng chính trên Android. Không đánh dấu hoàn thành chỉ vì đã có mã Dart hoặc workflow.

**Phụ thuộc:** Flutter/Android SDK và môi trường build. Có thể chuẩn bị song song khi Codespace bị chặn; không đồng nhất việc chuẩn bị với APK đã build.

## Mốc 4 — Backend và ngân hàng sandbox

- Chọn nhà cung cấp theo API, hợp đồng và quyền truy cập thực tế; chưa có dữ kiện để tự chọn hoặc hứa tích hợp.
- Thiết kế tài khoản, xác thực, phân quyền theo chủ sở hữu và quản lý phiên ở server.
- Lưu sổ cái phía server; ghi nhận debit/credit nhất quán trong giao dịch cơ sở dữ liệu.
- Thêm idempotency, kiểm tra đồng thời, retry, webhook được xác minh và đối soát trạng thái.
- Kiểm tra người A không xem/sửa dữ liệu B; secret không nằm trong frontend/repo/log.
- Thử luồng nạp/rút/chuyển trong sandbox của nhà cung cấp, gồm thất bại và timeout.

**Đầu ra:** tích hợp sandbox đã kiểm thử end-to-end, threat model và bằng chứng đối soát.

**Nghiệm thu:** không ghi tiền hai lần khi retry, không vượt số dư khi đồng thời, xác thực webhook đúng, quyền sở hữu được kiểm tra phía server, không báo giao dịch thành công khi trạng thái chưa rõ.

**Điểm chặn phải ghi nhận:** nhà cung cấp/API sandbox, tài khoản dịch vụ và quyền tích hợp chưa có. Không yêu cầu gửi mật khẩu, OTP hoặc khóa bí mật qua chat.

## Mốc 5 — Đánh giá trước phát hành thật

- Rà soát độc lập về bảo mật và yêu cầu pháp lý/hợp đồng với đối tác có thẩm quyền.
- Kiểm tra phân quyền, đối soát, sao lưu/khôi phục, giám sát, giới hạn giao dịch và ứng phó sự cố.
- Chuẩn bị điều khoản, quyền riêng tư, hỗ trợ và quy trình xử lý tranh chấp phù hợp mô hình sản phẩm thực tế.
- Tách demo/sandbox/production, chuẩn bị rollback và kế hoạch phát hành giới hạn.

**Đầu ra:** hồ sơ quyết định phát hành dựa trên kết quả thực tế, không phải tuyên bố ứng dụng đã đủ điều kiện ngân hàng.

**Nghiệm thu:** các yêu cầu kỹ thuật và điều kiện đối tác được xác minh; quyền production riêng biệt hợp lệ. Không chạy giao dịch tiền thật chỉ để kiểm thử bản demo.

## Nguyên tắc điều phối

Người dùng giao quyền xử lý công việc kỹ thuật và không muốn bị hỏi thêm. Tự quyết các lựa chọn triển khai phù hợp, giữ nguyên dữ liệu, lưu bằng chứng và báo rõ phần bị chặn. Quyền điều phối không tự cung cấp quyền GitHub/Codespaces, thông tin ngân hàng hoặc điều kiện phát hành thật.
