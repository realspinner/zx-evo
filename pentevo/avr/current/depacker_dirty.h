#ifndef DEPACKER_DIRTY_H
#define DEPACKER_DIRTY_H

/**
 * @file
 * @brief Depack and load fpga configuration.
 * @author http://www.nedopc.com
 *
 * Depacker use MegaLZ without any checks.
 */

/** Size of output buffer */
#define DBSIZE 2048
/** Mask of output buffer */
#define DBMASK 2047

/** Get next byte. */
#define NEXT_BYTE (pgm_read_byte_far(curFpga++))

/** Actual depacker, 8bit-oriented and without any checks. */
void  depacker_dirty(void);

/** */
u8 get_bits_dirty(u8 numbits);
s16 get_bigdisp_dirty(void);

/** */
void put_byte(u8);
void repeat(s16,u8);

#endif

