//
//  HYSetAdressView.h
//  Teshehui
//
//  Created by ichina on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCustomNavItemViewController.h"
#import "HYAddressInfo.h"

typedef enum {
    HYAddressManageAdd,
    HYAddressManageEdit
}
HYAddressManageType;

@protocol HYAddressEditViewControllerDelegate <NSObject>

@end
/**
 *  添加收货地址，编辑收货地址
 */
@interface HYAddressEditViewController : HYCustomNavItemViewController

@property(nonatomic,strong) HYAddressInfo *addressInfo;
@property(nonatomic,assign) HYAddressManageType type;
@property(nonatomic, weak) id<HYAddressEditViewControllerDelegate> delegate;

@end
