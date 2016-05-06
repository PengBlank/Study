//
//  TYAnalyticsManager.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//


typedef NS_ENUM(NSInteger, O2OSceneButtonType)
{
    
    DestineBtn              = 1, //预定场景订单按钮
    MainListPageShareBtn    = 2, //首页分享按钮
    DetailpageShareBtn      = 3, //详情页分享按钮
    DetailpagePhoneBtn      = 4, //详情页电话按钮
    ScenePayBtn             = 5, //场景支付按钮
    OtherBtn                = 99 //其他按钮
};

typedef NS_ENUM(NSInteger, O2OSceneShareType)
{
    
    WeChat              = 1,
    TimeLine            = 2,
    QQ                  = 3,
    SinaWeibo           = 4
};

typedef NS_ENUM(NSInteger, O2OScenePageType)
{
    
    FoodPackageDetailPage               = 1,
    EntertainmentPackageDetailPage      = 2,
    PayResultPage                       = 3,
    otherPage                           = 4
};

#import <Foundation/Foundation.h>
#import "TYAnalyseScenePageReq.h"
#import "TYAnalyseSceneBtnReq.h"
#import "TYAnalyseSceneShareBtnReq.h"

@interface TYAnalyticsManager : NSObject
+ (instancetype)sharedManager;

- (void)sendAnalyseForSceneDetailPage:(O2OScenePageType)pageType
                               packId:(NSString *)packId
                           pageIdentifier:(NSString *)pageIdentifier
                         toPageIdentifier:(NSString *)toPageIdentifier;

- (void)sendAnalyseForSceneBtnClick:(O2OSceneButtonType)buttonType;

- (void)sendAnalyseForSceneShareType:(O2OSceneShareType)shareType;



@end
