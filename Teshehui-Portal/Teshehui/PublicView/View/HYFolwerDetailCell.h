//
//  HYFolwerDetailCell.h
//  Teshehui
//
//  Created by ichina on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYFlowerListSummary.h"

@interface HYFolwerDetailCell : HYBaseLineCell

@property (nonatomic, strong) UIImageView* headImg;
@property (nonatomic, strong) UILabel* nameLab;
@property (nonatomic, strong) UILabel* moneyLab;
@property (nonatomic, strong) UILabel* desLab;
@property (nonatomic, strong) UILabel* pointLab;
@property (nonatomic, strong) HYFlowerListSummary *flowerData;

- (void)setCellData:(NSString *)headImg andName:(NSString *)name andMoney:(NSString*)money andDss:(NSString*)dic andPoint:(NSString*)point andMuch:(NSString*)much;
@end
