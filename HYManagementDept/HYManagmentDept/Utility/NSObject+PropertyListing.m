//
//  NSObject+PropertyListing.m
//  hpiWeibo
//
//  Created by RayXiang on 12-8-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
// 
#import "NSObject+PropertyListing.h"
#import <objc/runtime.h>

@implementation NSObject (PropertyListing)

-(void)setPropertysWithDictionary:(NSDictionary *)keyedValues
{
    NSArray* propertys = [self getPropertysNames];
    for (NSString* key in propertys) 
    {
        NSObject* value = [keyedValues objectForKey:key];

        if(value)
        {
            [self setValue:value forKey:key];
        }
    }
}
- (NSArray *)getPropertysNames 
{
    NSMutableArray *props = [[NSMutableArray alloc] init];   
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++){
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [props addObject:propertyName];
    } 
    free(properties);
    return props;   
}   

- (void)setPropertysWithDictionary:(NSDictionary *)keyedValues unfindMarker:(NSString *)marker
{
    NSArray* propertys = [self getPropertysNames];
    for (NSString* key in propertys)
    {
        NSObject* value = [keyedValues objectForKey:key];
        
        if(value)
        {
            [self setValue:value forKey:key];
        } else {
            [self setValue:marker forKey:key];
        }
    }
}

-(NSDictionary*)dictionValue
{
    NSMutableDictionary* retDic = [[NSMutableDictionary alloc] init];
    NSArray* propertys =  [self getPropertysNames];
    for (NSString* property in propertys)
    {
        NSObject* value = [self valueForKey:property];
        if (value)
        {
            [retDic setObject:value forKey:property];
        }
    }
    return retDic;
}

- (NSDictionary *)dictionValueWithNotFoundMarker:(id)marker
{
    NSMutableDictionary* retDic = [[NSMutableDictionary alloc] init];
    NSArray* propertys =  [self getPropertysNames];
    for (NSString* property in propertys)
    {
        NSObject* value = [self valueForKey:property];
        if (value)
        {
            [retDic setObject:value forKey:property];
        } else {
            [retDic setObject:marker forKey:property];
        }
    }
    return retDic;
}

- (NSArray *)valuesForPropertys:(NSArray *)pros
{
    return [self valuesForPropertys:pros nilMarker:[NSNull null]];
}

- (NSArray *)valuesForPropertys:(NSArray *)pros nilMarker:(id)marker
{
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *pro in pros) {
        id v = [self valueForKey:pro];
        if (v) {
            [values addObject:v];
        } else {
            [values addObject:marker];
        }
    }
    return [values copy];
}

@end

@implementation NSObject (PropertyEncode)

+ (NSDictionary *)propertiesWithEncodedTypes
{
	// Recurse up the classes, but stop at NSObject. Each class only reports its own properties, not those inherited from its superclass
	NSMutableDictionary *theProps;
	
	if ([self superclass] != [NSObject class])
		theProps = (NSMutableDictionary *)[[self superclass] propertiesWithEncodedTypes];
	else
		theProps = [NSMutableDictionary dictionary];
	
	unsigned int outCount;
	
    
	objc_property_t *propList = class_copyPropertyList([self class], &outCount);
    
	int i;
	
	// Loop through properties and add declarations for the create
	for (i=0; i < outCount; i++)
	{
        
		objc_property_t oneProp = propList[i];
		NSString *propName = [NSString stringWithUTF8String:property_getName(oneProp)];
		NSString *attrs = [NSString stringWithUTF8String: property_getAttributes(oneProp)];
		// Read only attributes are assumed to be derived or calculated
		// See http://developer.apple.com/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/chapter_8_section_3.html
		if ([attrs rangeOfString:@",R,"].location == NSNotFound)
		{
			NSArray *attrParts = [attrs componentsSeparatedByString:@","];
			if (attrParts != nil)
			{
				if ([attrParts count] > 0)
				{
					NSString *propType = [[attrParts objectAtIndex:0] substringFromIndex:1];
					[theProps setObject:propType forKey:propName];
				}
			}
		}
	}
	
	free( propList );
	return theProps;
}

@end
