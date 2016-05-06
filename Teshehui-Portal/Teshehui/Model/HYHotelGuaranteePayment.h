//
//  HYHotelGuaranteePayment.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

@interface HYHotelGuaranteePayment : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *GuaranteeCode;
@property (nonatomic, copy) NSString *Start;
@property (nonatomic, copy) NSString *End;
@property (nonatomic, copy) NSString *Amount;
@property (nonatomic, copy) NSString *CurrencyCode;

@end
