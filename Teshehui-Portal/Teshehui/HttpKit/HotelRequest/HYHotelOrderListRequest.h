//
//  HYHotelOrderListRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店列表接口
 */

#import "CQBaseRequest.h"
#import "HYHotelOrderListResponse.h"

@interface HYHotelOrderListRequest : CQBaseRequest

//必须参数
//@property (nonatomic, copy) NSString *user_id;  //商城用户ID
//@property (nonatomic, assign) int num_per_page;  //INT	请求条数
//@property (nonatomic, assign) int page;  //INT	请求的页码
//新增Java参数
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *isEnterprise;


//可选参数
@property (nonatomic, assign) NSInteger is_enterprise;  //企业账号查看企业员工因公消费.is_enterprise=1

@end
