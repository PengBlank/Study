//
//  HYHelpViewController.m
//  Teshehui
//
//  Created by ichina on 14-3-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHelpViewController.h"
#import "HYGetHelpRequest.h"
#import "HYGetHelpResponse.h"

#import "HYGetWebLinkRequest.h"
#import "HYGetWebLinkResponse.h"

#import "HYNullView.h"
#import "HYLoadHubView.h"

@interface HYHelpViewController ()<UIWebViewDelegate>
{
    HYGetWebLinkRequest *_linkRequest;
}

@property (nonatomic, strong) HYNullView *nullView;

@end


@implementation HYHelpViewController

- (void)dealloc
{
    [_linkRequest cancel];
    _linkRequest = nil;
    
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    t.textColor = [UIColor colorWithRed:161.0/255.0
                                  green:0
                                   blue:0
                                  alpha:1.0];
    t.font = [UIFont systemFontOfSize:19];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = NSTextAlignmentCenter;
    t.text = self.title;
    self.navigationItem.titleView = t;
    
    self.title = @"帮助";
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 48, 30);
    [backButton setTitle:@"关闭" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithWhite:0.4 alpha:1]
                     forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [backButton addTarget:self
                   action:@selector(dismissView:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = leftBarItem;
    
    [self getHomePageList];
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
- (void)dismissView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

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

-(void)getHomePageList
{
    _linkRequest = [[HYGetWebLinkRequest alloc] init];
    _linkRequest.type = HelpInfo;
    
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

@end
