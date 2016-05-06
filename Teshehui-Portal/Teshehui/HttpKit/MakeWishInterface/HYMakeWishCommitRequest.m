//
//  HYMakeWishCommitRequest.m
//  Teshehui
//
//  Created by HYZB on 15/11/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMakeWishCommitRequest.h"

@implementation HYMakeWishCommitRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"wish/addWish.action"];
        self.httpMethod = @"POST";
    }
    
    return self;
}


- (NSMutableDictionary *)getJsonDictionary
{
   NSMutableDictionary *newDict = [super getJsonDictionary];
    
    if (self.userId) {
        [newDict setObject:self.userId forKey:@"userId"];
    }
    if (self.contactName) {
        [newDict setObject:self.contactName forKey:@"contactName"];
    }
    if (self.contactMobile) {
        [newDict setObject:self.contactMobile forKey:@"contactMobile"];
    }
    if (self.wishTitle) {
        [newDict setObject:self.wishTitle forKey:@"wishTitle"];
    }
    if (self.wishContent) {
        [newDict setObject:self.wishContent forKey:@"wishContent"];
    }
    if (self.uploadfile) {
        NSMutableArray *picArr = [NSMutableArray array];
        for (UIImage *image in self.uploadfile) {
           // NSData *imageData = UIImagePNGRepresentation(image);
            NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
            NSDictionary *dict = @{@"uploadfile":imageData};
            [picArr addObject:dict];
        }
        [newDict setObject:picArr forKey:@"uploadfile"];
    }
    
    return newDict;
}

@end
