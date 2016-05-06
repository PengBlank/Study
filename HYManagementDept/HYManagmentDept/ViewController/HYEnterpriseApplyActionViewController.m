//
//  HYEnterpriseApplyActionViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYEnterpriseApplyActionViewController.h"
#import "HYEtApproveRequest.h"
#import "UIAlertView+Utils.h"
#import "UIImage+ResizableUtil.h"
#import "UIDevice+Resolutions.h"
#import "UINavigationItem+Margin.h"

@interface HYEnterpriseApplyActionViewController ()<UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *_editingTap;
}
@property (nonatomic, strong) HYEtApproveRequest *request;

@end

@implementation HYEnterpriseApplyActionViewController

- (void)dealloc
{
    [self.request cancel];
    self.request = nil;
    DebugNSLog(@"et apply action is released");
}


- (void)refuseBtnAction:(id)sender
{
    [self sendRequestWithAccept:NO];
}

- (void)acceptBtnAction:(id)sender
{
    [self sendRequestWithAccept:YES];
}

- (void)sendRequestWithAccept:(BOOL)accept
{
    [self.navigationController.view endEditing:YES];
    [self showLoadingView];
    
    self.request = [[HYEtApproveRequest alloc] init];
    _request.user_id = _memberApply.m_id;
    _request.desc = _commentView.text;
    _request.status = accept ? 1 : 0;
    __weak HYEnterpriseApplyActionViewController *w_self = self;
    [_request sendReuqest:^(id result, NSError *error)
    {
        HYEnterpriseApplyActionViewController *s_self = w_self;
        [s_self hideLoadingView];
        if ([result isKindOfClass:[HYEtApproveResponse class]])
        {
            HYEtApproveResponse *rs = (HYEtApproveResponse *)result;
            if (rs.status == 200)
            {
                [UIAlertView showMessage:@"审批完成"];
                if (s_self.actionCallback)
                {
                    s_self.actionCallback(YES);
                }
                [s_self menuItemClicked:nil];
            } else {
                NSString *err = rs.rspDesc;
                [UIAlertView showMessage:err];
            }
        }
    }];
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"企业会员审批";
    BOOL onPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    float titleFontSize = onPad ? 22.0 : 16.0;
//    if (onPad)
//    {
//        
//    } else {
//        CGRect frame = self.view.frame;
//        frame.size = CGSizeMake(320, 480);
//        self.view.frame = frame;
//    }
    UIImage *navB;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        navB = [UIImage imageNamed:@"nav_128"];
    }
    else
    {
        navB = [UIImage imageNamed:@"nav_88"];
    }
    [self.navigationController.navigationBar setBackgroundImage:navB forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeFont: [UIFont boldSystemFontOfSize:titleFontSize], UITextAttributeTextColor:[UIColor whiteColor]}];
    
    UIBarButtonItem *cancelItem;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(menuItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = cancelItem;
    [self.navigationItem setLeftBarButtonItemWithMargin:cancelItem];
    
    [self setWithMember:_memberApply];
    
    _commentView.delegate = self;
    UIImage *frame = [UIImage imageNamed:@"input"];
    frame = [frame utilResizableImageWithCapInsets:UIEdgeInsetsMake(7, 10, 7, 10)];
    self.commentBg.image = frame;
    
    UIImage *btn_n = [UIImage imageNamed:@"orderlist_btn"];
    btn_n = [btn_n stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.cancelBtn setBackgroundImage:btn_n forState:UIControlStateNormal];
    [self.submitBtn setBackgroundImage:btn_n forState:UIControlStateNormal];
    
    _editingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editingTapAction:)];
    _editingTap.delegate = self;
    //[self.view addGestureRecognizer:_editingTap];
}

//收回键盘
- (void)editingTapAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)setWithMember:(HYEnterpriseMemberApply *)member
{
    self.userNameLabel.text = member.enterprise_name;
    self.applyTimeLabel.text = member.created;
    self.memberCountLabel.text = [NSString stringWithFormat:@"%ld", (long)member.total_member];
}

- (void)menuItemClicked:(UIButton *)btn
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)offset{return 60;}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIWindow *w = [[UIApplication sharedApplication].delegate window];
    [w addGestureRecognizer:_editingTap];
    if ([UIDevice isRunningOniPhone4])
    {
        [UIView animateWithDuration:.3 animations:^{
            CGFloat off = -[self offset];
            CGRect frame = self.view.frame;
            frame.origin.y = off;
            self.view.frame = frame;
        }];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    UIWindow *w = [[[UIApplication sharedApplication] delegate] window];
    [w removeGestureRecognizer:_editingTap];
    if ([UIDevice isRunningOniPhone4])
    {
        [UIView animateWithDuration:.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = 44;
            self.view.frame = frame;
        }];
    }
}

@end

@interface UINavigationController (dismiss)
- (BOOL)disablesAutomaticKeyboardDismissal;
@end

@implementation UINavigationController (dismiss)

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

@end
