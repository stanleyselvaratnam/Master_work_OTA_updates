<div align="center">
    <tr>
      <td align="center">
        <h1>Master’s Thesis</h1>
        <h2><font color=615959>Yocto Project with OTA Updates & Secure Embedded Systems</font></h2>

  <br/>

  <img src="image/drone.gif" alt="Embedded Drone System" width="400">

  <br/>

  <p align="center">
    <a href="https://www.yoctoproject.org/">
      <img src="https://img.shields.io/badge/Yocto-Scarthgap-white?style=for-the-badge&logo=yocto&logoColor=black" alt="Yocto Project">
    </a>
    &nbsp;
    <a href="https://www.toradex.com/computer-on-modules/verdin-arm-family/nxp-imx-8m-plus">
      <img src="https://img.shields.io/badge/Platform-Toradex_iMX8MP-white?style=for-the-badge&logo=linux&logoColor=black" alt="Toradex Verdin">
    </a>
    &nbsp;
    <a href="https://github.com/toradex/meta-toradex-security">
      <img src="https://img.shields.io/badge/Security-HAB4_|_CAAM-white?style=for-the-badge&logo=lock&logoColor=black" alt="Security Layer">
    </a>
    &nbsp;
    <a href="https://mender.io/">
      <img src="https://img.shields.io/badge/OTA-Mender-white?style=for-the-badge&logo=mender&logoColor=black" alt="Mender OTA">
    </a>
  </p>
</div>

## Introduction

This project is part of the Master’s thesis and focuses on building a complete embedded Linux system using the Yocto Project. The system is designed to run on multiple hardware platforms:

* QEMU ARM64 (emulated environment)
* Raspberry Pi 4
* Toradex Verdin iMX8MP

The main objective is to establish a reproducible build environment and validate system images across various platforms.
The project also aims to integrate a robust OTA update mechanism using Mender to ensure long-term maintainability of the embedded system.

## Prerequisites & Setup

### 1. Clone the Project

To ensure all meta-layers are correctly retrieved, use the recursive clone command:

```bash
git clone --recursive git@github.com:stanleyselvaratnam/Secure_OTA_Update_System_for_Embedded_Drones.git

```

### 2. External Tools & NXP Security

To support hardware enablement and secure features for the iMX8MP, manual retrieval of NXP tools is required:

1. **NXP Account:** Create an account on [NXP.com](https://www.nxp.com).
2. **Code Signing Tool (CST):** Download **IMX_CST_TOOL v4.0.1** from the [NXP Download Portal](https://www.nxp.com/webapp/sps/download/preDownload.jsp?render=true).
3. **PKI Tree Generation:** * Follow the `CST_UG.pdf` guide (Section: *Generating HAB4 Keys and Certificates*) from the [NXP Download CST_UG.pdf](https://community.nxp.com/pwmxy87654/attachments/pwmxy87654/imx-processors/202591/1/CST_UG.pdf).
* Place the resulting `IMX_CST_TOOL_NEW` folder at the **root of this project**.
* *Note: This folder is ignored by git to follow security best practices.*


### 3. Mender Artifact Signing

Before building, generate the required keys for Mender artifact verification:

```bash
./generate-mender-keys-signed.sh
```

### 4. Docker Environment

The project uses a container based on:
`FROM crops/yocto:ubuntu-22.04-base`

Launch the environment with:

```bash
docker run --rm -it -v ~/Documents/TM/yocto:/workdir testyocto --workdir=/workdir
```

This container includes all required tools for building Yocto images.

---

## Building the Different Platforms

The project supports Yocto builds for three platforms. Each platform is built using a dedicated `kas` configuration file.

### 1. QEMU ARM64 (Validation)

Used for initial tests and validation in a controlled environment.

Example build command:

```bash
KAS_BUILD_DIR=build-arm64 kas build kas_qemuarm64.yml
```

### 2. Raspberry Pi 4 (Hardware Test)

Used as a real hardware test platform to validate OTA updates with Mender.

Example build command:

```bash
KAS_BUILD_DIR=build-rpi4 kas build kas_rpi.yml
```

### 3. Toradex Verdin iMX8MP (Final Target)

The final target platform for the drone system used by Rega.
Tests include integrating Mender and managing the bootloader.

Example build command:

```bash
KAS_BUILD_DIR=build-imx8mp kas build kas_imx8mp.yml
```

---

## □ Security & OTA Strategy

The project implements a high-security standard for embedded systems:

* **OTA Updates:** Integrated Mender with **A/B partition-based rollback**.
* **Secure Boot:** Hardware-rooted trust using NXP HAB4 (High Assurance Boot).
* **Data Encryption:** External partition encryption managed via **CAAM** (Cryptographic Acceleration and Assurance Module) for hardware-accelerated security.
* **Integrity:** All Mender artifacts are digitally signed to ensure image authenticity.
---

## Yocto Layers and Commit References

Below is the complete list of Yocto layers used in the project, including their branches and exact commit references, to ensure full reproducibility of the builds:

```bash
meta-arm:
  Branch: scarthgap
  Commit: a81c19915b5b9e71ed394032e9a50fd06919e1cd
meta-custom:
  Branch: main
  Commit: 00d50c7952b126623f6281124ca3601796af4368
meta-freescale:
  Branch: scarthgap
  Commit: 902dde8c5bd29bb507ac8d37772565a6c9ab77cd
meta-freescale-3rdparty:
  Branch: scarthgap
  Commit: 70c83e96c7f75e73245cb77f1b0cada9ed4bbc6d
meta-freescale-distro:
  Branch: scarthgap
  Commit: b9d6a5d9931922558046d230c1f5f4ef6ee72345
meta-lts-mixins:
  Branch: scarthgap/u-boot
  Commit: a44882db02a0ed0f149371831bfbe067665eb42b
meta-mender:
  Branch: scarthgap
  Commit: c3064a2767be4779589bd276079d7bb535dcb481
meta-mender-kernel:
  Branch: master
  Commit: a497f4092e47d296cde5ee1b7f2015942b23462f
meta-openembedded:
  Branch: scarthgap
  Commit: 2759d8870ea387b76c902070bed8a6649ff47b56
meta-qt5:
  Branch: scarthgap
  Commit: 9ae2fe2696b10f5dc4253c4f467dc388139860bd
meta-raspberrypi:
  Branch: scarthgap
  Commit: 1091bde25e9ebaea33114edb85e4aee931d105f3
meta-security:
  Branch: scarthgap
  Commit: 97e482b71688b62ac1109d16e89368122f039cbf
meta-ti:
  Branch: scarthgap
  Commit: 5258ee2f903d8f1e0cbcb9d01488d08b57314009
meta-toradex-bsp-common:
  Branch: scarthgap-7.x.y
  Commit: 3e1311ec106758d87eaa6e39143f5a640c6e5a3a
meta-toradex-demos:
  Branch: scarthgap-7.x.y
  Commit: 4ba1cebc6909ee7a83d569e8cc748f69e6a0a24f
meta-toradex-distro:
  Branch: scarthgap-7.x.y
  Commit: c55b5b491427ac1f129dcd905bb9956feecd31a4
meta-toradex-nxp:
  Branch: scarthgap-7.x.y
  Commit: d52482a22c60d39e0049356ec7eda41411196a11
meta-toradex-security:
  Branch: scarthgap-7.x.y
  Commit: 1d0420b32946cda80a68b72d4f846d50ed5bceac
meta-toradex-tezi:
  Branch: scarthgap-7.x.y
  Commit: ec827a64343fa3fe0edb57089d60ab0bbdf94785
meta-toradex-ti:
  Branch: scarthgap-7.x.y
  Commit: 9d660de6b2ddae5ca2f3077ed9ec85243305725a
poky:
  Branch: scarthgap
  Commit: 353491479086e8d3f209d5cce0019a29e143b064
```