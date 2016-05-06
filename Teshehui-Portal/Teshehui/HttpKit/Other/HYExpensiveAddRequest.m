//
//  HYExpensiveAddRequest.m
//  Teshehui
//
//  Created by apple on 15/4/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYExpensiveAddRequest.h"

@implementation HYExpensiveAddRequest

- (instancetype)init
{
    if (self = [super init])
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/guijiupei/applyGuijiupei.action", kJavaRequestBaseURL];
        self.httpMethod = @"POST";
        self.businessType = @"01";
    }
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *dict = [super getJsonDictionary];
    
    [dict setObject:self.userId forKey:@"userId"];
    
    if (self.orderCode)
    {
        [dict setObject:_orderCode forKey:@"orderCode"];
    }
    if (self.productSkuCode)
    {
        [dict setObject:_productSkuCode forKey:@"productSkuCode"];
    }
    if (self.productCode)
    {
        [dict setObject:_productCode forKey:@"productCode"];
    }
    if (self.desc)
    {
        [dict setObject:self.desc forKey:@"description"];
    }
    if (self.compare_url)
    {
        [dict setObject:self.compare_url forKey:@"compareUrl"];
    }
    //上传图片文件
    if (self.imgs.count > 0)
    {
        NSMutableArray *array = [NSMutableArray array];
        [self.imgs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(obj, .5);
            NSDictionary *dict = @{@"uploadfile": imageData};
            [array addObject:dict];
        }];
        [dict setObject:array forKey:@"uploadfile"];
    }
    
    return dict;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    return [[HYExpensiveAddResponse alloc] initWithJsonDictionary:info];
}


@end
