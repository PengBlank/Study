//
//  HYMallGuijiupeiOrderLogItem.h
//  Teshehui
//
//  Created by Kris on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol HYMallGuijiupeiOrderLogItem

@end

@interface HYMallGuijiupeiOrderLogItem : JSONModel

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *operationName;
@property (nonatomic, copy) NSString *createTime;

@end
