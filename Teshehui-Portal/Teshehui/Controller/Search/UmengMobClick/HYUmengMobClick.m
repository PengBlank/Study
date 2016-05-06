//
//  HYUmengMobClick.m
//  Teshehui
//
//  Created by HYZB on 16/1/14.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYUmengMobClick.h"
#import "MobClick.h"

@implementation HYUmengMobClick

+ (void)homePageBannerClickedWithNumber:(int)number
{
    NSString *str = [NSString stringWithFormat:@"v440_shangcheng_shouye_dingbugundongbannertu%d_jishu", number];
    [MobClick event:str];
}

+ (void)homePageTextADClickedWithNumber:(int)number
{
    NSString *str = [NSString stringWithFormat:@"v440_shangcheng_shouye_wenziguanggao%d_jishu", number+1];
    [MobClick event:str];
}

+ (void)homePagePrimeRateClickedWithNumber:(int)number
{
    NSString *str = [NSString stringWithFormat:@"v440_shangcheng_shouye_chaoyouhui%d_jishu", number];
    [MobClick event:str];
}

// 首页-时尚街滚动
+ (void)homePageFashionStreetScrollClickedWithNumber:(int)number
{
    NSString *str = [NSString stringWithFormat:@"v440_shangcheng_shouye_shishangjiegundong%d_jishu", number];
    [MobClick event:str];
}

// 首页-时尚街
+ (void)homePageFashionStreetClickedWithNumber:(int)number
{
    NSString *str = [NSString stringWithFormat:@"v440_shangcheng_shouye_shishangjieguding%d_jishu", number];
    [MobClick event:str];
}

// 首页-生活日用
+ (void)homePageLifeClickedWithNumber:(int)number
{
    NSString *str = [NSString stringWithFormat:@"v440_shangcheng_shouye_shenghuoriyong%d_jishu", number];
    [MobClick event:str];
}

// 首页-精选分类
+ (void)homePageChoicenessClickedWithNumber:(int)number
{
    NSString *str = [NSString stringWithFormat:@"v440_shangcheng_shouye_jingpinfenlei%d_jishu", number];
    [MobClick event:str];
}

// 首页-品牌助推-更多
+ (void)homePagePublicityBrandMoreClicked
{
    NSString *str = [NSString stringWithFormat:@"v440_shangcheng_shouye_pinpaizhutui_gengduo_jishu"];
    [MobClick event:str];
}

// 首页-品牌助推
+ (void)homePagePublicityBrandClickedWithNumber:(int)number
{
    NSString *str = [NSString stringWithFormat:@"v440_shangcheng_shouye_pinpaizhutui%d_jishu", number];
    [MobClick event:str];
}

// 首页-品牌街
+ (void)homePageBrandStreetClickedWithNumber:(int)number
{
    NSString *str = [NSString stringWithFormat:@"v440_shangcheng_shouye_pinpaijie%d_jishu", number];
    [MobClick event:str];
}

// 购物车页-底部-移至收藏
+ (void)homePageBuyCarMoveToCollectionClicked
{
    NSString *str = [NSString stringWithFormat:@"v440_shangcheng_gouwucheye_dibu_yizhishoucang_jishu"];
    [MobClick event:str];
}

// 购物车页-底部-删除
+ (void)homePageBuyCarDeleteClicked
{
    NSString *str = [NSString stringWithFormat:@"v440_shangcheng_gouwucheye_dibu_shanchu_jishu"];
    [MobClick event:str];
}

// 购物车页-编辑颜色尺寸
+ (void)homePageEditColorAndSizeClicked
{
    NSString *str = [NSString stringWithFormat:@"v440_shangcheng_gouwucheye_dibu_bianjiyansechicun_jishu"];
    [MobClick event:str];
}

+ (void)mineShareEarnTicketWithType:(ShareType)type
{
    NSString *str = nil;
    switch (type) {
        case ShareTypeFriend:
            str = @"v440_wode_fenxiangzhuanxianjinquan_fenxianggeihaoyou_jishu";
            break;
        case ShareTypeQQ:
            str = @"v440_wode_fenxiangzhuanxianjinquan_fenxianggeihaoyou_qq_jishu";
            break;
        case ShareTypeWeiXin:
            str = @"v440_wode_fenxiangzhuanxianjinquan_fenxianggeihaoyou_weixinhaoyou_jishu";
            break;
        case ShareTypeFriendCircle:
            str = @"v440_wode_fenxiangzhuanxianjinquan_fenxianggeihaoyou_pengyouquan_jishu";
            break;
        case ShareTypeWeiBo:
            str = @"v440_wode_fenxiangzhuanxianjinquan_fenxianggeihaoyou_weibo_jishu";
            break;
        default:
            break;
    }
    [MobClick event:str];
}

+ (void)mineOrderWithType:(int)type
{
    NSString *str = nil;
    switch (type) {
        case OrderTypeMall:
            str = @"v440_wode_wodedingdan_shangchengdingdan_jishu";
            break;
        case OrderTypeFlight:
            str = @"v440_wode_wodedingdan_jipiaodingdan_jishu";
            break;
        case OrderTypeDiDi:
            str = @"v440_wode_wodedingdan_dididingdan_jishu";
            break;
        case OrderTypeShop:
            str = @"v440_wode_wodedingdan_shitidiandingdan_jishu";
            break;
        case OrderTypeSnooker:
            str = @"v440_wode_wodedingdan_zhuoqiudingdan_jishu";
            break;
        case OrderTypeTravel:
            str = @"v440_wode_wodedingdan_lvyoudingdan_jishu";
            break;
        case OrderTypeHotel:
            str = @"v440_wode_wodedingdan_jiudiandingdan_jishu";
            break;
        case OrderTypeMeiTuan:
            str = @"v440_wode_wodedingdan_tuangoudingdan_jishu";
            break;
        case OrderTypeFlower:
            str = @"v440_wode_wodedingdan_xianhuadingdan_jishu";
            break;
        case OrderTypeMeiWeiQiQi:
            str = @"v440_wode_wodedingdan_meiweiqiqidingdan_jishu";
            break;
        case OrderTypeCarInsurance:
            str = @"v440_wode_wodedingdan_chexiandingdan_jishu";
            break;
        default:
            break;
    }
    [MobClick event:str];
}

+ (void)mineCollectionWithType:(CollectionViewBtnType)type
{
    NSString *str = nil;
    switch (type) {
        case CollectionViewBtnTypeBottomSelectAll:
            str = @"v440_wode_wodeshoucang_dibu_quanxuan_jishu";
            break;
        case CollectionViewBtnTypeBottomDelete:
            str = @"v440_wode_wodeshoucang_dibu_shanchu_jishu";
            break;
        case CollectionViewBtnTypeDelete:
            str = @"v440_wode_wodeshoucang_shanchu_jishu";
            break;
        default:
            break;
    }
    [MobClick event:str];
}

+ (void)mineWishWithBtnType:(WishViewBtnType)type
{
    NSString *str = nil;
    switch (type) {
        case WishViewBtnTypeGoToMakeWish:
            str = @"v440_wode_wodeyuanwang_quxuyuan_jishu";
            break;
        case WishViewBtnTypeConfirm:
            str = @"v440_wode_wodeyuanwang_quxuyuan_queding_jishu";
            break;
        default:
            break;
    }
    [MobClick event:str];
}

@end
