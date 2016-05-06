//
//  ConsumeCell.h
//  Teshehui
//
//  Created by macmini5 on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsumeInfo.h"

@interface ConsumeCell : UITableViewCell

/**
 刷新UI数据
 */
- (void)refreshUIDataWithModel:(ConsumeInfo *)Info;

@end
