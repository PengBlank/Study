//
//  HYAccountBalanceResponse.h
//  Teshehui
//
//  Created by Kris on 15/8/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "JSONModel.h"


@interface HYAccountBalance:JSONModel

@property (nonatomic, copy) NSString *tradeNumber;
@property (nonatomic, copy) NSString *businessTypeName;
@property (nonatomic, copy) NSString *operateTypeName;
@property (nonatomic, copy) NSString *tradeOrderNumber;
@property (nonatomic, copy) NSString *tradeDescription;
@property (nonatomic, copy) NSString *tradeAmount;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, copy) NSString *operateTypeCode;
@property (nonatomic, copy) NSString *iconUrl;

@end

@interface HYAccountBalanceResponse : CQBaseResponse

@property (nonatomic, strong) NSArray *accountBalanceInfos;

@end
//"具体字段data": [
//             
//             /** 总记录数 */
//             private Integer totalCount;
//             /** 分页页码 */
//             private Integer pageNo;
//             /** 分页记录数 */
//             private Integer pageSize;
//             /** 实际数据项 */
//             private Collection<T> items;
//             
//             
//             /** 交易唯一标识 */
//             private Long id;
//             /** 交易流水号 */
//             private String tradeNumber;
//             /** 交易用户标识 */
//             private Long userId;
//             /** 交易关联的用户名称 */
//             private String userName;
//             /** 交易关联的用户类型 */
//             private String userType;
//             /** 交易关联的客户终端类型类型 */
//             private String clientTypeCode;
//             /** 交易终端类型名称 */
//             private String clientTypeName;
//             /** 交易业务类型 */
//             private String businessTypeCode;
//             /** 交易业务类型名称 */
//             private String businessTypeName;
//             /** 交易的币种类型 */
//             private String currencyTypeCode;
//             /** 交易的币种类型名称 */
//             private String currencyTypeName;
//             /** 交易的操作类型 */
//             private String operateTypeCode;
//             /** 交易的操作类型名称 */
//             private String operateTypeName;
//             /** 交易关联的订单编号 */
//             private String tradeOrderNumber;
//             /** 变更金额 */
//             private Long tradeAmount;
//             /** 交易变更加密的金额 */
//             private String amountEncrypt;
//             /** 交易描述 */
//             private String tradeDescription;
//             /** 交易创建时间 */
//             private Date createTime;
//             /** 交易更新时间 */
//             private Date updateTime;
//             
//             ]
//}
