//
//  RefundCell.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/11.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"

@interface RefundCell : BaseCell

@property (nonatomic,strong) UILabel        *reasonLabel;
@property (nonatomic,strong) UILabel        *desLabel;
@property (nonatomic,strong) UIButton       *selectBtn;

- (void)bindData:(NSArray *)dataArray reasonArray:(NSMutableArray *)reasonArray indexPath:(NSIndexPath *)indexPath;

@end
