//
//  HYPointLogCell.h
//  Teshehui
//
//  Created by ichina on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYPointLogInfo.h"

@interface HYPointLogCell : HYBaseLineCell
@property(nonatomic,strong)UILabel* TimeLab;

@property(nonatomic,strong)UILabel* NameLab;

@property(nonatomic,strong)UILabel* VauleLab;

-(void)setList:(HYPointLogInfo *)info andType:(NSInteger)type;
@end
