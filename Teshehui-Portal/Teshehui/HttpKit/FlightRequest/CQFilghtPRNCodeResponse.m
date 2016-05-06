//
//  CQFilghtPRNCodeResponse.m
//  ComeHere
//
//  Created by ChengQian on 13-11-27.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtPRNCodeResponse.h"

@implementation CQFilghtPRNCodeResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *dic = GETOBJECTFORKEY(dictionary, @"sd", [NSDictionary class]);
        self.pnr = GETOBJECTFORKEY(dic, @"pnr", [NSString class]);
    }
    
    return self;
}

@end
