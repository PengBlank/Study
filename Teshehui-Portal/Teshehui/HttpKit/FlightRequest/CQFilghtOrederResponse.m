//
//  CQFilghtOrederResponse.m
//  ComeHere
//
//  Created by ChengQian on 13-11-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtOrederResponse.h"

@implementation CQFilghtOrederResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        self.MyOrderID = GETOBJECTFORKEY(dictionary, @"MyOrderID", [NSString class]);
        self.PMOrderID = GETOBJECTFORKEY(dictionary, @"PMOrderID", [NSString class]);
    }
    
    return self;
}

@end
