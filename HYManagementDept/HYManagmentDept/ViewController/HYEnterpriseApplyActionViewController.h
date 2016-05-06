//
//  HYEnterpriseApplyActionViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYEnterpriseMemberApply.h"

@interface HYEnterpriseApplyActionViewController : UIViewController
<UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *applyTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *memberCountLabel;
@property (nonatomic, strong) IBOutlet UITextView *commentView;
@property (nonatomic, strong) IBOutlet UIImageView *commentBg;
@property (nonatomic, weak) IBOutlet UIButton *cancelBtn;
@property (nonatomic, weak) IBOutlet UIButton *submitBtn;

@property (nonatomic, strong) HYEnterpriseMemberApply *memberApply;

- (IBAction)refuseBtnAction:(id)sender;
- (IBAction)acceptBtnAction:(id)sender;

@property (nonatomic, copy) void (^actionCallback)(BOOL success) ;

@end
