//
//  HYTaxiRule.h
//  Teshehui
//
//  Created by Kris on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYTaxiCarType.h"

@interface HYTaxiRule : JSONModel

@property (nonatomic, copy) NSString *ruleCode;
@property (nonatomic, copy) NSString *ruleName;
@property (nonatomic, copy) NSArray <HYTaxiCarType>*carTypeArray;

@end
