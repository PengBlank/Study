//
//  HYSiRedPacketsViewController.h
//  Teshehui
//
//  Created by Kris on 15/9/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

@interface HYSiRedPacketsViewController : HYMallViewBaseController

@property (nonatomic, assign) BOOL needClearCache;
@property (nonatomic, copy) NSString *cashCard;

@property (nonatomic, copy) void (^completeBlock)(void);

+ (void)showWithPoints:(NSString *)points completeBlock:(void (^)(void))completeBlock;

@end
