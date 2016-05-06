//
//  HYAnalyticsManager.h
//  Teshehui
//
//  Created by HYZB on 15/11/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HYVisitObjectReq.h"
#import "HYFeedbackItemInfoReq.h"
#import "HYCommentItemReq.h"
#import "HYPurchaseItemReq.h"
#import "HYSearchKeywordReq.h"
#import "HYVisitAnalyticsParams.h"
#import "HYMallHomeBoard.h"
#import "HYMallChannelBoard.h"
#import "HYMallGoodsDetail.h"
#import "HYProductListSummary.h"
#import "HYMallCategoryInfo.h"
#import "HYMallChannelGoods.h"
#import "HYChannelPageResponse.h"

@interface HYAnalyticsManager : NSObject

+ (instancetype)sharedManager;

- (void)searchEventWith:(NSString *)keyword result:(BOOL)result;
- (void)purchaseEventWith:(NSArray <HYOrderItem *> *)orderItems
            withOrderCode:(NSString *)oc
                    stgid:(NSString *)stgid;
- (void)commentEventWith:(NSArray <HYCommentItem *> *)comment withOrderCode:(NSString *)oc;
- (void)feedbackEventWith:(NSArray <HYFeedbackItemInfo *> *)feedback
                     type:(NSString *)type
                    stgid:(NSString *)stgid;

/**
 *  @brief 热度统计
 *
 *  @param b    board_code
 *  @param b2   banner_code
 *  @param t    banner_type
 *  @param from 1首页 2频道页
 */
- (void)hotStaticsWithB:(NSString *)b b2:(NSString *)b2 t:(NSString *)t from:(NSInteger)from;


+ (void)sendHomeVisitReq;
+ (void)sendWebVisitReqWithURL:(NSString *)url;

/**
 *  @brief 列表页访问
 */

/**
 *  @brief 列表页
 *
 *  @param type       类型
 *  @param keyword    对象标识，分类编码、品牌编码
 *  @param boardcode  版块编码
 *  @param bannercode 栏位编码
 *  @param fromPage   来源，1首页 2频道页 3 Wap
 */
+ (void)sendProductListVisitWithType:(HYListPageFromType)type
                             keyWord:(NSString *)keyword
                           boardCode:(NSString *)boardcode
                          bannerCode:(NSString *)bannercode
                          bannerType:(NSString*)bt
                            fromPage:(NSInteger)fromPage
                        additionInfo:(NSDictionary *)addition
                               stgid:(NSString *)stgid;

+ (void)sendProductListVisitWithBannerItem:(HYMallHomeItem *)item
                                     board:(HYMallHomeBoard *)board
                                  fromPage:(NSInteger)fromPage
                                     stgid:(NSString *)stgid;


+ (void)sendProductListVisitFromChannelWithItem:(HYMallChannelItem *)item
                                          board:(HYMallChannelBoard *)board
                                          stgid:(NSString *)stgid;

/**
 *  @brief 详情统计流程
 *
 *  @return
 */

/// 详情统计，从首页开始
- (void)beginProductDetailFromHomeWithItem:(HYMallHomeItem *)item
                                     board:(HYMallHomeBoard *)board;

/// 详情统计，从频道页开始
- (void)beginProductDetailFromChannelWithItem:(HYMallChannelItem *)item
                                        board:(HYMallChannelBoard *)board;
- (void)beginDetailFromChannelWithProduct:(HYMallChannelGoods*)goods withCate:(HYChannelCategory*)cate;

/// 详情统计，从搜索开始
- (void)beginDetailVisitFromSearch:(HYProductListSummary *)summary withKey:(NSString *)searchKey;

/// 详情统计，从列表页开始
- (void)beginDetailVisitFromCate:(HYMallCategoryInfo*)cate;

/// 详情统计，从WAP开始
- (void)beginDetailVisitFromWAP:(NSString *)pt refId:(NSString *)refId;

/// 详情统计第二步，在列表页继续统计
- (void)continueVisitAtListWithSummary:(HYProductListSummary *)summary;

/// 详情统计，最终发送
- (void)sendProductDetailVisit:(HYMallGoodsDetail *)detail stgId:(NSString *)stgId;

/**
 *  @brief app启动统计
 */
/**
 *  @brief app启动统计
 *
 *  @param lat      经度
 *  @param lon      纬度
 *  @param openType 启动类型 1启动，2后台切前台
 */
+ (void)sendAppOpenWithOpenType:(NSInteger)openType;

/**
 *  @brief 1.12	用户注册统计
 */
/**
 *  @brief 1.12	用户注册统计
 *
 *  @param openType reg_type	注册类型	Number
 枚举类型：
 101：APP-快速注册
 102：APP-实体卡激活
 103：APP-在线购卡注册
 201：WAP-抽奖页注册
 202：WAP-第三方合作商页注册
 203：WAP-O2O商户页注册
 204：WAP-现金券红包页注册
 205：WAP-分享赚现金券页注册
 206：WAP-现金券账单分享页注册
 300：其他方式注册
 */
+ (void)sendUserRegisterType:(NSInteger)type;

/**
 *  @brief 1.13	用户登录统计（UserLogin）
 */
/**
 *  @brief 1.13	用户登录统计（UserLogin）
 *
 *  @param lg_type	登录类型（login_type）
 Number
 枚举类型：
 101：APP-快速登录
 102：APP-密码登录
 111：APP-第三方登录之微信
 112：APP-第三方登录之QQ
 201：WAP登录
 300：其他方式登录

 */
+ (void)sendUserLoginType:(NSInteger)type;
@end
