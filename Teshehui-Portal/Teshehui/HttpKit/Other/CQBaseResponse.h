//
//  CQBaseResponse.h
//  Teshehui
//
//  Created by ChengQian on 13-11-15.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQBaseResponse : NSObject

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *rspDesc;
@property (nonatomic, strong) NSString *suggestMsg;
@property (nonatomic, assign) NSInteger code;

@property (nonatomic, readonly, strong) NSDictionary *jsonDic;

- (id)initWithJsonDictionary:(NSDictionary*)dictionary;

@end
