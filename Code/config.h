#ifndef CONFIG_H
#define CONFIG_H

#include <mega32.h>

// ??????? ??????? LCD
#define LCD_PORT      PORTC
#define LCD_DDR       DDRC
#define LCD_RS        PORTC.0
#define LCD_EN        PORTC.1
#define LCD_D4        PORTC.2
#define LCD_D5        PORTC.3
#define LCD_D6        PORTC.4
#define LCD_D7        PORTC.5

// ??????? ??????? Keypad
#define KEYPAD_PORT   PORTA
#define KEYPAD_PIN    PINA
#define KEYPAD_DDR    DDRA

// ????? ??? (LED)
#define LOCK_OUT      PORTB.0
#define LOCK_DDR      DDRB.0

#endif