//
//  TicketingViewController.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/16.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "HYMallViewBaseController.h"

@interface TicketingViewController : HYMallViewBaseController

@property ( nonatomic , copy ) NSString * strScenicId;  // 景点id
@property ( nonatomic , copy ) NSString * strTicketType;  // 类型（0代表merid为景区id，1代表merid为景区票id）

@end
