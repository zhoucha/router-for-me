FROM python:3.9-slim

ENV PYTHONUNBUFFERED=1

# 安装 redis-server 和 supervisor
RUN apt-get update && apt-get install -y redis-server supervisor && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 user

# 关键：设置工作目录
WORKDIR /app


COPY --chown=user:user requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=user:user cli-proxy-api config.yaml ./
RUN chmod +x cli-proxy-api

# 复制 supervisor 配置文件（内容见后文）
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 7860



# 注意：这里用 supervisor 作为主进程，而不是直接运行 cli-proxy-api
CMD ["supervisord", "-n"]