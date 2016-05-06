//
//  HYMineInfoWalletCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseLineCell.h"

@protocol HYMineInfoWalletCellDelegate <NSObject>


@end

/**
 *  @brief 新版钱包详情cell
 *  包含：现金券、帐户余额、红包数
 */
@interface HYMineInfoWalletCell : HYBaseLineCell
{
    NSInteger _packetsSend;
    NSInteger _packetsRecv;
}

@property (nonatomic, weak) id<HYMineInfoWalletCellDelegate> delegate;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) double balance;
@property (nonatomic, assign) double o2obalance;

- (void)setSendPackets:(NSInteger)send recv:(NSInteger)recv;

/// 点击具体项目的事件，这里懒得做enum了。就这样吧。。。
@property (nonatomic, copy) void (^didCheckSubType)(NSInteger);

@end
