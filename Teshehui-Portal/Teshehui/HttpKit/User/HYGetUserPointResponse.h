//
//  HYGetUserPointResponse.h
//  Teshehui
//
//  Created by ichina on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYPointLogInfo.h"

@interface HYGetUserPointResponse : CQBaseResponse

@property(nonatomic,strong)NSMutableArray* PointArray;

@property(nonatomic,assign)NSInteger totalItems;
@property (nonatomic, copy) NSString *points;

@end
