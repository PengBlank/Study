//
//  HYUmengLoginClick.m
//  Teshehui
//
//  Created by 成才 向 on 16/1/15.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYUmengLoginClick.h"
#import "MobClick.h"

NSString *const UmVersionStr = @"v440";
NSString *const UmLoginStr = @"zhucedenglu";
NSString *const UmMoreStr = @"gengduo";
NSString *const UmActivateStr = @"yiyouhuiyuankajihuo";
NSString *const UmAccountStr = @"zhanghaodenglu";
NSString *const UmBuycard = @"meiyouhuiyuankagouka";
NSString *const UmJishuStr = @"jishu";

@implementation HYUmengLoginClick

+ (void)clickStart
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_kaishi_%@", UmVersionStr, UmLoginStr, UmJishuStr]];
}

+ (void)clickQQ
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_qqdenglu_%@", UmVersionStr, UmLoginStr, UmJishuStr]];
}
+ (void)clickWeixin
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_weixindenglu_%@", UmVersionStr, UmLoginStr, UmJishuStr]];
}
+ (void)clickMore
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_gengduo_%@", UmVersionStr, UmLoginStr, UmJishuStr]];
}
+ (void)clickMoreAccount
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_zhanghaodenglu_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreAccountLogin
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_zhanghaodenglu_denglu_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreAccountForget
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_zhanghaodenglu_wangjimima_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreActivate
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_yiyouhuiyuankajihuo_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreActivateNext
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_yiyouhuiyuankajihuo_xiayibu_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreActivateNextNext
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_yiyouhuiyuankajihuo_xiayibu_xiayibu_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreActivateNextNextActivate
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_yiyouhuiyuankajihuo_xiayibu_xiayibu_zhijiejihuo_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreActivateNextNextActivateClear
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_yiyouhuiyuankajihuo_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreActivateNextNextInsuare
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_yiyouhuiyuankajihuo_xiayibu_xiayibu_xuyaobaoxian_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreActivateNextNextInsuareActivate
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_yiyouhuiyuankajihuo_xiayibu_xiayibu_zhijiejihuo_lijijihuo_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreBuycard
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_meiyouhuiyuankagouka_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreBuycardNext
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_meiyouhuiyuankagouka_xiayibu_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreBuycardNextBuy
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_meiyouhuiyuankagouka_xiayibu_zhijiegoumai_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreBuycardNextBuyClear
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_meiyouhuiyuankagouka_xiayibu_zhijiegoumai_qujiesuan_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreBuycardNextInsuares
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_meiyouhuiyuankagouka_xiayibu_xuyaobaoxian_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreBuycardNextInsuaresBuy
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_meiyouhuiyuankagouka_xiayibu_xuyaobaoxian_lijigoumai_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreBuycardNextInsuaresBuyClose
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_%@_meiyouhuiyuankagouka_xiayibu_xuyaobaoxian_lijigoumai_qujiesuan_%@", UmVersionStr, UmLoginStr, UmMoreStr, UmJishuStr]];
}
+ (void)clickMoreCancel
{
    [MobClick event:[NSString stringWithFormat:@"%@_%@_gengduo_quxiao_%@", UmVersionStr, UmLoginStr, UmJishuStr]];
}

@end
