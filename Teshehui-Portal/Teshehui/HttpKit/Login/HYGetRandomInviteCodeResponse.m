//
//  HYGetRandomInviteCodeResponse.m
//  Teshehui
//
//  Created by Kris on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYGetRandomInviteCodeResponse.h"

@implementation HYGetRandomInviteCodeResponse

-(id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        if (data)
        {
            self.invteCode = [data objectForKey:@"code"];
        }

    }
    return self;
}

@end
