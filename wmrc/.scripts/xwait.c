#include <unistd.h>

#define SLEEP_INTERVAL 1000000

int main() {
    while (1) {
        usleep(SLEEP_INTERVAL);
    }
    return 0;
}
