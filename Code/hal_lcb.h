#ifndef HAL_LCD_H
#define HAL_LCD_H

void lcd_init(void);
void lcd_clear(void);
void lcd_print(char* str);
void lcd_gotoxy(unsigned char x, unsigned char y);
void lcd_putc(char c);

#endif