//
//  HYClearHistoryCell.h
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYClearHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

/// 如果没有历史记录，显示 暂无历史记录
@property (nonatomic, assign) BOOL hasHistory;

@end
