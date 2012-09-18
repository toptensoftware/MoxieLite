#ifndef _THREADING_H
#define _THREADING_H

typedef void (*THREADPROC)();
typedef void* HTHREAD;

void threads_init();
void threads_run();

HTHREAD thread_create(THREADPROC threadProc, void* stackPointer);
void thread_yield();

#endif