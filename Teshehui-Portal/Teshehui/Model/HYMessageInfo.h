//
//  HYMessageInfo.h
//  Teshehui
//
//  Created by ichina on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQResponseResolve.h"

@interface HYMessageInfo : NSObject<CQResponseResolve>

@property(nonatomic,copy)NSString* add_time;

@property(nonatomic,copy)NSString* content;

@property(nonatomic,copy)NSString* from_id;

@property(nonatomic,copy)NSString* msg_id;

@property(nonatomic,copy)NSString* Msgnew;

@property(nonatomic,copy)NSString* parent_id;

@property(nonatomic,copy)NSString* status;

@property(nonatomic,copy)NSString* title;

@property(nonatomic,copy)NSString* to_id;

@property(nonatomic,copy)NSString* user_name;

@end

/*
 {
 "add_time" = 1393810131;
 content = "\U6d4b\U8bd5";
 "from_id" = 0;
 "last_update" = 1393810131;
 "msg_id" = 26;
 new = 1;
 "parent_id" = 0;
 status = 3;
 title = "";
 "to_id" = 102;
 "user_name" = "system_message";
 }
*/