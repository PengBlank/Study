//
//  HYAddCommentsLevelCell.h
//  Teshehui
//
//  Created by RayXiang on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCommentModel.h"

@class HYAddCommentsLevelCell;
/**
 *  回调,描述，服务，发货的评级
 */
@protocol HYAddCommentsLevelCellDelegate <NSObject>
@optional
- (void)levelCell:(HYAddCommentsLevelCell *)cell didGetDescriptionLevel:(NSInteger)level;
- (void)levelCell:(HYAddCommentsLevelCell *)cell didGetServiceLevel:(NSInteger)level;
- (void)levelCell:(HYAddCommentsLevelCell *)cell didGetDeliverLevel:(NSInteger)level;

@end

@interface HYAddCommentsLevelCell : UITableViewCell

@property (nonatomic, weak) id<HYAddCommentsLevelCellDelegate> delegate;

@property (nonatomic, strong) HYCommentModel *commentModel;

@end
