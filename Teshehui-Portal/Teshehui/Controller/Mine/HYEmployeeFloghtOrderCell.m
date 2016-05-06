//
//  HYEmployeeFloghtOrderCell.m
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYEmployeeFloghtOrderCell.h"

@implementation HYEmployeeFloghtOrderCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat x = 20;
        CGFloat y = 12;
        CGFloat h = 15;
        CGFloat w = CGRectGetWidth(frame) - 2 * x;
        CGRect rect = CGRectMake(x, y, w, h);
        
        self.flightNameLabel = [[UILabel alloc] initWithFrame:rect];
        [self configureLabel:_flightNameLabel];
        [self.contentView addSubview:_flightNameLabel];
        
        rect.origin.y = CGRectGetMaxY(rect) + 12;
        self.regionTimeLabel = [[UILabel alloc] initWithFrame:rect];
        [self configureLabel:_regionTimeLabel];
        [self.contentView addSubview:_regionTimeLabel];
        
        rect.origin.y = CGRectGetMaxY(rect) + 12;
        self.passengerLabel = [[UILabel alloc] initWithFrame:rect];
        [self configureLabel:_passengerLabel];
        [self.contentView addSubview:_passengerLabel];
        
        rect.origin.y = CGRectGetMaxY(rect) + 8;
        rect.size.width = 200;
        self.priceLabel = [[UILabel alloc] initWithFrame:rect];
        _priceLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_priceLabel];
        
        //按钮右下角浮动
        w = 120.0;
        h = 28.0;
        x = CGRectGetWidth(frame) - 8 - w;
        y = CGRectGetHeight(frame) - 5 - h;
        rect = CGRectMake(x, y, w, h);
        self.completeBtn = [[UIButton alloc] initWithFrame:rect];
        _completeBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin \
        | UIViewAutoresizingFlexibleTopMargin;
        [_completeBtn setTitle:@"出票成功" forState:UIControlStateNormal];
        [self.contentView addSubview:_completeBtn];
    }
    return self;
}

- (void)configureLabel:(UILabel *)label
{
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
