//
//  TravelOrderListView.h
//  Teshehui
//
//  Created by apple_administrator on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelOrderInfo.h"
typedef void(^ProjectListViewBlock)(TravelOrderInfo *orderInfo, NSInteger type, BOOL isButton);

typedef NS_ENUM(NSInteger, ListViewType)
{
    validityTicket              = 0,
    invalidTicket               = 1
};

@interface TravelOrderListView : UIView

- (id)initWithFrame:(CGRect)frame type:(NSInteger)type block:(ProjectListViewBlock)block;

@end
