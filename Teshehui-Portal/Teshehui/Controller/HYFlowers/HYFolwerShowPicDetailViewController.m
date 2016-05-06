//
//  HYFolwerShowPicDetailViewController.m
//  Teshehui
//
//  Created by ichina on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFolwerShowPicDetailViewController.h"
#import "HYNullView.h"
#import "HYLoadHubView.h"

@interface HYFolwerShowPicDetailViewController ()
@property(nonatomic,strong)HYNullView* nullView;
@end

@implementation HYFolwerShowPicDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _Mytitle;
        
    _myWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _myWeb.delegate = self;
    _myWeb.scalesPageToFit = YES;
    [self.myWeb loadHTMLString:_htmlString baseURL:nil];
    [self.view addSubview:_myWeb];
    
    _nullView = [[HYNullView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_nullView];
    _nullView.hidden = YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [HYLoadHubView show];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HYLoadHubView dismiss];
    _nullView.hidden = YES;
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [HYLoadHubView dismiss];
    _nullView.hidden = NO;
    _nullView.descInfo = @"未能获取鲜花详细信息";
}

-(void)dealloc
{
    [HYLoadHubView dismiss];
}
@end
