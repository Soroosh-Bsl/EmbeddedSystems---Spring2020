
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
	.DEF _i=R5
	.DEF _j=R4
	.DEF _sending=R7
	.DEF _sender_set=R6
	.DEF _MY_ID=R9
	.DEF _rx_wr_index=R8
	.DEF _rx_rd_index=R11
	.DEF _rx_counter=R10
	.DEF _tx_wr_index=R13
	.DEF _tx_rd_index=R12

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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

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
;Project :
;Version :
;Date    : 4/6/2020
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
;#define lcd_ddr DDRB
;#define lcd_port PORTB
;#define lcd_control_ddr DDRA
;#define lcd_control_port PORTA
;#define RS 6
;#define RW 1
;#define EN 7
;#define KEYPAD_DDR DDRC
;#define KEYPAD_PORT PORTC
;#define KEYPAD_PIN PINC
;
;// Declare your global variables here
;unsigned char received_string[40];
;unsigned char sending_string[40];
;unsigned char message_string[17];
;unsigned char i = 0;
;unsigned char j = 0;
;unsigned char sending = 0;
;unsigned char sender_set = 0;
;unsigned char MY_ID;
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 16
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 004C {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004D char status,data;
; 0000 004E status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 004F data=UDR;
	IN   R16,12
; 0000 0050 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0051    {
; 0000 0052    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R8
	INC  R8
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0053 #if RX_BUFFER_SIZE == 256
; 0000 0054    // special case for receiver buffer size=256
; 0000 0055    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 0056 #else
; 0000 0057    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(16)
	CP   R30,R8
	BRNE _0x4
	CLR  R8
; 0000 0058    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R10
	LDI  R30,LOW(16)
	CP   R30,R10
	BRNE _0x5
; 0000 0059       {
; 0000 005A       rx_counter=0;
	CLR  R10
; 0000 005B       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 005C       }
; 0000 005D #endif
; 0000 005E    }
_0x5:
; 0000 005F }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x72
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0066 {
_getchar:
; .FSTART _getchar
; 0000 0067 char data;
; 0000 0068 while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R10
	BREQ _0x6
; 0000 0069 data=rx_buffer[rx_rd_index++];
	MOV  R30,R11
	INC  R11
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 006A #if RX_BUFFER_SIZE != 256
; 0000 006B if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(16)
	CP   R30,R11
	BRNE _0x9
	CLR  R11
; 0000 006C #endif
; 0000 006D #asm("cli")
_0x9:
	cli
; 0000 006E --rx_counter;
	DEC  R10
; 0000 006F #asm("sei")
	sei
; 0000 0070 return data;
	MOV  R30,R17
	RJMP _0x2060001
; 0000 0071 }
; .FEND
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 16
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index=0,tx_rd_index=0;
;#else
;unsigned int tx_wr_index=0,tx_rd_index=0;
;#endif
;
;#if TX_BUFFER_SIZE < 256
;unsigned char tx_counter=0;
;#else
;unsigned int tx_counter=0;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0087 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0088 if (tx_counter)
	LDS  R30,_tx_counter
	CPI  R30,0
	BREQ _0xA
; 0000 0089    {
; 0000 008A    --tx_counter;
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0000 008B    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 008C #if TX_BUFFER_SIZE != 256
; 0000 008D    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(16)
	CP   R30,R12
	BRNE _0xB
	CLR  R12
; 0000 008E #endif
; 0000 008F    }
_0xB:
; 0000 0090 }
_0xA:
_0x72:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0097 {
_putchar:
; .FSTART _putchar
; 0000 0098 while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0xC:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x10)
	BREQ _0xC
; 0000 0099 #asm("cli")
	cli
; 0000 009A if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter
	CPI  R30,0
	BRNE _0x10
	SBIC 0xB,5
	RJMP _0xF
_0x10:
; 0000 009B    {
; 0000 009C    tx_buffer[tx_wr_index++]=c;
	MOV  R30,R13
	INC  R13
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 009D #if TX_BUFFER_SIZE != 256
; 0000 009E    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(16)
	CP   R30,R13
	BRNE _0x12
	CLR  R13
; 0000 009F #endif
; 0000 00A0    ++tx_counter;
_0x12:
	LDS  R30,_tx_counter
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0000 00A1    }
; 0000 00A2 else
	RJMP _0x13
_0xF:
; 0000 00A3    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00A4 #asm("sei")
_0x13:
	sei
; 0000 00A5 }
	RJMP _0x2060006
; .FEND
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;void lcd_send_cmd(unsigned char cmd);
;void lcd_send_char(unsigned char sentCharacter);
;void lcd_clear();
;void lcd_send_string(char sentString[]);
;
;void lcd_init(){
; 0000 00B1 void lcd_init(){
_lcd_init:
; .FSTART _lcd_init
; 0000 00B2     lcd_ddr = 0xff;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00B3     lcd_control_ddr |= (1<<RS) | (1<<RW) | (1<<EN);
	IN   R30,0x1A
	ORI  R30,LOW(0xC2)
	OUT  0x1A,R30
; 0000 00B4 	lcd_send_cmd(0x0E);
	LDI  R26,LOW(14)
	RCALL _lcd_send_cmd
; 0000 00B5 	lcd_send_cmd(0x38);
	LDI  R26,LOW(56)
	RCALL _lcd_send_cmd
; 0000 00B6 	lcd_clear();
	RCALL _lcd_clear
; 0000 00B7 	delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 00B8 	lcd_clear();
	RCALL _lcd_clear
; 0000 00B9 }
	RET
; .FEND
;
;void lcd_send_cmd(unsigned char cmd){
; 0000 00BB void lcd_send_cmd(unsigned char cmd){
_lcd_send_cmd:
; .FSTART _lcd_send_cmd
; 0000 00BC 	lcd_port = cmd;
	ST   -Y,R26
;	cmd -> Y+0
	LD   R30,Y
	OUT  0x18,R30
; 0000 00BD 	lcd_control_port &= ~(1<<RS);
	CBI  0x1B,6
; 0000 00BE 	lcd_control_port &= ~(1<<RW);
	RJMP _0x2060005
; 0000 00BF 	lcd_control_port |=  (1<<EN);
; 0000 00C0 	delay_us(700);
; 0000 00C1 	lcd_control_port &= ~(1<<EN);
; 0000 00C2 }
; .FEND
;
;void lcd_send_char(unsigned char sentCharacter){
; 0000 00C4 void lcd_send_char(unsigned char sentCharacter){
_lcd_send_char:
; .FSTART _lcd_send_char
; 0000 00C5 	lcd_port = sentCharacter;
	ST   -Y,R26
;	sentCharacter -> Y+0
	LD   R30,Y
	OUT  0x18,R30
; 0000 00C6 	lcd_control_port |=  (1<<RS);
	SBI  0x1B,6
; 0000 00C7 	lcd_control_port &= ~(1<<RW);
_0x2060005:
	CBI  0x1B,1
; 0000 00C8 	lcd_control_port |=  (1<<EN);
	SBI  0x1B,7
; 0000 00C9 	delay_us(700);
	__DELAY_USW 1400
; 0000 00CA 	lcd_control_port &= ~(1<<EN);
	CBI  0x1B,7
; 0000 00CB }
_0x2060006:
	ADIW R28,1
	RET
; .FEND
;
;void lcd_send_string(char sentString[]){
; 0000 00CD void lcd_send_string(char sentString[]){
_lcd_send_string:
; .FSTART _lcd_send_string
; 0000 00CE 	unsigned char  i = 0;
; 0000 00CF 	while (sentString[i]!='\0')
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	sentString -> Y+1
;	i -> R17
	LDI  R17,0
_0x14:
	CALL SUBOPT_0x0
	LD   R30,X
	CPI  R30,0
	BREQ _0x16
; 0000 00D0 	{
; 0000 00D1 		lcd_send_char(sentString[i]);
	CALL SUBOPT_0x0
	LD   R26,X
	RCALL _lcd_send_char
; 0000 00D2 		i++;
	SUBI R17,-1
; 0000 00D3 	}
	RJMP _0x14
_0x16:
; 0000 00D4 }
	RJMP _0x2060004
; .FEND
;
;void lcd_clear(){
; 0000 00D6 void lcd_clear(){
_lcd_clear:
; .FSTART _lcd_clear
; 0000 00D7 	lcd_send_cmd(0x01);
	LDI  R26,LOW(1)
	RCALL _lcd_send_cmd
; 0000 00D8 }
	RET
; .FEND
;
;void lcd_go_to_xy(unsigned char x,unsigned char y){
; 0000 00DA void lcd_go_to_xy(unsigned char x,unsigned char y){
_lcd_go_to_xy:
; .FSTART _lcd_go_to_xy
; 0000 00DB 	if(x == 0){
	ST   -Y,R26
;	x -> Y+1
;	y -> Y+0
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x17
; 0000 00DC 		lcd_send_cmd(0x80+y);
	LD   R26,Y
	SUBI R26,-LOW(128)
	RJMP _0x6F
; 0000 00DD 	}
; 0000 00DE     else if (x == 1){
_0x17:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x19
; 0000 00DF 		lcd_send_cmd(0xC0+y);
	LD   R26,Y
	SUBI R26,-LOW(192)
_0x6F:
	RCALL _lcd_send_cmd
; 0000 00E0 	}
; 0000 00E1 }
_0x19:
	RJMP _0x2060003
; .FEND
;
;void show_message(unsigned char* string){
; 0000 00E3 void show_message(unsigned char* string){
_show_message:
; .FSTART _show_message
; 0000 00E4     lcd_clear();
	ST   -Y,R27
	ST   -Y,R26
;	*string -> Y+0
	RCALL _lcd_clear
; 0000 00E5     message_string[0] = 'S';
	LDI  R30,LOW(83)
	STS  _message_string,R30
; 0000 00E6     message_string[1] = 'n';
	LDI  R30,LOW(110)
	__PUTB1MN _message_string,1
; 0000 00E7     message_string[2] = 'd';
	LDI  R30,LOW(100)
	CALL SUBOPT_0x1
; 0000 00E8     message_string[3] = 'r';
; 0000 00E9     message_string[4] = ':';
; 0000 00EA     message_string[5] = '\0';
; 0000 00EB     lcd_send_string(message_string);
; 0000 00EC     lcd_send_char(string[0]);
	LD   R26,Y
	LDD  R27,Y+1
	LD   R26,X
	RCALL _lcd_send_char
; 0000 00ED     message_string[0] = ' ';
	LDI  R30,LOW(32)
	STS  _message_string,R30
; 0000 00EE     message_string[1] = ' ';
	__PUTB1MN _message_string,1
; 0000 00EF     message_string[2] = '\0';
	LDI  R30,LOW(0)
	__PUTB1MN _message_string,2
; 0000 00F0     lcd_send_string(message_string);
	CALL SUBOPT_0x2
; 0000 00F1     message_string[0] = 'R';
	LDI  R30,LOW(82)
	STS  _message_string,R30
; 0000 00F2     message_string[1] = 'c';
	LDI  R30,LOW(99)
	__PUTB1MN _message_string,1
; 0000 00F3     message_string[2] = 'v';
	LDI  R30,LOW(118)
	CALL SUBOPT_0x1
; 0000 00F4     message_string[3] = 'r';
; 0000 00F5     message_string[4] = ':';
; 0000 00F6     message_string[5] = '\0';
; 0000 00F7     lcd_send_string(message_string);
; 0000 00F8     lcd_send_char(string[1]);
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R26,Z+1
	RCALL _lcd_send_char
; 0000 00F9     lcd_go_to_xy(1, 0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x3
; 0000 00FA     lcd_send_char('M');
	LDI  R26,LOW(77)
	RCALL _lcd_send_char
; 0000 00FB     lcd_send_char('=');
	LDI  R26,LOW(61)
	RCALL _lcd_send_char
; 0000 00FC     lcd_send_string(string+2);
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,2
	RCALL _lcd_send_string
; 0000 00FD }
	RJMP _0x2060003
; .FEND
;
;void show_sending(){
; 0000 00FF void show_sending(){
_show_sending:
; .FSTART _show_sending
; 0000 0100     unsigned char string[17];
; 0000 0101     lcd_clear();
	SBIW R28,17
;	string -> Y+0
	RCALL _lcd_clear
; 0000 0102     string[0] = 'S';
	LDI  R30,LOW(83)
	ST   Y,R30
; 0000 0103     string[1] = 'e';
	LDI  R30,LOW(101)
	STD  Y+1,R30
; 0000 0104     string[2] = 'n';
	LDI  R30,LOW(110)
	STD  Y+2,R30
; 0000 0105     string[3] = 'd';
	LDI  R30,LOW(100)
	STD  Y+3,R30
; 0000 0106     string[4] = 'i';
	LDI  R30,LOW(105)
	STD  Y+4,R30
; 0000 0107     string[5] = 'n';
	LDI  R30,LOW(110)
	STD  Y+5,R30
; 0000 0108     string[6] = 'g';
	LDI  R30,LOW(103)
	STD  Y+6,R30
; 0000 0109     string[7] = ' ';
	LDI  R30,LOW(32)
	STD  Y+7,R30
; 0000 010A     string[8] = 'M';
	LDI  R30,LOW(77)
	STD  Y+8,R30
; 0000 010B     string[9] = 'e';
	LDI  R30,LOW(101)
	STD  Y+9,R30
; 0000 010C     string[10] = 's';
	LDI  R30,LOW(115)
	STD  Y+10,R30
; 0000 010D     string[11] = 's';
	STD  Y+11,R30
; 0000 010E     string[12] = 'a';
	LDI  R30,LOW(97)
	STD  Y+12,R30
; 0000 010F     string[13] = 'g';
	LDI  R30,LOW(103)
	STD  Y+13,R30
; 0000 0110     string[14] = 'e';
	LDI  R30,LOW(101)
	STD  Y+14,R30
; 0000 0111     string[15] = '!';
	LDI  R30,LOW(33)
	STD  Y+15,R30
; 0000 0112     string[16] = '\0';
	LDI  R30,LOW(0)
	STD  Y+16,R30
; 0000 0113     lcd_go_to_xy(0, 0);
	CALL SUBOPT_0x3
; 0000 0114     lcd_send_string(string);
	MOVW R26,R28
	RCALL _lcd_send_string
; 0000 0115     delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0116     lcd_clear();
	RCALL _lcd_clear
; 0000 0117 }
	ADIW R28,17
	RET
; .FEND
;
;void send(unsigned char* string){
; 0000 0119 void send(unsigned char* string){
_send:
; .FSTART _send
; 0000 011A     unsigned char k=0;
; 0000 011B     while (string[k] != '#'){
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*string -> Y+1
;	k -> R17
	LDI  R17,0
_0x1A:
	CALL SUBOPT_0x0
	LD   R26,X
	CPI  R26,LOW(0x23)
	BREQ _0x1C
; 0000 011C         putchar(string[k]);
	CALL SUBOPT_0x0
	LD   R26,X
	RCALL _putchar
; 0000 011D         k += 1;
	SUBI R17,-LOW(1)
; 0000 011E     }
	RJMP _0x1A
_0x1C:
; 0000 011F     putchar(string[k]);
	CALL SUBOPT_0x0
	LD   R26,X
	RCALL _putchar
; 0000 0120     //putchar('\0');
; 0000 0121 }
_0x2060004:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
;
;void process(unsigned char* string){
; 0000 0123 void process(unsigned char* string){
_process:
; .FSTART _process
; 0000 0124     if (string[1] == ('0' + MY_ID)){
	ST   -Y,R27
	ST   -Y,R26
;	*string -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R26,Z+1
	MOV  R30,R9
	LDI  R31,0
	ADIW R30,48
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x1D
; 0000 0125         show_message(string);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _show_message
; 0000 0126     }
; 0000 0127     else{
	RJMP _0x1E
_0x1D:
; 0000 0128         show_sending();
	RCALL _show_sending
; 0000 0129         send(string);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _send
; 0000 012A     }
_0x1E:
; 0000 012B }
_0x2060003:
	ADIW R28,2
	RET
; .FEND
;
;void receive(){
; 0000 012D void receive(){
_receive:
; .FSTART _receive
; 0000 012E     unsigned char d;
; 0000 012F     if (rx_counter == 0){
	ST   -Y,R17
;	d -> R17
	TST  R10
	BRNE _0x1F
; 0000 0130         return;
	RJMP _0x2060001
; 0000 0131     }
; 0000 0132     d = getchar();
_0x1F:
	RCALL _getchar
	MOV  R17,R30
; 0000 0133     if (d == '#'){
	CPI  R17,35
	BRNE _0x20
; 0000 0134         received_string[i] = d;
	CALL SUBOPT_0x4
	ST   Z,R17
; 0000 0135         i += 1;
	INC  R5
; 0000 0136         received_string[i] = '\0';
	CALL SUBOPT_0x4
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0137         i = 0;
	CLR  R5
; 0000 0138         process(received_string);
	LDI  R26,LOW(_received_string)
	LDI  R27,HIGH(_received_string)
	RCALL _process
; 0000 0139 
; 0000 013A     }
; 0000 013B     else{
	RJMP _0x21
_0x20:
; 0000 013C         received_string[i] = d;
	CALL SUBOPT_0x4
	ST   Z,R17
; 0000 013D         i += 1;
	INC  R5
; 0000 013E     }
_0x21:
; 0000 013F }
	RJMP _0x2060001
; .FEND
;
;unsigned char GetKeyPressed(){
; 0000 0141 unsigned char GetKeyPressed(){
_GetKeyPressed:
; .FSTART _GetKeyPressed
; 0000 0142     unsigned char r,c;
; 0000 0143     KEYPAD_PORT |= 0X0F;
	ST   -Y,R17
	ST   -Y,R16
;	r -> R17
;	c -> R16
	IN   R30,0x15
	ORI  R30,LOW(0xF)
	OUT  0x15,R30
; 0000 0144     for(c=0;c<3;c++){
	LDI  R16,LOW(0)
_0x23:
	CPI  R16,3
	BRSH _0x24
; 0000 0145         KEYPAD_DDR &= ~(0X7F);
	IN   R30,0x14
	ANDI R30,LOW(0x80)
	OUT  0x14,R30
; 0000 0146         KEYPAD_DDR |= (0X40>>c);
	IN   R1,20
	MOV  R30,R16
	LDI  R26,LOW(64)
	CALL __LSRB12
	OR   R30,R1
	OUT  0x14,R30
; 0000 0147         for(r=0;r<4;r++){
	LDI  R17,LOW(0)
_0x26:
	CPI  R17,4
	BRSH _0x27
; 0000 0148             if(!(KEYPAD_PIN & (0X08>>r))){
	IN   R1,19
	MOV  R30,R17
	LDI  R26,LOW(8)
	CALL __LSRB12
	AND  R30,R1
	BRNE _0x28
; 0000 0149                 return (r*3+c);
	LDI  R26,LOW(3)
	MULS R17,R26
	MOVW R30,R0
	ADD  R30,R16
	RJMP _0x2060002
; 0000 014A             }
; 0000 014B         }
_0x28:
	SUBI R17,-1
	RJMP _0x26
_0x27:
; 0000 014C     }
	SUBI R16,-1
	RJMP _0x23
_0x24:
; 0000 014D     return 0XFF;//Indicate No key pressed
	LDI  R30,LOW(255)
_0x2060002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 014E }
; .FEND
;
;void receive_command(){
; 0000 0150 void receive_command(){
_receive_command:
; .FSTART _receive_command
; 0000 0151   unsigned char keypressed = GetKeyPressed();
; 0000 0152   delay_ms(30);
	ST   -Y,R17
;	keypressed -> R17
	RCALL _GetKeyPressed
	MOV  R17,R30
	LDI  R26,LOW(30)
	LDI  R27,0
	CALL _delay_ms
; 0000 0153   if (keypressed==0){
	CPI  R17,0
	BRNE _0x29
; 0000 0154     if (sending == 2){
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x2A
; 0000 0155     sending_string[j] = '1';
	CALL SUBOPT_0x5
; 0000 0156     j++;
; 0000 0157     lcd_send_char('1');
; 0000 0158     }
; 0000 0159     if (sending == 1){
_0x2A:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x2B
; 0000 015A         if (sender_set == 0){
	TST  R6
	BRNE _0x2C
; 0000 015B             sending_string[j] = '1';
	CALL SUBOPT_0x5
; 0000 015C             j++;
; 0000 015D             lcd_send_char('1');
; 0000 015E             sender_set = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 015F         }
; 0000 0160     }
_0x2C:
; 0000 0161   }
_0x2B:
; 0000 0162   if (keypressed==3){
_0x29:
	CPI  R17,3
	BRNE _0x2D
; 0000 0163     if (sending == 2){
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x2E
; 0000 0164         sending_string[j] = '4';
	CALL SUBOPT_0x6
; 0000 0165         j++;
; 0000 0166         lcd_send_char('4');
; 0000 0167     }
; 0000 0168     if (sending == 1){
_0x2E:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x2F
; 0000 0169         if (sender_set == 0){
	TST  R6
	BRNE _0x30
; 0000 016A             sending_string[j] = '4';
	CALL SUBOPT_0x6
; 0000 016B             j++;
; 0000 016C             lcd_send_char('4');
; 0000 016D             sender_set = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 016E         }
; 0000 016F     }
_0x30:
; 0000 0170   }
_0x2F:
; 0000 0171   if (keypressed==6){
_0x2D:
	CPI  R17,6
	BRNE _0x31
; 0000 0172     if (sending == 2){
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x32
; 0000 0173         sending_string[j] = '7';
	CALL SUBOPT_0x7
; 0000 0174         j++;
; 0000 0175         lcd_send_char('7');
; 0000 0176     }
; 0000 0177     if (sending == 1){
_0x32:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x33
; 0000 0178         if (sender_set == 0){
	TST  R6
	BRNE _0x34
; 0000 0179             sending_string[j] = '7';
	CALL SUBOPT_0x7
; 0000 017A             j++;
; 0000 017B             lcd_send_char('7');
; 0000 017C             sender_set = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 017D         }
; 0000 017E     }
_0x34:
; 0000 017F   }
_0x33:
; 0000 0180   if (keypressed==9){
_0x31:
	CPI  R17,9
	BRNE _0x35
; 0000 0181     if (sending == 2){
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x36
; 0000 0182         sending_string[j] = '*';
	CALL SUBOPT_0x8
	LDI  R26,LOW(42)
	STD  Z+0,R26
; 0000 0183         j++;
	INC  R4
; 0000 0184         lcd_send_char('*');
	RJMP _0x70
; 0000 0185     }
; 0000 0186     else if (sending == 0){
_0x36:
	TST  R7
	BRNE _0x38
; 0000 0187         sending = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0188         sending_string[0] = '0' + MY_ID;
	MOV  R30,R9
	SUBI R30,-LOW(48)
	STS  _sending_string,R30
; 0000 0189         j = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 018A         lcd_clear();
	RCALL _lcd_clear
; 0000 018B         lcd_send_char('=');
	LDI  R26,LOW(61)
	RJMP _0x71
; 0000 018C     }
; 0000 018D     else{
_0x38:
; 0000 018E         if (sender_set == 1){
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x3A
; 0000 018F             sending = 2;
	LDI  R30,LOW(2)
	MOV  R7,R30
; 0000 0190             lcd_send_char('*');
_0x70:
	LDI  R26,LOW(42)
_0x71:
	RCALL _lcd_send_char
; 0000 0191         }
; 0000 0192     }
_0x3A:
; 0000 0193   }
; 0000 0194   if (keypressed==1){
_0x35:
	CPI  R17,1
	BRNE _0x3B
; 0000 0195     if (sending == 2){
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x3C
; 0000 0196         sending_string[j] = '2';
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 0197         j++;
; 0000 0198         lcd_send_char('2');
; 0000 0199     }
; 0000 019A     if (sending == 1){
_0x3C:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x3D
; 0000 019B         if (sender_set == 0){
	TST  R6
	BRNE _0x3E
; 0000 019C             sending_string[j] = '2';
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 019D             j++;
; 0000 019E             lcd_send_char('2');
; 0000 019F             sender_set = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 01A0         }
; 0000 01A1     }
_0x3E:
; 0000 01A2   }
_0x3D:
; 0000 01A3   if (keypressed==4){
_0x3B:
	CPI  R17,4
	BRNE _0x3F
; 0000 01A4     if (sending == 2){
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x40
; 0000 01A5         sending_string[j] = '5';
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
; 0000 01A6         j++;
; 0000 01A7         lcd_send_char('5');
; 0000 01A8     }
; 0000 01A9     if (sending == 1){
_0x40:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x41
; 0000 01AA         if (sender_set == 0){
	TST  R6
	BRNE _0x42
; 0000 01AB             sending_string[j] = '5';
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
; 0000 01AC             j++;
; 0000 01AD             lcd_send_char('5');
; 0000 01AE             sender_set = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 01AF         }
; 0000 01B0     }
_0x42:
; 0000 01B1   }
_0x41:
; 0000 01B2   if (keypressed==7){
_0x3F:
	CPI  R17,7
	BRNE _0x43
; 0000 01B3     if (sending == 2){
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x44
; 0000 01B4         sending_string[j] = '8';
	CALL SUBOPT_0x8
	CALL SUBOPT_0xB
; 0000 01B5         j++;
; 0000 01B6         lcd_send_char('8');
; 0000 01B7     }
; 0000 01B8     if (sending == 1){
_0x44:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x45
; 0000 01B9         if (sender_set == 0){
	TST  R6
	BRNE _0x46
; 0000 01BA             sending_string[j] = '8';
	CALL SUBOPT_0x8
	CALL SUBOPT_0xB
; 0000 01BB             j++;
; 0000 01BC             lcd_send_char('8');
; 0000 01BD             sender_set = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 01BE         }
; 0000 01BF     }
_0x46:
; 0000 01C0   }
_0x45:
; 0000 01C1   if (keypressed==10){
_0x43:
	CPI  R17,10
	BRNE _0x47
; 0000 01C2     if (sending == 2){
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x48
; 0000 01C3         sending_string[j] = '0';
	CALL SUBOPT_0x8
	CALL SUBOPT_0xC
; 0000 01C4         j++;
; 0000 01C5         lcd_send_char('0');
; 0000 01C6     }
; 0000 01C7     if (sending == 1){
_0x48:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x49
; 0000 01C8         if (sender_set == 0){
	TST  R6
	BRNE _0x4A
; 0000 01C9             sending_string[j] = '0';
	CALL SUBOPT_0x8
	CALL SUBOPT_0xC
; 0000 01CA             j++;
; 0000 01CB             lcd_send_char('0');
; 0000 01CC             sender_set = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 01CD         }
; 0000 01CE     }
_0x4A:
; 0000 01CF   }
_0x49:
; 0000 01D0   if (keypressed==2){
_0x47:
	CPI  R17,2
	BRNE _0x4B
; 0000 01D1     if (sending == 2){
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x4C
; 0000 01D2         sending_string[j] = '3';
	CALL SUBOPT_0x8
	CALL SUBOPT_0xD
; 0000 01D3         j++;
; 0000 01D4         lcd_send_char('3');
; 0000 01D5     }
; 0000 01D6     if (sending == 1){
_0x4C:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x4D
; 0000 01D7         if (sender_set == 0){
	TST  R6
	BRNE _0x4E
; 0000 01D8             sending_string[j] = '3';
	CALL SUBOPT_0x8
	CALL SUBOPT_0xD
; 0000 01D9             j++;
; 0000 01DA             lcd_send_char('3');
; 0000 01DB             sender_set = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 01DC         }
; 0000 01DD     }
_0x4E:
; 0000 01DE   }
_0x4D:
; 0000 01DF   if (keypressed==5){
_0x4B:
	CPI  R17,5
	BRNE _0x4F
; 0000 01E0     if (sending == 2){
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x50
; 0000 01E1         sending_string[j] = '6';
	CALL SUBOPT_0x8
	CALL SUBOPT_0xE
; 0000 01E2         j++;
; 0000 01E3         lcd_send_char('6');
; 0000 01E4     }
; 0000 01E5     if (sending == 1){
_0x50:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x51
; 0000 01E6         if (sender_set == 0){
	TST  R6
	BRNE _0x52
; 0000 01E7             sending_string[j] = '6';
	CALL SUBOPT_0x8
	CALL SUBOPT_0xE
; 0000 01E8             j++;
; 0000 01E9             lcd_send_char('6');
; 0000 01EA             sender_set = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 01EB         }
; 0000 01EC     }
_0x52:
; 0000 01ED   }
_0x51:
; 0000 01EE   if (keypressed==8){
_0x4F:
	CPI  R17,8
	BRNE _0x53
; 0000 01EF     if (sending == 2){
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x54
; 0000 01F0         sending_string[j] = '9';
	CALL SUBOPT_0x8
	CALL SUBOPT_0xF
; 0000 01F1         j++;
; 0000 01F2         lcd_send_char('9');
; 0000 01F3     }
; 0000 01F4     if (sending == 1){
_0x54:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x55
; 0000 01F5         if (sender_set == 0){
	TST  R6
	BRNE _0x56
; 0000 01F6             sending_string[j] = '9';
	CALL SUBOPT_0x8
	CALL SUBOPT_0xF
; 0000 01F7             j++;
; 0000 01F8             lcd_send_char('9');
; 0000 01F9             sender_set = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 01FA         }
; 0000 01FB     }
_0x56:
; 0000 01FC   }
_0x55:
; 0000 01FD   if (keypressed==11){
_0x53:
	CPI  R17,11
	BRNE _0x57
; 0000 01FE     if (sending == 2){
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x58
; 0000 01FF         sending_string[j] = '#';
	CALL SUBOPT_0x8
	LDI  R26,LOW(35)
	STD  Z+0,R26
; 0000 0200         j++;
	INC  R4
; 0000 0201         sending_string[j] == '\0';
	CALL SUBOPT_0x8
	LD   R26,Z
	LDI  R30,LOW(0)
	CALL __EQB12
; 0000 0202         j++;
	INC  R4
; 0000 0203         sending = 0;
	CLR  R7
; 0000 0204         sender_set = 0;
	CLR  R6
; 0000 0205         process(sending_string);
	LDI  R26,LOW(_sending_string)
	LDI  R27,HIGH(_sending_string)
	RCALL _process
; 0000 0206     }
; 0000 0207   }
_0x58:
; 0000 0208 }
_0x57:
	RJMP _0x2060001
; .FEND
;
;void set_my_id(){
; 0000 020A void set_my_id(){
_set_my_id:
; .FSTART _set_my_id
; 0000 020B     unsigned char keypressed;
; 0000 020C     lcd_clear();
	ST   -Y,R17
;	keypressed -> R17
	RCALL _lcd_clear
; 0000 020D     message_string[0] = 'E';
	LDI  R30,LOW(69)
	STS  _message_string,R30
; 0000 020E     message_string[1] = 'n';
	LDI  R30,LOW(110)
	__PUTB1MN _message_string,1
; 0000 020F     message_string[2] = 't';
	LDI  R30,LOW(116)
	__PUTB1MN _message_string,2
; 0000 0210     message_string[3] = 'e';
	LDI  R30,LOW(101)
	__PUTB1MN _message_string,3
; 0000 0211     message_string[4] = 'r';
	LDI  R30,LOW(114)
	__PUTB1MN _message_string,4
; 0000 0212     message_string[5] = ' ';
	LDI  R30,LOW(32)
	__PUTB1MN _message_string,5
; 0000 0213     message_string[6] = 'M';
	LDI  R30,LOW(77)
	__PUTB1MN _message_string,6
; 0000 0214     message_string[7] = 'Y';
	LDI  R30,LOW(89)
	__PUTB1MN _message_string,7
; 0000 0215     message_string[8] = ' ';
	LDI  R30,LOW(32)
	__PUTB1MN _message_string,8
; 0000 0216     message_string[9] = 'I';
	LDI  R30,LOW(73)
	__PUTB1MN _message_string,9
; 0000 0217     message_string[10] = 'D';
	LDI  R30,LOW(68)
	__PUTB1MN _message_string,10
; 0000 0218     message_string[11] = ':';
	LDI  R30,LOW(58)
	__PUTB1MN _message_string,11
; 0000 0219     message_string[12] = '\0';
	LDI  R30,LOW(0)
	__PUTB1MN _message_string,12
; 0000 021A     lcd_go_to_xy(0, 2);
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _lcd_go_to_xy
; 0000 021B     lcd_send_string(message_string);
	CALL SUBOPT_0x2
; 0000 021C     do  {
_0x5A:
; 0000 021D         keypressed = GetKeyPressed();
	RCALL _GetKeyPressed
	MOV  R17,R30
; 0000 021E     }
; 0000 021F     while (keypressed==0xFF || keypressed==9 || keypressed==11);
	CPI  R17,255
	BREQ _0x5C
	CPI  R17,9
	BREQ _0x5C
	CPI  R17,11
	BRNE _0x5B
_0x5C:
	RJMP _0x5A
_0x5B:
; 0000 0220     switch (keypressed) {
	MOV  R30,R17
	LDI  R31,0
; 0000 0221     case 0:{
	SBIW R30,0
	BRNE _0x61
; 0000 0222         keypressed=1;
	LDI  R17,LOW(1)
; 0000 0223         break;
	RJMP _0x60
; 0000 0224     }
; 0000 0225     case 1:{
_0x61:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x62
; 0000 0226         keypressed=2;
	LDI  R17,LOW(2)
; 0000 0227         break;
	RJMP _0x60
; 0000 0228     }case 2:{
_0x62:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x63
; 0000 0229         keypressed=3;
	LDI  R17,LOW(3)
; 0000 022A         break;
	RJMP _0x60
; 0000 022B     }case 3:{
_0x63:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x64
; 0000 022C         keypressed=4;
	LDI  R17,LOW(4)
; 0000 022D         break;
	RJMP _0x60
; 0000 022E     }case 4:{
_0x64:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x65
; 0000 022F         keypressed=5;
	LDI  R17,LOW(5)
; 0000 0230         break;
	RJMP _0x60
; 0000 0231     }case 5:{
_0x65:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x66
; 0000 0232         keypressed=6;
	LDI  R17,LOW(6)
; 0000 0233         break;
	RJMP _0x60
; 0000 0234     }case 6:{
_0x66:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x67
; 0000 0235         keypressed=7;
	LDI  R17,LOW(7)
; 0000 0236         break;
	RJMP _0x60
; 0000 0237     }case 7:{
_0x67:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x68
; 0000 0238         keypressed=8;
	LDI  R17,LOW(8)
; 0000 0239         break;
	RJMP _0x60
; 0000 023A     }case 8:{
_0x68:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x69
; 0000 023B         keypressed=9;
	LDI  R17,LOW(9)
; 0000 023C         break;
	RJMP _0x60
; 0000 023D     }case 10:{
_0x69:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x60
; 0000 023E         keypressed=0;
	LDI  R17,LOW(0)
; 0000 023F         break;
; 0000 0240     }
; 0000 0241     };
_0x60:
; 0000 0242     MY_ID = keypressed;
	MOV  R9,R17
; 0000 0243     message_string[0] = 'I';
	LDI  R30,LOW(73)
	STS  _message_string,R30
; 0000 0244     message_string[1] = 'D';
	LDI  R30,LOW(68)
	__PUTB1MN _message_string,1
; 0000 0245     message_string[2] = ' ';
	LDI  R30,LOW(32)
	__PUTB1MN _message_string,2
; 0000 0246     message_string[3] = 's';
	LDI  R30,LOW(115)
	__PUTB1MN _message_string,3
; 0000 0247     message_string[4] = 'e';
	LDI  R30,LOW(101)
	__PUTB1MN _message_string,4
; 0000 0248     message_string[5] = 't';
	LDI  R30,LOW(116)
	__PUTB1MN _message_string,5
; 0000 0249     message_string[6] = ' ';
	LDI  R30,LOW(32)
	__PUTB1MN _message_string,6
; 0000 024A     message_string[7] = 't';
	LDI  R30,LOW(116)
	__PUTB1MN _message_string,7
; 0000 024B     message_string[8] = 'o';
	LDI  R30,LOW(111)
	__PUTB1MN _message_string,8
; 0000 024C     message_string[9] = ':';
	LDI  R30,LOW(58)
	__PUTB1MN _message_string,9
; 0000 024D     message_string[10] = ' ';
	LDI  R30,LOW(32)
	__PUTB1MN _message_string,10
; 0000 024E     message_string[11] = '\0';
	LDI  R30,LOW(0)
	__PUTB1MN _message_string,11
; 0000 024F     lcd_go_to_xy(1, 0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x3
; 0000 0250     lcd_send_string(message_string);
	CALL SUBOPT_0x2
; 0000 0251     lcd_send_char('0'+keypressed);
	MOV  R26,R17
	SUBI R26,-LOW(48)
	RCALL _lcd_send_char
; 0000 0252     delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0253 }
_0x2060001:
	LD   R17,Y+
	RET
; .FEND
;
;void main(void)
; 0000 0256 {
_main:
; .FSTART _main
; 0000 0257 // Declare your local variables here
; 0000 0258 
; 0000 0259 // Input/Output Ports initialization
; 0000 025A // Port A initialization
; 0000 025B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 025C DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 025D // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 025E PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 025F 
; 0000 0260 // Port B initialization
; 0000 0261 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0262 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0263 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0264 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0265 
; 0000 0266 // Port C initialization
; 0000 0267 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0268 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0269 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 026A PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 026B 
; 0000 026C // Port D initialization
; 0000 026D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 026E DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 026F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0270 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0271 
; 0000 0272 // Timer/Counter 0 initialization
; 0000 0273 // Clock source: System Clock
; 0000 0274 // Clock value: Timer 0 Stopped
; 0000 0275 // Mode: Normal top=0xFF
; 0000 0276 // OC0 output: Disconnected
; 0000 0277 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0278 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0279 OCR0=0x00;
	OUT  0x3C,R30
; 0000 027A 
; 0000 027B // Timer/Counter 1 initialization
; 0000 027C // Clock source: System Clock
; 0000 027D // Clock value: Timer1 Stopped
; 0000 027E // Mode: Normal top=0xFFFF
; 0000 027F // OC1A output: Disconnected
; 0000 0280 // OC1B output: Disconnected
; 0000 0281 // Noise Canceler: Off
; 0000 0282 // Input Capture on Falling Edge
; 0000 0283 // Timer1 Overflow Interrupt: Off
; 0000 0284 // Input Capture Interrupt: Off
; 0000 0285 // Compare A Match Interrupt: Off
; 0000 0286 // Compare B Match Interrupt: Off
; 0000 0287 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0288 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0289 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 028A TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 028B ICR1H=0x00;
	OUT  0x27,R30
; 0000 028C ICR1L=0x00;
	OUT  0x26,R30
; 0000 028D OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 028E OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 028F OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0290 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0291 
; 0000 0292 // Timer/Counter 2 initialization
; 0000 0293 // Clock source: System Clock
; 0000 0294 // Clock value: Timer2 Stopped
; 0000 0295 // Mode: Normal top=0xFF
; 0000 0296 // OC2 output: Disconnected
; 0000 0297 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0298 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0299 TCNT2=0x00;
	OUT  0x24,R30
; 0000 029A OCR2=0x00;
	OUT  0x23,R30
; 0000 029B 
; 0000 029C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 029D TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 029E 
; 0000 029F // External Interrupt(s) initialization
; 0000 02A0 // INT0: Off
; 0000 02A1 // INT1: Off
; 0000 02A2 // INT2: Off
; 0000 02A3 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 02A4 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 02A5 
; 0000 02A6 // USART initialization
; 0000 02A7 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 02A8 // USART Receiver: On
; 0000 02A9 // USART Transmitter: On
; 0000 02AA // USART Mode: Asynchronous
; 0000 02AB // USART Baud Rate: 9600
; 0000 02AC UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 02AD UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 02AE UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 02AF UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 02B0 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 02B1 
; 0000 02B2 // Analog Comparator initialization
; 0000 02B3 // Analog Comparator: Off
; 0000 02B4 // The Analog Comparator's positive input is
; 0000 02B5 // connected to the AIN0 pin
; 0000 02B6 // The Analog Comparator's negative input is
; 0000 02B7 // connected to the AIN1 pin
; 0000 02B8 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02B9 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 02BA 
; 0000 02BB // ADC initialization
; 0000 02BC // ADC disabled
; 0000 02BD ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 02BE 
; 0000 02BF // SPI initialization
; 0000 02C0 // SPI disabled
; 0000 02C1 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 02C2 
; 0000 02C3 // TWI initialization
; 0000 02C4 // TWI disabled
; 0000 02C5 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 02C6 
; 0000 02C7 // Global enable interrupts
; 0000 02C8 #asm("sei")
	sei
; 0000 02C9 lcd_init();
	RCALL _lcd_init
; 0000 02CA set_my_id();
	RCALL _set_my_id
; 0000 02CB while (1)
_0x6B:
; 0000 02CC       {
; 0000 02CD         //lcd_send_char('A');
; 0000 02CE       // Place your code here
; 0000 02CF         receive();
	RCALL _receive
; 0000 02D0         receive_command();
	RCALL _receive_command
; 0000 02D1       }
	RJMP _0x6B
; 0000 02D2 }
_0x6E:
	RJMP _0x6E
; .FEND
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

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_received_string:
	.BYTE 0x28
_sending_string:
	.BYTE 0x28
_message_string:
	.BYTE 0x11
_rx_buffer:
	.BYTE 0x10
_tx_buffer:
	.BYTE 0x10
_tx_counter:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	__PUTB1MN _message_string,2
	LDI  R30,LOW(114)
	__PUTB1MN _message_string,3
	LDI  R30,LOW(58)
	__PUTB1MN _message_string,4
	LDI  R30,LOW(0)
	__PUTB1MN _message_string,5
	LDI  R26,LOW(_message_string)
	LDI  R27,HIGH(_message_string)
	JMP  _lcd_send_string

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_message_string)
	LDI  R27,HIGH(_message_string)
	JMP  _lcd_send_string

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_go_to_xy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_received_string)
	SBCI R31,HIGH(-_received_string)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_sending_string)
	SBCI R31,HIGH(-_sending_string)
	LDI  R26,LOW(49)
	STD  Z+0,R26
	INC  R4
	JMP  _lcd_send_char

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_sending_string)
	SBCI R31,HIGH(-_sending_string)
	LDI  R26,LOW(52)
	STD  Z+0,R26
	INC  R4
	JMP  _lcd_send_char

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_sending_string)
	SBCI R31,HIGH(-_sending_string)
	LDI  R26,LOW(55)
	STD  Z+0,R26
	INC  R4
	JMP  _lcd_send_char

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x8:
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_sending_string)
	SBCI R31,HIGH(-_sending_string)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(50)
	STD  Z+0,R26
	INC  R4
	JMP  _lcd_send_char

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(53)
	STD  Z+0,R26
	INC  R4
	JMP  _lcd_send_char

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(56)
	STD  Z+0,R26
	INC  R4
	JMP  _lcd_send_char

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(48)
	STD  Z+0,R26
	INC  R4
	JMP  _lcd_send_char

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(51)
	STD  Z+0,R26
	INC  R4
	JMP  _lcd_send_char

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(54)
	STD  Z+0,R26
	INC  R4
	JMP  _lcd_send_char

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(57)
	STD  Z+0,R26
	INC  R4
	JMP  _lcd_send_char


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

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

;END OF CODE MARKER
__END_OF_CODE:
