//
//  HYHotelPrice.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-13.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYHotelPrice : NSObject

@property (nonatomic, assign) NSInteger priceLevel; //0 - ...

@property (nonatomic, copy) NSString *priceDesc;
@property (nonatomic, assign) CGFloat lPrice;   //低价
@property (nonatomic, assign) CGFloat hPrice;   //高价

+ (NSString *)priceDescWithLevel:(NSInteger)level;

+ (instancetype)hotelPriceWithPriceLevel:(NSInteger)level;
+ (NSArray *)priceMapping;

@end
