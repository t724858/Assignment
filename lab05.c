#include "hardware/gpio.h"
#include <stdio.h>
#include "pico/stdlib.h"

// Must declare the main assembly entry point before use.
void main_asm();

int main() {
       
    // Jump into the main assembly code subroutine.
    main_asm();

    // Returning zero indicates everything went okay.
    return 0;
}


void asm_gpio_init(int pin) {
    gpio_init(pin);
    printf("init\n");
}


void asm_gpio_set_dir(int pin, int dir) {
    gpio_set_dir(pin, dir);
}


int asm_gpio_get(int pin) {
    return gpio_get(pin);
}


void asm_gpio_put(int pin, int value) {
    gpio_put(pin, value);
}

void print_adc_value(int value) {
    printf("ADC Value: %d\n", value);
}
