//
//  HYUpdateAdressRequest.h
//  Teshehui
//
//  Created by ichina on 14-3-3.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYAddressInfo.h"

@interface HYUpdateAddressRequest : CQBaseRequest

@property (nonatomic, strong) HYAddressInfo *addressInfo;

@property (nonatomic, copy) NSString* addr_id;
@property (nonatomic, copy) NSString* consignee;
@property (nonatomic, copy) NSString* region_id;
@property (nonatomic, copy) NSString* region_name;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString* zipcode;
@property (nonatomic, copy) NSString* phone_tel;
@property (nonatomic, copy) NSString* phone_mob;
@property (nonatomic, assign) BOOL isDefault;

@end
