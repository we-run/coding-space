#include <algorithm>
#include <atomic>
#include <cinttypes>
#include <cstdio>
#include <iostream>
#include <limits>
#include <memory>
#include <cstdlib>
#include <math.h>
#include "Hello.h"

#ifdef USE_MYMATH
#include <MathFunction.h>
#endif

namespace MF
{
    template <typename T>
    T minimum(const T &lhs, const T &rhs)
    {
        return lhs < rhs ? lhs : rhs;
    }
}

int main(int argc, char *argv[])
{
    int a;
    float b[5];
    std::cout << "Hello World!>1223> \n";
    // const double inputValue = std::stod(argv[1]);
    const double inputValue = 0.1;
    int n1 = 1, n2 = 2;

#ifdef USE_MYMATH
    const double outputValue = MF::mysqrt(inputValue);
    // MF::my_swap<int>(n1, n2);
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

    std::cout
        << n1 << " vs_before" << n2;
    std::cout << MF::minimum<int>(n1, n2);
    std::cout
        << n1 << " vs_after " << n2;
    return 1;
}
