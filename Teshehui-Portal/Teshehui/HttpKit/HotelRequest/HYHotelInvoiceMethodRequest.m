//
//  HYHotelInvoiceMethodRequest.m
//  Teshehui
//
//  Created by apple on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYHotelInvoiceMethodRequest.h"
#import "HYHotelInvoiceMethodResponse.h"

@implementation HYHotelInvoiceMethodRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kHotelRequestBaseURL, @"api/hotels/hotel_invoice"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    return [[HYHotelInvoiceMethodResponse alloc] initWithJsonDictionary:info];
}

@end
