//
//  HotCityCell.h
//  Teshehui
//
//  Created by apple_administrator on 15/10/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"

@interface HotCityCell : BaseCell

@property (nonatomic, copy) void (^hotCityClick)(UIButton *btn);

- (void)bindData:(NSMutableArray *)hotCityArray;
@end
