//
//  NSObject+cc_introspect.m
//  Kuke
//
//  Created by 成才 向 on 15/10/29.
//  Copyright © 2015年 RK. All rights reserved.
//

#import "NSObject+cc_introspect.h"
#import <objc/runtime.h>

@implementation NSObject (cc_introspect)

- (cc_Property*)cc_propertyWithName:(NSString *)name
{
    objc_property_t property = class_getProperty([self class], [name cStringUsingEncoding:NSUTF8StringEncoding]);
    return [self propertyWithProperty:property];
}

- (NSArray *)cc_propertys
{
    Class class = [self class];
    NSMutableArray *ccpropertys = [NSMutableArray array];
    while (class != [NSObject class])
    {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        for (unsigned int i = 0; i < propertyCount; i++) {
            objc_property_t property = properties[i];
            cc_Property *ccproperty = [self propertyWithProperty:property];
            [ccpropertys addObject:ccproperty];
        }
        free(properties);
        class = [class superclass];
    }
    
    return ccpropertys;
}

- (NSDictionary *)cc_propertyDictionary
{
    return [self cc_propertyDictionaryWithClass:[NSObject class]];
}

- (NSDictionary *)cc_propertyDictionaryWithClass:(Class)targetClass
{
    
    Class class = [self class];
    NSMutableDictionary *pDict = [NSMutableDictionary dictionary];
    while (class != targetClass)
    {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        for (unsigned int i = 0; i < propertyCount; i++) {
            objc_property_t property = properties[i];
            cc_Property *ccproperty = [self propertyWithProperty:property];
            [pDict setObject:ccproperty.name forKey:[self valueForKey:ccproperty.name]];
        }
        free(properties);
        class = [class superclass];
    }
    return pDict;
}

- (cc_Ivar*)cc_ivarWithName:(NSString *)name
{
    Ivar ivar = class_getInstanceVariable([self class], [name cStringUsingEncoding:NSUTF8StringEncoding]);
    return [self ivarWithIvar:ivar];
}

- (cc_Ivar*)ivarWithIvar:(Ivar)ivar
{
    cc_Ivar *i = [[cc_Ivar alloc] init];
    const char *ivarName = ivar_getName(ivar);
    i.name = @(ivarName);
    i.value = object_getIvar(self, ivar);
    return i;
}


- (cc_Property*)propertyWithProperty:(objc_property_t)property
{
    cc_Property *p = [[cc_Property alloc] init];
    NSString* propertyType = nil;
    const char *propertyName = property_getName(property);
    p.name = @(propertyName);
    cc_PropertyAttributes attr = p.attributes;
    
    //JMLog(@"property: %@", p.name);
    
    //get property attributes
    const char *attrs = property_getAttributes(property);
    NSString* propertyAttributes = @(attrs);
    NSArray* attributeItems = [propertyAttributes componentsSeparatedByString:@","];
    
    if ([attributeItems containsObject:@"R"])
    {
        attr.readOnly = YES;
    }
    if ([attributeItems containsObject:@"C"]) {
        attr.isCopy = YES;
    }
    if ([attributeItems containsObject:@"&"]) {
        attr.isRetain = YES;
    }
    if ([attributeItems containsObject:@"N"]) {
        attr.isNonatomic = YES;
    }
    if ([attributeItems containsObject:@"D"]) {
        attr.isDynimic = YES;
    }
    if ([attributeItems containsObject:@"W"]) {
        attr.isWeak = YES;
    }
    
    //check for 64b BOOLs
    if ([propertyAttributes hasPrefix:@"Tc,"]) {
        //mask BOOLs as structs so they can have custom convertors
        p.structName = @"BOOL";
    }
    
    NSScanner* scanner = [NSScanner scannerWithString: propertyAttributes];
    
    //JMLog(@"attr: %@", [NSString stringWithCString:attrs encoding:NSUTF8StringEncoding]);
    [scanner scanUpToString:@"T" intoString: nil];
    [scanner scanString:@"T" intoString:nil];
    
    //check if the property is an instance of a class
    if ([scanner scanString:@"@\"" intoString: &propertyType]) {
        
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                intoString:&propertyType];
        
        //JMLog(@"type: %@", propertyClassName);
        p.type = NSClassFromString(propertyType);
//        p.isMutable = ([propertyType rangeOfString:@"Mutable"].location != NSNotFound);
        
        //read through the property protocols
        while ([scanner scanString:@"<" intoString:NULL]) {
            
            NSString* protocolName = nil;
            
            [scanner scanUpToString:@">" intoString: &protocolName];
            
            p.protocol = protocolName;
            
            [scanner scanString:@">" intoString:NULL];
        }
        
    }
    //check if the property is a structure
    else if ([scanner scanString:@"{" intoString: &propertyType]) {
        [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet]
                            intoString:&propertyType];
        
//        p.isStandardJSONType = NO;
        p.structName = propertyType;
        
    }
    //the property must be a primitive
    else {
        
        //the property contains a primitive data type
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@","]
                                intoString:&propertyType];
        NSDictionary *primitivesNames = @{@"f":@"float", @"i":@"int", @"d":@"double", @"l":@"long", @"c":@"BOOL", @"s":@"short", @"q":@"long",
                                          //and some famos aliases of primitive types
                                          // BOOL is now "B" on iOS __LP64 builds
                                          @"I":@"NSInteger", @"Q":@"NSUInteger", @"B":@"BOOL",
                                          
                                          @"@?":@"Block"};
        
        
        //get the full name of the primitive type
        propertyType = primitivesNames[propertyType];
        p.structName = propertyType;
        
    }
    
    return p;
}

@end

@implementation cc_Property

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

@end


@implementation cc_Ivar



@end