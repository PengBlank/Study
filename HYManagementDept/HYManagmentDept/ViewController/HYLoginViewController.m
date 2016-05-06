//
//  HYLoginViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYLoginViewController.h"
#import "HYLoginParam.h"
#import "UIView+Style.h"
#import "HYAppDelegate.h"
#import "HYLoginInfoCache.h"
#import "UIAlertView+Utils.h"
#import "UIImage+ResizableUtil.h"
#import "HYLoginTextFrameView.h"
#import "UIDevice+Resolutions.h"
#import "HYLoginView.h"
#import "HYDataManager.h"
#import "HYKeyboardHandler.h"



@interface HYLoginViewController ()
<HYKeyboardHandlerDelegate>
{
    HYLoginView *_view;
    
    //internet variables
    HYLoginParam *_loginRequest;
    
}

@property (nonatomic, strong) HYLoginView *view;
@property (nonatomic, strong) HYKeyboardHandler *keyboardHandler;

@end

@implementation HYLoginViewController

- (void)dealloc
{
    [self.keyboardHandler stopListen];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    HYLoginView *loginView = [[HYLoginView alloc] initWithFrame:frame];
    self.view = loginView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HYLoginView *view = (HYLoginView *)self.view;
    
    view.nameField.delegate = self;
    view.passField.delegate = self;
//    [view.rememberPassBtn addTarget:self
//                             action:@selector(rememberNameBtnClicked:)
//                   forControlEvents:UIControlEventTouchUpInside];
    [view.rememberPassBtn addTarget:self
                             action:@selector(rememberPassBtnClicked:)
                   forControlEvents:UIControlEventTouchUpInside];
    [view.loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.keyboardHandler = [[HYKeyboardHandler alloc]
                            initWithDelegate:self view:self.view];
    
    //[HYLoadHubView show];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_keyboardHandler startListen];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_keyboardHandler stopListen];
}

#pragma mark - Keyboard
- (void)xMoveViewWithOffset:(CGFloat)offset
{
    BOOL isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    CGFloat version = [[UIDevice currentDevice] systemVersion].floatValue;
    [UIView animateWithDuration:0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         CGRect frame = self.view.frame;
         if (isPad && version < 8.0)
         {
             frame.origin.x = offset;
         }
         else
         {
             frame.origin.y = offset;
         }
         self.view.frame = frame;
     } completion:nil];
}

- (CGFloat)getAppropriateOffset
{
    CGFloat offset = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        offset = 100;
    }
    else if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        CGFloat version = [[UIDevice currentDevice] systemVersion].floatValue;
        if (version < 8.0) {
            offset = self.interfaceOrientation == UIInterfaceOrientationLandscapeRight ? \
            -1 : 1;
            offset *= 150;
        } else {
            offset = 150;
        }
        
    }
    return offset;
}

- (void)keyboardChangeFrame:(CGRect)kFrame
{
    CGFloat offset = -[self getAppropriateOffset];
    [self xMoveViewWithOffset:offset];
}

- (void)keyboardHide
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.view.frame = frame;
}

#pragma mark -

- (void)loginBtnClicked:(UIButton *)btn
{
    //验证
    [self.view endEditing:YES];
    
    HYLoginView *view = (HYLoginView *)self.view;
    
    NSString *name = view.nameField.text;
    NSString *pass = view.passField.text;
    
    if (name.length == 0 || pass.length == 0)
    {
        [UIAlertView showMessage:@"帐号或密码不能为空"];
        return;
    }
    
    _loginRequest = [[HYLoginParam alloc] init];
    _loginRequest.user_name = name;
    _loginRequest.password = pass;
    [self showLoadingView];
    
    __weak typeof(self) b_self = self;
    [_loginRequest sendReuqest:^(id result, NSError *error)
    {
        [b_self hideLoadingView];
        
        if ([result isKindOfClass:[HYBaseResponse class]])
        {
            HYLoginResponse *response = (HYLoginResponse *)result;
            
            if (response.status == 200) {
                //success
                HYUserInfo *userInfo = response.userInfo;
                
                //User type validate
                if (userInfo.organType == OrganTypeUnkown)
                {
                    [UIAlertView showMessage:@"未知用户类型,请重试."];
                    return ;
                }
                
                [HYDataManager sharedManager].userInfo = userInfo;
                
                //cache
                NSString *nameR, *passR;
               if (view.rememberPassBtn.selected) {
                    passR = pass;
                    nameR = name;
                }
                
                [HYLoginInfoCache loginInfoWithName:nameR passWord:passR shouldCache:YES];
                HYAppDelegate *delegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate showContent];
            }
            else
            {
                [UIAlertView showMessage:error.domain];
            }
        }
        else
        {
            [UIAlertView showMessage:@"网络请求异常"];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event

- (void)rememberNameBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [[NSUserDefaults standardUserDefaults] setBool:btn.selected forKey:kShouldRememberUserNameKey];
}

- (void)rememberPassBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [[NSUserDefaults standardUserDefaults] setBool:btn.selected forKey:kShouldRememberUserNameKey];
    [[NSUserDefaults standardUserDefaults] setBool:btn.selected forKey:kShouldRememberUserPassKey];
}

#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    HYLoginView *view = (HYLoginView *)self.view;
    if (textField == view.nameField &&
        view.passField.text != nil)
    {
        view.passField.text = nil;
        [HYLoginInfoCache deleteCachedLoginInfo];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    HYLoginView *view = (HYLoginView *)self.view;
    if (textField == view.nameField &&
        view.passField.text != nil)
    {
        view.passField.text = nil;
        [HYLoginInfoCache deleteCachedLoginInfo];
    }
    return YES;
}

#pragma mark -

#pragma mark -

- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0)
{
   return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    HYLoginView *view = (HYLoginView *)self.view;
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [view setupiPadLanscape];
    }else
    {
        [view setupiPadPortrait];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
