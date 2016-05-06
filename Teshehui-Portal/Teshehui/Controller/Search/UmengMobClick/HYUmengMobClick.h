//
//  HYUmengMobClick.h
//  Teshehui
//
//  Created by HYZB on 16/1/14.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ShareType) {
    ShareTypeFriend = 1,
    ShareTypeQQ,
    ShareTypeWeiXin,
    ShareTypeFriendCircle,
    ShareTypeWeiBo
};

typedef NS_ENUM(NSUInteger, OrderType) {
    OrderTypeMall = 1,
    OrderTypeFlight,
    OrderTypeDiDi,
    OrderTypeShop,
    OrderTypeSnooker,
    OrderTypeTravel,
    OrderTypeHotel,
    OrderTypeMeiTuan,
    OrderTypeFlower,
    OrderTypeMeiWeiQiQi,
    OrderTypeCarInsurance
};

typedef NS_ENUM(NSUInteger, CollectionViewBtnType) {
    CollectionViewBtnTypeBottomSelectAll = 1,
    CollectionViewBtnTypeBottomDelete,
    CollectionViewBtnTypeDelete
};

typedef NS_ENUM(NSUInteger, WishViewBtnType) {
    WishViewBtnTypeGoToMakeWish = 1,
    WishViewBtnTypeConfirm
};

@interface HYUmengMobClick : NSObject

// 首页-顶部滚动banner图
+ (void)homePageBannerClickedWithNumber:(int)number;

// 首页-文字广告
+ (void)homePageTextADClickedWithNumber:(int)number;

// 首页-超优汇
+ (void)homePagePrimeRateClickedWithNumber:(int)number;

// 首页-时尚街滚动
+ (void)homePageFashionStreetScrollClickedWithNumber:(int)number;

// 首页-时尚街
+ (void)homePageFashionStreetClickedWithNumber:(int)number;

// 首页-生活日用
+ (void)homePageLifeClickedWithNumber:(int)number;

// 首页-精选分类
+ (void)homePageChoicenessClickedWithNumber:(int)number;

// 首页-品牌助推-更多
+ (void)homePagePublicityBrandMoreClicked;

// 首页-品牌助推
+ (void)homePagePublicityBrandClickedWithNumber:(int)number;

// 首页-品牌街
+ (void)homePageBrandStreetClickedWithNumber:(int)number;

// 购物车页-底部-移至收藏
+ (void)homePageBuyCarMoveToCollectionClicked;

// 购物车页-底部-删除
+ (void)homePageBuyCarDeleteClicked;

// 购物车页-编辑颜色尺寸
+ (void)homePageEditColorAndSizeClicked;

// 我的-分享赚现金券
+ (void)mineShareEarnTicketWithType:(ShareType)type;

// 我的-我的订单
+ (void)mineOrderWithType:(int)type;

// 我的-我的收藏
+ (void)mineCollectionWithType:(CollectionViewBtnType)type;

// 我的-我的愿望
+ (void)mineWishWithBtnType:(WishViewBtnType)type;


@end
