# ubuntu 平台开发指引 - desktop

## 1. 编译镜像 - desktop

### 1.1 编译镜像 - desktop (推荐：本地编译)
对于本仓库（Portable Fork）, 强烈建议使用本地资源进行编译，以避免 `apt-get` 网络连接失败或下载超时问题。

```bash
# 切换路径为项目根目录
cd TAD_Sim_portable

# 推荐：使用本地 Dockerfile 编译 (快速、无网络依赖)
docker build -f Dockerfile_local . -t tadsim/desktop:v1.0
```

### 1.2 其他编译方式 (需联网)
如果必须联网构建, 可以尝试原始 Dockerfile（可能因源限制而失败）：

```bash
# 使用 docker build 按当前平台进行构建
docker build . -t tadsim/desktop:v1.0 --build-arg BASE_MIRROR=ccr.ccs.tencentyun.com/library/
```
