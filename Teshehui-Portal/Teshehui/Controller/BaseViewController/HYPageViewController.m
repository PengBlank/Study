//
//  HYPageViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-31.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYPageViewController.h"

@interface HYPageViewControl ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
}

@end

@implementation HYPageViewControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        frame.origin = CGPointZero;
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    
    return self;
}

#pragma mark private methods


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
