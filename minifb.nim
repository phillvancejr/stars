
{.passL: "-L/usr/local/lib -lminifb -framework Cocoa -framework IOKit -framework Metal -framework MetalKit" .}
{.passC: "-I/usr/local/include" .}
{.push cdecl, header: "<minifb/Minifb.h>" .}

import
  MiniFB_enums

type
    uint32_t = uint32
    uint8_t = uint8
## /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

template MFB_RGB*(r, g, b: untyped): untyped =
  ((cast[uint32_t](r)) shl 16) or ((cast[uint32_t](g)) shl 8) or (cast[uint32_t](b))

## /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
##  Create a window that is used to display the buffer sent into the mfb_update function, returns 0 if fails

proc mfb_open*(title: cstring; width: cuint; height: cuint): ptr mfb_window {.
    importc: "mfb_open", header: "minifb.h".}
proc mfb_open_ex*(title: cstring; width: cuint; height: cuint; flags: cuint): ptr mfb_window {.
    importc: "mfb_open_ex", header: "minifb.h".}
##  Update the display
##  Input buffer is assumed to be a 32-bit buffer of the size given in the open call
##  Will return a negative status if something went wrong or the user want to exit
##  Also updates the window events

proc mfb_update*(window: ptr mfb_window; buffer: pointer): mfb_update_state {.
    importc: "mfb_update", header: "minifb.h".}
proc mfb_update_ex*(window: ptr mfb_window; buffer: pointer; width: cuint; height: cuint): mfb_update_state {.
    importc: "mfb_update_ex", header: "minifb.h".}
##  Only updates the window events

proc mfb_update_events*(window: ptr mfb_window): mfb_update_state {.
    importc: "mfb_update_events", header: "minifb.h".}
##  Close the window

proc mfb_close*(window: ptr mfb_window) {.importc: "mfb_close", header: "minifb.h".}
##  Set user data

proc mfb_set_user_data*(window: ptr mfb_window; user_data: pointer) {.
    importc: "mfb_set_user_data", header: "minifb.h".}
proc mfb_get_user_data*(window: ptr mfb_window): pointer {.
    importc: "mfb_get_user_data", header: "minifb.h".}
##  Set viewport (useful when resize)

proc mfb_set_viewport*(window: ptr mfb_window; offset_x: cuint; offset_y: cuint;
                      width: cuint; height: cuint): bool {.
    importc: "mfb_set_viewport", header: "minifb.h".}
##  DPI
##  [Deprecated]: Probably a better name will be mfb_get_monitor_scale

proc mfb_get_monitor_dpi*(window: ptr mfb_window; dpi_x: ptr cfloat; dpi_y: ptr cfloat) {.
    importc: "mfb_get_monitor_dpi", header: "minifb.h".}
##  Use this instead

proc mfb_get_monitor_scale*(window: ptr mfb_window; scale_x: ptr cfloat;
                           scale_y: ptr cfloat) {.importc: "mfb_get_monitor_scale",
    header: "minifb.h".}
##  Callbacks

proc mfb_set_active_callback*(window: ptr mfb_window; callback: mfb_active_func) {.
    importc: "mfb_set_active_callback", header: "minifb.h".}
proc mfb_set_resize_callback*(window: ptr mfb_window; callback: mfb_resize_func) {.
    importc: "mfb_set_resize_callback", header: "minifb.h".}
proc mfb_set_keyboard_callback*(window: ptr mfb_window; callback: mfb_keyboard_func) {.
    importc: "mfb_set_keyboard_callback", header: "minifb.h".}
proc mfb_set_char_input_callback*(window: ptr mfb_window;
                                 callback: mfb_char_input_func) {.
    importc: "mfb_set_char_input_callback", header: "minifb.h".}
proc mfb_set_mouse_button_callback*(window: ptr mfb_window;
                                   callback: mfb_mouse_button_func) {.
    importc: "mfb_set_mouse_button_callback", header: "minifb.h".}
proc mfb_set_mouse_move_callback*(window: ptr mfb_window;
                                 callback: mfb_mouse_move_func) {.
    importc: "mfb_set_mouse_move_callback", header: "minifb.h".}
proc mfb_set_mouse_scroll_callback*(window: ptr mfb_window;
                                   callback: mfb_mouse_scroll_func) {.
    importc: "mfb_set_mouse_scroll_callback", header: "minifb.h".}
##  Getters

proc mfb_get_key_name*(key: mfb_key): cstring {.importc: "mfb_get_key_name",
    header: "minifb.h".}
proc mfb_is_window_active*(window: ptr mfb_window): bool {.
    importc: "mfb_is_window_active", header: "minifb.h".}
proc mfb_get_window_width*(window: ptr mfb_window): cuint {.
    importc: "mfb_get_window_width", header: "minifb.h".}
proc mfb_get_window_height*(window: ptr mfb_window): cuint {.
    importc: "mfb_get_window_height", header: "minifb.h".}
proc mfb_get_mouse_x*(window: ptr mfb_window): cint {.importc: "mfb_get_mouse_x",
    header: "minifb.h".}
##  Last mouse pos X

proc mfb_get_mouse_y*(window: ptr mfb_window): cint {.importc: "mfb_get_mouse_y",
    header: "minifb.h".}
##  Last mouse pos Y

proc mfb_get_mouse_scroll_x*(window: ptr mfb_window): cfloat {.
    importc: "mfb_get_mouse_scroll_x", header: "minifb.h".}
##  Mouse wheel X as a sum. When you call this function it resets.

proc mfb_get_mouse_scroll_y*(window: ptr mfb_window): cfloat {.
    importc: "mfb_get_mouse_scroll_y", header: "minifb.h".}
##  Mouse wheel Y as a sum. When you call this function it resets.

proc mfb_get_mouse_button_buffer*(window: ptr mfb_window): ptr uint8_t {.
    importc: "mfb_get_mouse_button_buffer", header: "minifb.h".}
##  One byte for every button. Press (1), Release 0. (up to 8 buttons)

proc mfb_get_key_buffer*(window: ptr mfb_window): ptr uint8_t {.
    importc: "mfb_get_key_buffer", header: "minifb.h".}
##  One byte for every key. Press (1), Release 0.
##  FPS

proc mfb_set_target_fps*(fps: uint32_t) {.importc: "mfb_set_target_fps",
                                       header: "minifb.h".}
proc mfb_get_target_fps*(): cuint {.importc: "mfb_get_target_fps", header: "minifb.h".}
proc mfb_wait_sync*(window: ptr mfb_window): bool {.importc: "mfb_wait_sync",
    header: "minifb.h".}
##  Timer

proc mfb_timer_create*(): ptr mfb_timer {.importc: "mfb_timer_create",
                                      header: "minifb.h".}
proc mfb_timer_destroy*(tmr: ptr mfb_timer) {.importc: "mfb_timer_destroy",
    header: "minifb.h".}
proc mfb_timer_reset*(tmr: ptr mfb_timer) {.importc: "mfb_timer_reset",
                                        header: "minifb.h".}
proc mfb_timer_now*(tmr: ptr mfb_timer): cdouble {.importc: "mfb_timer_now",
    header: "minifb.h".}
proc mfb_timer_delta*(tmr: ptr mfb_timer): cdouble {.importc: "mfb_timer_delta",
    header: "minifb.h".}
proc mfb_timer_get_frequency*(): cdouble {.importc: "mfb_timer_get_frequency",
                                        header: "minifb.h".}
proc mfb_timer_get_resolution*(): cdouble {.importc: "mfb_timer_get_resolution",
    header: "minifb.h".}
## /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
