FROM python:3.12-slim

WORKDIR /app

COPY requirements-docker.txt .
RUN pip install --no-cache-dir -r requirements-docker.txt

COPY app.py .

# DB lưu ở /data (gắn volume) để không mất dữ liệu khi rebuild container
ENV DB_PATH=/data/shop.db
VOLUME ["/data"]

EXPOSE 5000

# 1 worker là đủ cho một quầy bán hàng (tránh tranh chấp ghi SQLite)
CMD ["gunicorn", "-b", "0.0.0.0:5000", "-w", "1", "--timeout", "120", "app:app"]
