//
//  HYCheckChildTiketResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCheckChildTicketResponse.h"

@implementation HYCheckChildTicketResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        _hasChildrenTicket = NO;
        if ([data count] > 0)
        {
            _hasChildrenTicket = YES;
            NSString *price = GETOBJECTFORKEY(data, @"single_price", [NSString class]);
            self.single_price = [price floatValue];
            
            NSString *airport = GETOBJECTFORKEY(data, @"airport_tax", [NSString class]);
            self.airport_tax = [airport floatValue];
            
            NSString *fuel = GETOBJECTFORKEY(data, @"fuel_tax", [NSString class]);
            self.fuel_tax = [fuel floatValue];
            
            NSString *cPoint = GETOBJECTFORKEY(data, @"points", [NSString class]);
            self.cPoint = [cPoint floatValue];
            
            NSString *fee = GETOBJECTFORKEY(data, @"baby_fee", [NSString class]);
            self.bbFee = [fee floatValue];
            
            NSString *bbPrice = GETOBJECTFORKEY(data, @"baby_price", [NSString class]);
            self.bbPrice = [bbPrice floatValue];
            
            NSString *bbPoint = GETOBJECTFORKEY(data, @"baby_points", [NSString class]);
            self.bbPoint = [bbPoint floatValue];
        }
    }
    
    return self;
}

@end
