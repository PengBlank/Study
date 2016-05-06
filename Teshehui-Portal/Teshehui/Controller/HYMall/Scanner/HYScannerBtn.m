//
//  HYScannerBtn.m
//  Teshehui
//
//  Created by HYZB on 16/4/7.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYScannerBtn.h"


@interface HYScannerBtn ()



@end

@implementation HYScannerBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *iconImgV = [[UIImageView alloc] init];
        [self addSubview:iconImgV];
        _iconImgV = iconImgV;
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:20];
        [self addSubview:titleLab];
        _titleLab = titleLab;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = 90;
    CGFloat height = 90;
    CGFloat x = self.frame.size.width/2-width/2;
    CGFloat y = (self.frame.size.height-height-40)/2;
    _iconImgV.frame = CGRectMake(x, y, width, height);
    
    _titleLab.frame = CGRectMake(CGRectGetMinX(_iconImgV.frame), CGRectGetMaxY(_iconImgV.frame)+20, width, 20);
}

+ (instancetype)buttonWithImage:(NSString *)image title:(NSString *)title
{
    HYScannerBtn *btn = [[HYScannerBtn alloc] init];
    btn.iconImgV.image = [UIImage imageNamed:image];
    btn.titleLab.text = title;
    return btn;
}

@end
