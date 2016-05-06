//
//  HYHotelPriceConditionView.h
//  Teshehui
//
//  Created by RayXiang on 14-11-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYHotelCondition.h"


@interface HYHotelPriceConditionView : UIView
{
    UIView *_backgroundView;
}
- (void)showWithAnimation:(BOOL)animation;
- (void)dismissWithAnimation:(BOOL)animation;

//@property (nonatomic, assign) NSInteger priceLevel;
@property (nonatomic, strong) NSArray *starLevels;

@property (nonatomic, strong) HYHotelCondition *condition;

@property (nonatomic, weak) id<HYHotelConditionChangeDelegate> delegate;

@end
