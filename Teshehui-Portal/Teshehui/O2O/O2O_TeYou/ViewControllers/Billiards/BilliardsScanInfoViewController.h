//
//  BilliardsScanInfoViewController.h
//  Teshehui
//
//  Created by apple_administrator on 15/11/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "BilliardsTableInfo.h"
#import "HYScreenTransformHeader.h"
@interface BilliardsScanInfoViewController : HYMallViewBaseController

@property (nonatomic,strong) BilliardsTableInfo *billiardsTableInfo;
@property (nonatomic,strong) NSString *merId; //商家ID
@property (nonatomic,strong) NSString *btId; //球台ID
@property (nonatomic,assign) NSInteger type;  //1:开台、2:使用中、3:禁用、4:二维码失效（无球台信息）

@end
