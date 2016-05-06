//
//  HYGetUpdateInfoResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-28.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetUpdateInfoResponse.h"

@implementation HYGetUpdateInfoResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.version_no = GETOBJECTFORKEY(data, @"version_no", [NSString class]);
        self.version_name = GETOBJECTFORKEY(data, @"version_name", [NSString class]);
        
        NSString *force = GETOBJECTFORKEY(data, @"force_update", [NSString class]);
        
        if ([force length] > 0)
        {
            self.force_update = [force isEqualToString:@"Y"];
        }
    }
    
    return self;
}

@end
