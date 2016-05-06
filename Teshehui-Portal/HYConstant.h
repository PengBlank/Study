//
//  HYConstant.h
//  Teshehui
//
//  Created by HYZB on 15/9/27.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GETOBJECTFORKEY(dictonary, key , Class) [[dictonary objectForKey:key] isKindOfClass:[Class class]] ? [dictonary objectForKey:key] : nil

#define PTRelease(_object) {[_object release], _object = nil;}

#ifndef __OPTIMIZE__
#define DebugNSLog(...) NSLog(__VA_ARGS__)
#else
#define DebugNSLog(...) {}
#endif

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64

#define FORMAT_Integer @"%ld"  //long
#define FORMAT_Float @"%lf"  //double

#else

#define FORMAT_Integer @"%d"  //int
#define FORMAT_Float @"%f"   //float

#endif


///弱引用宏
#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;

//分发模式
//ADHOC APPSTORE
//#define ADHOC
//---------------------企业证书分发
#ifdef ADHOC

//百度地图
#define BDMapAccessToken @"qKHCSXobONuzKgkfrdFYmBuF"

#else
//---------------------APP STORE分发

//百度地图
#define BDMapAccessToken @"FFSa9Y4UeTc1axLnsY66Yzae"

#endif

#define CheckIOS7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define SupportSystemVersion(v)  ([[[UIDevice currentDevice] systemVersion] floatValue] >= v)
#define kCommentAppURL (CheckIOS7 ? @"itms-apps://itunes.apple.com/app/id833071976" : @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=833071976")

/**
 * 用户的消费方式
 */

typedef NS_ENUM(NSInteger, HYSpendingPatterns)
{
    Undefind_SP = 1,  //未指定消费方式
    Personal_SP,  //个人消费
    Enterprise_SP  //企业消费
};

typedef NS_ENUM(NSInteger, BusinessType)
{
    AirTickets = 1,       /* 机票 */
    Hotel,              /* 酒店 */
    Flower,             /* 鲜花 */
    QRScanInfo,          /* 二维码 */
    CarInsurance,        /*阳光车险*/
    Meituan,
    DidiTaxi,
    MeiWeiQiQi,
    PhoneCharge,
    MovieTicket
};

typedef NS_ENUM(NSInteger, SnsType)   //社交平台类型
{
    Weixin,
    Sina,
    TencentQQ,
    QZone,
    TencentWeibo
};

typedef NS_ENUM(NSInteger, ProductPayType)
{
    Pay_Mall = 1,
    Pay_Flight,
    Pay_Flower,
    Pay_Hotel,
    Pay_BuyCard,
    Pay_Upgrad, //升级
    Pay_Renewal,  //续保,
    Pay_O2O_QRScan,  //O2O扫二维码支付,
    Pay_DidiTaxi,
    pay_phoneCharge = 50
};

typedef NS_ENUM(NSUInteger,HYPolicyTypeForChoosing)
{
    PingAn,
    RenShou,
    TaiPingYang
};

/// 男男女女
///
typedef NS_ENUM(NSUInteger, HYUserInfoSex)
{
    /// 未知
    HYSexUnknown,
    ///男
    HYSexMale,
    /// 女
    HYSexFemale,
    /// 人妖
    HYSexRenYao
};

extern HYUserInfoSex hyGetSexFromJavaSex(NSInteger javaSex);
extern NSString *hySexMaleStringFromSex(HYUserInfoSex sex);
extern HYUserInfoSex hyGetSexFromString(NSString *sexString);
extern NSString *hyGetJavaSexStringFromSex(HYUserInfoSex sex);

UIKIT_EXTERN NSString *const kXresUid; //后台统计事件的接口固定id
UIKIT_EXTERN NSString *const kCurrentCity; //当前城市
UIKIT_EXTERN NSString *const kLastStartCity;//机票起飞城市
UIKIT_EXTERN NSString *const kLastComeCity;    //航班到达城市
UIKIT_EXTERN NSString *const kIsLogin;
UIKIT_EXTERN NSString *const kUserInfo;
UIKIT_EXTERN NSString *const kPhoneNumber;
UIKIT_EXTERN NSString *const kToken;
UIKIT_EXTERN NSString *const kHotelDefCity;   //酒店的默认城市
UIKIT_EXTERN NSString *const kHotelCheckInDate;   //酒店的入住时间
UIKIT_EXTERN NSString *const kHotelCheckOutDate;   //酒店的离开时间
UIKIT_EXTERN NSString *const kUserLocation;   //用户的详细信息
UIKIT_EXTERN NSString *const kUserAddress;   //用户的详细信息
UIKIT_EXTERN NSString *const kHotelCityInfoUpdate;   //酒店的城市列表的更新
UIKIT_EXTERN NSString *const kIsShowRedpacket; //是否显示过红包
UIKIT_EXTERN NSString *const kRedpacketCount;
UIKIT_EXTERN NSString *const kShoppingCarHasNew;
UIKIT_EXTERN NSString *const InputHistoryForEnd; //滴滴打车 终点输入
UIKIT_EXTERN NSString *const InputHistoryForStart;//起点输入
UIKIT_EXTERN NSString *const kAdsImage; ////广告缓存图片的key
UIKIT_EXTERN NSString *const kAdsShowMaxNum;//广告一天显示最大的次数
UIKIT_EXTERN NSString *const kAdsHasShownTimes;//广告一天已经显示的次数
UIKIT_EXTERN NSString *const kAdsDateOfSetting;//广告每天第一次缓存的时间
UIKIT_EXTERN NSString *const kStartAdsItem;//启动广告的跳转项目
UIKIT_EXTERN NSString *const kBannerCodeArray;//首页广告bannerCode的缓存
/** 摇一摇签到提醒时间 */
UIKIT_EXTERN NSString *const kShakeSignInWakeupTime;
/** 摇一摇签到提醒开关状态 */
UIKIT_EXTERN NSString *const kShakeSignInSwitchStatus;
//海淘用户信息
UIKIT_EXTERN NSString *const kAbroadBuyConsignee;
UIKIT_EXTERN NSString *const kAbroadBuyIdentification;

UIKIT_EXTERN CGFloat const kTabBarHeight;
UIKIT_EXTERN NSString *const kHomeDataUpdateTime;
UIKIT_EXTERN NSString *const kStoreDataUpdateTime;
UIKIT_EXTERN NSString *const kSettingInterestLabel;  //设置兴趣标签
UIKIT_EXTERN NSString *const kBrandDataUpdateTime;
UIKIT_EXTERN NSString *const kProductDataUpdateTime;
UIKIT_EXTERN NSString *const kLotteryCode;   //抽奖的信息
UIKIT_EXTERN NSString *const kLotteryTypeCode;   //抽奖的信息
UIKIT_EXTERN NSString *const kLotteryVersion;   //抽奖的信息
UIKIT_EXTERN NSString *const ImageSizeBig;
UIKIT_EXTERN NSString *const ImageSizeMid;
UIKIT_EXTERN NSString *const ImageSizeSmall;
UIKIT_EXTERN NSString *const BusinessType_Mall;
UIKIT_EXTERN NSString *const BusinessType_Flight;
UIKIT_EXTERN NSString *const BusinessType_Hotel;
UIKIT_EXTERN NSString *const BusinessType_Flower;
UIKIT_EXTERN NSString *const BusinessType_BuyCard;
UIKIT_EXTERN NSString *const BusinessType_Upgrad;
UIKIT_EXTERN NSString *const BusinessType_Renewal;
UIKIT_EXTERN NSString *const BusinessType_O2O_QRScan;
UIKIT_EXTERN NSString *const BusinessType_DidiTaxi;
UIKIT_EXTERN NSString *const BusinessType_TRAIN;  //高铁
UIKIT_EXTERN NSString *const BusinessType_DidiTaxi;  //滴滴
UIKIT_EXTERN NSString *const BusinessType_Travel;  //旅游
UIKIT_EXTERN NSString *const BusinessType_Catering; //餐饮
UIKIT_EXTERN NSString *const BusinessType_MeiQiqi;  //美味七七
UIKIT_EXTERN NSString *const BusinessType_Meituan;
UIKIT_EXTERN NSString *const BusinessType_Yangguang;
UIKIT_EXTERN NSString *const BusinessType_PhoneCharge;
UIKIT_EXTERN NSString *const BusinessType_MovieTicket;
UIKIT_EXTERN NSString *const BusinessType_Guahao;  //挂号

UIKIT_EXTERN NSString *const uMengAppKey;
UIKIT_EXTERN NSString *const kUMengShareContent;

/*--------------Interface URL链接地址列表---------------*/
UIKIT_EXTERN NSString *const kPayResultRedirectUrl;  //携程wap支付完成重定向回调
UIKIT_EXTERN NSString *const kMallRequestBaseURL;
UIKIT_EXTERN NSString *const kFlowerRequestBaseURL;
UIKIT_EXTERN NSString *const kHotelRequestBaseURL;
UIKIT_EXTERN NSString *const kFlightRequestBaseURL;
UIKIT_EXTERN NSString *const kJavaRequestBaseURL;
UIKIT_EXTERN NSString *const kShowHandBaseURL;
/*--------------Interface URL链接地址列表---------------*/

/*
 银联支付必填项;
 接入模式设定,两个值: @"00":代表接入生产环境(正式版 本需要); @"01":代表接入开发测试环境(测 试版本需要);
 */
UIKIT_EXTERN NSString *const kUPPayMode;
UIKIT_EXTERN NSString *const kCustomerQQForMall;
UIKIT_EXTERN NSString *const kCustomerQQForFilght;
UIKIT_EXTERN NSString *const kCustomerQQForFlower;
UIKIT_EXTERN NSString *const kCustomerQQForHotel;
UIKIT_EXTERN NSString *const kCustomerQQForGroup;
UIKIT_EXTERN NSString *const kFeedbackQQ;
UIKIT_EXTERN NSString *const kUpdateAppURL;
UIKIT_EXTERN NSString *const kAppStoreDownLink;
UIKIT_EXTERN NSString *const AppId;


//百度云推送
UIKIT_EXTERN NSString *const BPushAPIKey;
UIKIT_EXTERN NSString *const BPushSecretKey;

//微信
UIKIT_EXTERN NSString *const WXAppId;
UIKIT_EXTERN NSString *const WXAppSecret;

//qq开放平台
UIKIT_EXTERN NSString *const QQAppId;
UIKIT_EXTERN NSString *const QQAppKey;

//渠道号
UIKIT_EXTERN NSString *const kChannelId;

//推送的缓存数据
UIKIT_EXTERN NSString *const kRemoteNotificationUserInfo;
UIKIT_EXTERN NSString *const kIsSupportCarInsurance;
UIKIT_EXTERN NSString *const kIsReviewed;

//信用卡des加密的key
UIKIT_EXTERN NSString *const kProtalAPIKey;

//信用卡des加密的key
UIKIT_EXTERN NSString *const kDESKey;

/**********************支付宝的部分*********************/
//合作商户ID。用签约支付宝账号登录ms.alipay.com后，在账户信息页面获取。
UIKIT_EXTERN NSString *const PartnerID;
//账户ID。用签约支付宝账号登录ms.alipay.com后，在账户信息页面获取。
UIKIT_EXTERN NSString *const SellerID;
//安全校验码（MD5）密钥  用签约支付宝账号登录ms.alipay.com后，在密钥管理页面获取
UIKIT_EXTERN NSString *const MD5_KEY;
//商户私钥，自助生成
UIKIT_EXTERN NSString *const PartnerPrivKey;
//支付宝公钥，用签约支付宝账号登录ms.alipay.com后获取。
UIKIT_EXTERN NSString *const AlipayPubKey;
/**********************支付宝的部分*********************/


UIKIT_EXTERN NSString *const kHomeRouteNotification;
