#include <mega32.h>
#include <stdio.h>
#include <string.h>

#include "config.h"
#include "hal_timer.h"
#include "hal_lcd.h"
#include "hal_keypad.h"
#include "app_lock.h"

// ????? ???? ?????? ???? ???? ????? ???? ??????? ??? ???
char ui_get_key(void) {
    char key;
    while(1) {
        lock_update_task(); // ?? ???? ????? ??? ?? ????????
        key = keypad_read();
        if(key != 0) {
            wait_ms(20); // ????????? (Debounce)
            if (keypad_read() == key) {
                // ??? ?????? ?? ????? ???? ?? ?? ??? ???? ??????
                while(keypad_read() != 0) lock_update_task(); 
                return key;
            }
        }
    }
}

// ?? ???? ???? ???? ????? ????? (??? ?? ???)
// ??? is_password ????? 1 ????? ????? ??? ??????
int get_input(char* buffer, int max_len, int is_password) {
    int idx = 0;
    char key;
    buffer[0] = '\0';
    
    lcd_gotoxy(0, 1);
    lcd_print("                ");
    lcd_gotoxy(0, 1);
    
    while(1) {
        key = ui_get_key();
        
        if(key == '#') { // ?????
            if(idx == max_len) return 1;
            else {
                lcd_gotoxy(0, 1);
                lcd_print("Len Must Be "); lcd_putc(max_len + '0');
                wait_ms(1500);
                return 0; // ??? ?? ??? ?????
            }
        } 
        else if(key == '*') { // ??? ???? ?? ????? (Clear)
            idx = 0;
            buffer[0] = '\0';
            lcd_gotoxy(0, 1);
            lcd_print("                ");
            lcd_gotoxy(0, 1);
        } 
        else if(key == 'C') { // ?????? / ??????
            return 0;
        } 
        else if(key >= '0' && key <= '9') {
            if(idx < max_len) {
                buffer[idx] = key;
                idx++;
                buffer[idx] = '\0';
                
                lcd_gotoxy(idx - 1, 1);
                if(is_password) lcd_putc('*');
                else lcd_putc(key);
            }
        }
    }
}

// ??? ??? ????? ?? ?? ???????? ?????
void system_lockdown(void) {
    int wait_time = 15; // 15 ????? ??? ??????
    unsigned long last_sec = millis();
    char buf[16];
    
    lcd_clear();
    lcd_print("SYSTEM LOCKED!");
    
    while(wait_time > 0) {
        lock_update_task();
        if(millis() - last_sec >= 1000) {
            last_sec = millis();
            wait_time--;
            sprintf(buf, "Wait %2d sec   ", wait_time);
            lcd_gotoxy(0, 1);
            lcd_print(buf);
        }
    }
    lock_reset_failures();
}

// ???? ??????
void admin_menu(void) {
    char key;
    char buf[10];
    
    while(1) {
        lcd_clear();
        lcd_print("1:UsrPsw 2:AdmPs");
        lcd_gotoxy(0, 1);
        lcd_print("3:Tries  4:Len");
        
        key = ui_get_key();
        
        if(key == '1') {
            lcd_clear(); lcd_print("New User Pass:");
            if(get_input(buf, lock_get_pass_len(), 1)) {
                lock_set_password(buf, ROLE_USER);
                lcd_clear(); lcd_print("Saved!"); wait_ms(1000);
            }
        } 
        else if(key == '2') {
            lcd_clear(); lcd_print("New Admin Pass:");
            if(get_input(buf, lock_get_pass_len(), 1)) {
                lock_set_password(buf, ROLE_ADMIN);
                lcd_clear(); lcd_print("Saved!"); wait_ms(1000);
            }
        } 
        else if(key == '3') {
            lcd_clear(); lcd_print("Set Max Tries:");
            if(get_input(buf, 1, 0)) { // ??? 1 ??? ???? ???
                lock_set_max_tries(buf[0] - '0');
                lcd_clear(); lcd_print("Saved!"); wait_ms(1000);
            }
        } 
        else if(key == '4') {
            lcd_clear(); lcd_print("Set Length(4-8):");
            if(get_input(buf, 1, 0)) {
                int new_len = buf[0] - '0';
                if(new_len >= 4 && new_len <= 8) {
                    lock_set_pass_len(new_len);
                    lcd_clear(); lcd_print("Saved! Plz Reset");
                    wait_ms(1000);
                } else {
                    lcd_clear(); lcd_print("Invalid Length!");
                    wait_ms(1000);
                }
            }
        } 
        else if(key == 'C' || key == 'D') {
            break; // ???? ?? ???? ??????
        }
    }
}

void main(void) {
    char key;
    char input_buffer[10];
    
    // ???????? ????? ?????
    timer_init();
    lcd_init();
    keypad_init();
    lock_init();
    
    lcd_clear();
    lcd_print("  Digital Lock  ");
    lcd_gotoxy(0, 1);
    lcd_print(" Starting...    ");
    wait_ms(1500);

    while (1) {
        lock_update_task();
        
        lcd_clear();
        lcd_print("A: User  B:Admin");
        lcd_gotoxy(0, 1);
        lcd_print("Select Mode...");
        
        key = ui_get_key();
        
        if (key == 'A') { // ???? ?????
            lcd_clear();
            lcd_print("User Password:");
            if (get_input(input_buffer, lock_get_pass_len(), 1)) {
                if (lock_verify_password(input_buffer, ROLE_USER)) {
                    lock_reset_failures();
                    lock_open_door();
                    lcd_clear(); lcd_print("Access Granted");
                    lcd_gotoxy(0, 1); lcd_print("Door Opened");
                    wait_ms(2000);
                } else {
                    lock_register_failure();
                    lcd_clear(); lcd_print("Wrong Password!");
                    wait_ms(1500);
                    if(lock_get_failed_attempts() >= lock_get_max_tries()) {
                        system_lockdown();
                    }
                }
            }
        } 
        else if (key == 'B') { // ???? ????
            lcd_clear();
            lcd_print("Admin Password:");
            if (get_input(input_buffer, lock_get_pass_len(), 1)) {
                if (lock_verify_password(input_buffer, ROLE_ADMIN)) {
                    lock_reset_failures();
                    lcd_clear(); lcd_print("Admin Verified!");
                    wait_ms(1000);
                    admin_menu(); // ???? ?? ???? ???????
                } else {
                    lock_register_failure();
                    lcd_clear(); lcd_print("Wrong Password!");
                    wait_ms(1500);
                    if(lock_get_failed_attempts() >= lock_get_max_tries()) {
                        system_lockdown();
                    }
                }
            }
        }
    }
}