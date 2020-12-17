#include <stdio.h>
#include <stdint.h>
#include <math.h>

#define NROWS       1024

int main(int argc, char **argv) {
    FILE *rfile, *wfile;
    int i, j;
    uint32_t val;
    char tmp;
    unsigned char buffer[34];

    if (argc != 3) {
        return argc;
    }

    rfile = fopen(argv[1], "r");
    wfile = fopen(argv[2], "w");

    fprintf(wfile, "WIDTH=32;\n");
    fprintf(wfile, "DEPTH=1024;\n\n");
    fprintf(wfile, "ADDRESS_RADIX=HEX;\nDATA_RADIX=BIN;\n\n");
    fprintf(wfile, "CONTENT BEGIN\n");

    for (i = 0; i < NROWS; i++) {
        fgets(buffer, 0x22, rfile);
        buffer[32] = ';';
        fprintf(wfile, "\t%03x:\t%s\n", i, buffer);
    }

    fprintf(wfile, "END;");

    fclose(rfile);
    fclose(wfile);

    return 0;    
}