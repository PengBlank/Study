//
//  HYMallWebViewController.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/4.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallWebViewController.h"
#import "UMSocial.h"
#import "HYNullView.h"
#import "HYShareInfoReq.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "PTAppStoreHelper.h"

#import "HYProductDetailViewController.h"
#import "HYWebToNativeManager.h"
#import <WebKit/WebKit.h>

@interface HYMallWebViewController ()
<UIWebViewDelegate,UMSocialUIDelegate>
{
    HYShareInfoReq *_shareRequest;
}

@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, strong) UIWebView *webView;
//which has higher efficiency when the system version is above iOS 8.0
@property (nonatomic, strong) WKWebView *wkView;
@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, strong) UIBarButtonItem *leftBarItemBar;
//@property (nonatomic, strong) UIBarButtonItem *shareItemBar;

@end

@implementation HYMallWebViewController


- (void)dealloc
{
    [_shareRequest cancel];
    
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    self.leftItemType = CustomItemBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    NSString *strUrl = [self.linkUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = nil;
    if (strUrl)
    {
        url = [NSURL URLWithString:strUrl];
    }
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    if (req)
    {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
        webView.scalesPageToFit = YES;
        webView.delegate = self;
        [webView loadRequest:req];
        self.webView = webView;
        [self.view addSubview:webView];
    }

    /*
    if ([[UIDevice currentDevice].systemVersion integerValue] < 8.0)
    {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
        webView.scalesPageToFit = YES;
        webView.delegate = self;
        self.webView = webView;
        [self.view addSubview:webView];
        
        if (req)
        {
            [webView loadRequest:req];
        }
    }
    else
    {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame];
//        webView.scalesPageToFit = YES;
//        webView.delegate = self;
        self.wkView = webView;
        [self.view addSubview:webView];
        
        if (req)
        {
            [webView loadRequest:req];
        }
    }
     */
    self.navigationItem.leftBarButtonItem = self.leftBarItemBar;
}

#pragma mark setter/getter
- (UIBarButtonItem *)shareItemBar
{
    if (!_shareItemBar)
    {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(0, 0, 48, 30);
        
        [shareBtn setTitleColor:[UIColor colorWithRed:161.0/255.0
                                                green:0
                                                 blue:0
                                                alpha:1.0]
                       forState:UIControlStateNormal];
        [shareBtn setTitle:@"分享"
                  forState:UIControlStateNormal];
        [shareBtn addTarget:self
                     action:@selector(shareAction:)
           forControlEvents:UIControlEventTouchUpInside];
        
        _shareItemBar = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    }
    
    return _shareItemBar;
}

- (UIBarButtonItem *)leftBarItemBar
{
    if (!_leftBarItemBar)
    {
        UIView *leftBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        
        UIImage *goBack = [UIImage imageNamed:@"nav_back_itembar"];
        UIButton *goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        goBackBtn.frame = CGRectMake(0, 0, 40, 44);
        [goBackBtn setImage:goBack forState:UIControlStateNormal];
        [goBackBtn setAdjustsImageWhenHighlighted:NO];
        [goBackBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [goBackBtn addTarget:self
                      action:@selector(goBack:)
            forControlEvents:UIControlEventTouchUpInside];
        [leftBarView addSubview:goBackBtn];
        
        UIImage *close = [UIImage imageNamed:@"icon_close"];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(40, 0, 40, 44);
        [closeBtn setImage:close forState:UIControlStateNormal];
        [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [closeBtn setAdjustsImageWhenHighlighted:NO];
        
        [closeBtn addTarget:self
                     action:@selector(closeWeb:)
           forControlEvents:UIControlEventTouchUpInside];
        [leftBarView addSubview:closeBtn];
        
        _leftBarItemBar = [[UIBarButtonItem alloc] initWithCustomView:leftBarView];
    }
    
    return _leftBarItemBar;
}

#pragma mark private methods
- (void)shareAction:(id)sender
{
    if (!_isShare)
    {
        _isShare = YES;
        if (!_shareRequest)
        {
            _shareRequest = [[HYShareInfoReq alloc] init];
        }
        _shareRequest.type = @"4";
        [HYLoadHubView show];
        __weak typeof(self) b_self = self;
        [_shareRequest sendReuqest:^(HYShareInfoResp* res, NSError *error)
         {
             b_self.isShare = NO;
             [HYLoadHubView dismiss];
             if (res.status == 200)
             {
                 [self shareTitle:res.title msg:res.msg url:res.url imgUrl:res.imgurl];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:res.rspDesc
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
                 [alert show];
             }
         }];
    }
}

- (void)goBack:(id)sender
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
    }
    else
    {
        [self closeWeb:sender];
    }
}

- (void)closeWeb:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    [HYLoadHubView show];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [HYLoadHubView dismiss];
    _nullView.hidden = NO;
    _nullView.descInfo = @"加载失败";
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HYLoadHubView dismiss];
    _nullView.hidden = YES;
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"checkUpdate"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //检查更新
            [[PTAppStoreHelper defaultAppStoreHelper] checkNewVersionNeedAlert:YES];
        });
    };
    
    WS(weakSelf);
    
    context[@"callNative"] = ^{
        NSArray *args = [JSContext currentArguments];
        if (args.count > 0)
        {
            JSValue *param = [args objectAtIndex:0];
            NSString *jsonparam = [param toString];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf checkNative:jsonparam];
            });
        }
    };
    
    
    context[@"flaunt"] = ^
    {
        NSArray *args = [JSContext currentArguments];
        if (args.count == 4)
        {
            JSValue *flauntUrl = args[0];
            JSValue *flauntMsg = args[1];
            JSValue *flauntTitle = args[2];
            JSValue *flauntTitleUrl = args[3];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf shareTitle:[flauntTitle toString]
                                 msg:[flauntMsg toString]
                                 url:[flauntUrl toString]
                              imgUrl:[flauntTitleUrl toString]];
            });
            
        }
    };
    //
    /*
     client.flaunt(flauntUrl, flauntMsg, flauntTitle, flauntTitleUrl);
     flauntUrl   分享URL
     flauntMsg 分享文案
     flauntTitle  标题
     flauntTitleUrl 图片URL
     */
}

- (void)checkNative:(NSString *)param
{
    UIViewController *vc = [HYWebToNativeManager checkWebToNativeCall:param];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareTitle:(NSString *)title msg:(NSString *)msg url:(NSString *)url imgUrl:(NSString*)imgUrl
{
    if (!_isShare)
    {
        _isShare = YES;
        NSData *imgData = nil;
        if (imgUrl)
        {
            imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        }
        else
        {
            imgData = UIImageJPEGRepresentation([UIImage imageNamed:@"share_icon"], 1);
        }
        
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;  //使用app类型的时候分享到会话无法跳转
        [UMSocialData defaultData].extConfig.title = title;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
        
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
        [UMSocialData defaultData].extConfig.qqData.url = url;
        [UMSocialData defaultData].extConfig.qzoneData.title = title;
        [UMSocialData defaultData].extConfig.qzoneData.url = url;
        [UMSocialData defaultData].extConfig.qqData.title = title;
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:uMengAppKey
                                          shareText:[NSString stringWithFormat:@"%@%@", msg, url]
                                         shareImage:imgData
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,nil]
                                           delegate:self];
    }
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    _isShare = NO;
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    _isShare = NO;
}


@end
