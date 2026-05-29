/* This will force us to create a kernel entry function instead of jumping to kernel.c:0x00 */
void dummy_test_entrypoint() {
}

void main() {
    char* video_memory = (char*) 0xb8000;
    *video_memory = 'X';
//     for (int offset = 1; offset < 12; offset += 1) {
//         *(video_memory + offset) = 'X';
//     }
}