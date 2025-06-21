
#include "sgl.h" // Required for basic sgl functions

#define		SystemWork		0x060ffc00		/* System Variable Address */
#define		SystemSize		(0x06100000-0x060ffc00)		/* System Variable Size */
/* sl.lnk で指定した.bssセクションの開始、終了シンボル */
extern Uint32 _bstart, _bend;
/* */
extern void ss_main( void );

// GNUSH: void to int
int	main( void )
{
	Uint8	*dst;
	Uint32	i;

	/* 1.Zero Set .bss Section */
	for( dst = (Uint8 *)&_bstart; dst < (Uint8 *)&_bend; dst++ ) {
		*dst = 0;
	}
	/* 2.ROM has data at end of text; copy it. */

	/* 3.SGL System Variable Clear */
	for( dst = (Uint8 *)SystemWork, i = 0;i < SystemSize; i++) {
		*dst = 0;
	}

	/* Application Call */
	ss_main();
}

