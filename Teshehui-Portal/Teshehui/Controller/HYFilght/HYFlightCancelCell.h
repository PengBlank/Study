//
//  HYFlightCancelCell.h
//  Teshehui
//
//  Created by Kris on 15/9/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYFlightOrder.h"

@protocol HYFlightCancelCellDelegate;

@interface HYFlightCancelCell : HYBaseLineCell

@property (nonatomic, strong) HYFlightOrder *order;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<HYFlightCancelCellDelegate> delegate;
@property (nonatomic, assign) NSInteger orderStatus;

@end


@protocol HYFlightCancelCellDelegate <NSObject>

@optional
- (void)cancelFilghtOrder:(HYFlightOrder *)order;

@end