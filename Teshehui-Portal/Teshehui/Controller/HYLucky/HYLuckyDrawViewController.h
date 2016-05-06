//
//  HYLuckyDrawViewController.h
//  Teshehui
//
//  Created by HYZB on 15/3/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *抽奖发牌界面
 */
#import "HYMallViewBaseController.h"
#import "HYLuckyStatusInfo.h"
#import "HYLuckyInfo.h"

@protocol HYLuckyDrawViewControllerDelegate <NSObject>

@optional
- (void)didRecvCard:(HYLuckyStatusInfo *)lucky;
- (void)didUpdateLuckyStatus;

@end

@interface HYLuckyDrawViewController : HYMallViewBaseController

@property (nonatomic, weak) id<HYLuckyDrawViewControllerDelegate> delegate;
@property (nonatomic, strong) HYLuckyInfo *curLukcy;

@end
