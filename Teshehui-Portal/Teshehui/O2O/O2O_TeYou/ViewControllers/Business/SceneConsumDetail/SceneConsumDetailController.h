//
//  SceneConsumDetailController.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//
/**
 *  //这个页面主要是继承“中心”的滑动返回和自定义导航栏
 *  //设置导航栏的透明度
 *  //其他数据绑定及操作等功能都在子控制器中
 */

#import "HYMallViewBaseController.h"

@interface SceneConsumDetailController : HYMallViewBaseController

@property ( nonatomic , weak) NSString *packId;
@property ( nonatomic , strong) NSString *cityName;
@property ( nonatomic , strong) UIImage *shareImage;
@property ( nonatomic , assign) NSInteger pageType;

@end
