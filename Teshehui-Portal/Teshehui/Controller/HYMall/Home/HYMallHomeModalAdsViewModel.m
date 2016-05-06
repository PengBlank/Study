//
//  HYMallHomeModalAdsViewModel.m
//  Teshehui
//
//  Created by Kris on 16/1/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallHomeModalAdsViewModel.h"

@implementation HYMallHomeModalAdsViewModel

+ (instancetype)viewModelWithSubject:(HYMallHomeBoard *)subject
{
    return [[HYMallHomeModalAdsViewModel alloc] initWithSubject:subject];
}

-(instancetype)initWithSubject:(HYMallHomeBoard*)subject
{
    if (self = [super init])
    {
        self.board = subject;
        self.items = subject.programPOList;
        NSMutableArray *urls = [NSMutableArray array];
        NSMutableArray *taps = [NSMutableArray array];
        for (HYMallHomeItem *obj in self.items)
        {
            NSString *temp = [obj.pictureUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:temp];
            if (url)
            {
                [urls addObject:url];
            }
       
            temp = [obj.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *tap = [NSURL URLWithString:temp];
            if (tap)
            {
               [taps addObject:tap];
            }
     
        }
        self.picUrls = urls;
        self.tapUrls = taps;
    }
    return self;
}
@end
