<div align="center">

<img src="https://qclic.github.io/images/site/logo.svg" alt="infisecos-logo" width="64">

</div>

<h2 align="center">无极安全操作系统</h1>

<p align="center">一个专注于 AIoT 领域的安全操作系统</p>

<!-- <div align="center">

[![GitHub stars](https://img.shields.io/github/stars/qclic/InfisecOS?logo=github)](https://github.com/qclic/InfisecOS/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/qclic/InfisecOS?logo=github)](https://github.com/qclic/InfisecOS/network)
[![license](https://img.shields.io/github/license/qclic/InfisecOS)](https://github.com/ZCShou/GoGoGo/blob/master/LICENSE)

</div> -->

[English](README.md) | 中文版

# 简介

基于 Buildroot 官方的 2022.2 版本修改而来的 InfisecOS 构建系统。

# 构建

## 开发环境

Buildroot 被设计为在 x86 Linux 系统上运行，目前仅在 Ubuntu 20.04、Ubuntu 22.04 的 x86 主机上进行了开发验证，其他系统也可能支持，但是未经验证。

## 安装依赖

1. 在开发主机系统上安装以下依赖包：

    ```bash
    $ sudo apt update
    $ sudo apt install sed make binutils build-essential gcc \
    g++ bash patch gzip bzip2 perl tar cpio unzip rsync file bc wget git \
    binfmt-support
    ```

2. 由于部分软件包由 Rust 语言开发，因此，需要安装 Rust 开发环境，详见 [Rust 官方安装说明](https://www.rust-lang.org/learn/get-started)。

## 配置文件

目前支持直接构建适用于飞腾派、树莓派 4B 开发板的相关镜像，对应的配置文件信息如下所示：

| 配置 | 开发板 | 内核 | 版本 |
|----|----|----|----|
| configs/phytiumpi_defconfig | Phytium Pi| [Phytium kernel](https://gitee.com/phytium_embedded/phytium-linux-kernel) | 5.10.209 |
| configs/phytiumpi_rt_defconfig | Phytium Pi| 合入了 PREEMPT_RT 补丁的 [Phytium kernel](https://gitee.com/phytium_embedded/phytium-linux-kernel) | 5.10.209 |
| configs/phytiumpi_openeuler_defconfig | Phytium Pi | [openEuler kernel](https://gitee.com/openeuler/phytium-kernel) | 5.10.x / openEuler-22.03-LTS |
| configs/raspberrypi4_64_defconfig | Raspberry Pi | [raspberrypi kernel](https://github.com/raspberrypi/linux) | 5.10.110 |
| configs/raspberrypi4_64_openeuler_defconfig | Raspberry Pi | [openEuler kernel](https://gitee.com/openeuler/raspberrypi-kernel) | 5.10.0-235.0.0 / openEuler-22.03-LTS-SP4 |
| configs/raspberrypi4_64_openeuler_rt_defconfig | Raspberry Pi | 合入了 PREEMPT_RT 补丁的 [openEuler kernel](https://gitee.com/openeuler/raspberrypi-kernel) | 5.10.0-235.0.0 / openEuler-22.03-LTS-SP4 |

## 构建过程

1. 通过 `make xxx_defconfig` 命令加载 defconfig 以生成默认配置 `.config`

2. 使用 `make` 命令启动编译

3. 生成的根文件系统、内核、SD 卡镜像位于 `output/images` 目录中

# 文档

查看 [The InfisecOS Document](https://qclic.github.io/) 以了解更多关于本项目的信息。

# 开源许可

InfisecOS 的源代码和文档主要使用 MIT 协议， 部分组件保持原有开源协议！
