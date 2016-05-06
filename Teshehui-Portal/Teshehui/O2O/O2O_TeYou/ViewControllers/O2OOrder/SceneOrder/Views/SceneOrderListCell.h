//
//  SceneOrderListCell.h
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/7.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  场景订单列表cell

#import <UIKit/UIKit.h>
#import "SceneOrderListModel.h"

// 点击按钮回调block
typedef void(^buttonBlock)(BOOL isButton);

@interface SceneOrderListCell : UITableViewCell

-(void)refreshUIWithModel:(SceneOrderListModel *)model Type:(NSInteger)type ButtonClickBlock:(buttonBlock)block;

@end
