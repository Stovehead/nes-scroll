; Object index in X
player_init:
    lda #$10
    sta object_x_positions, x
    lda #176
    sta object_y_positions, x
    lda #$00
    sta object_x_page_subpixels, x
    sta object_y_page_subpixels, x
    sta object_flags, x
    sta object_animation_timers, x
    sta object_animations_frames, x
    sta object_animations_ids, x
    sta object_variables_0, x
    sta object_variables_1, x
    sta object_variables_2, x
    sta object_variables_3, x
    sta object_variables_4, x
    sta object_variables_5, x
    .if ANIM_PLAYER_IDLE_FRAME <> 0
    lda #ANIM_PLAYER_IDLE_FRAME
    .endif
    sta object_current_metasprites, x
    .if ANIM_PLAYER_IDLE_LENGTH <> ANIM_PLAYER_IDLE_FRAME
    lda #ANIM_PLAYER_IDLE_LENGTH
    .endif
    sta object_animation_timers, x
    rts

; Object index in X
player_x_velocity = object_variables_0
player_y_velocity = object_variables_1
PLAYER_ACCELERATION = 2 ; subpixels per frame
PLAYER_MAX_SPEED = 24 ; subpixels per frame
PLAYER_WIDTH = 16
player_step:
    lda object_animations_ids, x
    sta scratch + 2 ; Flag for new animation playing
    lda controller_input
    and #BUTTON_RIGHT + BUTTON_LEFT
    beq @not_pressing_anything
    cmp #BUTTON_RIGHT + BUTTON_LEFT
    beq @not_pressing_anything
    and #BUTTON_RIGHT
    beq @pressing_left
    ; If pressing right
    lda #ANIM_PLAYER_WALK
    sta scratch + 2
    lda player_x_velocity, x
    clc
    adc #PLAYER_ACCELERATION
    cmp #PLAYER_MAX_SPEED
    bcc :+
    lda #PLAYER_MAX_SPEED
    :
    jmp @after_determine_x_velocity
    @pressing_left:
    lda #ANIM_PLAYER_WALK
    sta scratch + 2
    lda player_x_velocity, x
    sec
    sbc #PLAYER_ACCELERATION
    cmp #256 - PLAYER_MAX_SPEED
    bcs :+
    lda #256 - PLAYER_MAX_SPEED
    :
    jmp @after_determine_x_velocity
    @not_pressing_anything:
    lda #ANIM_PLAYER_IDLE
    sta scratch + 2
    lda player_x_velocity, x
    cmp #%10000000
    bcc @decrease_x_velocity
    lda player_x_velocity, x
    clc
    adc #PLAYER_ACCELERATION
    bcc :+
    lda #$00
    :
    jmp @after_determine_x_velocity
    @decrease_x_velocity:
    lda player_x_velocity, x
    sec
    sbc #PLAYER_ACCELERATION
    bcs :+
    lda #$00
    :
    @after_determine_x_velocity:
    sta player_x_velocity, x
    lda player_x_velocity, x
    beq :++
    cmp #%10000000
    bcc :+
    lda object_flags, x
    ora #OBJECT_FLIPPED_H
    sta object_flags, x
    jmp :++
    :
    lda object_flags, x
    and #255 - OBJECT_FLIPPED_H
    sta object_flags, x
    :
    lda object_x_page_subpixels, x
    and #SUBPIXEL_MASK
    clc
    adc player_x_velocity, x
    sta scratch + 3 ; Store x offset
    and #SUBPIXEL_MASK
    sta scratch + 4 ; Store new subpixel value
    lda object_x_page_subpixels, x
    and #PAGE_MASK
    ora scratch + 4
    sta object_x_page_subpixels, x
    lda scratch + 3
    lsr
    lsr
    lsr
    cmp #%00010000
    bcc @positive_x_velocity
    ora #%11100000
    clc
    adc object_x_positions, x
    sta object_x_positions, x
    bcs @after_add_x_velocity
    lda object_x_page_subpixels, x
    and #PAGE_MASK
    bne :+
    lda #$00
    sta object_x_positions, x
    sta object_x_page_subpixels, x
    jmp @after_add_x_velocity
    :
    sec
    sbc #SUBPIXEL_MASK + 1
    sta object_x_page_subpixels, x
    jmp @after_add_x_velocity
    @positive_x_velocity:
    clc
    adc object_x_positions, x
    sta object_x_positions, x
    bcc :+
    lda object_x_page_subpixels, x
    adc #SUBPIXEL_MASK
    sta object_x_page_subpixels, x
    :
    @after_add_x_velocity:
    lda scratch + 2
    cmp object_animations_ids, x
    beq :+
    sta object_animations_ids, x
    jsr init_animation
    jmp :++
    :
    jsr play_animation
    :
    rts