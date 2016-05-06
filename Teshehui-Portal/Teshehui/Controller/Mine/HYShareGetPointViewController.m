//
//  HYShareGetPointViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYShareGetPointViewController.h"
//#import "HYShareInfoReq.h"
#import "UMSocial.h"
#import "HYUmengMobClick.h"
#import "HYGetShareViewReq.h"
#import "HYUserInfo.h"
#import "HYNullView.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface HYShareGetPointViewController ()
<UMSocialUIDelegate,
UIWebViewDelegate>
{
//    HYShareInfoReq *_shareRequest;
    HYGetShareViewReq *_getShareViewReq;
}
//@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
//@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (nonatomic, strong) UIWebView *webV;
@property (nonatomic, strong) HYNullView *nullView;

@property (nonatomic, assign) BOOL isShare;

@end

@implementation HYShareGetPointViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
//    [_shareRequest cancel];
    [_getShareViewReq cancel];
//    _shareRequest = nil;
    _getShareViewReq = nil;
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 64;
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView *webV = [[UIWebView alloc] initWithFrame:self.view.frame];
    webV.delegate = self;
    webV.userInteractionEnabled = YES;
    [self.view addSubview:webV];
    _webV = webV;
    
    HYNullView *nullView = [[HYNullView alloc] initWithFrame:self.view.frame];
    nullView.hidden = YES;
    _nullView = nullView;
    [self.view addSubview:nullView];
    
    [self loadData];
}

#pragma mark - privateMethod
- (void)loadData
{
    if (!_getShareViewReq)
    {
        _getShareViewReq = [[HYGetShareViewReq alloc] init];
    }
    
    _getShareViewReq.type = 1;
    [HYLoadHubView show];
    WS(weakSelf)
    [_getShareViewReq sendReuqest:^(HYGetShareViewResp *result, NSError *error) {
        
        [HYLoadHubView dismiss];
        if (result.status == 200)
        {
            if (result.shareTitle.length > 0)
            {
                weakSelf.title = result.shareTitle;
            }
            NSURL *url = [NSURL URLWithString:result.shareUrl];
            [weakSelf.webV loadRequest:[NSURLRequest requestWithURL:url]];
        }
        else
        {
            _nullView.hidden = NO;
            _nullView.descInfo = @"加载失败";
        }
        
    }];
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
    
//    NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
//    DebugNSLog(@"%@", str);
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    WS(weakSelf)
    
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
    /*
     client.flaunt(flauntUrl, flauntMsg, flauntTitle, flauntTitleUrl);
     flauntUrl   分享URL
     flauntMsg 分享文案
     flauntTitle  标题
     flauntTitleUrl 图片URL
     */
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


//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    UIImage *share = [UIImage imageNamed:@"btn_red1"];
//    share = [share resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) resizingMode:UIImageResizingModeStretch];
//    [_shareBtn setBackgroundImage:share forState:UIControlStateNormal];
//    self.title = @"分享赚现金券";
//    CGRect frame = [UIScreen mainScreen].bounds;
//    frame.size.height -= 64;
//    self.view.frame = frame;
//    
//    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, TFScalePoint(_scrollView.frame.size.height));
//    self.scrollView.frame = self.view.bounds;
//    for (UIView *view in self.scrollView.subviews)
//    {
//        view.frame = TFREctMakeWithRect(view.frame);
//        [view setNeedsDisplay];
//    }
//    
//    self.isShare = NO;
//}

/**
 *  @brief 滑动返回时，去除分享界面。by:成才
 */
//- (BOOL)canDragBack
//{
//    if (_isShare) {
//        return NO;
//    }
//    return YES;
//}

//- (IBAction)shareAction:(id)sender
//{
//    if (!_isShare)
//    {
//        _isShare = YES;
//        if (!_shareRequest)
//        {
//            _shareRequest = [[HYShareInfoReq alloc] init];
//        }
//        _shareRequest.type = @"3";
//        [HYLoadHubView show];
//        __weak typeof(self) b_self = self;
//        [_shareRequest sendReuqest:^(HYShareInfoResp* res, NSError *error)
//         {
//             [HYLoadHubView dismiss];
//             if (res.status == 200)
//             {
//                 NSData *imgdata;
//                 if (res.imgurl.length > 0)
//                 {
//                     imgdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:res.imgurl]];
//                 }
//                 else
//                 {
//                     UIImage *shareImg = [UIImage imageNamed:@"share_icon"];
//                     imgdata = UIImageJPEGRepresentation(shareImg, 1);
//                 }
//                 
//                 
//                 [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;  //使用app类型的时候分享到会话无法跳转
//                 [UMSocialData defaultData].extConfig.title = res.title;
//                 [UMSocialData defaultData].extConfig.wechatSessionData.url = res.url;
//                 [UMSocialData defaultData].extConfig.wechatTimelineData.url = res.url;
//                 
//                 [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
//                 [UMSocialData defaultData].extConfig.qqData.url = res.url;
//                 [UMSocialData defaultData].extConfig.qzoneData.title = res.title;
//                 [UMSocialData defaultData].extConfig.qzoneData.url = res.url;
//                 [UMSocialData defaultData].extConfig.qqData.title = res.title;
//                 
//                 [UMSocialSnsService presentSnsIconSheetView:self
//                                                      appKey:uMengAppKey
//                                                   shareText:[NSString stringWithFormat:@"%@%@", res.msg, res.url]
//                                                  shareImage:imgdata
//                                             shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,nil]
//                                                    delegate:self];
//             }
//             else
//             {
//                 b_self.isShare = NO;
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:res.rspDesc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                 [alert show];
//             }
//         }];
//    }
//}

//-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
//{
//    _isShare = NO;
//    if ([platformName isEqualToString:@"sina"])
//    {
//        [HYUmengMobClick mineShareEarnTicketWithType:ShareTypeWeiBo];
//    }
//    else if ([platformName isEqualToString:@"qq"])
//    {
//        [HYUmengMobClick mineShareEarnTicketWithType:ShareTypeQQ];
//    }
//    else if ([platformName isEqualToString:@"wxsession"])
//    {
//        [HYUmengMobClick mineShareEarnTicketWithType:ShareTypeWeiXin];
//    }
//    else if ([platformName isEqualToString:@"wxtimeline"])
//    {
//        [HYUmengMobClick mineShareEarnTicketWithType:ShareTypeFriendCircle];
//    }
//}
//
//-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
//{
//    _isShare = NO;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
