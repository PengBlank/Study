//
//  HYHotelFillOrderFooterView.m
//  Teshehui
//
//  Created by HYZB on 15/1/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYHotelFillOrderFooterView.h"

@implementation HYHotelFillOrderFooterView

@synthesize descLab = _descLab;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor =  [UIColor whiteColor];
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.masksToBounds = YES;
        
        _descLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLab.lineBreakMode = NSLineBreakByCharWrapping;
        _descLab.numberOfLines = 10;
        _descLab.backgroundColor = [UIColor clearColor];
        _descLab.font = [UIFont systemFontOfSize:12];
        _descLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_bgView addSubview:_descLab];
        
        [self addSubview:_bgView];
    }
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [_descLab.text sizeWithFont:_descLab.font
                            constrainedToSize:CGSizeMake(ScreenRect.size.width-30, 120)];
    _descLab.frame = CGRectMake(5, 5, size.width, size.height);
    _bgView.frame = CGRectMake(10, 10, ScreenRect.size.width-20, size.height+10);
}
@end
