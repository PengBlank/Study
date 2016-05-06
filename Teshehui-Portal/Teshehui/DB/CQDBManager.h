//
//  CQDBManager.h
//  Teshehui
//
//  Created by ChengQian on 13-11-21.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"


@interface CQDBManager : NSObject
{
    FMDatabaseQueue *_queue;
}

@property (nonatomic, retain, readonly) FMDatabaseQueue *queue;

+(CQDBManager *)sharedInstance;

//清理数据
- (BOOL)cleanData;

@end
