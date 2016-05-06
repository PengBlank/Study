//
//  HYMallAllBrandModel.h
//  Teshehui
//
//  Created by Kris on 16/3/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYMallAllBrandModel : JSONModel

@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *brandCode;
@property (nonatomic, copy) NSString *firstChar;

@end

//{"brandId":5065,"brandName":"泽贝酷","brandCode":"CN05065","firstChar":"Z"}