//
//  UITableView+Extend.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-12.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "UITableView+Extend.h"

@implementation UITableView (Extend)

- (void)setExtraLinesHidden;
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
}

@end
