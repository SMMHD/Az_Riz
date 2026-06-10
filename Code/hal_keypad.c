#include "config.h"
#include "hal_timer.h"
#include "hal_keypad.h"

void keypad_init(void) {
    KEYPAD_DDR = 0x0F;  // 4 پین اول خروجی (سطرها)، 4 پین دوم ورودی (ستون‌ها)
    KEYPAD_PORT = 0xFF; // پول‌آپ کردن ورودی‌ها و یک کردن خروجی‌ها
}

char keypad_read(void) {
    char keymap[4][4] = {
        {'1','2','3','A'},
        {'4','5','6','B'},
        {'7','8','9','C'},
        {'*','0','#','D'}
    };
    unsigned char r, c;
    
    for(r = 0; r < 4; r++) {
        KEYPAD_PORT = ~(1 << r) | 0xF0; // صفر کردن یک سطر
        wait_ms(2); // زمان برای تثبیت ولتاژ
        
        for(c = 0; c < 4; c++) {
            if(!(KEYPAD_PIN & (1 << (c + 4)))) { // اگر ستونی صفر شده بود
                return keymap[r][c];
            }
        }
    }
    return 0; // هیچ کلیدی فشرده نشده
}