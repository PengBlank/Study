//
//  HYChannelPageResponse.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYChannelPageResponse.h"

@implementation HYChannelPageResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *dataInfo = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        self.channelTitle = GETOBJECTFORKEY(dataInfo, @"channelTitle", NSString);
        NSArray *boardArray = GETOBJECTFORKEY(dataInfo, @"channelBoardList", NSArray);
        if (boardArray.count > 0)
        {
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (id obj in boardArray)
            {
                HYMallChannelBoard *board = [[HYMallChannelBoard alloc] initWithDictionary:obj
                                                                               error:nil];
                [muArray addObject:board];
            }
            self.boardList = [muArray copy];
        }
        NSArray *cateArray = GETOBJECTFORKEY(dataInfo, @"categoryList", NSArray);
        if ([cateArray count] > 0)
        {
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (id obj in cateArray)
            {
                HYChannelCategory *board = [[HYChannelCategory alloc] initWithDictionary:obj
                                                                               error:nil];
                [muArray addObject:board];
            }
            self.cateList = [muArray copy];
        }
    }
    
    return self;
}

@end

@implementation HYChannelCategory



@end
