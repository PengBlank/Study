//
//  NSObject+PropertyListing.h
//  hpiWeibo
//
//  Created by RayXiang on 12-8-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PropertyListing)

/**
 *  获得所有属性名
 *
 *  @return an array of all the property names.
 */
- (NSArray *)getPropertysNames;

/**
 *  使用一个字典对一个对象进行赋值，按key = propertyName的关系进行
 *
 *  @param keyedValues
 */
-(void)setPropertysWithDictionary:(NSDictionary *)keyedValues;

/**
 *  使用一个字典对对象进行赋值，对象拥有但是字典中没有的属性，赋maker值
 *
 *  @param keyedValues
 *  @param marker
 */
-(void)setPropertysWithDictionary:(NSDictionary *)keyedValues unfindMarker:(NSString *)marker;

/**
 *  获取一个对象的字典表示
 *
 *  @return dicionary
 */
-(NSDictionary*)dictionValue;
- (NSDictionary *)dictionValueWithNotFoundMarker:(id)marker;

- (NSArray *)valuesForPropertys:(NSArray *)pros;
- (NSArray *)valuesForPropertys:(NSArray *)pros nilMarker:(id)marker;
@end

@interface NSObject (PropertyEncode)

/*!
 This is just a convenience routine; in several places we have to iterate through the properties and take some action based
 on their type. This method creates an array with all the property names and their types in a dictionary. The values for
 the encoded types will be one of:
 
 c	A char
 i	An int
 s	A short
 l	A long
 q	A long long
 C	An unsigned char
 I	An unsigned int
 S	An unsigned short
 L	An unsigned long
 Q	An unsigned long long
 f	A float
 d	A double
 B	A C++ bool or a C99 _Bool
 v	A void
 *	A character string (char *)
 @	An object (whether statically typed or typed id)
 #	A class object (Class)
 :	A method selector (SEL)
 [array type]	An array
 {name=type...}	A structure
 (name=type...)	A union
 bnum	A bit field of num bits
 ^type	A pointer to type
 ?	An unknown type (among other things, this code is used for function pointers)
 
 Currently, the following properties cannot be persisted using this class:  C, c, v, #, :, [array type], *, {name=type...}, (name=type...), bnum, ^type, or ?
 TODO: Look at finding ways to allow people to use some or all of the currently unsupported types... we could probably use sizeof to store the structs and unions maybe??.
 TODO: Look at overriding valueForUndefinedKey: to handle the char, char * and unsigned char property types - valueForKey: doesn't return anything for these, so currently they do not work.
 */
+ (NSDictionary *)propertiesWithEncodedTypes;

@end
