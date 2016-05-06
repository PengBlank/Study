//
//  HYFlowerFillMessageViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-4-9.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 祝福语界面
 */

#import "HYFolwerViewBaseController.h"

@protocol HYFlowerFillMessageViewControllerDelegate <NSObject>

@optional
- (void)didFinishedMessage:(NSString *)message needSig:(BOOL)needSig;

@end

@interface HYFlowerFillMessageViewController : HYFolwerViewBaseController

@property (nonatomic, weak) id<HYFlowerFillMessageViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *message;

@end
