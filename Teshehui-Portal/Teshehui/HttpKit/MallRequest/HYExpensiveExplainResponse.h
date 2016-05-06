//
//  HYExpensiveExplainResponse.h
//  Teshehui
//
//  Created by apple on 15/4/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "JSONModel.h"

@interface HYExpensiveInfo : JSONModel

@property (nonatomic, strong) NSString *fake;   //假赔13
@property (nonatomic, strong) NSString *guijiupei;  //贵就赔
@property (nonatomic, strong) NSString *lightning;  //闪电退
@property (nonatomic, strong) NSString *guarantee;

@property (nonatomic, copy) NSString *img_key1;
+ (instancetype)sharedInfo;
- (void)setShared;

@end

@interface HYExpensiveExplainResponse : CQBaseResponse

@property (nonatomic, strong) HYExpensiveInfo *expensiveInfo;

@end
