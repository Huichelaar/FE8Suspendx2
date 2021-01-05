.thumb

push  {r4-r6, r14}
mov   r5, r0


@ Overwritten by hook, check for A input.
ldr   r0, =KeyStatusBuffer
ldrh  r6, [r0, #0x8]
mov   r1, #0x1
and   r1, r6
cmp   r1, #0x0
beq   L1

  mov   r1, sp
  ldr   r0, [r1, #0xC]
  add   r0, #0xC
  str   r0, [r1, #0xC]
  mov   r0, #0x29
  mov   r1, #0x0
  strb  r1, [r5, r0]
  b     Return


L1:
ldr   r0, =Procs_SaveMenu
ldr   r4, =Find6C
bl    GOTO_R4
cmp   r0, #0x0
beq   Return                          @ Don't listen to L if there's no SaveMenu
cmp   r5, r0
bne   Return                          @ Don't listen to L if we're not SaveMenu
mov   r1, #0x42
ldrh  r1, [r5, r1]
cmp   r1, #0x1
bne   Return                          @ Don't listen to L if we're not resuming.
mov   r3, #0x41
ldsb  r2, [r5, r3]
cmp   r2, #0x0
ble   Return                          @ Don't listen to L if no backup or no undo's left.

@ Check for L input
mov   r0, #0x1
lsl   r0, #0x9
and   r0, r6
cmp   r0, #0x0
beq   Return

  mov   r1, sp
  ldr   r0, [r1, #0xC]
  add   r0, #0xC
  str   r0, [r1, #0xC]
  mov   r0, #0x29
  mov   r1, #0x0
  strb  r1, [r5, r0]
  
  @ Decrement backupcounter
  sub   r2, #0x1
  strb  r2, [r5, r3]


Return:
mov   r0, r6
pop   {r4-r6}
pop   {r1}
bx    r1
GOTO_R4:
bx    r4
