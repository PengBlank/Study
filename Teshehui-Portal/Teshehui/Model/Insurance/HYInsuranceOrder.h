//
//  HYInsuranceOrder.h
//  Teshehui
//
//  Created by Galwin Chain on 15/4/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYInsuranceOrder : JSONModel

@property(nonatomic, copy)NSString *order_id;
@property(nonatomic, copy)NSString *order_no;
@property(nonatomic, copy)NSString *order_name;
@property(nonatomic, copy)NSString *pay_total;
@property(nonatomic, copy)NSString *points;

@end
