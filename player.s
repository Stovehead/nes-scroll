; Object index in X
player_init:
    lda #$10
    sta object_x_positions, x
    lda #176
    sta object_y_positions, x
    lda #PLAYER_IS_GROUNDED
    sta player_flags, x
    lda #$00
    sta object_x_page_subpixels, x
    sta object_y_page_subpixels, x
    sta object_flags, x
    sta object_animation_timers, x
    sta object_animations_frames, x
    sta object_animations_ids, x
    sta object_variables_0, x
    sta object_variables_1, x
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

.macro get_collision_at_point XOffset, YOffset
    stx scratch + 3
    sty scratch + 4
    lda object_x_page_subpixels, x ; Get page
    lsr
    lsr
    lsr
    sta scratch + 10 ; Store in parameter location
    lda object_x_positions, x ; Get X position
    .if XOffset <> 0
    clc
    adc #XOffset
    .endif
    sta scratch + 11 ; Store in parameter location
    lda scratch + 10 ; Update page if X position wrapped
    adc #$00
    sta scratch + 10
    lda object_y_positions, x ; Get Y Position
    .if YOffset <> 0
    clc
    adc #YOffset
    .endif
    sta scratch + 12 ; Store in parameter location
    jsr test_collision
.endmacro

; Object index in X
player_x_velocity = object_variables_0
player_y_velocity = object_variables_1
player_flags = object_variables_2
PLAYER_IS_GROUNDED = %00000001
PLAYER_ACCELERATION = 4 ; subpixels per frame
PLAYER_MAX_SPEED = 16 ; subpixels per frame
PLAYER_JUMP_VELOCITY = 256 - 44 ; subpixels per frame
PLAYER_WIDTH = 16
player_step:
    lda object_animations_ids, x
    sta scratch + 2 ; Flag for new animation playing
    lda player_y_velocity, x ; Apply gravity
    cmp #128 ; Check if velocity is negative
    bcc :+
    adc #LIGHT_GRAVITY ; Use lighter gravity if going upwards
    jmp :++
    :
    clc
    adc #GRAVITY ; Otherwise use regular gravity
    :
    cmp #128
    bcs :+
    cmp #TERMINAL_VELOCITY 
    bcc :+
    lda #TERMINAL_VELOCITY ; Cap downwards velocity
    :
    sta player_y_velocity, x
    lda object_y_page_subpixels, x ; Add Y velocity to position
    and #SUBPIXEL_MASK
    clc
    adc player_y_velocity, x
    sta scratch + 5 ; Store our new subpixel position for recombination later
    cmp #SUBPIXEL_MASK ; Check if subpixel overflowed
    bcc @after_increment_y_position ; Skip incrementing position if it didn't
    and #PAGE_MASK ; Get whole part to add
    lsr
    lsr
    lsr
    tay
    lda player_flags, x ; Since our position changed, reset the grounded flag
    and #$FF ^ PLAYER_IS_GROUNDED
    sta player_flags, x
    tya
    cmp #%00010000 ; Check if it's negative (offset by 3 bits because of the shifts)
    bcc @positive_y_velocity
    ora #%11100000 ; Make negative before adding
    clc
    adc object_y_positions, x
    bcs :+
    sbc #15 ; If it underflowed, account for the 16 pixels at the bottom of the screen we can't use
    :
    jmp @after_add_y_velocity
    @positive_y_velocity:
    clc
    adc object_y_positions, x
    bcs :+
    cmp #240
    bcc @after_add_y_velocity
    :
    adc #15
    @after_add_y_velocity:
    sta object_y_positions, x
    lda scratch + 5 ; Apply subpixels we stored earlier
    and #SUBPIXEL_MASK
    sta scratch + 5
    lda object_y_page_subpixels, x
    and #PAGE_MASK
    ora scratch + 5
    sta object_y_page_subpixels, x
    ldy #$08 ; Limit collision checks to 8 so that we don't infinitely loop
    lda player_y_velocity, x
    bne @after_increment_y_position
    jmp @after_vertical_collision ; Don't check vertical collision if Y velocity is 0
    @after_increment_y_position:
    bpl @test_floor_collision_left ; Don't check ceiling collision if Y velocity is positive
    jmp @test_ceiling_collision_left
    @test_floor_collision_left:
    get_collision_at_point 5, 15
    ldx scratch + 3
    and #COLLISION_TOP
    beq @after_test_floor_collision_left ; Ignore this tile if it's not solid on top
    lda object_y_page_subpixels, x ; Set subpixel back to 0
    and #PAGE_MASK
    sta object_y_page_subpixels, x
    lda object_y_positions, x
    sec
    sbc #$01 ; Snap position up
    and #$F0
    sta object_y_positions, x
    lda #$00
    sta player_y_velocity, x ; Reset Y velocity
    lda player_flags, x
    ora #PLAYER_IS_GROUNDED
    sta player_flags, x ; Store that we're on the ground
    ldy scratch + 4
    dey
    bne @test_floor_collision_left
    jmp @after_vertical_collision
    @after_test_floor_collision_left:
    @test_floor_collision_right:
    get_collision_at_point 10, 15
    ldx scratch + 3
    and #COLLISION_TOP
    beq @after_test_floor_collision_right
    lda object_y_page_subpixels, x
    and #PAGE_MASK
    sta object_y_page_subpixels, x
    lda object_y_positions, x
    sec
    sbc #$01
    and #$F0
    sta object_y_positions, x
    lda #$00
    sta player_y_velocity, x
    lda player_flags, x
    ora #PLAYER_IS_GROUNDED
    sta player_flags, x ; Store that we're on the ground
    ldy scratch + 4
    dey
    bne @test_floor_collision_right
    jmp @after_vertical_collision
    @after_test_floor_collision_right:
    jmp @after_vertical_collision
    @test_ceiling_collision_left:
    get_collision_at_point 5, 0
    ldx scratch + 3
    and #COLLISION_BOTTOM
    beq @after_test_ceiling_collision_left
    lda object_y_page_subpixels, x
    and #PAGE_MASK
    sta object_y_page_subpixels, x
    lda object_y_positions, x
    clc
    adc #16
    and #$F0
    sta object_y_positions, x
    lda #$00
    sta player_y_velocity, x
    ldy scratch + 4
    dey
    bne @test_ceiling_collision_left
    jmp @after_vertical_collision
    @after_test_ceiling_collision_left:
    @test_ceiling_collision_right:
    get_collision_at_point 10, 0
    ldx scratch + 3
    and #COLLISION_BOTTOM
    beq @after_test_ceiling_collision_right
    lda object_y_page_subpixels, x
    and #PAGE_MASK
    sta object_y_page_subpixels, x
    lda object_y_positions, x
    clc
    adc #16
    and #$F0
    sta object_y_positions, x
    lda #$00
    sta player_y_velocity, x
    ldy scratch + 4
    dey
    bne @test_ceiling_collision_right
    @after_test_ceiling_collision_right:
    @after_vertical_collision:
    lda controller_input
    and #BUTTON_RIGHT + BUTTON_LEFT ; Check if we're pressing left or right
    beq @not_pressing_anything
    cmp #BUTTON_RIGHT + BUTTON_LEFT ; Ignore horizontal inputs if pressing left and right
    beq @not_pressing_anything
    and #BUTTON_RIGHT
    beq @pressing_left
    ; If pressing right
    lda player_flags, x
    and #PLAYER_IS_GROUNDED
    beq :+
    lda #ANIM_PLAYER_WALK ; If we're on the ground and pressing right, play the walk animation
    sta scratch + 2
    :
    lda player_x_velocity, x
    clc
    adc #PLAYER_ACCELERATION
    cmp #128
    bcs :+
    cmp #PLAYER_MAX_SPEED ; Cap horizontal speed
    bcc :+
    lda #PLAYER_MAX_SPEED
    :
    jmp @after_determine_x_velocity
    @pressing_left:
    lda player_flags, x
    and #PLAYER_IS_GROUNDED
    beq :+
    lda #ANIM_PLAYER_WALK
    sta scratch + 2
    :
    lda player_x_velocity, x
    sec
    sbc #PLAYER_ACCELERATION
    cmp #128
    bcc :+
    cmp #256 - PLAYER_MAX_SPEED
    bcs :+
    lda #256 - PLAYER_MAX_SPEED
    :
    jmp @after_determine_x_velocity
    @not_pressing_anything:
    lda player_flags, x
    and #PLAYER_IS_GROUNDED
    beq :+
    lda #ANIM_PLAYER_IDLE ; Play idle animation if on the ground
    sta scratch + 2
    :
    lda player_x_velocity, x ; Move velocity towards 0
    cmp #%10000000
    bcc @decrease_x_velocity
    lda player_x_velocity, x ; If velocity is negative
    clc
    adc #PLAYER_ACCELERATION
    bcc :+
    lda #$00
    :
    jmp @after_determine_x_velocity
    @decrease_x_velocity:
    lda player_x_velocity, x ; If velocity is positive
    sec
    sbc #PLAYER_ACCELERATION
    bcs :+
    lda #$00
    :
    @after_determine_x_velocity:
    sta player_x_velocity, x
    tay ; Reset zero flag
    beq :++ ; Don't change the direction if the velocity is 0
    cmp #%10000000
    bcc :+
    lda object_flags, x
    ora #OBJECT_FLIPPED_H ; Flip if facing to the left
    sta object_flags, x
    jmp :++
    :
    lda object_flags, x
    and #$FF ^ OBJECT_FLIPPED_H ; Unflip if facing to the right
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
    sta player_x_velocity, x
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
    ldy #$08
    @test_wall_collision_top_right:
    get_collision_at_point 13, 2
    ldx scratch + 3
    and #COLLISION_RIGHT
    beq @after_test_wall_collision_top_right
    lda object_x_page_subpixels, x
    and #PAGE_MASK
    sta object_x_page_subpixels, x
    lda object_x_positions, x
    clc
    adc #13
    and #$F0
    sec
    sbc #14
    sta object_x_positions, x
    lda #$00
    sta player_x_velocity, x
    ldy scratch + 4
    dey
    bne @test_wall_collision_top_right
    jmp @after_test_wall_collision
    @after_test_wall_collision_top_right:
    @test_wall_collision_bottom_right:
    get_collision_at_point 13, 12
    ldx scratch + 3
    and #COLLISION_RIGHT
    beq @after_test_wall_collision_bottom_right
    lda object_x_page_subpixels, x
    and #PAGE_MASK
    sta object_x_page_subpixels, x
    lda object_x_positions, x
    clc
    adc #13
    and #$F0
    sec
    sbc #14
    sta object_x_positions, x
    lda #$00
    sta player_x_velocity, x
    ldy scratch + 4
    dey
    bne @test_wall_collision_bottom_right
    jmp @after_test_wall_collision
    @after_test_wall_collision_bottom_right:
    @test_wall_collision_top_left:
    get_collision_at_point 2, 2
    ldx scratch + 3
    and #COLLISION_LEFT
    beq @after_test_wall_collision_top_left
    lda object_x_page_subpixels, x
    and #PAGE_MASK
    sta object_x_page_subpixels, x
    lda object_x_positions, x
    sec
    sbc #3
    and #$F0
    clc
    adc #14
    sta object_x_positions, x
    lda #$00
    sta player_x_velocity, x
    ldy scratch + 4
    dey
    bne @test_wall_collision_top_left
    jmp @after_test_wall_collision
    @after_test_wall_collision_top_left:
    @test_wall_collision_bottom_left:
    get_collision_at_point 2, 12
    ldx scratch + 3
    and #COLLISION_LEFT
    beq @after_test_wall_collision_bottom_left
    lda object_x_page_subpixels, x
    and #PAGE_MASK
    sta object_x_page_subpixels, x
    lda object_x_positions, x
    sec
    sbc #3
    and #$F0
    clc
    adc #14
    sta object_x_positions, x
    lda #$00
    sta player_x_velocity, x
    ldy scratch + 4
    dey
    bne @test_wall_collision_bottom_left
    @after_test_wall_collision_bottom_left:
    @after_test_wall_collision:
    lda player_flags, x ; Check if we're on the ground
    and #PLAYER_IS_GROUNDED
    beq @not_on_ground
    lda buttons_pressed
    and #BUTTON_A
    beq @after_air_code
    lda #PLAYER_JUMP_VELOCITY
    sta player_y_velocity, x
    @not_on_ground:
    lda #ANIM_PLAYER_JUMP
    sta scratch + 2
    lda player_y_velocity, x
    cmp #128
    bcc @after_release_jump
    lda buttons_released
    and #BUTTON_A
    beq @after_release_jump
    lda #$00
    sta player_y_velocity, x
    @after_release_jump:
    @after_air_code:
    stx scratch
    jsr load_object_collision
    ldx scratch
    ldy #$0F ; Check collision
    @start_collision_check_loop:
    lda object_ids, y
    beq @end_collision_check_loop
    cmp #$01
    bne @end_collision_check_loop
    sty scratch
    jsr test_object_collision
    ldy scratch
    cmp #$00
    beq @not_colliding
    lda #$01
    sta object_current_metasprites, y
    jmp @end_collision_check_loop
    @not_colliding:
    lda #$00
    sta object_current_metasprites, y
    @end_collision_check_loop:
    dey
    bne @start_collision_check_loop
    lda scratch + 2 ; Load animation to play
    cmp object_animations_ids, x
    beq :+
    tay
    sta object_animations_ids, x
    jmp init_animation ; If it's different from our current animation, initialize it
    :
    jmp play_animation ; Otherwise continue to play current animation