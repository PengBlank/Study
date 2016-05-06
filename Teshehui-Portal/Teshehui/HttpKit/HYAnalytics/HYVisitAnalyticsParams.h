//
//  HYVisitAnalyticsParams.h
//  Teshehui
//
//  Created by 成才 向 on 16/1/13.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

/// 商品列表页用户访问行为
#import "HYAnalyticsBaseParams.h"

typedef NS_ENUM(NSInteger, HYListPageFromType) {
    HYListPageFromCate,
    HYListPageFromBrand,
    HYListPageFromChannel,
    HYListPageFromActivity,
    HYListPageFromStore,
    HYListPageFromSearch
};

@interface HYVisitAnalyticsParams : HYAnalyticsBaseParams

@property (nonatomic, copy) NSString *obj_code;
@property (nonatomic, copy) NSString *obj_type;
@property (nonatomic, copy) NSString *vt;
@property (nonatomic, copy) NSString *bbxt;
@property (nonatomic, copy) NSString *pt;
@property (nonatomic, copy) NSString *category_code;
@property (nonatomic, copy) NSString *brand_code;
@property (nonatomic, copy) NSString *tsh_price;
@property (nonatomic, copy) NSString *ref_page_id;
@property (nonatomic, copy) NSString *stg_id;


+ (instancetype)homeVisitParam;
+ (instancetype)webpageVisitParamWithURL:(NSString *)url;
+ (instancetype)productListPageVisitParam;


/// 分类页
////

/**
 *  @brief 分类页行为
 *
 *  @param cateCode   分类标识、编码等
 *  @param boardCode  版块
 *  @param bannerCode 栏位
 *  @param fromPage   来源 1首页，2频道页 3WAP
 *
 *  @return
 */
+ (instancetype)listPageVisitParamWithType:(HYListPageFromType)type
                              withListCode:(NSString *)cateCode
                             withBoardCode:(NSString *)boardCode
                                bannerCode:(NSString *)bannerCode
                                bannerType:(NSString *)bt
                                  fromPage:(NSInteger)fromPage
                              additionInfo:(NSDictionary *)addition
                                     stgid:(NSString *)stgid;

@end
