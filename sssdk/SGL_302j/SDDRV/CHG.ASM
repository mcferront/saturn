;		制御項目
;	drv_87	: HOST Comand $87 Mixer change
;	CTRL_10 : $Bn,$10,$xx     Mixer change
;	CTRL_20	: $Bn,$20,$xx	  Bank  change
;

	include	SCSP.LIB

; A.Miyazawa	{
			.extern		send_user
;		}

	external	BANK_init
	external	EFSDL_all_off		; MIXER[EFREG0〜F] clear

;************************************************************************
;		  ＨＯＳＴコマンド（＄８７）Ｍixer# change		*
; P1 : 0 〜 F ( 音色BANK# )					94/07/27*
; P2 : 0 〜 7F ( Mixer# )						*
;************************************************************************
	global	drv_87
drv_87:		move.b	(a0)+,d0		; P1 : 音色 BANK#
		move.b	(a0)+,d3		; P2 : Mixer#
		andi.w	#$7F,d3			;
		move.w	d3,_activ_MIX_NO(a6)	; ready Mixer#

		jsr	get_BANK_addr(pc)	; ready d0
		bcs	return_2		; jump if 音色BANK-ID nothing
		move.l	d2,_activ_MIX_BNK(a6)	;
;@		jsr	set_MIXER_wk2(pc)	;
;@		bcs.s	drv_87_er		; jump if Mixer# data nothing
		jmp	MIXER_wr(pc)		; jump and return
;@drv_87_er:	rts
;************************************************************************
;		SCSPBIN address set into [k_BANK_adr]			*
;【機能】指定音色ＢＡＮＫ"SCSPBIN"の先頭アドレスを Ａrea Ｍap カレント	*
;	 から検索して[k_BANK_adr]に格納。				*
;	 また[k_PRG_no],[k_MIDI_PAN],[k_PBend_BF]を 0 clear		*
;【入力】d0.w : 音色ＢＡＮＫ番号 ( $00〜$0F )				*
;【破壊】a0/a1/d2/d3/d7						94/07/26*
;【出力】d2.l : 音色ＢＡＮＫ top address				*
;************************************************************************
		external	er_1B
		global	get_BANK_addr
get_BANK_addr:
		andi.w	#$0f,d0			; = BANK#
		lea	bs_AMAPC,a0		; area map current work top
		moveq	#32-1,d7		; loop size
BNK_chg:	move.b	(a0),d2			; data exist ?
		bmi.s	er_IF_bit2		; jump if 音色BANK-ID nothing
		move.b	d2,d3			; = data ID & ID#
		andi.b	#$70,d2			; = data ID only
		bne.s	BNK_chg_4		; jump if not 音色BANK-ID(=0)
		andi.b	#$0F,d3			; = ID# only
		cmp.b	d0,d3			; BANK# equal ?
		beq.s	BNK_chg_3		; jump if Yes
BNK_chg_4:	lea	8(a0),a0		;
		dbra	d7,BNK_chg		;
		bra.s	er_IF_bit2		; jump if 音色BANK-ID nothing

BNK_chg_3:	move.w	(a0)+,d2		;
		andi.w	#$0F,d2			; = addr D19〜D16
		swap	d2			;
		move.w	(a0)+,d2		; = addr D15〜D0
		move.b	(a0),d3			; データ down load 済 ?
		bpl.s	er_IF_bit2		; jump if 音色BANK not ready
;@		move.l	d2,_activ_MIX_BNK(a6)	;

;@		bclr.b	#ERRb_2,Mem_err_bit+3
		clc
		rts
er_IF_bit2:	bset.b	#ERRb_2,Mem_err_bit+3
		stc
return_2:	rts
;************************************************************************
;【機能】 ＭＩＤＩコントロールチェンジ[$Bn,$10,$xx]制御。		*
;	  指定ＭＩＸＥＲデータ[EFSDL]&[EFPAN]書込み。			*
;【入力】d1.w : MIDI ch# ( 0 〜 1F )					*
;        d3.b : Parameter 00〜7FH = MIXER Number		94/07/26*
;************************************************************************
		global	CTRL_10
CTRL_10:	; 不特定（汎用操作子１）
		move.w	_tmp_kanri(a6),d2	; = 発音管理番号×200H
		lsl.w	#5,d1			; activ Mixer MIDI ch# 0〜F
		add.w	d1,d2			;		    *knr_unit
		move.l	knr_BANK_adr(a6,d2.w),d0	; = SCSPBIN top address
		beq	CTRL_10_er0		;
;@		bclr.b	#ERRb_3,Mem_err_bit+3	;
		move.l	d0,_activ_MIX_BNK(a6)	;

		andi.w	#$7F,d3			;
		move.w	d3,_activ_MIX_NO(a6)	; ready Mixer#
;@		bra	MIXER_wr
;************************************************************************
;			ＭＩＸＥＲ 更新					*
;【機能】ＭＩＸＥＲデータを"mixer_wk"に転送後、ＳＣＳＰに書込。		*
;【入力】[_activ_MIX_BNK] MIXデータのある音色BANK先頭アドレス		*
;	 [_activ_MIX_NO]  MIXER#					*
;************************************************************************
		global	MIXER_wr
MIXER_wr:
		move.l	_activ_MIX_BNK(a6),d0	; = SCSPBIN top address
		beq.s	er_IF_bit0
		movea.l	d0,a0
		move.w	_activ_MIX_NO(a6),d0	; ready Mixer#
		movea.l	a0,a1			;
		adda.w	BIN_VL(a0),a1		; = V-L data top
		adda.w	BIN_MIX(a0),a0		; = MIXER top addr

		add.w	d0,d0			;
		adda.w	d0,a0			; +  2*Mixer#
		lsl.w	#3,d0			; + 16*Mixer#
		adda.w	d0,a0			; = desti. Mixer addr

		cmpa.l	a1,a0
		bcc.s	er_IF_bit0		; jump if not find Mixer
		lea	mixer_wk_SCSP(a6),a2	;
		move.l	(a0)+,(a2)+		;
		move.l	(a0)+,(a2)+		;
		move.l	(a0)+,(a2)+		;
		move.l	(a0)+,(a2)+		;
;@		move.w	(a0)+,(a2)+		;
;@		bclr.b	#ERRb_0,Mem_err_bit+3
		;************************************************
		;    ＭＩＸＥＲ （Effect Return & Pan ) 更新	*
		;【機能】 mixer_wk データを "ＥＦＲＥＧ"に書込。*
		;************************************************
		global	MIXER_wk_wr
MIXER_wk_wr:
		move.b	EFCT_CHG_CNT(a6),d0	; Effect change exe mode ?
		bne.s	MIXER_ret0		; jump if Yes

		lea	mixer_wk_SCSP(a6),a0
;@		moveq	#18-1,d7		; loop size
		moveq	#16-1,d7		; loop size 95/02/21
		move.b	SND_OUT_ST(a6),d4	; MONO/STEREO status
		bmi.s	MIXER_MONO
		; <<<< Stereo mode >>>>
		clr.w	d4
MIXER_wr1_lp:	move.b	(a0)+,SCSP_EFSDLPN(a5,d4.w)
		addi.w	#SCSP_slot_unit,d4
		dbra	d7,MIXER_wr1_lp
MIXER_ret0:	rts
		; <<<< MONO mode >>>>
MIXER_MONO:	clr.w	d4
MIXER_wk_wr_lp:	move.b	(a0)+,d0
		andi.b	#$E0,d0			; --> Center
		move.b	d0,SCSP_EFSDLPN(a5,d4.w)
		addi.w	#SCSP_slot_unit,d4
		dbra	d7,MIXER_wk_wr_lp
		clc
		rts
er_IF_bit0:	bset.b	#ERRb_0,Mem_err_bit+3
		jmp	EFSDL_all_off(pc)	; MIXER[EFREG0〜F] clear
;@		rts
CTRL_10_er0:	bset.b	#ERRb_3,Mem_err_bit+3

; A.Miyazawa	{
		move.b	#ILLEGAL_MIXER_CHANGE,d0
		bsr	send_user
;		}

		jmp	EFSDL_all_off(pc)	; MIXER[EFREG0〜F] clear
;@		stc
;@		rts
;************************************************************************
; Command I/F = $08	  Map change					;
;	P1 : Map# ( 00H 〜 FFH )					;
;	P2 : reserved							;
;************************************************************************
		global	seq_map
seq_map:	move.b	(a0)+,d0		; P1 ready d0 : ( 0 〜 7 )
		andi.w	#$FF,d0			;
		jsr	MAP_chg(pc)		; ready d0
		jmp	BANK_init(pc)
;@@@@@		clc
;@@@@@		rts
;************************************************************************
;			    ＡＲＥＡ ＭＡＰ 更新			*
;【機能】指定されたＭＡＰをスペア領域からカレント領域に転送。		*
;【入力】d0.w : MAP#	( $00〜$FF )					*
;【出力】CY = error / NC = complete				94/07/26*
;************************************************************************
		global	MAP_chg
MAP_chg:
		lea	bs_AMAPC,a0		; area map current work top
		moveq	#$100/4-1,d7		;
		moveq	#0,d4			;
MAP_clear:	move.l	d4,(a0)+		; clear map current work 
		dbra	d7,MAP_clear		;
		;-------------------------------;
		lea	knr_BANK_adr(a6),a0	;
		move.w	#8*16-1,d7		; 発音管理番号数×MIDI-ch数
		moveq	#0,d4
k_BANK_adr_clr:	move.l	d4,(a0)			; = clear SCSPBIN top address
		lea	knr_unit(a0),a0		;
		dbra	d7,k_BANK_adr_clr
		;-------------------------------;
		lea	slot_work(a6),a0	;
		move.w	#slot_size-1,d7
		moveq	#0,d4
sl_flg_clr:	move.b	d4,sl_flag1(a0)		; clear slot_work[sl_flag1]
		move.b	d4,PSPN(a0)		; clear slot_work[PSPN]
		move.l	d4,sl_layer_adr(a0)	; clear slot_work[sl_layer_adr]
		lea	slot_wk_unit(a0),a0
		dbra	d7,sl_flg_clr
		;-------------------------------;
		lea	bs_AREAM,a0		; Area Map スペア領域 top
		lea	bs_AREAM+sz_AREAM,a1
		;-------------------------------;
		andi.w	#$FF,d0
		beq	MAP_chg_ex		; jump if Map#0
		subq.w	#1,d0			; = loop size
MAP_chg_lp:	move.b	(a0),d1			; = E , data ID & ID#
		bmi.s	MAP_chg_3		; jump if Map unit end
		lea	8(a0),a0		;
		cmpa.l	a0,a1
		bcs.s	er_IF_bit1		; jump if not find MAP
		bra	MAP_chg_lp
MAP_chg_3:	addq.l	#1,a0			;
		dbra	d0,MAP_chg_lp
		;-------------------------------;
		; a0 : 該当 MAP unit top address
		;-------------------------------;
MAP_chg_ex:	lea	bs_AMAPC,a2		; area map current work top
		moveq	#256/8-1,d7		; loop size
MAP_chg_2lp:	move.b	(a0)+,(a2)+		; = E , data ID , ID#
		move.b	(a0)+,(a2)+		; = start addr H
		move.b	(a0)+,(a2)+		; = 	//     M
		move.b	(a0)+,(a2)+		; = 	//     L
		move.b	(a0)+,(a2)+		; = L
		move.b	(a0)+,(a2)+		; = size H
		move.b	(a0)+,(a2)+		; =  //  M
		move.b	(a0)+,(a2)+		; =  //  L
		dbra	d7,MAP_chg_2lp
		;-------------------------------;
		lea	DSP_COEF(a5),a0		;
		move.w	#$500/4-1,d7		; loop size
		moveq	#0,d0			;
MAP_chg_DSP:	move.l	d0,(a0)+		;
		dbra	d7,MAP_chg_DSP		;
;@		bclr.b	#ERRb_1,Mem_err_bit+3	;
		;-------------------------------;
	if	ENGN
	external	ENGN_init
		bsr.w	ENGN_init
	endif
		rts
		;-------------------------------;
er_IF_bit1:	bset.b	#ERRb_1,Mem_err_bit+3	;
		rts
;************************************************************************
;【機能】 ＭＩＤＩコントロールチェンジ[$Bn,$20,$xx]制御。		*
;		<<  音色 ＢＡＮＫ チェンジ >>				*
;		set dest. SCSPBIN top addr    ---> knr_BANK_adr		*
;		set MIDI Volume initial value ---> knr_MIDI_VOL		*
;		exe Prg change(Prg#=0)					*
;【入力】d1.w : MIDI ch# ( $00〜$1F )					*
;	 d3.b : Parameter					94/07/26*
;************************************************************************

; A.Miyazawa	{

;	global	CTRL_20
;CTRL_20_er:	rts
;CTRL_20:	move.w	d3,d0			; ready d0 : tone-BANK#
;		jsr	get_BANK_addr(pc)	; d2.l = desti. tone-BANK addr
;		bcs.s	CTRL_20_er		; d1.w = MIDI ch#
;		move.w	d1,d0			; = MIDI ch#
;		lsl.w	#5,d0			; = MIDIch#*knr_unit
;		add.w	_tmp_kanri(a6),d0	; + 発音管理番号×200H
;		move.l	d2,knr_BANK_adr(a6,d0.w)	;
;
;		move.b	#init_MIDI_VOL,knr_MIDI_Volume(a6,d0.w)
;		move.b	#init_MIDI_VOL,knr_MIDI_7(a6,d0.w)
;		move.b	#init_MIDI_VOL,knr_MIDI_11(a6,d0.w)
;
;		moveq	#0,d2			; ready d2 : MIDI Prg#
;		move.w	_tmp_MIDI_ch(a6),d1	; ready d1 : MIDI ch#
;;@		bra.w	PRG_chg			;


			.public		CTRL_20
CTRL_20:
		move.w	d3,d0
		bsr	get_BANK_addr

		bcs.s	?bank_not_found

		move.w	d1,d0
		lsl.w	#5,d0
		add.w	_tmp_kanri(a6),d0
		move.l	d2,knr_BANK_adr(a6,d0.w)

;		move.w	#default_volume,midi_master_volume(a6,d0.w)
;		move.w	#default_volume,midi_volume(a6,d0.w)
;		move.w	#default_volume,midi_expression(a6,d0.w)

		clc
		rts

	?bank_not_found:
		move.b	#BANK_NOT_FOUND,d0
		bsr	send_user
		rts

;		}

;************************************************************************
;【機能】 ＭＩＤＩプログラム（音色）チェンジ[$Cn,$xx]制御		*
;		set   MIDI Prg# 	     ---> knr_PROG_no		*
;		clear MIDI Pitch Bend buffer ---> knr_PBend_BF		*
;		set   Sequence PAN bit	     ---> knr_MIDI_PAN		*
;【入力】d1.w : MIDI ch# ( 0 〜 1F )			       		*
;	 d2.b : MIDI Program change# ( 00 〜 7FH )			*
;【destroy】a0/d0/d1						94/07/26*
;************************************************************************

; A.Miyazawa	{

;		external	er_08
;		global	PRG_chg
;PRG_chg:
;		andi.w	#$7f,d2			; = Prgram#
;		move.w	knr_kanri_ofst(a6),d0	;
;		move.l	knr_BANK_adr(a6,d0.w),d3	; = desti. SCSPBIN top
;		beq.s	PRG_chg_er1			;
;		movea.l	d3,a0
;;@		bclr.b	#ERRb_4,Mem_err_bit+3	;
;		moveq	#BIN_VOICE,d3		; = 8
;		add.w	d2,d3			; + Prg#
;		add.w	d2,d3			; + Prg# = offset addr
;		cmp.w	BIN_MIX(a0),d3		; Mixer offset addr
;		bcc.s	PRG_chg_er2		; jump if Voice# too large
;;@		bclr.b	#ERRb_5,Mem_err_bit+3	;
;		move.b	d2,knr_PROG_no(a6,d0.w)	; <<< set MIDI Prg# >>>
;		moveq	#0,d3			;
;		move.w	d3,knr_PBend_BF(a6,d0.w)	; <<< clear Pitch Bend >>>
;		;-------------------------------;
;;		global	PRG_chg_PAN
;PRG_chg_PAN:	move.b	knr_MIDI_PAN(a6,d0.w),d3	; clear PAN buffer
;		btst	#6,d3			; SEQ PAN on ?
;		bne.w	PRG_chg_PAN1		; jump if on
;		andi.b	#$7F,d3			;
;		move.b	d3,knr_MIDI_PAN(a6,d0.w)	;
;PRG_chg_PAN1:
;	if	sw_MODEL_M
;		cmpi.w	#$E00,_tmp_kanri(a6)	; = 発音管理番号＝７？
;		bne	PRG_chg_ret		;
;		lea	bs_MONTR,a0		;
;		add.w	d1,d1			;
;		add.w	d1,d1			;
;		andi.w	#$7C,d1			;
;		move.b	d2,Mem_MVC(a0,d1.w)	; set Tool I/F Monitor(Voice#)
;	endif
;PRG_chg_ret:	clc
;		rts
;PRG_chg_er2:	bset.b	#ERRb_5,Mem_err_bit+3	;
;		stc
;		rts
;PRG_chg_er1:	bset.b	#ERRb_4,Mem_err_bit+3	;
;		stc
;		rts
;
;
			.extern		er_08
			.public		PRG_chg
PRG_chg:
		andi.w	#$007f,d2			; d2=program number
		move.w	knr_kanri_ofst(a6),d0
		move.l	knr_BANK_adr(a6,d0.w),d3	; = desti. SCSPBIN top
		beq.s	error1

		movea.l	d3,a0
		moveq	#BIN_VOICE,d3			; = 8
		add.w	d2,d3				; + Prg#
		add.w	d2,d3				; + Prg# = offset addr
		cmp.w	BIN_MIX(a0),d3			; Mixer offset addr
		bcc.s	error2				; jump if Voice# too large

		move.b	d2,knr_PROG_no(a6,d0.w)		; <<< set MIDI Prg# >>>
		moveq	#0,d3				;
		move.w	d3,knr_PBend_BF(a6,d0.w)	; <<< clear Pitch Bend >>>

	?prg_chg_pan:
		move.b	knr_MIDI_PAN(a6,d0.w),d3	; clear PAN buffer
		btst	#6,d3				; SEQ PAN on ?
		bne.w	?100				; jump if on
		andi.b	#$7F,d3
		move.b	d3,knr_MIDI_PAN(a6,d0.w)
	?100:
			.if sw_MODEL_M

		cmpi.w	#$E00,_tmp_kanri(a6)		; = 発音管理番号＝７？
		bne	PRG_chg_ret
		lea	bs_MONTR,a0
		add.w	d1,d1
		add.w	d1,d1
		andi.w	#$7C,d1
		move.b	d2,Mem_MVC(a0,d1.w)		; set Tool I/F Monitor(Voice#)

			.endif

	PRG_chg_ret:
		clc
		rts
error2:
		move.b	#PROGRAM_NOT_FOUND,d0
		bsr	send_user
		bset.b	#ERRb_5,Mem_err_bit+3
		stc
		rts
error1:
		move.b	#BANK_NOT_AVAIRABLE,d0
		bsr	send_user
		bset.b	#ERRb_4,Mem_err_bit+3
		stc
		rts


;		}
