//
//  DefineConfig.h
//
//
//  Created by xkun on 15/6/10.
//  Copyright (c) 2015年 xkun. All rights reserved.
//

//快速显示提示框
#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#define KEY_WINDOW       [[UIApplication sharedApplication] keyWindow]
#define kScreen_Bounds   [[UIScreen mainScreen] bounds]
#define kScreen_Width    [[UIScreen mainScreen] bounds].size.width
#define kScreen_Height   [[UIScreen mainScreen] bounds].size.height

#define kDevice_Is_iPhone5      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define ScaleHEIGHT(height)     (height * (kScreen_Width / 375.0))
#define ScaleWIDTH(width)       (width * (kScreen_Width / 375.0))

#define IMAGE(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define BASEURL                     @"http://life-api.o2o.teshehui.com"  //商家模块  使用场景：商家最开始的api访问
#define ORDER_API_URL               @"http://oc-api.o2o.teshehui.com"   //订单模块  使用场景：旧版订单模块api访问
#define ORDER_API_URL_V3            @"http://oc-api.o2o.teshehui.com/v3" //订单模块V3版 使用场景：桌球主动付款、商家主动付款
#define TRAVEL_API_URL              @"http://y.teshehui.com" //旅游模块 使用场景：旅游模块api访问
#define BILLIARDS_API_URL           @"http://zq-api.o2o.teshehui.com/v2"  //桌球模块
#define ORANGE_API_URL              @"http://orange-api.o2o.teshehui.com"  //聚宝橙相关

//#define TYTest
//#ifndef TYTest
//#define BILLIARDS_API_URL                     @"http://192.168.0.216:8011"  //桌球测试
//#else
//#define BILLIARDS_API_URL                     @"http://zq-api.o2o.teshehui.com"  //桌球正式
//#endif

#define CenterToken                 @"1f3517e7f8c994bb7b546655afa55628" //中心token
#define V3Token                     @"06D71BA68B66B1BFAC1B230CCEE7D74E" //V3token
#define TravelToken                 @"C86F49B4083006F2CFF8FA2718391F81" //旅游token
#define BilliardsToken              @"A00F713F91DF43AA8D25B37A065D74BD"  //桌球token
#define OrangeToken                 @"5AC42921E47B253A87A544A363A55223" //聚宝橙token


#define kNotificationWithBilliardsCloseTable                @"kNotificationWithBilliardsCloseTable"          //桌球收台之后刷新数据
#define kNotificationWithBilliardsOrderListChanged          @"kNotificationWithBilliardsOrderListChanged"   //桌球付款之后刷新列表
#define kNotificationWithOrderListCommentChanged            @"kNotificationWithOrderListCommentChanged"  // 发现订单评论刷新数据
#define kNotificationWithTravelOrderListCommentChanged      @"kNotificationWithTravelOrderListCommentChanged"  // 旅游订单评论刷新数据
#define kNotificationWithBilliardsOrderCommentChanged       @"kNotificationWithTravelOrderListCommentChanged"  // 桌球订单评论刷新数据

#define kNetworkNotReachability ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0)  //无网

/**
 *  判断系统版本
 */
#define IOS7_OR_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)

#define IOS7            ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7)
#define IOS8            ([[[UIDevice currentDevice] systemVersion] integerValue] >= 8)
#define kNavBarHeight   (IOS7 ? 64 : 44)
#define kStatusHeight   (IOS7 ? 20 : 0)

#define  kUITabBarHeight                49
#define  kPaddingLeftWidth              15.0
#define  kDefaultPageIndexStart         1
#define  kDefaultPageSize               20
#define  MaxTag                         999999999

#define RecentlyCityKey                    @"RecentlyCityKey"

extern CGFloat g_fitFloat(NSArray *plist);

extern CGFloat g_fitNSInteger(NSArray *plist);
/**
 *  适配5、6、6P~尺寸
 *
 *  @param plist 参数列表，字体大小依次是多少例如(@[@10,@20,@30])、(@[@10,@20)、(@[@10])
 *
 *  @return 返回对应字体大小,(@[@10,@20,@30])5返回10号字体，6返回20号字体，6P返回30号字体; (@[@10,@20) 5返回10号字体，6和6P返回20号字体; (@[@10])5、6、6P都返回10号字体。
 */
extern UIFont *g_fitSystemFontSize(NSArray *plist);

typedef NS_ENUM(NSInteger, O2OPayType)
{
    TravelPay    = 1,
    BusinessPay  = 2,
    BilliardsPay = 3,
    Catering     = 4

};

typedef NS_ENUM(NSInteger, O2OCommentType)
{
    
    BusinessComment     = 1,
    TravelComment       = 2,
    BilliardsComment    = 3
    
};







