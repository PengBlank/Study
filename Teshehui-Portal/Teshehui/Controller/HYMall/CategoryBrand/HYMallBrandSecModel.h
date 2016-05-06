//
//  HYMallBrandSecModel.h
//  Teshehui
//
//  Created by Kris on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol HYMallBrandSecModel <NSObject>
@end

@interface HYMallBrandSecModel : JSONModel

@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *brandCode;
@property (nonatomic, copy) NSString *logoPath;

@end
