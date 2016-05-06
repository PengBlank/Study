//
//  HYFlightWapPayViewController.m
//  Teshehui
//
//  Created by HYZB on 14-8-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightWapPayViewController.h"
#import "HYLoadHubView.h"
#import "HYNullView.h"

@interface HYFlightWapPayViewController ()
<
UIWebViewDelegate,
UIAlertViewDelegate
>

@property (nonatomic, strong) HYNullView *nullView;

@end

@implementation HYFlightWapPayViewController

- (void)dealloc
{
    _webView.delegate = nil;
    [_webView stopLoading];
    _webView = nil;
    
    [HYLoadHubView dismiss];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    // Do any additional setup after loading the view.
    self.title = @"携程支付";
    
    [self loadWebView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark setter/getter
- (HYNullView *)nullView
{
    if (!_nullView)
    {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _nullView = [[HYNullView alloc] initWithFrame:frame];
        [self.view addSubview:self.nullView];
    }
    
    return _nullView;
}

#pragma mark - private methods
- (void)loadWebView
{
    if ([self.orderNO length] > 0)
    {
        [HYLoadHubView show];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/Order/Pay/%@", kFlightRequestBaseURL, self.orderNO];
        
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _webView = [[UIWebView alloc] initWithFrame:frame];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        [self.view addSubview:_webView];
    }
    else
    {
        [HYLoadHubView dismiss];
        self.nullView.descInfo = @"支付信息不完整";
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HYLoadHubView dismiss];
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSString *otherUrl = [url absoluteString];

    //根据相应的重定向处理支付完成的回调
    NSRange range = [otherUrl rangeOfString:kPayResultRedirectUrl options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound)
    {
        NSString *str = [url query];
        NSString *key = [str substringFromIndex:([str length]-1)];
        BOOL result = (key.intValue == 1);
       
        if (result)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"订单支付成功，您可以在机票的订单列表中查看详细信息"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            alertView.tag = 10;
            [alertView show];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"订单支付失败"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            alertView.tag = 11;
            [alertView show];
        }
        
        return NO;
    }
    
    [HYLoadHubView show];
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [HYLoadHubView dismiss];
//    self.nullView.descInfo = error.domain;
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL succ = (alertView.tag == 10);
    if (succ)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if ([self.delegate respondsToSelector:@selector(didPaymentResult:)])
    {
        [self.delegate didPaymentResult:succ];
    }
}
@end
