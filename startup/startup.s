.syntax unified
.cpu cortex-m4
.fpu fpv4-sp-d16
.thumb

# TODO .data is aligned by 4 so i can copy word by word and skip half-word and byte copy
CopyData_ToSRAM:
    # Set stack pointer
    LDR sp, =_estack
    LDR r0, =_sdata
    LDR r1, =_edata
    # This will be the start of .data
    LDR r2, =_etext
    # Calculate size of .data
    SUBS r3,r1,r0
    # Calculate how many words to copy
    LSRS r4,r3,#2
    B CopyData_Word

CopyData_Word:
    CBZ r4, CopyData_HalfWord
    # Load address of _etext in r5 and increment r2 by 4
    LDR r5, [r2], #4
    # Store in r5 4 bytes of .data and increment _sdata by 4
    STR r5, [r0], #4
    SUBS r3,r3,#4
    SUBS r4,r4,#1
    B CopyData_Word

CopyData_HalfWord:
    # Calculate how many half-words to copy(at most it will be 1)
    LSRS r4,r3,#1
    CBZ r4, CopyData_Byte
    LDRH r5, [r2], #2
    STRH r5, [r0], #2
    SUBS r3,r3,#2
    SUBS r4,r4,#1
    B CopyData_HalfWord


CopyData_Byte:
    # There will never be more than 1 byte to copy here
    CBZ r4, Init_Bss
    LDRB r5, [r2], #1
    STRB r5, [r0], #1
    B Init_Bss

Init_Bss:
    LDR r1, = _ebss
    LDR r2, = _sbss
    # Calculate size in bytes of .bss
    SUBS r3,r1,r2
    # Calculate how many words to zero(.bss is aligned to 4 so it should always work with words)
    LSR r3,r3,#2
    MOVS r4,#0
    B Zero_Bss

Zero_Bss:
    CBZ r3, Call_Main
    STR r4, [r2], #4
    SUBS r3,r3,#1
    B Zero_Bss

Call_Main:
    B main
    B Infinite_Loop

Infinite_Loop:
    B Infinite_Loop

.global Reset_Handler
Reset_Handler:
    B CopyData_ToSRAM

Default_Handler:
	B Default_Handler

.section	.isr_vector,"a",%progbits
.type	vector_table, %object
.size	vector_table, .-vector_table

vector_table:
	.word	_estack
	.word	Reset_Handler
	.word	NMI_Handler
	.word	HardFault_Handler
	.word	MemManage_Handler
	.word	BusFault_Handler
	.word	UsageFault_Handler
	.word	0
	.word	0
	.word	0
	.word	0
	.word	SVC_Handler
	.word	DebugMon_Handler
	.word	0
	.word	PendSV_Handler
	.word	SysTick_Handler
	.word	WWDG_IRQHandler
	.word	PVD_IRQHandler
	.word	TAMP_STAMP_IRQHandler
	.word	RTC_WKUP_IRQHandler
	.word	FLASH_IRQHandler
	.word	RCC_IRQHandler
	.word	EXTI0_IRQHandler
	.word	EXTI1_IRQHandler
	.word	EXTI2_TSC_IRQHandler
	.word	EXTI3_IRQHandler
	.word	EXTI4_IRQHandler
	.word	DMA1_Channel1_IRQHandler
	.word	DMA1_Channel2_IRQHandler
	.word	DMA1_Channel3_IRQHandler
	.word	DMA1_Channel4_IRQHandler
	.word	DMA1_Channel5_IRQHandler
	.word	DMA1_Channel6_IRQHandler
	.word	DMA1_Channel7_IRQHandler
	.word	ADC1_2_IRQHandler
	.word	USB_HP_CAN_TX_IRQHandler
	.word	USB_LP_CAN_RX0_IRQHandler
	.word	CAN_RX1_IRQHandler
	.word	CAN_SCE_IRQHandler
	.word	EXTI9_5_IRQHandler
	.word	TIM1_BRK_TIM15_IRQHandler
	.word	TIM1_UP_TIM16_IRQHandler
	.word	TIM1_TRG_COM_TIM17_IRQHandler
	.word	TIM1_CC_IRQHandler
	.word	TIM2_IRQHandler
	.word	TIM3_IRQHandler
	.word	TIM4_IRQHandler
	.word	I2C1_EV_IRQHandler
	.word	I2C1_ER_IRQHandler
	.word	I2C2_EV_IRQHandler
	.word	I2C2_ER_IRQHandler
	.word	SPI1_IRQHandler
	.word	SPI2_IRQHandler
	.word	USART1_IRQHandler
	.word	USART2_IRQHandler
	.word	USART3_IRQHandler
	.word	EXTI15_10_IRQHandler
	.word	RTC_Alarm_IRQHandler
	.word	USBWakeUp_IRQHandler
	.word	TIM8_BRK_IRQHandler
	.word	TIM8_UP_IRQHandler
	.word	TIM8_TRG_COM_IRQHandler
	.word	TIM8_CC_IRQHandler
	.word	ADC3_IRQHandler
	.word	FMC_IRQHandler
	.word	0
	.word	0
	.word	SPI3_IRQHandler
	.word	UART4_IRQHandler
	.word	UART5_IRQHandler
	.word	TIM6_DAC_IRQHandler
	.word	TIM7_IRQHandler
	.word	DMA2_Channel1_IRQHandler
	.word	DMA2_Channel2_IRQHandler
	.word	DMA2_Channel3_IRQHandler
	.word	DMA2_Channel4_IRQHandler
	.word	DMA2_Channel5_IRQHandler
	.word	ADC4_IRQHandler
	.word	0
	.word	0
	.word	COMP1_2_3_IRQHandler
	.word	COMP4_5_6_IRQHandler
	.word	COMP7_IRQHandler
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	I2C3_EV_IRQHandler
	.word	I2C3_ER_IRQHandler
	.word	USB_HP_IRQHandler
	.word	USB_LP_IRQHandler
	.word	USBWakeUp_RMP_IRQHandler
	.word	TIM20_BRK_IRQHandler
	.word	TIM20_UP_IRQHandler
	.word	TIM20_TRG_COM_IRQHandler
	.word	TIM20_CC_IRQHandler
	.word	FPU_IRQHandler
	.word	0
	.word	0
	.word	SPI4_IRQHandler

    .weak	NMI_Handler
    .thumb_set NMI_Handler,Default_Handler

    .weak	HardFault_Handler
    .thumb_set HardFault_Handler,Default_Handler

    .weak	MemManage_Handler
    .thumb_set MemManage_Handler,Default_Handler

    .weak	BusFault_Handler
    .thumb_set BusFault_Handler,Default_Handler

    .weak	UsageFault_Handler
    .thumb_set UsageFault_Handler,Default_Handler

    .weak	SVC_Handler
    .thumb_set SVC_Handler,Default_Handler

    .weak	DebugMon_Handler
    .thumb_set DebugMon_Handler,Default_Handler