//
//  HYBaseLineCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@interface HYBaseLineCell ()

@property (nonatomic, strong) UIImageView *lineView;

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
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)awakeFromNib
{
    _separatorLeftInset = 16.0f;
    _hiddenLine = NO;
    self.contentView.backgroundColor = [UIColor whiteColor];
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
- (UIImageView *)lineView
{
    if (!_lineView)
    {
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(_separatorLeftInset, 0, CGRectGetWidth(self.frame)-_separatorLeftInset, 1.0)];
        _lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                        topCapHeight:0];
        [self addSubview:_lineView];
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

- (void)setHiddenLine:(BOOL)hiddenLine
{
    _hiddenLine = hiddenLine;
    _lineView.hidden = hiddenLine;
}

//- (UILabel *)certifacateLab
//{
//    if (!_certifacateLab)
//    {
//        _certifacateLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, TFScalePoint(200), 44)];
//        _certifacateLab.textColor = [UIColor blackColor];
//        [_certifacateLab setFont:[UIFont systemFontOfSize:16]];
//    }
//    return _certifacateLab;
//}

@end
