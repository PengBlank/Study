//
//  HYQuickActive2ViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-31.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseDetailViewController.h"
#import "HYCardActiveInfo.h"
@class HYQuickActiveViewController;

@interface HYQuickActive2ViewController : HYBaseDetailViewController

@property (nonatomic, strong) HYCardActiveInfo *activeInfo;

@property (nonatomic, weak) HYQuickActiveViewController *delegate;


- (void)clearInfo;
@end
