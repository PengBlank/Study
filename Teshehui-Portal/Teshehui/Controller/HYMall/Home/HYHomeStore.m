//
//  HYHomeStore.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/15.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYHomeStore.h"

@implementation HYHomeStore

+ (NSString *)cachePath
{
    NSArray *urls = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if (urls.count > 0)
    {
        NSString *directoryPath = [urls objectAtIndex:0];
        NSString *filePath = [directoryPath stringByAppendingPathComponent:@"homecache.dat"];
        return filePath;
    }
    return nil;
}

+ (void)cacheHomeItems:(NSArray*)items
{
    NSString *path = [self cachePath];
    if (path)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:items];
            NSError *err;
            BOOL succ =  [data writeToFile:path options:NSDataWritingAtomic error:&err];
            if (succ) {
                DebugNSLog(@"首页数据缓存成功");
            }
        });
    }
}
+ (NSArray *)getCachedItems
{
    NSString *path = [self cachePath];
    if (path)
    {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSArray *items = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return items;
    }
    return nil;
}

@end
