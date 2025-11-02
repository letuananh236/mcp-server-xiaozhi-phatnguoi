# mcp-server-xiaozhi

Test thử một số mcp-server để dùng với Tiểu Trí, chạy tốt trên các thiết bị Orange Pi nh ư 
[Orange Pi 5](https://orangepi.vn/shop/orange-pi-5-chip-rk3588s-ram-8gb), [Orange Pi 4A](https://orangepi.vn/shop/orange-pi-4a-phien-ban-2gb-ram), [Orange Pi 3B](https://orangepi.vn/shop/orange-pi-3b-chip-rk3566-wifi5-bt5-ram-4gb) ...

## Quick Start

1. Install dependencies 
```bash
pip install -r requirements.txt
```
Đối với Phạt nguội API, cần cài NodeJS (dùng NVM cài node 18), sau đó cài đặt chạy background trong service
```bash
sudo cp phatnguoi-api/phatnguoi-api.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable --now phatnguoi-api.service
```
File `phatnguoi.py` cai sử dụng `localhost:3033` nếu thay đổi phải sửa file này

2. Set up environment variables
```bash
export MCP_ENDPOINT=<your_mcp_endpoint>
```
hoặc tạo file `.env` và paste `export MCP_ENDPOINT=<your_mcp_endpoint>` vào đó

3. Run the calculator example
```bash
python mcp_pipe.py calculator.py
```

Or run all configured servers
```bash
python mcp_pipe.py
```

### Windows Quick Start

Chạy dự án trên Windows bằng cách sử dụng file batch `run_mcp.bat` vừa được bổ sung:

1. Cài đặt Python và đảm bảo đã thêm vào `PATH`.
2. Cài đặt các thư viện cần thiết:
   ```bat
   pip install -r requirements.txt
   ```
3. Thiết lập biến môi trường `MCP_ENDPOINT` (có thể tạo file `.env` với nội dung `export MCP_ENDPOINT=<endpoint>` giống như trên Linux).
4. Chạy server MCP:
   ```bat
   run_mcp.bat
   ```
   Có thể truyền thêm tham số nếu muốn chạy riêng lẻ, ví dụ:
   ```bat
   run_mcp.bat calculator.py
   ```

Batch script sẽ tự động đọc biến môi trường từ `.env` (nếu có) và thông báo lỗi khi chưa cấu hình `MCP_ENDPOINT` hoặc chưa cài Python.

*Requires `mcp_config.json` configuration file with server definitions (supports stdio/sse/http transport types)*

## Contributing 

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Forked from the original https://github.com/78/mcp-calculator
- API Phạt nguội lấy từ https://github.com/anyideaz/phatnguoi-api

