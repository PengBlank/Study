//
//  ShareButtonView.m
//  Teshehui
//
//  Created by macmini5 on 15/12/28.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "ShareButtonView.h"
#import "UIColor+hexColor.h"
#import "Masonry.h"
#import "DefineConfig.h"
#import <TencentOpenAPI/QQApi.h>
#import "WXApi.h"
#import "HYUserInfo.h"
#import "O2OShareInfoRequest.h"
#import "METoast.h"
#import "NSString+Common.h"
#import "UMSocial.h"

typedef NS_ENUM(NSInteger, ShareType)
{
    WeiXin   = 1,
    QQ  = 2,
    WeiBo = 3,
    WXMomnet
    
};

@interface ShareButtonView ()
{
    BOOL    _isPaySuccess;
}

@property (nonatomic, copy  ) NSString    *merId;
@property (nonatomic, copy  ) NSString    *savePrice; // 省了多少钱钱

@property (nonatomic, strong) UIViewController *vc;

@end

@implementation ShareButtonView

- (id)initWithViewController:(UIViewController *)viewController MerId:(NSString *)merId AndSavePrice:(NSString *)savePrice AndBackgroundColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        _vc         = viewController;
        _merId      = merId;
        _savePrice  = savePrice;
        _isPaySuccess = NO;
        
        [self createUI:color];
    }
    return self;
}

// 这个方法是给购票成功后后调用的 因为UI距离不一样
- (id)initWithPaySuccessViewController:(UIViewController *)viewController MerId:(NSString *)merId AndSavePrice:(NSString *)savePrice AndBackgroundColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        _vc         = viewController;
        _merId      = merId;
        _savePrice  = savePrice;
        _isPaySuccess = YES;
        
        [self createUI:color];
    }
    return self;
}

- (void)createUI:(UIColor *)color
{
    self.backgroundColor = color;
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexColor:@"e5e5e5" alpha:1];
    [self addSubview:lineView];
    
    UILabel *desLabel = [[UILabel alloc] init];
    [desLabel setText:@"    去分享 获优惠    "];
    [desLabel setBackgroundColor:color];
    [desLabel setTextColor:[UIColor colorWithHexColor:@"606060" alpha:1]];
    [desLabel setFont:[UIFont systemFontOfSize:11]];
    [self addSubview:desLabel];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_isPaySuccess) {
            make.top.mas_equalTo(lineView.superview.mas_top).offset(40);
        }else
        {
            make.top.mas_equalTo(lineView.superview.mas_top).offset(15);
        }
        make.left.mas_equalTo(lineView.superview.mas_left).offset(kPaddingLeftWidth);
        make.width.mas_equalTo(kScreen_Width - 30);
        make.height.mas_equalTo(0.5);
    }];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lineView.mas_centerY);
        make.centerX.mas_equalTo(desLabel.superview.mas_centerX);
    }];
    
    BOOL qqTure = [QQApi isQQInstalled];
    BOOL wxTure = [WXApi isWXAppInstalled];
    
    if (qqTure && wxTure) {
        
        CGFloat width   = kScreen_Width / 4;
        NSArray *imageArray = [[NSArray alloc] initWithObjects:@"wechatfriend",@"qqzone",@"weibo",@"moments", nil];
        for (int i = 0; i < 4 ; i++) {
            
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [shareBtn setTag:i + 1];
            [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [shareBtn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:shareBtn];
            
            [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(width * i);
                make.top.mas_equalTo(lineView.mas_bottom).offset(20);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(55);
            }];
        }
        
    }else if (qqTure && !wxTure){
        
        CGFloat width   = kScreen_Width / 2;
        CGFloat height  = kScreen_Width / 4;
        NSArray *imageArray = [[NSArray alloc] initWithObjects:@"qqzone",@"weibo",nil];
        for (int i = 0; i < 2 ; i++) {
            
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if (i == 0) {
                [shareBtn setTag:QQ];
            }else{
                [shareBtn setTag:WeiBo];
            }
            
            
            [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [shareBtn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:shareBtn];
            
            CGFloat value = width-height-20;
            if (i==0) {
                [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(width * i +value);
                    make.top.mas_equalTo(desLabel.mas_bottom).offset(kPaddingLeftWidth -15);
                    make.width.mas_equalTo(width -value);
                    make.height.mas_equalTo(height);
                }];
            }else
            {
                [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(width * i);
                    make.top.mas_equalTo(desLabel.mas_bottom).offset(kPaddingLeftWidth -15);
                    make.width.mas_equalTo(width -value);
                    make.height.mas_equalTo(height);
                }];
            }
        }
        
        
    }else if(!qqTure && wxTure){
        
        CGFloat width   = kScreen_Width / 3;
        CGFloat height  = kScreen_Width / 4;
        NSArray *imageArray = [[NSArray alloc] initWithObjects:@"wechatfriend",@"weibo",@"moments", nil];
        for (int i = 0; i < 3 ; i++) {
            
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if (i == 0) {
                [shareBtn setTag:WeiXin];
            }else if(i == 1){
                [shareBtn setTag:WeiBo];
            }else{
                [shareBtn setTag:WXMomnet];
            }
            
            
            [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [shareBtn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:shareBtn];
            
            [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(width * i);
                make.top.mas_equalTo(desLabel.mas_bottom).offset(kPaddingLeftWidth -15);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);
            }];
        }
    }else{
        
        //        CGFloat width   = kScreen_Width / 1;
        CGFloat height  = kScreen_Width / 4;
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [shareBtn setTag:WeiBo];
        
        [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [shareBtn setImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareBtn];
        
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(desLabel.mas_bottom).offset(kPaddingLeftWidth -15);
            make.width.mas_equalTo(height);
            make.height.mas_equalTo(height);
        }];
    }
}

- (void)shareBtnClick:(UIButton *)btn{
    
    [HYLoadHubView show];
    
    [_shareInfoRequest cancel];
    _shareInfoRequest = nil;
    
    _shareInfoRequest = [[O2OShareInfoRequest alloc] init];
    _shareInfoRequest.interfaceURL  = [NSString stringWithFormat:@"%@/common/GetExperience",ORDER_API_URL];
    _shareInfoRequest.interfaceType = DotNET2;
    _shareInfoRequest.postType      = JSON;
    _shareInfoRequest.httpMethod    = @"POST";
    
    _shareInfoRequest.uId = [[HYUserInfo getUserInfo] userId];
    _shareInfoRequest.type = @"5";
    _shareInfoRequest.merchantId = self.merId;
    _shareInfoRequest.price = self.savePrice;
    
    WS(weakSelf);
    [_shareInfoRequest sendReuqest:^(id result, NSError *error) {
        
        
        if(result){
            NSDictionary *objDic = [result jsonDic];
            
            int code = [objDic[@"code"] intValue];
            if (code == 0) { //状态值为0 代表请求成功
                NSDictionary *tmpDic = objDic[@"data"];
                
                NSString *msg = [tmpDic objectForKey:@"msg"];
                NSString *url = [tmpDic objectForKey:@"url"];
                
                if(msg.length != 0 && url.length != 0)
                    [weakSelf shareContentWithType:btn.tag shareMsg:msg shareUrl:url];
                
            }else{
                NSString *msg = [objDic objectForKey:@"msg"];
                [METoast toastWithMessage:[msg isNil] ? @"获取分享信息失败" : msg];
            }
            
        }else{
            [METoast toastWithMessage:@"无法连接服务器"];
        }
        
        [HYLoadHubView dismiss];
    }];
}

- (void)shareContentWithType:(NSInteger)shareType shareMsg:(NSString *)msg shareUrl:(NSString *)url
{
    switch (shareType) {
        case WeiXin:
        {
            
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;  //使用app类型的时候分享到会话无法跳转
            [UMSocialData defaultData].extConfig.title = @"特奢汇";//msg;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
            [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop ];
            
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession]
                                                                content:msg
                                                                  image:[UIImage imageNamed:@"share_icon"]
                                                               location:nil
                                                            urlResource:nil
                                                    presentedController:self.vc
                                                             completion:^(UMSocialResponseEntity *response){
                                                        
                                                        if (response.responseCode == UMSResponseCodeSuccess) {
                                                            [METoast toastWithMessage:@"分享成功"];
                                                        }else{
                                                            [METoast toastWithMessage:@"分享失败"];
                                                        }
                                                        
                                                    }];
        }
            break;
        case QQ:
        {
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
            
            [UMSocialData defaultData].extConfig.qzoneData.title = @"特奢汇";//msg;
            [UMSocialData defaultData].extConfig.qzoneData.url = url;
            [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop ];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone]
                                                                content:msg
                                                                  image:[UIImage imageNamed:@"share_icon"]
                                                               location:nil urlResource: nil
                                                    presentedController:self.vc
                                                             completion:^(UMSocialResponseEntity *response){
                                                        
                                                        if (response.responseCode == UMSResponseCodeSuccess) {
                                                            [METoast toastWithMessage:@"分享成功"];
                                                        }else{
                                                            [METoast toastWithMessage:@"分享失败"];
                                                        }
                                                        
                                                    }];
        }
            break;
        case WeiBo:
        {
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina]
                                                                content:[NSString stringWithFormat:@"%@%@",msg,url]
                                                                  image:[UIImage imageNamed:@"share_icon"]
                                                               location:nil
                                                            urlResource:nil
                                                    presentedController:self.vc
                                                             completion:^(UMSocialResponseEntity *shareResponse){
                                                                 if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                                                                     [METoast toastWithMessage:@"分享成功"];
                                                                 }else{
                                                                     [METoast toastWithMessage:@"分享失败"];
                                                                 }
                                                             }];
        }
            break;
        case WXMomnet:
        {
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;  //使用app类型的时候分享到会话无法跳转
            [UMSocialData defaultData].extConfig.title = msg;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
            [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop ];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline]
                                                                content:@"特奢汇"
                                                                  image:[UIImage imageNamed:@"share_icon"]
                                                               location:nil urlResource: nil
                                                    presentedController:self.vc completion:^(UMSocialResponseEntity *response){
                                                        
                                                        if (response.responseCode == UMSResponseCodeSuccess) {
                                                            [METoast toastWithMessage:@"分享成功"];
                                                        }else{
                                                            [METoast toastWithMessage:@"分享失败"];
                                                        }
                                                        
                                                    }];
        }
            break;
            
        default:
            break;
    }

}

@end
