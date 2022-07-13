pragma ada_2020;

with minifb; use minifb;
with minifb_enums; use minifb_enums;
with interfaces; use interfaces;
with interfaces.c; use interfaces.c;
with interfaces.c.strings;  
with ada.numerics.float_random; 
with ada.text_io;
with ada.float_text_io;
procedure stars is
    package io renames ada.text_io;
    package fio renames ada.float_text_io;
    package cstr renames interfaces.c.strings;
    package rand renames ada.numerics.float_random;

    gen    : rand.generator;    
 
    title  : cstr.chars_ptr := cstr.new_string("Software Rendering Ada");
    width  : constant := 800;
    height : constant := 600;

    half_width  : constant float := float(width) / 2.0;
    half_height : constant float := float(height) / 2.0;
    subtype Bounds_X is integer range 0 .. width  -1;
    subtype Bounds_Y is integer range 0 .. height -1;
    pixels : array(Bounds_y, Bounds_x) of natural := (others=>(others=>0)); 
    white  : constant interfaces.unsigned_32 := (interfaces.shift_left(255,16) or interfaces.shift_left(255,8) or 255);

    num_stars : constant := 1000;
    spread    : float    := 20.0; 
    speed     : float    := 0.1;
    

    type Star_Range is array(0 .. num_stars-1) of float;
    star_x : Star_Range;
    star_y : Star_Range;
    star_z : Star_Range;
        
    function rand_float return float is (rand.random(gen) * 0.99);

    procedure init_star(i: integer) is
    begin
        -- 0.0 to 1.0 -> -0.5 to 0.5 -> -1 to 1 -> -spread to spread
        star_x(i) := 2.0 * (rand_float - 0.5) * spread;
        star_y(i) := 2.0 * (rand_float - 0.5) * spread;
        -- add a bit to z so it is not at pos 0 which would be in same place as camera and not visible 
        star_z(i) := (rand.random(gen) + 0.00001) * spread;
    end;

    window : access mfb_window := mfb_open_ex(title, width, height, WF_RESIZABLE);
    
    procedure clear is begin pixels := (others=>(others=>0)); end;
begin
    -- seed random
    rand.reset(gen);
    -- initialize stars
    for i in Star_Range'range loop
        init_star(i);
    end loop;


    while mfb_wait_sync(window) loop
        exit when mfb_update_ex(window, pixels'address, width, height) < 0;
        -- clear to black
        clear;
        -- draw stars
        for i in Star_Range'range loop
            declare
                z renames star_z(i);
                x : integer;
                y : integer;

            begin
                -- move on z
                z := @ - speed;

                if z <= 0.0 then 
                    init_star(i); 
                end if;
            
                -- convert to screen space
                x := integer((star_x(i)/z) * half_width + half_width);
                y := integer((star_y(i)/z) * half_height + half_height);

                if x not in Bounds_X or y not in Bounds_Y then
                    init_star(i);
                else
                    pixels(y, x) := natural(white);
                end if;
            end;
        end loop;

    end loop;
end;
