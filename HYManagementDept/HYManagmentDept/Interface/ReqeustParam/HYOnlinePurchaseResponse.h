//
//  HYPurchaseResponse.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-11-4.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseResponse.h"

@interface HYOnlinePurchaseResponse : HYBaseResponse

@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_no;
@property (nonatomic, strong) NSString *order_name;
@property (nonatomic, strong) NSString *pay_total;

- (id)initWithJsonDictionary:(NSDictionary *)dictionary;

@end
