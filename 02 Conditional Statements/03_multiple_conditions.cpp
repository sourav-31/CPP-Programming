#include <iostream>
using namespace std;

int main() {
    int marks;
    cout << "Enter marks: ";
    cin >> marks;
    if (marks>100)
    {
        cout << "Enter marks out of 100\n";
    }
    else if (marks >= 91)
    {
        cout<< "Grade = A\n";
    }
    else if(marks >= 81)
    {
        cout << "Grade = B\n";
    }
    else if(marks >= 71)
    {
        cout << "Grade = C\n";
    }
    else if(marks >= 61)
    {
        cout << "Grade = D\n";
    }
    else if(marks >= 51)
    {
        cout << "Grade = E\n";
    }
    else if(marks >= 35)
    {
        cout << "Grade = F\n";
    }
    else
    {
        cout << "You are Fail\n";
    }
    return 0;
}