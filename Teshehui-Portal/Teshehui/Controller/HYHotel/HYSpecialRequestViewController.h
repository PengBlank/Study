//
//  HYSpecialRequestViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelViewBaseController.h"

@protocol HYSpecialRequestViewControllerDelegale <NSObject>

@optional
- (void)specialInputComplete:(NSString *)content;

@end

@interface HYSpecialRequestViewController : HYHotelViewBaseController

@property (nonatomic, weak) id<HYSpecialRequestViewControllerDelegale>delegate;

@property (nonatomic, copy) NSString *content;

@end
