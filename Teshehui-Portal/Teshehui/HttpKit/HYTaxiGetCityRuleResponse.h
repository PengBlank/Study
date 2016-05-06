//
//  HYTaxiGetCityRuleResponse.h
//  Teshehui
//
//  Created by Kris on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYTaxiRule.h"

@interface HYTaxiGetCityRuleResponse : CQBaseResponse

@property (nonatomic, copy) NSArray *carDataList;
@property (nonatomic, copy) NSString *cityCode;

@end
