#include <iostream>
using namespace std;

int main()
{
    int a = 10;
    int b = a++;                 // kaam ; update
    cout << "a = " << a << endl; // 11
    cout << "b = " << b << endl; // 10
    int c = 20;
    int d = ++c;                 // update ; kaam
    cout << "d = " << d << endl; // 21
    cout << "c = " << c << endl; // 21
    return 0;
}