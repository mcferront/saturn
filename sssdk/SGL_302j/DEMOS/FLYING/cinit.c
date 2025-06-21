//------------------------------------------------------------------------
//
//	CINIT.C
//	C Startup module for Saturn/SGL apps
//
//	CONFIDENTIAL
//	Copyright (c) 1995-1996, Sega Technical Institute
//
//	AUTHOR
//  Unknown
//
//	TARGET
//	GCC for SH2
//
//	REVISION
//	  8/7/96 - RAB - Header added for demo release
//
//------------------------------------------------------------------------

/* 
    C����ŕK�v�ȏ����������T���v�����[�`��(SGL�T���v���v���O�����p)
      1.BSS(���������̈�)�̃N���A
      2.ROM�̈悩��RAM�̈�ւ̃R�s�[(���݂��Ȃ��ꍇ�͂���Ȃ�)
*/

#include	"sgl.h"

/* sl.lnk �Ŏw�肵��.bss�Z�N�V�����̊J�n�A�I���V���{�� */
extern Uint32 _bstart, _bend;
/* */
extern void ss_main( void );

int	main( void )
{
	Uint8	*dst;

	/* Zero Set .bss Section */
	for( dst = (Uint8 *)&_bstart; dst < (Uint8 *)&_bend; dst++ ) {
		*dst = 0;
	}
	/* ROM has data at end of text; copy it. */

	/* Application Call */
	ss_main();
}

