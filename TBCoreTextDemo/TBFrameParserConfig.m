//
//  TBFrameParserConfig.m
//  TBCoreTextDemo
//
//  Created by 思来氏 on 16/8/2.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//  配置类

#import "TBFrameParserConfig.h"
#import "Config.h"
@implementation TBFrameParserConfig


// 显示配置设置，并没有实际作用，仅是初始化效果
- (id)init{
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = RGB(108, 108, 108);
    }
    return self;
}
@end
