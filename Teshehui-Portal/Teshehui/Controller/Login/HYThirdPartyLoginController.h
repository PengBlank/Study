//
//  HYThirdPartyLoginController.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>


extern NSString *const HYThirdPartyQQ;
extern NSString *const HYThirdPartyWeixin;
typedef NSString* HYThirdPartyLoginType;

@protocol HYThirdPartyLoginControllerDelegate <NSObject>

@optional
- (void)didGetThirdLoginToken:(NSString *)token openId:(NSString *)openId loginType:(HYThirdPartyLoginType)type;
- (void)thirdLoginFailWithMessage:(NSString *)msg loginType:(HYThirdPartyLoginType)type;

//
@optional
- (void)didGetMobileCode:(NSString *)code;

@end

@interface HYThirdPartyLoginController : NSObject<TencentSessionDelegate>
{
    TencentOAuth *_tencentAuth;
}
- (void)loginWithTencent;
- (void)loginWithWeixin;


@property (nonatomic, weak) id<HYThirdPartyLoginControllerDelegate> delegate;

//gej mobile validate code
//- (void)getCodeWithMobilePhone:(NSString *)phone;

@end
