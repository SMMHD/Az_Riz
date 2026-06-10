#include "config.h"
#include "hal_timer.h"
#include "hal_lcd.h"

void lcd_pulse(void) {
    LCD_EN = 1;
    wait_ms(1);
    LCD_EN = 0;
    wait_ms(1);
}

void lcd_send(unsigned char value, unsigned char is_data) {
    LCD_RS = is_data;
    
    // ????? 4 ??? ?? ????
    LCD_D4 = (value >> 4) & 1;
    LCD_D5 = (value >> 5) & 1;
    LCD_D6 = (value >> 6) & 1;
    LCD_D7 = (value >> 7) & 1;
    lcd_pulse();
    
    // ????? 4 ??? ?? ????
    LCD_D4 = (value >> 0) & 1;
    LCD_D5 = (value >> 1) & 1;
    LCD_D6 = (value >> 2) & 1;
    LCD_D7 = (value >> 3) & 1;
    lcd_pulse();
}

void lcd_init(void) {
    LCD_DDR |= 0x3F; // ????? 6 ??? ??? ???? C ?? ????? ?????
    LCD_RS = 0; LCD_EN = 0;
    wait_ms(20);
    
    lcd_send(0x02, 0); // ?????? ?? ???? (???? 4 ???)
    lcd_send(0x28, 0); // 4-bit, 2 lines
    lcd_send(0x0C, 0); // Display ON, Cursor OFF
    lcd_send(0x06, 0); // Entry mode
    lcd_clear();
}

void lcd_clear(void) {
    lcd_send(0x01, 0);
    wait_ms(2);
}

void lcd_putc(char c) {
    lcd_send(c, 1);
}

void lcd_print(char* str) {
    while(*str) {
        lcd_putc(*str++);
    }
}

void lcd_gotoxy(unsigned char x, unsigned char y) {
    unsigned char addr = (y == 0) ? (0x80 + x) : (0xC0 + x);
    lcd_send(addr, 0);
}