//
//  OrderListView.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/22.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"

typedef void(^ProjectListViewBlock)(OrderInfo *orderInfo);

typedef NS_ENUM(NSInteger, ListViewType)
{
    Project_noPay           = 0,
    Project_alreadyPay      = 1
};

@interface OrderListView : UIView


- (id)initWithFrame:(CGRect)frame type:(NSInteger)type block:(ProjectListViewBlock)block;
@end
