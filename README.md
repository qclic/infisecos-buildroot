# secos-buildroot

基于 Buildroot 官方的 2022.2 版本修改的 SecOS 构建系统，目前支持飞腾派、树莓派 4B 开发板

# 开发环境

## 系统要求
Buildroot被设计为在x86 Linux系统上运行，我们只支持在Ubuntu20.04、Ubuntu22.04、Debian11这三种x86主机上运行phytium-linux-buildroot，不支持其他系统。
Buildroot需要主机系统上安装以下依赖包：
```
$ sudo apt update
$ sudo apt install debianutils sed make binutils build-essential gcc \
g++ bash patch gzip bzip2 perl tar cpio unzip rsync file bc wget git \
debootstrap qemu-user-static binfmt-support debian-archive-keyring
```
对于Debian11系统，需要设置PATH环境变量：`PATH=$PATH:/usr/sbin`  

## 构建过程

1. 加载 defconfig
`$ make xxx_defconfig`

2. 编译
`$ make`

3. 镜像的输出位置
生成的根文件系统、内核、img 镜像位于 output/images 目录。
