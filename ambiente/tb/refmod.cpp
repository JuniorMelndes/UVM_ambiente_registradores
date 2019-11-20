#include <stdio.h>
#include <math.h>

extern "C" int soma(int x, int y){
  return x + y;
}
extern "C" int dif(int x, int y){
  return x - y;
}
extern "C" int incre(int x){
  return ++x;
}
