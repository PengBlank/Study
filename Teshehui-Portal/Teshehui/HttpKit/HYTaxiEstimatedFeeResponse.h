//
//  HYTaxiEstimatedFeeResponse.h
//  Teshehui
//
//  Created by Kris on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYTaxiFeeModel.h"

@interface HYTaxiEstimatedFeeResponse : CQBaseResponse

@property (nonatomic, copy) NSArray *dataList;

@end
