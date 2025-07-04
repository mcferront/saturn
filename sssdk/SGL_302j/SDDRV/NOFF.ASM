; 93'10〜	(C)SEGA sound Room   AM2 Yamamoto
;
;	SCSP Contol Program      
;

	include	SCSP.LIB

	global		Note_off

	external	get_EXPTBS,get_EXPTB2,get_LEVEL
	external	Note_on
;@@	external	er_26

;�ｮ�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�ｲ
;�､     MIDI note off							 �､
;�､ Key on 中の 同一MIDI# と Note# の全ての slot に対して Key off を実行 �､
;�､【 入  力 】 a6 = CPU work top addr.					 �､
;�､		d1.w = MIDI 1st. byte	0 〜 1FH ( MIDI ch# )		 �､
;�､		d2.b = MIDI 2nd. byte	0 〜 7FH ( note )		 �､
;�､		d3.b = MIDI 3rd. byte	0 〜 7FH ( velocity )		 �､
;�､【 出  力 】 なし							 �､
;�､【レジスタ】 destroy : d0,d1,d4,d5,d6				 �､
;�ｶ�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�ｺ
Note_off:	move.w	knr_kanri_ofst(a6),d5	;
		btst.b	#knr_mono,knr_MIDI_flg(a6,d5.w)	; mono mode ?
		beq	polyphonic_note_off
;		�ｱ�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�ｵ
;		�･    		モノモード：ノートオフ	  		�･
;		�ｹ�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�ｽ
NOFF_M1:	move.b	knr_MONO_NT0(a6,d5.w),d6	; Note# exist ?
		beq.s	NOFF_er_ret
		cmp.b	d2,d6			; Note# equal ?
		beq.s	NOFF_M2
		cmp.b	knr_MONO_NT1(a6,d5.w),d2	; Note# equal ?
		beq.s	NOFF_M3
		cmp.b	knr_MONO_NT2(a2,d5.w),d2	; Note# equal ?
		beq.s	NOFF_M4
		bra.s	NOFF_er_ret
NOFF_M3:	move.b	knr_MONO_NT2(a6,d5.w),knr_MONO_NT1(a6,d5.w)
NOFF_M4:	move.b	#0,knr_MONO_NT2(a6,d5.w)	; clear
NOFF_er_ret:
;@		bset.b	#7,Mem_err_bit+2	; not find Key-off slot
;@		rts
		bset.b	#ERRa_8,Mem_DRVERR_FLG+0	; key-off すべき key-on中slot
		rts				; が存在しない

NOFF_M2:
		move.b	knr_MONO_NT1(a6,d5.w),d6	;
		beq.s	NOFF_M6			; jump if [note1] nothing
		move.b	d6,knr_MONO_NT0(a6,d5.w)	;
		move.b	d6,d2			; set new Note on data
		move.b	knr_MONO_VOL(a6,d5.w),d3	;
		andi.b	#$7f,d3			; set new velocity data
		move.b	knr_MONO_NT2(a6,d5.w),knr_MONO_NT0(a6,d5.w)
		move.b	#0,knr_MONO_NT1(a6,d5.w)	; clear
		move.b	#0,knr_MONO_NT2(a6,d5.w)	; clear
		jmp	Note_on(pc)
NOFF_M6:
;@@		btst.b	#k_DMPR,k_MIDI_flg(a6,d5.w)	; 入力 MIDI ch 
;@@		beq.s	NOFF_M5				;   Damper on/off ?
;@@		;-------------------------------;
;@@		; set flg_DMPR ：ダンパーによるＫey-off未実行フラグセット
;@@
;@@		moveq	#32,d7			;
;@@		sub.w	off_slot_cnt(a6),d7	; = key-on中 slot数
;@@		beq.s	ret_12			;
;@@		subq.w	#1,d7			; loop size
;@@		lea	_KEYHISTB(a6),a0		;
;@@		lea	slot_work(a6),a4	;
;@@		move.w	HIS_off_pt(a6),d0	;
;@@NOFF_M7_lp:	andi.w	#HOPM,d0		; 0,2,4,...,3EH
;@@		move.w	(a0,d0.w),d4		;
;@@		andi.w	#KHMSK,d4		; $7C0
;@@		cmp.b	sl_MIDI(a4,d4.w),d1	; MIDI ch# equal ?
;@@		bne.s	NOFF_M7			;
;@@		cmp.b	sl_note(a4,d4.w),d2	; MIDI Note# equal ?
;@@		bne.s	NOFF_M7			;
;@@
;@@		move.w	_sl_kanri(a4,d4.w),d6	;
;@@		cmp.w	_tmp_kanri(a6),d6	; 発音管理番号 equal ?
;@@		bne.s	NOFF_M7			;
;@@
;@@		bset.b	#flg_DMPR,sl_flag2(a4,d4.w)
;@@NOFF_M7:	addq.w	#2,d0
;@@		dbra	d7,NOFF_M7_lp
;@@ret_12:	
;@@		jmp	er_26(pc)
;@@		rts
		;-------------------------------;
NOFF_M5:	move.b	d6,knr_MONO_NT0(a6,d5.w)	;

;===============================================
;	Note off ( polyphonic mode )
;-----------------------------------------------
;	in  d1 = 
;	in  d2 = 
;	in  a5 = 
;	in  a6 = 
;	break  = d0/d3/d4/d5/d6/d7/a0/a1/a2/a3/a4
;	keep   = d1/d2/a5/a6
;	free   = a3
;===============================================

polyphonic_note_off:
		lea	_KEYHISTB(a6),a0
		lea	slot_work(a6),a4

		moveq	#slot_size,d7			; clear 
		sub.w	off_slot_cnt(a6),d7		; = key-on slot数
		bne.s	OF_0				; jump if key-on slot exist
		bra	er_20

		;-------------------------------------------------------;
		; key-on 中の 同一 MIDI ch & Note# slot への key-off 実行;
		;【入力】 d7.w : key-on slot 数
		;-------------------------------------------------------;

			.public		OF_0

OF_0:
		subq.w	#1,d7				; loop size
		move.w	HIS_off_pt(a6),d0		;
	?slot_loop:
		andi.w	#HOPM,d0			; 0,2,4,...,3EH
		move.w	(a0,d0.w),d4
		andi.w	#KHMSK,d4			; $7C0

		move.b	PSPN(a4,d4.w),d6		; PCM Stream playing ?
		bmi.w	?function_false

			.if ENGN

		move.b	sl_flag1(a4,d4.w),d6		; Engine busy ?
		bmi.w	?function_false				; jump if Yes

			.endif

		cmp.b	sl_MIDI(a4,d4.w),d1		; MIDI ch# equal ?
		bne	?function_false			; jump if not equal

		cmp.b	sl_note(a4,d4.w),d2		; MIDI note# equal ?
		bne	?function_false			; jump if not equal

		move.w	_sl_kanri(a4,d4.w),d6		;
		cmp.w	_tmp_kanri(a6),d6		; 発音管理番号 equal ?
		bne	?function_false			; jump if not equal

		bclr.b	#flg_non,sl_flag2(a4,d4.w)	; set Note-off中 mode
		move.w	knr_kanri_ofst(a6),d6		;
		btst.b	#knr_DMPR,knr_MIDI_flg(a6,d6.w)	; Damper on/off ?
		bne	?function_false			; = no key-off jp if Damper on mode

		bclr.b	#flg_KON,sl_flag2(a4,d4.w)	; set key-off中 mode
		addq.w	#1,off_slot_cnt(a6)		; = key off slot数 + 1

		btst.b	#PEON_flg,sl_flag1(a4,d4.w)
		beq.s	?next_step			; jump if if PEG off

		bsr	PEG_off

;		<<<< Key-off 実行 >>>>

	?next_step:
		lsr.w	#1,d4				; = $00,$20,.....,$3E0
		move.b	SCSP_KXKB(a5,d4.w),d5		;
		andi.b	#%00000111,d5			; clear KYONB
		ori.b	#%00010000,d5			; set   KYONEX
		move.b	d5,SCSP_KXKB(a5,d4.w)		;
		add.w	d4,d4				; = $00,$40,.....,$7C0

;		<<<< KEYHISTB 更新 >>>>

		swap	d7				;
		move.w	HIS_off_pt(a6),d5		;
		andi.w	#HOPM,d5			; 0,2,4,...,3EH
		move.w	d0,d6				;
	?key_history_loop:
		move.w	d6,d7				;
		cmp.w	d6,d5				;
		beq.s	?escape				;
		move.w	(a0,d7.w),d4			;
		subq.w	#2,d6				;
		andi.w	#HOPM,d6			; 0,2,4,...,3EH
		move.w	(a0,d6.w),(a0,d7.w)		;
		move.w	d4,(a0,d6.w)			;
		bra.s	?key_history_loop
	?escape:
		addq.w	#2,HIS_off_pt(a6)
		swap	d7

	?function_false:
		addq.w	#2,d0
		dbra	d7,?slot_loop



;@OF_exit:
;		�ｱ�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�ｵ
;		�･  ＤＳＰ ＣＰＵ駆動Ｄ-Ｆilter	の検索			�･
; 		�･【入力】 a6						�･
; 		�･	   d1.w : 入力 MIDI ch#				�･
; 		�･【破壊】 a1/a2					�･
; 		�･	   d0.w/d6.w					�･
;		�ｹ�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�ｽ
		global	DFLTR_off
DFLTR_off:	lea	_DFL_ELMNT_wk(a6),a2
;@		movea.l	Mem_Snd_tool_pt,a1	; = sound tool I/F work top
		clr.w	d6			;
		move.b	DFL_ELMNT_NO(a6),d6	; エレメント数  ：Ｘ
;@		move.b	Mem_ELMNT_no(a1),d6	; = エレメント数  ：Ｘ
		beq.s	DFLTR_off_1		;
		movea.l	DFL_ELMNT_addr(a6),a1	; = Element data top
;@		movea.l	Mem_ELMNT_addr(a1),a1	; = Element data top
		subq.w	#1,d6			; loop size
		andi.w	#$1F,d6			;
DFLTR_off_3:	cmp.b	(a1),d1			; Element MIDI ch = MIDI# ?
		bne.s	DFLTR_off_2
		move.b	1(a1),d0		;
		cmpi.b	#8,d0			; 1000 ?
		beq.s	DFLTR_off_LFO		; jump if LFO
		bcs.s	DFLTR_off_2		; jump if LFO/EG off
		;-------------------------------;
DFLTR_off_EG:	move.b	#6,DFL_EG_seg(a2)	; 強制 set seg#6
		move.w	DFL_add_wk(a2),d4	; = $0000〜$FF00
		move.b	15(a1),d0		; = [RL]
		lsl.w	#8,d0			; = -$8000〜$7F00
		addi.w	#$8000,d0		; = $0000〜$FF00
		move.w	d0,DFL_level(a2)	; set 到達レベル
		cmp.w	d0,d4
		bcc.s	DFL_off_EG_1		; jump if [RL] < add_wk
		move.b	14(a1),d0		; = [RR]
		bpl.s	DFL_off_EG_2
		bra.s	DFL_off_EG_3
DFL_off_EG_1:	move.b	14(a1),d0		; = [RR]
		bmi.s	DFL_off_EG_2
DFL_off_EG_3:	neg.b	d0
DFL_off_EG_2:	jsr	get_EXPTBS(pc)		; return d0.w : -$3F01〜+$3F01
		move.w	d0,DFL_add_bs(a2)	; set rate
		bra.s	DFLTR_off_2
		;-------------------------------;
DFLTR_off_LFO:	move.w	#0,DFL_add_bs(a2)	; LFO only ( don't destroy EG )
;@		bclr.b	#7,DFL_wk_MSFC(a2)	; Note off mode
;@		bra.s	DFLTR_off_2
		;-------------------------------;
DFLTR_off_2:	lea	$18(a1),a1
		lea	$10(a2),a2
		dbra	d6,DFLTR_off_3
DFLTR_off_1:
;@@@@@@@@@@@@@@@		bclr.b	#7,bug_flag(a6)
;@@@@@@@@@@@@@@@		beq.s	bug_00
;@@@@@@@@@@@@@@@		jmp	er_26(pc)
;@@@@@@@@@@@@@@@	bug_00:
		rts

;		�ｱ�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�ｵ
;		�･  ＰＥＧ更新						�･
; 		�･【入力&保持】	a4   : slot work top			�･
;		�･		d4.w : slot work offset			�･
;		�･		d0 low : History offset point		�･
; 		�･【破壊】	a1   : 					�･
;		�･		d0 High	, d3.l , d5.l , d6.l		�･
;		�ｹ�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�｣�ｽ
		global	PEG_off
PEG_off:	swap	d0
		move.b	#6,PEG_SEG(a4,d4.w)	;
		movea.l	PEG_addr(a4,d4.w),a1	;
		addq	#8,a1			;
		move.b	(a1)+,d0		; = [RR]
		beq.s	PEG_off_3
		;-------------------------------;
		jsr	get_EXPTB2(pc)		; return d0.w:-$3F01〜+$3F01
		move.w	d0,d6
		swap	d6
		clr.w	d6
		asr.l	#4,d6			; for 4msec

		move.b	(a1),d0			; = [RL]
		jsr	get_LEVEL(pc)		; return d0.w:-$5FFF〜+$5FFF
		move.w	d0,d5			;
		swap	d5			;
		clr.w	d5			;
		move.l	d5,PEG_level(a4,d4.w)	; set 到達レベル
		addi.l	#$80000000,d5		;
		move.l	PEG_cent(a4,d4.w),d3	;
		addi.l	#$80000000,d3		;
		cmp.l	d3,d5			;
		beq.s	PEG_off_3		; jump if _cent = _level
		bcc.s	PEG_off_2		; jump if _cent < _level
		move.l	d6,d6			;
		bmi.s	PEG_off_exit		;
		bra.s	PEG_off_4
PEG_off_2:	move.l	d6,d6			;
		bpl.s	PEG_off_exit		;
PEG_off_4:	neg.l	d6
PEG_off_exit:	move.l	d6,PEG_RATE(a4,d4.w)	; set 傾き／4msec
		swap	d0
		rts

PEG_off_3:	addq.b	#1,PEG_SEG(a4,d4.w)	;
		swap	d0
		rts


er_20:		bset.b	#ERRa10,Mem_DRVERR_FLG+0	; key-off すべき key-on中slot
		rts				; が存在しない


