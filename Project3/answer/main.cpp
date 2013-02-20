#include <iostream>
using namespace std;

int main(int argc,char ** argv)
{
	int myArray[10];
    int newArray[10];
    cout << "please enter your number: ";

    cin >> myArray[0];
    for (int i = 1; i < 10; i++){

        myArray[i] = myArray[i - 1] * 2;

    }

    for (int i = 9; i >=0; i--) {

        newArray[i] = myArray[9-i];

    }

    for (int i = 0; i < 10; i++){

        cout << endl << myArray[i];

    }

	for (int i = 0; i < 10; i++){

        cout << endl << newArray[i];

    }
}