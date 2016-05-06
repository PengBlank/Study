//
//  HYAddCardViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-15.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseDetailViewController.h"
#import "HYPublicView.h"
/**
 *  会员卡批发
 */
@interface HYAddCardViewController : HYBaseDetailViewController<HYPublicViewDelegate>

- (void)loadAgencyList;

@property (nonatomic, readonly) HYPublicView *publicView;

@end
