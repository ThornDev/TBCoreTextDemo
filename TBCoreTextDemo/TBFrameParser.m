//
//  TBFrameParser.m
//  TBCoreTextDemo
//
//  Created by 思来氏 on 16/8/2.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//  排版类

#import "TBFrameParser.h"
#import "TBCoreTextImageData.h"
@implementation TBFrameParser

// 配置属性字符串属性
+ (NSDictionary *)attributesWithConfig:(TBFrameParserConfig *)config{
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpace = config.lineSpace;
    const CFIndex kNumberOfSetting = 3;
    CTParagraphStyleSetting theSetting[kNumberOfSetting] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat),&lineSpace},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpace}
    };
    CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(theSetting, kNumberOfSetting);
    UIColor *textColor = config.textColor;
    NSMutableDictionary * mutDic = [NSMutableDictionary dictionary];
    mutDic[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    mutDic[(id)kCTFontAttributeName] = (__bridge id _Nullable)(fontRef);
    mutDic[(id)kCTParagraphStyleAttributeName] = (__bridge id _Nullable)paragraphRef;
    
    CFRelease(paragraphRef);
    CFRelease(fontRef);
    return mutDic;
}

// 为显示内容进行，属性字符串配置，并获取内容高度
+ (TBCoreTextData *)parseContent:(NSString *)content config:(TBFrameParserConfig *)config{
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    
//    创建 CTFramesetterRef 实例
    CTFramesetterRef framesetterRef  = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
    
//    获取要绘制的区域高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
//    生成CTFrameRef实例
    CTFrameRef frameRef = [self createFrameWithFramesetter:framesetterRef config:config height:textHeight];
// 将生成好的 CTFrameRef 实例和计算好的绘制高度保存到 TBCoreTextData 实例中，最后返回 TBCoreTextData 实例
    TBCoreTextData *tbData = [[TBCoreTextData alloc] init];
    tbData.ctFrame = frameRef;
    tbData.height = textHeight;
    
//    释放内存
    CFRelease(frameRef);
    CFRelease(framesetterRef);
    return tbData;
    
}





// 为显示内容进行，属性字符串配置，并获取内容高度
+ (TBCoreTextData *)customParseContent:(NSAttributedString *)content config:(TBFrameParserConfig *)config{
    
    //    创建 CTFramesetterRef 实例
    CTFramesetterRef framesetterRef  = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    //    获取要绘制的区域高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    //    生成CTFrameRef实例
    CTFrameRef frameRef = [self createFrameWithFramesetter:framesetterRef config:config height:textHeight];
    // 将生成好的 CTFrameRef 实例和计算好的绘制高度保存到 TBCoreTextData 实例中，最后返回 TBCoreTextData 实例
    TBCoreTextData *tbData = [[TBCoreTextData alloc] init];
    tbData.ctFrame = frameRef;
    tbData.height = textHeight;
    
    //    释放内存
    CFRelease(frameRef);
    CFRelease(framesetterRef);
    return tbData;
    
}

// 获取绘制区域设置
+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                  config:(TBFrameParserConfig *)config
                                  height:(CGFloat)height{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frameRef;
    
}

/**
 *  根据配置信息解析配置内容
 *
 *  @param filePath 配置文件路径
 *  @param config   配置类
 *
 *  @return 显示信息
 */
+ (TBCoreTextData *)parseTemplateFile:(NSString*)filePath config:(TBFrameParserConfig *)config{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    NSAttributedString *content = [self loadTemplatePath:filePath config:config imageArray:imageArray];
    TBCoreTextData *data = [self customParseContent:content config:config];
    data.imageArray = imageArray;
    return data;
}


/**
 *  加载配置文件并解析
 *
 *  @param filePath 配置文件路径
 *  @param config   配置类
 *
 *  @return 为定制内容设置的属性字符串
 */
+ (NSAttributedString *)loadTemplatePath:(NSString *)filePath
                                  config:(TBFrameParserConfig *)config
                              imageArray:(NSMutableArray*)imageArray{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSMutableAttributedString *mutableAttrString = [[NSMutableAttributedString alloc] init];
    if (data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in array) {
                NSString *type = dic[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString *attrString =  [self parseAttributedContentFromDictionary:dic
                                                                                          config:config];
                    [mutableAttrString appendAttributedString:attrString];
                }else if ([type isEqualToString:@"img"]){
                    
                    TBCoreTextImageData *tbImageData = [[TBCoreTextImageData alloc] init];
                    tbImageData.name = dic[@"content"];
                    tbImageData.position = [mutableAttrString length];
                    tbImageData.singleLine = [dic[@"singleLine"] integerValue];
                    tbImageData.containerWidth = config.width;
                    [imageArray addObject:tbImageData];
                    // 创建空白位
                    NSAttributedString *as = [self parseImageDataFromDictionary:dic config:config];
                    [mutableAttrString appendAttributedString:as];
                }
                
                
            }
        }
    }
    return mutableAttrString;
}


/**
 *  为属性字符串配置 json里的颜色  字号 内容
 *
 *  @param dic    配置信息
 *  @param config 配置对象
 *
 *  @return 自定义配置好的属性字符串
 */
+ (NSAttributedString *)parseAttributedContentFromDictionary:(NSDictionary *)dic config:(TBFrameParserConfig *)config{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:[self attributesWithConfig:config]];
    UIColor *color = [self colorFromTemplate:dic[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    
    CGFloat fontSize = [dic[@"size"] floatValue];
    if (fontSize > 0 ) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id _Nullable)(fontRef);
        CFRelease(fontRef);
    }
    
    NSString *content = dic[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
    
}

/**
 *  解析配置里的颜色信息
 *
 *  @param colorName 颜色名字（为颜色值加Color），目的与UIColor的类方法对应
 *
 *  @return
 */
+ (UIColor *)colorFromTemplate:(NSString *)colorName{
    SEL colorSel = NSSelectorFromString(colorName);
    UIColor* tColor = nil;
    if ([UIColor respondsToSelector: colorSel]){
        tColor  = [UIColor performSelector:colorSel];
        return tColor;
    }
    return nil;
}


static CGFloat ascentCallBack(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallBack(void *ref){
    return 0;
}

static CGFloat widthCallBack(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

+ (NSAttributedString *)parseImageDataFromDictionary:(NSDictionary *)dic config:(TBFrameParserConfig *)config{
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    callBacks.version = kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallBack;
    callBacks.getDescent = descentCallBack;
    callBacks.getWidth = widthCallBack;
    
    
    CTRunDelegateRef delegateRef = CTRunDelegateCreate(&callBacks, (__bridge void * _Nullable)(dic));
    
    // 使用 0xFFFC 作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSMutableAttributedString *mutableAttrString = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)mutableAttrString, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegateRef);
    CFRelease(delegateRef);
    return mutableAttrString;
    
}

@end
