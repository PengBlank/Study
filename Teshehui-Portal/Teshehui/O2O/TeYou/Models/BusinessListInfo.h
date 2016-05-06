//
//  BusinessListInfo.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessListInfo : NSObject
@property (nonatomic, strong) NSString *Address;
@property (nonatomic, strong) NSString *Category;
@property (nonatomic, strong) NSString *Logo;
@property (nonatomic, strong) NSString *MerchantsName;
@property (nonatomic, strong) NSString *MerId;
@property (nonatomic, strong) NSString *Strategy;
@property (nonatomic, assign) CGFloat  Distance;

@property (nonatomic, strong) NSString *AddressDetail;

@property (nonatomic, assign) double               Latitude;
@property (nonatomic, assign) double               Longitude;
@end
