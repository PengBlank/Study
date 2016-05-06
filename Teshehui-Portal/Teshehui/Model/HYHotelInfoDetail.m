//
//  HYHotelInfoBase.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelInfoDetail.h"
#import "HYHotelPictureInfo.h"
#import "HYHotelRoom.h"
#import "NSDate+Addition.h"

@interface HYHotelInfoDetail ()

@property (nonatomic, strong) NSArray *bigImgList;
@property (nonatomic, strong) NSArray *midImgList;
@property (nonatomic, strong) NSArray *smallImgList;

@end

@implementation HYHotelInfoDetail

- (id)initWithDataInfo:(NSDictionary *)data
{
    NSMutableDictionary *tempdec = [[NSMutableDictionary alloc]initWithDictionary:data];
    NSDictionary *expand = [data objectForKey:@"expandedResponse"];
    [tempdec addEntriesFromDictionary:expand];
    [tempdec removeObjectForKey:@"expandedResponse"];
    
    NSError *error = nil;
    self = [super initWithDictionary:tempdec error:&error];
   
    if (self)
    {
        NSMutableArray *bigList = [[NSMutableArray alloc] init];
        NSMutableArray *midList = [[NSMutableArray alloc] init];
        NSMutableArray *smallList = [[NSMutableArray alloc] init];
   
        NSArray *sku = GETOBJECTFORKEY(data, @"productSKUArray", [NSArray class]);
        NSMutableArray *tempMuArr = [HYHotelSKU arrayOfModelsFromDictionaries:sku];
        self.productSKUArray = [tempMuArr copy];
        
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        
        for (HYHotelSKU *sku in self.productSKUArray)
        {
            if (![tempDic.allKeys containsObject:sku.roomTypeName])
            {
                NSMutableArray *items = [NSMutableArray arrayWithObject:sku];
                [tempDic setObject:items forKey:sku.roomTypeName];
                
                //有序保存
                [tempArr addObject:items];
            }
            else
            {
                NSMutableArray *mu = [tempDic objectForKey:sku.roomTypeName];
                [mu addObject:sku];
            }
            
            for (HYImageInfo *image in sku.productSKUImagArray)
            {
                NSString *bigUrl = [NSString stringWithFormat:@"%@_%@", image.imageUrl, ImageSizeBig];
                NSString *midUrl = [NSString stringWithFormat:@"%@_%@", image.imageUrl, ImageSizeMid];
                NSString *smallUrl = [NSString stringWithFormat:@"%@_%@", image.imageUrl, ImageSizeSmall];
                [bigList addObject:bigUrl];
                [midList addObject:midUrl];
                [smallList addObject:smallUrl];
            }
        }
        
        self.roomItems = [tempArr copy];
        
        self.bigImgList = [bigList copy];
        self.midImgList = [midList copy];
        self.smallImgList = [smallList copy];
        
        self.currentsSUK = [self.productSKUArray lastObject];
        
        
        NSString *time = GETOBJECTFORKEY(expand, @"establishmentTime", NSString);
//        NSString *time = GETOBJECTFORKEY(baseInfo, @"establishmentTime", [NSString class]);
        if (time.length > 11)
        {
            time = [time substringToIndex:10];
        }
        self.establishmentTime = time;//GETOBJECTFORKEY(baseInfo, @"establishmentTime", [NSString class]);
        self.productName = GETOBJECTFORKEY(expand, @"productName", NSString);
        self.renovationTime = GETOBJECTFORKEY(expand, @"renovationTime", NSString);
        self.generalAmenities = GETOBJECTFORKEY(expand, @"generalAmenities", NSString);
        self.roomAmenities = GETOBJECTFORKEY(expand, @"roomAmenities", NSString);
        self.recreationAmenities = GETOBJECTFORKEY(expand, @"recreationAmenities", NSString);
        self.otherAmenities = GETOBJECTFORKEY(expand, @"otherAmenities", NSString);
        self.traffic = GETOBJECTFORKEY(expand, @"traffic", NSString);
        self.surroundings = GETOBJECTFORKEY(expand, @"surroundings", NSString);
        self.hotelDescription = GETOBJECTFORKEY(expand, @"hotelDescription", NSString);
//        self.renovationTime = GETOBJECTFORKEY(baseInfo, @"renovationTime", [NSString class]);
//        self.generalAmenities = GETOBJECTFORKEY(baseInfo, @"generalAmenities", [NSString class]);
//        self.roomAmenities = GETOBJECTFORKEY(baseInfo, @"roomAmenities", [NSString class]);
//        self.recreationAmenities = GETOBJECTFORKEY(baseInfo, @"recreationAmenities", [NSString class]);
//        self.otherAmenities = GETOBJECTFORKEY(baseInfo, @"otherAmenities", [NSString class]);
//        self.traffic = GETOBJECTFORKEY(baseInfo, @"traffic", [NSString class]);
//        self.surroundings = GETOBJECTFORKEY(baseInfo, @"surroundings", [NSString class]);
//        self.hotelDescription = GETOBJECTFORKEY(baseInfo, @"hotelDescription", [NSString class]);
        
//        NSMutableArray *muRooms = [[NSMutableArray alloc] init];
////        NSArray *rooms = GETOBJECTFORKEY(data, @"hotelRoomTypeList", [NSArray class]);
//        NSArray *rooms = GETOBJECTFORKEY(data, @"productSKUArray", [NSArray class]);
//        for (id obj in rooms)
//        {
//            if ([obj isKindOfClass:[NSDictionary class]])
//            {
//                HYHotelRoom *r = [[HYHotelRoom alloc] initWithDataInfo:obj];
//                [muRooms addObject:r];
//            }
//        }
//        
//        self.roomTypeList = muRooms;
    }
    
    return self;
}

- (void)setWithSummaryInfo:(HYHotelListSummary *)summary
{
    if (summary.productId)
    {
        self.productId = summary.productId;
    }
    if (summary.productName)
    {
        self.productName = summary.productName;
    }
    if (summary.bigLogoUrl)
    {
        self.bigLogoUrl = summary.bigLogoUrl;
    }
    if (summary.hotelStar)
    {
        self.hotelStar = summary.hotelStar;
    }
//    if (summary.score)
//    {
//        self.score = summary.score;
//    }
    if (summary.districtName)
    {
        self.districtName = summary.districtName;
    }
    if (summary.commercialName)
    {
        self.commercialName = summary.commercialName;
    }
//    if (summary.price)
//    {
//        self.price = [NSString stringWithFormat:@"%f",summary.price];
//    }
    if (summary.currencyCode)
    {
        self.currencyCode = summary.currencyCode;
    }
    if (summary.positionTypeCode)
    {
        self.positionTypeCode = summary.positionTypeCode;
    }
    if (summary.latitude)
    {
        self.latitude = summary.latitude;
    }
    if (summary.longitude)
    {
        self.longitude = summary.longitude;
    }
    if (summary.wifi)
    {
        self.wifi = summary.wifi;
    }
    if (summary.park)
    {
        self.park = summary.park;
    }
//    if (summary.createdTime)
//    {
//        self.createdTime = summary.createdTime;
//    }
//    if (summary.updatedTime)
//    {
//        self.updatedTime = summary.updatedTime;
//    }
//    if (summary.distance)
//    {
//        self.distance = summary.distance;
//    }
    if (summary.address)
    {
        self.address = summary.address;
    }
}

- (NSString *)hotelDescriptionEscaped
{
    if (!_hotelDescriptionEscaped)
    {
        if (_hotelDescription)
        {
            _hotelDescriptionEscaped = [_hotelDescription stringByReplacingOccurrencesOfString:@"\n" withString:@"\r\n"];
        }
    }
    return  _hotelDescriptionEscaped;
}

- (NSString *)trafficEscaped
{
    if (!_trafficEscaped)
    {
        if (_traffic)
        {
            _trafficEscaped = [_traffic stringByReplacingOccurrencesOfString:@"\n" withString:@"\r\n"];
        }
    }
    return _trafficEscaped;
}

@end
