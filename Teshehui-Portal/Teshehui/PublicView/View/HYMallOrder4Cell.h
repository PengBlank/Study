//
//  HYMallOrder4Cell.h
//  Teshehui
//
//  Created by ichina on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@interface HYMallOrder4Cell : HYBaseLineCell

@property (nonatomic,retain)UILabel* moneyLab;

@property (nonatomic,retain)UILabel* pointLab;

-(void)setList:(NSDictionary*)dic;

@end
