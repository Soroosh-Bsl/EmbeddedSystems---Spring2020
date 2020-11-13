
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
	.DEF _counter0=R5
	.DEF _counter1=R4
	.DEF _seconds0=R7
	.DEF _seconds1=R6

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


__GLOBAL_INI_TBL:
	.DW  0x04
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
;Project : Elevator -Embedded Course
;Version :
;Date    : 3/29/2020
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
;#include <io.h>>
;// Declare your global variables here
;#define LCD_Dir  DDRA            /* Define LCD data port direction */
;#define LCD_Port PORTA            /* Define LCD data port */
;#define RS PORTA2                /* Define Register Select pin */
;#define EN PORTA3                 /* Define Enable signal pin */
;
;unsigned char cabins_states[2];
;
;void LCD_Char( unsigned char data );
;void LCD_String_xy (char row, char pos, char *str);
;void off_LED(char floor, char dir);
;unsigned char cabins_floors[2];
;unsigned char cabins_up_stops[2][5];
;unsigned char cabins_down_stops[2][5];
;unsigned char counter0 = 0;
;unsigned char counter1 = 0;
;unsigned char seconds0 = 0;
;unsigned char seconds1 = 0;
;unsigned char threshold[2];
;unsigned char flag[2];
;
;#define clocks_per_a_sec 30
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0034 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	RCALL SUBOPT_0x0
; 0000 0035     unsigned char i = 0;
; 0000 0036     // Reinitialize Timer 0 value
; 0000 0037     TCNT0=0x83;
;	i -> R17
	OUT  0x32,R30
; 0000 0038     // Place your code here
; 0000 0039     counter0 += 1;
	INC  R5
; 0000 003A     if (counter0 == clocks_per_a_sec){
	LDI  R30,LOW(30)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x3
; 0000 003B         counter0 = 0;
	CLR  R5
; 0000 003C         seconds0 += 1;
	INC  R7
; 0000 003D         if (seconds0 == threshold[0]){
	LDS  R30,_threshold
	CP   R30,R7
	BREQ PC+2
	RJMP _0x4
; 0000 003E             seconds0 = 0;
	CLR  R7
; 0000 003F             flag[0] = 0;
	LDI  R30,LOW(0)
	STS  _flag,R30
; 0000 0040             if (threshold[0] == 3 || threshold[0] == 0){
	LDS  R26,_threshold
	CPI  R26,LOW(0x3)
	BREQ _0x6
	CPI  R26,LOW(0x0)
	BREQ _0x6
	RJMP _0x5
_0x6:
; 0000 0041                 if (cabins_states[0] == 'u'){
	LDS  R26,_cabins_states
	CPI  R26,LOW(0x75)
	BRNE _0x8
; 0000 0042                     cabins_up_stops[0][cabins_floors[0]] = 0;
	LDS  R30,_cabins_floors
	RCALL SUBOPT_0x1
; 0000 0043                     off_LED(cabins_floors[0], 'u');
	LDS  R30,_cabins_floors
	ST   -Y,R30
	LDI  R26,LOW(117)
	RCALL _off_LED
; 0000 0044                     for (i = cabins_floors[0]; i < 5; i++){
	LDS  R17,_cabins_floors
_0xA:
	CPI  R17,5
	BRSH _0xB
; 0000 0045                         if (cabins_up_stops[0][i] == 1){
	RCALL SUBOPT_0x2
	BRNE _0xC
; 0000 0046                             flag[0] = 1;
	RCALL SUBOPT_0x3
; 0000 0047                             cabins_floors[0] += 1;
; 0000 0048                             if (cabins_floors[0] == i){
	BRNE _0xD
; 0000 0049                                 off_LED(i, 'u');
	RCALL SUBOPT_0x4
; 0000 004A                                 cabins_up_stops[0][i] = 0;
; 0000 004B                                 threshold[0] = 10;
	LDI  R30,LOW(10)
	RJMP _0x14F
; 0000 004C                             }
; 0000 004D                             else
_0xD:
; 0000 004E                                 threshold[0] = 3;
	LDI  R30,LOW(3)
_0x14F:
	STS  _threshold,R30
; 0000 004F                             break;
	RJMP _0xB
; 0000 0050                         }
; 0000 0051                     }
_0xC:
	SUBI R17,-1
	RJMP _0xA
_0xB:
; 0000 0052                     if (flag[0] == 0){
	LDS  R30,_flag
	CPI  R30,0
	BRNE _0xF
; 0000 0053                         for (i = 5; i >= cabins_floors[0] && i < 255; i--){
	LDI  R17,LOW(5)
_0x11:
	LDS  R30,_cabins_floors
	CP   R17,R30
	BRLO _0x13
	CPI  R17,255
	BRLO _0x14
_0x13:
	RJMP _0x12
_0x14:
; 0000 0054                             if (cabins_down_stops[0][i] == 1){
	RCALL SUBOPT_0x5
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRNE _0x15
; 0000 0055                                 flag[0] = 1;
	RCALL SUBOPT_0x3
; 0000 0056                                 cabins_floors[0] += 1;
; 0000 0057                                 if (cabins_floors[0] == i){
	BRNE _0x16
; 0000 0058                                     off_LED(i, 'd');
	RCALL SUBOPT_0x6
; 0000 0059                                     cabins_down_stops[0][i] = 0;
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 005A                                     threshold[0] = 10;
	LDI  R30,LOW(10)
	RJMP _0x150
; 0000 005B                                 }
; 0000 005C                                 else
_0x16:
; 0000 005D                                     threshold[0] = 3;
	LDI  R30,LOW(3)
_0x150:
	STS  _threshold,R30
; 0000 005E                                 break;
	RJMP _0x12
; 0000 005F                             }
; 0000 0060                         }
_0x15:
	SUBI R17,1
	RJMP _0x11
_0x12:
; 0000 0061                     }
; 0000 0062                     if (flag[0] == 0){
_0xF:
	LDS  R30,_flag
	CPI  R30,0
	BRNE _0x18
; 0000 0063                         TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	RCALL SUBOPT_0x7
; 0000 0064                         TCNT0=0x00;
; 0000 0065                         cabins_states[0] = 's';
; 0000 0066                     }
; 0000 0067                 }
_0x18:
; 0000 0068                 else if (cabins_states[0] == 'd'){
	RJMP _0x19
_0x8:
	LDS  R26,_cabins_states
	CPI  R26,LOW(0x64)
	BRNE _0x1A
; 0000 0069                     cabins_down_stops[0][cabins_floors[0]] = 0;
	LDS  R30,_cabins_floors
	LDI  R31,0
	SUBI R30,LOW(-_cabins_down_stops)
	SBCI R31,HIGH(-_cabins_down_stops)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 006A                     off_LED(cabins_floors[0], 'd');
	LDS  R30,_cabins_floors
	ST   -Y,R30
	LDI  R26,LOW(100)
	RCALL _off_LED
; 0000 006B                     for (i = cabins_floors[0]; i < 255; i--)
	LDS  R17,_cabins_floors
_0x1C:
	CPI  R17,255
	BRSH _0x1D
; 0000 006C                         if (cabins_down_stops[0][i] == 1){
	RCALL SUBOPT_0x5
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRNE _0x1E
; 0000 006D                             flag[0] = 1;
	RCALL SUBOPT_0x8
; 0000 006E                             cabins_floors[0] -= 1;
; 0000 006F                             if (cabins_floors[0] == i){
	BRNE _0x1F
; 0000 0070                                 off_LED(i, 'd');
	RCALL SUBOPT_0x6
; 0000 0071                                 cabins_down_stops[0][i] = 0;
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0072                                 threshold[0] = 10;
	LDI  R30,LOW(10)
	RJMP _0x151
; 0000 0073                             }
; 0000 0074                             else
_0x1F:
; 0000 0075                                 threshold[0] = 3;
	LDI  R30,LOW(3)
_0x151:
	STS  _threshold,R30
; 0000 0076                             break;
	RJMP _0x1D
; 0000 0077                         }
; 0000 0078                     if (flag[0] == 0){
_0x1E:
	SUBI R17,1
	RJMP _0x1C
_0x1D:
	LDS  R30,_flag
	CPI  R30,0
	BRNE _0x21
; 0000 0079                         for (i = 0; i <= cabins_floors[0]; i++){
	LDI  R17,LOW(0)
_0x23:
	LDS  R30,_cabins_floors
	CP   R30,R17
	BRLO _0x24
; 0000 007A                             if (cabins_up_stops[0][i] == 1){
	RCALL SUBOPT_0x2
	BRNE _0x25
; 0000 007B                                 flag[0] = 1;
	RCALL SUBOPT_0x8
; 0000 007C                                 cabins_floors[0] -= 1;
; 0000 007D                                 if (cabins_floors[0] == i){
	BRNE _0x26
; 0000 007E                                     off_LED(i, 'u');
	RCALL SUBOPT_0x4
; 0000 007F                                     cabins_up_stops[0][i] = 0;
; 0000 0080                                     threshold[0] = 10;
	LDI  R30,LOW(10)
	RJMP _0x152
; 0000 0081                                 }
; 0000 0082                                 else
_0x26:
; 0000 0083                                     threshold[0] = 3;
	LDI  R30,LOW(3)
_0x152:
	STS  _threshold,R30
; 0000 0084                                 break;
	RJMP _0x24
; 0000 0085                             }
; 0000 0086                         }
_0x25:
	SUBI R17,-1
	RJMP _0x23
_0x24:
; 0000 0087                     }
; 0000 0088                     if (flag[0] == 0){
_0x21:
	LDS  R30,_flag
	CPI  R30,0
	BRNE _0x28
; 0000 0089                         TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	RCALL SUBOPT_0x7
; 0000 008A                         TCNT0=0x00;
; 0000 008B                         cabins_states[0] = 's';
; 0000 008C                     }
; 0000 008D                 }
_0x28:
; 0000 008E             }
_0x1A:
_0x19:
; 0000 008F             else{
	RJMP _0x29
_0x5:
; 0000 0090                 if (cabins_states[0] == 'u'){
	LDS  R26,_cabins_states
	CPI  R26,LOW(0x75)
	BRNE _0x2A
; 0000 0091                     for (i = cabins_floors[0]; i < 5; i++){
	LDS  R17,_cabins_floors
_0x2C:
	CPI  R17,5
	BRSH _0x2D
; 0000 0092                         if (cabins_up_stops[0][i] == 1){
	RCALL SUBOPT_0x2
	BRNE _0x2E
; 0000 0093                             threshold[0] = 3;
	RCALL SUBOPT_0x9
; 0000 0094                             flag[0] = 1;
; 0000 0095                             break;
	RJMP _0x2D
; 0000 0096                         }
; 0000 0097                     }
_0x2E:
	SUBI R17,-1
	RJMP _0x2C
_0x2D:
; 0000 0098                     if (flag[0] == 0){
	LDS  R30,_flag
	CPI  R30,0
	BRNE _0x2F
; 0000 0099                         for (i = cabins_floors[0]; i < 255; i--){
	LDS  R17,_cabins_floors
_0x31:
	CPI  R17,255
	BRSH _0x32
; 0000 009A                             if (cabins_down_stops[0][i] == 1){
	RCALL SUBOPT_0x5
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRNE _0x33
; 0000 009B                                 cabins_states[0] = 'd';
	LDI  R30,LOW(100)
	STS  _cabins_states,R30
; 0000 009C                                 threshold[0] = 3;
	RCALL SUBOPT_0x9
; 0000 009D                                 flag[0] = 1;
; 0000 009E                                 break;
	RJMP _0x32
; 0000 009F                             }
; 0000 00A0                         }
_0x33:
	SUBI R17,1
	RJMP _0x31
_0x32:
; 0000 00A1                     }
; 0000 00A2                     if (flag[0] == 0){
_0x2F:
	LDS  R30,_flag
	CPI  R30,0
	BRNE _0x34
; 0000 00A3                         //stop timer
; 0000 00A4                         TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	RCALL SUBOPT_0x7
; 0000 00A5                         TCNT0=0x00;
; 0000 00A6                         cabins_states[0] = 's';
; 0000 00A7                     }
; 0000 00A8                 }
_0x34:
; 0000 00A9                 else if (cabins_states[0] == 'd'){
	RJMP _0x35
_0x2A:
	LDS  R26,_cabins_states
	CPI  R26,LOW(0x64)
	BRNE _0x36
; 0000 00AA                     for (i = cabins_floors[0]; i < 255; i--)
	LDS  R17,_cabins_floors
_0x38:
	CPI  R17,255
	BRSH _0x39
; 0000 00AB                         if (cabins_down_stops[0][i] == 1){
	RCALL SUBOPT_0x5
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRNE _0x3A
; 0000 00AC                             threshold[0] = 3;
	RCALL SUBOPT_0x9
; 0000 00AD                             flag[0] = 1;
; 0000 00AE                             break;
	RJMP _0x39
; 0000 00AF                         }
; 0000 00B0                     if (flag[0] == 0){
_0x3A:
	SUBI R17,1
	RJMP _0x38
_0x39:
	LDS  R30,_flag
	CPI  R30,0
	BRNE _0x3B
; 0000 00B1                         for (i = cabins_floors[0]; i < 5 ; i++)
	LDS  R17,_cabins_floors
_0x3D:
	CPI  R17,5
	BRSH _0x3E
; 0000 00B2                             if (cabins_up_stops[0][i] == 1){
	RCALL SUBOPT_0x2
	BRNE _0x3F
; 0000 00B3                                 cabins_states[0] = 'u';
	LDI  R30,LOW(117)
	STS  _cabins_states,R30
; 0000 00B4                                 threshold[0] = 3;
	RCALL SUBOPT_0x9
; 0000 00B5                                 flag[0] = 1;
; 0000 00B6                                 break;
	RJMP _0x3E
; 0000 00B7                             }
; 0000 00B8                     }
_0x3F:
	SUBI R17,-1
	RJMP _0x3D
_0x3E:
; 0000 00B9                     if (flag[0] == 0){
_0x3B:
	LDS  R30,_flag
	CPI  R30,0
	BRNE _0x40
; 0000 00BA                         //stop timer
; 0000 00BB                         TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	RCALL SUBOPT_0x7
; 0000 00BC                         TCNT0=0x00;
; 0000 00BD                         cabins_states[0] = 's';
; 0000 00BE                     }
; 0000 00BF                 }
_0x40:
; 0000 00C0             }
_0x36:
_0x35:
_0x29:
; 0000 00C1         }
; 0000 00C2     }
_0x4:
; 0000 00C3 }
_0x3:
	RJMP _0x15F
; .FEND
;
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 00C6 {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	RCALL SUBOPT_0x0
; 0000 00C7     unsigned char i = 0;
; 0000 00C8     // Reinitialize Timer 2 value
; 0000 00C9     TCNT2=0x83;
;	i -> R17
	OUT  0x24,R30
; 0000 00CA     // Place your code here
; 0000 00CB     counter1 += 1;
	INC  R4
; 0000 00CC     if (counter1 == clocks_per_a_sec){
	LDI  R30,LOW(30)
	CP   R30,R4
	BREQ PC+2
	RJMP _0x41
; 0000 00CD         counter1 = 0;
	CLR  R4
; 0000 00CE         seconds1 += 1;
	INC  R6
; 0000 00CF         if (seconds1 == threshold[1]){
	__GETB1MN _threshold,1
	CP   R30,R6
	BREQ PC+2
	RJMP _0x42
; 0000 00D0             seconds1 = 0;
	CLR  R6
; 0000 00D1             flag[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _flag,1
; 0000 00D2             if (threshold[1] == 3 || threshold[1] == 0){
	__GETB2MN _threshold,1
	CPI  R26,LOW(0x3)
	BREQ _0x44
	__GETB2MN _threshold,1
	CPI  R26,LOW(0x0)
	BREQ _0x44
	RJMP _0x43
_0x44:
; 0000 00D3                 if (cabins_states[1] == 'u'){
	__GETB2MN _cabins_states,1
	CPI  R26,LOW(0x75)
	BREQ PC+2
	RJMP _0x46
; 0000 00D4                     cabins_up_stops[1][cabins_floors[1]] = 0;
	__POINTW2MN _cabins_up_stops,5
	RCALL SUBOPT_0xA
; 0000 00D5                     off_LED(cabins_floors[1], 'u');
	LDI  R26,LOW(117)
	RCALL _off_LED
; 0000 00D6                     for (i = cabins_floors[1]; i < 5; i++){
	__GETBRMN 17,_cabins_floors,1
_0x48:
	CPI  R17,5
	BRSH _0x49
; 0000 00D7                         if (cabins_up_stops[1][i] == 1){
	RCALL SUBOPT_0xB
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x4A
; 0000 00D8                             flag[1] = 1;
	RCALL SUBOPT_0xC
; 0000 00D9                             cabins_floors[1] += 1;
; 0000 00DA                             if (cabins_floors[1] == i){
	BRNE _0x4B
; 0000 00DB                                 off_LED(i, 'u');
	ST   -Y,R17
	LDI  R26,LOW(117)
	RCALL _off_LED
; 0000 00DC                                 cabins_up_stops[1][i] = 0;
	RCALL SUBOPT_0xB
	ST   X,R30
; 0000 00DD                                 threshold[1] = 10;
	LDI  R30,LOW(10)
	RJMP _0x153
; 0000 00DE                             }
; 0000 00DF                             else
_0x4B:
; 0000 00E0                                 threshold[1] = 3;
	LDI  R30,LOW(3)
_0x153:
	__PUTB1MN _threshold,1
; 0000 00E1                             break;
	RJMP _0x49
; 0000 00E2                         }
; 0000 00E3                     }
_0x4A:
	SUBI R17,-1
	RJMP _0x48
_0x49:
; 0000 00E4                     if (flag[1] == 0){
	__GETB1MN _flag,1
	CPI  R30,0
	BRNE _0x4D
; 0000 00E5                         for (i = 5; i >= cabins_floors[1] && i < 255; i--){
	LDI  R17,LOW(5)
_0x4F:
	__GETB1MN _cabins_floors,1
	CP   R17,R30
	BRLO _0x51
	CPI  R17,255
	BRLO _0x52
_0x51:
	RJMP _0x50
_0x52:
; 0000 00E6                             if (cabins_down_stops[1][i] == 1){
	RCALL SUBOPT_0xD
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x53
; 0000 00E7                                 flag[1] = 1;
	RCALL SUBOPT_0xC
; 0000 00E8                                 cabins_floors[1] += 1;
; 0000 00E9                                 if (cabins_floors[1] == i){
	BRNE _0x54
; 0000 00EA                                     off_LED(i, 'd');
	ST   -Y,R17
	LDI  R26,LOW(100)
	RCALL _off_LED
; 0000 00EB                                     cabins_down_stops[1][i] = 0;
	RCALL SUBOPT_0xD
	ST   X,R30
; 0000 00EC                                     threshold[1] = 10;
	LDI  R30,LOW(10)
	RJMP _0x154
; 0000 00ED                                 }
; 0000 00EE                                 else
_0x54:
; 0000 00EF                                     threshold[1] = 3;
	LDI  R30,LOW(3)
_0x154:
	__PUTB1MN _threshold,1
; 0000 00F0                                 break;
	RJMP _0x50
; 0000 00F1                             }
; 0000 00F2                         }
_0x53:
	SUBI R17,1
	RJMP _0x4F
_0x50:
; 0000 00F3                     }
; 0000 00F4                     if (flag[1] == 0){
_0x4D:
	__GETB1MN _flag,1
	CPI  R30,0
	BRNE _0x56
; 0000 00F5                         //stop timer
; 0000 00F6                         TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	RCALL SUBOPT_0xE
; 0000 00F7                         TCNT2=0x00;
; 0000 00F8                         cabins_states[1] = 's';
; 0000 00F9                     }
; 0000 00FA                 }
_0x56:
; 0000 00FB                 else if (cabins_states[1] == 'd'){
	RJMP _0x57
_0x46:
	__GETB2MN _cabins_states,1
	CPI  R26,LOW(0x64)
	BREQ PC+2
	RJMP _0x58
; 0000 00FC                     cabins_down_stops[1][cabins_floors[1]] = 0;
	__POINTW2MN _cabins_down_stops,5
	RCALL SUBOPT_0xA
; 0000 00FD                     off_LED(cabins_floors[1], 'd');
	LDI  R26,LOW(100)
	RCALL _off_LED
; 0000 00FE                     for (i = cabins_floors[1]; i < 255; i--){
	__GETBRMN 17,_cabins_floors,1
_0x5A:
	CPI  R17,255
	BRSH _0x5B
; 0000 00FF                         if (cabins_down_stops[1][i] == 1){
	RCALL SUBOPT_0xD
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x5C
; 0000 0100                             cabins_floors[1] -= 1;
	RCALL SUBOPT_0xF
; 0000 0101                             if (cabins_floors[1] == i){
	BRNE _0x5D
; 0000 0102                                 cabins_down_stops[1][i] = 0;
	RCALL SUBOPT_0xD
	ST   X,R30
; 0000 0103                                 off_LED(i, 'd');
	ST   -Y,R17
	LDI  R26,LOW(100)
	RCALL _off_LED
; 0000 0104                                 threshold[1] = 10;
	LDI  R30,LOW(10)
	RJMP _0x155
; 0000 0105                             }
; 0000 0106                             else
_0x5D:
; 0000 0107                                 threshold[1] = 3;
	LDI  R30,LOW(3)
_0x155:
	__PUTB1MN _threshold,1
; 0000 0108                             break;
	RJMP _0x5B
; 0000 0109                         }
; 0000 010A                     }
_0x5C:
	SUBI R17,1
	RJMP _0x5A
_0x5B:
; 0000 010B                     if (flag[1] == 0){
	__GETB1MN _flag,1
	CPI  R30,0
	BRNE _0x5F
; 0000 010C                         for (i = 0; i <= cabins_floors[1]; i++){
	LDI  R17,LOW(0)
_0x61:
	__GETB1MN _cabins_floors,1
	CP   R30,R17
	BRLO _0x62
; 0000 010D                             if (cabins_up_stops[1][i] == 1){
	RCALL SUBOPT_0xB
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x63
; 0000 010E                                 flag[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _flag,1
; 0000 010F                                 cabins_floors[1] -= 1;
	RCALL SUBOPT_0xF
; 0000 0110                                 if (cabins_floors[1] == i){
	BRNE _0x64
; 0000 0111                                     cabins_up_stops[1][i] = 0;
	RCALL SUBOPT_0xB
	ST   X,R30
; 0000 0112                                     off_LED(i, 'u');
	ST   -Y,R17
	LDI  R26,LOW(117)
	RCALL _off_LED
; 0000 0113                                     threshold[1] = 10;
	LDI  R30,LOW(10)
	RJMP _0x156
; 0000 0114                                 }
; 0000 0115                                 else
_0x64:
; 0000 0116                                     threshold[1] = 3;
	LDI  R30,LOW(3)
_0x156:
	__PUTB1MN _threshold,1
; 0000 0117                                 break;
	RJMP _0x62
; 0000 0118                             }
; 0000 0119                         }
_0x63:
	SUBI R17,-1
	RJMP _0x61
_0x62:
; 0000 011A                     }
; 0000 011B                     if (flag[1] == 0){
_0x5F:
	__GETB1MN _flag,1
	CPI  R30,0
	BRNE _0x66
; 0000 011C                         //stop timer
; 0000 011D                         TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	RCALL SUBOPT_0xE
; 0000 011E                         TCNT2=0x00;
; 0000 011F                         cabins_states[1] = 's';
; 0000 0120                     }
; 0000 0121                 }
_0x66:
; 0000 0122             }
_0x58:
_0x57:
; 0000 0123             else{
	RJMP _0x67
_0x43:
; 0000 0124                 if (cabins_states[1] == 'u'){
	__GETB2MN _cabins_states,1
	CPI  R26,LOW(0x75)
	BRNE _0x68
; 0000 0125                     for (i = cabins_floors[1]; i < 5; i++){
	__GETBRMN 17,_cabins_floors,1
_0x6A:
	CPI  R17,5
	BRSH _0x6B
; 0000 0126                         if (cabins_up_stops[1][i] == 1){
	RCALL SUBOPT_0xB
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x6C
; 0000 0127                             threshold[1] = 3;
	RCALL SUBOPT_0x10
; 0000 0128                             flag[1] = 1;
; 0000 0129                             break;
	RJMP _0x6B
; 0000 012A                         }
; 0000 012B                     }
_0x6C:
	SUBI R17,-1
	RJMP _0x6A
_0x6B:
; 0000 012C                     if (flag[1] == 0){
	__GETB1MN _flag,1
	CPI  R30,0
	BRNE _0x6D
; 0000 012D                         for (i = cabins_floors[1]; i < 255; i--){
	__GETBRMN 17,_cabins_floors,1
_0x6F:
	CPI  R17,255
	BRSH _0x70
; 0000 012E                             if (cabins_down_stops[1][i] == 1){
	RCALL SUBOPT_0xD
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x71
; 0000 012F                                 cabins_states[1] = 'd';
	LDI  R30,LOW(100)
	__PUTB1MN _cabins_states,1
; 0000 0130                                 threshold[1] = 3;
	RCALL SUBOPT_0x10
; 0000 0131                                 flag[1] = 1;
; 0000 0132                                 break;
	RJMP _0x70
; 0000 0133                             }
; 0000 0134                         }
_0x71:
	SUBI R17,1
	RJMP _0x6F
_0x70:
; 0000 0135                     }
; 0000 0136                     if (flag[1] == 0){
_0x6D:
	__GETB1MN _flag,1
	CPI  R30,0
	BRNE _0x72
; 0000 0137                         //stop timer
; 0000 0138                         TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	RCALL SUBOPT_0xE
; 0000 0139                         TCNT2=0x00;
; 0000 013A                         cabins_states[1] = 's';
; 0000 013B                     }
; 0000 013C                 }
_0x72:
; 0000 013D                 else if (cabins_states[1] == 'd'){
	RJMP _0x73
_0x68:
	__GETB2MN _cabins_states,1
	CPI  R26,LOW(0x64)
	BRNE _0x74
; 0000 013E                     for (i = cabins_floors[1]; i < 255; i--)
	__GETBRMN 17,_cabins_floors,1
_0x76:
	CPI  R17,255
	BRSH _0x77
; 0000 013F                         if (cabins_down_stops[1][i] == 1){
	RCALL SUBOPT_0xD
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x78
; 0000 0140                             threshold[1] = 3;
	RCALL SUBOPT_0x10
; 0000 0141                             flag[1] = 1;
; 0000 0142                             break;
	RJMP _0x77
; 0000 0143                         }
; 0000 0144                     if (flag[1] == 0){
_0x78:
	SUBI R17,1
	RJMP _0x76
_0x77:
	__GETB1MN _flag,1
	CPI  R30,0
	BRNE _0x79
; 0000 0145                         for (i = cabins_floors[1]; i < 5 ; i++)
	__GETBRMN 17,_cabins_floors,1
_0x7B:
	CPI  R17,5
	BRSH _0x7C
; 0000 0146                             if (cabins_up_stops[1][i] == 1){
	RCALL SUBOPT_0xB
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x7D
; 0000 0147                                 cabins_states[1] = 'u';
	LDI  R30,LOW(117)
	__PUTB1MN _cabins_states,1
; 0000 0148                                 threshold[1] = 3;
	RCALL SUBOPT_0x10
; 0000 0149                                 flag[1] = 1;
; 0000 014A                                 break;
	RJMP _0x7C
; 0000 014B                             }
; 0000 014C                     }
_0x7D:
	SUBI R17,-1
	RJMP _0x7B
_0x7C:
; 0000 014D                     if (flag[0] == 0){
_0x79:
	LDS  R30,_flag
	CPI  R30,0
	BRNE _0x7E
; 0000 014E                         //stop timer
; 0000 014F                             TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	RCALL SUBOPT_0xE
; 0000 0150                             TCNT2=0x00;
; 0000 0151                             cabins_states[1] = 's';
; 0000 0152                     }
; 0000 0153                 }
_0x7E:
; 0000 0154             }
_0x74:
_0x73:
_0x67:
; 0000 0155         }
; 0000 0156     }
_0x42:
; 0000 0157 }
_0x41:
_0x15F:
	LD   R17,Y+
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
;void LCD_Command( unsigned char cmnd )
; 0000 015A {
_LCD_Command:
; .FSTART _LCD_Command
; 0000 015B     LCD_Port = (LCD_Port & 0x0F) | (cmnd & 0xF0); /* sending upper nibble */
	RCALL SUBOPT_0x11
;	cmnd -> Y+0
; 0000 015C     LCD_Port &= ~ (1<<RS);        /* RS=0, command reg. */
	CBI  0x1B,2
; 0000 015D     LCD_Port |= (1<<EN);        /* Enable pulse */
	RJMP _0x2000003
; 0000 015E     delay_us(1);
; 0000 015F     LCD_Port &= ~ (1<<EN);
; 0000 0160 
; 0000 0161     delay_us(200);
; 0000 0162 
; 0000 0163     LCD_Port = (LCD_Port & 0x0F) | (cmnd << 4);  /* sending lower nibble */
; 0000 0164     LCD_Port |= (1<<EN);
; 0000 0165     delay_us(1);
; 0000 0166     LCD_Port &= ~ (1<<EN);
; 0000 0167     delay_ms(2);
; 0000 0168 }
; .FEND
;
;
;void LCD_Char( unsigned char data )
; 0000 016C {
_LCD_Char:
; .FSTART _LCD_Char
; 0000 016D     LCD_Port = (LCD_Port & 0x0F) | (data & 0xF0); /* sending upper nibble */
	RCALL SUBOPT_0x11
;	data -> Y+0
; 0000 016E     LCD_Port |= (1<<RS);        /* RS=1, data reg. */
	SBI  0x1B,2
; 0000 016F     LCD_Port|= (1<<EN);
_0x2000003:
	SBI  0x1B,3
; 0000 0170     delay_us(1);
	__DELAY_USB 3
; 0000 0171     LCD_Port &= ~ (1<<EN);
	CBI  0x1B,3
; 0000 0172 
; 0000 0173     delay_us(200);
	__DELAY_USW 400
; 0000 0174 
; 0000 0175     LCD_Port = (LCD_Port & 0x0F) | (data << 4); /* sending lower nibble */
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	OUT  0x1B,R30
; 0000 0176     LCD_Port |= (1<<EN);
	SBI  0x1B,3
; 0000 0177     delay_us(1);
	__DELAY_USB 3
; 0000 0178     LCD_Port &= ~ (1<<EN);
	CBI  0x1B,3
; 0000 0179     delay_ms(2);
	RCALL SUBOPT_0x12
; 0000 017A }
	ADIW R28,1
	RET
; .FEND
;
;void LCD_Init (void)            /* LCD Initialize function */
; 0000 017D {
_LCD_Init:
; .FSTART _LCD_Init
; 0000 017E     LCD_Dir = 0xFF;            /* Make LCD port direction as o/p */
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 017F     delay_ms(20);            /* LCD Power ON delay always >15ms */
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0000 0180 
; 0000 0181     LCD_Command(0x02);        /* send for 4 bit initialization of LCD  */
	LDI  R26,LOW(2)
	RCALL _LCD_Command
; 0000 0182     LCD_Command(0x28);              /* 2 line, 5*7 matrix in 4-bit mode */
	LDI  R26,LOW(40)
	RCALL _LCD_Command
; 0000 0183     LCD_Command(0x0c);              /* Display on cursor off*/
	LDI  R26,LOW(12)
	RCALL _LCD_Command
; 0000 0184     LCD_Command(0x06);              /* Increment cursor (shift cursor to right)*/
	LDI  R26,LOW(6)
	RCALL _LCD_Command
; 0000 0185     LCD_Command(0x01);              /* Clear display screen*/
	LDI  R26,LOW(1)
	RCALL _LCD_Command
; 0000 0186     delay_ms(2);
	RCALL SUBOPT_0x12
; 0000 0187 }
	RET
; .FEND
;
;
;void LCD_String (char *str)		/* Send string to LCD function */
; 0000 018B {
_LCD_String:
; .FSTART _LCD_String
; 0000 018C 	int i;
; 0000 018D 	for(i=0;str[i]!=0;i++)		/* Send each char of string till the NULL */
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*str -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x80:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BREQ _0x81
; 0000 018E 	{
; 0000 018F 		LCD_Char (str[i]);
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _LCD_Char
; 0000 0190 	}
	__ADDWRN 16,17,1
	RJMP _0x80
_0x81:
; 0000 0191 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2000002
; .FEND
;
;void LCD_String_xy (char row, char pos, char *str)	/* Send string to LCD with xy position */
; 0000 0194 {
_LCD_String_xy:
; .FSTART _LCD_String_xy
; 0000 0195 	if (row == 0 && pos<16)
	ST   -Y,R27
	ST   -Y,R26
;	row -> Y+3
;	pos -> Y+2
;	*str -> Y+0
	LDD  R26,Y+3
	CPI  R26,LOW(0x0)
	BRNE _0x83
	LDD  R26,Y+2
	CPI  R26,LOW(0x10)
	BRLO _0x84
_0x83:
	RJMP _0x82
_0x84:
; 0000 0196 	LCD_Command((pos & 0x0F)|0x80);	/* Command of first row and required position<16 */
	LDD  R30,Y+2
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x157
; 0000 0197 	else if (row == 1 && pos<16)
_0x82:
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x87
	LDD  R26,Y+2
	CPI  R26,LOW(0x10)
	BRLO _0x88
_0x87:
	RJMP _0x86
_0x88:
; 0000 0198 	LCD_Command((pos & 0x0F)|0xC0);	/* Command of first row and required position<16 */
	LDD  R30,Y+2
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x157:
	MOV  R26,R30
	RCALL _LCD_Command
; 0000 0199 	LCD_String(str);		/* Call LCD string function */
_0x86:
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _LCD_String
; 0000 019A }
_0x2000002:
	ADIW R28,4
	RET
; .FEND
;
;void LCD_Clear()
; 0000 019D {
_LCD_Clear:
; .FSTART _LCD_Clear
; 0000 019E 	LCD_Command (0x01);		/* Clear display */
	LDI  R26,LOW(1)
	RCALL _LCD_Command
; 0000 019F 	delay_ms(2);
	RCALL SUBOPT_0x12
; 0000 01A0 	LCD_Command (0x80);		/* Cursor at home position */
	LDI  R26,LOW(128)
	RCALL _LCD_Command
; 0000 01A1 }
	RET
; .FEND
;
;
;void off_LED(char floor, char dir){
; 0000 01A4 void off_LED(char floor, char dir){
_off_LED:
; .FSTART _off_LED
; 0000 01A5     switch (floor) {
	ST   -Y,R26
;	floor -> Y+1
;	dir -> Y+0
	LDD  R30,Y+1
	LDI  R31,0
; 0000 01A6         case 0:{
	SBIW R30,0
	BRNE _0x8C
; 0000 01A7             PORTD &= ~(1<<0);
	CBI  0x12,0
; 0000 01A8             break;
	RJMP _0x8B
; 0000 01A9         }
; 0000 01AA         case 1:{
_0x8C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x8D
; 0000 01AB             if (dir == 'u')
	LD   R26,Y
	CPI  R26,LOW(0x75)
	BRNE _0x8E
; 0000 01AC                 PORTD &= ~(1<<1);
	CBI  0x12,1
; 0000 01AD             else
	RJMP _0x8F
_0x8E:
; 0000 01AE                 PORTD &= ~(1<<2);
	CBI  0x12,2
; 0000 01AF             break;
_0x8F:
	RJMP _0x8B
; 0000 01B0         }
; 0000 01B1         case 2:{
_0x8D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x90
; 0000 01B2             if (dir == 'u')
	LD   R26,Y
	CPI  R26,LOW(0x75)
	BRNE _0x91
; 0000 01B3                 PORTD &= ~(1<<3);
	CBI  0x12,3
; 0000 01B4             else
	RJMP _0x92
_0x91:
; 0000 01B5                 PORTD &= ~(1<<4);
	CBI  0x12,4
; 0000 01B6             break;
_0x92:
	RJMP _0x8B
; 0000 01B7         }
; 0000 01B8         case 3:{
_0x90:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x93
; 0000 01B9             if (dir == 'u')
	LD   R26,Y
	CPI  R26,LOW(0x75)
	BRNE _0x94
; 0000 01BA                 PORTD &= ~(1<<5);
	CBI  0x12,5
; 0000 01BB             else
	RJMP _0x95
_0x94:
; 0000 01BC                 PORTD &= ~(1<<6);
	CBI  0x12,6
; 0000 01BD             break;
_0x95:
	RJMP _0x8B
; 0000 01BE         }
; 0000 01BF         case 4:{
_0x93:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x8B
; 0000 01C0             PORTD &= ~(1<<7);
	CBI  0x12,7
; 0000 01C1             break;
; 0000 01C2         }
; 0000 01C3     };
_0x8B:
; 0000 01C4 }
	ADIW R28,2
	RET
; .FEND
;
;unsigned char calc_distance_time(unsigned char cabin_number, unsigned char floor, unsigned char direction){
; 0000 01C6 unsigned char calc_distance_time(unsigned char cabin_number, unsigned char floor, unsigned char direction){
_calc_distance_time:
; .FSTART _calc_distance_time
; 0000 01C7     unsigned char distance = 0;
; 0000 01C8     unsigned char i = 0;
; 0000 01C9     unsigned char limit_up = 4;
; 0000 01CA     unsigned char limit_down = 0;
; 0000 01CB     if (direction == 'u'){
	ST   -Y,R26
	CALL __SAVELOCR4
;	cabin_number -> Y+6
;	floor -> Y+5
;	direction -> Y+4
;	distance -> R17
;	i -> R16
;	limit_up -> R19
;	limit_down -> R18
	LDI  R17,0
	LDI  R16,0
	LDI  R19,4
	LDI  R18,0
	LDD  R26,Y+4
	CPI  R26,LOW(0x75)
	BREQ PC+2
	RJMP _0x97
; 0000 01CC         if (cabins_states[cabin_number]=='u'){
	RCALL SUBOPT_0x13
	CPI  R26,LOW(0x75)
	BREQ PC+2
	RJMP _0x98
; 0000 01CD             if (floor >= cabins_floors[cabin_number]){
	RCALL SUBOPT_0x14
	LD   R30,Z
	LDD  R26,Y+5
	CP   R26,R30
	BRLO _0x99
; 0000 01CE                 distance = 3*(floor-cabins_floors[cabin_number]);
	RCALL SUBOPT_0x14
	LD   R26,Z
	LDD  R30,Y+5
	RCALL SUBOPT_0x15
; 0000 01CF                 for (i = cabins_floors[cabin_number]+1; i <= floor; i++){
	LD   R30,Z
	SUBI R30,-LOW(1)
	MOV  R16,R30
_0x9B:
	LDD  R30,Y+5
	CP   R30,R16
	BRLO _0x9C
; 0000 01D0                     if (cabins_up_stops[i] == 1)
	RCALL SUBOPT_0x16
	BRNE _0x9D
; 0000 01D1                         distance += 10;
	SUBI R17,-LOW(10)
; 0000 01D2                 }
_0x9D:
	SUBI R16,-1
	RJMP _0x9B
_0x9C:
; 0000 01D3             }
; 0000 01D4             else{
	RJMP _0x9E
_0x99:
; 0000 01D5                 for (i = cabins_floors[cabin_number]; i < 5; i++){
	RCALL SUBOPT_0x14
	LD   R16,Z
_0xA0:
	CPI  R16,5
	BRSH _0xA1
; 0000 01D6                     if (cabins_up_stops[i] == 1)
	RCALL SUBOPT_0x16
	BRNE _0xA2
; 0000 01D7                         limit_up = i;
	MOV  R19,R16
; 0000 01D8                 }
_0xA2:
	SUBI R16,-1
	RJMP _0xA0
_0xA1:
; 0000 01D9                 for (i = cabins_floors[cabin_number]+1; i <= limit_up; i++){
	RCALL SUBOPT_0x14
	LD   R30,Z
	SUBI R30,-LOW(1)
	MOV  R16,R30
_0xA4:
	CP   R19,R16
	BRLO _0xA5
; 0000 01DA                     if (cabins_up_stops[i] == 1)
	RCALL SUBOPT_0x16
	BRNE _0xA6
; 0000 01DB                         distance += 10;
	SUBI R17,-LOW(10)
; 0000 01DC                     distance += 3;
_0xA6:
	SUBI R17,-LOW(3)
; 0000 01DD                 }
	SUBI R16,-1
	RJMP _0xA4
_0xA5:
; 0000 01DE                 for (i = limit_up; i < 255; i--){
	MOV  R16,R19
_0xA8:
	CPI  R16,255
	BRSH _0xA9
; 0000 01DF                     if (cabins_down_stops[i] == 1)
	RCALL SUBOPT_0x17
	BRNE _0xAA
; 0000 01E0                         limit_down = i;
	MOV  R18,R16
; 0000 01E1                 }
_0xAA:
	SUBI R16,1
	RJMP _0xA8
_0xA9:
; 0000 01E2                 for (i = limit_up-1; i >= limit_down && i < 255; i--){
	MOV  R30,R19
	SUBI R30,LOW(1)
	MOV  R16,R30
_0xAC:
	CP   R16,R18
	BRLO _0xAE
	CPI  R16,255
	BRLO _0xAF
_0xAE:
	RJMP _0xAD
_0xAF:
; 0000 01E3                     if (cabins_down_stops[i] == 1)
	RCALL SUBOPT_0x17
	BRNE _0xB0
; 0000 01E4                         distance += 10;
	SUBI R17,-LOW(10)
; 0000 01E5                     distance += 3;
_0xB0:
	SUBI R17,-LOW(3)
; 0000 01E6                 }
	SUBI R16,1
	RJMP _0xAC
_0xAD:
; 0000 01E7                 distance += 3*(floor-limit_down)?limit_down<=floor:3*(limit_down-floor);
	LDD  R26,Y+5
	CLR  R27
	MOV  R30,R18
	RCALL SUBOPT_0x18
	SBIW R30,0
	BREQ _0xB1
	LDD  R30,Y+5
	MOV  R26,R18
	CALL __LEB12U
	RJMP _0xB2
_0xB1:
	MOV  R26,R18
	CLR  R27
	LDD  R30,Y+5
	RCALL SUBOPT_0x18
_0xB2:
	ADD  R17,R30
; 0000 01E8                 distance += 10;
	SUBI R17,-LOW(10)
; 0000 01E9             }
_0x9E:
; 0000 01EA         }
; 0000 01EB         else if (cabins_states[cabin_number]=='d'){
	RJMP _0xB4
_0x98:
	RCALL SUBOPT_0x13
	CPI  R26,LOW(0x64)
	BRNE _0xB5
; 0000 01EC             for (i = cabins_floors[cabin_number]; i < 255; i--){
	RCALL SUBOPT_0x14
	LD   R16,Z
_0xB7:
	CPI  R16,255
	BRSH _0xB8
; 0000 01ED                 if (cabins_down_stops[i] == 1)
	RCALL SUBOPT_0x17
	BRNE _0xB9
; 0000 01EE                     limit_down = i;
	MOV  R18,R16
; 0000 01EF             }
_0xB9:
	SUBI R16,1
	RJMP _0xB7
_0xB8:
; 0000 01F0             for (i = cabins_floors[cabin_number]-1; i >= limit_down && i < 255; i--){
	RCALL SUBOPT_0x14
	LD   R30,Z
	SUBI R30,LOW(1)
	MOV  R16,R30
_0xBB:
	CP   R16,R18
	BRLO _0xBD
	CPI  R16,255
	BRLO _0xBE
_0xBD:
	RJMP _0xBC
_0xBE:
; 0000 01F1                 if (cabins_down_stops[i] == 1)
	RCALL SUBOPT_0x17
	BRNE _0xBF
; 0000 01F2                     distance += 10;
	SUBI R17,-LOW(10)
; 0000 01F3                 distance += 3;
_0xBF:
	SUBI R17,-LOW(3)
; 0000 01F4             }
	SUBI R16,1
	RJMP _0xBB
_0xBC:
; 0000 01F5             if (floor >= limit_down){
	LDD  R26,Y+5
	CP   R26,R18
	BRLO _0xC0
; 0000 01F6                 distance = 3*(floor-limit_down)+10;
	LDD  R30,Y+5
	SUB  R30,R18
	RCALL SUBOPT_0x19
; 0000 01F7                 for (i = limit_down; i <= floor; i++){
	MOV  R16,R18
_0xC2:
	LDD  R30,Y+5
	CP   R30,R16
	BRLO _0xC3
; 0000 01F8                     if (cabins_up_stops[i] == 1)
	RCALL SUBOPT_0x16
	BRNE _0xC4
; 0000 01F9                         distance += 10;
	SUBI R17,-LOW(10)
; 0000 01FA                 }
_0xC4:
	SUBI R16,-1
	RJMP _0xC2
_0xC3:
; 0000 01FB             }
; 0000 01FC             else{
	RJMP _0xC5
_0xC0:
; 0000 01FD                 distance = 3*(limit_down-floor)+10;
	LDD  R26,Y+5
	MOV  R30,R18
	SUB  R30,R26
	RCALL SUBOPT_0x19
; 0000 01FE             }
_0xC5:
; 0000 01FF         }
; 0000 0200         else{
	RJMP _0xC6
_0xB5:
; 0000 0201             if (cabins_floors[cabin_number]<=floor){
	RCALL SUBOPT_0x14
	LD   R26,Z
	LDD  R30,Y+5
	CP   R30,R26
	BRLO _0xC7
; 0000 0202                 distance += 3*(floor-cabins_floors[cabin_number]);
	RCALL SUBOPT_0x14
	LD   R26,Z
	LDD  R30,Y+5
	RJMP _0x158
; 0000 0203             }
; 0000 0204             else{
_0xC7:
; 0000 0205                 distance += 3*(cabins_floors[cabin_number]-floor);
	RCALL SUBOPT_0x14
	LD   R30,Z
	LDD  R26,Y+5
_0x158:
	SUB  R30,R26
	LDI  R26,LOW(3)
	MULS R30,R26
	MOVW R30,R0
	ADD  R17,R30
; 0000 0206             }
; 0000 0207             distance += 10;
	SUBI R17,-LOW(10)
; 0000 0208         }
_0xC6:
_0xB4:
; 0000 0209     }
; 0000 020A     else{
	RJMP _0xC9
_0x97:
; 0000 020B         if (cabins_states[cabin_number]=='d'){
	RCALL SUBOPT_0x13
	CPI  R26,LOW(0x64)
	BREQ PC+2
	RJMP _0xCA
; 0000 020C             if (floor <= cabins_floors[cabin_number]){
	RCALL SUBOPT_0x14
	LD   R30,Z
	LDD  R26,Y+5
	CP   R30,R26
	BRLO _0xCB
; 0000 020D                 distance = 3*(cabins_floors[cabin_number]-floor);
	RCALL SUBOPT_0x14
	LD   R30,Z
	LDD  R26,Y+5
	RCALL SUBOPT_0x15
; 0000 020E                 for (i = cabins_floors[cabin_number]-1; i >= floor && i < 255; i--){
	LD   R30,Z
	SUBI R30,LOW(1)
	MOV  R16,R30
_0xCD:
	LDD  R30,Y+5
	CP   R16,R30
	BRLO _0xCF
	CPI  R16,255
	BRLO _0xD0
_0xCF:
	RJMP _0xCE
_0xD0:
; 0000 020F                     if (cabins_down_stops[i] == 1)
	RCALL SUBOPT_0x17
	BRNE _0xD1
; 0000 0210                         distance += 10;
	SUBI R17,-LOW(10)
; 0000 0211                 }
_0xD1:
	SUBI R16,1
	RJMP _0xCD
_0xCE:
; 0000 0212             }
; 0000 0213             else{
	RJMP _0xD2
_0xCB:
; 0000 0214                 for (i = cabins_floors[cabin_number]; i < 255; i--){
	RCALL SUBOPT_0x14
	LD   R16,Z
_0xD4:
	CPI  R16,255
	BRSH _0xD5
; 0000 0215                     if (cabins_down_stops[i] == 1)
	RCALL SUBOPT_0x17
	BRNE _0xD6
; 0000 0216                         limit_down = i;
	MOV  R18,R16
; 0000 0217                 }
_0xD6:
	SUBI R16,1
	RJMP _0xD4
_0xD5:
; 0000 0218                 for (i = cabins_floors[cabin_number]-1; i >= limit_down && i < 255; i--){
	RCALL SUBOPT_0x14
	LD   R30,Z
	SUBI R30,LOW(1)
	MOV  R16,R30
_0xD8:
	CP   R16,R18
	BRLO _0xDA
	CPI  R16,255
	BRLO _0xDB
_0xDA:
	RJMP _0xD9
_0xDB:
; 0000 0219                     if (cabins_down_stops[i] == 1)
	RCALL SUBOPT_0x17
	BRNE _0xDC
; 0000 021A                         distance += 10;
	SUBI R17,-LOW(10)
; 0000 021B                     distance += 3;
_0xDC:
	SUBI R17,-LOW(3)
; 0000 021C                 }
	SUBI R16,1
	RJMP _0xD8
_0xD9:
; 0000 021D                 for (i = limit_down; i < 5; i++){
	MOV  R16,R18
_0xDE:
	CPI  R16,5
	BRSH _0xDF
; 0000 021E                     if (cabins_up_stops[i] == 1)
	RCALL SUBOPT_0x16
	BRNE _0xE0
; 0000 021F                         limit_up = i;
	MOV  R19,R16
; 0000 0220                 }
_0xE0:
	SUBI R16,-1
	RJMP _0xDE
_0xDF:
; 0000 0221                 for (i = limit_down+1; i <= limit_up; i++){
	MOV  R30,R18
	SUBI R30,-LOW(1)
	MOV  R16,R30
_0xE2:
	CP   R19,R16
	BRLO _0xE3
; 0000 0222                     if (cabins_up_stops[i] == 1)
	RCALL SUBOPT_0x16
	BRNE _0xE4
; 0000 0223                         distance += 10;
	SUBI R17,-LOW(10)
; 0000 0224                     distance += 3;
_0xE4:
	SUBI R17,-LOW(3)
; 0000 0225                 }
	SUBI R16,-1
	RJMP _0xE2
_0xE3:
; 0000 0226                 distance += 3*(floor-limit_up)?limit_up<=floor:3*(limit_up-floor);
	LDD  R26,Y+5
	CLR  R27
	MOV  R30,R19
	RCALL SUBOPT_0x18
	SBIW R30,0
	BREQ _0xE5
	LDD  R30,Y+5
	MOV  R26,R19
	CALL __LEB12U
	RJMP _0xE6
_0xE5:
	MOV  R26,R19
	CLR  R27
	LDD  R30,Y+5
	RCALL SUBOPT_0x18
_0xE6:
	ADD  R17,R30
; 0000 0227                 distance += 10;
	SUBI R17,-LOW(10)
; 0000 0228             }
_0xD2:
; 0000 0229         }
; 0000 022A         else if (cabins_states[cabin_number]=='u'){
	RJMP _0xE8
_0xCA:
	RCALL SUBOPT_0x13
	CPI  R26,LOW(0x75)
	BRNE _0xE9
; 0000 022B             for (i = cabins_floors[cabin_number]; i < 5; i++){
	RCALL SUBOPT_0x14
	LD   R16,Z
_0xEB:
	CPI  R16,5
	BRSH _0xEC
; 0000 022C                 if (cabins_up_stops[i] == 1)
	RCALL SUBOPT_0x16
	BRNE _0xED
; 0000 022D                     limit_up = i;
	MOV  R19,R16
; 0000 022E             }
_0xED:
	SUBI R16,-1
	RJMP _0xEB
_0xEC:
; 0000 022F             for (i = cabins_floors[cabin_number]+1; i <= limit_up; i++){
	RCALL SUBOPT_0x14
	LD   R30,Z
	SUBI R30,-LOW(1)
	MOV  R16,R30
_0xEF:
	CP   R19,R16
	BRLO _0xF0
; 0000 0230                 if (cabins_down_stops[i] == 1)
	RCALL SUBOPT_0x17
	BRNE _0xF1
; 0000 0231                     distance += 10;
	SUBI R17,-LOW(10)
; 0000 0232                 distance += 3;
_0xF1:
	SUBI R17,-LOW(3)
; 0000 0233             }
	SUBI R16,-1
	RJMP _0xEF
_0xF0:
; 0000 0234             if (floor <= limit_up){
	LDD  R26,Y+5
	CP   R19,R26
	BRLO _0xF2
; 0000 0235                 distance = 3*(limit_up-floor)+10;
	MOV  R30,R19
	SUB  R30,R26
	RCALL SUBOPT_0x19
; 0000 0236                 for (i = limit_up; i >= floor && i < 255; i--){
	MOV  R16,R19
_0xF4:
	LDD  R30,Y+5
	CP   R16,R30
	BRLO _0xF6
	CPI  R16,255
	BRLO _0xF7
_0xF6:
	RJMP _0xF5
_0xF7:
; 0000 0237                     if (cabins_down_stops[i] == 1)
	RCALL SUBOPT_0x17
	BRNE _0xF8
; 0000 0238                         distance += 10;
	SUBI R17,-LOW(10)
; 0000 0239                 }
_0xF8:
	SUBI R16,1
	RJMP _0xF4
_0xF5:
; 0000 023A             }
; 0000 023B             else{
	RJMP _0xF9
_0xF2:
; 0000 023C                 distance = 3*(floor-limit_up)+10;
	LDD  R30,Y+5
	SUB  R30,R19
	RCALL SUBOPT_0x19
; 0000 023D             }
_0xF9:
; 0000 023E         }
; 0000 023F         else{
	RJMP _0xFA
_0xE9:
; 0000 0240             if (cabins_floors[cabin_number]<=floor){
	RCALL SUBOPT_0x14
	LD   R26,Z
	LDD  R30,Y+5
	CP   R30,R26
	BRLO _0xFB
; 0000 0241                 distance += 3*(floor-cabins_floors[cabin_number]);
	RCALL SUBOPT_0x14
	LD   R26,Z
	LDD  R30,Y+5
	RJMP _0x159
; 0000 0242             }
; 0000 0243             else{
_0xFB:
; 0000 0244                 distance += 3*(cabins_floors[cabin_number]-floor);
	RCALL SUBOPT_0x14
	LD   R30,Z
	LDD  R26,Y+5
_0x159:
	SUB  R30,R26
	LDI  R26,LOW(3)
	MULS R30,R26
	MOVW R30,R0
	ADD  R17,R30
; 0000 0245             }
; 0000 0246             distance += 10;
	SUBI R17,-LOW(10)
; 0000 0247 
; 0000 0248         }
_0xFA:
_0xE8:
; 0000 0249     }
_0xC9:
; 0000 024A     //LCD_Char(cabin_number);
; 0000 024B     //LCD_Char(' ');
; 0000 024C     //LCD_Char('0'+distance);
; 0000 024D     return distance;
	MOV  R30,R17
	CALL __LOADLOCR4
	ADIW R28,7
	RET
; 0000 024E }
; .FEND
;
;
;void check_out_buttons(){
; 0000 0251 void check_out_buttons(){
_check_out_buttons:
; .FSTART _check_out_buttons
; 0000 0252     unsigned char cabin0_dist = 0;
; 0000 0253     unsigned char cabin1_dist = 0;
; 0000 0254     if (PINC & (1<<0)){
	ST   -Y,R17
	ST   -Y,R16
;	cabin0_dist -> R17
;	cabin1_dist -> R16
	LDI  R17,0
	LDI  R16,0
	SBIS 0x13,0
	RJMP _0xFD
; 0000 0255         // up for zero
; 0000 0256         cabin0_dist = calc_distance_time(0, 0, 'u');
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1A
	MOV  R17,R30
; 0000 0257         cabin1_dist = calc_distance_time(1, 0, 'u');
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1A
	MOV  R16,R30
; 0000 0258         if (cabin1_dist < cabin0_dist){
	CP   R16,R17
	BRSH _0xFE
; 0000 0259             cabins_up_stops[1][0] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_up_stops,5
; 0000 025A         }
; 0000 025B         else{
	RJMP _0xFF
_0xFE:
; 0000 025C             cabins_up_stops[0][0] = 1;
	LDI  R30,LOW(1)
	STS  _cabins_up_stops,R30
; 0000 025D         }
_0xFF:
; 0000 025E         PORTD = PORTD | (1<<0);
	SBI  0x12,0
; 0000 025F     }
; 0000 0260     if (PINC & (1<<1)){
_0xFD:
	SBIS 0x13,1
	RJMP _0x100
; 0000 0261         // up for one
; 0000 0262         cabin0_dist = calc_distance_time(0, 1, 'u');
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1B
	MOV  R17,R30
; 0000 0263         cabin1_dist = calc_distance_time(1, 1, 'u');
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1B
	MOV  R16,R30
; 0000 0264         if (cabin1_dist < cabin0_dist){
	CP   R16,R17
	BRSH _0x101
; 0000 0265             cabins_up_stops[1][1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_up_stops,6
; 0000 0266         }
; 0000 0267         else{
	RJMP _0x102
_0x101:
; 0000 0268             cabins_up_stops[0][1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_up_stops,1
; 0000 0269         }
_0x102:
; 0000 026A         PORTD = PORTD | (1<<1);
	SBI  0x12,1
; 0000 026B     }
; 0000 026C     if (PINC & (1<<2)){
_0x100:
	SBIS 0x13,2
	RJMP _0x103
; 0000 026D         // down for one
; 0000 026E         cabin0_dist = calc_distance_time(0, 1, 'd');
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1C
	MOV  R17,R30
; 0000 026F         cabin1_dist = calc_distance_time(1, 1, 'd');
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1C
	MOV  R16,R30
; 0000 0270         if (cabin1_dist < cabin0_dist){
	CP   R16,R17
	BRSH _0x104
; 0000 0271             cabins_down_stops[1][1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,6
; 0000 0272         }
; 0000 0273         else{
	RJMP _0x105
_0x104:
; 0000 0274             cabins_down_stops[0][1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,1
; 0000 0275         }
_0x105:
; 0000 0276         PORTD = PORTD | (1<<2);
	SBI  0x12,2
; 0000 0277     }
; 0000 0278     if (PINC & (1<<3)){
_0x103:
	SBIS 0x13,3
	RJMP _0x106
; 0000 0279         // up for two
; 0000 027A         cabin0_dist = calc_distance_time(0, 2, 'u');
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1D
	MOV  R17,R30
; 0000 027B         cabin1_dist = calc_distance_time(1, 2, 'u');
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1D
	MOV  R16,R30
; 0000 027C         if (cabin1_dist < cabin0_dist){
	CP   R16,R17
	BRSH _0x107
; 0000 027D             cabins_up_stops[1][2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_up_stops,7
; 0000 027E         }
; 0000 027F         else{
	RJMP _0x108
_0x107:
; 0000 0280             cabins_up_stops[0][2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_up_stops,2
; 0000 0281         }
_0x108:
; 0000 0282         PORTD = PORTD | (1<<3);
	SBI  0x12,3
; 0000 0283     }
; 0000 0284     if (PINC & (1<<4)){
_0x106:
	SBIS 0x13,4
	RJMP _0x109
; 0000 0285         // down for two
; 0000 0286         cabin0_dist = calc_distance_time(0, 2, 'd');
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1E
	MOV  R17,R30
; 0000 0287         cabin1_dist = calc_distance_time(1, 2, 'd');
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1E
	MOV  R16,R30
; 0000 0288         if (cabin1_dist < cabin0_dist){
	CP   R16,R17
	BRSH _0x10A
; 0000 0289             cabins_down_stops[1][2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,7
; 0000 028A         }
; 0000 028B         else{
	RJMP _0x10B
_0x10A:
; 0000 028C             cabins_down_stops[0][2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,2
; 0000 028D         }
_0x10B:
; 0000 028E         PORTD = PORTD | (1<<4);
	SBI  0x12,4
; 0000 028F     }
; 0000 0290     if (PINC & (1<<5)){
_0x109:
	SBIS 0x13,5
	RJMP _0x10C
; 0000 0291         // up for three
; 0000 0292         cabin0_dist = calc_distance_time(0, 3, 'u');
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1F
	MOV  R17,R30
; 0000 0293         cabin1_dist = calc_distance_time(1, 3, 'u');
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1F
	MOV  R16,R30
; 0000 0294         if (cabin1_dist < cabin0_dist){
	CP   R16,R17
	BRSH _0x10D
; 0000 0295             cabins_up_stops[1][3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_up_stops,8
; 0000 0296         }
; 0000 0297         else{
	RJMP _0x10E
_0x10D:
; 0000 0298             cabins_up_stops[0][3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_up_stops,3
; 0000 0299         }
_0x10E:
; 0000 029A         PORTD = PORTD | (1<<5);
	SBI  0x12,5
; 0000 029B     }
; 0000 029C     if (PINC & (1<<6)){
_0x10C:
	SBIS 0x13,6
	RJMP _0x10F
; 0000 029D         // down for three
; 0000 029E         cabin0_dist = calc_distance_time(0, 3, 'd');
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x20
	MOV  R17,R30
; 0000 029F         cabin1_dist = calc_distance_time(1, 3, 'd');
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x20
	MOV  R16,R30
; 0000 02A0         if (cabin1_dist < cabin0_dist){
	CP   R16,R17
	BRSH _0x110
; 0000 02A1             cabins_down_stops[1][3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,8
; 0000 02A2         }
; 0000 02A3         else{
	RJMP _0x111
_0x110:
; 0000 02A4             cabins_down_stops[0][3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,3
; 0000 02A5         }
_0x111:
; 0000 02A6         PORTD = PORTD | (1<<6);
	SBI  0x12,6
; 0000 02A7     }
; 0000 02A8     if (PINC & (1<<7)){
_0x10F:
	SBIS 0x13,7
	RJMP _0x112
; 0000 02A9         // down for four
; 0000 02AA         cabin0_dist = calc_distance_time(0, 4, 'd');
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x21
	MOV  R17,R30
; 0000 02AB         cabin1_dist = calc_distance_time(1, 4, 'd');
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x21
	MOV  R16,R30
; 0000 02AC         if (cabin1_dist < cabin0_dist){
	CP   R16,R17
	BRSH _0x113
; 0000 02AD             cabins_down_stops[1][4] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,9
; 0000 02AE         }
; 0000 02AF         else{
	RJMP _0x114
_0x113:
; 0000 02B0             cabins_down_stops[0][4] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,4
; 0000 02B1         }
_0x114:
; 0000 02B2         PORTD = PORTD | (1<<7);
	SBI  0x12,7
; 0000 02B3     }
; 0000 02B4 
; 0000 02B5 }
_0x112:
	RJMP _0x2000001
; .FEND
;
;void check_in_buttons(){
; 0000 02B7 void check_in_buttons(){
_check_in_buttons:
; .FSTART _check_in_buttons
; 0000 02B8     if (PINB & (1<<0)){
	SBIS 0x16,0
	RJMP _0x115
; 0000 02B9         cabins_down_stops[0][0] = 1;
	LDI  R30,LOW(1)
	STS  _cabins_down_stops,R30
; 0000 02BA     }
; 0000 02BB     if (PINB & (1<<1)){
_0x115:
	SBIS 0x16,1
	RJMP _0x116
; 0000 02BC         if (cabins_floors[0] > 1)
	LDS  R26,_cabins_floors
	CPI  R26,LOW(0x2)
	BRLO _0x117
; 0000 02BD             cabins_down_stops[0][1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,1
; 0000 02BE         else
	RJMP _0x118
_0x117:
; 0000 02BF             cabins_up_stops[0][1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_up_stops,1
; 0000 02C0     }
_0x118:
; 0000 02C1     if (PINB & (1<<2)){
_0x116:
	SBIS 0x16,2
	RJMP _0x119
; 0000 02C2         if (cabins_floors[0] > 2)
	LDS  R26,_cabins_floors
	CPI  R26,LOW(0x3)
	BRLO _0x11A
; 0000 02C3             cabins_down_stops[0][2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,2
; 0000 02C4         else
	RJMP _0x11B
_0x11A:
; 0000 02C5             cabins_up_stops[0][2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_up_stops,2
; 0000 02C6     }
_0x11B:
; 0000 02C7     if (PINB & (1<<3)){
_0x119:
	SBIS 0x16,3
	RJMP _0x11C
; 0000 02C8         if (cabins_floors[0] > 3)
	LDS  R26,_cabins_floors
	CPI  R26,LOW(0x4)
	BRLO _0x11D
; 0000 02C9             cabins_down_stops[0][3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,3
; 0000 02CA         else
	RJMP _0x11E
_0x11D:
; 0000 02CB             cabins_up_stops[0][3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_up_stops,3
; 0000 02CC     }
_0x11E:
; 0000 02CD     if (PINB & (1<<4)){
_0x11C:
	SBIS 0x16,4
	RJMP _0x11F
; 0000 02CE         cabins_down_stops[0][4] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,4
; 0000 02CF     }
; 0000 02D0     if (PINB & (1<<5)){
_0x11F:
	SBIS 0x16,5
	RJMP _0x120
; 0000 02D1         cabins_down_stops[1][0] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,5
; 0000 02D2     }
; 0000 02D3     if (PINB & (1<<6)){
_0x120:
	SBIS 0x16,6
	RJMP _0x121
; 0000 02D4         if (cabins_floors[1] > 1)
	__GETB2MN _cabins_floors,1
	CPI  R26,LOW(0x2)
	BRLO _0x122
; 0000 02D5             cabins_down_stops[1][1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,6
; 0000 02D6         else
	RJMP _0x123
_0x122:
; 0000 02D7             cabins_up_stops[1][1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_up_stops,6
; 0000 02D8     }
_0x123:
; 0000 02D9     if (PINB & (1<<7)){
_0x121:
	SBIS 0x16,7
	RJMP _0x124
; 0000 02DA         if (cabins_floors[1] > 2)
	__GETB2MN _cabins_floors,1
	CPI  R26,LOW(0x3)
	BRLO _0x125
; 0000 02DB             cabins_down_stops[1][2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,7
; 0000 02DC         else
	RJMP _0x126
_0x125:
; 0000 02DD             cabins_up_stops[1][2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_up_stops,7
; 0000 02DE     }
_0x126:
; 0000 02DF     if (PINA & (1<<0)){
_0x124:
	SBIS 0x19,0
	RJMP _0x127
; 0000 02E0         if (cabins_floors[1] > 3)
	__GETB2MN _cabins_floors,1
	CPI  R26,LOW(0x4)
	BRLO _0x128
; 0000 02E1             cabins_down_stops[1][3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,8
; 0000 02E2         else
	RJMP _0x129
_0x128:
; 0000 02E3             cabins_up_stops[1][3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_up_stops,8
; 0000 02E4     }
_0x129:
; 0000 02E5     if (PINA & (1<<1)){
_0x127:
	SBIS 0x19,1
	RJMP _0x12A
; 0000 02E6         cabins_down_stops[1][4] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _cabins_down_stops,9
; 0000 02E7     }
; 0000 02E8 }
_0x12A:
	RET
; .FEND
;
;void update_lcd(){
; 0000 02EA void update_lcd(){
_update_lcd:
; .FSTART _update_lcd
; 0000 02EB     unsigned char string[2][17];
; 0000 02EC     string[0][0] = 'F';
	SBIW R28,34
;	string -> Y+0
	LDI  R30,LOW(70)
	ST   Y,R30
; 0000 02ED     string[0][1] = 'l';
	LDI  R30,LOW(108)
	STD  Y+1,R30
; 0000 02EE     string[0][2] = 'o';
	LDI  R30,LOW(111)
	STD  Y+2,R30
; 0000 02EF     string[0][3] = 'o';
	STD  Y+3,R30
; 0000 02F0     string[0][4] = 'r';
	LDI  R30,LOW(114)
	STD  Y+4,R30
; 0000 02F1     string[0][5] = ':';
	LDI  R30,LOW(58)
	STD  Y+5,R30
; 0000 02F2     string[0][6] = '0'+cabins_floors[0];
	LDS  R30,_cabins_floors
	SUBI R30,-LOW(48)
	STD  Y+6,R30
; 0000 02F3     string[0][7] = ' ';
	LDI  R30,LOW(32)
	STD  Y+7,R30
; 0000 02F4     string[0][8] = ' ';
	STD  Y+8,R30
; 0000 02F5     string[0][9] = ' ';
	STD  Y+9,R30
; 0000 02F6     string[0][10] = 'D';
	LDI  R30,LOW(68)
	STD  Y+10,R30
; 0000 02F7     string[0][11] = 'i';
	LDI  R30,LOW(105)
	STD  Y+11,R30
; 0000 02F8     string[0][12] = 'r';
	LDI  R30,LOW(114)
	STD  Y+12,R30
; 0000 02F9     string[0][13] = ':';
	LDI  R30,LOW(58)
	STD  Y+13,R30
; 0000 02FA     if (cabins_states[0]=='u')
	LDS  R26,_cabins_states
	CPI  R26,LOW(0x75)
	BRNE _0x12B
; 0000 02FB         string[0][14] = 'U';
	LDI  R30,LOW(85)
	RJMP _0x15A
; 0000 02FC     else if (cabins_states[0]=='d')
_0x12B:
	LDS  R26,_cabins_states
	CPI  R26,LOW(0x64)
	BRNE _0x12D
; 0000 02FD         string[0][14] = 'D';
	LDI  R30,LOW(68)
	RJMP _0x15A
; 0000 02FE     else
_0x12D:
; 0000 02FF         string[0][14] = 'S';
	LDI  R30,LOW(83)
_0x15A:
	STD  Y+14,R30
; 0000 0300     if (threshold[0] == 10 && cabins_states[0] != 's'){
	LDS  R26,_threshold
	CPI  R26,LOW(0xA)
	BRNE _0x130
	LDS  R26,_cabins_states
	CPI  R26,LOW(0x73)
	BRNE _0x131
_0x130:
	RJMP _0x12F
_0x131:
; 0000 0301         string[0][15] = '*';
	LDI  R30,LOW(42)
	RJMP _0x15B
; 0000 0302     }
; 0000 0303     else{
_0x12F:
; 0000 0304         string[0][15] = ' ';
	LDI  R30,LOW(32)
_0x15B:
	STD  Y+15,R30
; 0000 0305     }
; 0000 0306     string[0][16] = '\0';
	LDI  R30,LOW(0)
	STD  Y+16,R30
; 0000 0307 
; 0000 0308 
; 0000 0309     string[1][0] = 'F';
	LDI  R30,LOW(70)
	STD  Y+17,R30
; 0000 030A     string[1][1] = 'l';
	MOVW R30,R28
	ADIW R30,18
	LDI  R26,LOW(108)
	STD  Z+0,R26
; 0000 030B     string[1][2] = 'o';
	MOVW R30,R28
	ADIW R30,19
	LDI  R26,LOW(111)
	STD  Z+0,R26
; 0000 030C     string[1][3] = 'o';
	MOVW R30,R28
	ADIW R30,20
	STD  Z+0,R26
; 0000 030D     string[1][4] = 'r';
	MOVW R30,R28
	ADIW R30,21
	LDI  R26,LOW(114)
	STD  Z+0,R26
; 0000 030E     string[1][5] = ':';
	MOVW R30,R28
	ADIW R30,22
	LDI  R26,LOW(58)
	STD  Z+0,R26
; 0000 030F     string[1][6] = '0'+cabins_floors[1];
	__GETB1MN _cabins_floors,1
	SUBI R30,-LOW(48)
	STD  Y+23,R30
; 0000 0310     string[1][7] = ' ';
	MOVW R30,R28
	ADIW R30,24
	LDI  R26,LOW(32)
	STD  Z+0,R26
; 0000 0311     string[1][8] = ' ';
	MOVW R30,R28
	ADIW R30,25
	STD  Z+0,R26
; 0000 0312     string[1][9] = ' ';
	MOVW R30,R28
	ADIW R30,26
	STD  Z+0,R26
; 0000 0313     string[1][10] = 'D';
	MOVW R30,R28
	ADIW R30,27
	LDI  R26,LOW(68)
	STD  Z+0,R26
; 0000 0314     string[1][11] = 'i';
	MOVW R30,R28
	ADIW R30,28
	LDI  R26,LOW(105)
	STD  Z+0,R26
; 0000 0315     string[1][12] = 'r';
	MOVW R30,R28
	ADIW R30,29
	LDI  R26,LOW(114)
	STD  Z+0,R26
; 0000 0316     string[1][13] = ':';
	MOVW R30,R28
	ADIW R30,30
	LDI  R26,LOW(58)
	STD  Z+0,R26
; 0000 0317     if (cabins_states[1]=='u')
	__GETB2MN _cabins_states,1
	CPI  R26,LOW(0x75)
	BRNE _0x133
; 0000 0318         string[1][14] = 'U';
	MOVW R30,R28
	ADIW R30,31
	LDI  R26,LOW(85)
	RJMP _0x15C
; 0000 0319     else if (cabins_states[1]=='d')
_0x133:
	__GETB2MN _cabins_states,1
	CPI  R26,LOW(0x64)
	BRNE _0x135
; 0000 031A         string[1][14] = 'D';
	MOVW R30,R28
	ADIW R30,31
	LDI  R26,LOW(68)
	RJMP _0x15C
; 0000 031B     else
_0x135:
; 0000 031C         string[1][14] = 'S';
	MOVW R30,R28
	ADIW R30,31
	LDI  R26,LOW(83)
_0x15C:
	STD  Z+0,R26
; 0000 031D     if (threshold[1] == 10 && cabins_states[1] != 's'){
	__GETB2MN _threshold,1
	CPI  R26,LOW(0xA)
	BRNE _0x138
	__GETB2MN _cabins_states,1
	CPI  R26,LOW(0x73)
	BRNE _0x139
_0x138:
	RJMP _0x137
_0x139:
; 0000 031E         string[1][15] = '*';
	MOVW R30,R28
	ADIW R30,32
	LDI  R26,LOW(42)
	RJMP _0x15D
; 0000 031F     }
; 0000 0320     else{
_0x137:
; 0000 0321         string[1][15] = ' ';
	MOVW R30,R28
	ADIW R30,32
	LDI  R26,LOW(32)
_0x15D:
	STD  Z+0,R26
; 0000 0322     }string[1][16] = '\0';
	MOVW R30,R28
	ADIW R30,33
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0323 
; 0000 0324     LCD_String_xy(0, 0, string[0]);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	RCALL _LCD_String_xy
; 0000 0325     LCD_String_xy(1, 0, string[1]);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,19
	RCALL _LCD_String_xy
; 0000 0326 }
	ADIW R28,34
	RET
; .FEND
;
;
;void move_cabin_states(){
; 0000 0329 void move_cabin_states(){
_move_cabin_states:
; .FSTART _move_cabin_states
; 0000 032A     unsigned char i = 0;
; 0000 032B     unsigned char j = 0;
; 0000 032C     for (i=0; i<2; i++){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	j -> R16
	LDI  R17,0
	LDI  R16,0
	LDI  R17,LOW(0)
_0x13C:
	CPI  R17,2
	BRLO PC+2
	RJMP _0x13D
; 0000 032D         if (cabins_states[i] == 's'){
	RCALL SUBOPT_0x22
	LD   R26,Z
	CPI  R26,LOW(0x73)
	BREQ PC+2
	RJMP _0x13E
; 0000 032E             for (j = 0; j < 5; j++){
	LDI  R16,LOW(0)
_0x140:
	CPI  R16,5
	BRLO PC+2
	RJMP _0x141
; 0000 032F                 if (cabins_up_stops[i][j] == 1 | cabins_down_stops[i][j] == 1){
	RCALL SUBOPT_0x23
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R22,R30
	MOVW R26,R0
	SUBI R26,LOW(-_cabins_down_stops)
	SBCI R27,HIGH(-_cabins_down_stops)
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	LD   R26,X
	LDI  R30,LOW(1)
	CALL __EQB12
	OR   R30,R22
	BREQ _0x142
; 0000 0330                     if (j > cabins_floors[i]) {
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_cabins_floors)
	SBCI R31,HIGH(-_cabins_floors)
	LD   R30,Z
	CP   R30,R16
	BRSH _0x143
; 0000 0331                         cabins_states[i] = 'u';
	RCALL SUBOPT_0x22
	LDI  R26,LOW(117)
	RCALL SUBOPT_0x24
; 0000 0332                         threshold[i] = 3;
	RJMP _0x15E
; 0000 0333                     }
; 0000 0334                     else if (j < cabins_floors[i]){
_0x143:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_cabins_floors)
	SBCI R31,HIGH(-_cabins_floors)
	LD   R30,Z
	CP   R16,R30
	BRSH _0x145
; 0000 0335                         cabins_states[i] = 'd';
	RCALL SUBOPT_0x22
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x24
; 0000 0336                         threshold[i] = 3;
	RJMP _0x15E
; 0000 0337                     }
; 0000 0338                     else{
_0x145:
; 0000 0339                         threshold[i] = 10;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_threshold)
	SBCI R31,HIGH(-_threshold)
	LDI  R26,LOW(10)
	STD  Z+0,R26
; 0000 033A                         if (cabins_up_stops[i][j] == 1){
	RCALL SUBOPT_0x23
	CPI  R26,LOW(0x1)
	BRNE _0x147
; 0000 033B                             cabins_states[i] = 'u';
	RCALL SUBOPT_0x22
	LDI  R26,LOW(117)
	RJMP _0x15E
; 0000 033C                         }
; 0000 033D                         else{
_0x147:
; 0000 033E                             cabins_states[i] = 'd';
	RCALL SUBOPT_0x22
	LDI  R26,LOW(100)
_0x15E:
	STD  Z+0,R26
; 0000 033F                         }
; 0000 0340                     }
; 0000 0341                     //TODO timer 3 seconds
; 0000 0342                     if (i == 0){
	CPI  R17,0
	BRNE _0x149
; 0000 0343                         //timer0
; 0000 0344                         //PORTD = PORTD | (1<<0);
; 0000 0345                         //threshold[0] = 3;
; 0000 0346                         TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 0347                         TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 0348                     }
; 0000 0349                     else{
	RJMP _0x14A
_0x149:
; 0000 034A                         //timer2
; 0000 034B                         //threshold[1] = 3;
; 0000 034C                         TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (1<<CS21) | (0<<CS20);
	LDI  R30,LOW(6)
	OUT  0x25,R30
; 0000 034D                         TCNT2=0x83;
	LDI  R30,LOW(131)
	OUT  0x24,R30
; 0000 034E                     }
_0x14A:
; 0000 034F                 }
; 0000 0350             }
_0x142:
	SUBI R16,-1
	RJMP _0x140
_0x141:
; 0000 0351         }
; 0000 0352     }
_0x13E:
	SUBI R17,-1
	RJMP _0x13C
_0x13D:
; 0000 0353 }
_0x2000001:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;
;void main(void)
; 0000 0357 {
_main:
; .FSTART _main
; 0000 0358 // Declare your local variables here
; 0000 0359 
; 0000 035A // Input/Output Ports initialization
; 0000 035B // Port A initialization
; 0000 035C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 035D DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 035E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 035F PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0360 
; 0000 0361 // Port B initialization
; 0000 0362 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0363 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0364 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0365 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0366 
; 0000 0367 // Port C initialization
; 0000 0368 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0369 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 036A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 036B PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 036C 
; 0000 036D // Port D initialization
; 0000 036E // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 036F DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0370 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0371 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0372 
; 0000 0373 // Timer/Counter 0 initialization
; 0000 0374 // Clock source: System Clock
; 0000 0375 // Clock value: Timer 0 Stopped
; 0000 0376 // Mode: Normal top=0xFF
; 0000 0377 // OC0 output: Disconnected
; 0000 0378 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0379 TCNT0=0x00;
	OUT  0x32,R30
; 0000 037A OCR0=0x00;
	OUT  0x3C,R30
; 0000 037B 
; 0000 037C // Timer/Counter 1 initialization
; 0000 037D // Clock source: System Clock
; 0000 037E // Clock value: Timer1 Stopped
; 0000 037F // Mode: Normal top=0xFFFF
; 0000 0380 // OC1A output: Disconnected
; 0000 0381 // OC1B output: Disconnected
; 0000 0382 // Noise Canceler: Off
; 0000 0383 // Input Capture on Falling Edge
; 0000 0384 // Timer1 Overflow Interrupt: Off
; 0000 0385 // Input Capture Interrupt: Off
; 0000 0386 // Compare A Match Interrupt: Off
; 0000 0387 // Compare B Match Interrupt: Off
; 0000 0388 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0389 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 038A TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 038B TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 038C ICR1H=0x00;
	OUT  0x27,R30
; 0000 038D ICR1L=0x00;
	OUT  0x26,R30
; 0000 038E OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 038F OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0390 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0391 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0392 
; 0000 0393 // Timer/Counter 2 initialization
; 0000 0394 // Clock source: System Clock
; 0000 0395 // Clock value: Timer2 Stopped
; 0000 0396 // Mode: Normal top=0xFF
; 0000 0397 // OC2 output: Disconnected
; 0000 0398 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0399 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 039A TCNT2=0x00;
	OUT  0x24,R30
; 0000 039B OCR2=0x00;
	OUT  0x23,R30
; 0000 039C 
; 0000 039D // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 039E TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 039F 
; 0000 03A0 // External Interrupt(s) initialization
; 0000 03A1 // INT0: Off
; 0000 03A2 // INT1: Off
; 0000 03A3 // INT2: Off
; 0000 03A4 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 03A5 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 03A6 
; 0000 03A7 // USART initialization
; 0000 03A8 // USART disabled
; 0000 03A9 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 03AA 
; 0000 03AB // Analog Comparator initialization
; 0000 03AC // Analog Comparator: Off
; 0000 03AD // The Analog Comparator's positive input is
; 0000 03AE // connected to the AIN0 pin
; 0000 03AF // The Analog Comparator's negative input is
; 0000 03B0 // connected to the AIN1 pin
; 0000 03B1 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 03B2 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 03B3 
; 0000 03B4 // ADC initialization
; 0000 03B5 // ADC disabled
; 0000 03B6 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 03B7 
; 0000 03B8 // SPI initialization
; 0000 03B9 // SPI disabled
; 0000 03BA SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 03BB 
; 0000 03BC // TWI initialization
; 0000 03BD // TWI disabled
; 0000 03BE TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 03BF 
; 0000 03C0 // Global enable interrupts
; 0000 03C1 #asm("sei")
	sei
; 0000 03C2 
; 0000 03C3 // PortD: LEDs for up and down
; 0000 03C4 // up for 0
; 0000 03C5 DDRD = DDRD | ( 1<<0);
	SBI  0x11,0
; 0000 03C6 // up for 1
; 0000 03C7 DDRD = DDRD | ( 1<<1);
	SBI  0x11,1
; 0000 03C8 // down for 1
; 0000 03C9 DDRD = DDRD | ( 1<<2);
	SBI  0x11,2
; 0000 03CA // up for 2
; 0000 03CB DDRD = DDRD | ( 1<<3);
	SBI  0x11,3
; 0000 03CC // down for 2
; 0000 03CD DDRD = DDRD | ( 1<<4);
	SBI  0x11,4
; 0000 03CE // up for 3
; 0000 03CF DDRD = DDRD | ( 1<<5);
	SBI  0x11,5
; 0000 03D0 // down for 3
; 0000 03D1 DDRD = DDRD | ( 1<<6);
	SBI  0x11,6
; 0000 03D2 // up for 4
; 0000 03D3 DDRD = DDRD | ( 1<<7);
	SBI  0x11,7
; 0000 03D4 
; 0000 03D5 // PortC: Buttons for up and down
; 0000 03D6 // up for 0
; 0000 03D7 DDRC = DDRC & ~(1<<0);
	CBI  0x14,0
; 0000 03D8 // up for 1
; 0000 03D9 DDRC = DDRC & ~(1<<1);
	CBI  0x14,1
; 0000 03DA // down for 1
; 0000 03DB DDRC = DDRC & ~(1<<2);
	CBI  0x14,2
; 0000 03DC // up for 2
; 0000 03DD DDRC = DDRC & ~(1<<3);
	CBI  0x14,3
; 0000 03DE // down for 2
; 0000 03DF DDRC = DDRC & ~(1<<4);
	CBI  0x14,4
; 0000 03E0 // up for 3
; 0000 03E1 DDRC = DDRC & ~(1<<5);
	CBI  0x14,5
; 0000 03E2 // down for 3
; 0000 03E3 DDRC = DDRC & ~(1<<6);
	CBI  0x14,6
; 0000 03E4 // down for 4
; 0000 03E5 DDRC = DDRC & ~(1<<7);
	CBI  0x14,7
; 0000 03E6 
; 0000 03E7 // PortB and PortA: Buttons in Cabins
; 0000 03E8 // Cab1, Floor0
; 0000 03E9 DDRB = DDRB & ~(1<<0);
	CBI  0x17,0
; 0000 03EA // Cab1, Floor1
; 0000 03EB DDRB = DDRB & ~(1<<1);
	CBI  0x17,1
; 0000 03EC // Cab1, Floor2
; 0000 03ED DDRB = DDRB & ~(1<<2);
	CBI  0x17,2
; 0000 03EE // Cab1, Floor3
; 0000 03EF DDRB = DDRB & ~(1<<3);
	CBI  0x17,3
; 0000 03F0 // Cab1, Floor4
; 0000 03F1 DDRB = DDRB & ~(1<<4);
	CBI  0x17,4
; 0000 03F2 
; 0000 03F3 // Cab2, Floor0
; 0000 03F4 DDRB = DDRB & ~(1<<5);
	CBI  0x17,5
; 0000 03F5 // Cab2, Floor1
; 0000 03F6 DDRB = DDRB & ~(1<<6);
	CBI  0x17,6
; 0000 03F7 // Cab2, Floor2
; 0000 03F8 DDRB = DDRB & ~(1<<7);
	CBI  0x17,7
; 0000 03F9 // Cab2, Floor3
; 0000 03FA DDRA = DDRA & ~(1<<0);
	CBI  0x1A,0
; 0000 03FB // Cab2, Floor4
; 0000 03FC DDRA = DDRA & ~(1<<1);
	CBI  0x1A,1
; 0000 03FD 
; 0000 03FE LCD_Init();
	RCALL _LCD_Init
; 0000 03FF LCD_Clear();
	RCALL _LCD_Clear
; 0000 0400 cabins_states[0] = 's';
	LDI  R30,LOW(115)
	STS  _cabins_states,R30
; 0000 0401 cabins_states[1] = 's';
	__PUTB1MN _cabins_states,1
; 0000 0402 while (1)
_0x14B:
; 0000 0403       {
; 0000 0404       // Place your code here
; 0000 0405        check_out_buttons();
	RCALL _check_out_buttons
; 0000 0406        check_in_buttons();
	RCALL _check_in_buttons
; 0000 0407        move_cabin_states();
	RCALL _move_cabin_states
; 0000 0408        update_lcd();
	RCALL _update_lcd
; 0000 0409       }
	RJMP _0x14B
; 0000 040A }
_0x14E:
	RJMP _0x14E
; .FEND

	.DSEG
_cabins_states:
	.BYTE 0x2
_cabins_floors:
	.BYTE 0x2
_cabins_up_stops:
	.BYTE 0xA
_cabins_down_stops:
	.BYTE 0xA
_threshold:
	.BYTE 0x2
_flag:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x0:
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
	ST   -Y,R17
	LDI  R17,0
	LDI  R30,LOW(131)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R31,0
	SUBI R30,LOW(-_cabins_up_stops)
	SBCI R31,HIGH(-_cabins_up_stops)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_cabins_up_stops)
	SBCI R31,HIGH(-_cabins_up_stops)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1)
	STS  _flag,R30
	LDS  R30,_cabins_floors
	SUBI R30,-LOW(1)
	STS  _cabins_floors,R30
	LDS  R26,_cabins_floors
	CP   R17,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	ST   -Y,R17
	LDI  R26,LOW(117)
	RCALL _off_LED
	MOV  R30,R17
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_cabins_down_stops)
	SBCI R31,HIGH(-_cabins_down_stops)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ST   -Y,R17
	LDI  R26,LOW(100)
	RCALL _off_LED
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	OUT  0x33,R30
	OUT  0x32,R30
	LDI  R30,LOW(115)
	STS  _cabins_states,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(1)
	STS  _flag,R30
	LDS  R30,_cabins_floors
	SUBI R30,LOW(1)
	STS  _cabins_floors,R30
	LDS  R26,_cabins_floors
	CP   R17,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(3)
	STS  _threshold,R30
	LDI  R30,LOW(1)
	STS  _flag,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	__GETB1MN _cabins_floors,1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
	__GETB1MN _cabins_floors,1
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xB:
	__POINTW2MN _cabins_up_stops,5
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1)
	__PUTB1MN _flag,1
	__GETB1MN _cabins_floors,1
	SUBI R30,-LOW(1)
	__PUTB1MN _cabins_floors,1
	__GETB2MN _cabins_floors,1
	CP   R17,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xD:
	__POINTW2MN _cabins_down_stops,5
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	OUT  0x25,R30
	OUT  0x24,R30
	LDI  R30,LOW(115)
	__PUTB1MN _cabins_states,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	__GETB1MN _cabins_floors,1
	SUBI R30,LOW(1)
	__PUTB1MN _cabins_floors,1
	__GETB2MN _cabins_floors,1
	CP   R17,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(3)
	__PUTB1MN _threshold,1
	LDI  R30,LOW(1)
	__PUTB1MN _flag,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(2)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	LDD  R30,Y+6
	LDI  R31,0
	SUBI R30,LOW(-_cabins_states)
	SBCI R31,HIGH(-_cabins_states)
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x14:
	LDD  R30,Y+6
	LDI  R31,0
	SUBI R30,LOW(-_cabins_floors)
	SBCI R31,HIGH(-_cabins_floors)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	SUB  R30,R26
	LDI  R26,LOW(3)
	MULS R30,R26
	MOV  R17,R0
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(5)
	MUL  R16,R26
	MOVW R30,R0
	SUBI R30,LOW(-_cabins_up_stops)
	SBCI R31,HIGH(-_cabins_up_stops)
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(5)
	MUL  R16,R26
	MOVW R30,R0
	SUBI R30,LOW(-_cabins_down_stops)
	SBCI R31,HIGH(-_cabins_down_stops)
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x18:
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(3)
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(10)
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(117)
	RJMP _calc_distance_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(117)
	RJMP _calc_distance_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(100)
	RJMP _calc_distance_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(117)
	RJMP _calc_distance_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(100)
	RJMP _calc_distance_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(117)
	RJMP _calc_distance_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(100)
	RJMP _calc_distance_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(100)
	RJMP _calc_distance_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_cabins_states)
	SBCI R31,HIGH(-_cabins_states)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(5)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_cabins_up_stops)
	SBCI R31,HIGH(-_cabins_up_stops)
	MOVW R26,R30
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	STD  Z+0,R26
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_threshold)
	SBCI R31,HIGH(-_threshold)
	LDI  R26,LOW(3)
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

__LEB12U:
	CP   R30,R26
	LDI  R30,1
	BRSH __LEB12U1
	CLR  R30
__LEB12U1:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
