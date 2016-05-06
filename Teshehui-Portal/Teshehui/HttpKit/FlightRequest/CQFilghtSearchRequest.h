//
//  CQFilghtSearchRequest.h
//  ComeHere
//
//  Created by ChengQian on 13-11-17.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtBaseRequest.h"

@interface CQFilghtSearchRequest : CQFilghtBaseRequest

//http://app.bnx6688.com/airflight/?uid=bnxapp&key=8g92f8e0-65b9-45aa-a2d2-1c4b9e2bd587&OrgCity=PEK&DstCity=SHA&OffDate=2013-12-08

/*
 Uid	True	String	授权帐号
 Key	True	String	授权密码
 OrgCity	True	String	出发机场代码
 DstCity	True	String	到达机场代码
 OffDate	True	String	出发日期
 */

//必须参数
@property (nonatomic, copy) NSString *Uid;  //授权帐号
@property (nonatomic, copy) NSString *Key;
@property (nonatomic, copy) NSString *OrgCity;
@property (nonatomic, copy) NSString *DstCity;
@property (nonatomic, copy) NSString *OffDate;

@end
