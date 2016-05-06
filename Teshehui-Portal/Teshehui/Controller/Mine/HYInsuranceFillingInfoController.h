//
//  HYInsuranceFillingInfoController.h
//  Teshehui
//
//  Created by Kris on 15/11/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

typedef void(^SaveCompletionHandler)(NSString *result);

#import "HYMallViewBaseController.h"

@interface HYInsuranceFillingInfoController : HYMallViewBaseController

@property (nonatomic, copy) SaveCompletionHandler handler;

@end
