//
//  HYAttentionMeViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAttentionMeViewController.h"
#import "HYLoadHubView.h"
#import "HYGetWebLinkRequest.h"
#import "HYGetWebLinkResponse.h"
#import "HYNullView.h"

@interface HYAttentionMeViewController ()<UIWebViewDelegate>
{
    HYGetWebLinkRequest* _linkRequest;
}

@property (nonatomic, strong) HYNullView *nullView;

@end

@implementation HYAttentionMeViewController


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
    self.title = @"关注我们";
    [self getHomeList];
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
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        UIWebView *web = [[UIWebView alloc] initWithFrame:frame];
        web.scalesPageToFit = YES;
        web.delegate = self;
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]]];
        [self.view addSubview:web];
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
    _linkRequest.type = AttentionInfo;
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [_linkRequest sendReuqest:^(id result, NSError *error) {

        if (result && [result isKindOfClass:[HYGetWebLinkResponse class]])
        {
            HYGetWebLinkResponse *response = (HYGetWebLinkResponse *)result;
            [b_self reloadWithLink:response.link];
        }
    }];
    
}

-(void)dealloc
{
    [_linkRequest cancel];
    _linkRequest = nil;
    [HYLoadHubView dismiss];
}
@end
