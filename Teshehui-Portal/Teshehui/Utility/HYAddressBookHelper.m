//
//  HYAddressBookHelper.m
//  Teshehui
//
//  Created by HYZB on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYAddressBookHelper.h"
#import "HYPerson.h"
#import "PinYin.h"
#import "NSString+Addition.h"

@interface HYAddressBookHelper ()

@property (nonatomic, readonly) ABAddressBookRef addressBook;

@end

@implementation HYAddressBookHelper

#pragma mark pulice methods
- (NSArray *)getAllContacts
{
    CFArrayRef ABContacts = ABAddressBookCopyArrayOfAllPeople(self.addressBook);
    
    if (!ABContacts)
    {
        return nil;
    }
    
    NSMutableArray *allContacts = [[NSMutableArray alloc] init];
    NSMutableSet *mobileSet = [[NSMutableSet alloc] init];
    
    DebugNSLog(@"start run loop");
    for (int i=0; i< CFArrayGetCount(ABContacts); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(ABContacts, i);
        ABRecordID personId = ABRecordGetRecordID(person);
        
        // name
        CFStringRef chineseName = ABRecordCopyCompositeName(person);
        if (![(__bridge NSString *)chineseName length]>0)
        {
            chineseName = ABRecordCopyValue(person, kABPersonOrganizationProperty);
        }
        
        PTChineseNameInfo *cni = [PinYin quickConvert:((__bridge NSString *)chineseName)];
        NSString *index = cni.pinyinIndex;
        NSString *pinyin = cni.pinyinLong;
        
        //phones
        ABMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFArrayRef  values = ABMultiValueCopyArrayOfAllValues(phoneMulti);
        
        for (NSString *mobile in ((__bridge NSArray *)values))
        {
            if (![mobileSet containsObject:mobile])
            {
                [mobileSet addObject:mobile];
                
                NSString *str = [mobile filterInvalidStringToMobile];
                
                /// by 成才，我觉得这里不需要过虑电话号码
//                if ([str checkPhoneNumberValid])
                {
                    HYPerson *contact = [[HYPerson alloc] init];
                    contact.recordId = personId;
                    if (chineseName)
                    {
                        contact.name = (__bridge NSString *)chineseName;
                    }
                    else
                    {
                        contact.name = str;
                    }
                    
                    contact.mobile = str;
                    contact.index = index;
                    contact.pinyin = pinyin;
                    contact.searchKey = i * 100 + [(__bridge NSArray *)values indexOfObject:mobile];
                    
                    [allContacts addObject:contact];
                }
            }
        }
        
        if(values)
            CFRelease(values);
        if (phoneMulti)
            CFRelease(phoneMulti);
        
        if (chineseName)
            CFRelease(chineseName);
    }
    
    DebugNSLog(@"end run loop ");
    
    if (ABContacts)
        CFRelease(ABContacts);
    
    DebugNSLog(@"start sort ");
    //排序所有联系人
    [allContacts sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *f1 = [(HYPerson *)obj1 pinyin];
        NSString *f2 = [(HYPerson *)obj2 pinyin];
        return [f1 compare:f2];
    }];
    DebugNSLog(@"end sort ");
    
    return [allContacts copy];
}

#pragma mark private methods

#pragma mark setter/getter
- (ABAddressBookRef)addressBook
{
    if (!_addressBook)
    {
        NSString *version = [[UIDevice currentDevice] systemVersion];
        BOOL isVersion6 = [version compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending;
        
        if (isVersion6)
        {
            if (&ABAddressBookCreateWithOptions != NULL)
            {
                CFErrorRef errorRef = NULL;
                _addressBook = ABAddressBookCreateWithOptions(NULL, &errorRef);
                
                if (!_addressBook){
                    //bail
                    DebugNSLog(@"Error: Failed to create AddressBook instance. Underlying ABAddressBookCreateWithOptions() failed with error: %@", errorRef);
                    if (errorRef) CFRelease(errorRef);
                }
            }
            
            _accessStatus = ABAddressBookGetAuthorizationStatus();
            switch (_accessStatus)
            {
                case kABAuthorizationStatusNotDetermined:  //没有请求过
                    ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
                        if (error)
                        {
                            DebugNSLog(@"Error: Failed to create AddressBook instance. Underlying ABAddressBookCreateWithOptions() failed with error: %@", error);
                            CFRelease(error);
                        }
                    });
                    break;
                case kABAuthorizationStatusRestricted:  //访问受权限控制

                    break;
                case kABAuthorizationStatusDenied:  //访问被拒绝

                    break;
                case kABAuthorizationStatusAuthorized:  //同意访问

                    break;
                    //
                default:
                    break;
            }
        }
        else
        {
            _addressBook = ABAddressBookCreate();
            _accessStatus = kABAuthorizationStatusAuthorized;
        }
    }
    
    return _addressBook;
}

@end
