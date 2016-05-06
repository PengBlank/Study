//
//  HYProductSpareAmount.h
//  Teshehui
//
//  Created by Kris on 15/9/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol HYSpareItem
@end

@interface HYProductSpareAmount : JSONModel

@property (nonatomic, copy) NSString *totalAmount;
@property (nonatomic, copy) NSString *totalSpareAmount;
@property (nonatomic, copy) NSString *totalPoints;
@property (nonatomic, copy) NSArray<HYSpareItem> *productSKUArray;
@end

@interface HYSpareItem : JSONModel

@property (nonatomic, strong) NSString *productSKUId;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *discountRate;
@property (nonatomic, strong) NSString *spareAmount;
@property (nonatomic, strong) NSString *points;

@end