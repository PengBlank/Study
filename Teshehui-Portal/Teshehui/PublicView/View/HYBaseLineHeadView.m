//
//  HYBaseLineHeadView.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineHeadView.h"

@implementation HYBaseLineHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _hiddenLine = NO;
        [self createLine];
    }
    return self;
}

- (void)awakeFromNib
{
    _separatorLeftInset = 16.0f;
    _hiddenLine = NO;
    [self createLine];
}

- (void)createLine
{
    _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(_separatorLeftInset, 0, CGRectGetWidth(self.frame)-_separatorLeftInset, 1.0)];
    _lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
    [self addSubview:_lineView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _lineView.hidden = _hiddenLine;
    if (!_hiddenLine)
    {
        _lineView.frame = CGRectMake(_separatorLeftInset, self.frame.size.height-1, self.frame.size.width-_separatorLeftInset, 1.0);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
