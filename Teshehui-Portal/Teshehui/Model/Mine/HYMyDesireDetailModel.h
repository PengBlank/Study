//
//  HYMyDesireDetailModel.h
//  Teshehui
//
//  Created by HYZB on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYMyDesireDetailModel : JSONModel

@property (nonatomic, copy) NSString *desire_id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *contactMobile;
@property (nonatomic, copy) NSString *wishTitle;
@property (nonatomic, copy) NSString *wishContent;
@property (nonatomic, strong) NSMutableArray *wishPicList;
@property (nonatomic, copy) NSString *wishTime;
@property (nonatomic, copy) NSString *replyContent;
@property (nonatomic, strong) NSMutableArray *wishDetailPOList;
@property (nonatomic, copy) NSString *replyTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *statusStr;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;

/*
 "id":"编号",
 "userId":"用户ID",
 "contactName":"联系人",
 "contactMobile":"联系人手机号",
 "wishTitle":"愿望标题",
 "wishContent":"愿望内容",
 "wishPicList":"愿望相关图片链表,最多三个",
 "wishTime":"许愿时间",
 "replyContent":"客服回复",
 "replyTime":"客服回复时间",
 "status":"状态 0:待回复， 1：已实现，2：未实现",
 "statusStr":"愿望状态字符串 0:待回复， 1：已实现，2：未实现",
 "createTime":"创建时间",
 "updateTime":"修改时间"
 */

@end
