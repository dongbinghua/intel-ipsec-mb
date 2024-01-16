;
;; Copyright (c) 2017-2023, Intel Corporation
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:
;;
;;     * Redistributions of source code must retain the above copyright notice,
;;       this list of conditions and the following disclaimer.
;;     * Redistributions in binary form must reproduce the above copyright
;;       notice, this list of conditions and the following disclaimer in the
;;       documentation and/or other materials provided with the distribution.
;;     * Neither the name of Intel Corporation nor the names of its contributors
;;       may be used to endorse or promote products derived from this software
;;       without specific prior written permission.
;;
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
;; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
;; OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
;; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;

;; Authors:
;;   Shay Gueron (1, 2), Regev Shemy (2), Tomasz kantecki (2)
;;   (1) University of Haifa, Israel
;;   (2) Intel Corporation

;; In System V AMD64 ABI
;;	callee saves: RBX, RBP, R12-R15
;; Windows x64 ABI
;;	callee saves: RBX, RBP, RDI, RSI, RSP, R12-R15

;; Clobbers ZMM0-31 and K1 to K7

%include "include/des_avx512.inc"

;;; ========================================================
;;; DATA

mksection .rodata
default rel
align 64
mask_values:
        dd 0x04000000, 0x04000000, 0x04000000, 0x04000000
        dd 0x04000000, 0x04000000, 0x04000000, 0x04000000
        dd 0x04000000, 0x04000000, 0x04000000, 0x04000000
        dd 0x04000000, 0x04000000, 0x04000000, 0x04000000
        dd 0x40240202, 0x40240202, 0x40240202, 0x40240202
        dd 0x40240202, 0x40240202, 0x40240202, 0x40240202
        dd 0x40240202, 0x40240202, 0x40240202, 0x40240202
        dd 0x40240202, 0x40240202, 0x40240202, 0x40240202
        dd 0x00001110, 0x00001110, 0x00001110, 0x00001110
        dd 0x00001110, 0x00001110, 0x00001110, 0x00001110
        dd 0x00001110, 0x00001110, 0x00001110, 0x00001110
        dd 0x00001110, 0x00001110, 0x00001110, 0x00001110
        dd 0x01088000, 0x01088000, 0x01088000, 0x01088000
        dd 0x01088000, 0x01088000, 0x01088000, 0x01088000
        dd 0x01088000, 0x01088000, 0x01088000, 0x01088000
        dd 0x01088000, 0x01088000, 0x01088000, 0x01088000
        dd 0x00000001, 0x00000001, 0x00000001, 0x00000001
        dd 0x00000001, 0x00000001, 0x00000001, 0x00000001
        dd 0x00000001, 0x00000001, 0x00000001, 0x00000001
        dd 0x00000001, 0x00000001, 0x00000001, 0x00000001
        dd 0x0081000C, 0x0081000C, 0x0081000C, 0x0081000C
        dd 0x0081000C, 0x0081000C, 0x0081000C, 0x0081000C
        dd 0x0081000C, 0x0081000C, 0x0081000C, 0x0081000C
        dd 0x0081000C, 0x0081000C, 0x0081000C, 0x0081000C
        dd 0x00000020, 0x00000020, 0x00000020, 0x00000020
        dd 0x00000020, 0x00000020, 0x00000020, 0x00000020
        dd 0x00000020, 0x00000020, 0x00000020, 0x00000020
        dd 0x00000020, 0x00000020, 0x00000020, 0x00000020
        dd 0x00000040, 0x00000040, 0x00000040, 0x00000040
        dd 0x00000040, 0x00000040, 0x00000040, 0x00000040
        dd 0x00000040, 0x00000040, 0x00000040, 0x00000040
        dd 0x00000040, 0x00000040, 0x00000040, 0x00000040
        dd 0x00400400, 0x00400400, 0x00400400, 0x00400400
        dd 0x00400400, 0x00400400, 0x00400400, 0x00400400
        dd 0x00400400, 0x00400400, 0x00400400, 0x00400400
        dd 0x00400400, 0x00400400, 0x00400400, 0x00400400
        dd 0x00000800, 0x00000800, 0x00000800, 0x00000800
        dd 0x00000800, 0x00000800, 0x00000800, 0x00000800
        dd 0x00000800, 0x00000800, 0x00000800, 0x00000800
        dd 0x00000800, 0x00000800, 0x00000800, 0x00000800
        dd 0x00002000, 0x00002000, 0x00002000, 0x00002000
        dd 0x00002000, 0x00002000, 0x00002000, 0x00002000
        dd 0x00002000, 0x00002000, 0x00002000, 0x00002000
        dd 0x00002000, 0x00002000, 0x00002000, 0x00002000
        dd 0x00100000, 0x00100000, 0x00100000, 0x00100000
        dd 0x00100000, 0x00100000, 0x00100000, 0x00100000
        dd 0x00100000, 0x00100000, 0x00100000, 0x00100000
        dd 0x00100000, 0x00100000, 0x00100000, 0x00100000
        dd 0x00004000, 0x00004000, 0x00004000, 0x00004000
        dd 0x00004000, 0x00004000, 0x00004000, 0x00004000
        dd 0x00004000, 0x00004000, 0x00004000, 0x00004000
        dd 0x00004000, 0x00004000, 0x00004000, 0x00004000
        dd 0x00020000, 0x00020000, 0x00020000, 0x00020000
        dd 0x00020000, 0x00020000, 0x00020000, 0x00020000
        dd 0x00020000, 0x00020000, 0x00020000, 0x00020000
        dd 0x00020000, 0x00020000, 0x00020000, 0x00020000
        dd 0x02000000, 0x02000000, 0x02000000, 0x02000000
        dd 0x02000000, 0x02000000, 0x02000000, 0x02000000
        dd 0x02000000, 0x02000000, 0x02000000, 0x02000000
        dd 0x02000000, 0x02000000, 0x02000000, 0x02000000
        dd 0x08000000, 0x08000000, 0x08000000, 0x08000000
        dd 0x08000000, 0x08000000, 0x08000000, 0x08000000
        dd 0x08000000, 0x08000000, 0x08000000, 0x08000000
        dd 0x08000000, 0x08000000, 0x08000000, 0x08000000
        dd 0x00000080, 0x00000080, 0x00000080, 0x00000080
        dd 0x00000080, 0x00000080, 0x00000080, 0x00000080
        dd 0x00000080, 0x00000080, 0x00000080, 0x00000080
        dd 0x00000080, 0x00000080, 0x00000080, 0x00000080
        dd 0x20000000, 0x20000000, 0x20000000, 0x20000000
        dd 0x20000000, 0x20000000, 0x20000000, 0x20000000
        dd 0x20000000, 0x20000000, 0x20000000, 0x20000000
        dd 0x20000000, 0x20000000, 0x20000000, 0x20000000
        dd 0x90000000, 0x90000000, 0x90000000, 0x90000000
        dd 0x90000000, 0x90000000, 0x90000000, 0x90000000
        dd 0x90000000, 0x90000000, 0x90000000, 0x90000000
        dd 0x90000000, 0x90000000, 0x90000000, 0x90000000

align 64
init_perm_consts:
        dd 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f
        dd 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f
        dd 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f
        dd 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f, 0x0f0f0f0f
        dd 0x0000ffff, 0x0000ffff, 0x0000ffff, 0x0000ffff
        dd 0x0000ffff, 0x0000ffff, 0x0000ffff, 0x0000ffff
        dd 0x0000ffff, 0x0000ffff, 0x0000ffff, 0x0000ffff
        dd 0x0000ffff, 0x0000ffff, 0x0000ffff, 0x0000ffff
        dd 0x33333333, 0x33333333, 0x33333333, 0x33333333
        dd 0x33333333, 0x33333333, 0x33333333, 0x33333333
        dd 0x33333333, 0x33333333, 0x33333333, 0x33333333
        dd 0x33333333, 0x33333333, 0x33333333, 0x33333333
        dd 0x00ff00ff, 0x00ff00ff, 0x00ff00ff, 0x00ff00ff
        dd 0x00ff00ff, 0x00ff00ff, 0x00ff00ff, 0x00ff00ff
        dd 0x00ff00ff, 0x00ff00ff, 0x00ff00ff, 0x00ff00ff
        dd 0x00ff00ff, 0x00ff00ff, 0x00ff00ff, 0x00ff00ff
        dd 0x55555555, 0x55555555, 0x55555555, 0x55555555
        dd 0x55555555, 0x55555555, 0x55555555, 0x55555555
        dd 0x55555555, 0x55555555, 0x55555555, 0x55555555
        dd 0x55555555, 0x55555555, 0x55555555, 0x55555555

;;; S-Box table
align 64
S_box_flipped:
        ;; SBOX0
        dw 0x07, 0x02, 0x0c, 0x0f, 0x04, 0x0b, 0x0a, 0x0c
        dw 0x0b, 0x07, 0x06, 0x09, 0x0d, 0x04, 0x00, 0x0a
        dw 0x02, 0x08, 0x05, 0x03, 0x0f, 0x06, 0x09, 0x05
        dw 0x08, 0x01, 0x03, 0x0e, 0x01, 0x0d, 0x0e, 0x00
        dw 0x00, 0x0f, 0x05, 0x0a, 0x07, 0x02, 0x09, 0x05
        dw 0x0e, 0x01, 0x03, 0x0c, 0x0b, 0x08, 0x0c, 0x06
        dw 0x0f, 0x03, 0x06, 0x0d, 0x04, 0x09, 0x0a, 0x00
        dw 0x02, 0x04, 0x0d, 0x07, 0x08, 0x0e, 0x01, 0x0b
        ;; SBOX1
        dw 0x0f, 0x00, 0x09, 0x0a, 0x06, 0x05, 0x03, 0x09
        dw 0x01, 0x0e, 0x04, 0x03, 0x0c, 0x0b, 0x0a, 0x04
        dw 0x08, 0x07, 0x0e, 0x01, 0x0d, 0x02, 0x00, 0x0c
        dw 0x07, 0x0d, 0x0b, 0x06, 0x02, 0x08, 0x05, 0x0f
        dw 0x0c, 0x0b, 0x03, 0x0d, 0x0f, 0x0c, 0x06, 0x00
        dw 0x02, 0x05, 0x08, 0x0e, 0x01, 0x02, 0x0d, 0x07
        dw 0x0b, 0x01, 0x00, 0x06, 0x04, 0x0f, 0x09, 0x0a
        dw 0x0e, 0x08, 0x05, 0x03, 0x07, 0x04, 0x0a, 0x09
        ;; SBOX2
        dw 0x05, 0x0b, 0x08, 0x0d, 0x06, 0x01, 0x0d, 0x0a
        dw 0x09, 0x02, 0x03, 0x04, 0x0f, 0x0c, 0x04, 0x07
        dw 0x00, 0x06, 0x0b, 0x08, 0x0c, 0x0f, 0x02, 0x05
        dw 0x07, 0x09, 0x0e, 0x03, 0x0a, 0x00, 0x01, 0x0e
        dw 0x0b, 0x08, 0x04, 0x02, 0x0c, 0x06, 0x03, 0x0d
        dw 0x00, 0x0b, 0x0a, 0x07, 0x06, 0x01, 0x0f, 0x04
        dw 0x0e, 0x05, 0x01, 0x0f, 0x02, 0x09, 0x0d, 0x0a
        dw 0x09, 0x00, 0x07, 0x0c, 0x05, 0x0e, 0x08, 0x03
        ;; SBOX3
        dw 0x0e, 0x05, 0x08, 0x0f, 0x00, 0x03, 0x0d, 0x0a
        dw 0x07, 0x09, 0x01, 0x0c, 0x09, 0x0e, 0x02, 0x01
        dw 0x0b, 0x06, 0x04, 0x08, 0x06, 0x0d, 0x03, 0x04
        dw 0x0c, 0x00, 0x0a, 0x07, 0x05, 0x0b, 0x0f, 0x02
        dw 0x0b, 0x0c, 0x02, 0x09, 0x06, 0x05, 0x08, 0x03
        dw 0x0d, 0x00, 0x04, 0x0a, 0x00, 0x0b, 0x07, 0x04
        dw 0x01, 0x0f, 0x0e, 0x02, 0x0f, 0x08, 0x05, 0x0e
        dw 0x0a, 0x06, 0x03, 0x0d, 0x0c, 0x01, 0x09, 0x07
        ;; SBOX4
        dw 0x04, 0x02, 0x01, 0x0f, 0x0e, 0x05, 0x0b, 0x06
        dw 0x02, 0x08, 0x0c, 0x03, 0x0d, 0x0e, 0x07, 0x00
        dw 0x03, 0x04, 0x0a, 0x09, 0x05, 0x0b, 0x00, 0x0c
        dw 0x08, 0x0d, 0x0f, 0x0a, 0x06, 0x01, 0x09, 0x07
        dw 0x07, 0x0d, 0x0a, 0x06, 0x02, 0x08, 0x0c, 0x05
        dw 0x04, 0x03, 0x0f, 0x00, 0x0b, 0x04, 0x01, 0x0a
        dw 0x0d, 0x01, 0x00, 0x0f, 0x0e, 0x07, 0x09, 0x02
        dw 0x03, 0x0e, 0x05, 0x09, 0x08, 0x0b, 0x06, 0x0c
        ;; SBOX5
        dw 0x03, 0x09, 0x00, 0x0e, 0x09, 0x04, 0x07, 0x08
        dw 0x05, 0x0f, 0x0c, 0x02, 0x06, 0x03, 0x0a, 0x0d
        dw 0x08, 0x07, 0x0b, 0x00, 0x04, 0x01, 0x0e, 0x0b
        dw 0x0f, 0x0a, 0x02, 0x05, 0x01, 0x0c, 0x0d, 0x06
        dw 0x05, 0x02, 0x06, 0x0d, 0x0e, 0x09, 0x00, 0x06
        dw 0x02, 0x04, 0x0b, 0x08, 0x09, 0x0f, 0x0c, 0x01
        dw 0x0f, 0x0c, 0x08, 0x07, 0x03, 0x0a, 0x0d, 0x00
        dw 0x04, 0x03, 0x07, 0x0e, 0x0a, 0x05, 0x01, 0x0b
        ;; SBOX6
        dw 0x02, 0x08, 0x0c, 0x05, 0x0f, 0x03, 0x0a, 0x00
        dw 0x04, 0x0d, 0x09, 0x06, 0x01, 0x0e, 0x06, 0x09
        dw 0x0d, 0x02, 0x03, 0x0f, 0x00, 0x0c, 0x05, 0x0a
        dw 0x07, 0x0b, 0x0e, 0x01, 0x0b, 0x07, 0x08, 0x04
        dw 0x0b, 0x06, 0x07, 0x09, 0x02, 0x08, 0x04, 0x07
        dw 0x0d, 0x0b, 0x0a, 0x00, 0x08, 0x05, 0x01, 0x0c
        dw 0x00, 0x0d, 0x0c, 0x0a, 0x09, 0x02, 0x0f, 0x04
        dw 0x0e, 0x01, 0x03, 0x0f, 0x05, 0x0e, 0x06, 0x03
        ;; SBOX7
        dw 0x0b, 0x0e, 0x05, 0x00, 0x06, 0x09, 0x0a, 0x0f
        dw 0x01, 0x02, 0x0c, 0x05, 0x0d, 0x07, 0x03, 0x0a
        dw 0x04, 0x0d, 0x09, 0x06, 0x0f, 0x03, 0x00, 0x0c
        dw 0x02, 0x08, 0x07, 0x0b, 0x08, 0x04, 0x0e, 0x01
        dw 0x08, 0x04, 0x03, 0x0f, 0x05, 0x02, 0x00, 0x0c
        dw 0x0b, 0x07, 0x06, 0x09, 0x0e, 0x01, 0x09, 0x06
        dw 0x0f, 0x08, 0x0a, 0x03, 0x0c, 0x05, 0x07, 0x0a
        dw 0x01, 0x0e, 0x0d, 0x00, 0x02, 0x0b, 0x04, 0x0d

;;; Used in DOCSIS DES partial block scheduling 16 x 32bit of value 1
align 64
vec_ones_32b:
        dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

align 64
and_eu:
        dd 0x3f003f00, 0x3f003f00, 0x3f003f00, 0x3f003f00
        dd 0x3f003f00, 0x3f003f00, 0x3f003f00, 0x3f003f00
        dd 0x3f003f00, 0x3f003f00, 0x3f003f00, 0x3f003f00
        dd 0x3f003f00, 0x3f003f00, 0x3f003f00, 0x3f003f00

align 64
and_ed:
        dd 0x003f003f, 0x003f003f, 0x003f003f, 0x003f003f
        dd 0x003f003f, 0x003f003f, 0x003f003f, 0x003f003f
        dd 0x003f003f, 0x003f003f, 0x003f003f, 0x003f003f
        dd 0x003f003f, 0x003f003f, 0x003f003f, 0x003f003f

align 64
idx_e:
        dq 0x0d0c090805040100, 0x0f0e0b0a07060302
        dq 0x1d1c191815141110, 0x1f1e1b1a17161312
        dq 0x2d2c292825242120, 0x2f2e2b2a27262322
        dq 0x3d3c393835343130, 0x3f3e3b3a37363332

align 64
reg_values16bit_7:
        dq 0x001f001f001f001f, 0x001f001f001f001f
        dq 0x001f001f001f001f, 0x001f001f001f001f
        dq 0x001f001f001f001f, 0x001f001f001f001f
        dq 0x001f001f001f001f, 0x001f001f001f001f

align 64
shuffle_reg:
        dq 0x0705060403010200, 0x0f0d0e0c0b090a08
        dq 0x1715161413111210, 0x1f1d1e1c1b191a18
        dq 0x2725262423212220, 0x2f2d2e2c2b292a28
        dq 0x3735363433313230, 0x3f3d3e3c3b393a38

;;; ========================================================
;;; CODE
mksection .text

;;; arg 1 : pointer to DES OOO structure
;;; arg 2 : size in bytes
align 64
MKGLOBAL(des_x16_cbc_enc_avx512,function,internal)
des_x16_cbc_enc_avx512:
        GENERIC_DES_ENC DES
        ret

;;; arg 1 : pointer to DES OOO structure
;;; arg 2 : size in bytes
align 64
MKGLOBAL(des_x16_cbc_dec_avx512,function,internal)
des_x16_cbc_dec_avx512:
        GENERIC_DES_DEC DES
	ret

;;; arg 1 : pointer to DES OOO structure
;;; arg 2 : size in bytes
align 64
MKGLOBAL(des3_x16_cbc_enc_avx512,function,internal)
des3_x16_cbc_enc_avx512:
        GENERIC_DES_ENC 3DES
        ret

;;; arg 1 : pointer to DES OOO structure
;;; arg 2 : size in bytes
align 64
MKGLOBAL(des3_x16_cbc_dec_avx512,function,internal)
des3_x16_cbc_dec_avx512:
        GENERIC_DES_DEC 3DES
	ret

;;; arg 1 : pointer to DES OOO structure
;;; arg 2 : size in bytes
align 64
MKGLOBAL(docsis_des_x16_enc_avx512,function,internal)
docsis_des_x16_enc_avx512:
        GENERIC_DES_ENC DOCSIS
	ret

;;; arg 1 : pointer to DES OOO structure
;;; arg 2 : size in bytes
align 64
MKGLOBAL(docsis_des_x16_dec_avx512,function,internal)
docsis_des_x16_dec_avx512:
        GENERIC_DES_DEC DOCSIS
	ret

mksection stack-noexec
