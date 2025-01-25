#include "spinlock.h"
#include "os.h"

void acquire(SpinLock *l)
{
	// TODO: What to do if the one asking to acquire the lock
	// is already holding the lock?

	while(l->locked)
		;		

	l->locked = 1;
}

void release(SpinLock *l)
{
	if (!l->locked)
		panic("Attempting to acquire a free lock: %s", l->name);

	l->locked = 0;
}
