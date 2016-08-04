//
//  TBDisplayView.m
//  TBCoreTextDemo
//
//  Created by 思来氏 on 16/8/2.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//  显示类

#import "TBDisplayView.h"
#import "CoreText/CoreText.h"
#import "UIView+Frame.h"
#import "TBCoreTextImageData.h"
@implementation TBDisplayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/**
 *  setNeedsDisplay会自动调用drawRect方法，这样可以拿到UIGraphicsGetCurrentContext，就可以画画了。
 而setNeedsLayout会默认调  用layoutSubViews，就可以处理子视图中的一些数据。
 宗上所诉，setNeedsDisplay方便绘图，而layoutSubViews方便出来数据
 *
 *  @param rect
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    开始绘画
//    得到当前绘制画布的上下文，用于后续将内容绘制在画布上
    CGContextRef context = UIGraphicsGetCurrentContext();
    
// 对当前画布进行设置
 /*   
  将坐标系上下翻转。对于底层的绘制引擎来说，屏幕的左下角是（0, 0）坐标。
  而对于上层的 UIKit 来说，左上角是 (0, 0) 坐标。
  所以我们为了之后的坐标系描述按 UIKit 来做，所以先在这里做一个坐标系的上下翻转操作。
  翻转之后，底层和上层的 (0, 0) 坐标就是重合的了
  */
    CGContextSetTextMatrix(context, CGAffineTransformIdentity); //设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
    CGContextTranslateCTM(context, 0, self.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.tbData) {
        CTFrameDraw(self.tbData.ctFrame, context);
    }
    
    for (TBCoreTextImageData * imageData in self.tbData.imageArray) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGRect tRect = imageData.imagePosition;
            if (imageData.singleLine) {
                CGFloat centerX = (imageData.containerWidth - CGRectGetWidth(imageData.imagePosition))/2;
                tRect = CGRectMake(centerX, CGRectGetMinY(imageData.imagePosition),
                                   CGRectGetWidth(imageData.imagePosition),
                                   CGRectGetHeight(imageData.imagePosition));
            }
            CGContextDrawImage(context, tRect, image.CGImage);
        }
    }

//    self.frame = rect;
    /*
//    设置绘画区域
    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, self.bounds);
    CGPathAddEllipseInRect(path, NULL, self.bounds);
    
//    设置绘画内容
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"hello world创建绘制的区域，CoreText 本身支持各种文字排版的区域创建绘制的区域，CoreText 本身支持各种文字排版的区域创建绘制的区域，CoreText 本身支持各种文字排版的区域创建绘制的区域，CoreText 本身支持各种文字排版的区域创建绘制的区域，CoreText 本身支持各种文字排版的区域创建绘制的区域，CoreText 本身支持各种文字排版的区域创建绘制的区域，CoreText 本身支持各种文字排版的区域创建绘制的区域，CoreText 本身支持各种文字排版的区域创建绘制的区域，CoreText 本身支持各种文字排版的区域"];
    CTFramesetterRef framesetter =  CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef framef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attString.length), path, NULL);
    CGFloat height = [self contentHeight:framef];
    NSLog(@"content height : %.2f",height);
//    开始绘画
    CTFrameDraw(framef, context);
    
//    释放资源
    CFRelease(framef);
    CFRelease(path);
    CFRelease(framesetter);
     */
}

- (CGFloat)contentHeight:(CTFrameRef)framef{
    CGFloat total_height = 0.0;
    NSArray *linesArray = (NSArray *) CTFrameGetLines(framef);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(framef, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 1000 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    
    return total_height;
}


@end
