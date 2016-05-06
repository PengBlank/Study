//
//  HYMyDesireCell.h
//  Teshehui
//
//  Created by Kris on 15/11/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYMyDesirePoolModel.h"

@protocol HYMyDesireCellDelegate <NSObject>

- (void)sendDeleteInfo:(NSInteger)deleteId;

@end

@interface HYMyDesireCell : HYBaseLineCell

@property (nonatomic, weak) id <HYMyDesireCellDelegate>delegate;

- (void)setCellInfoWithModel:(HYMyDesirePoolModel *)model;

@end
