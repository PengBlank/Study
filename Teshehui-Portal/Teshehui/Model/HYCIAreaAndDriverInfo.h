//
//  HYCIAreaAndDriverInfo.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/16.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYCICarInfoFillType.h"

@interface HYCIAreaAndDriverInfo : NSObject

@property (nonatomic, assign) BOOL runAreaFlag;
@property (nonatomic, assign) BOOL driverFlag;  //是否可指
@property (nonatomic, assign) BOOL isAssignDriver;
@property (nonatomic, strong) HYCICarInfoFillType *runAreaInfo;

//驾驶员信息
@property (nonatomic, strong) NSString *driverName;
@property (nonatomic, strong) NSString *driverNum;
@property (nonatomic, strong) NSString *drivateDate;

- (NSString *)checkError;

@end
