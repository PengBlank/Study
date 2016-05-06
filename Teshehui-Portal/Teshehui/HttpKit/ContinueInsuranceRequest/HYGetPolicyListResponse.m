//
//  HYGetPolicyListResponse.m
//  Teshehui
//
//  Created by Kris on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYGetPolicyListResponse.h"

@implementation HYGetPolicyListResponse

-(id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *data = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        if (data)
        {
            self.dataList = [HYPolicyType arrayOfModelsFromDictionaries:data];
        }
    }
    return self;
}

@end
