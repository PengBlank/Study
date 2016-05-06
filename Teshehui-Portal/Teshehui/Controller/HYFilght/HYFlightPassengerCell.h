//
//  HYFlightPassengerCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYPassengers.h"

@protocol HYFlightPassengerCellDelegate;
@interface HYFlightPassengerCell : HYBaseLineCell

@property (nonatomic, weak) id<HYFlightPassengerCellDelegate> delegate;
@property (nonatomic, strong) HYPassengers *passenger;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *childrenPrice;
@property (nonatomic, assign) BOOL supportChild;

- (void)updateWithPassenger:(HYPassengers *)passenger
                      price:(NSString *)price
                    support:(BOOL)support;
@end


@protocol HYFlightPassengerCellDelegate <NSObject>

@optional
- (void)childUpdateBuyTicketType:(HYPassengers *)passenger;
- (void)deletePassengerCellForIndexPath:(NSIndexPath *)indexPath;

@end
