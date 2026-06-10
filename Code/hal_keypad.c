#include "config.h"
#include "hal_timer.h"
#include "hal_keypad.h"

void keypad_init(void) {
    KEYPAD_DDR = 0x0F;  // 4 پین اول خروجی (سطرها)، 4 پین دوم ورودی (ستون‌ها)
    KEYPAD_PORT = 0xFF; // پول‌آپ کردن ورودی‌ها و یک کردن خروجی‌ها
}

char keypad_read(void) {
    // چیدمان اصلاح شده بر اساس KEYPAD-SMALLCALC در پروتئوس
    // در این کیپد: ستون آخر عملگرهای / * - + هستند و کلیدهای پایین ON/C 0 = +
    char keymap[4][4] = {
        {'7','8','9','/'},  // سطر اول (PA0)
        {'4','5','6','*'},  // سطر دوم (PA1)
        {'1','2','3','-'},  // سطر سوم (PA2)
        {'C','0','#','+'}   // سطر چهارم (PA3) -> از 'C' برای Clear و از '#' برای تایید ('=') استفاده میکنیم
    };
    unsigned char r, c;
    
    for(r = 0; r < 4; r++) {
        KEYPAD_PORT = ~(1 << r) | 0xF0; 
        wait_ms(2); 
        
        for(c = 0; c < 4; c++) {
            if(!(KEYPAD_PIN & (1 << (c + 4)))) { 
                return keymap[r][c];
            }
        }
    }
    return 0;
}