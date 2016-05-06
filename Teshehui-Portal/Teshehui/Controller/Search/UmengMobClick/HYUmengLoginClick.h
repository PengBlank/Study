//
//  HYUmengLoginClick.h
//  Teshehui
//
//  Created by 成才 向 on 16/1/15.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UmLoginOption)
{
    UmLoginStart,
    UmLoginQQ,
    UmLoginWeixin,
    UmLoginMore
};

typedef struct
{
    UmLoginOption option;
}UmLogin;

//typedef NS_ENUM(NSUInteger, UmLogin) <#new#>;


@interface HYUmengLoginClick : NSObject

+ (void)clickStart;
+ (void)clickQQ;
+ (void)clickWeixin;
+ (void)clickMore;
+ (void)clickMoreAccount;
+ (void)clickMoreAccountLogin;
+ (void)clickMoreAccountForget;
+ (void)clickMoreActivate;
+ (void)clickMoreActivateNext;
+ (void)clickMoreActivateNextNext;
+ (void)clickMoreActivateNextNextActivate;
+ (void)clickMoreActivateNextNextActivateClear;
+ (void)clickMoreActivateNextNextInsuare;
+ (void)clickMoreActivateNextNextInsuareActivate;
+ (void)clickMoreBuycard;
+ (void)clickMoreBuycardNext;
+ (void)clickMoreBuycardNextBuy;
+ (void)clickMoreBuycardNextBuyClear;
+ (void)clickMoreBuycardNextInsuares;
+ (void)clickMoreBuycardNextInsuaresBuy;
+ (void)clickMoreBuycardNextInsuaresBuyClose;
+ (void)clickMoreCancel;

@end
