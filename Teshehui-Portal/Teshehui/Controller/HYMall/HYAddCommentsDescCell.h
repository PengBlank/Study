//
//  HYAddCommentsDescCell.h
//  Teshehui
//
//  Created by RayXiang on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCommentModel.h"

@class HYAddCommentsDescCell;
@protocol HYAddCommentsDescCellDelegate <NSObject>

- (void)descCellDidBeginEditing:(HYAddCommentsDescCell *)cell;

@end

@interface HYAddCommentsDescCell : UITableViewCell

@property (nonatomic, strong) HYCommentModel *commentModel;
@property (nonatomic, weak) id<HYAddCommentsDescCellDelegate> delegate;

@end
