//
//  HYFlightRTRules.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-28.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightRTRules.h"

@interface HYFlightRTRules ()

@property (nonatomic, assign) CGFloat changeHeight;
@property (nonatomic, assign) CGFloat refundHeight;
@property (nonatomic, assign) CGFloat remarkHeight;

@end

@implementation HYFlightRTRules

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.Airline = GETOBJECTFORKEY(data, @"Airline", [NSString class]);
        self.Cabin = GETOBJECTFORKEY(data, @"Cabin", [NSString class]);
        self.ChangeSdate = GETOBJECTFORKEY(data, @"ChangeSdate", [NSString class]);
        self.ChangeEdate = GETOBJECTFORKEY(data, @"ChangeEdate", [NSString class]);
        self.RefundSdate = GETOBJECTFORKEY(data, @"RefundSdate", [NSString class]);
        self.RefundEdate = GETOBJECTFORKEY(data, @"RefundEdate", [NSString class]);
        NSString *change = GETOBJECTFORKEY(data, @"change_rule", [NSString class]);
        if ([change length] <= 0)
        {
            change = @"改签补差价";
        }
        self.Change = change;
        
        NSString *refund = GETOBJECTFORKEY(data, @"refund_rule", [NSString class]);
        if ([refund length] <= 0)
        {
            refund = @"不支持退票";
        }
        self.Refund = refund;
        self.Remark = GETOBJECTFORKEY(data, @"remark", [NSString class]);
    }
    
    return self;
}

- (CGFloat)remarkHeight
{
    if (_remarkHeight<=0 && [self.Remark length]>0)
    {
        CGSize size = [self.Remark sizeWithFont:[UIFont systemFontOfSize:12]
                              constrainedToSize:CGSizeMake(TFScalePoint(270), 600)
                                  lineBreakMode:NSLineBreakByCharWrapping];
        _remarkHeight = size.height;
    }
    
    return _remarkHeight;
}

- (CGFloat)refundHeight
{
    if (_refundHeight<=0 && [self.Refund length]>0)
    {
        CGSize size = [self.Refund sizeWithFont:[UIFont systemFontOfSize:12]
                              constrainedToSize:CGSizeMake(TFScalePoint(270), 600)
                                  lineBreakMode:NSLineBreakByCharWrapping];
        _refundHeight = size.height;
    }
    
    return _refundHeight;
}

- (CGFloat)changeHeight
{
    if (_changeHeight<=0 && [self.Change length]>0)
    {
        CGSize cSize = [self.Change sizeWithFont:[UIFont systemFontOfSize:12]
                               constrainedToSize:CGSizeMake(TFScalePoint(270), 600)
                                   lineBreakMode:NSLineBreakByCharWrapping];
        _changeHeight = cSize.height;
    }
    
    return _changeHeight;
}

@end
