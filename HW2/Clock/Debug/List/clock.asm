
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _counter=R5
	.DEF _seconds=R4
	.DEF _minutes=R7
	.DEF _hours=R6
	.DEF _stop_watch_counter=R9
	.DEF _stop_watch_seconds=R8
	.DEF _stop_watch_minutes=R11
	.DEF _stop_watch_hours=R10
	.DEF _alarm_minutes=R13
	.DEF _alarm_hours=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Clock -Embedded Course
;Version :
;Date    : 3/28/2020
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <io.h>
;
;
;// Declare your global variables here
;unsigned char counter = 0;
;unsigned char seconds = 0;
;unsigned char minutes = 0;
;unsigned char hours = 0;
;
;unsigned char stop_watch_counter = 0;
;unsigned char stop_watch_seconds = 0;
;unsigned char stop_watch_minutes = 0;
;unsigned char stop_watch_hours = 0;
;
;unsigned char alarm_minutes = 0;
;unsigned char alarm_hours = 0;
;
;unsigned char time_string[17];
;unsigned char state = 0;
;
;unsigned char ALARM = 0;
;unsigned char string[17];
;void lcd_go_to_xy(unsigned char x,unsigned char y);
;void lcd_send_char(unsigned char sentCharacter);
;
;#define lcd_ddr DDRA
;#define lcd_port PORTA
;#define lcd_control_ddr DDRD
;#define lcd_control_port PORTD
;#define RS 6
;#define RW 1
;#define EN 7
;#define clocks_per_a_sec 30
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 003D {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003E // Reinitialize Timer 0 value
; 0000 003F TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 0040 // Place your code here
; 0000 0041     counter += 1;
	INC  R5
; 0000 0042     if (counter == clocks_per_a_sec){
	LDI  R30,LOW(30)
	CP   R30,R5
	BRNE _0x3
; 0000 0043         counter = 0;
	CLR  R5
; 0000 0044         seconds += 1;
	INC  R4
; 0000 0045         if (seconds == 60){
	LDI  R30,LOW(60)
	CP   R30,R4
	BRNE _0x4
; 0000 0046             minutes += 1;
	INC  R7
; 0000 0047             seconds = 0;
	CLR  R4
; 0000 0048             if (minutes == 60){
	CP   R30,R7
	BRNE _0x5
; 0000 0049                 hours += 1;
	INC  R6
; 0000 004A                 minutes = 0;
	CLR  R7
; 0000 004B                 if (hours == 24){
	LDI  R30,LOW(24)
	CP   R30,R6
	BRNE _0x6
; 0000 004C                     hours = 0;
	CLR  R6
; 0000 004D                 }
; 0000 004E             }
_0x6:
; 0000 004F         }
_0x5:
; 0000 0050 
; 0000 0051         if ((alarm_hours == hours) && (alarm_minutes == minutes) && (ALARM == 1) & (seconds < 10)){
_0x4:
	CP   R6,R12
	BRNE _0x8
	CP   R7,R13
	BRNE _0x8
	LDS  R26,_ALARM
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	MOV  R26,R4
	LDI  R30,LOW(10)
	CALL __LTB12U
	AND  R30,R0
	BRNE _0x9
_0x8:
	RJMP _0x7
_0x9:
; 0000 0052             //PORTD = PORTD | (1<<4) ;
; 0000 0053             lcd_go_to_xy(0, 15);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(15)
	RCALL _lcd_go_to_xy
; 0000 0054             lcd_send_char('*');
	LDI  R26,LOW(42)
	RJMP _0x4C
; 0000 0055         }
; 0000 0056         else{
_0x7:
; 0000 0057             //PORTD = PORTD & ~(1<<4);
; 0000 0058             lcd_go_to_xy(0, 15);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(15)
	RCALL _lcd_go_to_xy
; 0000 0059             lcd_send_char('\0');
	LDI  R26,LOW(0)
_0x4C:
	RCALL _lcd_send_char
; 0000 005A         }
; 0000 005B     }
; 0000 005C }
_0x3:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 005F {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0060 // Reinitialize Timer 2 value
; 0000 0061 TCNT2=0x83;
	LDI  R30,LOW(131)
	OUT  0x24,R30
; 0000 0062 // Place your code here
; 0000 0063     stop_watch_counter += 1;
	INC  R9
; 0000 0064     if (stop_watch_counter == clocks_per_a_sec){
	LDI  R30,LOW(30)
	CP   R30,R9
	BRNE _0xB
; 0000 0065         stop_watch_counter = 0;
	CLR  R9
; 0000 0066         stop_watch_seconds += 1;
	INC  R8
; 0000 0067         if (stop_watch_seconds == 60){
	LDI  R30,LOW(60)
	CP   R30,R8
	BRNE _0xC
; 0000 0068             stop_watch_minutes += 1;
	INC  R11
; 0000 0069             stop_watch_seconds = 0;
	CLR  R8
; 0000 006A             if (stop_watch_minutes == 60){
	CP   R30,R11
	BRNE _0xD
; 0000 006B                 stop_watch_hours += 1;
	INC  R10
; 0000 006C                 stop_watch_minutes = 0;
	CLR  R11
; 0000 006D                 if (stop_watch_hours == 24){
	LDI  R30,LOW(24)
	CP   R30,R10
	BRNE _0xE
; 0000 006E                     stop_watch_hours = 0;
	CLR  R10
; 0000 006F                 }
; 0000 0070             }
_0xE:
; 0000 0071         }
_0xD:
; 0000 0072     }
_0xC:
; 0000 0073 }
_0xB:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;void lcd_send_cmd(unsigned char cmd);
;void lcd_send_char(unsigned char sentCharacter);
;void lcd_clear();
;void lcd_send_string(char sentString[]);
;
;void lcd_init(){
; 0000 007A void lcd_init(){
_lcd_init:
; .FSTART _lcd_init
; 0000 007B     lcd_ddr = 0xff;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 007C     lcd_control_ddr |= (1<<RS) | (1<<RW) | (1<<EN);
	IN   R30,0x11
	ORI  R30,LOW(0xC2)
	OUT  0x11,R30
; 0000 007D 	lcd_send_cmd(0x0E);
	LDI  R26,LOW(14)
	RCALL _lcd_send_cmd
; 0000 007E 	lcd_send_cmd(0x38);
	LDI  R26,LOW(56)
	RCALL _lcd_send_cmd
; 0000 007F 	lcd_clear();
	RCALL _lcd_clear
; 0000 0080     lcd_send_string(time_string);
	RCALL SUBOPT_0x0
; 0000 0081 	delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 0082 	lcd_clear();
	RCALL _lcd_clear
; 0000 0083 }
	RET
; .FEND
;
;void lcd_send_cmd(unsigned char cmd){
; 0000 0085 void lcd_send_cmd(unsigned char cmd){
_lcd_send_cmd:
; .FSTART _lcd_send_cmd
; 0000 0086 	lcd_port = cmd;
	ST   -Y,R26
;	cmd -> Y+0
	LD   R30,Y
	OUT  0x1B,R30
; 0000 0087 	lcd_control_port &= ~(1<<RS);
	CBI  0x12,6
; 0000 0088 	lcd_control_port &= ~(1<<RW);
	RJMP _0x2000001
; 0000 0089 	lcd_control_port |=  (1<<EN);
; 0000 008A 	delay_us(700);
; 0000 008B 	lcd_control_port &= ~(1<<EN);
; 0000 008C }
; .FEND
;
;void lcd_send_char(unsigned char sentCharacter){
; 0000 008E void lcd_send_char(unsigned char sentCharacter){
_lcd_send_char:
; .FSTART _lcd_send_char
; 0000 008F 	lcd_port = sentCharacter;
	ST   -Y,R26
;	sentCharacter -> Y+0
	LD   R30,Y
	OUT  0x1B,R30
; 0000 0090 	lcd_control_port |=  (1<<RS);
	SBI  0x12,6
; 0000 0091 	lcd_control_port &= ~(1<<RW);
_0x2000001:
	CBI  0x12,1
; 0000 0092 	lcd_control_port |=  (1<<EN);
	SBI  0x12,7
; 0000 0093 	delay_us(700);
	__DELAY_USW 1400
; 0000 0094 	lcd_control_port &= ~(1<<EN);
	CBI  0x12,7
; 0000 0095 }
	ADIW R28,1
	RET
; .FEND
;
;void lcd_send_string(char sentString[]){
; 0000 0097 void lcd_send_string(char sentString[]){
_lcd_send_string:
; .FSTART _lcd_send_string
; 0000 0098 	unsigned char  i = 0;
; 0000 0099 	while (sentString[i]!='\0')
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	sentString -> Y+1
;	i -> R17
	LDI  R17,0
_0xF:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0x11
; 0000 009A 	{
; 0000 009B 		lcd_send_char(sentString[i]);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _lcd_send_char
; 0000 009C 		i++;
	SUBI R17,-1
; 0000 009D 	}
	RJMP _0xF
_0x11:
; 0000 009E }
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
;
;void lcd_clear(){
; 0000 00A0 void lcd_clear(){
_lcd_clear:
; .FSTART _lcd_clear
; 0000 00A1 	lcd_send_cmd(0x01);
	LDI  R26,LOW(1)
	RCALL _lcd_send_cmd
; 0000 00A2 }
	RET
; .FEND
;
;void lcd_go_to_xy(unsigned char x,unsigned char y){
; 0000 00A4 void lcd_go_to_xy(unsigned char x,unsigned char y){
_lcd_go_to_xy:
; .FSTART _lcd_go_to_xy
; 0000 00A5 	if(x == 0){
	ST   -Y,R26
;	x -> Y+1
;	y -> Y+0
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x12
; 0000 00A6 		lcd_send_cmd(0x80+y);
	LD   R26,Y
	SUBI R26,-LOW(128)
	RJMP _0x4D
; 0000 00A7 	}
; 0000 00A8     else if (x == 1){
_0x12:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x14
; 0000 00A9 		lcd_send_cmd(0xC0+y);
	LD   R26,Y
	SUBI R26,-LOW(192)
_0x4D:
	RCALL _lcd_send_cmd
; 0000 00AA 	}
; 0000 00AB }
_0x14:
	ADIW R28,2
	RET
; .FEND
;
;void updateTimeString(unsigned char hour,unsigned char minute,unsigned char second,char timeString[17]){
; 0000 00AD void updateTimeString(unsigned char hour,unsigned char minute,unsigned char second,char timeString[17]){
_updateTimeString:
; .FSTART _updateTimeString
; 0000 00AE     timeString[0] = '0' + hour/10;
	ST   -Y,R27
	ST   -Y,R26
;	hour -> Y+4
;	minute -> Y+3
;	second -> Y+2
;	timeString -> Y+0
	LDD  R26,Y+4
	RCALL SUBOPT_0x1
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
; 0000 00AF     timeString[1] = '0' + hour%10;
	LDD  R26,Y+4
	RCALL SUBOPT_0x2
	__PUTB1SNS 0,1
; 0000 00B0     timeString[2] = ':';
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,2
	LDI  R30,LOW(58)
	ST   X,R30
; 0000 00B1     timeString[3] = '0' + minute/10;
	LDD  R26,Y+3
	RCALL SUBOPT_0x1
	__PUTB1SNS 0,3
; 0000 00B2     timeString[4] = '0' + minute%10;
	LDD  R26,Y+3
	RCALL SUBOPT_0x2
	__PUTB1SNS 0,4
; 0000 00B3     timeString[5] = ':';
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,5
	LDI  R30,LOW(58)
	ST   X,R30
; 0000 00B4     timeString[6] = '0' + second/10;
	LDD  R26,Y+2
	RCALL SUBOPT_0x1
	__PUTB1SNS 0,6
; 0000 00B5     timeString[7] = '0' + second%10;
	LDD  R26,Y+2
	RCALL SUBOPT_0x2
	__PUTB1SNS 0,7
; 0000 00B6     timeString[8] = ' ';
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,8
	RCALL SUBOPT_0x3
; 0000 00B7     timeString[9] = ' ';
	ADIW R26,9
	RCALL SUBOPT_0x3
; 0000 00B8     timeString[10] = ' ';
	ADIW R26,10
	RCALL SUBOPT_0x3
; 0000 00B9     timeString[11] = ' ';
	ADIW R26,11
	LDI  R30,LOW(32)
	ST   X,R30
; 0000 00BA     if (ALARM == 1){
	LDS  R26,_ALARM
	CPI  R26,LOW(0x1)
	BRNE _0x15
; 0000 00BB         timeString[12] = 'A';
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,12
	LDI  R30,LOW(65)
	RJMP _0x4E
; 0000 00BC     }
; 0000 00BD     else{
_0x15:
; 0000 00BE         timeString[12] = ' ';
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,12
	LDI  R30,LOW(32)
_0x4E:
	ST   X,R30
; 0000 00BF     }
; 0000 00C0 
; 0000 00C1     timeString[13] = ' ';
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,13
	RCALL SUBOPT_0x3
; 0000 00C2     timeString[14] = ' ';
	ADIW R26,14
	RCALL SUBOPT_0x3
; 0000 00C3     timeString[15] = ' ';
	ADIW R26,15
	RCALL SUBOPT_0x3
; 0000 00C4     timeString[16] = '\0';
	ADIW R26,16
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00C5 }
	ADIW R28,5
	RET
; .FEND
;
;void check_push_buttons(){
; 0000 00C7 void check_push_buttons(){
_check_push_buttons:
; .FSTART _check_push_buttons
; 0000 00C8     switch (state) {
	LDS  R30,_state
	LDI  R31,0
; 0000 00C9         case 0:{
	SBIW R30,0
	BRNE _0x1A
; 0000 00CA             if (PINC & (1<<5))
	SBIS 0x13,5
	RJMP _0x1B
; 0000 00CB                 state = 1; // setting new time (seconds)
	LDI  R30,LOW(1)
	RJMP _0x4F
; 0000 00CC             else if (PIND & (1<<5))
_0x1B:
	SBIS 0x10,5
	RJMP _0x1D
; 0000 00CD                 state = 2; // alarm and stop watch (stop watch)
	LDI  R30,LOW(2)
_0x4F:
	STS  _state,R30
; 0000 00CE             //delay_ms(500);
; 0000 00CF             break;
_0x1D:
	RJMP _0x19
; 0000 00D0         }
; 0000 00D1         case 1:{
_0x1A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1E
; 0000 00D2             if (PIND & (1<<5)){
	SBIS 0x10,5
	RJMP _0x1F
; 0000 00D3                 seconds = (seconds + 1) % 60;
	MOV  R30,R4
	RCALL SUBOPT_0x4
	MOV  R4,R30
; 0000 00D4                 state = 1;
	LDI  R30,LOW(1)
	STS  _state,R30
; 0000 00D5             }
; 0000 00D6             if (PINC & (1<<5)){
_0x1F:
	SBIS 0x13,5
	RJMP _0x20
; 0000 00D7                 state = 3; // setting minutes
	LDI  R30,LOW(3)
	STS  _state,R30
; 0000 00D8             }
; 0000 00D9             //delay_ms(300);
; 0000 00DA             break;
_0x20:
	RJMP _0x19
; 0000 00DB         }
; 0000 00DC         case 2:{
_0x1E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x21
; 0000 00DD             if (PIND & (1<<5)){
	SBIS 0x10,5
	RJMP _0x22
; 0000 00DE                 // start stop watch
; 0000 00DF                 stop_watch_counter = 0;
	CLR  R9
; 0000 00E0                 stop_watch_seconds = 0;
	CLR  R8
; 0000 00E1                 stop_watch_minutes = 0;
	CLR  R11
; 0000 00E2                 stop_watch_hours = 0;
	CLR  R10
; 0000 00E3 
; 0000 00E4                 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (1<<CS21) | (0<<CS20);
	LDI  R30,LOW(6)
	OUT  0x25,R30
; 0000 00E5                 TCNT2=0x83;
	LDI  R30,LOW(131)
	OUT  0x24,R30
; 0000 00E6 
; 0000 00E7                 state = 4; //stop watch running
	LDI  R30,LOW(4)
	STS  _state,R30
; 0000 00E8             }
; 0000 00E9             if (PINC & (1<<5)){
_0x22:
	SBIS 0x13,5
	RJMP _0x23
; 0000 00EA                 state = 5; // alarm setting
	LDI  R30,LOW(5)
	STS  _state,R30
; 0000 00EB             }
; 0000 00EC             //delay_ms(300);
; 0000 00ED             break;
_0x23:
	RJMP _0x19
; 0000 00EE         }
; 0000 00EF         case 3:{
_0x21:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x24
; 0000 00F0             if (PIND & (1<<5)){
	SBIS 0x10,5
	RJMP _0x25
; 0000 00F1                 minutes = (minutes + 1) % 60;
	MOV  R30,R7
	RCALL SUBOPT_0x4
	MOV  R7,R30
; 0000 00F2                 state = 3;
	LDI  R30,LOW(3)
	STS  _state,R30
; 0000 00F3             }
; 0000 00F4             if (PINC & (1<<5)){
_0x25:
	SBIS 0x13,5
	RJMP _0x26
; 0000 00F5                 state = 7; // setting hours
	LDI  R30,LOW(7)
	STS  _state,R30
; 0000 00F6             }
; 0000 00F7             //delay_ms(300);
; 0000 00F8             break;
_0x26:
	RJMP _0x19
; 0000 00F9         }
; 0000 00FA         case 4:{
_0x24:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x27
; 0000 00FB             if (PIND & (1<<5)){
	SBIS 0x10,5
	RJMP _0x28
; 0000 00FC                 if (TCNT2 == 0x00){
	IN   R30,0x24
	CPI  R30,0
	BRNE _0x29
; 0000 00FD                     TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (1<<CS21) | (0<<CS20);
	LDI  R30,LOW(6)
	OUT  0x25,R30
; 0000 00FE                     TCNT2=0x83;
	LDI  R30,LOW(131)
	RJMP _0x50
; 0000 00FF                 }
; 0000 0100                 else{
_0x29:
; 0000 0101                     TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0000 0102                     TCNT2=0x00;
_0x50:
	OUT  0x24,R30
; 0000 0103                 }
; 0000 0104                 state = 4;
	LDI  R30,LOW(4)
	STS  _state,R30
; 0000 0105             }
; 0000 0106             if (PINC & (1<<5)){
_0x28:
	SBIS 0x13,5
	RJMP _0x2B
; 0000 0107                 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0000 0108                 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0109                 state = 5; // alarm setting
	LDI  R30,LOW(5)
	STS  _state,R30
; 0000 010A             }
; 0000 010B             //delay_ms(300);
; 0000 010C             break;
_0x2B:
	RJMP _0x19
; 0000 010D         }
; 0000 010E         case 5:{
_0x27:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2C
; 0000 010F             if (PIND & (1<<5)){
	SBIS 0x10,5
	RJMP _0x2D
; 0000 0110                 state = 6; // setting alarm's minutes
	LDI  R30,LOW(6)
	STS  _state,R30
; 0000 0111             }
; 0000 0112             if (PINC & (1<<5)){
_0x2D:
	SBIS 0x13,5
	RJMP _0x2E
; 0000 0113                 state = 0;
	LDI  R30,LOW(0)
	STS  _state,R30
; 0000 0114             }
; 0000 0115             //delay_ms(300);
; 0000 0116             break;
_0x2E:
	RJMP _0x19
; 0000 0117         }
; 0000 0118         case 6:{
_0x2C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2F
; 0000 0119             if (PIND & (1<<5)){
	SBIS 0x10,5
	RJMP _0x30
; 0000 011A                 alarm_minutes = (alarm_minutes + 1) % 60;
	MOV  R30,R13
	RCALL SUBOPT_0x4
	MOV  R13,R30
; 0000 011B                 state = 6;
	LDI  R30,LOW(6)
	STS  _state,R30
; 0000 011C             }
; 0000 011D             if (PINC & (1<<5)){
_0x30:
	SBIS 0x13,5
	RJMP _0x31
; 0000 011E                 state = 8; // setting alarm's hour
	LDI  R30,LOW(8)
	STS  _state,R30
; 0000 011F             }
; 0000 0120             //delay_ms(300);
; 0000 0121             break;
_0x31:
	RJMP _0x19
; 0000 0122         }
; 0000 0123         case 7:{
_0x2F:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x32
; 0000 0124             if (PIND & (1<<5)){
	SBIS 0x10,5
	RJMP _0x33
; 0000 0125                 hours = (hours + 1) % 24;
	MOV  R30,R6
	RCALL SUBOPT_0x5
	MOV  R6,R30
; 0000 0126                 state = 7;
	LDI  R30,LOW(7)
	STS  _state,R30
; 0000 0127             }
; 0000 0128             if (PINC & (1<<5)){
_0x33:
	SBIS 0x13,5
	RJMP _0x34
; 0000 0129                 state = 0;
	LDI  R30,LOW(0)
	STS  _state,R30
; 0000 012A             }
; 0000 012B             //delay_ms(300);
; 0000 012C             break;
_0x34:
	RJMP _0x19
; 0000 012D         }
; 0000 012E         case 8:{
_0x32:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x35
; 0000 012F             if (PIND & (1<<5)){
	SBIS 0x10,5
	RJMP _0x36
; 0000 0130                 alarm_hours = (alarm_hours + 1) % 24;
	MOV  R30,R12
	RCALL SUBOPT_0x5
	MOV  R12,R30
; 0000 0131                 state = 8;
	LDI  R30,LOW(8)
	STS  _state,R30
; 0000 0132             }
; 0000 0133             if (PINC & (1<<5)){
_0x36:
	SBIS 0x13,5
	RJMP _0x37
; 0000 0134                 state = 9;
	LDI  R30,LOW(9)
	STS  _state,R30
; 0000 0135             }
; 0000 0136             //delay_ms(300);
; 0000 0137             break;
_0x37:
	RJMP _0x19
; 0000 0138         }
; 0000 0139         case 9:{
_0x35:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x19
; 0000 013A             if (PIND & (1<<5)){
	SBIS 0x10,5
	RJMP _0x39
; 0000 013B                 //lcd_send_string("Alarm Set");
; 0000 013C                 ALARM = 1;
	LDI  R30,LOW(1)
	STS  _ALARM,R30
; 0000 013D                 state = 0;
	LDI  R30,LOW(0)
	STS  _state,R30
; 0000 013E             }
; 0000 013F             if (PINC & (1<<5)){
_0x39:
	SBIS 0x13,5
	RJMP _0x3A
; 0000 0140                 ALARM = 0;
	LDI  R30,LOW(0)
	STS  _ALARM,R30
; 0000 0141                 state = 0;
	STS  _state,R30
; 0000 0142             }
; 0000 0143             //delay_ms(300);
; 0000 0144             break;
_0x3A:
; 0000 0145         }
; 0000 0146     };
_0x19:
; 0000 0147 
; 0000 0148 }
	RET
; .FEND
;
;void update_lcd(){
; 0000 014A void update_lcd(){
_update_lcd:
; .FSTART _update_lcd
; 0000 014B     lcd_go_to_xy(0, 0);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x6
; 0000 014C     switch (state) {
	LDS  R30,_state
	LDI  R31,0
; 0000 014D     case 0:{
	SBIW R30,0
	BRNE _0x3E
; 0000 014E         updateTimeString(hours, minutes, seconds, time_string);
	RCALL SUBOPT_0x7
; 0000 014F         lcd_send_string(time_string);
; 0000 0150         string[0] = 'C';
	LDI  R30,LOW(67)
	RCALL SUBOPT_0x8
; 0000 0151         string[1] = ':';
; 0000 0152         string[2] = 'T';
	LDI  R30,LOW(84)
	__PUTB1MN _string,2
; 0000 0153         string[3] = 'i';
	LDI  R30,LOW(105)
	__PUTB1MN _string,3
; 0000 0154         string[4] = 'm';
	LDI  R30,LOW(109)
	__PUTB1MN _string,4
; 0000 0155         string[5] = 'e';
	LDI  R30,LOW(101)
	__PUTB1MN _string,5
; 0000 0156         string[6] = 'S';
	LDI  R30,LOW(83)
	__PUTB1MN _string,6
; 0000 0157         string[7] = 'e';
	LDI  R30,LOW(101)
	__PUTB1MN _string,7
; 0000 0158         string[8] = 't';
	LDI  R30,LOW(116)
	__PUTB1MN _string,8
; 0000 0159         string[9] = '-';
	LDI  R30,LOW(45)
	__PUTB1MN _string,9
; 0000 015A         string[10] = 'D';
	LDI  R30,LOW(68)
	RCALL SUBOPT_0x9
; 0000 015B         string[11] = ':';
; 0000 015C         string[12] = 'A';
; 0000 015D         string[13] = '/';
	LDI  R30,LOW(47)
	__PUTB1MN _string,13
; 0000 015E         string[14] = 'S';
	LDI  R30,LOW(83)
	__PUTB1MN _string,14
; 0000 015F         string[15] = 'W';
	LDI  R30,LOW(87)
	RJMP _0x51
; 0000 0160         string[16] = '\0';
; 0000 0161         lcd_go_to_xy(1, 0);
; 0000 0162         lcd_send_string(string);
; 0000 0163         lcd_go_to_xy(0, 0);
; 0000 0164         break;
; 0000 0165     }
; 0000 0166     case 1:{
_0x3E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3F
; 0000 0167         updateTimeString(hours, minutes, seconds, time_string);
	RCALL SUBOPT_0x7
; 0000 0168         lcd_send_string(time_string);
; 0000 0169         string[0] = 'D';
	LDI  R30,LOW(68)
	RCALL SUBOPT_0x8
; 0000 016A         string[1] = ':';
; 0000 016B         string[2] = 'C';
	RCALL SUBOPT_0xA
; 0000 016C         string[3] = 'h';
; 0000 016D         string[4] = 'g';
; 0000 016E         string[5] = 'S';
	LDI  R30,LOW(83)
	__PUTB1MN _string,5
; 0000 016F         string[6] = 'e';
	LDI  R30,LOW(101)
	__PUTB1MN _string,6
; 0000 0170         string[7] = 'c';
	LDI  R30,LOW(99)
	RCALL SUBOPT_0xB
; 0000 0171         string[8] = '-';
; 0000 0172         string[9] = 'C';
; 0000 0173         string[10] = ':';
; 0000 0174         string[11] = 'G';
; 0000 0175         string[12] = 'o';
; 0000 0176         string[13] = 'M';
	LDI  R30,LOW(77)
	__PUTB1MN _string,13
; 0000 0177         string[14] = 'i';
	LDI  R30,LOW(105)
	__PUTB1MN _string,14
; 0000 0178         string[15] = 'n';
	LDI  R30,LOW(110)
	RJMP _0x51
; 0000 0179         string[16] = '\0';
; 0000 017A         lcd_go_to_xy(1, 0);
; 0000 017B         lcd_send_string(string);
; 0000 017C         lcd_go_to_xy(0, 0);
; 0000 017D         break;
; 0000 017E     }
; 0000 017F     case 2:{
_0x3F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x40
; 0000 0180         updateTimeString(stop_watch_hours, stop_watch_minutes, stop_watch_seconds, time_string);
	RCALL SUBOPT_0xC
; 0000 0181         lcd_send_string(time_string);
; 0000 0182         string[0] = 'D';
	LDI  R30,LOW(68)
	RCALL SUBOPT_0x8
; 0000 0183         string[1] = ':';
; 0000 0184         string[2] = 'S';
	RCALL SUBOPT_0xD
; 0000 0185         string[3] = 't';
; 0000 0186         string[4] = 'a';
	RCALL SUBOPT_0xE
; 0000 0187         string[5] = 'r';
; 0000 0188         string[6] = 't';
	LDI  R30,LOW(116)
	RCALL SUBOPT_0xF
; 0000 0189         string[7] = '-';
; 0000 018A         string[8] = 'C';
; 0000 018B         string[9] = ':';
	RJMP _0x52
; 0000 018C         string[10] = 'A';
; 0000 018D         string[11] = 'l';
; 0000 018E         string[12] = 'a';
; 0000 018F         string[13] = 'r';
; 0000 0190         string[14] = 'm';
; 0000 0191         string[15] = ' ';
; 0000 0192         string[16] = '\0';
; 0000 0193         lcd_go_to_xy(1, 0);
; 0000 0194         lcd_send_string(string);
; 0000 0195         lcd_go_to_xy(0, 0);
; 0000 0196         break;
; 0000 0197     }
; 0000 0198     case 3:{
_0x40:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x41
; 0000 0199         updateTimeString(hours, minutes, seconds, time_string);
	RCALL SUBOPT_0x7
; 0000 019A         lcd_send_string(time_string);
; 0000 019B         string[0] = 'D';
	LDI  R30,LOW(68)
	RCALL SUBOPT_0x8
; 0000 019C         string[1] = ':';
; 0000 019D         string[2] = 'C';
	RCALL SUBOPT_0xA
; 0000 019E         string[3] = 'h';
; 0000 019F         string[4] = 'g';
; 0000 01A0         string[5] = 'M';
	RCALL SUBOPT_0x10
; 0000 01A1         string[6] = 'i';
; 0000 01A2         string[7] = 'n';
; 0000 01A3         string[8] = '-';
; 0000 01A4         string[9] = 'C';
; 0000 01A5         string[10] = ':';
; 0000 01A6         string[11] = 'G';
; 0000 01A7         string[12] = 'o';
; 0000 01A8         string[13] = 'H';
	LDI  R30,LOW(72)
	__PUTB1MN _string,13
; 0000 01A9         string[14] = 'r';
	LDI  R30,LOW(114)
	RJMP _0x53
; 0000 01AA         string[15] = ' ';
; 0000 01AB         string[16] = '\0';
; 0000 01AC         lcd_go_to_xy(1, 0);
; 0000 01AD         lcd_send_string(string);
; 0000 01AE         lcd_go_to_xy(0, 0);
; 0000 01AF         break;
; 0000 01B0     }
; 0000 01B1     case 4:{
_0x41:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x42
; 0000 01B2         updateTimeString(stop_watch_hours, stop_watch_minutes, stop_watch_seconds, time_string);
	RCALL SUBOPT_0xC
; 0000 01B3         lcd_send_string(time_string);
; 0000 01B4         string[0] = 'D';
	LDI  R30,LOW(68)
	RCALL SUBOPT_0x8
; 0000 01B5         string[1] = ':';
; 0000 01B6         string[2] = 'S';
	RCALL SUBOPT_0xD
; 0000 01B7         string[3] = 't';
; 0000 01B8         string[4] = 'p';
	LDI  R30,LOW(112)
	__PUTB1MN _string,4
; 0000 01B9         string[5] = '/';
	LDI  R30,LOW(47)
	__PUTB1MN _string,5
; 0000 01BA         string[6] = 'R';
	LDI  R30,LOW(82)
	__PUTB1MN _string,6
; 0000 01BB         string[7] = 'e';
	LDI  R30,LOW(101)
	__PUTB1MN _string,7
; 0000 01BC         string[8] = 's';
	LDI  R30,LOW(115)
	__PUTB1MN _string,8
; 0000 01BD         string[9] = '-';
	LDI  R30,LOW(45)
	__PUTB1MN _string,9
; 0000 01BE         string[10] = 'C';
	LDI  R30,LOW(67)
	RCALL SUBOPT_0x9
; 0000 01BF         string[11] = ':';
; 0000 01C0         string[12] = 'A';
; 0000 01C1         string[13] = 'l';
	LDI  R30,LOW(108)
	__PUTB1MN _string,13
; 0000 01C2         string[14] = 'r';
	LDI  R30,LOW(114)
	__PUTB1MN _string,14
; 0000 01C3         string[15] = 'm';
	LDI  R30,LOW(109)
	RJMP _0x51
; 0000 01C4         string[16] = '\0';
; 0000 01C5         lcd_go_to_xy(1, 0);
; 0000 01C6         lcd_send_string(string);
; 0000 01C7         lcd_go_to_xy(0, 0);
; 0000 01C8         break;
; 0000 01C9     }
; 0000 01CA     case 5:{
_0x42:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x43
; 0000 01CB         time_string[0] = 'C';
	RCALL SUBOPT_0x11
; 0000 01CC         time_string[1] = ':';
; 0000 01CD         time_string[2] = 'T';
	LDI  R30,LOW(84)
	__PUTB1MN _time_string,2
; 0000 01CE         time_string[3] = 'o';
	LDI  R30,LOW(111)
	__PUTB1MN _time_string,3
; 0000 01CF         time_string[4] = ' ';
	LDI  R30,LOW(32)
	__PUTB1MN _time_string,4
; 0000 01D0         time_string[5] = 'M';
	LDI  R30,LOW(77)
	__PUTB1MN _time_string,5
; 0000 01D1         time_string[6] = 'a';
	LDI  R30,LOW(97)
	__PUTB1MN _time_string,6
; 0000 01D2         time_string[7] = 'i';
	LDI  R30,LOW(105)
	__PUTB1MN _time_string,7
; 0000 01D3         time_string[8] = 'n';
	LDI  R30,LOW(110)
	RCALL SUBOPT_0x12
; 0000 01D4         time_string[9] = ' ';
; 0000 01D5         time_string[10] = ' ';
; 0000 01D6         time_string[11] = ' ';
; 0000 01D7         time_string[12] = ' ';
; 0000 01D8         time_string[13] = ' ';
; 0000 01D9         time_string[14] = ' ';
; 0000 01DA         time_string[15] = ' ';
; 0000 01DB         time_string[16] = '\0';
; 0000 01DC         lcd_send_string(time_string);
; 0000 01DD         string[0] = 'D';
	LDI  R30,LOW(68)
	RCALL SUBOPT_0x8
; 0000 01DE         string[1] = ':';
; 0000 01DF         string[2] = 'A';
	LDI  R30,LOW(65)
	__PUTB1MN _string,2
; 0000 01E0         string[3] = 'l';
	LDI  R30,LOW(108)
	__PUTB1MN _string,3
; 0000 01E1         string[4] = 'a';
	RCALL SUBOPT_0xE
; 0000 01E2         string[5] = 'r';
; 0000 01E3         string[6] = 'm';
	LDI  R30,LOW(109)
	__PUTB1MN _string,6
; 0000 01E4         string[7] = ' ';
	LDI  R30,LOW(32)
	__PUTB1MN _string,7
; 0000 01E5         string[8] = ' ';
	__PUTB1MN _string,8
; 0000 01E6         string[9] = ' ';
	__PUTB1MN _string,9
; 0000 01E7         string[10] = ' ';
	__PUTB1MN _string,10
; 0000 01E8         string[11] = ' ';
	__PUTB1MN _string,11
; 0000 01E9         string[12] = ' ';
	__PUTB1MN _string,12
; 0000 01EA         string[13] = ' ';
	__PUTB1MN _string,13
; 0000 01EB         string[14] = ' ';
	RJMP _0x53
; 0000 01EC         string[15] = ' ';
; 0000 01ED         string[16] = '\0';
; 0000 01EE         lcd_go_to_xy(1, 0);
; 0000 01EF         lcd_send_string(string);
; 0000 01F0         lcd_go_to_xy(0, 0);
; 0000 01F1         break;
; 0000 01F2     }
; 0000 01F3     case 6:{
_0x43:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x44
; 0000 01F4         updateTimeString(alarm_hours, alarm_minutes, 0, time_string);
	RCALL SUBOPT_0x13
; 0000 01F5         lcd_send_string(time_string);
; 0000 01F6         string[0] = 'D';
	LDI  R30,LOW(68)
	RCALL SUBOPT_0x8
; 0000 01F7         string[1] = ':';
; 0000 01F8         string[2] = 'S';
	RCALL SUBOPT_0x14
; 0000 01F9         string[3] = 'e';
; 0000 01FA         string[4] = 't';
; 0000 01FB         string[5] = 'M';
	RCALL SUBOPT_0x10
; 0000 01FC         string[6] = 'i';
; 0000 01FD         string[7] = 'n';
; 0000 01FE         string[8] = '-';
; 0000 01FF         string[9] = 'C';
; 0000 0200         string[10] = ':';
; 0000 0201         string[11] = 'G';
; 0000 0202         string[12] = 'o';
; 0000 0203         string[13] = 'H';
	LDI  R30,LOW(72)
	__PUTB1MN _string,13
; 0000 0204         string[14] = 'r';
	LDI  R30,LOW(114)
	RJMP _0x53
; 0000 0205         string[15] = ' ';
; 0000 0206         string[16] = '\0';
; 0000 0207         lcd_go_to_xy(1, 0);
; 0000 0208         lcd_send_string(string);
; 0000 0209         lcd_go_to_xy(0, 0);
; 0000 020A         break;
; 0000 020B     }
; 0000 020C     case 7:{
_0x44:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x45
; 0000 020D         updateTimeString(hours, minutes, seconds, time_string);
	RCALL SUBOPT_0x7
; 0000 020E         lcd_send_string(time_string);
; 0000 020F         string[0] = 'D';
	LDI  R30,LOW(68)
	RCALL SUBOPT_0x8
; 0000 0210         string[1] = ':';
; 0000 0211         string[2] = 'C';
	RCALL SUBOPT_0xA
; 0000 0212         string[3] = 'h';
; 0000 0213         string[4] = 'g';
; 0000 0214         string[5] = 'H';
	RCALL SUBOPT_0x15
; 0000 0215         string[6] = 'r';
; 0000 0216         string[7] = '-';
; 0000 0217         string[8] = 'C';
; 0000 0218         string[9] = ':';
	RCALL SUBOPT_0x16
; 0000 0219         string[10] = 'F';
; 0000 021A         string[11] = 'i';
; 0000 021B         string[12] = 'n';
; 0000 021C         string[13] = 'i';
; 0000 021D         string[14] = 's';
; 0000 021E         string[15] = 'h';
	RJMP _0x51
; 0000 021F         string[16] = '\0';
; 0000 0220         lcd_go_to_xy(1, 0);
; 0000 0221         lcd_send_string(string);
; 0000 0222         lcd_go_to_xy(0, 0);
; 0000 0223         break;
; 0000 0224     }
; 0000 0225     case 8:{
_0x45:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x46
; 0000 0226         updateTimeString(alarm_hours, alarm_minutes, 0, time_string);
	RCALL SUBOPT_0x13
; 0000 0227         lcd_send_string(time_string);
; 0000 0228         string[0] = 'D';
	LDI  R30,LOW(68)
	RCALL SUBOPT_0x8
; 0000 0229         string[1] = ':';
; 0000 022A         string[2] = 'S';
	RCALL SUBOPT_0x14
; 0000 022B         string[3] = 'e';
; 0000 022C         string[4] = 't';
; 0000 022D         string[5] = 'H';
	RCALL SUBOPT_0x15
; 0000 022E         string[6] = 'r';
; 0000 022F         string[7] = '-';
; 0000 0230         string[8] = 'C';
; 0000 0231         string[9] = ':';
	RCALL SUBOPT_0x16
; 0000 0232         string[10] = 'F';
; 0000 0233         string[11] = 'i';
; 0000 0234         string[12] = 'n';
; 0000 0235         string[13] = 'i';
; 0000 0236         string[14] = 's';
; 0000 0237         string[15] = 'h';
	RJMP _0x51
; 0000 0238         string[16] = '\0';
; 0000 0239         lcd_go_to_xy(1, 0);
; 0000 023A         lcd_send_string(string);
; 0000 023B         lcd_go_to_xy(0, 0);
; 0000 023C         break;
; 0000 023D     }
; 0000 023E     case 9:{
_0x46:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x3D
; 0000 023F         time_string[0] = 'C';
	RCALL SUBOPT_0x11
; 0000 0240         time_string[1] = ':';
; 0000 0241         time_string[2] = 'C';
	LDI  R30,LOW(67)
	__PUTB1MN _time_string,2
; 0000 0242         time_string[3] = 'a';
	LDI  R30,LOW(97)
	__PUTB1MN _time_string,3
; 0000 0243         time_string[4] = 'n';
	LDI  R30,LOW(110)
	__PUTB1MN _time_string,4
; 0000 0244         time_string[5] = 'c';
	LDI  R30,LOW(99)
	__PUTB1MN _time_string,5
; 0000 0245         time_string[6] = 'e';
	LDI  R30,LOW(101)
	__PUTB1MN _time_string,6
; 0000 0246         time_string[7] = 'l';
	LDI  R30,LOW(108)
	__PUTB1MN _time_string,7
; 0000 0247         time_string[8] = ' ';
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x12
; 0000 0248         time_string[9] = ' ';
; 0000 0249         time_string[10] = ' ';
; 0000 024A         time_string[11] = ' ';
; 0000 024B         time_string[12] = ' ';
; 0000 024C         time_string[13] = ' ';
; 0000 024D         time_string[14] = ' ';
; 0000 024E         time_string[15] = ' ';
; 0000 024F         time_string[16] = '\0';
; 0000 0250 
; 0000 0251         lcd_send_string(time_string);
; 0000 0252         string[0] = 'D';
	LDI  R30,LOW(68)
	RCALL SUBOPT_0x8
; 0000 0253         string[1] = ':';
; 0000 0254         string[2] = 'C';
	LDI  R30,LOW(67)
	__PUTB1MN _string,2
; 0000 0255         string[3] = 'o';
	LDI  R30,LOW(111)
	__PUTB1MN _string,3
; 0000 0256         string[4] = 'n';
	LDI  R30,LOW(110)
	__PUTB1MN _string,4
; 0000 0257         string[5] = 'f';
	LDI  R30,LOW(102)
	__PUTB1MN _string,5
; 0000 0258         string[6] = 'i';
	LDI  R30,LOW(105)
	__PUTB1MN _string,6
; 0000 0259         string[7] = 'r';
	LDI  R30,LOW(114)
	__PUTB1MN _string,7
; 0000 025A         string[8] = 'm';
	LDI  R30,LOW(109)
	__PUTB1MN _string,8
; 0000 025B         string[9] = ' ';
	LDI  R30,LOW(32)
_0x52:
	__PUTB1MN _string,9
; 0000 025C         string[10] = 'A';
	LDI  R30,LOW(65)
	__PUTB1MN _string,10
; 0000 025D         string[11] = 'l';
	LDI  R30,LOW(108)
	__PUTB1MN _string,11
; 0000 025E         string[12] = 'a';
	LDI  R30,LOW(97)
	__PUTB1MN _string,12
; 0000 025F         string[13] = 'r';
	LDI  R30,LOW(114)
	__PUTB1MN _string,13
; 0000 0260         string[14] = 'm';
	LDI  R30,LOW(109)
_0x53:
	__PUTB1MN _string,14
; 0000 0261         string[15] = ' ';
	LDI  R30,LOW(32)
_0x51:
	__PUTB1MN _string,15
; 0000 0262         string[16] = '\0';
	LDI  R30,LOW(0)
	__PUTB1MN _string,16
; 0000 0263         lcd_go_to_xy(1, 0);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x6
; 0000 0264         lcd_send_string(string);
	LDI  R26,LOW(_string)
	LDI  R27,HIGH(_string)
	RCALL _lcd_send_string
; 0000 0265         lcd_go_to_xy(0, 0);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x6
; 0000 0266         break;
; 0000 0267     }
; 0000 0268     };
_0x3D:
; 0000 0269 
; 0000 026A }
	RET
; .FEND
;
;void main(void)
; 0000 026D {
_main:
; .FSTART _main
; 0000 026E // Declare your local variables here
; 0000 026F 
; 0000 0270 // Input/Output Ports initialization
; 0000 0271 // Port A initialization
; 0000 0272 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0273 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0274 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0275 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0276 
; 0000 0277 // Port B initialization
; 0000 0278 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0279 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 027A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 027B PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 027C 
; 0000 027D // Port C initialization
; 0000 027E // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 027F DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0280 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0281 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0282 
; 0000 0283 // Port D initialization
; 0000 0284 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0285 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0286 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0287 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0288 
; 0000 0289 // Timer/Counter 0 initialization
; 0000 028A // Clock source: System Clock
; 0000 028B // Clock value: 31.250 kHz
; 0000 028C // Mode: Normal top=0xFF
; 0000 028D // OC0 output: Disconnected
; 0000 028E // Timer Period: 4 ms
; 0000 028F TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 0290 TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 0291 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0292 
; 0000 0293 // Timer/Counter 1 initialization
; 0000 0294 // Clock source: System Clock
; 0000 0295 // Clock value: Timer1 Stopped
; 0000 0296 // Mode: Normal top=0xFFFF
; 0000 0297 // OC1A output: Disconnected
; 0000 0298 // OC1B output: Disconnected
; 0000 0299 // Noise Canceler: Off
; 0000 029A // Input Capture on Falling Edge
; 0000 029B // Timer1 Overflow Interrupt: Off
; 0000 029C // Input Capture Interrupt: Off
; 0000 029D // Compare A Match Interrupt: Off
; 0000 029E // Compare B Match Interrupt: Off
; 0000 029F TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 02A0 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 02A1 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 02A2 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 02A3 ICR1H=0x00;
	OUT  0x27,R30
; 0000 02A4 ICR1L=0x00;
	OUT  0x26,R30
; 0000 02A5 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 02A6 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 02A7 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 02A8 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 02A9 
; 0000 02AA // Timer/Counter 2 initialization
; 0000 02AB // Clock source: System Clock
; 0000 02AC // Clock value: Timer2 Stopped
; 0000 02AD // Mode: Normal top=0xFF
; 0000 02AE // OC2 output: Disconnected
; 0000 02AF ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 02B0 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 02B1 TCNT2=0x00;
	OUT  0x24,R30
; 0000 02B2 OCR2=0x00;
	OUT  0x23,R30
; 0000 02B3 
; 0000 02B4 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02B5 TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 02B6 
; 0000 02B7 // External Interrupt(s) initialization
; 0000 02B8 // INT0: Off
; 0000 02B9 // INT1: Off
; 0000 02BA // INT2: Off
; 0000 02BB MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 02BC MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 02BD 
; 0000 02BE // USART initialization
; 0000 02BF // USART disabled
; 0000 02C0 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 02C1 
; 0000 02C2 // Analog Comparator initialization
; 0000 02C3 // Analog Comparator: Off
; 0000 02C4 // The Analog Comparator's positive input is
; 0000 02C5 // connected to the AIN0 pin
; 0000 02C6 // The Analog Comparator's negative input is
; 0000 02C7 // connected to the AIN1 pin
; 0000 02C8 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02C9 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 02CA 
; 0000 02CB // ADC initialization
; 0000 02CC // ADC disabled
; 0000 02CD ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 02CE 
; 0000 02CF // SPI initialization
; 0000 02D0 // SPI disabled
; 0000 02D1 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 02D2 
; 0000 02D3 // TWI initialization
; 0000 02D4 // TWI disabled
; 0000 02D5 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 02D6 
; 0000 02D7 // Global enable interrupts
; 0000 02D8 #asm("sei")
	sei
; 0000 02D9 
; 0000 02DA DDRC = DDRC & ~(1<<5);
	CBI  0x14,5
; 0000 02DB DDRD = DDRD & ~(1<<5);
	CBI  0x11,5
; 0000 02DC //DDRD = DDRD | ( 1<<4);
; 0000 02DD lcd_init();
	RCALL _lcd_init
; 0000 02DE while (1)
_0x48:
; 0000 02DF       {
; 0000 02E0       // Place your code here
; 0000 02E1         check_push_buttons();
	RCALL _check_push_buttons
; 0000 02E2 
; 0000 02E3         update_lcd();
	RCALL _update_lcd
; 0000 02E4         lcd_send_cmd(0x0c);
	LDI  R26,LOW(12)
	RCALL _lcd_send_cmd
; 0000 02E5         delay_us(500);
	__DELAY_USW 1000
; 0000 02E6       }
	RJMP _0x48
; 0000 02E7 }
_0x4B:
	RJMP _0x4B
; .FEND

	.DSEG
_time_string:
	.BYTE 0x11
_state:
	.BYTE 0x1
_ALARM:
	.BYTE 0x1
_string:
	.BYTE 0x11

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_time_string)
	LDI  R27,HIGH(_time_string)
	RJMP _lcd_send_string

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(32)
	ST   X,R30
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_go_to_xy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x7:
	ST   -Y,R6
	ST   -Y,R7
	ST   -Y,R4
	LDI  R26,LOW(_time_string)
	LDI  R27,HIGH(_time_string)
	RCALL _updateTimeString
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x8:
	STS  _string,R30
	LDI  R30,LOW(58)
	__PUTB1MN _string,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	__PUTB1MN _string,10
	LDI  R30,LOW(58)
	__PUTB1MN _string,11
	LDI  R30,LOW(65)
	__PUTB1MN _string,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(67)
	__PUTB1MN _string,2
	LDI  R30,LOW(104)
	__PUTB1MN _string,3
	LDI  R30,LOW(103)
	__PUTB1MN _string,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xB:
	__PUTB1MN _string,7
	LDI  R30,LOW(45)
	__PUTB1MN _string,8
	LDI  R30,LOW(67)
	__PUTB1MN _string,9
	LDI  R30,LOW(58)
	__PUTB1MN _string,10
	LDI  R30,LOW(71)
	__PUTB1MN _string,11
	LDI  R30,LOW(111)
	__PUTB1MN _string,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	ST   -Y,R10
	ST   -Y,R11
	ST   -Y,R8
	LDI  R26,LOW(_time_string)
	LDI  R27,HIGH(_time_string)
	RCALL _updateTimeString
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(83)
	__PUTB1MN _string,2
	LDI  R30,LOW(116)
	__PUTB1MN _string,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(97)
	__PUTB1MN _string,4
	LDI  R30,LOW(114)
	__PUTB1MN _string,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xF:
	__PUTB1MN _string,6
	LDI  R30,LOW(45)
	__PUTB1MN _string,7
	LDI  R30,LOW(67)
	__PUTB1MN _string,8
	LDI  R30,LOW(58)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(77)
	__PUTB1MN _string,5
	LDI  R30,LOW(105)
	__PUTB1MN _string,6
	LDI  R30,LOW(110)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(67)
	STS  _time_string,R30
	LDI  R30,LOW(58)
	__PUTB1MN _time_string,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x12:
	__PUTB1MN _time_string,8
	LDI  R30,LOW(32)
	__PUTB1MN _time_string,9
	__PUTB1MN _time_string,10
	__PUTB1MN _time_string,11
	__PUTB1MN _time_string,12
	__PUTB1MN _time_string,13
	__PUTB1MN _time_string,14
	__PUTB1MN _time_string,15
	LDI  R30,LOW(0)
	__PUTB1MN _time_string,16
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	ST   -Y,R12
	ST   -Y,R13
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(_time_string)
	LDI  R27,HIGH(_time_string)
	RCALL _updateTimeString
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(83)
	__PUTB1MN _string,2
	LDI  R30,LOW(101)
	__PUTB1MN _string,3
	LDI  R30,LOW(116)
	__PUTB1MN _string,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(72)
	__PUTB1MN _string,5
	LDI  R30,LOW(114)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x16:
	__PUTB1MN _string,9
	LDI  R30,LOW(70)
	__PUTB1MN _string,10
	LDI  R30,LOW(105)
	__PUTB1MN _string,11
	LDI  R30,LOW(110)
	__PUTB1MN _string,12
	LDI  R30,LOW(105)
	__PUTB1MN _string,13
	LDI  R30,LOW(115)
	__PUTB1MN _string,14
	LDI  R30,LOW(104)
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__LTB12U:
	CP   R26,R30
	LDI  R30,1
	BRLO __LTB12U1
	CLR  R30
__LTB12U1:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

;END OF CODE MARKER
__END_OF_CODE:
