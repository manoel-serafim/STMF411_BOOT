/**
 * @file    startup.c
 * @brief   Startup file for STM32F411CEU6, including vector table and interrupt handlers.
 *          This file defines the initialization code, interrupt vector table, and default
 *          handlers for all exceptions and interrupts. It also includes routines to copy
 *          initialized data from FLASH to SRAM, zero-fill the BSS section, and initialize
 *          the system before transferring control to the main application.
 * 
 * @note    The interrupt vector table is initialized with default handlers which are weakly
 *          bound to the default interrupt handler, allowing for custom implementations to be
 *          added in separate source files. The system stack pointer is initialized, and the
 *          vector table is set up at startup.
 * 
 * @processor    ARM Cortex-M4
 * @microcontroller STM32F411CEU6
 * @version   1.0
 * @date      2025-01-18
 * 
 * @section VectorTable
 * The vector table contains the reset vector, exception vectors, and IRQ handlers.
 * It is placed at the beginning of memory and is used by the processor to determine
 * the appropriate handler for each exception or interrupt.
 * 
 * @section DataInitialization
 * This file includes assembly routines to copy the .data section from FLASH to SRAM
 * and zero the .bss section before transferring control to the main program.
 *
 * @section InterruptHandlers
 * The interrupt vector table contains weak references to the interrupt handlers.
 * Default implementations for common interrupts (such as HardFault and NMI) are provided.
 * These handlers simply enter an infinite loop, preserving the system state for debugging.
 * Custom interrupt handler implementations can be added by defining them in the user code.
 *
 *
 * @copyright  (C) 2025, Manoel Augusto de Souza Serafim
 *             All rights reserved.
 * 
 * @author     Manoel Serafim
 * @email      manoel.serafim@proton.me
 * @date       2025-01-15
 * @github     https://github.com/manoel-serafim
 */

.global reset_
.global vector_table__
.cpu cortex-m4
.thumb

.section .isr_vector,"a",%progbits
.type vector_table__, %object
vector_table__:
  .word _estack
  .word reset_
  .word NMI_Handler
  .word HardFault_Handler
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
  .word	WWDG_IRQHandler              			/* Window Watchdog interrupt                                          */
  .word	PVD_IRQHandler               			/* EXTI Line 16 interrupt / PVD through EXTI                          */
  .word	TAMP_STAMP_IRQHandler        			/* Tamper and TimeStamp interrupts through                            */
  .word	RTC_WKUP_IRQHandler          			/* RTC Wakeup interrupt through the EXTI line                         */
  .word	FLASH_IRQHandler             			/* FLASH global interrupt                                             */
  .word	RCC_IRQHandler               			/* RCC global interrupt                                               */
  .word	EXTI0_IRQHandler             			/* EXTI Line0 interrupt                                               */
  .word	EXTI1_IRQHandler             			/* EXTI Line1 interrupt                                               */
  .word	EXTI2_IRQHandler             			/* EXTI Line2 interrupt                                               */
  .word	EXTI3_IRQHandler             			/* EXTI Line3 interrupt                                               */
  .word	EXTI4_IRQHandler             			/* EXTI Line4 interrupt                                               */
  .word	DMA1_Stream0_IRQHandler      			/* DMA1 Stream0 global interrupt                                      */
  .word	DMA1_Stream1_IRQHandler      			/* DMA1 Stream1 global interrupt                                      */
  .word	DMA1_Stream2_IRQHandler      			/* DMA1 Stream2 global interrupt                                      */
  .word	DMA1_Stream3_IRQHandler      			/* DMA1 Stream3 global interrupt                                      */
  .word	DMA1_Stream4_IRQHandler      			/* DMA1 Stream4 global interrupt                                      */
  .word	DMA1_Stream5_IRQHandler      			/* DMA1 Stream5 global interrupt                                      */
  .word	DMA1_Stream6_IRQHandler      			/* DMA1 Stream6 global interrupt                                      */
  .word	ADC_IRQHandler               			/* ADC1 global interrupt                                              */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	EXTI9_5_IRQHandler           			/* EXTI Line[9:5] interrupts                                          */
  .word	TIM1_BRK_TIM9_IRQHandler     			/* TIM1 Break interrupt and TIM9 global interrupt                     */
  .word	TIM1_UP_TIM10_IRQHandler     			/* TIM1 Update interrupt and TIM10 global interrupt                   */
  .word	TIM1_TRG_COM_TIM11_IRQHandler			/* TIM1 Trigger and Commutation interrupts and TIM11 global interrupt */
  .word	TIM1_CC_IRQHandler           			/* TIM1 Capture Compare interrupt                                     */
  .word	TIM2_IRQHandler              			/* TIM2 global interrupt                                              */
  .word	TIM3_IRQHandler              			/* TIM3 global interrupt                                              */
  .word	TIM4_IRQHandler              			/* TIM4 global interrupt                                              */
  .word	I2C1_EV_IRQHandler           			/* I2C1 event interrupt                                               */
  .word	I2C1_ER_IRQHandler           			/* I2C1 error interrupt                                               */
  .word	I2C2_EV_IRQHandler           			/* I2C2 event interrupt                                               */
  .word	I2C2_ER_IRQHandler           			/* I2C2 error interrupt                                               */
  .word	SPI1_IRQHandler              			/* SPI1 global interrupt                                              */
  .word	SPI2_IRQHandler              			/* SPI2 global interrupt                                              */
  .word	USART1_IRQHandler            			/* USART1 global interrupt                                            */
  .word	USART2_IRQHandler            			/* USART2 global interrupt                                            */
  .word	0                            			/* Reserved                                                           */
  .word	EXTI15_10_IRQHandler         			/* EXTI Line[15:10] interrupts                                        */
  .word	RTC_Alarm_IRQHandler         			/* RTC Alarms (A and B) through EXTI line interrupt                   */
  .word	OTG_FS_WKUP_IRQHandler       			/* USB On-The-Go FS Wakeup through EXTI line interrupt                */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	DMA1_Stream7_IRQHandler      			/* DMA1 Stream7 global interrupt                                      */
  .word	0                            			/* Reserved                                                           */
  .word	SDIO_IRQHandler              			/* SDIO global interrupt                                              */
  .word	TIM5_IRQHandler              			/* TIM5 global interrupt                                              */
  .word	SPI3_IRQHandler              			/* SPI3 global interrupt                                              */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	DMA2_Stream0_IRQHandler      			/* DMA2 Stream0 global interrupt                                      */
  .word	DMA2_Stream1_IRQHandler      			/* DMA2 Stream1 global interrupt                                      */
  .word	DMA2_Stream2_IRQHandler      			/* DMA2 Stream2 global interrupt                                      */
  .word	DMA2_Stream3_IRQHandler      			/* DMA2 Stream3 global interrupt                                      */
  .word	DMA2_Stream4_IRQHandler      			/* DMA2 Stream4 global interrupt                                      */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	OTG_FS_IRQHandler            			/* USB On The Go FS global interrupt                                  */
  .word	DMA2_Stream5_IRQHandler      			/* DMA2 Stream5 global interrupt                                      */
  .word	DMA2_Stream6_IRQHandler      			/* DMA2 Stream6 global interrupt                                      */
  .word	DMA2_Stream7_IRQHandler      			/* DMA2 Stream7 global interrupt                                      */
  .word	USART6_IRQHandler            			/* USART6 global interrupt                                            */
  .word	I2C3_EV_IRQHandler           			/* I2C3 event interrupt                                               */
  .word	I2C3_ER_IRQHandler           			/* I2C3 error interrupt                                               */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	SPI4_IRQHandler              			/* SPI 4 global interrupt                                             */
  .word	SPI5_IRQHandler              			/* SPI 5 global interrupt                                             */
  .size vector_table__, .-vector_table__


	.weak	NMI_Handler
	.thumb_set NMI_Handler,default_

	.weak	HardFault_Handler
	.thumb_set HardFault_Handler,default_

	.weak	MemManage_Handler
	.thumb_set MemManage_Handler,default_

	.weak	BusFault_Handler
	.thumb_set BusFault_Handler,default_

	.weak	UsageFault_Handler
	.thumb_set UsageFault_Handler,default_

	.weak	SVC_Handler
	.thumb_set SVC_Handler,default_

	.weak	DebugMon_Handler
	.thumb_set DebugMon_Handler,default_

	.weak	PendSV_Handler
	.thumb_set PendSV_Handler,default_

	.weak	SysTick_Handler
	.thumb_set SysTick_Handler,default_

	.weak	WWDG_IRQHandler
	.thumb_set WWDG_IRQHandler,default_

	.weak	PVD_IRQHandler
	.thumb_set PVD_IRQHandler,default_

	.weak	TAMP_STAMP_IRQHandler
	.thumb_set TAMP_STAMP_IRQHandler,default_

	.weak	RTC_WKUP_IRQHandler
	.thumb_set RTC_WKUP_IRQHandler,default_

	.weak	FLASH_IRQHandler
	.thumb_set FLASH_IRQHandler,default_

	.weak	RCC_IRQHandler
	.thumb_set RCC_IRQHandler,default_

	.weak	EXTI0_IRQHandler
	.thumb_set EXTI0_IRQHandler,default_

	.weak	EXTI1_IRQHandler
	.thumb_set EXTI1_IRQHandler,default_

	.weak	EXTI2_IRQHandler
	.thumb_set EXTI2_IRQHandler,default_

	.weak	EXTI3_IRQHandler
	.thumb_set EXTI3_IRQHandler,default_

	.weak	EXTI4_IRQHandler
	.thumb_set EXTI4_IRQHandler,default_

	.weak	DMA1_Stream0_IRQHandler
	.thumb_set DMA1_Stream0_IRQHandler,default_

	.weak	DMA1_Stream1_IRQHandler
	.thumb_set DMA1_Stream1_IRQHandler,default_

	.weak	DMA1_Stream2_IRQHandler
	.thumb_set DMA1_Stream2_IRQHandler,default_

	.weak	DMA1_Stream3_IRQHandler
	.thumb_set DMA1_Stream3_IRQHandler,default_

	.weak	DMA1_Stream4_IRQHandler
	.thumb_set DMA1_Stream4_IRQHandler,default_

	.weak	DMA1_Stream5_IRQHandler
	.thumb_set DMA1_Stream5_IRQHandler,default_

	.weak	DMA1_Stream6_IRQHandler
	.thumb_set DMA1_Stream6_IRQHandler,default_

	.weak	ADC_IRQHandler
	.thumb_set ADC_IRQHandler,default_

	.weak	EXTI9_5_IRQHandler
	.thumb_set EXTI9_5_IRQHandler,default_

	.weak	TIM1_BRK_TIM9_IRQHandler
	.thumb_set TIM1_BRK_TIM9_IRQHandler,default_

	.weak	TIM1_UP_TIM10_IRQHandler
	.thumb_set TIM1_UP_TIM10_IRQHandler,default_

	.weak	TIM1_TRG_COM_TIM11_IRQHandler
	.thumb_set TIM1_TRG_COM_TIM11_IRQHandler,default_

	.weak	TIM1_CC_IRQHandler
	.thumb_set TIM1_CC_IRQHandler,default_

	.weak	TIM2_IRQHandler
	.thumb_set TIM2_IRQHandler,default_

	.weak	TIM3_IRQHandler
	.thumb_set TIM3_IRQHandler,default_

	.weak	TIM4_IRQHandler
	.thumb_set TIM4_IRQHandler,default_

	.weak	I2C1_EV_IRQHandler
	.thumb_set I2C1_EV_IRQHandler,default_

	.weak	I2C1_ER_IRQHandler
	.thumb_set I2C1_ER_IRQHandler,default_

	.weak	I2C2_EV_IRQHandler
	.thumb_set I2C2_EV_IRQHandler,default_

	.weak	I2C2_ER_IRQHandler
	.thumb_set I2C2_ER_IRQHandler,default_

	.weak	SPI1_IRQHandler
	.thumb_set SPI1_IRQHandler,default_

	.weak	SPI2_IRQHandler
	.thumb_set SPI2_IRQHandler,default_

	.weak	USART1_IRQHandler
	.thumb_set USART1_IRQHandler,default_

	.weak	USART2_IRQHandler
	.thumb_set USART2_IRQHandler,default_

	.weak	EXTI15_10_IRQHandler
	.thumb_set EXTI15_10_IRQHandler,default_

	.weak	RTC_Alarm_IRQHandler
	.thumb_set RTC_Alarm_IRQHandler,default_

	.weak	OTG_FS_WKUP_IRQHandler
	.thumb_set OTG_FS_WKUP_IRQHandler,default_

	.weak	DMA1_Stream7_IRQHandler
	.thumb_set DMA1_Stream7_IRQHandler,default_

	.weak	SDIO_IRQHandler
	.thumb_set SDIO_IRQHandler,default_

	.weak	TIM5_IRQHandler
	.thumb_set TIM5_IRQHandler,default_

	.weak	SPI3_IRQHandler
	.thumb_set SPI3_IRQHandler,default_

	.weak	DMA2_Stream0_IRQHandler
	.thumb_set DMA2_Stream0_IRQHandler,default_

	.weak	DMA2_Stream1_IRQHandler
	.thumb_set DMA2_Stream1_IRQHandler,default_

	.weak	DMA2_Stream2_IRQHandler
	.thumb_set DMA2_Stream2_IRQHandler,default_

	.weak	DMA2_Stream3_IRQHandler
	.thumb_set DMA2_Stream3_IRQHandler,default_

	.weak	DMA2_Stream4_IRQHandler
	.thumb_set DMA2_Stream4_IRQHandler,default_

	.weak	OTG_FS_IRQHandler
	.thumb_set OTG_FS_IRQHandler,default_

	.weak	DMA2_Stream5_IRQHandler
	.thumb_set DMA2_Stream5_IRQHandler,default_

	.weak	DMA2_Stream6_IRQHandler
	.thumb_set DMA2_Stream6_IRQHandler,default_

	.weak	DMA2_Stream7_IRQHandler
	.thumb_set DMA2_Stream7_IRQHandler,default_

	.weak	USART6_IRQHandler
	.thumb_set USART6_IRQHandler,default_

	.weak	I2C3_EV_IRQHandler
	.thumb_set I2C3_EV_IRQHandler,default_

	.weak	I2C3_ER_IRQHandler
	.thumb_set I2C3_ER_IRQHandler,default_

	.weak	SPI4_IRQHandler
	.thumb_set SPI4_IRQHandler,default_

	.weak	SPI5_IRQHandler
	.thumb_set SPI5_IRQHandler,default_

.section .text

/**
 * @brief  This is the code that gets called when the processor receives an
 *         unexpected interrupt. This simply enters an infinite loop, preserving
 *         the system state for examination by a debugger.
 *
 * @param  None
 * @return None
 */
  .section .text.default_,"ax",%progbits
default_:
loop__:
  b loop__
  .size default_, .-default_

  .section .text.reset_
  .type reset_, %function
reset_:
  ldr   r0, =_estack
  mov   sp, r0
/*bl  rcc_init (Init Cache, PLL , etc)*/  


/**
 * @brief Copy initialized .data section from FLASH to SRAM.
 * @details This assembly routine initializes the .data section in SRAM by copying
 *          its values from the corresponding region in FLASH. The .data section holds
 *          initialized global and static variables that must persist with specific
 *          initial values at runtime.
 *  @note If there is no use of initiallized global values, this may break the initialization code. 
 *        Still, no unreallistic overhead is added considering that the application established here will use it
 */
  ldr r0, =_sdata       
  ldr r1, =_edata       
  ldr r2, =_sidata
  sub r3, r1, r0

copy_flash__:
  sub r3, r3, #4
  ldr r4, [r2, r3]  
  str r4, [r0, r3]
  
  bne copy_flash__     


/**
 * @brief Zero fills the .bss section in SRAM.
 * @details This routine initializes the .bss section in SRAM by setting all its contents to 0. 
 *          The .bss section is used to store uninitialized global and static variables, which are 
 *          automatically initialized to zero during program startup. This ensures that all uninitialized 
 *          variables in the .bss section are properly set to zero before the program begins execution.
 * @note Variables to be initiallized with zero go here
 */
  ldr r0, =_sbss
  ldr r1, =_ebss
  movs r2, #0
  sub r3, r1, r0

zero_bss__:
  sub r3, r3, #4
  str  r2, [r0, r3]
  
  bne zero_bss__


  bl startup
  b .