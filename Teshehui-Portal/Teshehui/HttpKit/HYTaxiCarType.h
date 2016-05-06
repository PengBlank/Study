//
//  HYTaxiCarType.h
//  Teshehui
//
//  Created by Kris on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

typedef enum : NSUInteger {
    ProCar = 201,//专车
    LuxiousProCar = 200,//豪华专车
    BusinessProCar = 400,//商务专车
    ComfortableProCar = 100,//舒适专车
    FastCar = 301,//快车
    NormalFastCar = 600,//普通快车
} HYCarType;


@protocol HYTaxiCarType <NSObject>


@end

@interface HYTaxiCarType : JSONModel

@property (nonatomic, copy) NSString *carTypeCode;
@property (nonatomic, copy) NSString *carTypeName;
@property (nonatomic, copy) NSString *isDefault;
@property (nonatomic, copy) NSString *startPrice;
@property (nonatomic, copy) NSString *normalUnitPrice;

@end
