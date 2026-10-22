; Object index in X
electric_gate_init:
    lda #$00
    sta object_flags, x
    lda level_flags
    and #LIGHTS_OFF
    beq :+
    ldy #ANIM_ELECTRIC_GATE_OFF
    lda #$00
    jmp :++
    :
    ldy #ANIM_ELECTRIC_GATE_ON
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
    lda #ANIM_ELECTRIC_GATE_OFF
    jmp :++
    :
    lda #ANIM_ELECTRIC_GATE_ON
    :
    sta object_animations_ids, x
    tay
    jmp init_animation
    @no_change_in_state:
    jmp play_animation

; Player index in X, this index in Y
electric_gate_handle_player_collision:
    lda level_flags
    and #LIGHTS_OFF
    bne :+
    jsr test_object_collision
    bne :++
    :
    jmp player_reload_y
    :
    lda player_invincibility_timer, x
    beq :+
    inc player_hp
    lda #$00
    sta player_invincibility_timer, x
    lda object_flags, x
    and #$FF ^ OBJECT_IS_HIDDEN
    sta object_flags, x
    :
    txa
    pha
    ldy #SFX::SHOCKED
    jmp player_deal_damage_after_load_sound_effect