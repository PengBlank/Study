//
//  HYFolwerBigTypeCell.h
//  Teshehui
//
//  Created by ichina on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYFlowerTypeInfo.h"

@interface HYFolwerBigTypeCell : HYBaseLineCell

@property(nonatomic,retain)UILabel* NameLab;

- (void)setCellData:(HYFlowerTypeInfo *)data;
@end
