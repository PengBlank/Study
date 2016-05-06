//
//  HYCarInfo.m
//  Teshehui
//
//  Created by HYZB on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCICarInfo.h"
#import "HYCICarInfoFillType.h"

@implementation HYCICarInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (HYCICarInfo *)carInfoWithInputFillTypes:(NSArray *)fillTypes
{
    HYCICarInfo *carinfo = [[HYCICarInfo alloc] init];
    
    for (HYCICarInfoFillType *filltype in fillTypes)
    {
        if ([filltype.name isEqualToString:@"vehicleFrameNo"]) {
            carinfo.vehicleFrameNo = filltype.value;
        }
        else if ([filltype.name isEqualToString:@"vehicleModelName"])
        {
            carinfo.vehicleModelName = filltype.value;
        }
        else if ([filltype.name isEqualToString:@"vehicleId"])
        {
            carinfo.vehicleId = filltype.value;
        }
        else if ([filltype.name isEqualToString:@"engineNo"])
        {
            carinfo.engineNo = filltype.value;
        }
        else if ([filltype.name isEqualToString:@"seats"])
        {
            carinfo.seats = filltype.value;
        }
        else if ([filltype.name isEqualToString:@"firstRegisterDate"])
        {
            carinfo.firstRegisterDate = filltype.value;
        }
        else if ([filltype.name isEqualToString:@"specialCarFlag"])
        {
            carinfo.specialCarFlag = filltype.value;
        }
        else if ([filltype.name isEqualToString:@"ownerName"])
        {
            carinfo.owner = filltype.value;
        }
        else if ([filltype.name isEqualToString:@"ownerIdNo"])
        {
            carinfo.ownerId = filltype.value;
        }
    }
    
    return carinfo;
}

@end
