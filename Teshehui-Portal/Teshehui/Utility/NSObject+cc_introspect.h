//
//  NSObject+cc_introspect.h
//  Kuke
//
//  Created by 成才 向 on 15/10/29.
//  Copyright © 2015年 RK. All rights reserved.
//

#import <Foundation/Foundation.h>
@class cc_Property;
@class cc_Ivar;

typedef struct {
    BOOL readOnly;
    BOOL isCopy;
    BOOL isRetain;
    BOOL isNonatomic;
    BOOL isDynimic;
    BOOL isWeak;
}cc_PropertyAttributes;

@interface NSObject (cc_introspect)

- (cc_Property*)cc_propertyWithName:(NSString *)name;
- (NSArray *)cc_propertys;
- (NSDictionary *)cc_propertyDictionary;
- (NSDictionary *)cc_propertyDictionaryWithClass:(Class)targetClass;

- (cc_Ivar*)cc_ivarWithName:(NSString *)name;

@end

/**
 *  属性
 */
@interface cc_Property : NSObject

/** The name of the declared property (not the ivar name) */
@property (copy, nonatomic) NSString* name;

/** A property class type  */
@property (assign, nonatomic) Class type;

/** Struct name if a struct */
@property (strong, nonatomic) NSString* structName;

/** The name of the protocol the property conforms to (or nil) */
@property (copy, nonatomic) NSString* protocol;

/**/
@property (nonatomic, assign) cc_PropertyAttributes attributes;

@end

/**
 *  实例变量
 */
@interface cc_Ivar : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) id value;

@end
