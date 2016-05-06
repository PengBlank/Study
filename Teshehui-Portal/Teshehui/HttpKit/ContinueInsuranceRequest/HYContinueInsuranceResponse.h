//
//  HYContinueInsuranceResponse.h
//  Teshehui
//
//  Created by HYZB on 15/3/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYInsuranceOrder.h"

@interface HYContinueInsuranceResponse : CQBaseResponse

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *order_name;
@property (nonatomic, copy) NSString *pay_total;

@end
