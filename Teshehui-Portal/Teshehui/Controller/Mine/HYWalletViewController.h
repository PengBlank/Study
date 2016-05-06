//
//  HYWalletViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

/**
 *  @brief 我的钱包
 *  我的界面，钱包功能
 */
@interface HYWalletViewController : HYMallViewBaseController

/**
 *  @brief  所有的数据从前面传过来，不再取接口
 */
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) double balance;
@property (nonatomic, assign) NSInteger packetNew;
@property (nonatomic, assign) NSInteger packetTotal;
@property (nonatomic, assign) double o2obalance;

@end
