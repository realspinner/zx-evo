	DEVICE ZXSPECTRUM48

GSTP      EQU    4;  step in gfx view
tsFMAddr	  EQU	0x15af
MAX_BP    EQU      8;  �������襥 �᫮ ��⯫����.
MAX_ROWS  EQU    512;  �������襥 �᫮ ������ ����ࠦ����.
MAX_LINES EQU    512;  �������襥 �᫮ ����� ����ࠦ����.
BUF_SIZE  EQU   1024;  ࠧ��� ������� ����.
;FBUF_SIZE EQU   8192

MAX_W_IMAGE EQU  2; ����. �ਭ� ���� ����ࠦ���� = 2 ��࠭��.
MAX_H_IMAGE EQU 24; ����. ���� ���� ����ࠦ���� = 24 ��࠭��

PAL_INV	  EQU	0x8b00; �ᯮ������ ������⭮ ��। �ᯮ�짮������ ���� ��⯫����
BP_BUF    EQU   0x9000; ����� ���� ���� ��⯫����.
READY_BUF EQU   0x9400; ����� ���� ���� ��⮢�� �
                     ; "���ᮢ��" �� ��࠭�栬 ����ࠦ����.
PAL_BUF   EQU   0x9800
FILE_BUF  EQU   0xA000; ����� ���� 䠩������ ����.
PAL_LEN   EQU   0x0200
FILEBUFSZ EQU   0x2000

TABL	  EQU	0xc000

CPU2WIN   EQU   #6002; ����� ��࠭���, ����祭��� � CPU2-����.
CPU3WIN   EQU   #6003; ����� ��࠭���, ����祭��� � CPU3-����.

SCREENPAGE EQU  0 ; �� �ࠢ���� WC
SCREENMODE EQU  %11000010; 360x288c256






