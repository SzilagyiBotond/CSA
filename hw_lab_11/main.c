#include <stdio.h>
int biggest(int n,int string[100]);
int main(){
int n;
printf("How many numbers: ");
scanf("%d",&n);
int string[100];
for(int i=0;i<n;i++)
    scanf("%d",&string[i]);
for(int i=0;i<n;i++)
    printf("%d ",string[i]);
printf("\n");
int b=biggest(n,string);
FILE *fp=fopen("max.txt","w");
fprintf(fp,"%x",b);



return 0;
}
