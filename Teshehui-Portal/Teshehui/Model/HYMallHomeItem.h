//
//  HYMallHomeItem.h
//  Teshehui
//
//  Created by HYZB on 15/5/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYMallHomeSections.h"

@protocol HYMallHomeItem @end

@interface HYMallHomeItem : JSONModel

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* type;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* pictureUrl;
@property (nonatomic, copy) NSString* pictureUrlFor4s;
@property (nonatomic, copy) NSString* price;
@property (nonatomic, copy) NSString* points;
@property (nonatomic, copy) NSString* startTime;
@property (nonatomic, copy) NSString* endTime;
@property (nonatomic, copy) NSString* businessType;
@property (nonatomic, copy) NSString* advertMessage;
@property (nonatomic, copy) NSString* vidoUrl;
@property (nonatomic, copy) NSString* vidoThumbnailUrl;
@property (nonatomic, copy) NSString* expensived;
@property (nonatomic, copy) NSString* bannerCode;
@property (nonatomic, copy) NSString *marketPrice;
@property (nonatomic, copy) NSString* tagSelectedImg;
@property (nonatomic, copy) NSString* tagSelectedFlag;

@property (nonatomic, assign) HYHomeItemType itemType;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *channelCode;
/**
 * 赚现金券业务类型code
 */
@property (nonatomic, copy) NSString *code;

@end


/*
 name:栏目名称;可能涉及商品名称、分类名称、店铺名称、品牌名称、活动名称、搜索关键字等
 type:栏目类型;01:单品；02:活动；03:店铺列表；04:分类列表；05:品牌列表；06:搜索；07:网页
 url:跳转URL;
 pictureUrl:显示图片地址;
 description:栏目描述;
 
 类型为单品的时候使用
 price:商品价格;
 points:TB价格;
 */

/*
 "name":"测试单品",
 "type":"01",
 "url":"businessType=01&productId=112&version=1.0.0",
 "pictureUrl":"http://www.t.teshehui.com/data/files/mall/template/201305090858078656.jpg",
 "price":"1000",
 "points":"200"
*/