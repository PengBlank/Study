//
//  HYConstant.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#ifndef HYManagmentDept_HYConstant_h
#define HYManagmentDept_HYConstant_h

#define GETOBJECTFORKEY(dictonary, key , Class) [[dictonary objectForKey:key] isKindOfClass:[Class class]] ? [dictonary objectForKey:key] : nil

#ifndef __OPTIMIZE__
#define DebugNSLog(...) NSLog(__VA_ARGS__)
#else
#define DebugNSLog(...) {}
#endif

#define SupportSystemVersion(v)  ([[[UIDevice currentDevice] systemVersion] floatValue] >= v)

#define UMengKey @"53a2490d56240b1b2a05d721"
#define ChannelId @"1"
#define LoginCacheService @"HYManagementService"

//微信
#define WXAppId @"wx4a41efaa968348df"
#define WXAppSecret @"2b812ebd5f5a3e15213d9b42873d14d5"

//qq开放平台
#define QQAppId @"101033503"
#define QQAppKey @"3de334650afa5fa4a649e89486b2f5c9"

//#define SIMULATOR
//TEST
////#define SIMULATOR
///**********     测试     **************/
//#ifdef TEST
//#define kRequestBaseURL  @"http://portal.t.teshehui.com/v2/api"
//#define kOnlinePurchaseCallBackURL  @"http://www.t.teshehui.com/page_notify_for_buy_card/paynotify/online_buy_card_notify"
//
///**********     模拟     **************/
//#elif defined  SIMULATOR
//#define kRequestBaseURL  @"http://portal.stage.teshehui.com/v2/api"
//#define kOnlinePurchaseCallBackURL  @"http://portal.t.teshehui.com/page_notify_for_buy_card/paynotify/online_buy_card_notify"

/**********     正式     **************/
//#else
#define kRequestBaseURL  @"http://portal.teshehui.com/v2/api"
#define kOnlinePurchaseCallBackURL  @"http://portal.teshehui.com/page_notify_for_buy_card/paynotify/online_buy_card_notify"
//#endif

#define NeedLogin 1

#define UIViewAutoresizingFlexibleAllMargin UIViewAutoresizingFlexibleLeftMargin| \
                                            UIViewAutoresizingFlexibleRightMargin| \
                                            UIViewAutoresizingFlexibleTopMargin| \
                                            UIViewAutoresizingFlexibleBottomMargin
#define UIViewAutoresizingFlexibleAll UIViewAutoresizingFlexibleAllMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight

#define UIViewAutoresizingHorizontalCenter UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
#define UIViewAutoresizingVerticleCenter UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin


#define kShouldRememberUserNameKey @"kShouldRememberUserNameKey"
#define kShouldRememberUserPassKey @"kShouldRememberUserPassKey"
#define kRememberedUserNameKey @"kShould"

#define kIsPhone UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

//APPSTORE 相关
#define kAppId @"886475928"
#define kUpdateAppURL @"https://itunes.apple.com/us/app/te-she-hui-ying-yun/id886475928?mt=8&uo=4"

extern NSString* const NetworkRequestErrorDomain;

#define kSchemeColor [UIColor colorWithRed:6/255.0 green:105/255.0 blue:178/255.0 alpha:1]

//umeng
/******************umeng************************/
#define kUMengShareContent @"特奢汇提供了一种全新的消费方式，汇聚了奢侈品、机票、酒店、定制旅游、高尔夫订场、鲜花全球购等等服务模块，为您提供了高品质的奢侈服务。猛戳:http://a.app.qq.com/o/simple.jsp?pkgname=com.hy.teshehui&g_f=991653"
#define kUMengShareContentPromoter @"特奢汇提供了一种全新的消费方式，汇聚了奢侈品、机票、酒店、定制旅游、高尔夫订场、鲜花全球购等等服务模块，为您提供了高品质的奢侈服务。邀请码:%@ 猛戳:http://a.app.qq.com/o/simple.jsp?pkgname=com.hy.teshehui&g_f=991653"

//信用卡des加密的key
#define kDESKey  @"tsh13528"

/**********************支付宝的部分*********************/
//合作商户ID。用签约支付宝账号登录ms.alipay.com后，在账户信息页面获取。
#define PartnerID @"2088211432741456"
//账户ID。用签约支付宝账号登录ms.alipay.com后，在账户信息页面获取。
#define SellerID  @"zhifubao@teshehui.com"

//安全校验码（MD5）密钥  用签约支付宝账号登录ms.alipay.com后，在密钥管理页面获取
#define MD5_KEY @"3zayzl1qoiaerb3idd5lo4zvps7j"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMZXenG6qXdiTMdRKTe1CJmwjNvK22CfcW6cCEW+bVYaeoVy3KzuA8DxPmnsSC6kqUr+7AW9sNpy+BDZfOoZPBrLt2lh7M9vXVIJTD9cdPU0/DTXJbunGNY3cFwGrmXYaHKTXOaxXt5+dJkpbx/lNKBN0l0IiObFDTOryo78vDpjAgMBAAECgYAysgNS9GICaLa1L1J4saX8Gns2ZphCDx7gJbObl/u8SVJNr7kl3kRJWaAZVNJyUZYP3C6ZnQ2KGF69d8mM0FxjDN1NOk3ghIA4tPCaTZQC5mG3WtO5focJrvDC6+XNRcCn15AzVt2r3LfkpYyPzIT4tXbm8FL6naQJUhsCSkQjyQJBAP9WoWa9IC7cdbS9bD3fl2EuzVMfmWWmeYOxZOKpzvDotvamNU5UqjFtJ0XhY6wZvXguIjfa7CZRj4EGK463WxcCQQDG2wqHKJyGYTUDXyOYYaxX/O//N2KLxgQnmNo/Eo4ji7Cqmt1apkZrkU3kNSbNnDhF9bX1nnu39GbV5b6SRzqVAkEA6MqsoCRxgQfR8JR6aPa+5wVqgQxgKELcqmpDFjvGxfEFTl4+X0nlWOaxVY6l9rQI/9bfr5jSkCTv9qwPbjBQxQJAHrHI2jwGjSeMC00wLWFGPP6p/PcLmw+hrIsHhRzUG+CAEJV+/XMVA52WLFeX+bzXYtUelR81cZukE/g2hlXAUQJAWoCddcD2UbaTP6rZWbLfUpQBMNZw089A8K6+IjZ9BaRgA2wh0/vfn7WPd31WfTTgk+XbsHk1RlAfqN5E7XKqKw=="

//支付宝公钥，用签约支付宝账号登录ms.alipay.com后获取。
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"
/**********************支付宝的部分*********************/

typedef enum _ProductPayType
{
    Pay_Mall = 0,
    Pay_Flight,
    Pay_Flower,
    Pay_Hotel,
    Pay_BuyCard,
    Pay_Upgrad, //升级
    Pay_Renewal //续保,
}ProductPayType;

#endif
