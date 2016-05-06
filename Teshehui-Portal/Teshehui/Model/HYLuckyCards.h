//
//  HYLuckyCards.h
//  Teshehui
//
//  Created by HYZB on 15/3/5.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol HYLuckyCards @end

@interface HYLuckyCards : JSONModel

@property (nonatomic, assign) int type;
@property (nonatomic, assign) int num;
@property (nonatomic, assign) int count;

@end
