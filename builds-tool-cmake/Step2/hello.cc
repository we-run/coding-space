#include <algorithm>
#include <atomic>
#include <cinttypes>
#include <cstdio>
#include <iostream>
#include <limits>
#include <memory>
#include <cstdlib>
#include <math.h>

#ifdef USE_MYMATH
#include "MathFunction.h"
#endif

int main(int argc, char *argv[])
{
    int a;
    float b[5];
    std::cout << "Hello World!>1223> \n";
    // const double inputValue = std::stod(argv[1]);
    const double inputValue = 0.1;
#ifdef USE_MYMATH
    const double outputValue = mysqrt(inputValue);
#else
    std::cout << "IN";
    const double outputValue = sqrt(inputValue);
#endif
    // std::cout << inputValue;

    // if (argc < 2)
    // {
    //     // report version
    //     std::cout << argv[0] << " Version " << Hello_VERSION_MAJOR << "."
    //               << Hello_VERSION_MINOR << std::endl;
    //     std::cout << "Usage: " << argv[0] << " number" << std::endl;
    //     return 1;
    // }
    return 1;
}
