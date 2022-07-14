import minifb,
       minifb_enums,
       std/algorithm, # fill
       std/random

const
    title = "Star Field Nim"
    width = 800
    height = 600
    half_width = width / 2
    half_height = height / 2
    white = (255 shl 16) or (255 shl 8) or 255

    num_stars = 1000
    spread = 20
    speed = 0.1

type
    Star_Range = array[ num_stars, float ]
var
    pixels : array[ width * height, uint32 ]
    star_x : Star_Range
    star_y : Star_Range
    star_z : Star_Range

proc clear() = fill(pixels, 0)

proc init_star(i: int) =
    star_x[i] = 2 * (rand(1.0) - 0.5) * spread
    star_y[i] = 2 * (rand(1.0) - 0.5) * spread
    star_z[i] = (rand(1.0) + 0.00001) * spread

randomize()

for i in 0 .. num_stars - 1: init_star(i)

let window = mfb_open(title.cstring, width.cuint, height.cuint)

while mfb_wait_sync(window):
    if mfb_update_ex(window, pixels.addr, width.cuint, height.cuint) != STATE_OK: break

    clear()

    for i in 0 .. num_stars - 1:
        let z = star_z[i].addr
        z[] -= speed

        if z[] <= 0: init_star(i)

        let x = int((star_x[i] / z[]) * half_width + half_width)
        let y = int((star_y[i] / z[]) * half_height + half_height)

        if x < 0 or x >= width or y < 0 or y >= height:
            init_star(i)
        else:
            pixels[ y * width + x ] = white
        
