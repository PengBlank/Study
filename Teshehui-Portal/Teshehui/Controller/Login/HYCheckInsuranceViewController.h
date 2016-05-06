//
//  HYLooknsurance.h
//  Teshehui
//
//  Created by ichina on 14-3-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"
#import "HYRealnameProtocolViewController.h"

@interface HYCheckInsuranceViewController : HYMallViewBaseController

@property (nonatomic, weak) id<HYCheckInsuranceDelegate> delegate;
@property (nonatomic, assign) BOOL isAgree;
@property (nonatomic, copy) NSString *cardNum;
@property (nonatomic, copy) NSString *insuranceProvision;

@end
