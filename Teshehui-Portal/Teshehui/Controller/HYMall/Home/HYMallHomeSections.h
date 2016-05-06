//
//  HYMallHomeSections.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#ifndef HYMallHomeSections_h
#define HYMallHomeSections_h

//typedef NS_ENUM(NSUInteger, HYMallHomeSections)
//{
//    HYMallHomeSectionHeader,
//    HYMallHomeSectionYouHui,
//    HYMallHomeSectionFashion,   //时尚
//    HYMallHomeSectionLife,      //生活日用
//    HYMallHomeSectionCategory,  //精选分类
//    HYMallHomeSectionBrandBoost,
//    HYMallHomeSectionBrandStreet,
//    HYMallHomeSectionRecommend  //推荐
//};


typedef enum _HYHomeBoardType
{
    MallHomeUnknown = -1,
    MallHomeAds  = 1,              //banner
    MallHomeRecm        = 2,       //力荐商品
    MallHomeActive      = 3,       //超优惠
    MallHomeStore       = 4,       //每周好店
    MallHomeHot         = 6,       //热品推荐
    MallHomeNew         = 5,       //每周新品
    MallHomeProductType = 7,       //精选分类
    MallHomeMore        = 8,       //为您推荐
    MallHomeEspCheap    = 9,       //特实惠
    MallHomeTextAds     = 10,       //文字广告
    MallHomeFashionScroll   = 11,   //时尚滚动
    MallHomeFashion     = 12,       //时间固定
    MallHomeLife        = 13,       //生活日用
    MallHomeBrand       = 14,       //品牌街
    MallHomeBrandAds    = 15,       //品牌广告
    MallHomeLaunchAds   = 90,  //启动图
    MallHomeHomeAds     = 91,     //首页广告
    MallHomeInterestTag = 16,    //兴趣
    MallHomeShoppingPlace = 17,     //卖场
    MallHomeImageAds    = 18        //新增的广告图
}HYHomeBoardType;

typedef NS_ENUM(NSInteger, HYMallChannelBoardType) {
    ChannelBoardUnknown = -1,
    ChannelBoardBanner = 01,    //顶部
    ChannelBoardHot,            //热销排行
    ChannelBoardNew,            //新品
    ChannelBoardTimeLimit,      //限时降价
    ChannelBoardTheme,          //主题
    ChannelBoardSpecial,        //专题
    ChannelBoardBrand,           //品牌
    ChannelBoardGoods
};

/*
 栏目类型 01:单品;02:活动;03:店铺列表;04:分类列表;05:品牌列表;06:搜索;07:web;08:每周新品;09:热品推荐;10:梭哈;11频道
 */
typedef enum _HYHomeItemType
{
    MallHomeItemUnknown = -1,
    MallHomeItemGoods  = 01,
    MallHomeItemActive ,
    MallHomeItemStore,
    MallHomeItemCategory,
    MallHomeItemBrand,
    MallHomeItemSearch,
    MallHomeItemWeb,
    MallHomeItemNew,
    MallHomeItemHot,
    MallHomeItemShowHands,
    MallHomeItemChannel,
    MallHomeItemSeckill,
    MallHomeItemEarnTicket
}HYHomeItemType;

/*
 01	商城
 02	机票
 03	酒店
 04	鲜花
 05	团购
 06	阳光保险
 07	O2O商户
 21	高铁管家
 22	滴滴打车
 30	驴妈妈
 41	美味77
 50	充值
 60	卖座网
 */
typedef NS_ENUM(NSInteger, HYGetMoneyType)  //获取现金券的业务类型
{
    GetMoneyForMall               = 1,
    GetMoneyForFlight             = 2,
    GetMoneyForHotel              = 3,
    GetMoneyForFollower           = 4,
    GetMoneyForGroup              = 5,
    GetMoneyForCarInsurance       = 6,
    GetMoneyForO2O                = 7,
    GetMoneyForTicket             = 21,
    GetMoneyForDidi               = 22,
    GetMoneyForLumm               = 30,
    GetMoneyForMeiweiqiqi         = 41,
    GetMoneyForCharge             = 50,
    GetMoneyForMaizuo             = 60,
};

/**
 *  @brief 自定义标签栏位类型
 */
typedef NS_ENUM(NSInteger, HYInterestTagType) {
    HYInterestTagChannel    =   1,
    HYInterestTagCategory,
    HYInterestTagShake,
    HYInterestTagGetMoneyType,  //赚现金券的类型
    HYInterestTagSwipe
};

#endif /* HYMallHomeSections_h */
