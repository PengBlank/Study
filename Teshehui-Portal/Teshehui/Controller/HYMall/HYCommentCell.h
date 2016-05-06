//
//  HYCommentCell.h
//  Teshehui
//
//  Created by RayXiang on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMallGoodCommentInfo.h"

@class HYCommentCell;
@protocol HYCommentCellDelegate <NSObject>

@optional
- (void)commentCell:(HYCommentCell *)cell withInfo:(HYMallGoodCommentInfo *)info didClickImageAtIndex:(NSInteger)idx;

@end

@interface HYCommentCell : UITableViewCell

+ (CGFloat)heightForModel:(id)model;

@property (nonatomic, strong) HYMallGoodCommentInfo *commentInfo;

@property (nonatomic, weak) id<HYCommentCellDelegate> delegate;

@end
