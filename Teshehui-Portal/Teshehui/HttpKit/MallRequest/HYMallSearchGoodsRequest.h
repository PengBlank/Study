//
//  HYMallSearchGoodRequest.h
//  Teshehui
//
//  Created by HYZB on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYMallSearchGoodsRequest : CQBaseRequest

//扩展参数
@property (nonatomic, copy) NSString *categoryId;    //分类id
@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, copy) NSArray *brandIds;

//关键字, 0否，1是
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *keywordParseType;

@property (nonatomic,copy) NSString *highPrice;     //价格
@property (nonatomic,copy) NSString *lowPrice;

/*
 * 搜索类型  ：
 10：关键词搜索；
 20：分类列表搜索；
 30：品牌列表搜索
 40：店铺列表搜索
 */
@property (nonatomic,copy) NSString *searchType;  //

//排度：10销量，11介格，12上架时间, 0：desc, 1:asc
@property (nonatomic,copy) NSString *orderBy;       //排序字段名
@property (nonatomic,copy) NSString *order;         //排序

@property (nonatomic, assign) NSInteger pageSize;   //分页
@property (nonatomic, assign) NSInteger pageNo;

- (id)initReqWithStoreId:(NSString *)storeid;
- (id)initReqWithCategoryId:(NSString *)categoryId;
- (id)initReqWithBrandIds:(NSString *)brandIds;
- (id)initReqWithParamStr:(NSString *)paramStr;

@end