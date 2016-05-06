//
//  HYForGetResponse.m
//  Teshehui
//
//  Created by ichina on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYForGetResponse.h"

@implementation HYForGetResponse
- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        _dic = [NSDictionary dictionaryWithDictionary:GETOBJECTFORKEY(dictionary,@"data", [NSDictionary class])];
    }
    
    return self;
}
@end
