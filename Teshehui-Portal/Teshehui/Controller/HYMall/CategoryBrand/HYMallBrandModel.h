//
//  HYMallBrandModel.h
//  Teshehui
//
//  Created by Kris on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYMallBrandSecModel.h"

@interface HYMallBrandModel : JSONModel

@property (nonatomic, copy) NSString *cateName;
@property (nonatomic, copy) NSArray <HYMallBrandSecModel> *brandList;

@end

/*
 {
 "status": 200,
 "message": "Success!",
 "code": null,
 "suggestMsg": null,
 "timestamp": "1458720937846",
 "data": [
 {
 "serialVersionUID": 2941768502180872700,
 "id": 5094,
 "cateName": "服饰鞋包",
 "brandList": [
 {
 "brandCode": "AU05095",
 "brandName": "test",
 "logoPath": "http://image.teshehui.com/brand/95/AU05095/bdlogo_20160002.jpg?date=1458626338531",
 "sortNum": 9
 },
 {
 "brandCode": "FR04189",
 "brandName": "爱马仕",
 "sortNum": 8
 }
 ],
 "sortNum": 9
 },
 {
 "serialVersionUID": 2941768502180872700,
 "id": 5095,
 "cateName": "数码家电",
 "brandList": [
 {
 "brandCode": "AU05103",
 "brandName": "test8",
 "logoPath": "http://image.teshehui.com/brand/03/AU05103/bdlogo_20160001.jpg",
 "sortNum": 9
 }
 ],
 "sortNum": 8
 }
 ]
 }
 */