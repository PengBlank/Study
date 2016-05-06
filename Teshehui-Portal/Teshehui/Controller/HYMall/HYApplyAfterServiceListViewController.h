//
//  HYApplyAfterServiceListViewController.h
//  Teshehui
//
//  Created by Kris on 15/10/13.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYAddressInfo.h"

/**
 *  申请售后 可申请列表
 */
@interface HYApplyAfterServiceListViewController : HYMallViewBaseController

@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, strong) HYAddressInfo *addressInfo;

@end
