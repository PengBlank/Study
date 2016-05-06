//
//  HYLooknsurance.m
//  Teshehui
//
//  Created by ichina on 14-3-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCheckInsuranceViewController.h"
#import "HYLoadHubView.h"
#import "HYGetWebLinkRequest.h"
#import "HYGetWebLinkResponse.h"
#import "METoast.h"
#import "HYNullView.h"

@interface HYCheckInsuranceViewController ()
<
UIAlertViewDelegate,
UIScrollViewDelegate,
UIWebViewDelegate
>
{
    HYGetWebLinkRequest* _linkRequest;
}

@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, strong) UIWebView *web;

@end

@implementation HYCheckInsuranceViewController

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIWebView *web = [[UIWebView alloc] initWithFrame:frame];
    web.scalesPageToFit = YES;
    web.delegate = self;
    self.web = web;
    [self.view addSubview:web];
    
    if ([_insuranceProvision length] > 0)
    {
        [_web loadHTMLString:_insuranceProvision baseURL:nil];
    }else
    {
        [self getHomeList];
    }
}

- (void)backToRootViewController:(id)sender
{
    [super backToRootViewController:sender];
//    if (!self.isAgree)
//    {
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                       message:@"您已阅读并同意保险条款"
//                                                      delegate:self
//                                             cancelButtonTitle:@"确定"
//                                             otherButtonTitles:nil];
//        [alert show];
//    }
//    else
//    {
//        [super backToRootViewController:sender];
//    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HYLoadHubView dismiss];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [HYLoadHubView dismiss];
//    self.nullView.descInfo = @"获取信息失败";
}

#pragma mark private methods
- (void)reloadWithLink:(NSString *)link
{
    if (link)
    {
        [HYLoadHubView show];
        
        [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]]];
    }
    else
    {
        [HYLoadHubView dismiss];
        self.nullView.descInfo = @"获取信息失败";
    }
}

-(void)getHomeList
{
    _linkRequest = [[HYGetWebLinkRequest alloc] init];
    _linkRequest.type = InsuranceInfo;
    _linkRequest.cardNum = _cardNum;
    
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_linkRequest sendReuqest:^(id result, NSError *error) {

        if (result && [result isKindOfClass:[HYGetWebLinkResponse class]])
        {
            HYGetWebLinkResponse *response = (HYGetWebLinkResponse *)result;
            if (response.status == 200)
            {
                [b_self reloadWithLink:response.link];
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
