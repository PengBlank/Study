//
//  HYAboutResponse.m
//  Teshehui
//
//  Created by ichina on 14-3-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetWebLinkResponse.h"

@implementation HYGetWebLinkResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary* dic = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        self.link = GETOBJECTFORKEY(dic, @"url", [NSString class]);
        self.infoStr = GETOBJECTFORKEY(dic, @"how_to_get_invitation_code", [NSString class]);
    }
    return self;
}

@end
