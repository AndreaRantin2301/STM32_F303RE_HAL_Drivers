.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

CopyData_ToSRAM:
    # Set stack pointer
    LDR sp, =_estack
    LDR r0, =_sdata
    LDR r1, =_edata
    # This will be the start of .data
    LDR r2, =_etext
    # Calculate size of .data
    SUBS r3,r1,r0
    # Calculate how many words to copy
    LSRS r4,r3,#2
    B CopyData_Word

CopyData_Word:
    CBZ r4, CopyData_HalfWord
    # Load address of _etext in r5 and increment r2 by 4
    LDR r5, [r2], #4
    # Store in r5 4 bytes of .data and increment _sdata by 4
    STR r5, [r0], #4
    SUBS r3,r3,#4
    SUBS r4,r4,#1
    B CopyData_Word

CopyData_HalfWord:
    # Calculate how many half-words to copy(at most it will be 1)
    LSRS r4,r3,#1
    CBZ r4, CopyData_Byte
    LDRH r5, [r2], #2
    STRH r5, [r0], #2
    SUBS r3,r3,#2
    SUBS r4,r4,#1
    B CopyData_HalfWord


CopyData_Byte:
    # There will never be more than 1 byte to copy here
    CBZ r4, Init_Bss
    LDRB r5, [r2], #1
    STRB r5, [r0], #1
    B Init_Bss

Init_Bss:
    # TODO

.global Reset_Handler
Reset_Handler:
    B CopyData_ToSRAM
    # TODO ZERO INIT .bss