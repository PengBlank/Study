//
//  TYAnalyseScenePageReq.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYAnalyticsBaseReq.h"

@interface TYAnalyseScenePageReq : HYAnalyticsBaseReq

@property (nonatomic,copy)   NSString   *nowt; //跳转之后的页面标识符
@property (nonatomic,assign) NSInteger obj_type; //页面类型
@property (nonatomic,copy)   NSString   *ref_page_id; //当前页面表舒服
@property (nonatomic,copy)   NSString   *goods_id; //套餐Id

@end
