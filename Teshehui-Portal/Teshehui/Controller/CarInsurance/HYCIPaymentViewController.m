//
//  HYCIPaymentViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIPaymentViewController.h"
#import "HYNullView.h"
#import "UIImage+Addition.h"
#import "HYCIOrderListViewController.h"

@interface HYCIPaymentViewController ()
<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *MyWeb;
@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, strong) UIBarButtonItem *completeItem;
@end

@implementation HYCIPaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"支付订单";  //@"金秋大抽奖,“礼品”疯狂送";//
    
    _MyWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _MyWeb.scalesPageToFit = YES;
    _MyWeb.delegate = self;
    [_MyWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_paymentURL]]];
    [self.view addSubview:_MyWeb];
    
    _nullView = [[HYNullView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_nullView];
    _nullView.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = self.completeItem;
}

- (UIBarButtonItem *)completeItem
{
    if (!_completeItem)
    {
        UIImage *btnImg = [[UIImage imageNamed:@"sp_btn_normal"] utilResizableImageWithCapInsets:UIEdgeInsetsMake(10, 7, 6, 6)];
        UIButton *cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 58, 32)];
        [cityBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
        [cityBtn setTitle:@"完成" forState:UIControlStateNormal];
        cityBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [cityBtn addTarget:self
                    action:@selector(cityBtnAction:)
          forControlEvents:UIControlEventTouchUpInside];
        _completeItem = [[UIBarButtonItem alloc] initWithCustomView:cityBtn];
    }
    return _completeItem;
}

- (void)cityBtnAction:(UIButton *)btn
{
    if (_pageFrom == 0)
    {
        //为0则从首页进入，直接退回首页
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (_pageFrom == 1)
    {
        //为1从订单列表进入，退回订单列表
        NSArray *controllers = self.navigationController.viewControllers;
        HYCIOrderListViewController *listController = nil;
        for (UIViewController *controller in controllers)
        {
            if ([controller isKindOfClass:[HYCIOrderListViewController class]])
            {
                listController = (HYCIOrderListViewController*)controller;
                break;
            }
        }
        if (listController)
        {
            [listController reloadOrderData];
            [self.navigationController popToViewController:listController animated:YES];
        }
        else    //如果不能找到订单列表视图，直接退回根视图
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)dealloc
{
    [HYLoadHubView dismiss];
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
//    if (error)
//    {
//        _nullView.hidden = NO;
//        _nullView.descInfo = @"获取支付页面失败，请重试";
//    }
}

/**
 * 根据从定向处理页面调用本地方法的问题
 */
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType

{
    NSString *urlString = [[request URL] absoluteString];
    
    NSArray *urlComps = [urlString componentsSeparatedByString:@":"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        NSString *funcStr = [urlComps objectAtIndex:1];
        if([funcStr isEqualToString:@"doFunc1"])
        {
            /*调用本地函数1*/
        }
        else if([funcStr isEqualToString:@"doFunc2"])
        {
            /*调用本地函数2*/
        }
        
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
