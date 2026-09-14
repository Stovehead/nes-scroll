; Object index in X
light_switch_init:
    lda #$00
    sta object_flags, x
    sta light_switch_state, x
    sta object_animations_frames, x
    lda #ANIM_LIGHT_SWITCH_UP
    tay
    sta object_animations_ids, x
    jsr init_animation
    lda #ANIM_LIGHT_SWITCH_UP
    lda AnimationLengths, y
    dey
    sta object_animations_frames, x

light_switch_state = object_variables_0


; Object index in X
light_switch_step:
    jmp play_animation