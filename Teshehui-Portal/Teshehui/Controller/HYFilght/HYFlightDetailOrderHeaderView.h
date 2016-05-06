//
//  HYFlightDetailOrderHeaderView.h
//  Teshehui
//
//  Created by Kris on 15/9/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYFlightListSummary.h"
#import "HYFlightOrder.h"

@interface HYFlightDetailOrderHeaderView : UIView

@property (nonatomic, strong) HYFlightListSummary *flightSummary;
@property (nonatomic, strong) HYFlightOrder *order;

@end
