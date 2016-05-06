//
//  HYCIQuoteResponse.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYCICarInfoFillType.h"
#import "HYCIAreaAndDriverInfo.h"

@interface HYCIQuoteResponse : CQBaseResponse

//@property (nonatomic, strong) NSString *quoteKey;
//@property (nonatomic, strong) NSString *forceKey;
//@property (nonatomic, strong) NSString *dateKey;

@property (nonatomic, strong) NSArray *quoteList;
@property (nonatomic, strong) NSArray *forceList;
@property (nonatomic, strong) NSArray *dateList;

@property (nonatomic, assign) CGFloat points;

//是否可以使用指省
@property (nonatomic, assign) BOOL runAreaFlag;
@property (nonatomic, assign) BOOL driverFlag;
@property (nonatomic, strong) HYCICarInfoFillType *runAreaInfo;

@property (nonatomic, strong) NSArray *additionList;

@end

