//
//  HYConstant.m
//  Teshehui
//
//  Created by HYZB on 15/9/27.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYConstant.h"

NSString *const kXresUid = @"XresUid1";
NSString *const kCurrentCity = @"CurrentCity";
NSString *const kLastStartCity = @"LastStartCity";
NSString *const kLastComeCity = @"LastComeCity";
NSString *const kIsLogin = @"isLogin";
NSString *const kUserInfo = @"UserInfo";
NSString *const kPhoneNumber = @"PhoneNumber";
NSString *const kToken = @"Token";
NSString *const kHotelDefCity = @"kHotelDefCity";
NSString *const kHotelCheckInDate = @"HotelCheckInDate";
NSString *const kHotelCheckOutDate = @"HotelCheckOutDate";
NSString *const kUserLocation = @"kUserLocation";
NSString *const kUserAddress = @"kUserAddress";
NSString *const kHotelCityInfoUpdate = @"kHotelCityInfoUpdate";
NSString *const kIsShowRedpacket = @"kIsShowRedpacket";
NSString *const kRedpacketCount = @"kRedpacketCount";
NSString *const kShoppingCarHasNew =  @"kShoppingCarHasNew";

//广告缓存图片的key
NSString *const kAdsImage =  @"AdsImage";
NSString *const kBannerCodeArray =  @"kBannerCodeArray";
NSString *const kStartAdsItem =  @"kStartAdsItem";
NSString *const kAdsShowMaxNum =  @"kAdsShowNum";
NSString *const kAdsHasShownTimes = @"kAdsHasShownTimes";
NSString *const kAdsDateOfSetting = @"kAdsDateOfSetting";

//用户偏好设置
NSString *const InputHistoryForStart = @"inputHistoryForStart";
NSString *const InputHistoryForEnd = @"inputHistoryForEnd";
/** 摇一摇签到提醒 */
NSString *const kShakeSignInWakeupTime = @"kShakeSignInWakeupTime";
NSString *const kShakeSignInSwitchStatus = @"kShakeSignInSwitchStatus";
//海淘用户信息
NSString *const kAbroadBuyConsignee = @"kAbroadBuyConsignee";
NSString *const kAbroadBuyIdentification = @"kAbroadBuyIdentification";

//umeng
/******************umeng************************/
NSString *const uMengAppKey= @"531922e556240bec2a093fa7";
NSString *const kUMengShareContent= @"特奢汇提供了一种全新的消费方式，汇聚了奢侈品、机票、酒店、定制旅游、高尔夫订场、鲜花全球购等等服务模块，为您提供了高品质的奢侈服务。猛戳:http://a.app.qq.com/o/simple.jsp?pkgname=com.hy.teshehui&g_f=991653";

/*--------------Interface URL链接地址列表---------------*/
NSString *const kPayResultRedirectUrl = @"portal.air.teshehui.com/v3/Order/CtripPayResult" ;//携程wap支付完成重定向回调
NSString *const kMallRequestBaseURL = @"http://portal.teshehui.com/v2";
NSString *const kFlowerRequestBaseURL = @"http://portal.flower.teshehui.com/v2";
NSString *const kHotelRequestBaseURL = @"http://portal.hotel.teshehui.com/v2";
NSString *const kFlightRequestBaseURL = @"http://portal.air.teshehui.com/v3";
NSString *const kJavaRequestBaseURL = @"http://portal-web.teshehui.com";
NSString *const kShowHandBaseURL = @"http://sh.teshehui.com";
/*--------------Interface URL链接地址列表---------------*/


CGFloat const kTabBarHeight = 48.0f;
NSString *const kHomeDataUpdateTime= @"HomeDataUpdateTime";
NSString *const kStoreDataUpdateTime= @"StoreDataUpdateTime";
NSString *const kSettingInterestLabel= @"SettingInterestLabel";
NSString *const kBrandDataUpdateTime= @"BrandDataUpdateTime";
NSString *const kProductDataUpdateTime= @"ProductDataUpdateTime";

NSString *const kLotteryCode= @"showHandMay";  //抽奖的信息
NSString *const kLotteryTypeCode= @"showHand"; //抽奖的信息
NSString *const kLotteryVersion= @"1.0.0";  //抽奖的信息

NSString *const ImageSizeBig = @"800X800.jpg";
NSString *const ImageSizeMid = @"300X300.jpg";
NSString *const ImageSizeSmall= @"160X160.jpg";

NSString *const BusinessType_Mall= @"01";
NSString *const BusinessType_Flight= @"02";
NSString *const BusinessType_Hotel= @"03";
NSString *const BusinessType_Flower= @"04";
NSString *const BusinessType_BuyCard= @"07";
NSString *const BusinessType_Upgrad= @"07";
NSString *const BusinessType_Renewal= @"07";
NSString *const BusinessType_O2O_QRScan= @"08";
NSString *const BusinessType_TRAIN= @"21";  //高铁
NSString *const BusinessType_DidiTaxi= @"22";  //滴滴
NSString *const BusinessType_Travel= @"30";  //旅游
NSString *const BusinessType_Catering = @"40"; //餐饮
NSString *const BusinessType_MeiQiqi = @"41";  //美味七七
NSString *const BusinessType_Meituan = @"05";
NSString *const BusinessType_Yangguang = @"06";
NSString *const BusinessType_PhoneCharge = @"50";
NSString *const BusinessType_MovieTicket = @"60";
NSString *const BusinessType_Guahao = @"61";  //挂号

NSString *const kUPPayMode = @"00";
NSString *const kCustomerQQForMall  = @"2853516885";  //商城
NSString *const kCustomerQQForFilght  = @"2853516887";  //机票
NSString *const kCustomerQQForFlower  = @"2853516889"; // 鲜花
NSString *const kCustomerQQForHotel  = @"2853516890"; // 酒店
NSString *const kCustomerQQForGroup  = @"2853516891";  //车险订单
NSString *const kFeedbackQQ  = @"2853516901"; // 反馈
NSString *const kUpdateAppURL = @"https://itunes.apple.com/us/app/te-she-hui/id833071976?mt=8&uo=4"; //AppStore Link
NSString *const kAppStoreDownLink = @"https://itunes.apple.com/us/app/te-she-hui/id833071976?ls=1&mt=8";
NSString *const AppId  = @"833071976";

//百度云推送
NSString *const BPushAPIKey = @"bvo1ra4i6YfYxCqDFMpPraEi";
NSString *const BPushSecretKey  = @"Goc4UDSZAPafHeGyPi11y51Bw2OvWlvW";

//微信
NSString *const WXAppId = @"wx4a41efaa968348df";
NSString *const WXAppSecret = @"2b812ebd5f5a3e15213d9b42873d14d5";

//qq开放平台
NSString *const QQAppId = @"101033503";
NSString *const QQAppKey = @"3de334650afa5fa4a649e89486b2f5c9";

//渠道号
NSString *const kChannelId  = @"1";

//推送的缓存数据
NSString *const kRemoteNotificationUserInfo = @"RemoteNotificationUserInfo";
NSString *const kIsSupportCarInsurance = @"IsSupportCarInsurance";
NSString *const kIsReviewed = @"reviewed";

//信用卡des加密的key
NSString *const kProtalAPIKey  = @"40287ae447680a6b0147680a6b580000";
//信用卡des加密的key
NSString *const kDESKey  = @"tsh13528";

/**********************支付宝的部分*********************/
//合作商户ID。用签约支付宝账号登录ms.alipay.com后，在账户信息页面获取。
NSString *const PartnerID = @"2088211432741456";
//账户ID。用签约支付宝账号登录ms.alipay.com后，在账户信息页面获取。
NSString *const SellerID  = @"zhifubao@teshehui.com";
//安全校验码（MD5）密钥  用签约支付宝账号登录ms.alipay.com后，在密钥管理页面获取
NSString *const MD5_KEY = @"3zayzl1qoiaerb3idd5lo4zvps7j";
//商户私钥，自助生成
NSString *const PartnerPrivKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMZXenG6qXdiTMdRKTe1CJmwjNvK22CfcW6cCEW+bVYaeoVy3KzuA8DxPmnsSC6kqUr+7AW9sNpy+BDZfOoZPBrLt2lh7M9vXVIJTD9cdPU0/DTXJbunGNY3cFwGrmXYaHKTXOaxXt5+dJkpbx/lNKBN0l0IiObFDTOryo78vDpjAgMBAAECgYAysgNS9GICaLa1L1J4saX8Gns2ZphCDx7gJbObl/u8SVJNr7kl3kRJWaAZVNJyUZYP3C6ZnQ2KGF69d8mM0FxjDN1NOk3ghIA4tPCaTZQC5mG3WtO5focJrvDC6+XNRcCn15AzVt2r3LfkpYyPzIT4tXbm8FL6naQJUhsCSkQjyQJBAP9WoWa9IC7cdbS9bD3fl2EuzVMfmWWmeYOxZOKpzvDotvamNU5UqjFtJ0XhY6wZvXguIjfa7CZRj4EGK463WxcCQQDG2wqHKJyGYTUDXyOYYaxX/O//N2KLxgQnmNo/Eo4ji7Cqmt1apkZrkU3kNSbNnDhF9bX1nnu39GbV5b6SRzqVAkEA6MqsoCRxgQfR8JR6aPa+5wVqgQxgKELcqmpDFjvGxfEFTl4+X0nlWOaxVY6l9rQI/9bfr5jSkCTv9qwPbjBQxQJAHrHI2jwGjSeMC00wLWFGPP6p/PcLmw+hrIsHhRzUG+CAEJV+/XMVA52WLFeX+bzXYtUelR81cZukE/g2hlXAUQJAWoCddcD2UbaTP6rZWbLfUpQBMNZw089A8K6+IjZ9BaRgA2wh0/vfn7WPd31WfTTgk+XbsHk1RlAfqN5E7XKqKw==";

//支付宝公钥，用签约支付宝账号登录ms.alipay.com后获取。
NSString *const AlipayPubKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRA FljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQE B/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5Ksi NG9zpgmLCUYuLkxpLQIDAQAB";
/**********************支付宝的部分*********************/


NSString *const kHomeRouteNotification = @"kHomeRouteNotification";

/// 性别
HYUserInfoSex hyGetSexFromJavaSex(NSInteger javaSex)
{
    if (javaSex == 1) {
        return HYSexMale;
    }
    else if (javaSex == 0) {
        return HYSexFemale;
    }
    else {
        return HYSexUnknown;
    }
}

NSString *hySexMaleStringFromSex(HYUserInfoSex sex)
{
    if (sex == HYSexMale) {
        return @"M";
    }
    else if (sex == HYSexFemale) {
        return @"F";
    }
    else {
        return nil;
    }
}

HYUserInfoSex hyGetSexFromString(NSString *sexString)
{
    if ([sexString isEqualToString:@"M"]) {
        return HYSexMale;
    }
    else if ([sexString isEqualToString:@"F"]) {
        return HYSexFemale;
    }
    else {
        return HYSexUnknown;
    }
}

 NSString *hyGetJavaSexStringFromSex(HYUserInfoSex sex)
{
    if (sex == HYSexMale) {
        return @"1";
    }
    else if (sex == HYSexFemale) {
        return @"0";
    }
    else {
        return @"2";
    }
}
