//
//  HYSeckillBannerItemView.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYSeckillActivityModel.h"

///秒杀界面,顶部时间banner, 单个itemView
///显示日期时间, 秒杀状态
@interface HYSeckillBannerItemView : UIControl

@property (nonatomic, strong) HYSeckillActivityModel *activity;

@end
