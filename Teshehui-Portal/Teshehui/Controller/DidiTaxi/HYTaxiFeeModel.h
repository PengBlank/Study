//
//  HYTaxiFeeModel.h
//  Teshehui
//
//  Created by Kris on 15/11/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYTaxiFeeModel : JSONModel

@property (nonatomic, copy) NSString *carTypeName;
@property (nonatomic, copy) NSString *carTypeCode;
@property (nonatomic, copy) NSString *carTypeFee;
@property (nonatomic, copy) NSString *startPrice;
@property (nonatomic, copy) NSString *normalPrice;
@property (nonatomic, copy) NSString *normalUnitPrice;

@end

/*
 "carTypeName":"商务型:别克GL8 (7座)",
 "carTypeCode":"400",
 "carTypeFee":"73",
 "startPrice":"14",
 "normalUnitPrice":"3.8"
*/