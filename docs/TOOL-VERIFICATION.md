# Theo dõi công cụ và xác minh Tuto

Ngày: 02/11/2026, giờ Việt Nam. Mã nguồn được kiểm tra cục bộ: main tại commit `71d6a14917ef779953d9b443d10849456edd0cd2`.

## Kết quả có bằng chứng

| Công việc | Trạng thái | Bằng chứng và giới hạn |
| --- | --- | --- |
| Kiểm thử logic tài chính | ĐẠT cục bộ | npm test: 9 kiểm thử đạt. Không phải log kiểm thử trong Codespace. |
| Build web | ĐẠT cục bộ | npm run build thành công. |
| Khởi động preview | ĐẠT cục bộ | Chạy mới, tái sử dụng server, bảo vệ dịch vụ chiếm cổng, từ chối cổng không hợp lệ. Máy chủ thử nghiệm đã được dừng. |
| Lấy mã mới vào Codespace | Đã quan sát qua TinyFish | Run 7fcfe5cb báo Git Pull, cây làm việc sạch và thấy hai tệp cấu hình mới. SHA đầy đủ trong Codespace chưa được đọc độc lập. |
| Chọn tác vụ khởi động | Đã quan sát | Tác vụ Tuto xuất hiện và được chọn. Tên tác vụ/cổng không đủ để chứng minh lệnh chạy thành công. |
| Web Tuto tại cổng 4180 | ĐẠT trong phiên trình duyệt được kiểm tra | Run 886f3052 mở trực tiếp URL app, thấy giao diện xanh Tuto và dữ liệu mẫu. Không gặp 401 hoặc trang lỗi trong lần này. |
| Điều hướng UI trong Codespace | ĐẠT phạm vi đọc | Đã mở Trang chủ, Túi tiền, Thu chi, Mục tiêu, Thống kê, Chuyển tiền. Không gửi giao dịch hoặc thay đổi dữ liệu để thử. |
| SonarQube scan / Quality Gate | CHƯA CHẠY | Có skill nhưng không có MCP phân tích, CLI sonar, sonar-project.properties hoặc project key xác định. Không có kết quả Sonar hoặc kết luận sạch lỗi. |
| Plugin Eval tự động | CHƯA CHẠY | Có skill nhưng không có CLI plugin-eval hoặc bản plugin cục bộ đủ manifest/source. Không có điểm, benchmark hay số token đo thực tế. |
| KhanhBank Co-Pilot | Đã áp dụng hướng dẫn điều phối | Phân tách phạm vi, kiểm tra đúng đích, phân biệt kết quả cục bộ và trình duyệt, ghi nhận chặn. Không phải kiểm toán độc lập hoặc chứng nhận. |

## Đường dẫn bằng chứng

- Codespace app: https://super-duper-space-garbanzo-96wx46544x5r2vx6-4180.app.github.dev/#home
- Lấy mã/tác vụ: https://agent.tinyfish.ai/runs/7fcfe5cb-22d9-43ad-8618-9dbf0e492f8c
- Kiểm tra trực tiếp app: https://agent.tinyfish.ai/runs/886f3052-2dce-4512-a597-f1efb591e74c

Cổng giữ riêng tư. Link có thể yêu cầu phiên GitHub hợp lệ và chỉ phục vụ khi Codespace/server đang chạy. Không kết luận 401 đã được khắc phục vĩnh viễn cho mọi phiên.

## Rà soát quy trình theo hướng dẫn Plugin Eval

Đây là rà soát bằng chứng trong phiên, không phải đầu ra CLI Plugin Eval:

- Điểm tốt: đã tách kiểm thử mã khỏi xác minh app; không dùng README, nhãn cổng hoặc tác vụ làm bằng chứng thay cho giao diện thực.
- Cần cải thiện: các lần TinyFish trước đã suy diễn server chạy/dừng từ nhãn cổng và HTTP 401. Báo cáo này chỉ chấp nhận điều đã quan sát; 401 là lỗi xác thực, không chứng minh tiến trình server dừng.
- Ưu tiên tiếp: SonarQube cần kết nối phân tích và project hợp lệ; Plugin Eval cần CLI và bản plugin cục bộ để đánh giá đầy đủ. Không tự giả định tổ chức, project key hoặc thông tin đăng nhập.
- Khi chưa có các điều kiện trên, tiếp tục kiểm thử ứng dụng độc lập nhưng không đổi nhãn kết quả thành SonarQube/Plugin Eval.

## Trạng thái mốc 1

Đã xác nhận phần mở ứng dụng và điều hướng trong Codespace. Các kiểm thử tự động nêu trên đã đạt cục bộ; chưa thu được log chạy cùng bộ kiểm thử trong Codespace. Quét SonarQube/benchmark Plugin Eval còn là hạng mục riêng chưa thực hiện. APK và ngân hàng thật không nằm trong lần kiểm tra này.
