#include <cstdlib>
#include <string>
#include <unistd.h>
#include <memory>

struct mystruct{
    int x;
    int y;
    char *data;
};

void leakMalloc() {
    auto k = (char *) malloc(1024);
//    k = (char *)malloc(5);
//    free(k);
//
//    k = (char *)malloc(5);
}

void leakString() {
    std::string s = "hello";
    printf("%s\n", s.c_str());
//    sleep(1);
}

void leakStruct() {
    auto s = new mystruct{};
}

void smartPointer() {
    auto s = std::make_shared<mystruct>();
    s->data = (char *) malloc(1024);
}

/**
 * export VALGRIND_LIB=/data/local/tmp/lib/valgrind
 * /data/local/tmp/bin/valgrind --tool=memcheck --leak-check=full --leak-resolution=med --track-origins=yes --vgdb=no ./sample
 *
 * @param argc
 * @param argv
 * @return
 */
int main(int argc, char **argv) {
    printf("argc: %d\n", argc);

    leakMalloc();
    leakString();
    leakStruct();
    smartPointer();

    return 0;
}