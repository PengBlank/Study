//
//  PTAppStoreHelper.h
//  Putao
//
//  Created by ChengQian on 12-10-13.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

/**
 * 处理应用在appstore的相关信息
 */

#import <Foundation/Foundation.h>

@interface PTAppStoreHelper : NSObject
{
    NSMutableData *_returnData;  //请求返回的数据
    NSString *_trackViewUrl;    //下载地址
    
    BOOL needAlert;     //是否需要提醒，在手动更新的时候不管是否有新的，都应该提示
    
    BOOL _forceUpdate;
}

+ (PTAppStoreHelper *)defaultAppStoreHelper;

- (void)checkNewVersionNeedAlert:(BOOL)alert;
- (void)checkForceupdate;

@end
