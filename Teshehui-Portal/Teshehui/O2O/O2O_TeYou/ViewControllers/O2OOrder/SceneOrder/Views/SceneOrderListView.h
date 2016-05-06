//
//  SceneOrderListView.h
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/7.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
//  场景订单View

#import <UIKit/UIKit.h>

// 点击控制回调block 数据 和view的类型 支付按钮
typedef void(^SceneOrderListViewBlock)(id obj, NSString *orderNum, BOOL isButton, UIButton *btn);

typedef NS_ENUM(NSInteger, ListViewType)
{
    order_All           = 0, // 全部
    order_Enable        = 1, // 可使用
    order_Unpaid        = 2, // 未付款
    order_Invalid       = 3, // 无效订单
    
    order_Button        = 4, // 按钮
};

@interface SceneOrderListView : UIView

- (id)initWithFrame:(CGRect)frame Type:(NSInteger)type Block:(SceneOrderListViewBlock)block;

@end
