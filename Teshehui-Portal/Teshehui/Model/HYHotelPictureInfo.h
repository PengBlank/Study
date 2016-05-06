//
//  HYHotelPictureInfo.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店的图片
 */

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

@interface HYHotelPictureInfo : NSObject<CQResponseResolve>

//@property (nonatomic, copy) NSString *pID;   //数据库中唯一ID
//@property (nonatomic, copy) NSString *HotelID;  //酒店ID
//@property (nonatomic, copy) NSString *PicTitle;   //图片提示信息
//@property (nonatomic, copy) NSString *HotelPic550URL;  //大图
//@property (nonatomic, copy) NSString *HotelPic78URL;   //小图
//@property (nonatomic, copy) NSString *HotelPic175URL;  //中图

@property (nonatomic, strong) NSString *hotelImageId;
@property (nonatomic, strong) NSString *imageType;  //类型，大堂、客房等
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *extenedInfo;    //扩展字段
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *bigUrl;
@property (nonatomic, strong) NSString *midUrl;


@end
