//
//  HYAddAdressRequest.h
//  Teshehui
//
//  Created by ichina on 14-3-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYAddAdressRequest : CQBaseRequest

@property(nonatomic,copy)NSString* consignee;   //收货人名
@property(nonatomic,copy)NSString* region_id;
@property(nonatomic,copy)NSString* region_name;
@property(nonatomic,copy)NSString* address;
@property(nonatomic,copy)NSString* zipcode;
@property(nonatomic,copy)NSString* phone_tel;
@property(nonatomic,copy)NSString* phone_mob;
@property(nonatomic, assign) NSInteger isDefault;


@end
