# 简介

基于 Buildroot 官方的 2022.2 版本修改的 InfisecOS 构建系统，目前支持构建适用于飞腾派、树莓派 4B 开发板的相关镜像

# 开发环境

Buildroot 被设计为在 x86 Linux 系统上运行，目前仅在 Ubuntu20.04、Ubuntu22.04 这三种 x86 主机上进行了开发验证，其他系统也可能支持，但是未经验证。

# 构建

## 安装依赖

Buildroot 需要主机系统上安装以下依赖包：

```bash
$ sudo apt update
$ sudo apt install debianutils sed make binutils build-essential gcc \
g++ bash patch gzip bzip2 perl tar cpio unzip rsync file bc wget git \
debootstrap qemu-user-static binfmt-support debian-archive-keyring
```

## 配置文件

|开发板|配置|内核|
|----|----|----|
|Phytium Pi|phytiumpi_defconfig| phytium kernel|
|Phytium Pi|phytiumpi_openeuler_defconfig| openEuler kernel|
|Raspberry Pi|raspberrypi4_64_defconfig| phytium kernel|
|Raspberry Pi|raspberrypi4_64_openeuler_defconfig| openEuler kernel|

## 构建过程

1. 加载 defconfig `$ make xxx_defconfig`

2. 编译 `$ make`

3. 生成的根文件系统、内核、SD 卡镜像位于 output/images 目录。

# 文档

TODO
