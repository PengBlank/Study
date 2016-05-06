//
//  HYHotelImageResponse.h
//  Teshehui
//
//  Created by RayXiang on 14-11-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYHotelPictureInfo.h"

@interface HYHotelImageResponse : CQBaseResponse

@property (nonatomic, strong) NSArray *imageList;

@end
