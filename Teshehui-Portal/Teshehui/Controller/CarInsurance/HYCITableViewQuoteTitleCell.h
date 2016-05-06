//
//  HYCITableViewQuoteTitleCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseLineCell.h"

/*
 *  标题头
 */
@interface HYCITableViewQuoteTitleCell : HYBaseLineCell
@property (nonatomic, weak) IBOutlet UILabel *cateLab;
@property (nonatomic, weak) IBOutlet UILabel *amountLab;
@property (nonatomic, weak) IBOutlet UILabel *priceLab;
@end
