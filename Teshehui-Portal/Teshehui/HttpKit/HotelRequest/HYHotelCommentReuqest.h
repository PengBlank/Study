//
//  HYHotelCommentReuqest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 获取酒店评价接口
 */

#import "CQBaseRequest.h"

@interface HYHotelCommentReuqest : CQBaseRequest

//必须参数
@property (nonatomic, copy) NSString *HotelID;  //酒店ID
@property (nonatomic, assign) NSInteger num_per_page;  //INT	请求条数
@property (nonatomic, assign) NSInteger page;  //INT	请求的页码

//可选参数

@end
