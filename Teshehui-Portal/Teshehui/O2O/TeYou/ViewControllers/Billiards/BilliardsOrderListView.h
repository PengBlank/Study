//
//  BilliardsOrderListView.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BilliardsOrderInfo.h"
typedef void(^ProjectListViewBlock)(BilliardsOrderInfo *orderInfo);

typedef NS_ENUM(NSInteger, BilliardsListType)
{
    Project_noPay           = 0,
    Project_alreadyPay      = 1
};

@interface BilliardsOrderListView : UIView

- (id)initWithFrame:(CGRect)frame type:(NSInteger)type block:(ProjectListViewBlock)block;

@end
