//
//  HYMessageCell.h
//  Teshehui
//
//  Created by ichina on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMessageInfo.h"

@interface HYMessageCell : HYBaseLineCell

@property(nonatomic,strong)UILabel* conLab;

@property(nonatomic,strong)UILabel* timeLab;

-(void)setList:(HYMessageInfo*)info;
@end
