//
//  HYRefreshHeaderView.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-26.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "CCRefreshHeaderView.h"

@interface HYRefreshHeaderView : CCRefreshHeaderView
{
    
}


@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *lastUpdateLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) CALayer *arrowImage;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

@end
