//
//  HYLimitTimeBuyCell.h
//  Teshehui
//
//  Created by HYZB on 15/12/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYSeckillGoodsListModel;

typedef NS_ENUM(NSInteger, ActivityStatus) {
// 活动状态活动状态 10:待审核；20：即将开始；21：审核不通过；30：抢购中；40：已结束；99：活动已删除；
    ActivityWaitAudit       = 10,
    ActivityWaitBegin       = 20,
    ActivityNotPassAudit    = 21,
    ActivityBegin           = 30,
    ActivityEnd             = 40,
    ActivityDelete          = 99,
};

@protocol HYLimitTimeBuyCellDelegate <NSObject>

/**
 秒杀添加提醒
 */
- (void)addRemindWithBtn:(UIButton *)btn;

/**
 秒杀取消提醒
 */
- (void)cancelRemindWithBtn:(UIButton *)btn;

/**
 秒杀去抢购
 */
- (void)actionWithModel:(HYSeckillGoodsListModel *)model;

@end

@interface HYLimitTimeBuyCell : UITableViewCell

@property (nonatomic, strong) HYSeckillGoodsListModel *model;

@property (nonatomic, weak) id<HYLimitTimeBuyCellDelegate>delegate;

- (void)setCellInfoWithModel:(HYSeckillGoodsListModel *)model andActivityStatus:(NSString *)status;

@end
