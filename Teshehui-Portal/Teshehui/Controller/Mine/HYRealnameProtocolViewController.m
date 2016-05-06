//
//  HYRealnameProtocolViewController.m
//  Teshehui
//
//  Created by Kris on 15/9/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRealnameProtocolViewController.h"

#import "HYCheckInsuranceViewController.h"
#import "HYLoadHubView.h"
#import "HYGetProtocolReq.h"
#import "METoast.h"
#import "HYNullView.h"

@interface HYRealnameProtocolViewController ()
<
UIAlertViewDelegate,
UIScrollViewDelegate,
UIWebViewDelegate
>
{
    HYGetProtocolReq* _linkRequest;
    UIWebView *_contentView;
}

@property (nonatomic, strong) HYNullView *nullView;

@end

@implementation HYRealnameProtocolViewController

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.title = @"保险条款";
    }
    return self;
}

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    _contentView = [[UIWebView alloc] initWithFrame:rect];
    [self.view addSubview:_contentView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self getHomeList];
}

- (void)backToRootViewController:(id)sender
{
    if (!self.isAgree)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"您已阅读并同意保险条款"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [super backToRootViewController:sender];
    }
}

#pragma mark private methods
- (void)reloadContent:(NSString *)content
{
    [HYLoadHubView dismiss];
    
    if (content)
    {
        [_contentView loadHTMLString:content
                             baseURL:nil];
    }
    else
    {
        self.nullView.descInfo = @"获取信息失败";
    }
}

-(void)getHomeList
{
    _linkRequest = [[HYGetProtocolReq alloc] init];
    _linkRequest.copywriting_key = @"user_agreement";
    
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_linkRequest sendReuqest:^(id result, NSError *error) {
        
        if (!error && result && [result isKindOfClass:[HYGetProtocolResp class]])
        {
            HYGetProtocolResp *response = (HYGetProtocolResp *)result;
            if (response.status == 200)
            {
                [b_self reloadContent:response.user_agreement];
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:response.rspDesc
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
            }
        }
        else
        {
            [METoast toastWithMessage:@"网络出现问题,请稍后再试"];
        }
    }];
}

-(void)dealloc
{
    [_linkRequest cancel];
    _linkRequest = nil;
    [HYLoadHubView dismiss];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isAgree)
    {
        CGFloat height = scrollView.frame.size.height;
        CGFloat contentYoffset = scrollView.contentOffset.y;
        CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
        
        if (distanceFromBottom < height)
        {
            self.isAgree = YES;
            
            if ([self.delegate respondsToSelector:@selector(didAgreeInsurance)])
            {
                [self.delegate didAgreeInsurance];
            }
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.isAgree = YES;
    
    if ([self.delegate respondsToSelector:@selector(didAgreeInsurance)])
    {
        [self.delegate didAgreeInsurance];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
