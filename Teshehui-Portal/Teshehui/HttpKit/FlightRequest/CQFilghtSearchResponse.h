//
//  CQFilghtSearchResponse.h
//  ComeHere
//
//  Created by ChengQian on 13-11-17.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtResponseBase.h"
#import "HYFilghtDetail.h"

@interface CQFilghtSearchResponse : CQFilghtResponseBase

@property (nonatomic, copy) NSString *Status;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *fromname;
@property (nonatomic, copy) NSString *toname;
@property (nonatomic, strong) NSArray *Flight;

@end
