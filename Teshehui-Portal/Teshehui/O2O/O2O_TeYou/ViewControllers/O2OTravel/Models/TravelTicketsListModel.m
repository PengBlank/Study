//
//  TravelTicketsListModel.m
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TravelTicketsListModel.h"

@implementation TravelTicketsListModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"tickets" : [TravelSightInfo class],
             };
}

@end

@implementation TravelSightInfo

@end