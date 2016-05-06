//
//  CQAttListObject.m
//  Teshehui
//
//  Created by ChengQian on 13-11-13.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQAttListObject.h"

@implementation CQAttImpression

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.impressionId = [data objectForKey:@"impressionId"];
        self.impressionName = [data objectForKey:@"impressionName"];
    }
    
    return self;
}

@end

@implementation CQAttSuitherd

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.suitherdId = [data objectForKey:@"suitherdId"];
        self.suitherdName = [data objectForKey:@"suitherdName"];
    }
    
    return self;
}

@end

@implementation CQAttTheme

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.themeId = [data objectForKey:@"themeId"];
        self.themeName = [data objectForKey:@"themeName"];
    }
    
    return self;
}

@end

@implementation CQAttListObject

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        NSArray *themes = [data objectForKey:@"theme"];
        if ([themes count] > 0)
        {
            NSMutableArray *muthemes = [[NSMutableArray alloc] init];
            for (id data in themes)
            {
                CQAttTheme *theme = [[CQAttTheme alloc] initWithDataInfo:data];
                [muthemes addObject:theme];
            }
            
            self.themeList = muthemes;
        }
       
        NSArray *suitherds = [data objectForKey:@"suitherd"];
        if ([suitherds count] > 0)
        {
            NSMutableArray *musuitherds = [[NSMutableArray alloc] init];
            for (id data in suitherds)
            {
                CQAttSuitherd *suitherd = [[CQAttSuitherd alloc] initWithDataInfo:data];
                [musuitherds addObject:suitherd];
            }
            
            self.suitherdList = musuitherds;
        }
        
        NSArray *impressions = [data objectForKey:@"impression"];
        if ([impressions count] > 0)
        {
            NSMutableArray *muimpressions = [[NSMutableArray alloc] init];
            for (id data in impressions)
            {
                CQAttImpression *impression = [[CQAttImpression alloc] initWithDataInfo:data];
                [muimpressions addObject:impression];
            }
            
            self.impressionList = muimpressions;
        }
        
        /*
         NSString *sceneryName;	//景点名称	string
         NSString *sceneryId	;	//景点Id	int
         NSString *sceneryAddress	;	//景点地址	string
         NSString *scenerySummary	;	//景点简介	string
         NSString *imgPath	;	//图片地址	string	测试环境下
         NSString *provinceId	;	//省份Id	int
         NSString *provinceName	;	//省份名称	string
         NSString *cityId	;	//城市Id	int
         NSString *cityName	;	//城市名称	string
         NSString *gradeId	;	//等级ID	int
         NSString *commentCount	;	//点评数	int
         NSString *questionCount;	//	问答数	int
         NSString *blogCount;	//	博客数量	int
         NSString *viewCount;	//	浏览次数	int
         NSString *distance;	//	距离	decimal	和查询标签或坐标的距
         NSString *name;	//	景区别名	string
         */
        
        self.sceneryName = GETOBJECTFORKEY(data, @"sceneryName", [NSString class]);
        self.sceneryId = GETOBJECTFORKEY(data, @"sceneryId", [NSString class]);
        self.sceneryAddress = GETOBJECTFORKEY(data, @"sceneryAddress", [NSString class]);
        self.scenerySummary = GETOBJECTFORKEY(data, @"scenerySummary", [NSString class]);
        self.imgPath = GETOBJECTFORKEY(data, @"imgPath", [NSString class]);
        self.provinceId = GETOBJECTFORKEY(data, @"provinceId", [NSString class]);
        self.provinceName = GETOBJECTFORKEY(data, @"provinceName", [NSString class]);
        self.cityId = GETOBJECTFORKEY(data, @"cityId", [NSString class]);
        self.cityName = GETOBJECTFORKEY(data, @"cityName", [NSString class]);
        self.gradeId = GETOBJECTFORKEY(data, @"gradeId", [NSString class]);
        self.commentCount = GETOBJECTFORKEY(data, @"commentCount", [NSString class]);
        self.questionCount = GETOBJECTFORKEY(data, @"questionCount", [NSString class]);
        self.blogCount = GETOBJECTFORKEY(data, @"blogCount", [NSString class]);
        self.viewCount = GETOBJECTFORKEY(data, @"viewCount", [NSString class]);
        self.distance = GETOBJECTFORKEY(data, @"distance", [NSString class]);
        self.name = GETOBJECTFORKEY(data, @"name", [NSString class]);
        self.adviceAmount = GETOBJECTFORKEY(data, @"adviceAmount", [NSString class]);
    }
    
    return self;
}

@end
