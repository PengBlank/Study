//
//  HYDeleteResultShowView.m
//  Teshehui
//
//  Created by HYZB on 15/11/28.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYDeleteResultShowView.h"

@implementation HYDeleteResultShowView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel *descLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TFScalePoint(120), 40)];
        descLab.textAlignment = NSTextAlignmentCenter;
        descLab.textColor = [UIColor whiteColor];
        descLab.tag = 100;
        [self addSubview:descLab];
        self.backgroundColor = [UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1.0];
        self.frame = CGRectMake(TFScalePoint(100), 200, TFScalePoint(120), 50);
        self.layer.cornerRadius = 10;
    }
    return self;
}

- (void)setDescLabInfo:(NSString *)info
{
    UILabel *descLab = (UILabel *)[self viewWithTag:100];
    descLab.text = info;
}

@end
