//
//  TBFrameParser.h
//  TBCoreTextDemo
//
//  Created by 思来氏 on 16/8/2.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBFrameParserConfig.h"
#import "TBCoreTextData.h"
@interface TBFrameParser : NSObject

//+(TBCoreTextData *)parseContent:(NSString *)content
//                         config:(TBFrameParserConfig *)config;

// 为显示内容进行，属性字符串配置，并获取内容高度
+ (TBCoreTextData *)parseContent:(NSString *)content config:(TBFrameParserConfig *)config;



//  根据配置文件  来进行深度化配置
+ (TBCoreTextData *)parseTemplateFile:(NSString*)filePath config:(TBFrameParserConfig *)config;
@end
