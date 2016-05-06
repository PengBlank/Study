//
//  MapMerchantRequest.h
//  Teshehui
//
//  Created by apple_administrator on 15/10/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface MapMerchantRequest : CQBaseRequest
@property (nonatomic,assign) double     Longitude   ;//经度
@property (nonatomic,assign) double     Latitude    ;//纬度
@property (nonatomic,assign) NSInteger     PageIndex    ;//纬度
@property (nonatomic,assign) NSInteger     PageSize    ;//纬度
@property (nonatomic,strong) NSString      *City;
@end
