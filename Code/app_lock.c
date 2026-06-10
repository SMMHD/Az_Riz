#include <string.h>
#include "config.h"
#include "hal_timer.h"
#include "app_lock.h"

// ???????? ????? (?? ?? ????? ???????)
static char user_pass[10] = "1234";
static char admin_pass[10] = "9999";
static unsigned char max_tries = 3;
static unsigned char pass_len = 4;
static unsigned char failed_attempts = 0;

static unsigned long door_open_time = 0;
static unsigned char is_door_open = 0;

void lock_init(void) {
    LOCK_DDR |= (1<<0); // ????? ???? ???/LED ?? ????? ?????
    LOCK_OUT = 0;       // ?? ???? ??????? ??? ???? ???
}

void lock_open_door(void) {
    LOCK_OUT = 1;
    is_door_open = 1;
    door_open_time = millis();
}

// ??? ???? ???? ??????? ?? ??? ??? ?????? ?? delay ????? ???
// ??? ???? ??? ???? ?? (???? 3 ?????) ???? ???? ?? ?? ???????
void lock_update_task(void) {
    if(is_door_open) {
        if((millis() - door_open_time) > 3000) { // 3000 ?????????? = 3 ?????
            LOCK_OUT = 0;
            is_door_open = 0;
        }
    }
}

int lock_verify_password(char* input, unsigned char role) {
    if(role == ROLE_USER) {
        return (strcmp(input, user_pass) == 0);
    } else {
        return (strcmp(input, admin_pass) == 0);
    }
}

void lock_set_password(char* new_pass, unsigned char role) {
    if(role == ROLE_USER) {
        strcpy(user_pass, new_pass);
    } else {
        strcpy(admin_pass, new_pass);
    }
}

unsigned char lock_get_max_tries(void) { return max_tries; }
void lock_set_max_tries(unsigned char tries) { max_tries = tries; }

unsigned char lock_get_pass_len(void) { return pass_len; }
void lock_set_pass_len(unsigned char len) { pass_len = len; }

unsigned char lock_get_failed_attempts(void) { return failed_attempts; }
void lock_register_failure(void) { failed_attempts++; }
void lock_reset_failures(void) { failed_attempts = 0; }