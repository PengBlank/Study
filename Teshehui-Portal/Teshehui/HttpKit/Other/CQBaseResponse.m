//
//  CQBaseResponse.m
//  Teshehui
//
//  Created by ChengQian on 13-11-15.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQBaseResponse.h"

@interface CQBaseResponse ()
@property (nonatomic, strong) NSDictionary *jsonDic;
@end

@implementation CQBaseResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        self.jsonDic = dictionary;
        NSNumber *status = GETOBJECTFORKEY(dictionary, @"status", [NSString class]);
        self.status =  [status integerValue];
        
        self.suggestMsg = GETOBJECTFORKEY(dictionary, @"suggestMsg", NSString);
        self.code = [GETOBJECTFORKEY(dictionary, @"code", NSString) integerValue];
        
        /*
         * 服务端对错误的返回各种乱七八糟的结构，导致解析如此坑
         */
        id error = [dictionary objectForKey:@"error_msg"];
        if ([error isKindOfClass:[NSDictionary class]])
        {
            self.rspDesc = GETOBJECTFORKEY((NSDictionary *)error, @"msg", [NSString class]);
        }
        else if ([error isKindOfClass:[NSString class]])
        {
            self.rspDesc = (NSString *)error;
        }
        else if ([error isKindOfClass:[NSArray class]])
        {
            NSDictionary *obj = [(NSArray *)error lastObject];
            self.rspDesc = GETOBJECTFORKEY(obj, @"msg", [NSString class]);
        }
        
        if (!_rspDesc)
        {
            id error = [dictionary objectForKey:@"suggestMsg"];
            
            if (!error || [NSNull null]==(NSNull *)error)
            {
                error = [dictionary objectForKey:@"message"];
            }
            if (!error || [NSNull null]==(NSNull *)error)
            {
                error = [dictionary objectForKey:@"msg"];
            }
            
            if ([error isKindOfClass:[NSString class]])
            {
                self.rspDesc = error;
            }
        }
}
    
    return self;
}

@end
