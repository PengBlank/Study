//
//  HYMallHomeBoard.h
//  Teshehui
//
//  Created by HYZB on 15/5/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYMallHomeItem.h"
#import "HYMallHomeSections.h"

@interface HYMallHomeBoard : JSONModel

@property (nonatomic, copy) NSString *boardCode;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *programShowNum;
@property (nonatomic, copy) NSString *programTotalNum;
@property (nonatomic, copy) NSString *oneDayShowMaxCount;
@property (nonatomic, strong) NSArray <HYMallHomeItem>* programPOList;
@property (nonatomic, assign, readonly) HYHomeBoardType boardType;
@property (nonatomic, copy) NSString *lastUpdateTime;

@property (nonatomic, strong) NSDate *lastUpdateDate;

@end




/*
 "boardCode":"02",
 "title":"版块标题02",
 "pictureUrl":"http://www.teshehui.com/02.jpg",
 "description":"版块描述02",
 "programPOList":[
 {
 "name":"测试单品",
 "type":"01",
 "url":"businessType=01&productId=112&version=1.0.0",
 "pictureUrl":"http://www.t.teshehui.com/data/files/mall/template/201305090858078656.jpg",
 "price":"1000",
 "points":"200"
 },
 {
 "name":"测试单品",
 "type":"01",
 "url":"businessType=01&productId=112&version=1.0.0",
 "pictureUrl":"http://www.t.teshehui.com/data/files/mall/template/201305090858078656.jpg",
 "price":"1000",
 "points":"200"
 },
 {
 "name":"测试单品",
 "type":"01",
 "url":"businessType=01&productId=112&version=1.0.0",
 "pictureUrl":"http://www.t.teshehui.com/data/files/mall/template/201305090858078656.jpg",
 "price":"1000",
 "points":"200"
 },
 {
 "name":"测试单品",
 "type":"01",
 "url":"businessType=01&productId=112&version=1.0.0",
 "pictureUrl":"http://www.t.teshehui.com/data/files/mall/template/201305090858078656.jpg",
 "price":"1000",
 "points":"200"
 }
 ]
*/