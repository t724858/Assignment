.syntax unified
.cpu cortex-m0plus
.thumb
.global main_asm
.align 4

.equ LED_GPIO_BASE, 0x40014000  @ Base address for GPIO
.equ ADC_BASE, 0x4004C000       @ Base address for ADC
.equ ADC_CS, 0x00               @ Offset for Control and Status Register
.equ ADC_RESULT, 0x04           @ Offset for Result Register
.equ ADC_CS_EN, 0x01            @ Enable ADC
.equ LED_GPIO_OUT, 1
.equ LED_GPIO_IN, 0
.equ LED_GPIO_PIN, 2         @ Start at GPIO pin 2, last pin - 11
.equ    ADC_GPIO_PIN, 26    
.equ ADC_CS_START_MANY, 0x08

main_asm:
  @loop to initialize 10 GPIO with initilail value 0
  movs r5, #0
  init_gpio:
    movs r0, #LED_GPIO_PIN
    adds r0, r0, r5
    bl asm_gpio_init
    movs r1, #LED_GPIO_OUT
    bl asm_gpio_set_dir
    adds r5, r5, #1
    cmp r5, #11
    bne init_gpio

    movs    r0, #ADC_GPIO_PIN
    bl      asm_gpio_init
    movs    r0, #ADC_GPIO_PIN    
    movs    r1, #LED_GPIO_IN     
    bl      asm_gpio_set_dir

    ldr     r1, =ADC_BASE       @ Load the base address of the ADC
    ldr     r0, [r1, #ADC_CS]   @ Load the current value of the CS register
    adds    r0, r0, #ADC_CS_EN  @ Set the EN bit to enable the ADC
    str     r0, [r1, #ADC_CS]   @ Write back the value to the CS register
    ldr     r1, [r0, #ADC_CS]     @ Load the current value of the CS register
    ldr     r2, [r0, #ADC_RESULT] @ Load the result from the RESULT register

poll_adc:
  ldr r0, [r1, #ADC_CS]
  movs r2, #ADC_CS_START_MANY
  add r0, r0, r2
  str r0, [r1, #ADC_CS]

  bl delay_small

  ldr r2, [r1, #ADC_RESULT]
  lsrs r2, r2, #12          @ Scale ADC result to 0-10

  mov r0, r2                @ Move ADC result to r0 for printing
  bl print_adc_value        @ Call C function to print ADC value

  movs r7, r2
  movs r4, #0

loop:
  b loop

delay_small:
  movs r3, #0xFF            @ Simple delay loop
delay_loop:
  subs r3, r3, #1
  bne delay_loop
  bx lr

