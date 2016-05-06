//
//  HYMallAdressListInfo.h
//  Teshehui
//
//  Created by ichina on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"
#import "JSONModel.h"

//地址模型，java接口使用JSONModel默认方法来解析,
//PHP解口使用initWithDatainfo来解析
@protocol HYAddressInfo <NSObject>

@end

@interface HYAddressInfo : JSONModel

@property (nonatomic, copy) NSString *addr_id;
@property (nonatomic, copy) NSString *consignee;
@property (nonatomic, copy) NSString *regionId;
@property (nonatomic, copy) NSString *regionName;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phoneMobile;

//新增字段
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *name;

/**
 * 海淘增加字段，用户身份证号
 */
@property (nonatomic, copy) NSString *idCard;


@property (nonatomic, assign) BOOL isDefault;

- (id)initWithDataInfo:(NSDictionary *)data;
- (id)initWithOrderAddrInfo:(NSDictionary *)data;

- (NSString *)fullAddress;  //xx省xxy市xx区xx街。。。
- (NSString *)fullRegion;   //xx省xxy市xx区
- (NSString *)addressDetail;
- (NSString *)displayForInvoice;


- (NSString *)checkValid;

@end

/*
 "addr_id": "48",
 "user_id": "102",
 "consignee": "高武",
 "region_id": "27",
 "region_name": "中国\t天津市\t河北区",
 "address": "衡阳祁东",
 "zipcode": "421600",
 "phone_tel": "13113178211",
 "phone_mob": "13113178211"

*/