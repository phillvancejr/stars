#include <stdio.h>
#include <minifb/MiniFB.h>
#include <array>
#include <algorithm>
#include <stdlib.h>
#include <time.h>
#include <limits>

auto title = "Star Field CC";
constexpr auto width = 800;
constexpr auto height = 600;
constexpr auto half_width = width / 2;
constexpr auto half_height = height / 2;
auto pixels = std::array<unsigned int, width * height>{0};
constexpr auto white = (255 << 16) | (255 << 8) | 255;
auto clear = []{ std::fill(pixels.begin(), pixels.end(), 0); };

constexpr auto num_stars = 1000;
auto spread = 20;
auto speed  = 0.1;

float star_x[num_stars]{0};
float star_y[num_stars]{0};
float star_z[num_stars]{0};

auto random_float = []{ return (double)rand() / (double)RAND_MAX; };

void init_star(int i) {
    star_x[i] = 2 * (random_float() - .5) * spread; 
    star_y[i] = 2 * (random_float() - .5) * spread; 
    star_z[i] = (random_float() + .00001) * spread;
}

int main() {
    srand(time(0));

    for (auto i = 0; i < num_stars; i++) init_star(i);

    auto window = mfb_open(title, width, height);

    while (mfb_wait_sync(window)) {
        if (mfb_update_ex(window, pixels.data(), width, height) < 0 ) break;
        // clear background
        clear(); 
        // draw stars
        for (auto i = 0; i < num_stars; i++) {
            auto& z = star_z[i];
            z -= speed;
             
            if ( z <= 0 ) init_star(i);

            // convert to screen space
            int x = (star_x[i] / z) * half_width + half_width;
            int y = (star_y[i] / z) * half_height + half_height;
            
            if ( x < 0 or x >= width or y < 0 or y >= height )
                init_star(i);
            else
                pixels[ y * width + x ] = white;
        } 
    }
}
