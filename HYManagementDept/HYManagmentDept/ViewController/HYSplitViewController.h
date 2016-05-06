//
//  HYSplitViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-14.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMasterTableViewController.h"
#import "HYBaseDetailViewController.h"
#import "HYSlideDefine.h"
//#include "HYSlideDefine.h"

@interface HYSplitViewController : UIViewController
{
    BOOL _isShare;
}
@property (nonatomic, strong) HYMasterTableViewController *masterViewController;
@property (nonatomic, strong) UIViewController *detailViewController;
@property (nonatomic, strong) UIView *detailWrapperView;

- (void)showDetailViewController:(UIViewController *)detail;

- (void)changeSlideState;
- (void)moveOffset:(CGFloat)offset;

//promoters only
@property (nonatomic, strong) NSString *inviteCode;

@end
