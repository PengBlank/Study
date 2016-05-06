//
//  HYAnalyticsManager.m
//  Teshehui
//
//  Created by HYZB on 15/11/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAnalyticsManager.h"
#import "HYVisitAnalyticsParams.h"
#import "NSString+Addition.h"
#import "HYMallChannelGoods.h"
#import "HYHotStaticsAnalyticsParams.h"
#import "HYAppOpenAnalyticsParams.h"
#import "HYUserRegisterAnalyticsParams.h"
#import "HYUserLoginAnalyticsParams.h"

static HYVisitAnalyticsParams *__pDetailVisitParams;

@interface HYAnalyticsManager ()

@property (nonatomic, strong) HYVisitAnalyticsParams *detailVisitParams;
@property (nonatomic, strong) NSString *b;
@property (nonatomic, strong) NSString *b2;
@property (nonatomic, strong) NSString *x;
@property (nonatomic, strong) NSString *t;

@end

@implementation HYAnalyticsManager

+ (instancetype)sharedManager
{
    static HYAnalyticsManager *__sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedManager = [[HYAnalyticsManager alloc] init];
    });
    return __sharedManager;
}

- (void)searchEventWith:(NSString *)keyword result:(BOOL)result
{
    if (keyword)
    {
        HYSearchKeywordReq *req = [[HYSearchKeywordReq alloc] init];
        req.key_words = keyword;
        req.result_ind = [NSString stringWithFormat:@"%d", result];
        [req sendReuqest:nil];
    }
}

- (void)purchaseEventWith:(NSArray <HYOrderItem *> *)orderItems
            withOrderCode:(NSString *)oc
                    stgid:(NSString *)stgid
{
    if ([orderItems count])
    {
        HYPurchaseItemReq *req = [[HYPurchaseItemReq alloc] init];
        req.order_detail = orderItems;
        req.oc = oc;
        req.stg_id = stgid;
        [req sendReuqest:nil];
    }
}

- (void)commentEventWith:(NSArray <HYCommentItem *> *)comment withOrderCode:(NSString *)oc
{
    if ([comment count])
    {
        HYCommentItemReq *req = [[HYCommentItemReq alloc] init];
        req.ct_detail = comment;
        req.oc = oc;
        [req sendReuqest:nil];
    }
}

- (void)feedbackEventWith:(NSArray <HYFeedbackItemInfo *> *)feedback
                     type:(NSString *)type
                    stgid:(NSString *)stgid
{
    if ([feedback count])
    {
        HYFeedbackItemInfoReq *req = [[HYFeedbackItemInfoReq alloc] init];
        req.fb_type = type;
        req.stg_id = stgid;
        req.fb_detail = feedback;
        [req sendReuqest:nil];
    }
}

- (void)hotStaticsWithB:(NSString *)b b2:(NSString *)b2 t:(NSString *)t from:(NSInteger)from
{
    HYAnalyticsBaseReq *req = [[HYAnalyticsBaseReq alloc] init];
    req.interfaceURL = @"http://xres.teshehui.com/xclk/hs";
    HYHotStaticsAnalyticsParams *params = [[HYHotStaticsAnalyticsParams alloc] init];
    params.board_code = b;
    params.banner_code = b2;
    params.banner_type = t;
    params.hot_type = [NSString stringWithFormat:@"%ld", from];
    req.requestParams = params;
    [req sendReuqest:nil];
}

+ (void)sendHomeVisitReq
{
    HYAnalyticsBaseReq *req = [[HYAnalyticsBaseReq alloc] init];
    req.requestParams = [HYVisitAnalyticsParams homeVisitParam];
    [req sendReuqest:nil];
}

+ (void)sendWebVisitReqWithURL:(NSString *)url
{
    HYAnalyticsBaseReq *req = [[HYAnalyticsBaseReq alloc] init];
    req.requestParams = [HYVisitAnalyticsParams webpageVisitParamWithURL:url];
    [req sendReuqest:nil];
}

+ (void)sendProductListVisitWithType:(HYListPageFromType)type
                             keyWord:(NSString *)keyword
                           boardCode:(NSString *)boardcode
                          bannerCode:(NSString *)bannercode
                          bannerType:(NSString*)bt
                            fromPage:(NSInteger)fromPage
                        additionInfo:(NSDictionary *)addition
                               stgid:(NSString *)stgid
{
    HYAnalyticsBaseReq *req = [[HYAnalyticsBaseReq alloc] init];
    req.requestParams = [HYVisitAnalyticsParams listPageVisitParamWithType:type
                                                              withListCode:keyword
                                                             withBoardCode:boardcode
                                                                bannerCode:bannercode
                                                                bannerType:nil
                                                                  fromPage:fromPage
                                                              additionInfo:addition
                                                                     stgid:stgid];
    [req sendReuqest:nil];
}

+ (void)sendProductListVisitWithBannerItem:(HYMallHomeItem *)item
                                     board:(HYMallHomeBoard *)board
                                  fromPage:(NSInteger)fromPage
                                     stgid:(NSString *)stgid
{
    HYListPageFromType type = 0;
    NSString *keyCode = nil;
    NSMutableDictionary *params = [[item.url urlParamToDic] mutableCopy];
    
    NSString *expanded = [params objectForKey:@"expandedRequest"];
    if (expanded)
    {
        NSDictionary *exparams = [NSJSONSerialization JSONObjectWithData:[expanded dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if (exparams) {
            [params addEntriesFromDictionary:exparams];
        }
    }
    if (item.itemType == MallHomeItemStore) {
        type = HYListPageFromStore;
        keyCode = [params objectForKey:@"storeId"];
    }
    else if (item.itemType == MallHomeItemSearch) {
        type = HYListPageFromSearch;
        keyCode = [params objectForKey:@"keyword"];
    }
    else if (item.itemType == MallHomeItemBrand) {
        type = HYListPageFromBrand;
        NSArray *brandIds = [params objectForKey:@"brandId"];
        if (brandIds.count > 0) {
            keyCode = [brandIds objectAtIndex:0];
        }
    }
    else if (item.itemType == MallHomeItemCategory) {
        type = HYListPageFromCate;
        keyCode = [params objectForKey:@"categoryId"];
    }
    else if (item.itemType == MallHomeItemChannel) {
        type = HYListPageFromChannel;
        keyCode = item.channelCode;
    }
    else if (item.itemType == MallHomeItemActive) {
        type = HYListPageFromActivity;
        keyCode = [params objectForKey:@"activityCode"];
    }
    
    NSInteger pagefrom = stgid.length ? 3 : 1;
    HYAnalyticsBaseReq *req = [[HYAnalyticsBaseReq alloc] init];
    req.requestParams = [HYVisitAnalyticsParams listPageVisitParamWithType:type
                                                              withListCode:keyCode
                                                             withBoardCode:board.boardCode
                                                                bannerCode:item.bannerCode
                                                                bannerType:item.type
                                                                  fromPage:pagefrom
                                                              additionInfo:nil
                                                                     stgid:stgid];
    [req sendReuqest:nil];
}

+ (void)sendProductListVisitFromChannelWithItem:(HYMallChannelItem *)item
                                          board:(HYMallChannelBoard *)board
                                          stgid:(NSString *)stgid
{
    HYListPageFromType type = 0;
    NSString *keyCode = nil;
    NSMutableDictionary *params = [[item.url urlParamToDic] mutableCopy];
    
    NSString *expanded = [params objectForKey:@"expandedRequest"];
    if (expanded)
    {
        NSDictionary *exparams = [NSJSONSerialization JSONObjectWithData:[expanded dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if (exparams) {
            [params addEntriesFromDictionary:exparams];
        }
    }
    if (item.itemType == MallHomeItemStore) {
        type = HYListPageFromStore;
        keyCode = [params objectForKey:@"storeId"];
    }
    else if (item.itemType == MallHomeItemSearch) {
        type = HYListPageFromSearch;
        keyCode = [params objectForKey:@"keyword"];
    }
    else if (item.itemType == MallHomeItemBrand) {
        type = HYListPageFromBrand;
        NSArray *brandIds = [params objectForKey:@"brandId"];
        if (brandIds.count > 0) {
            keyCode = [brandIds objectAtIndex:0];
        }
    }
    else if (item.itemType == MallHomeItemCategory) {
        type = HYListPageFromCate;
        keyCode = [params objectForKey:@"categoryId"];
    }
    else if (item.itemType == MallHomeItemActive) {
        type = HYListPageFromActivity;
        keyCode = [params objectForKey:@"activityCode"];
    }
    
    NSInteger pagefrom = stgid.length ? 3 : 2;
    HYAnalyticsBaseReq *req = [[HYAnalyticsBaseReq alloc] init];
    req.requestParams = [HYVisitAnalyticsParams listPageVisitParamWithType:type
                                                              withListCode:keyCode
                                                             withBoardCode:board.channelBoardCode
                                                                bannerCode:item.bannerCode
                                                                  bannerType:item.bannerType
                                                                  fromPage:pagefrom
                                                              additionInfo:nil
                                                                     stgid:stgid];
    [req sendReuqest:nil];
}

- (void)beginProductDetailFromHomeWithItem:(HYMallHomeItem *)item board:(HYMallHomeBoard *)board
{
    [self reset];
    _detailVisitParams = [[HYVisitAnalyticsParams alloc] init];
    _detailVisitParams.obj_type = @"2";
    _detailVisitParams.tsh_price = item.price;
    self.b = board.boardCode;
    self.b2 = item.bannerCode;
    self.t = item.type;
    _detailVisitParams.pt = @"1";
    _detailVisitParams.vt = @"3";
    
    ///  x
    //  获取url params，categoryid等数据都存在里面呢
    NSMutableDictionary *params = [[item.url urlParamToDic] mutableCopy];
    NSString *expanded = [params objectForKey:@"expandedRequest"];
    if (expanded)
    {
        NSDictionary *exparams = [NSJSONSerialization JSONObjectWithData:[expanded dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if (exparams) {
            [params addEntriesFromDictionary:exparams];
        }
    }
    if (item.itemType == MallHomeItemGoods) {
        self.x = [params objectForKey:@"productId"];
    }
    else if (item.itemType == MallHomeItemCategory) {
        self.x = [params objectForKey:@"categoryId"];
    }
    else if (item.itemType == MallHomeItemBrand) {
        NSArray *brandIds = [params objectForKey:@"brandId"];
        if (brandIds.count > 0) {
            self.x = [brandIds objectAtIndex:0];
        }
    }
    else if (item.itemType == MallHomeItemActive) {
        self.x = [params objectForKey:@"activityCode"];
    }
    else if (item.itemType == MallHomeItemStore) {
        self.x = [params objectForKey:@"storeId"];
    }
    else if (item.itemType == MallHomeItemSearch) {
        self.x = nil;
        _detailVisitParams.ref_page_id = [params objectForKey:@"keyword"];
    }
}

- (void)beginProductDetailFromChannelWithItem:(HYMallChannelItem *)item board:(HYMallChannelBoard *)board
{
    [self reset];
    _detailVisitParams = [[HYVisitAnalyticsParams alloc] init];
    _detailVisitParams.obj_type = @"2";
    _detailVisitParams.tsh_price = item.tshPrice;
    self.b = board.channelBoardCode;
    self.b2 = item.bannerCode;
    self.t = item.bannerType;
    _detailVisitParams.pt = @"2";
    _detailVisitParams.vt = @"3";
    
    ///  x
    //  获取url params，categoryid等数据都存在里面呢
    NSMutableDictionary *params = [[item.url urlParamToDic] mutableCopy];
    NSString *expanded = [params objectForKey:@"expandedRequest"];
    if (expanded)
    {
        NSDictionary *exparams = [NSJSONSerialization JSONObjectWithData:[expanded dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if (exparams) {
            [params addEntriesFromDictionary:exparams];
        }
    }
    if (item.itemType == MallHomeItemGoods) {
        self.x = [params objectForKey:@"productId"];
    }
    else if (item.itemType == MallHomeItemCategory) {
        self.x = [params objectForKey:@"categoryId"];
    }
    else if (item.itemType == MallHomeItemBrand) {
        NSArray *brandIds = [params objectForKey:@"brandId"];
        if (brandIds.count > 0) {
            self.x = [brandIds objectAtIndex:0];
        }
    }
    else if (item.itemType == MallHomeItemActive) {
        self.x = [params objectForKey:@"activityCode"];
    }
    else if (item.itemType == MallHomeItemStore) {
        self.x = [params objectForKey:@"storeId"];
    }
    else if (item.itemType == MallHomeItemSearch) {
        self.x = nil;
        _detailVisitParams.ref_page_id = [params objectForKey:@"keyword"];
    }
}

- (void)beginDetailFromChannelWithProduct:(HYMallChannelGoods*)goods withCate:(HYChannelCategory*)cate
{
    [self reset];
    _detailVisitParams = [[HYVisitAnalyticsParams alloc] init];
    _detailVisitParams.obj_type = @"2";
    _detailVisitParams.tsh_price = goods.tshPrice;
    _detailVisitParams.pt = @"2";
    _detailVisitParams.vt = @"3";
    _detailVisitParams.ref_page_id = cate.categoryCode;
    
}

- (void)beginDetailVisitFromSearch:(HYProductListSummary *)summary withKey:(NSString *)searchKey
{
    [self reset];
    _detailVisitParams = [[HYVisitAnalyticsParams alloc] init];
    _detailVisitParams.obj_type = @"2";
    _detailVisitParams.tsh_price = [NSString stringWithFormat:@"%@", summary.price];
    _detailVisitParams.pt = @"4";
    _detailVisitParams.vt = @"3";
    _detailVisitParams.ref_page_id = searchKey;
}

- (void)beginDetailVisitFromCate:(HYMallCategoryInfo*)cate
{
    [self reset];
    _detailVisitParams = [[HYVisitAnalyticsParams alloc] init];
    _detailVisitParams.obj_type = @"2";
    _detailVisitParams.pt = @"3";
    _detailVisitParams.vt = @"3";
    _detailVisitParams.ref_page_id = cate.cate_id;
}

- (void)beginDetailVisitFromWAP:(NSString *)pt refId:(NSString *)refId;
{
    [self reset];
    _detailVisitParams = [[HYVisitAnalyticsParams alloc] init];
    _detailVisitParams.obj_type = @"2";
    _detailVisitParams.pt = pt;
    _detailVisitParams.vt = @"3";
    _detailVisitParams.ref_page_id = refId;
}

- (void)continueVisitAtListWithSummary:(HYProductListSummary *)summary
{
    if (_detailVisitParams)
    {
        _detailVisitParams.tsh_price = [NSString stringWithFormat:@"%@", summary.price];
    }
}

- (void)sendProductDetailVisit:(HYMallGoodsDetail *)detail stgId:(NSString *)stgId
{
    if (_detailVisitParams)
    {
        _detailVisitParams.obj_code = detail.productId;
        _detailVisitParams.category_code = detail.categoryId;
        _detailVisitParams.brand_code = detail.brandId;
        _detailVisitParams.tsh_price = detail.currentsSUK.marketPrice;
        
        //ref_page_id
        if ([_detailVisitParams.pt isEqualToString:@"3"])
        {
            _detailVisitParams.ref_page_id = detail.categoryId;
        }
        
        //web的统计的字段
        if (stgId)
        {
            _detailVisitParams.stg_id = stgId;
            _detailVisitParams.channel_id = @"1003";  //1003  WAP
        }
        else
        {
            _detailVisitParams.stg_id = nil;
            _detailVisitParams.channel_id = @"1002";
        }
        
        if (self.b && self.x && self.b2 && self.t) {
            _detailVisitParams.bbxt = [NSString stringWithFormat:@"%@|%@|%@|%@", self.b, self.b2, self.x, self.t];
        }
        HYAnalyticsBaseReq *req = [[HYAnalyticsBaseReq alloc] init];
        req.requestParams = _detailVisitParams;
        [req sendReuqest:nil];
    }
}

- (void)reset
{
    _b = nil;
    _b2 = nil;
    _x = nil;
    _t = nil;
    _detailVisitParams = nil;
}

+(void)sendAppOpenWithOpenType:(NSInteger)openType
{
    HYAppOpenAnalyticsParams *params = [[HYAppOpenAnalyticsParams alloc] init];
    params.open_type = (unsigned int)openType;
    HYAnalyticsBaseReq *req = [[HYAnalyticsBaseReq alloc] init];
    req.interfaceURL = @"http://xres.teshehui.com/xclk/ao";
    req.requestParams = params;
    [req sendReuqest:nil];
}

+ (void)sendUserRegisterType:(NSInteger)type
{
    HYUserRegisterAnalyticsParams *params = [[HYUserRegisterAnalyticsParams alloc] init];
    params.reg_type = type;
    HYAnalyticsBaseReq *req = [[HYAnalyticsBaseReq alloc] init];
    req.interfaceURL = @"http://xres.teshehui.com/xclk/uReg";
    req.requestParams = params;
    [req sendReuqest:nil];
}

+ (void)sendUserLoginType:(NSInteger)type
{
    HYUserLoginAnalyticsParams *params = [[HYUserLoginAnalyticsParams alloc] init];
    params.lg_type = type;
    HYAnalyticsBaseReq *req = [[HYAnalyticsBaseReq alloc] init];
    req.interfaceURL = @"http://xres.teshehui.com/xclk/uLg";
    req.requestParams = params;
    [req sendReuqest:nil];
}

@end
