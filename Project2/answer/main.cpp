#include <iostream>
using namespace std;

int main(int argc,char ** argv)
{
	double val;
	std::cin >> val;
	if(val<0)
		std::cout << "The value is negative." << std::endl;
	else
		std::cout << "The value is not negative." << std::endl;
}