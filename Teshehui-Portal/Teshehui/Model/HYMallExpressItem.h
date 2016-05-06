//
//  HYMallExpressItem.h
//  Teshehui
//
//  Created by Kris on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol HYMallExpressItem

@end


@interface HYMallExpressItem : JSONModel

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *context;
@property (nonatomic, assign) CGFloat contentHeight;

- (CGFloat)contentHeight;
@end
