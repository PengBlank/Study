//
//  HYUpdateAdressResponse.m
//  Teshehui
//
//  Created by ichina on 14-3-3.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYUpdateAdressResponse.h"

@implementation HYUpdateAdressResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *result = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        _adressInfo = [[HYAddressInfo alloc] initWithDictionary:result error:nil];
        NSString *message = GETOBJECTFORKEY(dictionary, @"message", [NSString class]);
        self.message = message;
    }
    
    return self;
}

@end
