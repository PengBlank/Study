//
//  HYCardTypeResponse.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCardTypeResponse.h"

@interface HYCardTypeResponse ()

@property (nonatomic, strong) NSArray *cardList;

@end

@implementation HYCardTypeResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSArray *list = GETOBJECTFORKEY(dictionary, @"data", [NSArray class]);
        
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in list)
        {
            HYCardType *c = [[HYCardType alloc] initWithDataInfo:dic];
            [muArray addObject:c];
        }
        
        self.cardList = muArray;
    }
    
    return self;
}

@end
