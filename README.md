<div align="center">

<img src="https://qclic.github.io/images/site/logo.svg" alt="infisecos-logo" width="64">

</div>

<h2 align="center">InfisecOS</h1>

<p align="center">A security operating system focused on the AIoT field</p>

<!-- <div align="center">

[![GitHub stars](https://img.shields.io/github/stars/qclic/InfisecOS?logo=github)](https://github.com/qclic/InfisecOS/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/qclic/InfisecOS?logo=github)](https://github.com/qclic/InfisecOS/network)
[![license](https://img.shields.io/github/license/qclic/InfisecOS)](https://github.com/ZCShou/GoGoGo/blob/master/LICENSE)

</div> -->

English | [中文版](README_CN.md)

# Introduction

The InfisecOS build system, modified based on the official Buildroot 2022.2 version.

# Build

## Development environment

Buildroot is designed to run on x86 Linux systems, and it has currently been developed and validated only on x86 hosts running Ubuntu 20.04 and Ubuntu 22.04. Other systems may also be supported, but they have not been validated.

## Install dependencies

1. Install the following dependencies on the development host system:

    ```bash
    $ sudo apt update
    $ sudo apt install sed make binutils build-essential gcc \
    g++ bash patch gzip bzip2 perl tar cpio unzip rsync file bc wget git \
    binfmt-support
    ```

2. Since some packages are developed in Rust, it is necessary to install the Rust development environment. Please refer to the [official Rust installation instructions](https://www.rust-lang.org/learn/get-started) for details.

## Configuration file

Currently, direct building of images for the Phytium Pi and Raspberry Pi 4B development boards is supported. The corresponding configuration file information is as follows:

| config | Development Board | Kernel | Version |
|----|----|----|----|
| configs/phytiumpi_defconfig | Phytium Pi| [Phytium kernel](https://gitee.com/phytium_embedded/phytium-linux-kernel) | 5.10.209 |
| configs/phytiumpi_rt_defconfig | Phytium Pi| [Phytium kernel](https://gitee.com/phytium_embedded/phytium-linux-kernel) with PREEMPT_RT patch integrated | 5.10.209 |
| configs/phytiumpi_openeuler_defconfig | Phytium Pi | [openEuler kernel](https://gitee.com/openeuler/phytium-kernel) | 5.10.x / openEuler-22.03-LTS |
| configs/raspberrypi4_64_defconfig | Raspberry Pi | [raspberrypi kernel](https://github.com/raspberrypi/linux) | 5.10.110 |
| configs/raspberrypi4_64_openeuler_defconfig | Raspberry Pi | [openEuler kernel](https://gitee.com/openeuler/raspberrypi-kernel) | 5.10.0-235.0.0 / openEuler-22.03-LTS-SP4 |
| configs/raspberrypi4_64_openeuler_rt_defconfig | Raspberry Pi | [openEuler kernel](https://gitee.com/openeuler/raspberrypi-kernel) with PREEMPT_RT patch integrated | 5.10.0-235.0.0 / openEuler-22.03-LTS-SP4 |

## Build process

1. Use the `make xxx_defconfig` command to load the defconfig and generate the default configuration file `.config`.

2. Start the compilation by running `make`.

3. After a successful build, the root filesystem, kernel, SD card image, and other related files will be generated in the output/images directory.

# Document

Refer to [The InfisecOS Document](https://qclic.github.io/) for more information about this project.

# License

The source code and documentation of InfisecOS are primarily licensed under the MIT license, while some components retain their original open-source licenses.
