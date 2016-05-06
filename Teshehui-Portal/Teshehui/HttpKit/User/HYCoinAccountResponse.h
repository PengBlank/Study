//
//  HYCoinAccountResponse.h
//  Teshehui
//
//  Created by Kris on 15/5/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "JSONModel.h"
//@class HYCoinAccount;
@interface HYCoinAccount : JSONModel

@property (nonatomic, assign, readonly) CGFloat cellHeight;

@property (nonatomic, assign, readonly) CGRect iconViewF;
@property (nonatomic, assign, readonly) CGRect inFoTextLabelF;
@property (nonatomic, assign, readonly) CGRect dateTextLabelF;
@property (nonatomic, assign, readonly) CGRect coinLabelF;

@property (nonatomic, strong, readonly) NSDate *createdDate;

@property (nonatomic, copy) NSString *operateUserType;
@property (nonatomic, copy) NSString *operateUserId;
@property (nonatomic, copy) NSString *operateUserName;
@property (nonatomic, copy) NSString *clientType;
@property (nonatomic, copy) NSString *businessType;
@property (nonatomic, copy) NSString *operateType;
@property (nonatomic, copy) NSString *sourceUserId;
@property (nonatomic, copy) NSString *targetUserId;
@property (nonatomic, copy) NSString *tradeOrderNumber;
@property (nonatomic, copy) NSString *tradeAmount;
@property (nonatomic, copy) NSString *tradeType;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, copy) NSString *updatedTime;
@property (nonatomic, copy) NSString *accountType;
@property (nonatomic, copy) NSString *tradeDescription;
@property (nonatomic, copy) NSString *iconUrl;

//@property (nonatomic, copy) NSString *logs;

@end

@interface HYCoinAccountResponse : CQBaseResponse

@property (nonatomic, strong) HYCoinAccount *coinAccount;
@property (nonatomic, strong) NSMutableArray *msgDataList;
@end


