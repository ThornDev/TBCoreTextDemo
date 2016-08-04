//
//  Config.h
//  TBCoreTextDemo
//
//  Created by 思来氏 on 16/8/2.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//



#ifndef Config_h
#define Config_h

#import <UIKit/UIKit.h>
#import "UIView+Frame.h"
#import "TBFrameParser.h"
#import "TBCoreTextData.h"
#import "TBFrameParserConfig.h"

#ifdef DEBUG
#define DBLog(...) NSLog(__VA_ARGS__)
#define DBMethod() NSLog(@"%s", __func__)
#else
#define DBLog(...)
#define DBMethod()
#endif

#define RGB(A, B, C)    [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]




#endif /* Config_h */
