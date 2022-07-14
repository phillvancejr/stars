import minifb,
       minifb_enums,
       std/[algorithm, # fill
            random,
            options ]

const
    title = "Star Field Nim"
    width = 800
    height = 600
    white = (255 shl 16) or (255 shl 8) or 255

    num_stars = 1000
    spread = 20
    speed = 0.1

type
    Stars = array[ num_stars, float ]
    # world space
    WS = tuple[ x: float, y: float, index: int ]
    # screen space
    Bounds_X = range[ 0 .. width  - 1 ] 
    Bounds_Y = range[ 0 .. height - 1 ]
    SS = tuple[ x: Bounds_X, y: Bounds_Y ]

var
    pixels : array[ width * height, uint32 ]
    field : tuple[ x: Stars, y: Stars, z: Stars ]

proc init_star(i: int) =
    field.x[i] = 2 * (rand(1.0) - 0.5) * spread
    field.y[i] = 2 * (rand(1.0) - 0.5) * spread
    field.z[i] = (rand(1.0) + 0.00001) * spread

proc star_at(i: int): WS = ( field.x[i], field.y[i], i )

proc zoom(star: WS): WS =
    let z = field.z[star.index].addr
    z[] -= speed
    if z[] <= 0: init_star(star.index)
    star

proc to_screen_space(star: WS): Option[SS] = 
    let
        half_width = width / 2
        half_height = height / 2
        z = field.z[star.index]
        x = int((star.x / z) * half_width + half_width)
        y = int((star.y / z) * half_height + half_height)
    if x < Bounds_X.low  or x > Bounds_X.high or y < Bounds_Y.low  or y > Bounds_Y.high:
        init_star(star.index)
        none(SS)
    else:
        some((Bounds_X(x), Bounds_Y(y)))

proc draw(star: Option[SS]) =
    if is_some(star):
        let pos = star.get()
        pixels[ pos.y * width + pos.x ] = white

# clear screen helper
proc clear = fill(pixels,0)

let window = mfb_open(title.cstring, width.cuint, height.cuint)

while mfb_wait_sync(window):
    if mfb_update_ex(window, pixels.addr, width.cuint, height.cuint) != STATE_OK: break

    clear()

    for i in Stars.low .. Stars.high:
        star_at(i)
        .zoom()
        .to_screen_space()
        .draw()
