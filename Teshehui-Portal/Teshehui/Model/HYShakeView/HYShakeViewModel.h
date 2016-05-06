//
//  HYShakeViewModel.h
//  Teshehui
//
//  Created by HYZB on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYShakeViewModel : JSONModel

@property (nonatomic, copy) NSString *shakeName;
@property (nonatomic, copy) NSString *shakeType;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *currentCode;
@property (nonatomic, copy) NSString *produuctPref;
@property (nonatomic, copy) NSString *cashCouponAmount;
@property (nonatomic, copy) NSString *continueSignAmount;
@property (nonatomic, copy) NSString *cuePhrases;
@property (nonatomic, assign) BOOL isSign;
@property (nonatomic, copy) NSString *shakeTime;
@property (nonatomic, copy) NSString *continueSignDays;
@property (nonatomic, copy) NSString *currentDayShakeCount;
@property (nonatomic, strong) NSDictionary *productPO;

@end
