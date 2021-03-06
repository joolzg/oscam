/*
    ifd_phoenix.h
    Header file for Smartmouse/Phoenix reader.
*/

int32_t Phoenix_Init (struct s_reader * reader);
int32_t Phoenix_GetStatus (struct s_reader * reader, int32_t * status);
int32_t Phoenix_Reset (struct s_reader * reader, ATR * atr);
int32_t Phoenix_Transmit (struct s_reader * reader, BYTE * buffer, uint32_t size, uint32_t block_delay, uint32_t char_delay);
int32_t Phoenix_Receive (struct s_reader * reader, BYTE * buffer, uint32_t size, uint32_t timeout);
int32_t Phoenix_SetBaudrate (struct s_reader * reader, uint32_t baudrate);
int32_t Phoenix_Close (struct s_reader * reader);
int32_t Phoenix_FastReset (struct s_reader * reader, int32_t delay);
