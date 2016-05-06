//
//  HYHotelPictureInfo.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelPictureInfo.h"

@implementation HYHotelPictureInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
//        self.pID = GETOBJECTFORKEY(data, @"pID", [NSString class]);
//        self.HotelID = GETOBJECTFORKEY(data, @"HotelID", [NSString class]);
//        self.PicTitle = GETOBJECTFORKEY(data, @"PicTitle", [NSString class]);
//        self.HotelPic550URL = GETOBJECTFORKEY(data, @"HotelPic550URL", [NSString class]);
//        self.HotelPic78URL = GETOBJECTFORKEY(data, @"HotelPic78URL", [NSString class]);
//        self.HotelPic175URL = GETOBJECTFORKEY(data, @"HotelPic175URL", [NSString class]);
        self.hotelImageId = GETOBJECTFORKEY(data, @"hotelImageId", [NSString class]);
        self.imageType = GETOBJECTFORKEY(data, @"imageType", [NSString class]);
        self.desc = GETOBJECTFORKEY(data, @"description", [NSString class]);
        self.bigUrl = GETOBJECTFORKEY(data, @"bigUrl", [NSString class]);
        self.extenedInfo = GETOBJECTFORKEY(data, @"extenedInfo", [NSString class]);
        self.midUrl = GETOBJECTFORKEY(data, @"midUrl", [NSString class]);
        self.address = GETOBJECTFORKEY(data, @"address", [NSString class]);
    }
    
    return self;
}

@end
