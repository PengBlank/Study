//
//  CQFilghtOrderQuery.h
//  ComeHere
//
//  Created by ChengQian on 13-11-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtBaseRequest.h"

@interface CQFilghtOrderQuery : CQFilghtBaseRequest

@property (nonatomic, copy) NSString *UserID;
@property (nonatomic, assign) int page;

@end
