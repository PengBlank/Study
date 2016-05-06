//
//  HYExpensivePhotoCell.h
//  Teshehui
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseLineCell.h"
@class HYExpensivePhotoCell;

@protocol HYExpensivePhotoCellDelegate <NSObject>
@optional
- (void)photoCellDidClickAddPhoto:(UITableViewCell *)cell;
- (void)photoCell:(UITableViewCell *)cell didClickDeletePhotoWithIndex:(NSInteger)idx;

@end
@interface HYExpensivePhotoCell : HYBaseLineCell

@property (nonatomic, weak) id<HYExpensivePhotoCellDelegate> delegate;
@property (nonatomic, strong) NSArray *photos; //评价照片
@property (nonatomic, assign) BOOL enable;
@end
