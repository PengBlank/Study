//
//  HYCommentAddOneStepCell.h
//  Teshehui
//
//  Created by HYZB on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYCommentAddOneStepModel.h"

@protocol HYCommentAddOneStepCellDelegate <NSObject>

@optional
- (void)didSendCommentWithModel:(HYCommentAddOneStepModel *)model;

@end

@interface HYCommentAddOneStepCell : HYBaseLineCell

@property (nonatomic, weak) id<HYCommentAddOneStepCellDelegate> delegate;
// @property (nonatomic, strong) HYCommentAddOneStepModel *goodsInfo;
- (void)setGoodsInfo:(HYCommentAddOneStepModel *)goodsInfo;

@end
