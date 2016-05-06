//
//  HYDeliveryAddress.h
//  Teshehui
//
//  Created by HYZB on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *  常用收货地址
 */
#import "HYCustomNavItemViewController.h"
#import "HYAddressInfo.h"

@protocol DeliverAdreeDelegate;

@interface HYDeliveryAddressViewController :HYCustomNavItemViewController

//type为1时，点击地址则选则，否则点击地址编辑
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, weak) id<DeliverAdreeDelegate>delegate;

@end

@protocol DeliverAdreeDelegate <NSObject>

- (void)getAdress:(HYAddressInfo*)info;

@end