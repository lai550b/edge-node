# 自有节点镜像：XTLS 官方 Xray-core 二进制 + 透明启动脚本，无任何第三方代码。
# 构建时从官方 GitHub Release 下载，并用写死的 SHA256 校验。
# 版本 v26.10.29 的 SHA2-256 已于 2026-10-31 对照官方发布页的 .dgst 文件核对：
#   https://github.com/XTLS/Xray-core/releases/tag/v26.10.29
FROM alpine:3.20

ARG XRAY_VERSION=v26.10.29
ARG XRAY_SHA256=8a5f3e6a1057e4bd0f8a7c57c9d91204b4be0b74222a6e210d070603101163c2

RUN apk add --no-cache ca-certificates curl unzip tzdata \
 && curl -fsSL -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-64.zip" \
 && echo "${XRAY_SHA256}  /tmp/xray.zip" | sha256sum -c - \
 && mkdir -p /usr/local/xray \
 && unzip -o /tmp/xray.zip -d /usr/local/xray \
 && chmod +x /usr/local/xray/xray \
 && rm -f /tmp/xray.zip

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
