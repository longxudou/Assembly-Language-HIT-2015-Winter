#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

typedef char BYTE;

extern "C" int  iq(char* buf, int* ip, BYTE chr);
extern "C" int  oq(char* buf, int* op, char* chr);
extern "C" int  pq(char* buf, int ip, int op);

extern "C" char buf[16];
extern "C" int ip;
extern "C" int op;
extern "C" int n;

extern "C" { 
	void incp(int *p)
		{
			*p = (*p + 1) % 16;
		}
}
int main()
{
	ip = 0;
	op = 0;
	n = 0;
	int ret;
	char chr;
	char c;
	printf("功能选择：ESC 退出：- 输出一个字符；+ 打印当前队列；0-9、A-Z进入队列，其他抛弃。\n");
	while (1)
	{
		c = _getche();
		if (c == 0x1B)
		{
			break;
		}
		if (c == '-')
		{
			ret = oq(buf, &op, &chr);
			if (ret == 0)
			{
				printf("\nEMPTY!\n");
			}
			else
			{
				printf("输出元素为：%c\n", chr);
			}
			continue;
		}
		if (c == '+')
		{
			printf("\n当前队列内容：");
			pq(buf, ip, op);
			printf("队首下标：%d 队尾下标：%d\n", op, ip);
			continue;
		}

		if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z'))
		{
			ret = iq(buf, &ip, c);
			if (ret == 0)
			{
				printf("\nFULL!\n");
			}
			continue;
		}
	}
	return 0;
}
