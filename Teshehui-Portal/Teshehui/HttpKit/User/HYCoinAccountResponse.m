//
//  HYCoinAccountResponse.m
//  Teshehui
//
//  Created by Kris on 15/5/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCoinAccountResponse.h"
#import "NSDate+Addition.h"
#import "PTDateFormatrer.h"

@implementation HYCoinAccountResponse
- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithJsonDictionary:dictionary])
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", NSDictionary);
        if (data)
        {
            NSArray *messageData = GETOBJECTFORKEY(data, @"items", [NSArray class]);
            NSMutableArray *muArray = [NSMutableArray array];
            for (id obj in messageData)
            {
                if ([obj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *d = (NSDictionary *)obj;
                    HYCoinAccount *coinAccount = [[HYCoinAccount alloc] initWithDictionary:d error:nil];
                    [muArray addObject:coinAccount];
                }
            }
            if ([muArray count] > 0)
            {
                self.msgDataList = [muArray copy];
            }
        }
    }
    return self;
}
@end

@interface HYCoinAccount ()

@end
@implementation HYCoinAccount
@synthesize cellHeight = _cellHeight;
@synthesize createdDate = _createdDate;

#define HYCoinAccountCellBorder 5

- (NSDate *)createdDate
{
    if (_createdDate)
    {
        return _createdDate;
    }
    else if (self.createdTime)
    {
        _createdDate = [PTDateFormatrer dateFromString:self.createdTime format:@"yyyy-MM-dd HH:mm:ss"];
        return _createdDate;
    }
    return nil;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
    NSArray *p = @[@"iconViewF", @"inFoTextLabelF", @"dateTextLabelF", @"coinLabelF", @"createdDate", @"logs"];
    return [p containsObject:propertyName];
}

//- (id)initWithDataInfo:(NSDictionary *)data
//{
//    self = [super init];
//    
//    if (self)
//    {
//        self.logs = GETOBJECTFORKEY(data, @"logs", [NSString class]);
//        self.points = GETOBJECTFORKEY(data, @"points", [NSString class]);
//        NSString *datestr = GETOBJECTFORKEY(data, @"created", NSString);
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[datestr doubleValue]];
//        self.created = date;
//        self.log_type = GETOBJECTFORKEY(data, @"log_type", [NSString class]);
//    }
//    return self;
//}

- (CGFloat)cellHeight
{
    if (_cellHeight == 0)
    {
        _iconViewF = CGRectMake(15, 15, 20, 20);
        
        CGFloat infoTextLabelW = [UIScreen mainScreen].bounds.size.width -
        (35+HYCoinAccountCellBorder) - (70 + HYCoinAccountCellBorder);
        CGSize infoSize = [self.tradeDescription sizeWithFont:[UIFont systemFontOfSize:14]
                                          constrainedToSize:CGSizeMake(infoTextLabelW, MAXFLOAT)];
//        infoSize.height = infoSize.height < 40 ? 40 : infoSize.height;
        _inFoTextLabelF = CGRectMake(CGRectGetMaxX(_iconViewF) + HYCoinAccountCellBorder, 8, infoSize.width, infoSize.height);
        
        NSString *created = self.createdTime;
        CGSize dateSize = [created sizeWithFont:[UIFont systemFontOfSize:12]];
        _dateTextLabelF = (CGRect){{CGRectGetMaxX(_iconViewF) + HYCoinAccountCellBorder, CGRectGetMaxY(_inFoTextLabelF) + HYCoinAccountCellBorder}, dateSize};
        
        _coinLabelF = CGRectMake(CGRectGetWidth(ScreenRect) - 80, CGRectGetMidY(_inFoTextLabelF)-20, 80, 40);
        _cellHeight = CGRectGetMaxY(_dateTextLabelF) + 5;
    }
    return _cellHeight;
}

//{
//    "status": 200,
//    "data": {
//        "totalItems": "1",
//        "totalPage": 1,
//        "messageData": [
//                        {
//                            "parent_id": "0",
//                            "logs": "会员卡激活成功，由 系统自动操作 自动送现金券1000 备注： 激活会员卡",
//                            "points": "1000",
//                            "created": "1425092097",
//                            "status": "1",
//                            "is_commercial": "0",
//                            "is_repeal": "0"
//                        }
//                        ],
//        "points": "999"
//    }

@end
