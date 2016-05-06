//
//  CQAttTraffInfo.m
//  Teshehui
//
//  Created by ChengQian on 13-12-28.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQAttTraffInfo.h"

@implementation CQAttTraffInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.longitude = GETOBJECTFORKEY(data, @"longitude", [NSString class]);
        self.longitude = GETOBJECTFORKEY(data, @"longitude", [NSString class]);
        self.sceneryId = GETOBJECTFORKEY(data, @"sceneryId", [NSString class]);
        self.traffic = GETOBJECTFORKEY(data, @"traffic", [NSString class]);
    }
    
    return self;
}

@end
