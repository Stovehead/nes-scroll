ANIM_LIGHT_SWITCH_DOWN_FRAME_0 = $06
ANIM_LIGHT_SWITCH_UP_FRAME_0 = $0A

; Object index in X
light_switch_init:
    lda #$00
    sta object_flags, x
    sta light_switch_state, x
    sta light_switch_collision_last_frame, x
    lda level_flags
    and #LIGHTS_OFF
    beq :+
    lda #ANIM_LIGHT_SWITCH_UP_FRAME_0
    jmp :++
    :
    .if ANIM_LIGHT_SWITCH_UP_FRAME_0 <> 0
    lda #ANIM_LIGHT_SWITCH_DOWN_FRAME_0
    .endif
    :
    sta object_current_metasprites, x
    rts

light_switch_state = object_variables_0
light_switch_collision_last_frame = object_variables_1
LIGHT_SWITCH_STILL = 0
LIGHT_SWITCH_MOVING = 1
LIGHT_SWITCH_FADE_LENGTH = 6

; Object index in X
light_switch_step:
    jsr check_object_on_screen
    bne :+
    sta object_ids, x
    jmp despawn_object
    :
    lda skip_light_switch_collision
    beq :+
    rts
    :
    lda light_switch_state, x
    beq :+
    jmp light_switch_moving_step
    :

light_switch_still_step:
    stx scratch
    jsr load_object_collision
    ldx scratch
    ldy #$00 ; Player should always be in slot 0
    jsr test_object_collision
    beq @not_colliding_with_player
    sta skip_light_switch_collision
    lda light_switch_collision_last_frame, x
    bne @after_determine_collision
    lda level_flags
    eor #LIGHTS_OFF
    sta level_flags
    and #LIGHTS_OFF
    bne :+
    lda #ANIM_LIGHT_SWITCH_UP
    jmp :++
    :
    lda #ANIM_LIGHT_SWITCH_DOWN
    :
    sta scratch + 6
    lda level_flags
    lda #LIGHT_SWITCH_FADE_LENGTH
    sta light_fade_timer
    ldy #$0F
    txa
    pha
    @loop_begin:
    lda object_ids, y
    cmp #LIGHT_SWITCH_OBJECT
    bne @loop_end
    lda #LIGHT_SWITCH_MOVING
    sta light_switch_state, y
    tya
    tax
    pha
    lda scratch + 6
    sta object_animations_ids, x
    tay
    jsr init_animation
    pla
    tay
    @loop_end:
    dey
    bne @loop_begin
    pla
    tax
    @after_determine_collision:
    lda #$01
    sta light_switch_collision_last_frame, x
    rts
    @not_colliding_with_player:
    lda #$00
    sta light_switch_collision_last_frame, x
    rts

light_switch_moving_step:
    jsr play_animation
    ldy object_animations_ids, x
    lda object_animations_frames, x
    clc
    adc #$01
    cmp AnimationLengths, y
    bcc :+
    lda #LIGHT_SWITCH_STILL
    sta light_switch_state, x
    .if LIGHT_SWITCH_STILL <> 0
    lda #$00
    .endif
    sta skip_light_switch_collision
    :
    rts