#!/bin/sh
# 启动时按环境变量生成 Xray 配置：VLESS + WebSocket 入站，freedom 直出。
# 必填：UUID          —— 客户端连接用的 UUID，自己生成一个填进平台环境变量
# 可选：WSPATH        —— WebSocket 路径，默认 /ray（部署时建议改成随机词）
# 可选：PORT          —— 监听端口，默认 8080
# 注意：Buildfyio 运行时根文件系统只读、进程为非 root（UID 1000），
# 只有 /tmp 可写 —— 生成的配置必须写 /tmp，写镜像内路径会报 EROFS 起不来。
set -eu
: "${UUID:?需要设置环境变量 UUID}"
WSPATH="${WSPATH:-/ray}"
PORT="${PORT:-8080}"

cat > /tmp/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [ { "id": "${UUID}" } ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "${WSPATH}" }
      }
    }
  ],
  "outbounds": [ { "protocol": "freedom" } ]
}
EOF

exec /usr/local/xray/xray run -config /tmp/config.json
