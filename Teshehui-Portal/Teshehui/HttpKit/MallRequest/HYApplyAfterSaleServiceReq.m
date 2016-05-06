//
//  HYApplyAfterSaleServiceReq.m
//  Teshehui
//
//  Created by Kris on 15/10/14.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYApplyAfterSaleServiceReq.h"
#import "HYAfterSaleServiceResponse.h"
#import "JSONKit_HY.h"

@implementation HYApplyAfterSaleServiceReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.httpMethod = @"POST";
        self.businessType = @"01";
        _isUpdate = NO;
    }
    
    return self;
}

- (NSString *)interfaceURL
{
    if (_isUpdate) {
        return [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"afterSeller/updateReturnFlow.action"];
    }
    else {
        return [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"afterSeller/applyReturnFlow.action"];
    }
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([_contactName length] > 0)
        {
            [newDic setObject:_contactName forKey:@"contactName"];
        }
        
        if ([_contactMobile length] > 0)
        {
            [newDic setObject:_contactMobile forKey:@"contactMobile"];
        }
        if ([_orderCode length] > 0)
        {
            [newDic setObject:_orderCode forKey:@"orderCode"];
        }
        if (_operationType)
        {
            [newDic setObject:[NSString stringWithFormat:@"%ld",_operationType]
                       forKey:@"operationType"];
        }
        //地址信息
        if (_contactProvinceCode)
        {
            [newDic setObject:_contactProvinceCode forKey:@"contactProvinceCode"];
        }
        if (_contactCityCode)
        {
            [newDic setObject:_contactCityCode forKey:@"contactCityCode"];
        }
        if (_contactRegionCode)
        {
            [newDic setObject:_contactRegionCode forKey:@"contactRegionCode"];
        }
        if (_contactPostCode)
        {
            [newDic setObject:_contactPostCode forKey:@"contactPostCode"];
        }
        if (_contactAddress)
        {
            [newDic setObject:_contactAddress forKey:@"contactAddress"];
        }
        if (_returnFlowCode) {
            [newDic setObject:_returnFlowCode forKey:@"returnFlowCode"];
        }
        //详细评论信息
        if ([_orderItemId length]>0
            && _quantity
            && [_remark length]>0)
        {
            NSDictionary *dict = @{@"orderItemId":_orderItemId,
                                   @"quantity":[NSString stringWithFormat:@"%ld",_quantity],
                                   @"remark":_remark};
            if (_returnFlowDetailId.length > 0) {
                NSMutableDictionary *mudict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [mudict setObject:_returnFlowDetailId forKey:@"returnFlowDetailId"];
                dict = [NSDictionary dictionaryWithDictionary:mudict];
            }
            NSArray *array = @[dict];
            if (array.count > 0)
            {
                NSString *mallReturnFlowDetailPOList = [array JSONString];
                [newDic setObject:mallReturnFlowDetailPOList
                           forKey:@"mallReturnFlowDetailPOList"];
            }
        }
        if (_delProofId) {
            [newDic setObject:_delProofId forKey:@"delProofId"];
        }
        //上传图片文件
        if (self.thumbPicArray.count > 0)
        {
            NSMutableArray *array = [NSMutableArray array];
            [self.thumbPicArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *imageData = UIImageJPEGRepresentation(obj, .5);
                NSDictionary *dict = @{@"uploadfile": imageData};
                [array addObject:dict];
            }];
               [newDic setObject:array forKey:@"uploadfile"];
        }
     
        
        
    }
    return newDic;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYAfterSaleServiceResponse *respose = [[HYAfterSaleServiceResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
