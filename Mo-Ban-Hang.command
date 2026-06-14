#!/bin/bash
# ============================================================
#  Bán hàng — mở bằng một cú double-click
#  - Nếu app đã chạy: mở thẳng app.
#  - Nếu chưa: tự bật máy ảo + container rồi mới mở.
#  Đặt file này TRONG CÙNG thư mục với docker-compose.yml
# ============================================================

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
cd "$(dirname "$0")" || exit 1

URL="http://localhost:8080"

# 1) App đã chạy sẵn -> chỉ mở, bỏ qua mọi bước khởi động
if curl -s "$URL" >/dev/null 2>&1; then
  open "$URL"
  exit 0
fi

# 2) Chưa chạy -> bật máy ảo (nếu cần) + container
echo "→ Đang bật máy ảo (Colima)..."
colima status >/dev/null 2>&1 || colima start

echo "→ Đang khởi động ứng dụng bán hàng..."
docker compose up -d

echo "→ Đang chờ ứng dụng sẵn sàng..."
for i in {1..60}; do
  curl -s "$URL" >/dev/null 2>&1 && break
  sleep 1
done

echo "→ Mở ứng dụng..."
open "$URL"
echo ""
echo "✓ Xong! Có thể đóng cửa sổ này."
