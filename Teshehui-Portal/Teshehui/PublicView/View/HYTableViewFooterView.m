//
//  HYTableViewFooterView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-14.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYTableViewFooterView.h"

@implementation HYTableViewFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_loadView.frame = CGRectMake(90, 12.0f, 20.0f, 20.0f);
		[self addSubview:_loadView];
        
        _loadText = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(0.0f, 12.0f, 320.0f, 20.0f)];
        _loadText.textAlignment = NSTextAlignmentCenter;
        _loadText.textColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
        _loadText.backgroundColor = [UIColor clearColor];
        _loadText.shadowColor = [UIColor whiteColor];
        _loadText.shadowOffset = CGSizeMake(0.5, 0);
        _loadText.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_loadText];
    }
    return self;
}

/*
 - (void)drawRect:(CGRect)rect
 {
 [super drawRect:rect];
 
 if (_needShowLine) {
 UIImage *lineImage = [UIImage imageNamed:@"line_bottom.png"];
 [lineImage drawAtPoint:CGPointMake(45, 22)];
 [lineImage drawAtPoint:CGPointMake(200, 22)];
 }
 }
 */

- (void)startLoadMore
{
    _loadFinish = NO;
    self.loadText.text = @"正在加载更多...";
    [self.loadView startAnimating];
}

- (void)stopLoadMore
{
    _loadFinish = YES;
    self.loadText.text = @"加载完成";
    [self.loadView stopAnimating];
}
@end
