//
//  HYMallLogisticsInfo.h
//  Teshehui
//
//  Created by HYZB on 14-9-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *  物流信息
 */

#import "CQResponseResolve.h"
#import "HYAddressInfo.h"
#import "HYMallExpressItem.h"

@interface HYTrackInfo : NSObject<CQResponseResolve>
{
    CGFloat _contentHeight;
}

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign, readonly) CGFloat contentHeight;

@end

@interface HYMallLogisticsInfo : JSONModel<CQResponseResolve>

@property (nonatomic, copy) NSString *expressName;
@property (nonatomic, copy) NSString *expressNo;
@property (nonatomic, copy) NSString *expressTo;


@property (nonatomic, strong) HYAddressInfo *address;


@property (nonatomic, strong) NSArray <HYMallExpressItem>*trackList;

@end

/*
 "data": {
 "express_num": "580070084598",
 "express_company": "天天快递",
 "data": [
 {
 "time": "2014-01-07 16:08:28",
 "context": "已签收,签收人是【本人】"
 },
 {
 "time": "2014-01-07 16:08:28",
 "context": "已签收,签收人是【罗世吉】"
 },
 {
 "time": "2014-01-07 09:18:29",
 "context": "【深圳八卦岭( 075525157244，25847726)】的派件员【罗世吉】正在派件"
 }
 ],
 "order_sn": "BB2S4504710906",
 "consignee": "高武",
 "region_name": "中国\t天津市\t河北区",
 "address": "衡阳祁东",
 "zipcode": "421600",
 "phone_tel": "13113178211",
 "phone_mob": "13113178211",
 "shipping_name": "包邮",
 "shipping_fee": "0.00"
 }
 */