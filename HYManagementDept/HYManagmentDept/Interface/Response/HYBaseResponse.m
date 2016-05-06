//
//  HYBaseResponse.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseResponse.h"

@interface HYBaseResponse ()

@property (nonatomic, strong) NSDictionary *jsonDic;

@end

@implementation HYBaseResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self)
    {
        self.jsonDic = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        NSNumber *status = GETOBJECTFORKEY(dictionary, @"code", NSString);
        if (!status) {
            status = GETOBJECTFORKEY(dictionary, @"status", NSString);
        }
        self.status =  [status intValue];
        self.rspDesc = GETOBJECTFORKEY(dictionary, @"msg", [NSString class]);
        if (!_rspDesc) {
            _rspDesc = GETOBJECTFORKEY(dictionary, @"error_msg", [NSString class]);
        }
        
        self.total = [[self.jsonDic objectForKey:@"total"] integerValue];
    }
    
    return self;
}

@end
