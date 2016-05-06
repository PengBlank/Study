//
//  SceneListRequest.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface SceneListRequest : CQBaseRequest
@property (nonatomic, strong) NSString  *cityName  ;
@property (nonatomic, strong) NSString  *calId;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@end
