//
//  HYExpressInfo.h
//  Teshehui
//
//  Created by HYZB on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 *  快递
 */
#import "JSONModel.h"

@interface HYExpressInfo : JSONModel

@property (nonatomic, strong) NSString *expressId;  // 快递模板ID
@property (nonatomic, strong) NSString *expressName;  //快递模板名称
@property (nonatomic, assign) BOOL is_support;  //1：支持配送，0：不支持配送
@property (nonatomic, assign) BOOL is_default;  //1：表示店铺默认快递模板
@property (nonatomic, copy) NSString *price;  //运费

@end
