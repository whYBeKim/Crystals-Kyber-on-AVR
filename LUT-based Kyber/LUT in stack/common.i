
/*
 * common.i
 *
 * Created: 2022-10-14 오전 2:02:43
 */ 

 .macro mc_prolog from:req, to:req
	push \from
.if     \to-\from
	push_range "(\from+1)",\to
.endif
	push R28
	push R29
.endm

.macro mc_epilog from:req, to:req
	pop R29
	pop R28
	pop \to
.if     \to-\from
	pop_range \from,"(\to-1)"
.endif
.endm

.macro push_range from:req, to:req
	push \from
.if     \to-\from
	push_range "(\from+1)",\to
.endif
.endm

.macro pop_range from:req, to:req
	pop \to
.if     \to-\from
	pop_range \from,"(\to-1)"
.endif
.endm