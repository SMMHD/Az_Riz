#include <mega32.h>
#include "hal_timer.h"

volatile unsigned long g_millis = 0;

// وقفه مقایسه تایمر صفر (هر 1 میلی‌ثانیه اجرا می‌شود)
interrupt [TIM0_COMP] void timer0_comp_isr(void) {
    g_millis++;
}

void timer_init(void) {
    TCNT0 = 0;
    OCR0 = 124; // تنظیم برای 1 میلی‌ثانیه با کلاک 8MHz و Prescaler=64
    TCCR0 = (1<<WGM01) | (1<<CS01) | (1<<CS00); // حالت CTC
    TIMSK |= (1<<OCIE0);
    #asm("sei") // فعال‌سازی وقفه‌های سراسری
}

unsigned long millis(void) {
    unsigned long time;
    #asm("cli")
    time = g_millis;
    #asm("sei")
    return time;
}

// تابع جایگزین delay_ms که برنامه را فریز نمی‌کند و وقفه‌ها کار می‌کنند
void wait_ms(unsigned int ms) {
    unsigned long start = millis();
    while((millis() - start) < ms);
}