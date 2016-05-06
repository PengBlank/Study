//
//  HYCITableViewExpandCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseLineCell.h"

/**
 *  这个cell用于订单确认界面显示cell 头部
 *  或者订单详情界面，订单详情界面需要将indicator隐藏
 */
@interface HYCITableViewConfirmExpandCell : HYBaseLineCell

@property (nonatomic, weak) IBOutlet UILabel *nameLab;
@property (nonatomic, weak) IBOutlet UIImageView *indicator;

- (void)setExpand:(BOOL)expand;

@end
