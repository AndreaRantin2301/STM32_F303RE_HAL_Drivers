ENTRY(Reset_Handler)

MEMORY
{
    CCMRAM (rwx) : ORIGIN = 0x10000000, LENGTH = 16K
    SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 64K
    FLASH(rx) : ORIGIN = 0x8000000, LENGTH = 512K
}

_estack = ORIGIN(SRAM) + LENGTH(SRAM);

SECTIONS
{
    .text :
    {
        *(.isr_vector)
        *(.text)
        *(.rodata)
        . = ALIGN(4);
        _etext = .;
    } > FLASH

    .data :
    {
       _sdata = .;
       *(.data)
       . = ALIGN(4);
       _edata = .; 
    } > SRAM AT > FLASH

    .bss :
    {
        _sbss = .;
        *(.bss)
        . = ALIGN(4);
        _ebss = .;
    } > SRAM
}