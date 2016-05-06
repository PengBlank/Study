//
//  HYSearchHotCell.h
//  Teshehui
//
//  Created by apple on 15/1/23.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseLineCell.h"

@interface HYSearchHotCell : HYBaseLineCell

@property (nonatomic, strong) NSArray *hotItems;

@property (nonatomic, copy) void (^hotCellCallback)(id searchKey);

@end
