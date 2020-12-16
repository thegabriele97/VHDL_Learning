#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>

#define FIXED_POINT     16
#define MUL_X           (1 << FIXED_POINT)
#define TO_FIXED(val)   ((uint32_t)((double)val * MUL_X)) 
#define MUL_FIX(a, b)   ((uint32_t)(((uint64_t)fix1 * (uint64_t)fix2) >> FIXED_POINT))
#define TO_FLOAT(val)   ((double)((double)val / MUL_X)) 

#define NROWS           0x20
#define NCOLS           0x20

void print_matrix(uint32_t mx[NROWS][NCOLS]);
void save_matrix(uint32_t mx[NROWS][NCOLS], FILE *fp);
void get_bits(char *buf, uint32_t val);

int main(int argc, char **argv) {
    uint32_t matrix0[NROWS][NCOLS], matrix1[NROWS][NCOLS], matrix2[NROWS][NCOLS];
    uint32_t tmp;
    uint64_t sum, tmp2;
    FILE *fp;
    float flt;
    char *buff;
    uint8_t r0, c0, r1, c1;
    
    srand(time(NULL));
    for (r0 = 0; r0 < NROWS; r0++) {
        for (c0 = 0; c0 < NCOLS; c0++) {
            matrix0[r0][c0] = ((uint32_t)rand()) & 0x00ffff70;
            matrix1[r0][c0] = ((uint32_t)rand()) & 0x00ffff70;
        }
    }

    buff = (char *)malloc(strlen(argv[1] + 0x9) * sizeof *buff);

    sprintf(buff, "%s%s", argv[1], "mat0.mem");
    fp = fopen(buff, "w");
    printf("Storing matrix0 in mat0.dat..\n");
    save_matrix(matrix0, fp);
    fclose(fp);

    sprintf(buff, "%s%s", argv[1], "mat1.mem");
    fp = fopen(buff, "w");
    printf("Storing matrix1 in mat1.dat..\n");
    save_matrix(matrix1, fp);
    fclose(fp);

    for (r0 = 0; r0 < NROWS; r0++) {
        for (c1 = 0; c1 < NCOLS; c1++) {
            
            r1 = 0;
            c0 = 0;
            sum = 0;
            while (r1 < 32) {
                tmp2 = (uint64_t)matrix0[r0][c0] * matrix1[r1][c1];
                printf("%u*%u=%lu", matrix0[r0][c0], matrix1[r1][c1], tmp2);
                
                tmp2 = (uint64_t)matrix0[r0][c0++] * matrix1[r1++][c1];
                sum += tmp2;
                printf(" sum = %ld\n", sum);
            }
            
            matrix2[r0][c1] = (uint32_t)(sum >> FIXED_POINT);
        }
    }

    sprintf(buff, "%s%s", argv[1], "mat2.mem");
    fp = fopen(buff, "w");
    printf("Storing matrix2 in mat2.dat..\n");
    save_matrix(matrix2, fp);
    fclose(fp);

    printf("Matrix 2:\n");
    print_matrix(matrix2);

    return 0;
}

void print_matrix(uint32_t mx[NROWS][NCOLS]) {
    uint8_t r0, c0;
    uint32_t tmp;
    
    for (r0 = 0; r0 < NROWS; r0++) {
        printf("Row #%d\n", r0);

        for (c0 = 0; c0 < NCOLS; c0++) {
            tmp = mx[r0][c0];
            //flt = TO_FLOAT(tmp);
            printf("%04x.%04x  ", tmp >> 16, tmp & 0x0000ffff);
            //printf("%04f\t", flt);
        }

        printf("\n");
    }
}

void save_matrix(uint32_t mx[NROWS][NCOLS], FILE *fp) {
    uint8_t r0, c0;
    uint32_t tmp;
    char buf[33];
    
    buf[32] = NULL;
    buf[0] = NULL;
    for (r0 = 0; r0 < NROWS; r0++) {
        for (c0 = 0; c0 < NCOLS; c0++) {
            get_bits(buf, mx[r0][c0]);
            fprintf(fp, "%s%s", buf, (*buf) ? "\n" : "");
        }
    }
}

void get_bits(char *buf, uint32_t val) {
    uint8_t i;
    char tmp;

    for (i = 0; i < 32; i++) {
        buf[31-i] = '0' + (val & 0x1);
        val >>= 1;
    }
}

/*int main() {
    float f1, f2, mul_f;
    uint32_t fix1, fix2;
    uint32_t mul_r;
    
    printf("f1: ");
    scanf("%f", &f1);

    fix1 = TO_FIXED(f1);
    printf("hex %04x.%04x\n", fix1 >> 16, fix1 & 0x0000ffff);

    printf("f2: ");
    scanf("%f", &f2);

    fix2 = TO_FIXED(f2);
    printf("hex %04x.%04x\n", fix2 >> 16, fix2 & 0x0000ffff);

    mul_r = MUL_FIX(fix1, fix2);
    printf("hex %04x.%04x\n", mul_r >> 16, mul_r & 0x0000ffff);
    
    mul_f = TO_FLOAT(mul_r);
    printf("mul: %f\n", mul_f);

    return 0;
}*/