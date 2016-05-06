//
//  HYMakeWishCommitRequest.h
//  Teshehui
//
//  Created by HYZB on 15/11/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYMakeWishCommitRequest : CQBaseRequest

@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *contactMobile;
@property (nonatomic, copy) NSString *wishTitle;
@property (nonatomic, copy) NSString *wishContent;
@property (nonatomic, strong) NSArray *uploadfile;


@end
