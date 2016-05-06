//
//  CQLoginResponse.m
//  Teshehui
//
//  Created by ChengQian on 13-11-16.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYLoginResponse.h"


@implementation HYLoginResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];

    if (self)
    {
        NSDictionary *dic = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        if (dic)
        {
            NSError *err;
            self.userInfo = [[HYUserInfo alloc] initWithDictionary:dic error:&err];
            if (err)
            {
                assert(NO);
            }
            //持久化
            [self.userInfo saveData];
        }
    }
    
    return self;
}

@end
