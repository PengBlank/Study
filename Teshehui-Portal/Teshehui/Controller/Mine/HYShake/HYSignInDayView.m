//
//  HYSignInDayView.m
//  Teshehui
//
//  Created by HYZB on 16/3/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYSignInDayView.h"

#define kLineViewMargin 40
#define kLineSpace 50

@implementation HYSignInDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        for (NSInteger i = 10; i < 15; i++)
        {
            UIView *lineView = [[UIView alloc] init];
            lineView.tag = i;
            lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
            [self addSubview:lineView];
        }
        
        NSInteger i = 100;
        for (NSInteger row = 0; row < 5; row++)
        {
            for (NSInteger col = 0; col < 7; col++)
            {
                UIImageView *dayIconImgV = [[UIImageView alloc] init];
                dayIconImgV.tag = i;
                [self addSubview:dayIconImgV];
                if ((row == 1 && col == 2) || (row == 2 && col == 5))
                {
                    dayIconImgV.image = [UIImage imageNamed:@"icon_signin_gift_gray"];
                }
                else if (row == 4 && col == 1)
                {
                    // 第30天
                    dayIconImgV.image = [UIImage imageNamed:@"icon_signin_finallygift_gray"];
                    return self;
                }
                else
                {
                    dayIconImgV.image = [UIImage imageNamed:@"icon_signin_sign_gray"];
                }
                
                i++;
            }
         }
    }
    return self;
}

- (void)layoutSubviews
{

    for (NSInteger i = 10; i < 15; i++)
    {
        UIView *lineView = [self viewWithTag:i];
        
        CGFloat x = TFScalePoint(20);
        /*
         0  kLineViewMargin
         1  kLineViewMargin+2+kLineSpace                kLineViewMargin+1*(2+kLineSpace)
         2  kLineViewMargin+2+kLineSpace+2+kLineSpace   kLineViewMargin+2*(2+kLineSpace)
         */
        CGFloat y = kLineViewMargin+(i-10)*(1+kLineSpace);
        if (i == 14)
        {
            lineView.frame = CGRectMake(x, y, TFScalePoint(55), 1);
        }
        else
        {
            lineView.frame = CGRectMake(x, y, TFScalePoint(280), 1);
        }
    }
    
    NSInteger i = 100;
    for (NSInteger row = 0; row < 5; row++)
    {
        for (NSInteger col = 0; col < 7; col++)
        {
            UIImageView *dayIconImgV = [self viewWithTag:i];
            /*
            0  10                      10+23*0
            1  10+23+23                10+23*2
            2  10+23+23+23+23          10+23*4
            3  10+23+23+23+23+23+23    10+23*6
             */
            CGFloat x = TFScalePoint(10) + TFScalePoint(23)*(col*2);
            
            CGFloat dayIconMarginY = kLineViewMargin-TFScalePoint(11);
            CGFloat dayIconSpace = kLineSpace-TFScalePoint(22);
            /*
             0  dayIconMarginY
             1  dayIconMarginY+23+dayIconSpace
             2  dayIconMarginY+23+dayIconSpace+23+dayIconSpace              
                dayIconMarginY+(23+dayIconSpace)*2
             3  dayIconMarginY+23+dayIconSpace+23+dayIconSpace+23+dayIconSpace        
                dayIconMarginY+(23+dayIconSpace)*3
             4  dayIconMarginY+23+dayIconSpace+23+dayIconSpace+23+dayIconSpace+23+18  
                dayIconMarginY+(23+dayIconSpace)*4
             */
            CGFloat y = dayIconMarginY + row*(TFScalePoint(23)+dayIconSpace);
            CGFloat width = TFScalePoint(23);
            CGFloat height = TFScalePoint(23);
            dayIconImgV.frame = CGRectMake(x, y, width, height);
            
            i++;
        }
    }
}

- (void)setCurrentSignNum:(NSString *)currentSignNum
{
    _currentSignNum = currentSignNum;
    
    if (_currentSignNum.integerValue > 0)
    {
        for (NSInteger n = 100; n < _currentSignNum.integerValue + 100; n++)
        {
            UIImageView *dayIconImgV = [self viewWithTag:n];
            if (n == 109 || n == 119)
            {
                dayIconImgV.image = [UIImage imageNamed:@"icon_signin_gift_red"];
            }
            else if (n == 129)
            {
                // 第30天
                dayIconImgV.image = [UIImage imageNamed:@"icon_signin_finallygift_red"];
            }
            else
            {
                dayIconImgV.image = [UIImage imageNamed:@"icon_signin_sign_red"];
            }
        }
    }
}


@end
