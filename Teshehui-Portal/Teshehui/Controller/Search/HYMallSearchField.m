//
//  HYMallSearchField.m
//  Teshehui
//
//  Created by apple on 15/1/23.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallSearchField.h"

@implementation HYMallSearchField

- (void)awakeFromNib
{
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 28)];
    UIImage *search = [UIImage imageNamed:@"i_search.png"];
    UIImageView *searchV = [[UIImageView alloc] initWithImage:search];
    searchV.center = CGPointMake(CGRectGetMidX(left.bounds), CGRectGetMidY(left.frame));
    [left addSubview:searchV];
    self.leftView = left;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, 30, CGRectGetHeight(bounds));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
