//
//  CQFilghtSearchResponse.m
//  ComeHere
//
//  Created by ChengQian on 13-11-17.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtSearchResponse.h"

@implementation CQFilghtSearchResponse
- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        self.Status = GETOBJECTFORKEY(dictionary, @"Status", [NSString class]);
        self.date = GETOBJECTFORKEY(dictionary, @"Carrier", [NSString class]);
        self.from = GETOBJECTFORKEY(dictionary, @"from", [NSString class]);
        
        self.to = GETOBJECTFORKEY(dictionary, @"to", [NSString class]);
        self.toname = GETOBJECTFORKEY(dictionary, @"toname", [NSString class]);

        NSArray *filghs = GETOBJECTFORKEY(dictionary, @"Flight", [NSArray class]);
        
        if ([filghs count] > 0)
        {
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in filghs)
            {
                HYFilghtDetail *f = [[HYFilghtDetail alloc] initWithDataInfo:dic];
                [muArray addObject:f];
            }
            
            self.Flight = muArray;
        }
    }
    
    return self;
}


@end
