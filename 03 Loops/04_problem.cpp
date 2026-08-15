// Check whether a number is prime or not
#include <iostream>
using namespace std;

int main()
{
    int n;
    bool isPrime = true;
    cout << "Enter a number: " << endl;
    cin >> n;
    for (int i=2; i <= n - 1; i++)
    {
        if (n % i == 0)
        {
            // non prime
            isPrime = false;
            break;
        }
    }

    if (isPrime == true)
    {
        cout << "Given number is prime" << endl;
    }
    else
    {
        cout << "Given number is composite" << endl;
    }

    return 0;
}