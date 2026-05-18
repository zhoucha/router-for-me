FROM python:3.9-slim

ENV PYTHONUNBUFFERED=1

# 安装 redis-server 和 supervisor
RUN apt-get update && apt-get install -y redis-server supervisor wget && rm -rf /var/lib/apt/lists/*


RUN useradd -m -u 1000 user

# 关键：设置工作目录
WORKDIR /app


# 关键：从你的 GitHub Release 下载 cli-proxy-api 二进制文件
RUN wget -O /app/cli-proxy-api https://github.com/zhoucha/router-for-me/releases/latest/download/cli-proxy-api && \
    chmod +x /app/cli-proxy-api

# 复制 supervisor 配置文件（内容见后文）
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 7860


# 注意：这里用 supervisor 作为主进程，而不是直接运行 cli-proxy-api
CMD ["supervisord", "-n"]