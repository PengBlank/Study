//
//  HYMallBrandCell.h
//  Teshehui
//
//  Created by Kris on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallBrandModel.h"

@protocol HYMallBrandCellDelegate <NSObject>

@optional
- (void)checkBrandDetaill:(HYMallBrandSecModel *)brandItem;

@end

@interface HYMallBrandCell : HYBaseLineCell

@property (nonatomic, weak) id<HYMallBrandCellDelegate> delegate;
@property (nonatomic, assign, readonly) CGFloat contentHeight;

- (void)setModelList:(NSArray<HYMallBrandSecModel *> *)modelList;

@end
