//
//  HYMyDesireDeleteRequest.m
//  Teshehui
//
//  Created by HYZB on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMyDesireDeleteRequest.h"

@implementation HYMyDesireDeleteRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"wish/deleteWish.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getDataDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.userId) {
        [dict setObject:self.userId forKey:@"userId"];
    }
    if (self.delete_id) {
        [dict setObject:@(self.delete_id) forKey:@"id"];
    }
    return dict;
}



@end
