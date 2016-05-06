//
//  HYHotelTrafficCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelInfoCell.h"

@interface HYHotelTrafficCell : HYHotelInfoCell

@property (nonatomic, copy) NSString *traDesc;
@property (nonatomic, copy) NSString *distance;

- (void)addExpandView:(UIView *)view;
- (void)removeExpandView;

@end
