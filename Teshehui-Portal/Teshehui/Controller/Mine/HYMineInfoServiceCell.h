//
//  HYMineInfoServiceCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYMineINfoServiceCellDelegate <NSObject>

- (void)didClickPhone;
- (void)didClickQQ;

@end


/**
 *  @brief 服务功能cell
 *  4.4.0已废弃
 */
@interface HYMineInfoServiceCell : UITableViewCell

@property (nonatomic, weak) id<HYMineINfoServiceCellDelegate> delegate;

@end
