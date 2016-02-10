#include <iostream>
#include <stdio.h>
#include <conio.h>
using namespace std;


void swap(int *m, int *n) {//定义swap函数，参数为int型指针m和n
	int tem;
	tem = *m;
	*m = *n;
	*n = tem;
}

int main() {//主函数返回值类型为整形
	int x = 1, y = 2;
	cout << "Before swap" <<endl<< "x=" << x << ",y=" << y << endl;//输出x与y的值
	swap(&x, &y);//调用swap函数
	cout << "After swap" << endl << "x=" << x << ",y=" << y << endl;
	if (x > y)
		cout << 'x';
	else
		cout << 'y';
	getchar();
	return 0;
}