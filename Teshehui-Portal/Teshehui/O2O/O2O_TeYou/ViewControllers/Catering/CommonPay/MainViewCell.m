//
//  MainViewCell.m
//  Orange
//
//  Created by wujianming on 15/11/23.
//  Copyright © 2015年 teshehui. All rights reserved.
//

#define kTextborderW 0.5
#define kTextborderColor [UIColor grayColor].CGColor

#import "MainViewCell.h"
#import "UIColor+expanded.h"
@implementation MainViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 3.0;
        self.clipsToBounds = YES;
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom]; // 折扣
        _btn.frame = self.bounds;
        _btn.backgroundColor = [UIColor whiteColor];
        _btn.layer.cornerRadius = 3.0;
        _btn.clipsToBounds = YES;
        _btn.layer.borderWidth = kTextborderW;
        _btn.layer.borderColor = kTextborderColor;
        _btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btn setBackgroundImage:[self getImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_btn setBackgroundImage:[self getImageWithColor:[UIColor colorWithHexString:@"0xb80000"]] forState:UIControlStateSelected];
        [self addSubview:_btn];

        [_btn addTarget:self action:@selector(cellItemDidClick:) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)cellItemDidClick:(UIButton *)btn
{
    if (self.discountCallBack) { // 选中按钮传出
        _discountCallBack(btn);
    }
}

- (UIImage *)getImageWithColor:(UIColor *)color
{
    CGRect aFrame = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
