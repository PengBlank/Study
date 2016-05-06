//
//  HYFlowerAdressInfo.h
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYFlowerCityInfo.h"

@interface HYFlowerAddressInfo : NSObject

@property (nonatomic, strong)HYFlowerCityInfo *province;
@property (nonatomic, strong)HYFlowerCityInfo *city;
@property (nonatomic, strong)HYFlowerCityInfo *area;

@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *detaillInfo;

@property (nonatomic, copy, readonly)NSString *fullAddress;


@end
