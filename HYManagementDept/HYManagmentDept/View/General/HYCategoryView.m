//
//  HYCategoryView.m
//  HYManagmentDept
//
//  Created by apple on 14/12/16.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYCategoryView.h"
#include "HYStyleConst.h"

@implementation HYCategoryView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame])
    {
        _titles = titles;
        [self setDefaultMetrics];
        self.backgroundColor = kCategoryNormalColor;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        CGRect btnframe = CGRectMake(_metrics.categoryx, 0, _metrics.categorywidth, CGRectGetHeight(frame));
        UIScrollView *contentScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        contentScroll.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -3, 0);
        contentScroll.bounces = NO;
        contentScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:contentScroll];
        
        NSMutableArray *btns = [NSMutableArray array];
        for (int i = 0; i < titles.count; i++)
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:btnframe];
            NSString *title = [titles objectAtIndex:i];
            [btn setTitle:title forState:UIControlStateNormal];
            btn.backgroundColor = kCategoryNormalColor;
            btn.titleLabel.font = [UIFont systemFontOfSize:_metrics.font];
            
            [contentScroll addSubview:btn];
            
            [btns addObject:btn];
            
            //加分隔线
            if (i != titles.count - 1)
            {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnframe), 3, 1, CGRectGetHeight(self.frame)-6)];
                line.backgroundColor = [UIColor colorWithWhite:.63 alpha:1];
                [contentScroll addSubview:line];
            }
            
            btnframe.origin.x += CGRectGetWidth(btnframe) + _metrics.categoryspace;
        }
        UIButton *lastBtn = [btns lastObject];
        CGFloat offx = CGRectGetMaxX(lastBtn.frame) + _metrics.categoryx;
        if (offx > CGRectGetWidth(frame))
        {
            contentScroll.contentSize = CGSizeMake(offx, CGRectGetHeight(frame));
        }
        
        _form = [[SingleSelectForm alloc] initWithButtons:btns];
        _contentScroll = contentScroll;
    }
    return self;
}

- (void)setDefaultMetrics
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        _metrics.categoryx = 25;
        _metrics.categorywidth = 105;
        _metrics.categoryspace = 0.5;
        _metrics.font = 18.0;
    }
    else
    {
        _metrics.categoryx = 0;
        _metrics.categoryspace = 0.5;
        _metrics.categorywidth = 65;
        _metrics.font = 13.0;
        
        CGFloat expectWidth = _titles.count * _metrics.categorywidth + (_titles.count-1) * _metrics.categoryspace + _metrics.categoryx*2;
        if (expectWidth < CGRectGetWidth(self.frame))
        {
            _metrics.categorywidth = CGRectGetWidth(self.frame) / _titles.count;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIButton *lastBtn = [_form.buttons lastObject];
        CGFloat offx = CGRectGetMaxX(lastBtn.frame) + _metrics.categoryx;
        if (offx > CGRectGetWidth(self.frame))
        {
            _contentScroll.contentSize = CGSizeMake(offx, CGRectGetHeight(self.frame));
        }
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
