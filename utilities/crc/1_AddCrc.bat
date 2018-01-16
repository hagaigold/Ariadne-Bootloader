@echo off

REM last position that can be used for CRC is 0x3DFF0

SET srec_path=..\srecord-1.63-win32
SET crcpos=0xFFFE

:: this is only for verificationof CRC.
:: +2 byte of crc position
SET crcpos_recalc_start=0x10000
:: +2 byte
SET crcpos_recalc_end=0x10002 

echo.
echo Input file information:
echo.
%srec_path%\srec_info.exe %1 -intel

echo.
echo ===========================================================
echo.
echo CRC position: %crcpos%.
echo should be more then file length.. see above input file info
echo last position that can be used for CRC is 0x3DFF0
echo.
echo srecord path:  %srec_path%\
echo Input file  :  %1
echo Output file :  out.bin
echo.
echo ===========================================================
echo.
echo.

%srec_path%\srec_cat.exe %1 -intel -fill 0xff 0x00 %crcpos% -crc16-b-e %crcpos% -xmodem -o out.hex -intel
%srec_path%\srec_cat.exe out.hex -intel -o out.bin -bin

echo.
echo Checksum verfication... at loc %crcpos_recalc_start%, should be "00 00":
%srec_path%\srec_cat.exe out.bin -bin -crc16-b-e %crcpos_recalc_start% -xmodem -crop %crcpos_recalc_start% %crcpos_recalc_end% -o -hex-dump

echo.
echo out.bin file information:
echo.
%srec_path%\srec_info.exe out.bin -bin
echo.



