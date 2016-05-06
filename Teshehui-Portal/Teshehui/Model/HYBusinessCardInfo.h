//
//  HYBusinessCardInfo.h
//  Teshehui
//
//  Created by HYZB on 14-10-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NAME @"姓名"
#define ORG @"公司"
#define TITLE @"职位"
#define EMAIL @"邮箱"
#define ADD @"地址"
#define TEL @"电话"

@interface HYBusinessCardInfo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *org;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) NSMutableArray *numberList;
@property (nonatomic, assign, readonly) BOOL hasCache;
@property (nonatomic, assign, readonly) BOOL canAddNumber;
@property (nonatomic, copy, readonly) NSString *QRDesctription;

+ (instancetype)initWithDiskCache;
+ (void)cleanCache;
- (void)saveToDisk:(NSError **)error;
@end
