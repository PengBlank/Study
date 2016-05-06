//
//  PinYin.h
//  TestHanZiConvertToPinYin
//
//  Created by 程 谦 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTChineseNameInfo.h"

#define HZ2PY_VERSION "0.1"
#define HZ2PY_UTF8_CHECK_LENGTH 20
#define HZ2PY_FILE_READ_BUF_ARRAY_SIZE 1000
#define HZ2PY_INPUT_BUF_ARRAY_SIZE 1024
#define HZ2PY_OUTPUT_BUF_ARRAY_SIZE 5120
#define HZ2PY_STR_COPY(to, from, count) \
ok = 1;\
i = 0;\
_tmp = from;\
while(i < count)\
{\
if (*_tmp == '\0')\
{\
ok = 0;\
break;\
}\
_tmp ++;\
i ++;\
}\
if (ok)\
{\
i = 0;\
while(i < count)\
{\
*to = *from;\
to ++;\
from ++;\
i ++;\
}\
}\
else\
{\
if (overage_buff != NULL)\
{\
while(*from != '\0')\
{\
*overage_buff = *from;\
from ++;\
}\
}\
break;\
}

typedef struct _PinyinInfo {
    __unsafe_unretained NSString  *fPinyin;
    __unsafe_unretained NSString *pinyin;
}PinyinInfo;

@interface PinYin : NSObject
{
@private
    
}

+ (int)is_utf8_string:(char *)utf;

+ (void)utf8_to_pinyin:(char *)inBuf
                outBuf:(char *)outBuf
             add_blank:(int)add_blank
   convert_double_char:(int)convert_double_char
          overage_buff:(char *)overage_buff;

+ (void)utf8_to_pinyin:(char *)inBuf
                outBuf:(char *)outBuf
     first_letter_only:(int)first_letter_only
     polyphone_support:(int)polyphone_support
             add_blank:(int)add_blank
   convert_double_char:(int)convert_double_char
          overage_buff:(char *)overage_buff;

+ (PTChineseNameInfo *)quickConvert:(NSString *)hzString;
@end