//
//  HYStartAdsViewModel.m
//  Teshehui
//
//  Created by Kris on 16/1/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYStartAdsViewModel.h"

@implementation HYStartAdsViewModel

+(instancetype)viewModelWithSubjects:(NSArray *)subjects
{
    return [[self alloc]initWithSubjects:subjects];
}

-(instancetype)initWithSubjects:(NSArray <HYMallHomeItem *>*)subjects
{
    if (self = [super init])
    {
        if (subjects.count > 0)
        {
            HYMallHomeItem *item = subjects[0];
            self.item = item;
            
            NSString *temp = [item.pictureUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *pic = [NSURL URLWithString:temp];
            if (pic)
            {
                self.picUrl = pic;
            }
            temp = [item.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *tap = [NSURL URLWithString:temp];
            if (tap)
            {
                self.tapUrl = tap;
            }

        }
    }
    return self;
}
@end
