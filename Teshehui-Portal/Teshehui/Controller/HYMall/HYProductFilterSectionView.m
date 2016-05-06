//
//  HYProductFilterSectionView.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/5.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductFilterSectionView.h"

@interface HYProductFilterSectionView ()
{
    UILabel *_titleLab;
    
    UIImageView *_asscessView;
}
@end

@implementation HYProductFilterSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _asscessView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-20, frame.size.height/2-6, 7, 12)];
        _asscessView.transform = CGAffineTransformMakeRotation(M_PI/2);
        [_asscessView setImage:[UIImage imageNamed:@"cell_indicator"]];
        [self addSubview:_asscessView];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, frame.size.height)];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [UIColor redColor];
        _titleLab.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLab];
        
        UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        expandBtn.frame = CGRectMake(0, 0, ScreenRect.size.width, 60);
        [expandBtn addTarget:self
                      action:@selector(expandCell:)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:expandBtn];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, CGRectGetWidth(self.frame)-1, 1.0)];
        lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                       topCapHeight:0];
        [self addSubview:lineView];
        
        _isExpend = YES;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - private methods
- (void)expandCell:(id)sender
{
    self.isExpend = !self.isExpend;
    
    if ([self.delegate respondsToSelector:@selector(didExpandCellWithSection:)])
    {
        [self.delegate didExpandCellWithSection:self.tag];
    }
}

#pragma mark setter/getter
- (void)setIsExpend:(BOOL)isExpend
{
    if (isExpend != _isExpend)
    {
        _isExpend = isExpend;
        
        [UIView animateWithDuration:0.4 animations:^{
            CGFloat rad = isExpend ?  M_PI/2 : -M_PI/2;
            _asscessView.transform = CGAffineTransformMakeRotation(rad);
        }];
    }
}

- (void)setTitle:(NSString *)title
{
    if (title != _title)
    {
        _title = title;
        
        _titleLab.text = title;
    }
}

@end
