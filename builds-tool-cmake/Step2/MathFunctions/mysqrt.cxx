
#include <iostream>
#include <cstdio>
#include <cmath>
#include "MathFunction.h"

namespace MF
{

    double mysqrt(double v)
    {
        // #if defined(HAVE_LOG) && defined(HAVE_EXP)
        //     double result = exp(log(x) * 0.5);
        //     std::cout << "Computing sqrt of " << x << " to be " << result
        //           << " using log and exp" << std::endl;
        // #else
        //     double result = x;

        std::cout << "MatchFunction running ...";
        return 1.01;
    }

    // void swap(int &a, int &b) {
    //     int temp = a;
    //     a = b;
    //     b = temp;
    // }

    template <class T>
    T my_swap(T &t1, T &t2)
    {
        T tmpT;
        tmpT = t1;
        t1 = t2;
        t2 = tmpT;
    }
}
