//
//  HYMallGoodImageInfo.h
//  Teshehui
//
//  Created by ichina on 14-2-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"

@interface HYMallGoodImageInfo : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *image_id;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *sort_order;
@property (nonatomic, copy) NSString *file_id;
@property (nonatomic, copy) NSString *thumbnail_middle;
@property (nonatomic, copy) NSString *thumbnail_small;

@end

/*
 {
 "image_id": "121",
 "goods_id": "35",
 "image_url": "http:\/\/www.teshehui.com\/data\/files\/store_68\/goods_140\/201401101115401363.jpg",
 "thumbnail": "http:\/\/www.teshehui.com\/data\/files\/store_68\/goods_140\/small_201401101115401363.jpg",
 "sort_order": "1",
 "file_id": "337"
 }
*/