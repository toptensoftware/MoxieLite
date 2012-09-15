#include <string.h>

// External references to the PCU's memory map
extern char dma_buffer[];
extern char vram_buffer[];
extern unsigned char port_leds_linear; 
extern unsigned short port_leds_7seg;

// Simple delay loop
void delay()
{
	for (int i=0; i<25000; i++)
	{
		__asm__("nop");
	}
}

// Main!
void main()
{
	// Display something on the 7-segment display
	port_leds_7seg = 0xCAFE;

	// Display a rotating bit patter
	unsigned char bits = 0x03;
	while (1)
	{	
		// Update the LEDs
		port_leds_linear = bits;

		// Rotate the bit pattern
		bits = (bits << 1) | ((bits & 0x80) ? 1 : 0);

		// Not too fast...
		delay();
	}
}