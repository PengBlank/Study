//
//  HYPromotersApplyCodeResponse.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromotersApplyCodeResponse.h"

@implementation HYPromotersApplyCodeResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            NSNumber *code = GETOBJECTFORKEY(self.jsonDic, @"code", [NSString class]);
            self.code = [NSString stringWithFormat:@"%@", code];
        }
    }
    
    return self;
}


@end
