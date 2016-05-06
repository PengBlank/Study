//
//  HYCIOrderSummary.h
//  Teshehui
//
//  Created by HYZB on 15/7/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol HYCIOrderSummary @end

@interface HYCIOrderSummary : JSONModel

@property (nonatomic, copy) NSString *plateNumber;
@property (nonatomic, copy) NSString *orderNumber;
@property (nonatomic, copy) NSString *productType;
@property (nonatomic, copy) NSString *orderAmount;
@property (nonatomic, copy) NSString *currency;

@end

/*
 "plateNumber":"10粤NSB102",
 "orderNumber":"20160609181649726",
 "productType":"阳光车险",
 "orderAmount":"5320",
 "currency":"元"
*/

/*
 
*/