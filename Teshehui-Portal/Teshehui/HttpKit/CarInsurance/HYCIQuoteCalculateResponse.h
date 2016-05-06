//
//  HYCIQuoteCalculateResponse.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYCIQuoteCalculateResponse : CQBaseResponse

@property (nonatomic, strong) NSArray *quoteList;
@property (nonatomic, strong) NSArray *forceList;
@property (nonatomic, strong) NSArray *dateList;

@property (nonatomic, assign) CGFloat points;

@end
