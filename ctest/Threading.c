/*

Simple co-operative threading.

To use:

1. Call threads_init()
2. Call thread_create for required threads
3. Call threads_run() to run those threads
4. In each thread proc, periodically call thread_yield()

Notes:
* Once all threads have finished executing, threads_run() will return.
* Running threads can create further threads if necessary.
* A thread terminates when it returns from the it's thread proc.
* In general everything should be compiled as re-entrant.

*/


#include <stdlib.h>
#include <string.h>
#include "Threading.h"

#define true 1
#define false 0

typedef unsigned int uint16_t;

#define _countof(x) (sizeof(x)/sizeof(x[0]))

void run_first_thread();

// Thread control block
typedef struct _TCB
{
	struct _TCB*	next;
	void*			sp;
} TCB;

TCB* g_pThreadList = NULL;
TCB* g_pCurrentThread = NULL;
TCB g_ThreadSlots[16];		// Max 16 threads
unsigned int g_exit_fp;

void threads_init()
{
	// Zero all the thread slots
	memset(g_ThreadSlots, 0, sizeof(g_ThreadSlots));
}

void threads_run()
{
	__asm__
	("\n\
		# Check if g_pThreadList is NULL\n\
		lda.l	$r0,(g_pThreadList)\n\
		xor		$r1,$r1\n\
		cmp		$r0,$r1\n\
		beq 	exit1\n\
		\n\
		# Save FP\n\
		ldi.l	$r0,-12\n\
		add.l	$r0,$fp\n\
		sta.l	(g_exit_fp),$r0\n\
		\n\
		# Run the first thread\n\
		jsra	run_first_thread\n\
	exit1:\n\
		\n\
		# Control will return here once all threads have finished\n\
		# and _threads_exit is called\n\
	");
}

void _threads_exit() 
{
	__asm__
	("\n\
		# Restore stack pointer to threads_run thread\n\
		lda.l	$fp,(g_exit_fp) \n\
		\n\
		# Return and continue just after call to run_first_thread above\n\
		ret\n\
	");
}

// The address of this function is set as the return address at top of stack
//  for newly created threads
// ie: when a thread exits, control will transfer to here
// This function never returns, rather it tranfers control to another
// thread or if no others, calls _threads_exit returns control to the 
// threads_run() entry point thread and no more threads are run
void _thread_term()
{
	TCB* p=g_pThreadList;

	// Remove from the circular list of running threads
	while (true)
	{
		if (p->next == g_pCurrentThread)
		{
			p->next = g_pCurrentThread->next;
			break;
		}
		if (p->next == g_pThreadList)
		{
			// WTF? wasn't found in list?
			// halt, abort, throw an exception and just generally give up.
		}
		p=p->next;
	}

	// Update the thread list head pointer
	if (g_pThreadList == g_pCurrentThread)
	{
		g_pThreadList = g_pCurrentThread->next;
		if (g_pThreadList == g_pCurrentThread)
			g_pThreadList=NULL;
	}

	// Mark TCB slot as unused
	g_pCurrentThread->next = NULL;

	// Run another thread, or tear down everything
	if (g_pThreadList!=NULL)
	{
		run_first_thread();
	}
	else
	{
		_threads_exit();
	}
}

// Creates a new thread with top of stack pointer "stackPointer"
HTHREAD thread_create(THREADPROC threadProc, void* stackPointer)
{
	int i;
	TCB* tcb=NULL;

	// Find an unused thread slot
	for (i=0; i<_countof(g_ThreadSlots); i++)
	{
		if (g_ThreadSlots[i].next==NULL)
		{
			tcb = &g_ThreadSlots[i];
			break;
		}
	}

	// Quit if no free slots
	if (tcb==NULL)
		return NULL;

	// Setup the stack
	void** pStack = (void**)stackPointer;

	// Thread Proc's call stack
	pStack[-1] = NULL;				// static chain
	pStack[-2] = _thread_term;		// return address
	pStack[-3] = NULL;				// saved $fp

	// Fake call stack into thread_yield
	pStack[-4] = NULL;				// static chain
	pStack[-5] = threadProc;		// return address
	pStack[-6] = NULL;				// save $fp

	// Saved registers
	pStack[-7] = NULL;				// $r6
	pStack[-8] = NULL;				// $r7
	pStack[-9] = NULL;				// $r8
	pStack[-10] = NULL;				// $r9
	pStack[-11] = NULL;				// $r10
	pStack[-12] = NULL;				// $r11

	tcb->sp = pStack-12;

	// Add the thread to the circular list of running threads
	if (g_pThreadList==NULL)
	{
		// First TCB, create circular linked list to self
		tcb->next = tcb;
		g_pThreadList = tcb;
	}
	else
	{
		// Insert after the first one.  Since the end of the list will be
		// pointing to the first entry, this saves having to find and update
		// the last entry in the list
		tcb->next = g_pThreadList->next;
		g_pThreadList->next = tcb;
	}

	// Return handle
	return (HTHREAD)tcb;
}

// This is the function that yields control to other threads
// It must be called periodically by all threads to give up
// time for the others to run
void thread_yield()	
{
	__asm__
	("\n\
		# Save registers \n\
		push	$sp,$r6\n\
		push	$sp,$r7\n\
		push	$sp,$r8\n\
		push	$sp,$r9\n\
		push	$sp,$r10\n\
		push	$sp,$r11\n\
		\n\
		# Get current TCB \n\
		lda.l	$r0,(g_pCurrentThread) \n\
		\n\
		# Save SP into the TCB \n\
		sto.l	4 ($r0),$sp \n\
		\n\
		# Update g_pCurrentThread to point to the next thread \n\
		ldo.l	$r1,0 ($r0) \n\
		sta.l	(g_pCurrentThread),$r1 \n\
		\n\
		# Restore SP for the next thread \n\
		ldo.l	$sp,4 ($r1) \n\
		\n\
		# Restore registers \n\
		pop		$sp,$r11 \n\
		pop		$sp,$r10 \n\
		pop		$sp,$r9 \n\
		pop		$sp,$r8 \n\
		pop		$sp,$r7 \n\
		pop		$sp,$r6 \n\
		mov		$fp,$sp \n\
		\n\
		# Return to other thread \n\
		ret \n\
	");
}

void run_first_thread()
{
	__asm__
	("\n\
		# Get TCB of first thread \n\
		lda.l	$r1,(g_pThreadList) \n\
		\n\
		# Update g_pCurrentThread to point to  \n\
		sta.l	(g_pCurrentThread),$r1 \n\
		\n\
		# Restore SP for the next thread \n\
		ldo.l	$sp,4 ($r1) \n\
		\n\
		# Restore registers \n\
		pop		$sp,$r11 \n\
		pop		$sp,$r10 \n\
		pop		$sp,$r9 \n\
		pop		$sp,$r8 \n\
		pop		$sp,$r7 \n\
		pop		$sp,$r6 \n\
		mov		$fp,$sp \n\
		\n\
		# Return to other thread \n\
		ret \n\
	");
}

