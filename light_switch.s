ANIM_LIGHT_SWITCH_DOWN_FRAME_0 = $06

; Object index in X
light_switch_init:
    lda #$00
    sta object_flags, x
    sta light_switch_state, x
    .if ANIM_LIGHT_SWITCH_DOWN_FRAME_0 <> 0
    lda #ANIM_LIGHT_SWITCH_DOWN_FRAME_0
    .endif
    sta object_current_metasprites, x
    rts

light_switch_state = object_variables_0
LIGHT_SWITCH_UP = 1
LIGHT_SWITCH_LOWERING = 2
LIGHT_SWITCH_DOWN = 3
LIGHT_SWITCH_RISING = 4

.define LightSwitchJumpTable \
    light_switch_up_down_step - 1, \
    light_switch_lowering_step - 1, \
    light_switch_up_down_step - 1, \
    light_switch_rising_step - 1

LightSwitchJumpTableLow:
    .lobytes LightSwitchJumpTable

LightSwitchJumpTableHigh:
    .hibytes LightSwitchJumpTable

; Object index in X
light_switch_step:
    ldy light_switch_state, x
    lda LightSwitchJumpTableHigh, y
    pha
    lda LightSwitchJumpTableLow, y
    pha
    rts

light_switch_up_down_step:
    rts

light_switch_lowering_step:
    jmp play_animation

light_switch_rising_step:
    jmp play_animation