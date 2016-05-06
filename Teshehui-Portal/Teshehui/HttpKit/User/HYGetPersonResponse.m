//
//  HYGetPersonResponse.m
//  Teshehui
//
//  Created by ichina on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetPersonResponse.h"

@implementation HYGetPersonResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *dic = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        NSError *err = nil;
        
        HYUserInfo *userinfo = [[HYUserInfo alloc] initWithDictionary:dic error:&err];
        self.userInfo = userinfo;
    }
    
    return self;
}

@end
