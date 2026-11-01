# 自有节点（官方 Xray，透明构建）

给陛下自备的备用节点包。全部内容就三个文件，谁都能逐行看：

- `Dockerfile`：从 XTLS 官方 GitHub Release 拉 Xray-core v26.10.29 二进制，
  用写死的 SHA256 校验（已对照官方 .dgst 核对），装进 Alpine 小镜像。
- `entrypoint.sh`：按环境变量 `UUID` / `WSPATH` / `PORT` 生成配置并启动。
  协议 VLESS + WebSocket，出口 freedom 直出，不加任何额外功能。
- 本文件。

## 部署到 Buildfyio（免卡 Hobby）

1. 注册 Buildfyio（邮箱 + 密码），新建项目，代码指向含本 Dockerfile 的仓库。
2. 环境变量：`UUID`=新生成的 UUID，`WSPATH`=随机路径（如 /xk39q），`PORT=8080`。
3. 区域 fra1（法兰克福，平台目前唯一区域）。域名形如 `<app>.buildfyio.com`，
   平台自动签 HTTPS 证书并终结 TLS，容器内跑明文 WS 即可（标准边缘终结模式）。
4. 验收（两条都过才算交付）：
   - 客户端连上后访问 generate_204 返回 204；
   - 查到的出口 IP 与 `<app>.buildfyio.com` 的 A 记录一致（Hetzner 直连，非 Cloudflare）。
5. 客户端：把 vless:// 分享链接导入 Karing 即可用。

## 已知限制（先说清）

- 免费层每月约 100 小时运行时长，只够当备用节点，不当主力。
- 免费 PaaS 跑代理可能违反平台条款，账号有被封风险，节点不保证长久。
- 若改用自己的海外 VPS：同一份 config 逻辑可直接装官方 sing-box/Xray，
  不依赖本 Dockerfile，步骤另给。
