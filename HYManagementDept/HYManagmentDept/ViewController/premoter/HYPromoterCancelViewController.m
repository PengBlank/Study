//
//  HYPromoterCancelViewController.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-1.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromoterCancelViewController.h"
#import "UIView+Style.h"
#import "HYAddCardSubmitBackgroundView.h"
#import "HYPromotersVerifyCodeRequest.h"
#import "HYPromotersCancelParam.h"
#import "UIAlertView+Utils.h"
#import "HYKeyboardHandler.h"
#import "UIView+Style.h"

@interface HYPromoterCancelViewController ()
<HYKeyboardHandlerDelegate,
UITextFieldDelegate>

@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, strong) UITextField *codeField;

//验证码请求
@property (nonatomic, strong) HYPromotersVerifyCodeRequest *codeRequest;

@property (nonatomic, strong) HYPromotersCancelParam *cancelRequest;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger sec;

//keyboard
@property (nonatomic, strong) HYKeyboardHandler *keyboardHandler;

@end

@implementation HYPromoterCancelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.keyboardHandler = [[HYKeyboardHandler alloc] init];
    }
    return self;
}

- (void)loadView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:screen];
    self.view.backgroundColor = [UIColor clearColor];
    
    _maskView = [[UIView alloc] initWithFrame:screen];
    _maskView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.6];
    _maskView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_maskView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_contentView];
    
    self.keyboardHandler.delegate = self;
    _keyboardHandler.view = self.view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    CGSize size;
    if (pad) {
        size = CGSizeMake(400, 220);
    } else {
        size = CGSizeMake(280, 220);
    }

    _contentView.frame = CGRectMake(CGRectGetMidX(self.view.frame)-size.width/2, CGRectGetMidY(self.view.bounds)-size.height/2, size.width, size.height);
    _contentView.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1];
    [_contentView addCorner:5];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleAllMargin;
    
    CGFloat x,y,w,h;
    x = 2;
    y = 2;
    w = size.width - 2*x;
    h = 40;
    UIFont *font = pad ? [UIFont systemFontOfSize:16.0] : [UIFont systemFontOfSize:14.0];
    
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:22.0];
    title.text = @"取消操作员";
    title.textColor = [UIColor blackColor];
    [title sizeToFit];
    x = CGRectGetMidX(_contentView.bounds) - title.frame.size.width/2;
    y = 10;
    title.frame = CGRectMake(x, y, title.frame.size.width, title.frame.size.height);
    [_contentView addSubview:title];
    
    UILabel *warningLab = [[UILabel alloc] init];
    warningLab.font = font;
    warningLab.textColor = [UIColor redColor];
    warningLab.text = @"执行此操作将不可恢复，你确定需要删除此记录吗？";
    x = pad ? 20 : 10;
    w = CGRectGetWidth(_contentView.frame) - 2*x;
    size = [warningLab.text sizeWithFont:font
                       constrainedToSize:CGSizeMake(w, 100)];
    warningLab.frame = CGRectMake(x, CGRectGetMaxY(title.frame)+2, size.width, size.height);
    warningLab.numberOfLines = 0;
    [_contentView addSubview:warningLab];
    
    //获取验证码
    y = CGRectGetMaxY(warningLab.frame) + 5;
    h = 30;
    UILabel *getCodeLab = [[UILabel alloc] init];
    getCodeLab.font = font;
    getCodeLab.text = @"获取验证码：";
    [getCodeLab sizeToFit];
    getCodeLab.frame = CGRectMake(x, y,
                                  CGRectGetWidth(getCodeLab.frame),
                                  h);
    [_contentView addSubview:getCodeLab];
    
    x = CGRectGetMaxX(getCodeLab.frame) + 5;
    UIButton *getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 150, h)];
    [getCodeBtn setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font = font;
    [getCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [getCodeBtn setBackgroundColor:[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
    [getCodeBtn addBorder:1 borderColor:[UIColor blackColor]];
    [getCodeBtn addCorner:4.0];
    [getCodeBtn addTarget:self action:@selector(getCodeAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:getCodeBtn];
    self.getCodeBtn = getCodeBtn;
    
    //输入验证码
    x = 20;
    y = CGRectGetMaxY(getCodeLab.frame) + 5;
    UILabel *codeLab = [[UILabel alloc] init];
    codeLab.font = font;
    codeLab.text = @"验证码：";
    [codeLab sizeToFit];
    codeLab.frame = CGRectMake(x, y,
                                  CGRectGetWidth(codeLab.frame),
                                  h);
    [_contentView addSubview:codeLab];
    
    x = CGRectGetMaxX(codeLab.frame) + 5;
    UITextField *codeField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, 100, h)];
    codeField.font = font;
    codeField.borderStyle = UITextBorderStyleLine;
    codeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    codeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    codeField.returnKeyType = UIReturnKeyDone;
    codeField.delegate = self;
    [_contentView addSubview:codeField];
    self.codeField = codeField;
    
    //线条
    h = 50;
    UIView *horiLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_contentView.bounds)- h, CGRectGetWidth(_contentView.bounds), 1)];
    horiLine.backgroundColor = [UIColor colorWithRed:177/255.0 green:177/255.0 blue:177/255.0 alpha:1];
    horiLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [_contentView addSubview:horiLine];
    
    UIView *vertLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(_contentView.bounds), CGRectGetMaxY(horiLine.frame), 1, h)];
    vertLine.backgroundColor = [UIColor colorWithRed:177/255.0 green:177/255.0 blue:177/255.0 alpha:1];
    vertLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [_contentView addSubview:vertLine];
    
    
    w = CGRectGetWidth(_contentView.bounds)/2;
    y = CGRectGetHeight(_contentView.bounds) - h;
    x = 0;
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:89/255.0
                                             green:124/255.0
                                              blue:251/255.0 alpha:1]
                    forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [cancelBtn addTarget:self action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:cancelBtn];
    
    x += w;
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor colorWithRed:89/255.0
                                             green:124/255.0
                                              blue:251/255.0 alpha:1]
                    forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [submitBtn addTarget:self action:@selector(submitAction:)
        forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:submitBtn];
    
    [self adjustViewFrame];
    [self showWithAnimation];
    
    [_keyboardHandler startListen];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_keyboardHandler stopListen];
    
    if (_timer) {
        [_timer invalidate];
    }
    [_codeRequest cancel];
    [_cancelRequest cancel];
    [self hideLoadingView];
}

- (void)cancelAction:(UIButton *)btn
{
    __weak HYPromoterCancelViewController *b_self = self;
    UIView *contentView = _contentView;
    [UIView animateWithDuration:.3 animations:^{
        contentView.frame = CGRectMake(CGRectGetMinX(contentView.frame), CGRectGetMaxY(b_self.view.bounds), CGRectGetWidth(contentView.frame), CGRectGetHeight(contentView.frame));
    } completion:^(BOOL finished) {
        [b_self.view removeFromSuperview];
        if (b_self.delegate &&
            [b_self.delegate respondsToSelector:@selector(customModalDismiss:)])
        {
            [b_self.delegate customModalDismiss:btn==nil];
        }
    }];
}

- (void)submitAction:(UIButton *)btn
{
    NSString *verifyCode = self.codeField.text;
    if (verifyCode.length == 0)
    {
        [UIAlertView showMessage:@"请填写验证码"];
        return;
    }
    
    [self showLoadingView];
    
    if (_cancelRequest) {
        [_cancelRequest cancel];
    }
    _cancelRequest = [[HYPromotersCancelParam alloc] init];
    _cancelRequest.user_id = self.promoters.user_id;
    _cancelRequest.pid = self.promoters.code;
    _cancelRequest.verify_code = verifyCode;
    __weak typeof(self) b_self = self;
    [_cancelRequest sendReuqest:^(id result, NSError *error)
    {
        [b_self hideLoadingView];
        HYPromotersCancelResponse *rs = (HYPromotersCancelResponse *)result;
        if (rs)
        {
            if (rs.status == 200) {
                [UIAlertView showMessage:@"操作成功"];
                [b_self cancelAction:nil];
            } else {
                [UIAlertView showMessage:rs.rspDesc];
            }
        }
        else
        {
            if (self.view.window) {
                [UIAlertView showMessage:@"网络请求异常"];
            }
        }
    }];
    
    
}

- (void)getCodeAction:(UIButton *)btn
{
    [self showLoadingView];
    if (_codeRequest) {
        [_codeRequest cancel];
        _codeRequest = nil;
    }
    _codeRequest = [[HYPromotersVerifyCodeRequest alloc] init];
    _codeRequest.pid = self.promoters.code;
    _codeRequest.user_id = self.promoters.user_id;
//    _codeRequest.number = self.promoters.number;
    __weak typeof(self) b_self = self;
    [_codeRequest sendReuqest:^(id result, NSError *error)
    {
       [b_self hideLoadingView];
        HYPromotersVerifyCodeResponse *rs = (HYPromotersVerifyCodeResponse *)result;
        if (rs)
        {
            if (rs.status == 200) {
                [UIAlertView showMessage:@"发送成功"];
                [b_self beginTimer];
            } else {
                [UIAlertView showMessage:rs.rspDesc];
            }
        }
        else
        {
            if (self.view.window) {
                [UIAlertView showMessage:@"网络请求异常"];
            }
        }
    }];
}

- (void)beginTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    self.sec = 60;
}

- (void)timerAction:(NSTimer *)timer
{
    if (_sec > 0) {
        _sec--;
        DebugNSLog(@"sec : %ld", (long)_sec);
        NSString *title = [NSString stringWithFormat:@"%ld秒后重新发送", (long)_sec];
        _getCodeBtn.enabled = NO;
        [_getCodeBtn setTitle:title forState:UIControlStateDisabled];
    } else {
        [_timer invalidate];
        _getCodeBtn.enabled = YES;
        [_getCodeBtn setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showWithAnimation
{
    CGRect frame_store = _contentView.frame;
    _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame),
                                    CGRectGetMaxY(self.view.frame),
                                    CGRectGetWidth(_contentView.frame),
                                    CGRectGetHeight(_contentView.frame));
    [UIView animateWithDuration:.3 animations:^
    {
        _contentView.frame = frame_store;
    }];
}

- (void)adjustViewFrame
{
    BOOL pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    if (pad)
    {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        {
            self.view.frame = CGRectMake(0, 0, 768, 1024);
        }
        else if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            self.view.frame = CGRectMake(0, 0, 1024, 768);
        }
    }
}

- (void)show
{
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [root addChildViewController:self];
    [self willMoveToParentViewController:root];
    [root.view addSubview:self.view];
    [self didMoveToParentViewController:root];
}

- (void)dismiss
{
    //UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [self willMoveToParentViewController:nil];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self adjustViewFrame];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _codeField)
    {
        [textField resignFirstResponder];
    }
    return YES;
}


#pragma mark -

//- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
//{
//    return YES;
//}
//- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
//{
//    return UIInterfaceOrientationMaskAll;
//}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0)
//{
//    return YES;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeLeft;
//}

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
