
-- Compile it --
To compile it, simply use any C compiler you have like gcc
ex. gcc main.c -o gen
    chmod +x gen

-- Use it --
To use it after you compiled it, take note of the path where your vivado simulation sources are, like (bash example)

simdir=/home/super/Vivado/Assignment/matrix_dot_product/matrix_dot_product.srcs/sim_2/new/
./gen $simdir

Snside your $simdir, you'll find mat0.mem, mat1.mem and mat2.mem randomly generated. Those file will be used by the test bench of the device.