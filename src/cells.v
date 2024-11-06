#include "wokwi-api.h"
#include <stdio.h>
#include <stdlib.h>

#define PWM_OUT 13  // Define the PWM output pin for the LED

typedef struct {
  uint32_t clock_divisor;   // Divides the input clock frequency
  uint32_t duty_cycle;      // Duty cycle percentage (0-100)
  uint32_t counter;         // Counter for frequency division
  uint8_t pwm_state;        // Current state of PWM output
} chip_state_t;

void chip_init() {
  chip_state_t *chip = malloc(sizeof(chip_state_t));
  chip->clock_divisor = 50;  // Set default division factor
  chip->duty_cycle = 1000;     // Fixed duty cycle at 50%
  chip->counter = 0;
  chip->pwm_state = 0;

  // Initialize the PWM_OUT pin as an output
  pin_mode(PWM_OUT, 1);  // Use 1 for OUTPUT mode in Wokwi API
  printf("Digital Frequency Divider with PWM Initialized!\n");
}

uint32_t pwm_output(chip_state_t *chip) {
  // Increment the counter with each clock cycle
  chip->counter++;

  // Divide the input frequency by clock_divisor
  if (chip->counter >= chip->clock_divisor) {
    chip->counter = 0;  // Reset counter

    // Toggle PWM state based on duty cycle
    uint32_t on_time = (chip->duty_cycle * chip->clock_divisor) / 100;
    chip->pwm_state = (chip->counter < on_time) ? 1 : 0;

    // Write to the PWM_OUT pin using the PWM state
    pin_write(PWM_OUT, chip->pwm_state);
  }
  return chip->pwm_state;
}

void chip_update(chip_state_t *chip) {
  // With a fixed duty cycle, we just need to update the PWM output
  pwm_output(chip);
}

void chip_free() {
  printf("Goodbye from custom chip!\n");
}

