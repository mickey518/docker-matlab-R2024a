
## 1. 编译 ubuntu:22.04-x11 镜像

基于 Ubuntu 22.04 创建支持中文、东八区时区、X11 GUI 创建 ubuntu:22.04-x11 镜像

```bash
docker buildx build -f Dockerfile-ubuntu -t ubuntu:22.04-x11 .
```

## 2. 编译 matlab:R2024a 镜像

tmp 目录结构为：

```txt
| docker-matlab-R2024a
|   Dockerfile-ubuntu
|   Dockerfile
|   entrypoint.sh
|   build.sh
|   start.sh
|   tmp
|     installer_input.txt
|     license.lic
|     R2024a_Linux.iso
```

编译镜像

```bash
sh build.sh
```

## 3. 启动 matlab 容器

```bash
sh start.sh
```
