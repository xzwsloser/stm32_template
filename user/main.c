#include "stm32f10x.h"
#include "stm32f10x_conf.h"

void delay() {
   for (volatile int i = 0 ; i < 1000000 ; i ++); 
}

int main(void) {
    // 使能 GPIOB 时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);

    // 配置 PB9 为推挽输出
    GPIO_InitTypeDef gpio;
    gpio.GPIO_Pin = GPIO_Pin_13;
    gpio.GPIO_Speed = GPIO_Speed_2MHz;
    gpio.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_Init(GPIOC, &gpio);

    // 点亮 LED（PB9 输出高电平）
    // 或者：GPIO_WriteBit(GPIOB, GPIO_Pin_9, SET);

    while (1) {
        GPIO_ResetBits(GPIOC, GPIO_Pin_13);
        delay();
        // LED始终点亮
        GPIO_SetBits(GPIOC, GPIO_Pin_13);
        delay();
    }
}