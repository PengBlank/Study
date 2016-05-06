//
//  HYPerson.h
//  Teshehui
//
//  Created by HYZB on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface HYPerson : NSObject

@property (nonatomic, copy) NSString *index;  
@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) ABRecordID recordId;
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) NSInteger searchKey;

@end
