//
//  HYFlowerOrderListInfo.m
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerOrderSummary.h"

@interface HYFlowerOrderSummary ()

@property (nonatomic, assign) CGFloat userMessageHeight;
@property (nonatomic, assign) CGFloat addressHeight;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) HYOrderAddress *address;
@property (nonatomic, strong) HYOrderAddress *invoiceAddress;

@end

@implementation HYFlowerOrderSummary

-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
        if(json != nil)
        {
            self.buyerNick = [json objectForKey:@"buyerNick"];
            self.presentName = [json objectForKey:@"presentName"];
            self.presentPhone = [json objectForKey:@"presentPhone"];
            
            self.invoiceType  = [json objectForKey:@"invoiceType"];
            self.status  = [json objectForKey:@"status"];
            self.updatedTime  = [json objectForKey:@"updatedTime"];
            
            self.buyerMobile  = [json objectForKey:@"buyerMobile"];
            self.orderTotalAmount  = [json objectForKey:@"orderTotalAmount"];
            self.creationTime  = [json objectForKey:@"creationTime"];
            self.orderCash  = [json objectForKey:@"orderCash"];
            self.walletAmount  = [json objectForKey:@"walletAmount"];
            self.walletStatus  = [[json objectForKey:@"walletStatus"] boolValue];
            
            self.orderTbAmount  = [json objectForKey:@"orderTbAmount"];
            self.orderShowStatus  = [json objectForKey:@"orderShowStatus"];
            self.orderCode  = [json objectForKey:@"orderCode"];
            self.orderPayAmount  = [json objectForKey:@"orderPayAmount"];
            self.buyerId  = [json objectForKey:@"buyerId"];
            self.invoiceTitle  = [json objectForKey:@"invoiceTitle"];
            self.invoiceCompany  = [json objectForKey:@"invoiceCompany"];
            self.remark  = [json objectForKey:@"remark"];
            self.orderType = GETOBJECTFORKEY(json, @"orderType", NSString);
            
            if (self.remark.length <= 0)
            {
                self.remark = @"无";
            }
            
            //何塔式说不需要自己拼，服务端返回 9-10
            /*
            else if (self.presentName)
            {
                self.remark = [NSString stringWithFormat:@"%@--%@", self.remark, self.presentName];
            }
            //不使用该值
            else if (self.buyerNick)
            {
                self.remark = [NSString stringWithFormat:@"%@--%@", self.remark, self.buyerNick];
            }
            */
            
            NSMutableArray *itemsTempList = [NSMutableArray array];
            for(NSDictionary *dic in [json objectForKey:@"orderItemPOList"])
            {
                HYFlowerOrderItem *item = [[HYFlowerOrderItem alloc] initWithJson:dic];
                [itemsTempList addObject:item];
                item.points = self.orderTbAmount;
            }
            
            self.orderItemPOList = [itemsTempList copy];
            
            self.isEnterprise  = [json objectForKey:@"isEnterprise"];
            self.orderId  = [json objectForKey:@"orderId"];
            self.shippingTime  = [json objectForKey:@"shippingTime"];
            
            NSMutableArray *addsTempList = [NSMutableArray array];
            for(NSDictionary *item in [json objectForKey:@"deliveryAddressPOList"])
            {
                HYOrderAddress *addr = [[HYOrderAddress alloc] initWithJson:item];
                if (addr.type.intValue == 1)
                {
                    self.address = addr;
                }
                else
                {
                    self.invoiceAddress = addr;
                }
                
                [addsTempList addObject:addr];
            }
            self.addressList = [addsTempList copy];
            
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.buyerNick forKey:@"zx_buyerNick"];
    [aCoder encodeObject:self.invoiceType forKey:@"zx_invoiceType"];
    [aCoder encodeObject:self.status forKey:@"zx_status"];
    [aCoder encodeObject:self.updatedTime forKey:@"zx_updatedTime"];
    [aCoder encodeObject:self.orderItemPOList forKey:@"zx_orderItemPOList"];
    [aCoder encodeObject:self.buyerMobile forKey:@"zx_buyerMobile"];
    [aCoder encodeObject:self.orderTotalAmount forKey:@"zx_orderTotalAmount"];
    [aCoder encodeObject:self.creationTime forKey:@"zx_creationTime"];
    [aCoder encodeObject:self.orderTbAmount forKey:@"zx_orderTbAmount"];
    [aCoder encodeObject:self.orderShowStatus forKey:@"zx_orderShowStatus"];
    [aCoder encodeObject:self.orderCode forKey:@"zx_orderCode"];
    [aCoder encodeObject:self.orderPayAmount forKey:@"zx_orderPayAmount"];
    [aCoder encodeObject:self.buyerId forKey:@"zx_buyerId"];
    [aCoder encodeObject:self.invoiceTitle forKey:@"zx_invoiceTitle"];
    [aCoder encodeObject:self.invoiceCompany forKey:@"zx_invoiceCompany"];
    [aCoder encodeObject:self.remark forKey:@"zx_remark"];
    [aCoder encodeObject:self.isEnterprise forKey:@"zx_isEnterprise"];
    [aCoder encodeObject:self.orderId forKey:@"zx_orderId"];
    [aCoder encodeObject:self.shippingTime forKey:@"zx_shippingTime"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.buyerNick = [aDecoder decodeObjectForKey:@"zx_buyerNick"];
        self.invoiceType = [aDecoder decodeObjectForKey:@"zx_invoiceType"];
        self.status = [aDecoder decodeObjectForKey:@"zx_status"];
        self.updatedTime = [aDecoder decodeObjectForKey:@"zx_updatedTime"];
        self.orderItemPOList = [aDecoder decodeObjectForKey:@"zx_orderItemPOList"];
        self.buyerMobile = [aDecoder decodeObjectForKey:@"zx_buyerMobile"];
        self.orderTotalAmount = [aDecoder decodeObjectForKey:@"zx_orderTotalAmount"];
        self.creationTime = [aDecoder decodeObjectForKey:@"zx_creationTime"];
        self.orderTbAmount = [aDecoder decodeObjectForKey:@"zx_orderTbAmount"];
        self.orderShowStatus = [aDecoder decodeObjectForKey:@"zx_orderShowStatus"];
        self.orderCode = [aDecoder decodeObjectForKey:@"zx_orderCode"];
        self.orderPayAmount = [aDecoder decodeObjectForKey:@"zx_orderPayAmount"];
        self.buyerId = [aDecoder decodeObjectForKey:@"zx_buyerId"];
        self.invoiceTitle = [aDecoder decodeObjectForKey:@"zx_invoiceTitle"];
        self.invoiceCompany = [aDecoder decodeObjectForKey:@"zx_invoiceCompany"];
        self.remark = [aDecoder decodeObjectForKey:@"zx_remark"];
        self.isEnterprise = [aDecoder decodeObjectForKey:@"zx_isEnterprise"];
        self.orderId = [aDecoder decodeObjectForKey:@"zx_orderId"];
        self.shippingTime = [aDecoder decodeObjectForKey:@"zx_shippingTime"];
        
    }
    return self;
}

- (NSString *) description
{
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"buyerNick : %@\n",self.buyerNick];
    result = [result stringByAppendingFormat:@"invoiceType : %@\n",self.invoiceType];
    result = [result stringByAppendingFormat:@"status : %@\n",self.status];
    result = [result stringByAppendingFormat:@"updatedTime : %@\n",self.updatedTime];
    result = [result stringByAppendingFormat:@"orderItemPOList : %@\n",self.orderItemPOList];
    result = [result stringByAppendingFormat:@"buyerMobile : %@\n",self.buyerMobile];
    result = [result stringByAppendingFormat:@"orderTotalAmount : %@\n",self.orderTotalAmount];
    result = [result stringByAppendingFormat:@"creationTime : %@\n",self.creationTime];
    result = [result stringByAppendingFormat:@"orderTbAmount : %@\n",self.orderTbAmount];
    result = [result stringByAppendingFormat:@"orderShowStatus : %@\n",self.orderShowStatus];
    result = [result stringByAppendingFormat:@"orderCode : %@\n",self.orderCode];
    result = [result stringByAppendingFormat:@"orderPayAmount : %@\n",self.orderPayAmount];
    result = [result stringByAppendingFormat:@"buyerId : %@\n",self.buyerId];
    result = [result stringByAppendingFormat:@"invoiceTitle : %@\n",self.invoiceTitle];
    result = [result stringByAppendingFormat:@"invoiceCompany : %@\n",self.invoiceCompany];
    result = [result stringByAppendingFormat:@"remark : %@\n",self.remark];
    result = [result stringByAppendingFormat:@"isEnterprise : %@\n",self.isEnterprise];
    result = [result stringByAppendingFormat:@"orderId : %@\n",self.orderId];
    result = [result stringByAppendingFormat:@"shippingTime : %@\n",self.shippingTime];
    
    return result;
}

- (CGFloat)userMessageHeight
{
    if (_userMessageHeight <= 0)
    {
        CGSize size = [self.remark sizeWithFont:[UIFont systemFontOfSize:12]
                              constrainedToSize:CGSizeMake(300, 100)
                                  lineBreakMode:NSLineBreakByCharWrapping];
        _userMessageHeight = (size.height+6);
        _userMessageHeight = _userMessageHeight>20 ? _userMessageHeight : 20;
    }
    
    return _userMessageHeight;
}

- (CGFloat)addressHeight
{
    if (_addressHeight <= 0)
    {
        CGSize size = [self.address.address sizeWithFont:[UIFont systemFontOfSize:12]
                               constrainedToSize:CGSizeMake(300, 100)
                                   lineBreakMode:NSLineBreakByCharWrapping];
        _addressHeight = (size.height+6);
        _addressHeight = _addressHeight>20 ? _addressHeight : 20;
    }
    return _addressHeight;
}

- (CGFloat)contentHeight
{
    if (_contentHeight <= 0)
    {
        _contentHeight = (100+self.userMessageHeight+self.addressHeight+120);
    }
    return _contentHeight;
}


@end
