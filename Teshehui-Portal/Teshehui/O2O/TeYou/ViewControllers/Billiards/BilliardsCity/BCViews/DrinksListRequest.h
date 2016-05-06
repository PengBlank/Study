//
//  DrinksListRequest.h
//  Teshehui
//
//  Created by wujianming on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQBaseRequest.h"

@interface DrinksListRequest : CQBaseRequest

@property (nonatomic,strong) NSString *merId;

@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageIndex;

@end
