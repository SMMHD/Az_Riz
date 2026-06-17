
;CodeVisionAVR C Compiler V3.14 Advanced
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
;Global 'const' stored in FLASH: No
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
	JMP  _timer0_comp_isr
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

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x31,0x32,0x33,0x34
_0x4:
	.DB  0x39,0x39,0x39,0x39
_0x5:
	.DB  0x3
_0x6:
	.DB  0x4
_0x20003:
	.DB  0x37,0x38,0x39,0x2F,0x34,0x35,0x36,0x2A
	.DB  0x31,0x32,0x33,0x2D,0x43,0x30,0x23,0x2B
_0x80000:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x4C,0x65,0x6E,0x20,0x4D,0x75,0x73
	.DB  0x74,0x20,0x42,0x65,0x20,0x0,0x53,0x59
	.DB  0x53,0x54,0x45,0x4D,0x20,0x4C,0x4F,0x43
	.DB  0x4B,0x45,0x44,0x21,0x0,0x57,0x61,0x69
	.DB  0x74,0x20,0x25,0x32,0x64,0x20,0x73,0x65
	.DB  0x63,0x20,0x20,0x20,0x0,0x31,0x3A,0x55
	.DB  0x73,0x72,0x50,0x73,0x77,0x20,0x32,0x3A
	.DB  0x41,0x64,0x6D,0x50,0x73,0x0,0x33,0x3A
	.DB  0x54,0x72,0x69,0x65,0x73,0x20,0x20,0x34
	.DB  0x3A,0x4C,0x65,0x6E,0x0,0x4E,0x65,0x77
	.DB  0x20,0x55,0x73,0x65,0x72,0x20,0x50,0x61
	.DB  0x73,0x73,0x3A,0x0,0x53,0x61,0x76,0x65
	.DB  0x64,0x21,0x0,0x4E,0x65,0x77,0x20,0x41
	.DB  0x64,0x6D,0x69,0x6E,0x20,0x50,0x61,0x73
	.DB  0x73,0x3A,0x0,0x53,0x65,0x74,0x20,0x4D
	.DB  0x61,0x78,0x20,0x54,0x72,0x69,0x65,0x73
	.DB  0x3A,0x0,0x53,0x65,0x74,0x20,0x4C,0x65
	.DB  0x6E,0x67,0x74,0x68,0x28,0x34,0x2D,0x38
	.DB  0x29,0x3A,0x0,0x53,0x61,0x76,0x65,0x64
	.DB  0x21,0x20,0x50,0x6C,0x7A,0x20,0x52,0x65
	.DB  0x73,0x65,0x74,0x0,0x49,0x6E,0x76,0x61
	.DB  0x6C,0x69,0x64,0x20,0x4C,0x65,0x6E,0x67
	.DB  0x74,0x68,0x21,0x0,0x20,0x20,0x44,0x69
	.DB  0x67,0x69,0x74,0x61,0x6C,0x20,0x4C,0x6F
	.DB  0x63,0x6B,0x20,0x20,0x0,0x20,0x53,0x74
	.DB  0x61,0x72,0x74,0x69,0x6E,0x67,0x2E,0x2E
	.DB  0x2E,0x20,0x20,0x20,0x20,0x0,0x2F,0x3A
	.DB  0x20,0x55,0x73,0x65,0x72,0x20,0x20,0x2A
	.DB  0x3A,0x41,0x64,0x6D,0x69,0x6E,0x0,0x53
	.DB  0x65,0x6C,0x65,0x63,0x74,0x20,0x4D,0x6F
	.DB  0x64,0x65,0x2E,0x2E,0x2E,0x0,0x55,0x73
	.DB  0x65,0x72,0x20,0x50,0x61,0x73,0x73,0x77
	.DB  0x6F,0x72,0x64,0x3A,0x0,0x41,0x63,0x63
	.DB  0x65,0x73,0x73,0x20,0x47,0x72,0x61,0x6E
	.DB  0x74,0x65,0x64,0x0,0x44,0x6F,0x6F,0x72
	.DB  0x20,0x4F,0x70,0x65,0x6E,0x65,0x64,0x0
	.DB  0x57,0x72,0x6F,0x6E,0x67,0x20,0x50,0x61
	.DB  0x73,0x73,0x77,0x6F,0x72,0x64,0x21,0x0
	.DB  0x41,0x64,0x6D,0x69,0x6E,0x20,0x50,0x61
	.DB  0x73,0x73,0x77,0x6F,0x72,0x64,0x3A,0x0
	.DB  0x41,0x64,0x6D,0x69,0x6E,0x20,0x56,0x65
	.DB  0x72,0x69,0x66,0x69,0x65,0x64,0x21,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _user_pass_G000
	.DW  _0x3*2

	.DW  0x04
	.DW  _admin_pass_G000
	.DW  _0x4*2

	.DW  0x01
	.DW  _max_tries_G000
	.DW  _0x5*2

	.DW  0x01
	.DW  _pass_len_G000
	.DW  _0x6*2

	.DW  0x11
	.DW  _0x8000B
	.DW  _0x80000*2

	.DW  0x0D
	.DW  _0x8000B+17
	.DW  _0x80000*2+17

	.DW  0x11
	.DW  _0x8000B+30
	.DW  _0x80000*2

	.DW  0x11
	.DW  _0x8000B+47
	.DW  _0x80000*2

	.DW  0x0F
	.DW  _0x8001F
	.DW  _0x80000*2+30

	.DW  0x11
	.DW  _0x80027
	.DW  _0x80000*2+61

	.DW  0x0F
	.DW  _0x80027+17
	.DW  _0x80000*2+78

	.DW  0x0F
	.DW  _0x80027+32
	.DW  _0x80000*2+93

	.DW  0x07
	.DW  _0x80027+47
	.DW  _0x80000*2+108

	.DW  0x10
	.DW  _0x80027+54
	.DW  _0x80000*2+115

	.DW  0x07
	.DW  _0x80027+70
	.DW  _0x80000*2+108

	.DW  0x0F
	.DW  _0x80027+77
	.DW  _0x80000*2+131

	.DW  0x07
	.DW  _0x80027+92
	.DW  _0x80000*2+108

	.DW  0x11
	.DW  _0x80027+99
	.DW  _0x80000*2+146

	.DW  0x11
	.DW  _0x80027+116
	.DW  _0x80000*2+163

	.DW  0x10
	.DW  _0x80027+133
	.DW  _0x80000*2+180

	.DW  0x11
	.DW  _0x8003B
	.DW  _0x80000*2+196

	.DW  0x11
	.DW  _0x8003B+17
	.DW  _0x80000*2+213

	.DW  0x11
	.DW  _0x8003B+34
	.DW  _0x80000*2+230

	.DW  0x0F
	.DW  _0x8003B+51
	.DW  _0x80000*2+247

	.DW  0x0F
	.DW  _0x8003B+66
	.DW  _0x80000*2+262

	.DW  0x0F
	.DW  _0x8003B+81
	.DW  _0x80000*2+277

	.DW  0x0C
	.DW  _0x8003B+96
	.DW  _0x80000*2+292

	.DW  0x10
	.DW  _0x8003B+108
	.DW  _0x80000*2+304

	.DW  0x10
	.DW  _0x8003B+124
	.DW  _0x80000*2+320

	.DW  0x10
	.DW  _0x8003B+140
	.DW  _0x80000*2+336

	.DW  0x10
	.DW  _0x8003B+156
	.DW  _0x80000*2+304

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
;#include <string.h>
;#include "config.h"
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
;#include "hal_timer.h"
;#include "app_lock.h"
;
;// ???????? ????? (?? ?? ????? ???????)
;static char user_pass[10] = "1234";

	.DSEG
;static char admin_pass[10] = "9999";
;static unsigned char max_tries = 3;
;static unsigned char pass_len = 4;
;static unsigned char failed_attempts = 0;
;
;static unsigned long door_open_time = 0;
;static unsigned char is_door_open = 0;
;
;void lock_init(void) {
; 0000 0010 void lock_init(void) {

	.CSEG
_lock_init:
; .FSTART _lock_init
; 0000 0011     LOCK_DDR |= (1<<0); // ????? ???? ???/LED ?? ????? ?????
	LDI  R26,0
	SBIC 0x17,0
	LDI  R26,1
	LDI  R30,LOW(1)
	OR   R30,R26
	BRNE _0x7
	CBI  0x17,0
	RJMP _0x8
_0x7:
	SBI  0x17,0
_0x8:
; 0000 0012     LOCK_OUT = 0;       // ?? ???? ??????? ??? ???? ???
	CBI  0x18,0
; 0000 0013 }
	RET
; .FEND
;
;void lock_open_door(void) {
; 0000 0015 void lock_open_door(void) {
_lock_open_door:
; .FSTART _lock_open_door
; 0000 0016     LOCK_OUT = 1;
	SBI  0x18,0
; 0000 0017     is_door_open = 1;
	LDI  R30,LOW(1)
	STS  _is_door_open_G000,R30
; 0000 0018     door_open_time = millis();
	CALL _millis
	STS  _door_open_time_G000,R30
	STS  _door_open_time_G000+1,R31
	STS  _door_open_time_G000+2,R22
	STS  _door_open_time_G000+3,R23
; 0000 0019 }
	RET
; .FEND
;
;// ??? ???? ???? ??????? ?? ??? ??? ?????? ?? delay ????? ???
;// ??? ???? ??? ???? ?? (???? 3 ?????) ???? ???? ?? ?? ???????
;void lock_update_task(void) {
; 0000 001D void lock_update_task(void) {
_lock_update_task:
; .FSTART _lock_update_task
; 0000 001E     if(is_door_open) {
	LDS  R30,_is_door_open_G000
	CPI  R30,0
	BREQ _0xD
; 0000 001F         if((millis() - door_open_time) > 3000) { // 3000 ?????????? = 3 ?????
	CALL _millis
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_door_open_time_G000
	LDS  R31,_door_open_time_G000+1
	LDS  R22,_door_open_time_G000+2
	LDS  R23,_door_open_time_G000+3
	CALL __SUBD21
	__CPD2N 0xBB9
	BRLO _0xE
; 0000 0020             LOCK_OUT = 0;
	CBI  0x18,0
; 0000 0021             is_door_open = 0;
	LDI  R30,LOW(0)
	STS  _is_door_open_G000,R30
; 0000 0022         }
; 0000 0023     }
_0xE:
; 0000 0024 }
_0xD:
	RET
; .FEND
;
;int lock_verify_password(char* input, unsigned char role) {
; 0000 0026 int lock_verify_password(char* input, unsigned char role) {
_lock_verify_password:
; .FSTART _lock_verify_password
; 0000 0027     if(role == ROLE_USER) {
	ST   -Y,R26
;	*input -> Y+1
;	role -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x11
; 0000 0028         return (strcmp(input, user_pass) == 0);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_user_pass_G000)
	LDI  R27,HIGH(_user_pass_G000)
	CALL SUBOPT_0x0
	JMP  _0x2060004
; 0000 0029     } else {
_0x11:
; 0000 002A         return (strcmp(input, admin_pass) == 0);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_admin_pass_G000)
	LDI  R27,HIGH(_admin_pass_G000)
	CALL SUBOPT_0x0
	JMP  _0x2060004
; 0000 002B     }
; 0000 002C }
; .FEND
;
;void lock_set_password(char* new_pass, unsigned char role) {
; 0000 002E void lock_set_password(char* new_pass, unsigned char role) {
_lock_set_password:
; .FSTART _lock_set_password
; 0000 002F     if(role == ROLE_USER) {
	ST   -Y,R26
;	*new_pass -> Y+1
;	role -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x13
; 0000 0030         strcpy(user_pass, new_pass);
	LDI  R30,LOW(_user_pass_G000)
	LDI  R31,HIGH(_user_pass_G000)
	RJMP _0x15
; 0000 0031     } else {
_0x13:
; 0000 0032         strcpy(admin_pass, new_pass);
	LDI  R30,LOW(_admin_pass_G000)
	LDI  R31,HIGH(_admin_pass_G000)
_0x15:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CALL _strcpy
; 0000 0033     }
; 0000 0034 }
	JMP  _0x2060004
; .FEND
;
;unsigned char lock_get_max_tries(void) { return max_tries; }
; 0000 0036 unsigned char lock_get_max_tries(void) { return max_tries; }
_lock_get_max_tries:
; .FSTART _lock_get_max_tries
	LDS  R30,_max_tries_G000
	RET
; .FEND
;void lock_set_max_tries(unsigned char tries) { max_tries = tries; }
; 0000 0037 void lock_set_max_tries(unsigned char tries) { max_tries = tries; }
_lock_set_max_tries:
; .FSTART _lock_set_max_tries
	ST   -Y,R26
;	tries -> Y+0
	LD   R30,Y
	STS  _max_tries_G000,R30
	JMP  _0x2060006
; .FEND
;
;unsigned char lock_get_pass_len(void) { return pass_len; }
; 0000 0039 unsigned char lock_get_pass_len(void) { return pass_len; }
_lock_get_pass_len:
; .FSTART _lock_get_pass_len
	LDS  R30,_pass_len_G000
	RET
; .FEND
;void lock_set_pass_len(unsigned char len) { pass_len = len; }
; 0000 003A void lock_set_pass_len(unsigned char len) { pass_len = len; }
_lock_set_pass_len:
; .FSTART _lock_set_pass_len
	ST   -Y,R26
;	len -> Y+0
	LD   R30,Y
	STS  _pass_len_G000,R30
	JMP  _0x2060006
; .FEND
;
;unsigned char lock_get_failed_attempts(void) { return failed_attempts; }
; 0000 003C unsigned char lock_get_failed_attempts(void) { return failed_attempts; }
_lock_get_failed_attempts:
; .FSTART _lock_get_failed_attempts
	LDS  R30,_failed_attempts_G000
	RET
; .FEND
;void lock_register_failure(void) { failed_attempts++; }
; 0000 003D void lock_register_failure(void) { failed_attempts++; }
_lock_register_failure:
; .FSTART _lock_register_failure
	LDS  R30,_failed_attempts_G000
	SUBI R30,-LOW(1)
	RJMP _0x2060009
; .FEND
;void lock_reset_failures(void) { failed_attempts = 0; }
; 0000 003E void lock_reset_failures(void) { failed_attempts = 0; }
_lock_reset_failures:
; .FSTART _lock_reset_failures
	LDI  R30,LOW(0)
_0x2060009:
	STS  _failed_attempts_G000,R30
	RET
; .FEND
;#include "config.h"
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
;#include "hal_timer.h"
;#include "hal_keypad.h"
;
;void keypad_init(void) {
; 0001 0005 void keypad_init(void) {

	.CSEG
_keypad_init:
; .FSTART _keypad_init
; 0001 0006     KEYPAD_DDR = 0x0F;  // 4 پین اول خروجی (سطرها)، 4 پین دوم ورودی (ستون‌ها)
	LDI  R30,LOW(15)
	OUT  0x1A,R30
; 0001 0007     KEYPAD_PORT = 0xFF; // پول‌آپ کردن ورودی‌ها و یک کردن خروجی‌ها
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0001 0008 }
	RET
; .FEND
;
;char keypad_read(void) {
; 0001 000A char keypad_read(void) {
_keypad_read:
; .FSTART _keypad_read
; 0001 000B     // چیدمان اصلاح شده بر اساس KEYPAD-SMALLCALC در پروتئوس
; 0001 000C     // در این کیپد: ستون آخر عملگرهای / * - + هستند و کلیدهای پایین ON/C 0 = +
; 0001 000D     char keymap[4][4] = {
; 0001 000E         {'7','8','9','/'},  // سطر اول (PA0)
; 0001 000F         {'4','5','6','*'},  // سطر دوم (PA1)
; 0001 0010         {'1','2','3','-'},  // سطر سوم (PA2)
; 0001 0011         {'C','0','#','+'}   // سطر چهارم (PA3) -> از 'C' برای Clear و از '#' برای تایید ('=')  ...
; 0001 0012     };
; 0001 0013     unsigned char r, c;
; 0001 0014 
; 0001 0015     for(r = 0; r < 4; r++) {
	SBIW R28,16
	LDI  R24,16
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x20003*2)
	LDI  R31,HIGH(_0x20003*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	keymap -> Y+2
;	r -> R17
;	c -> R16
	LDI  R17,LOW(0)
_0x20005:
	CPI  R17,4
	BRSH _0x20006
; 0001 0016         KEYPAD_PORT = ~(1 << r) | 0xF0;
	MOV  R30,R17
	LDI  R26,LOW(1)
	CALL __LSLB12
	COM  R30
	ORI  R30,LOW(0xF0)
	OUT  0x1B,R30
; 0001 0017         wait_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _wait_ms
; 0001 0018 
; 0001 0019         for(c = 0; c < 4; c++) {
	LDI  R16,LOW(0)
_0x20008:
	CPI  R16,4
	BRSH _0x20009
; 0001 001A             if(!(KEYPAD_PIN & (1 << (c + 4)))) {
	IN   R1,25
	MOV  R30,R16
	LDI  R31,0
	ADIW R30,4
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R1
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x2000A
; 0001 001B                 return keymap[r][c];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	LD   R30,X
	RJMP _0x2060008
; 0001 001C             }
; 0001 001D         }
_0x2000A:
	SUBI R16,-1
	RJMP _0x20008
_0x20009:
; 0001 001E     }
	SUBI R17,-1
	RJMP _0x20005
_0x20006:
; 0001 001F     return 0;
	LDI  R30,LOW(0)
_0x2060008:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,18
	RET
; 0001 0020 }
; .FEND
;#include "config.h"
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
;#include "hal_timer.h"
;#include "hal_lcd.h"
;
;void lcd_pulse(void) {
; 0002 0005 void lcd_pulse(void) {

	.CSEG
_lcd_pulse:
; .FSTART _lcd_pulse
; 0002 0006     LCD_EN = 1;
	SBI  0x15,1
; 0002 0007     wait_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _wait_ms
; 0002 0008     LCD_EN = 0;
	CBI  0x15,1
; 0002 0009     wait_ms(1);
	LDI  R26,LOW(1)
	RJMP _0x2060007
; 0002 000A }
; .FEND
;
;void lcd_send(unsigned char value, unsigned char is_data) {
; 0002 000C void lcd_send(unsigned char value, unsigned char is_data) {
_lcd_send:
; .FSTART _lcd_send
; 0002 000D     LCD_RS = is_data;
	ST   -Y,R26
;	value -> Y+1
;	is_data -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x40007
	CBI  0x15,0
	RJMP _0x40008
_0x40007:
	SBI  0x15,0
_0x40008:
; 0002 000E 
; 0002 000F     // ????? 4 ??? ?? ????
; 0002 0010     LCD_D4 = (value >> 4) & 1;
	LDD  R30,Y+1
	SWAP R30
	ANDI R30,LOW(0x1)
	BRNE _0x40009
	CBI  0x15,2
	RJMP _0x4000A
_0x40009:
	SBI  0x15,2
_0x4000A:
; 0002 0011     LCD_D5 = (value >> 5) & 1;
	LDD  R30,Y+1
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x4000B
	CBI  0x15,3
	RJMP _0x4000C
_0x4000B:
	SBI  0x15,3
_0x4000C:
; 0002 0012     LCD_D6 = (value >> 6) & 1;
	LDD  R30,Y+1
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x4000D
	CBI  0x15,4
	RJMP _0x4000E
_0x4000D:
	SBI  0x15,4
_0x4000E:
; 0002 0013     LCD_D7 = (value >> 7) & 1;
	LDD  R30,Y+1
	ROL  R30
	LDI  R30,0
	ROL  R30
	ANDI R30,LOW(0x1)
	BRNE _0x4000F
	CBI  0x15,5
	RJMP _0x40010
_0x4000F:
	SBI  0x15,5
_0x40010:
; 0002 0014     lcd_pulse();
	RCALL _lcd_pulse
; 0002 0015 
; 0002 0016     // ????? 4 ??? ?? ????
; 0002 0017     LCD_D4 = (value >> 0) & 1;
	LDD  R30,Y+1
	ANDI R30,LOW(0x1)
	BRNE _0x40011
	CBI  0x15,2
	RJMP _0x40012
_0x40011:
	SBI  0x15,2
_0x40012:
; 0002 0018     LCD_D5 = (value >> 1) & 1;
	LDD  R30,Y+1
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x40013
	CBI  0x15,3
	RJMP _0x40014
_0x40013:
	SBI  0x15,3
_0x40014:
; 0002 0019     LCD_D6 = (value >> 2) & 1;
	LDD  R30,Y+1
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x40015
	CBI  0x15,4
	RJMP _0x40016
_0x40015:
	SBI  0x15,4
_0x40016:
; 0002 001A     LCD_D7 = (value >> 3) & 1;
	LDD  R30,Y+1
	LSR  R30
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x40017
	CBI  0x15,5
	RJMP _0x40018
_0x40017:
	SBI  0x15,5
_0x40018:
; 0002 001B     lcd_pulse();
	RCALL _lcd_pulse
; 0002 001C }
	RJMP _0x2060005
; .FEND
;
;void lcd_init(void) {
; 0002 001E void lcd_init(void) {
_lcd_init:
; .FSTART _lcd_init
; 0002 001F     LCD_DDR |= 0x3F; // ????? 6 ??? ??? ???? C ?? ????? ?????
	IN   R30,0x14
	ORI  R30,LOW(0x3F)
	OUT  0x14,R30
; 0002 0020     LCD_RS = 0; LCD_EN = 0;
	CBI  0x15,0
	CBI  0x15,1
; 0002 0021     wait_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _wait_ms
; 0002 0022 
; 0002 0023     lcd_send(0x02, 0); // ?????? ?? ???? (???? 4 ???)
	LDI  R30,LOW(2)
	CALL SUBOPT_0x1
; 0002 0024     lcd_send(0x28, 0); // 4-bit, 2 lines
	LDI  R30,LOW(40)
	CALL SUBOPT_0x1
; 0002 0025     lcd_send(0x0C, 0); // Display ON, Cursor OFF
	LDI  R30,LOW(12)
	CALL SUBOPT_0x1
; 0002 0026     lcd_send(0x06, 0); // Entry mode
	LDI  R30,LOW(6)
	CALL SUBOPT_0x1
; 0002 0027     lcd_clear();
	RCALL _lcd_clear
; 0002 0028 }
	RET
; .FEND
;
;void lcd_clear(void) {
; 0002 002A void lcd_clear(void) {
_lcd_clear:
; .FSTART _lcd_clear
; 0002 002B     lcd_send(0x01, 0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1
; 0002 002C     wait_ms(2);
	LDI  R26,LOW(2)
_0x2060007:
	LDI  R27,0
	RCALL _wait_ms
; 0002 002D }
	RET
; .FEND
;
;void lcd_putc(char c) {
; 0002 002F void lcd_putc(char c) {
_lcd_putc:
; .FSTART _lcd_putc
; 0002 0030     lcd_send(c, 1);
	ST   -Y,R26
;	c -> Y+0
	LD   R30,Y
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_send
; 0002 0031 }
_0x2060006:
	ADIW R28,1
	RET
; .FEND
;
;void lcd_print(char* str) {
; 0002 0033 void lcd_print(char* str) {
_lcd_print:
; .FSTART _lcd_print
; 0002 0034     while(*str) {
	ST   -Y,R27
	ST   -Y,R26
;	*str -> Y+0
_0x4001D:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x4001F
; 0002 0035         lcd_putc(*str++);
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	MOV  R26,R30
	RCALL _lcd_putc
; 0002 0036     }
	RJMP _0x4001D
_0x4001F:
; 0002 0037 }
_0x2060005:
	ADIW R28,2
	RET
; .FEND
;
;void lcd_gotoxy(unsigned char x, unsigned char y) {
; 0002 0039 void lcd_gotoxy(unsigned char x, unsigned char y) {
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
; 0002 003A     unsigned char addr = (y == 0) ? (0x80 + x) : (0xC0 + x);
; 0002 003B     lcd_send(addr, 0);
	ST   -Y,R26
	ST   -Y,R17
;	x -> Y+2
;	y -> Y+1
;	addr -> R17
	LDD  R26,Y+1
	CPI  R26,LOW(0x0)
	BRNE _0x40020
	LDD  R30,Y+2
	LDI  R31,0
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	RJMP _0x40021
_0x40020:
	LDD  R30,Y+2
	LDI  R31,0
	SUBI R30,LOW(-192)
	SBCI R31,HIGH(-192)
_0x40021:
	MOV  R17,R30
	ST   -Y,R17
	LDI  R26,LOW(0)
	RCALL _lcd_send
; 0002 003C }
	LDD  R17,Y+0
_0x2060004:
	ADIW R28,3
	RET
; .FEND
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
;#include "hal_timer.h"
;
;volatile unsigned long g_millis = 0;
;
;// وقفه مقایسه تایمر صفر (هر 1 میلی‌ثانیه اجرا می‌شود)
;interrupt [TIM0_COMP] void timer0_comp_isr(void) {
; 0003 0007 interrupt [11] void timer0_comp_isr(void) {

	.CSEG
_timer0_comp_isr:
; .FSTART _timer0_comp_isr
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0003 0008     g_millis++;
	LDI  R26,LOW(_g_millis)
	LDI  R27,HIGH(_g_millis)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0003 0009 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
; .FEND
;
;void timer_init(void) {
; 0003 000B void timer_init(void) {
_timer_init:
; .FSTART _timer_init
; 0003 000C     TCNT0 = 0;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0003 000D     OCR0 = 124; // تنظیم برای 1 میلی‌ثانیه با کلاک 8MHz و Prescaler=64
	LDI  R30,LOW(124)
	OUT  0x3C,R30
; 0003 000E     TCCR0 = (1<<WGM01) | (1<<CS01) | (1<<CS00); // حالت CTC
	LDI  R30,LOW(11)
	OUT  0x33,R30
; 0003 000F     TIMSK |= (1<<OCIE0);
	IN   R30,0x39
	ORI  R30,2
	OUT  0x39,R30
; 0003 0010     #asm("sei") // فعال‌سازی وقفه‌های سراسری
	sei
; 0003 0011 }
	RET
; .FEND
;
;unsigned long millis(void) {
; 0003 0013 unsigned long millis(void) {
_millis:
; .FSTART _millis
; 0003 0014     unsigned long time;
; 0003 0015     #asm("cli")
	SBIW R28,4
;	time -> Y+0
	cli
; 0003 0016     time = g_millis;
	LDS  R30,_g_millis
	LDS  R31,_g_millis+1
	LDS  R22,_g_millis+2
	LDS  R23,_g_millis+3
	CALL __PUTD1S0
; 0003 0017     #asm("sei")
	sei
; 0003 0018     return time;
	CALL __GETD1S0
	ADIW R28,4
	RET
; 0003 0019 }
; .FEND
;
;// تابع جایگزین delay_ms که برنامه را فریز نمی‌کند و وقفه‌ها کار می‌ک� ...
;void wait_ms(unsigned int ms) {
; 0003 001C void wait_ms(unsigned int ms) {
_wait_ms:
; .FSTART _wait_ms
; 0003 001D     unsigned long start = millis();
; 0003 001E     while((millis() - start) < ms);
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
;	ms -> Y+4
;	start -> Y+0
	RCALL _millis
	CALL __PUTD1S0
_0x60003:
	RCALL _millis
	CALL __GETD2S0
	CALL __SUBD12
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRLO _0x60003
; 0003 001F }
	ADIW R28,6
	RET
; .FEND
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
;#include <stdio.h>
;#include <string.h>
;
;#include "config.h"
;#include "hal_timer.h"
;#include "hal_lcd.h"
;#include "hal_keypad.h"
;#include "app_lock.h"
;
;// ????? ???? ?????? ???? ???? ????? ???? ??????? ??? ???
;char ui_get_key(void) {
; 0004 000C char ui_get_key(void) {

	.CSEG
_ui_get_key:
; .FSTART _ui_get_key
; 0004 000D     char key;
; 0004 000E     while(1) {
	ST   -Y,R17
;	key -> R17
_0x80003:
; 0004 000F         lock_update_task(); // ?? ???? ????? ??? ?? ????????
	CALL _lock_update_task
; 0004 0010         key = keypad_read();
	CALL _keypad_read
	MOV  R17,R30
; 0004 0011         if(key != 0) {
	CPI  R17,0
	BREQ _0x80006
; 0004 0012             wait_ms(20); // ????????? (Debounce)
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _wait_ms
; 0004 0013             if (keypad_read() == key) {
	CALL _keypad_read
	CP   R17,R30
	BRNE _0x80007
; 0004 0014                 // ??? ?????? ?? ????? ???? ?? ?? ??? ???? ??????
; 0004 0015                 while(keypad_read() != 0) lock_update_task();
_0x80008:
	CALL _keypad_read
	CPI  R30,0
	BREQ _0x8000A
	CALL _lock_update_task
	RJMP _0x80008
_0x8000A:
; 0004 0016 return key;
	MOV  R30,R17
	RJMP _0x2060003
; 0004 0017             }
; 0004 0018         }
_0x80007:
; 0004 0019     }
_0x80006:
	RJMP _0x80003
; 0004 001A }
_0x2060003:
	LD   R17,Y+
	RET
; .FEND
;
;// ?? ???? ???? ???? ????? ????? (??? ?? ???)
;// ??? is_password ????? 1 ????? ????? ??? ??????
;int get_input(char* buffer, int max_len, int is_password) {
; 0004 001E int get_input(char* buffer, int max_len, int is_password) {
_get_input:
; .FSTART _get_input
; 0004 001F     int idx = 0;
; 0004 0020     char key;
; 0004 0021     buffer[0] = '\0';
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	*buffer -> Y+8
;	max_len -> Y+6
;	is_password -> Y+4
;	idx -> R16,R17
;	key -> R19
	CALL SUBOPT_0x2
; 0004 0022 
; 0004 0023     lcd_gotoxy(0, 1);
; 0004 0024     lcd_print("                ");
	__POINTW2MN _0x8000B,0
	CALL SUBOPT_0x3
; 0004 0025     lcd_gotoxy(0, 1);
; 0004 0026 
; 0004 0027     while(1) {
_0x8000C:
; 0004 0028         key = ui_get_key();
	RCALL _ui_get_key
	MOV  R19,R30
; 0004 0029 
; 0004 002A         if(key == '#') { // ?????
	CPI  R19,35
	BRNE _0x8000F
; 0004 002B             if(idx == max_len) return 1;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x80010
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x2060002
; 0004 002C             else {
_0x80010:
; 0004 002D                 lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4
; 0004 002E                 lcd_print("Len Must Be "); lcd_putc(max_len + '0');
	__POINTW2MN _0x8000B,17
	CALL _lcd_print
	LDD  R26,Y+6
	SUBI R26,-LOW(48)
	CALL _lcd_putc
; 0004 002F                 wait_ms(1500);
	CALL SUBOPT_0x5
; 0004 0030                 return 0; // ??? ?? ??? ?????
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2060002
; 0004 0031             }
; 0004 0032         }
; 0004 0033         else if(key == '*') { // ??? ???? ?? ????? (Clear)
_0x8000F:
	CPI  R19,42
	BRNE _0x80013
; 0004 0034             idx = 0;
	CALL SUBOPT_0x2
; 0004 0035             buffer[0] = '\0';
; 0004 0036             lcd_gotoxy(0, 1);
; 0004 0037             lcd_print("                ");
	__POINTW2MN _0x8000B,30
	CALL SUBOPT_0x3
; 0004 0038             lcd_gotoxy(0, 1);
; 0004 0039         }
; 0004 003A         else if(key == 'C') { // پاک کردن کل ورودی (روی کیپد دکمه ON/C)
	RJMP _0x80014
_0x80013:
	CPI  R19,67
	BRNE _0x80015
; 0004 003B             idx = 0;
	CALL SUBOPT_0x2
; 0004 003C             buffer[0] = '\0';
; 0004 003D             lcd_gotoxy(0, 1);
; 0004 003E             lcd_print("                ");
	__POINTW2MN _0x8000B,47
	CALL SUBOPT_0x3
; 0004 003F             lcd_gotoxy(0, 1);
; 0004 0040         }
; 0004 0041         else if(key == '-') { // انصراف / بازگشت
	RJMP _0x80016
_0x80015:
	CPI  R19,45
	BRNE _0x80017
; 0004 0042             return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2060002
; 0004 0043         }
; 0004 0044         else if(key >= '0' && key <= '9') {
_0x80017:
	CPI  R19,48
	BRLO _0x8001A
	CPI  R19,58
	BRLO _0x8001B
_0x8001A:
	RJMP _0x80019
_0x8001B:
; 0004 0045             if(idx < max_len) {
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x8001C
; 0004 0046                 buffer[idx] = key;
	MOVW R30,R16
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R19
; 0004 0047                 idx++;
	__ADDWRN 16,17,1
; 0004 0048                 buffer[idx] = '\0';
	MOVW R30,R16
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0004 0049 
; 0004 004A                 lcd_gotoxy(idx - 1, 1);
	MOV  R30,R16
	SUBI R30,LOW(1)
	CALL SUBOPT_0x4
; 0004 004B                 if(is_password) lcd_putc('*');
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BREQ _0x8001D
	LDI  R26,LOW(42)
	RJMP _0x8004B
; 0004 004C                 else lcd_putc(key);
_0x8001D:
	MOV  R26,R19
_0x8004B:
	CALL _lcd_putc
; 0004 004D             }
; 0004 004E         }
_0x8001C:
; 0004 004F     }
_0x80019:
_0x80016:
_0x80014:
	RJMP _0x8000C
; 0004 0050 }
_0x2060002:
	CALL __LOADLOCR4
	ADIW R28,10
	RET
; .FEND

	.DSEG
_0x8000B:
	.BYTE 0x40
;
;// ??? ??? ????? ?? ?? ???????? ?????
;void system_lockdown(void) {
; 0004 0053 void system_lockdown(void) {

	.CSEG
_system_lockdown:
; .FSTART _system_lockdown
; 0004 0054     int wait_time = 15; // 15 ????? ??? ??????
; 0004 0055     unsigned long last_sec = millis();
; 0004 0056     char buf[16];
; 0004 0057 
; 0004 0058     lcd_clear();
	SBIW R28,20
	ST   -Y,R17
	ST   -Y,R16
;	wait_time -> R16,R17
;	last_sec -> Y+18
;	buf -> Y+2
	__GETWRN 16,17,15
	CALL SUBOPT_0x6
	CALL _lcd_clear
; 0004 0059     lcd_print("SYSTEM LOCKED!");
	__POINTW2MN _0x8001F,0
	CALL _lcd_print
; 0004 005A 
; 0004 005B     while(wait_time > 0) {
_0x80020:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRGE _0x80022
; 0004 005C         lock_update_task();
	CALL _lock_update_task
; 0004 005D         if(millis() - last_sec >= 1000) {
	RCALL _millis
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 18
	CALL __SUBD21
	__CPD2N 0x3E8
	BRLO _0x80023
; 0004 005E             last_sec = millis();
	CALL SUBOPT_0x6
; 0004 005F             wait_time--;
	__SUBWRN 16,17,1
; 0004 0060             sprintf(buf, "Wait %2d sec   ", wait_time);
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x80000,45
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0004 0061             lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4
; 0004 0062             lcd_print(buf);
	MOVW R26,R28
	ADIW R26,2
	CALL _lcd_print
; 0004 0063         }
; 0004 0064     }
_0x80023:
	RJMP _0x80020
_0x80022:
; 0004 0065     lock_reset_failures();
	CALL _lock_reset_failures
; 0004 0066 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,22
	RET
; .FEND

	.DSEG
_0x8001F:
	.BYTE 0xF
;
;// منوی مدیریت
;void admin_menu(void) {
; 0004 0069 void admin_menu(void) {

	.CSEG
_admin_menu:
; .FSTART _admin_menu
; 0004 006A     char key;
; 0004 006B     char buf[10];
; 0004 006C 
; 0004 006D     while(1) {
	SBIW R28,10
	ST   -Y,R17
;	key -> R17
;	buf -> Y+1
_0x80024:
; 0004 006E         lcd_clear();
	CALL _lcd_clear
; 0004 006F         lcd_print("1:UsrPsw 2:AdmPs");
	__POINTW2MN _0x80027,0
	CALL SUBOPT_0x3
; 0004 0070         lcd_gotoxy(0, 1);
; 0004 0071         lcd_print("3:Tries  4:Len");
	__POINTW2MN _0x80027,17
	CALL _lcd_print
; 0004 0072 
; 0004 0073         key = ui_get_key();
	RCALL _ui_get_key
	MOV  R17,R30
; 0004 0074 
; 0004 0075         if(key == '1') {
	CPI  R17,49
	BRNE _0x80028
; 0004 0076             lcd_clear(); lcd_print("New User Pass:");
	CALL _lcd_clear
	__POINTW2MN _0x80027,32
	CALL SUBOPT_0x7
; 0004 0077             if(get_input(buf, lock_get_pass_len(), 1)) {
	BREQ _0x80029
; 0004 0078                 lock_set_password(buf, ROLE_USER);
	CALL SUBOPT_0x8
	LDI  R26,LOW(0)
	CALL _lock_set_password
; 0004 0079                 lcd_clear(); lcd_print("Saved!"); wait_ms(1000);
	CALL _lcd_clear
	__POINTW2MN _0x80027,47
	CALL SUBOPT_0x9
; 0004 007A             }
; 0004 007B         }
_0x80029:
; 0004 007C         else if(key == '2') {
	RJMP _0x8002A
_0x80028:
	CPI  R17,50
	BRNE _0x8002B
; 0004 007D             lcd_clear(); lcd_print("New Admin Pass:");
	CALL _lcd_clear
	__POINTW2MN _0x80027,54
	CALL SUBOPT_0x7
; 0004 007E             if(get_input(buf, lock_get_pass_len(), 1)) {
	BREQ _0x8002C
; 0004 007F                 lock_set_password(buf, ROLE_ADMIN);
	CALL SUBOPT_0x8
	LDI  R26,LOW(1)
	CALL _lock_set_password
; 0004 0080                 lcd_clear(); lcd_print("Saved!"); wait_ms(1000);
	CALL _lcd_clear
	__POINTW2MN _0x80027,70
	CALL SUBOPT_0x9
; 0004 0081             }
; 0004 0082         }
_0x8002C:
; 0004 0083         else if(key == '3') {
	RJMP _0x8002D
_0x8002B:
	CPI  R17,51
	BRNE _0x8002E
; 0004 0084             lcd_clear(); lcd_print("Set Max Tries:");
	CALL _lcd_clear
	__POINTW2MN _0x80027,77
	CALL _lcd_print
; 0004 0085             if(get_input(buf, 1, 0)) {
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
	BREQ _0x8002F
; 0004 0086                 lock_set_max_tries(buf[0] - '0');
	LDD  R26,Y+1
	SUBI R26,LOW(48)
	CALL _lock_set_max_tries
; 0004 0087                 lcd_clear(); lcd_print("Saved!"); wait_ms(1000);
	CALL _lcd_clear
	__POINTW2MN _0x80027,92
	CALL SUBOPT_0x9
; 0004 0088             }
; 0004 0089         }
_0x8002F:
; 0004 008A         else if(key == '4') {
	RJMP _0x80030
_0x8002E:
	CPI  R17,52
	BRNE _0x80031
; 0004 008B             lcd_clear(); lcd_print("Set Length(4-8):");
	CALL _lcd_clear
	__POINTW2MN _0x80027,99
	CALL _lcd_print
; 0004 008C             if(get_input(buf, 1, 0)) {
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
	BREQ _0x80032
; 0004 008D                 int new_len = buf[0] - '0';
; 0004 008E                 if(new_len >= 4 && new_len <= 8) {
	SBIW R28,2
;	buf -> Y+3
;	new_len -> Y+0
	LDD  R30,Y+3
	LDI  R31,0
	SBIW R30,48
	ST   Y,R30
	STD  Y+1,R31
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRLT _0x80034
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,9
	BRLT _0x80035
_0x80034:
	RJMP _0x80033
_0x80035:
; 0004 008F                     lock_set_pass_len(new_len);
	LD   R26,Y
	CALL _lock_set_pass_len
; 0004 0090                     lcd_clear(); lcd_print("Saved! Plz Reset");
	CALL _lcd_clear
	__POINTW2MN _0x80027,116
	RJMP _0x8004C
; 0004 0091                     wait_ms(1000);
; 0004 0092                 } else {
_0x80033:
; 0004 0093                     lcd_clear(); lcd_print("Invalid Length!");
	CALL _lcd_clear
	__POINTW2MN _0x80027,133
_0x8004C:
	CALL _lcd_print
; 0004 0094                     wait_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _wait_ms
; 0004 0095                 }
; 0004 0096             }
	ADIW R28,2
; 0004 0097         }
_0x80032:
; 0004 0098         else if(key == '-' || key == '+') { // دکمه‌های خروج
	RJMP _0x80037
_0x80031:
	CPI  R17,45
	BREQ _0x80039
	CPI  R17,43
	BRNE _0x80038
_0x80039:
; 0004 0099             break;
	RJMP _0x80026
; 0004 009A         }
; 0004 009B     }
_0x80038:
_0x80037:
_0x80030:
_0x8002D:
_0x8002A:
	RJMP _0x80024
_0x80026:
; 0004 009C }
	LDD  R17,Y+0
	ADIW R28,11
	RET
; .FEND

	.DSEG
_0x80027:
	.BYTE 0x95
;
;void main(void) {
; 0004 009E void main(void) {

	.CSEG
_main:
; .FSTART _main
; 0004 009F     char key;
; 0004 00A0     char input_buffer[10];
; 0004 00A1 
; 0004 00A2     timer_init();
	SBIW R28,10
;	key -> R17
;	input_buffer -> Y+0
	RCALL _timer_init
; 0004 00A3     lcd_init();
	CALL _lcd_init
; 0004 00A4     keypad_init();
	CALL _keypad_init
; 0004 00A5     lock_init();
	CALL _lock_init
; 0004 00A6 
; 0004 00A7     lcd_clear();
	CALL _lcd_clear
; 0004 00A8     lcd_print("  Digital Lock  ");
	__POINTW2MN _0x8003B,0
	CALL SUBOPT_0x3
; 0004 00A9     lcd_gotoxy(0, 1);
; 0004 00AA     lcd_print(" Starting...    ");
	__POINTW2MN _0x8003B,17
	CALL SUBOPT_0xB
; 0004 00AB     wait_ms(1500);
; 0004 00AC 
; 0004 00AD     while (1) {
_0x8003C:
; 0004 00AE         lock_update_task();
	CALL _lock_update_task
; 0004 00AF 
; 0004 00B0         lcd_clear();
	CALL _lcd_clear
; 0004 00B1         lcd_print("/: User  *:Admin"); // تغییر راهنما روی LCD
	__POINTW2MN _0x8003B,34
	CALL SUBOPT_0x3
; 0004 00B2         lcd_gotoxy(0, 1);
; 0004 00B3         lcd_print("Select Mode...");
	__POINTW2MN _0x8003B,51
	CALL _lcd_print
; 0004 00B4 
; 0004 00B5         key = ui_get_key();
	RCALL _ui_get_key
	MOV  R17,R30
; 0004 00B6 
; 0004 00B7         if (key == '/') { // تغییر دکمه حالت کاربر به /
	CPI  R17,47
	BRNE _0x8003F
; 0004 00B8             lcd_clear();
	CALL _lcd_clear
; 0004 00B9             lcd_print("User Password:");
	__POINTW2MN _0x8003B,66
	CALL SUBOPT_0xC
; 0004 00BA             if (get_input(input_buffer, lock_get_pass_len(), 1)) {
	BREQ _0x80040
; 0004 00BB                 if (lock_verify_password(input_buffer, ROLE_USER)) {
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lock_verify_password
	SBIW R30,0
	BREQ _0x80041
; 0004 00BC                     lock_reset_failures();
	CALL _lock_reset_failures
; 0004 00BD                     lock_open_door();
	CALL _lock_open_door
; 0004 00BE                     lcd_clear(); lcd_print("Access Granted");
	CALL _lcd_clear
	__POINTW2MN _0x8003B,81
	CALL SUBOPT_0x3
; 0004 00BF                     lcd_gotoxy(0, 1); lcd_print("Door Opened");
	__POINTW2MN _0x8003B,96
	CALL _lcd_print
; 0004 00C0                     wait_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _wait_ms
; 0004 00C1                 } else {
	RJMP _0x80042
_0x80041:
; 0004 00C2                     lock_register_failure();
	CALL _lock_register_failure
; 0004 00C3                     lcd_clear(); lcd_print("Wrong Password!");
	CALL _lcd_clear
	__POINTW2MN _0x8003B,108
	CALL SUBOPT_0xB
; 0004 00C4                     wait_ms(1500);
; 0004 00C5                     if(lock_get_failed_attempts() >= lock_get_max_tries()) {
	CALL _lock_get_failed_attempts
	PUSH R30
	CALL _lock_get_max_tries
	POP  R26
	CP   R26,R30
	BRLO _0x80043
; 0004 00C6                         system_lockdown();
	RCALL _system_lockdown
; 0004 00C7                     }
; 0004 00C8                 }
_0x80043:
_0x80042:
; 0004 00C9             }
; 0004 00CA         }
_0x80040:
; 0004 00CB         else if (key == '*') { // تغییر دکمه حالت مدیر به *
	RJMP _0x80044
_0x8003F:
	CPI  R17,42
	BRNE _0x80045
; 0004 00CC             lcd_clear();
	CALL _lcd_clear
; 0004 00CD             lcd_print("Admin Password:");
	__POINTW2MN _0x8003B,124
	CALL SUBOPT_0xC
; 0004 00CE             if (get_input(input_buffer, lock_get_pass_len(), 1)) {
	BREQ _0x80046
; 0004 00CF                 if (lock_verify_password(input_buffer, ROLE_ADMIN)) {
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lock_verify_password
	SBIW R30,0
	BREQ _0x80047
; 0004 00D0                     lock_reset_failures();
	CALL _lock_reset_failures
; 0004 00D1                     lcd_clear(); lcd_print("Admin Verified!");
	CALL _lcd_clear
	__POINTW2MN _0x8003B,140
	CALL SUBOPT_0x9
; 0004 00D2                     wait_ms(1000);
; 0004 00D3                     admin_menu();
	RCALL _admin_menu
; 0004 00D4                 } else {
	RJMP _0x80048
_0x80047:
; 0004 00D5                     lock_register_failure();
	CALL _lock_register_failure
; 0004 00D6                     lcd_clear(); lcd_print("Wrong Password!");
	CALL _lcd_clear
	__POINTW2MN _0x8003B,156
	CALL SUBOPT_0xB
; 0004 00D7                     wait_ms(1500);
; 0004 00D8                     if(lock_get_failed_attempts() >= lock_get_max_tries()) {
	CALL _lock_get_failed_attempts
	PUSH R30
	CALL _lock_get_max_tries
	POP  R26
	CP   R26,R30
	BRLO _0x80049
; 0004 00D9                         system_lockdown();
	RCALL _system_lockdown
; 0004 00DA                     }
; 0004 00DB                 }
_0x80049:
_0x80048:
; 0004 00DC             }
; 0004 00DD         }
_0x80046:
; 0004 00DE     }
_0x80045:
_0x80044:
	RJMP _0x8003C
; 0004 00DF }
_0x8004A:
	RJMP _0x8004A
; .FEND

	.DSEG
_0x8003B:
	.BYTE 0xAC

	.CSEG
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
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
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0xD
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0xD
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0xE
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xF
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0xE
	CALL SUBOPT_0x10
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0xE
	CALL SUBOPT_0x10
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0xE
	CALL SUBOPT_0x11
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0xE
	CALL SUBOPT_0x11
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0xD
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0xD
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xF
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0xD
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xF
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x12
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2060001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x12
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2060001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.DSEG
_user_pass_G000:
	.BYTE 0xA
_admin_pass_G000:
	.BYTE 0xA
_max_tries_G000:
	.BYTE 0x1
_pass_len_G000:
	.BYTE 0x1
_failed_attempts_G000:
	.BYTE 0x1
_door_open_time_G000:
	.BYTE 0x4
_is_door_open_G000:
	.BYTE 0x1
_g_millis:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	CALL _strcmp
	LDI  R26,LOW(0)
	CALL __EQB12
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_send

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2:
	__GETWRN 16,17,0
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x3:
	CALL _lcd_print
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	JMP  _wait_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL _millis
	__PUTD1S 18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7:
	CALL _lcd_print
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL _lock_get_pass_len
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _get_input
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	CALL _lcd_print
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _wait_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	CALL _get_input
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	CALL _lcd_print
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xC:
	CALL _lcd_print
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	CALL _lock_get_pass_len
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _get_input
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
