; Object index in X
electric_gate_init:
    lda #$00
    sta object_flags, x
    lda level_flags
    and #LIGHTS_OFF
    beq :+
    ldy #$05
    lda #$00
    jmp :++
    :
    ldy #$06
    lda #LIGHTS_OFF
    :
    sta electric_gate_enabled, x
    tya
    sta object_animations_ids, x
    jmp init_animation

electric_gate_enabled = object_variables_0

; Object index in X
electric_gate_step:
    jsr check_object_on_screen
    bne :+
    sta object_ids, x
    jmp despawn_object
    :
    lda level_flags
    and #LIGHTS_OFF
    eor electric_gate_enabled, x
    beq @no_change_in_state
    lda level_flags
    and #LIGHTS_OFF
    sta electric_gate_enabled, x
    beq :+
    lda #$05
    jmp :++
    :
    lda #$06
    :
    sta object_animations_ids, x
    tay
    jmp init_animation
    @no_change_in_state:
    jmp play_animation