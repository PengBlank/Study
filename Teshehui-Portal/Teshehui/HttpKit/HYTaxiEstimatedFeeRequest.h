//
//  HYTaxiEstimatedFeeRequest.h
//  Teshehui
//
//  Created by Kris on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYTaxiEstimatedFeeRequest : CQBaseRequest

@property (nonatomic, copy) NSString *startLatitude;
@property (nonatomic, copy) NSString *startLongitude;
@property (nonatomic, copy) NSString *endLatitude;
@property (nonatomic, copy) NSString *endLongitude;
@property (nonatomic, copy) NSString *mapType;
@property (nonatomic, copy) NSString *carTypeCode;
@property (nonatomic, copy) NSString *ruleCode;
@property (nonatomic, copy) NSString *cityCode;


@end
