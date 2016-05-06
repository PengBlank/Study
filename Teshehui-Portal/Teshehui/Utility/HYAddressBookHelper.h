//
//  HYAddressBookHelper.h
//  Teshehui
//
//  Created by HYZB on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface HYAddressBookHelper : NSObject
{
    ABAuthorizationStatus _accessStatus;
    ABAddressBookRef _addressBook;
}

- (NSArray *)getAllContacts;

@end
