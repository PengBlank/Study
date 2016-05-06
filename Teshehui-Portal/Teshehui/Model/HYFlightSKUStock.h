//
//  HYFlightStock.h
//  Teshehui
//
//  Created by 成才 向 on 15/6/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYFlightSKUStock : JSONModel

@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, assign) CGFloat childSinglePrice;   //儿童价
@property (nonatomic, assign) CGFloat childCabinTypePrice;    //儿童票面价，不用管
@property (nonatomic, assign) CGFloat childPoints;        //现金券
@property (nonatomic, assign) CGFloat childAirportTax;    //机建
@property (nonatomic, assign) CGFloat childFuelTax;       //燃油
@property (nonatomic, assign) CGFloat babyFee;            //婴儿手续费
@property (nonatomic, assign) CGFloat babyPrice;            //婴儿票价
@property (nonatomic, assign) CGFloat babyPoints;         //婴儿现金券

@property (nonatomic, assign) CGFloat singlePrice; // 票价
@property (nonatomic, copy) NSString *returnAmount; // 返现金额
@property (nonatomic, assign) CGFloat cabinTypePrice; // 仓位全价(市场价)
@property (nonatomic, assign) CGFloat points; // 特币数
@property (nonatomic, assign) CGFloat airportTax; // 机建费
@property (nonatomic, assign) CGFloat fuelTax; // 燃油费


@end
