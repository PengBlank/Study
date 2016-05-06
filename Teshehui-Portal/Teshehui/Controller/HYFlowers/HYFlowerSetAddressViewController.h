//
//  HYFolwerSerAdressViewController.h
//  Teshehui
//
//  Created by ichina on 14-3-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFolwerViewBaseController.h"
#import "HYFlowerAddressInfo.h"
#import "HYFlowerCityInfo.h"

@protocol HYFolwerSetAdressDelegate;

@interface HYFlowerSetAddressViewController : HYFolwerViewBaseController

@property(nonatomic,weak)id<HYFolwerSetAdressDelegate>delegate;

@property (nonatomic, strong) HYFlowerAddressInfo *address;

@end

@protocol HYFolwerSetAdressDelegate <NSObject>

- (void)didSelectAdressInfo:(HYFlowerAddressInfo *)address;

@end