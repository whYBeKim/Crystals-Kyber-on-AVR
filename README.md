# Efficient Crystals-Kyber Implementation on 8-bit AVR Sensor Nodes

## Introduction
This code accompanies our paper (Title : "**An Optimized Instantiation of Post-Quantum MQTT protocol on 8-bit AVR Sensor Nodes**”) accepted at [[AsiaCCS 2025, Cycle 1](https://asiaccs2025.hust.edu.vn/)]. Please email <darania@kookmin.ac.kr> if you have any suggestions for additions or improvements of my code. In the future, the goal of this project is to implement Post-Quantum Cryptography in constrained devices such as 8-bit AVR and 16-bit MSP430. Ultimately, I would like to design a PQC library for an AVR environment with minimal stack usage. If you have input about what should be covered, I'd be grateful for any input.

## What This code is trying to achieve
* It aims to properly port the implementation of [PQM4](https://github.com/mupq/pqm4) to the AVR environment. This code is written in a way that is easy to read and understand.

* We design the optimal modular arithmetic to implement Kyber in an 8-bit AVR environment. In our paper, we present  Signed LUT-based arithmetic for Kyber suitable for 8-bit AVR environment. In addition, we aims to apply as much as possible all the latest optimization implementation techniques for Crystals-Kyber. Moreover, assembly code for NTT for AVR environment is provided. Unfortunately, the merge technique for NTT implementation could not be applied due to the limitation of general-purpose registers. Perhaps this will become a new research topic in the future.

## SetUp/Code
The description of **SetUp** and **Code** is as follows:

* **SetUp** : We develop and benchmark the code using [Microchip studio](https://www.microchip.com/). Please select "New Project" in “Microchip studio” or “Atmel studio” and paste our code. Our target device is selected in `ATmega4808` with `6 Kbytes SRAM`, and `48 Kbytes flash memory` (Kyber-512). For Kyber-768 and Kyber-1024, we select `ATmega1280p`, which has `8 Kbytes SRAM`. The compile tool is `avr-gcc 5.4.0`, and we compile the code with the `-O3` option. 
We use an 8-bit AVR version of keccak implementation provided by [XKCP](https://github.com/XKCP/XKCP) library. Our Kyber implementation was designed based on optimized [PQM4](https://github.com/mupq/pqm4) code. “Code execution takes a long time! Please wait long enough that it's not a bug.”

* **Code** : One can select security level of Kyber in line 5 of `params.h`. The available options are 2, 3, and 4, for security level 1, 3, and 5, respectively. The executable file starts from the `main.c`, and can be executed for each API of Kyber KEM. 
Performance measurement can be checked through the register status information of [Microchip studio](https://www.microchip.com/). If set the breaking point to the KEM api on `main.c` and check the register status information, then one can measure the same performance as the summited paper. Our **Signed LUT reduction** is defined in `reduce.S`, and butterfies are defined in `LUT_ntt.S` and `LUT_invntt.S`, respectively. Except for the dependent files (`LUT_butterfly.i`, `LUT_xN_butterfly.i`, and so on) separated for readability, our code organization is basically the same as the stack version of [PQM4](https://github.com/mupq/pqm4).

## Optimization strategy
The code for this project is provided in two versions. The `LUT-based Kyber(stack)` version is the code implemented placing LUTs to stack, and the `LUT-based Kyber(Flash_memory)` is the code implemented placing LUTs to flash memory (program memory). The optimization methods of our code are as follows: 

- Signed LUT arithmetic (placing LUTs in stack or flash memory)
  + Our main contributions include alternatives to Montgomery and Barrett arithmetic. Specifically, Montgomery and Barrett reduction are replaced by Signed LUT reduction and small Signed LUT reduction, respectively.
- Polynomial Alignment and Cross Access
- Using Karatsuba multiplication
- Hand-written assembly NTT and Inverse NTT
- Streaming public matrix A and noise e [[PQM4](https://github.com/mupq/pqm4)]
- Using [XKCP](https://github.com/XKCP/XKCP) library for sha3 and SHAKE
- Pre-hased public key for Kyber.CCAKEM Encapsulation

## Secure GCM
For the KEM-MQTT implementation, AES-GCM adopts SCA-resistant methodology proposed in [[here](https://www.mdpi.com/2076-3417/10/8/2821)]. This code was implemented by [[Seog Chung Seo](https://github.com/SeogChungSeo)].

## Abstract of our paper
Since the selection of the National Institute of Standards and Technology (NIST) Post-Quantum Cryptography (PQC) standardization algorithms, research on integrating PQC into security protocols such as TLS/SSL, IPSec, and DNSSEC has been actively pursued. However, PQC migration for Internet of Things (IoT) communication protocols remains largely unexplored. Embedded devices in IoT environments have limited computational power and memory, making it crucial to optimize PQC algorithms for efficient computation and minimal memory usage when deploying them on low-spec IoT devices. In this paper, we introduce KEM-MQTT, a lightweight and efficient Key Encapsulation Mechanism (KEM) for the Message Queuing Telemetry Transport (MQTT) protocol, widely used in IoT environments. Our approach applies the NIST KEM algorithm Crystals-Kyber (Kyber) while leveraging MQTT’s characteristics and sensor node constraints. To enhance efficiency, we address certificate verification issues and adopt KEMTLS to eliminate the need for Post-Quantum Digital Signatures Algorithm (PQC-DSA) in mutual authentication. As a result, KEM-MQTT retains its lightweight properties while maintaining the security guarantees of TLS 1.3. We identify inefficiencies in existing Kyber implementations on 8-bit AVR microcontrollers (MCUs), which are highly resource-constrained. To address this, we propose novel implementation techniques that optimize Kyber for AVR, focusing on high-speed execution, reduced memory consumption, and secure implementation, including Signed LookUp-Table (LUT) Reduction. Our optimized Kyber achieves performance gains of 81%,75%, and 85% in the KeyGen, Encaps, and DeCaps processes, respectively, compared to the reference implementation. With approximately 3 KB of stack usage, our Kyber implementation surpasses all state-of-the-art Elliptic Curve Diffie-Hellman (ECDH) implementations. Finally, in KEM-MQTT using Kyber-512, an 8-bit AVR device completes the handshake preparation process in 4.32 seconds, excluding the physical transmission and reception times.
