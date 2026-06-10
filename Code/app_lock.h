#ifndef APP_LOCK_H
#define APP_LOCK_H

// ???????? ????? ?? ??????
#define ROLE_USER  0
#define ROLE_ADMIN 1

void lock_init(void);
void lock_open_door(void);
void lock_update_task(void); // ??? ???? ???? ????? ?? ???? ???? ??? ??? ???

int  lock_verify_password(char* input, unsigned char role);
void lock_set_password(char* new_pass, unsigned char role);

unsigned char lock_get_max_tries(void);
void lock_set_max_tries(unsigned char tries);

unsigned char lock_get_pass_len(void);
void lock_set_pass_len(unsigned char len);

unsigned char lock_get_failed_attempts(void);
void lock_register_failure(void);
void lock_reset_failures(void);

#endif