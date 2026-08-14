#include <iostream>
using namespace std;

int main() {
    int a = 10;
    int b = a++; // kaam(assign) ; update (+1)
    cout << "b = " << b << endl; //10
    cout << "a = " << a << endl; //11

    int c = 20;
    int d = ++c; // update(+1) ; kaam(assign) 
    cout << "c = " << c << endl; //21
    cout << "d = " << d << endl; //21
    return 0;
}