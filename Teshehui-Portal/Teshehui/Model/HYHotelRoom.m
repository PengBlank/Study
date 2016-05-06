//
//  HYHotelRoom.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelRoom.h"

@interface HYHotelRoom ()

@property (nonatomic, copy) NSString *breakfastDesc;
@property (nonatomic, copy) NSString *bedInfoDesc;
@property (nonatomic, copy) NSString *broadnetDesc;
@property (nonatomic, copy) NSString *HasSmokeCleanRoom;

@end

@implementation HYHotelRoom

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
- (BOOL)isPrePay
{
    return (self.productTypeCode ==3 );
}
//- (id)initWithDataInfo:(NSDictionary *)data
//{
//    self = [super init];
//    
//    if (self)
//    {
//        self.roomTypeId = GETOBJECTFORKEY(data, @"roomTypeId", [NSString class]);
//        self.roomTypeName = GETOBJECTFORKEY(data, @"roomTypeName", [NSString class]);
//        self.bigLogoUrl = GETOBJECTFORKEY(data, @"bigLogoUrl", [NSString class]);
//        self.midLogoUrl = GETOBJECTFORKEY(data, @"midLogoUrl", [NSString class]);
//        self.smallLogoUrl = GETOBJECTFORKEY(data, @"smallLogoUrl", [NSString class]);
//        self.code = GETOBJECTFORKEY(data, @"code", [NSString class]);
//
//        NSString *size = GETOBJECTFORKEY(data, @"areaSize", [NSString class]);
//        if (size) {
//            size = [NSString stringWithFormat:@"%@m²", size];
//        }
//        self.areaSize = size;
//        
//        self.floor = GETOBJECTFORKEY(data, @"floor", [NSString class]);
//        self.bedType = GETOBJECTFORKEY(data, @"bedType", [NSString class]);
//        NSString *bedAdd = GETOBJECTFORKEY(data, @"bedAdd", [NSString class]);
//        self.bedAdd = [bedAdd boolValue];
//        
//        NSString *bedAddFee = GETOBJECTFORKEY(data, @"bedAddFee", [NSString class]);  //INT	可入住
//        self.bedAddFee = [bedAddFee floatValue];
//        
//        self.standardOccupancy = [GETOBJECTFORKEY(data, @"standardOccupancy", [NSString class]) integerValue];
//        self.noSmoking = GETOBJECTFORKEY(data, @"noSmoking", [NSString class]);  //STRING	是否支
//        
//        NSInteger wifi = [GETOBJECTFORKEY(data, @"wifi", [NSString class]) integerValue];
//        switch (wifi) {
//            case 0:
//                self.wifi = @"未知";
//                break;
//            case 1:
//                self.wifi = @"免费Wi-Fi";
//                break;
//            case 2:
//                self.wifi = @"收费Wi-Fi";
//                break;
//            default:
//                break;
//        }
//        
//        NSInteger broadBand = [GETOBJECTFORKEY(data, @"broadBand", [NSString class]) integerValue];
//        switch (broadBand) {
//            case 0:
//                self.broadBand = @"未知";
//                break;
//            case 1:
//                self.broadBand = @"免费宽带";
//                break;
//            case 2:
//                self.broadBand = @"收费宽带";
//                break;
//            default:
//                break;
//        }
//        
//        self.window = [GETOBJECTFORKEY(data, @"window", [NSString class]) boolValue];  //STRING
//        self.windowNumber = [GETOBJECTFORKEY(data, @"HasTwinBed", [NSString class]) integerValue];  //STRING
//        self.desc = GETOBJECTFORKEY(data, @"description", [NSString class]);  //STRIN
//        self.createdTime = GETOBJECTFORKEY(data, @"createdTime", [NSString class]);  //STRIN
//        self.updatedTime = GETOBJECTFORKEY(data, @"updatedTime", [NSString class]);  //
//        self.occupancy = GETOBJECTFORKEY(data, @"occupancy", [NSString class]);  //STRING
//        
//        NSMutableArray *rateplan = [[NSMutableArray alloc] init];
//        NSArray *array = GETOBJECTFORKEY(data, @"roomRatePlanList", [NSArray class]);
//        for (id obj in array)
//        {
//            if ([obj isKindOfClass:[NSDictionary class]])
//            {
//                HYHotelRatePlan *p = [[HYHotelRatePlan alloc] initWithDataInfo:obj];
//                [rateplan addObject:p];
//            }
//        }
//        
//        self.rateList = rateplan;
//        
//        _selectIndex = 0;
//    }
//    
//    return self;
//}

- (HYHotelRatePlan *)selectRate
{
    if (self.selectIndex < [self.rateList count])
    {
        return [self.rateList objectAtIndex:self.selectIndex];
    }
    
    return nil;
}

/*
- (HYHotelPictureInfo *)iconCover
{
    if ([self.pictureList count] > 0)
    {
        return [self.pictureList objectAtIndex:0];
    }
    
    return nil;
}


- (NSString *)breakfastDesc
{
    if (!_breakfastDesc)
    {
        if (self.ratePlan.Breakfast)
        {
            if (self.ratePlan.NumberOfBreakfast == 1)
            {
                _breakfastDesc = @"单早";
            }
            else if (self.ratePlan.NumberOfBreakfast == 2)
            {
                _breakfastDesc = @"双早";
            }
            else
            {
                _breakfastDesc = @"多早";
            }
        }
        else
        {
            _breakfastDesc = @"无早";
        }
    }
    
    return _breakfastDesc;
}

- (NSString *)bedInfoDesc
{
    if (!_bedInfoDesc)
    {
        BOOL k = [self.HasKingBed isEqualToString:@"T"];
        BOOL t = [self.HasTwinBed isEqualToString:@"T"];
        
        if (k && t)
        {
            _bedInfoDesc = [NSString stringWithFormat:@"大床%@米，双床%@米", self.KingBedWidth, self.TwinBedWidth];
        }
        else if ([self.HasKingBed isEqualToString:@"T"])
        {
            _bedInfoDesc = [NSString stringWithFormat:@"大床%@", self.KingBedWidth];
        }
        else if ([self.HasTwinBed isEqualToString:@"T"])
        {
            _bedInfoDesc = [NSString stringWithFormat:@"双床%@", self.TwinBedWidth];
        }
    }
    
    return _bedInfoDesc;
}

- (NSString *)broadnetDesc
{
    if (!_broadnetDesc)
    {
        BOOL wify = [self.HasWirelessBroadnet isEqualToString:@"T"];
        BOOL dll = [self.HasWiredBroadnet isEqualToString:@"T"];
        if (wify && dll)
        {
            _broadnetDesc = @"该房间支持免费有线和无线宽带上网";
        }
        else if (wify)
        {
            _broadnetDesc = @"该房间支持免费无线宽带上网";
        }
        else if (dll)
        {
            _broadnetDesc = @"该房间支持免费有线宽带上网";
        }
        else
        {
            _broadnetDesc = @"该房间不支持宽带上网";
        }
    }
    
    return _broadnetDesc;
}
 */
@end
