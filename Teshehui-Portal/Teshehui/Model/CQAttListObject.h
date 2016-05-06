//
//  CQAttListObject.h
//  Teshehui
//
//  Created by ChengQian on 13-11-13.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

@interface CQAttTheme : NSObject<CQResponseResolve>
@property (nonatomic, copy) NSString *themeId;	//	景点主题Id	int	如1
@property (nonatomic, copy) NSString *themeName;	//	景点主题名称	string	如休闲游

@end

@interface CQAttSuitherd : NSObject<CQResponseResolve>
@property (nonatomic, copy) NSString *suitherdId;	//	适合人群Id	int	如1
@property (nonatomic, copy) NSString *suitherdName;	//	适合人群名称	string	如家庭旅游
@end

@interface CQAttImpression: NSObject
@property (nonatomic, copy) NSString *impressionId;	//	游客印象Id	int
@property (nonatomic, copy) NSString *impressionName;	//	游客印象名称	string	如:空气清新
@end

@interface CQAttListObject : NSObject<CQResponseResolve>
{
    
}

@property (nonatomic, copy) NSString *sceneryName;	//景点名称	string
@property (nonatomic, copy) NSString *sceneryId	;	//景点Id	int
@property (nonatomic, copy) NSString *sceneryAddress	;	//景点地址	string
@property (nonatomic, copy) NSString *scenerySummary	;	//景点简介	string
@property (nonatomic, copy) NSString *imgPath	;	//图片地址	string	测试环境下返回固定的测试Demo图片
@property (nonatomic, copy) NSString *provinceId	;	//省份Id	int
@property (nonatomic, copy) NSString *provinceName	;	//省份名称	string
@property (nonatomic, copy) NSString *cityId	;	//城市Id	int
@property (nonatomic, copy) NSString *cityName	;	//城市名称	string
@property (nonatomic, copy) NSString *gradeId	;	//等级ID	int
@property (nonatomic, copy) NSString *commentCount	;	//点评数	int
@property (nonatomic, copy) NSString *questionCount;	//	问答数	int
@property (nonatomic, copy) NSString *blogCount;	//	博客数量	int
@property (nonatomic, copy) NSString *viewCount;	//	浏览次数	int
@property (nonatomic, copy) NSString *distance;	//	距离	decimal	和查询标签或坐标的距离(单位:米) 注意 不精确(当使用范围限定参数时才有效)
@property (nonatomic, strong) NSArray *themeList;	//	景点主题列表
@property (nonatomic, strong) NSArray *suitherdList;	//	适合人群列表
@property (nonatomic, strong) NSArray *impressionList;	//	游客印象列表

@property (nonatomic, copy) NSString *name;	//	景区别名	string
@property (nonatomic, copy) NSString *adviceAmount;	//	最低价格	string
@end
