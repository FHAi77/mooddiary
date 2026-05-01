# 使用 Python 3.11 作为基础镜像
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 复制依赖文件并安装
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY . .

# 创建数据目录用于持久化 SQLite 数据库
RUN mkdir -p /app/data

# 修改数据库路径为数据目录
ENV DATABASE_URL=sqlite:////app/data/mooddiary.db

# 暴露端口
EXPOSE 5000

# 启动命令
CMD ["python", "app.py"]
