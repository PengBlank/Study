//
//  HYBaseLineCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@interface HYBaseLineCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation HYBaseLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _separatorLeftInset = 16.0f;
        _hiddenLine = NO;
//        _doubleLine = NO;
//        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGFloat lineWidth = 0.25f;
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    
    if (_doubleLine)
    {
        CGContextMoveToPoint(context, 0, lineWidth * 0.5f);
        CGContextAddLineToPoint(context, 320.0f, lineWidth * 0.5f);
    }
    CGContextMoveToPoint(context, _separatorLeftInset, rect.size.height-lineWidth * 0.5f);
    CGContextAddLineToPoint(context, 320.0f, rect.size.height-lineWidth * 0.5f);
    CGContextStrokePath(context);
}
*/
- (UIView *)lineView
{
    if (!_lineView)
    {
//        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(_separatorLeftInset, 0, 320-_separatorLeftInset, 1.0)];
//        _lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
//                                                                                        topCapHeight:0];
//        [self addSubview:_lineView];
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(_separatorLeftInset, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame)-_separatorLeftInset, .5)];
        _lineView.backgroundColor = [UIColor colorWithRed:96/255.0 green:97/255.0 blue:112/255.0 alpha:1];
        _lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_hiddenLine)
    {
        self.lineView.frame = CGRectMake(_separatorLeftInset, self.frame.size.height-1, CGRectGetWidth(self.frame)-_separatorLeftInset, 1.0);
        [self.lineView setHidden:NO];
    }
    else
    {
        [_lineView setHidden:YES];
    }
}

@end
