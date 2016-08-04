//
//  TBCoreTextData.m
//  TBCoreTextDemo
//
//  Created by 思来氏 on 16/8/2.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//  模型类

#import "TBCoreTextData.h"
#import "TBCoreTextImageData.h"
@implementation TBCoreTextData



- (void)setCtFrame:(CTFrameRef)ctFrame{
    if (_ctFrame != ctFrame) {
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    [self fillImagePosition];
}


- (void)fillImagePosition {
    if (self.imageArray.count == 0) {
        return;
    }
    NSArray *linesArray = (NSArray*)CTFrameGetLines(_ctFrame);
    NSInteger lineCount = linesArray.count;
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    NSInteger imageIndex = 0;
    TBCoreTextImageData *tbImageData = self.imageArray[0];
    for (int i = 0; i < lineCount ; i ++ ) {
        if (!tbImageData) {
            break;
        }
        CTLineRef lineRef = (__bridge CTLineRef)(linesArray[i]);
        NSArray *runObjectArray = (NSArray *)CTLineGetGlyphRuns(lineRef);
        for (id runObj in runObjectArray) {
            CTRunRef runRef = (__bridge CTRunRef)(runObj);
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(runRef);
            CTRunDelegateRef runDelegateRef = (__bridge CTRunDelegateRef)([runAttributes objectForKey:(id)kCTRunDelegateAttributeName]);
            if (runDelegateRef == nil) {
                continue;
            }
            
            NSDictionary *metaDic = CTRunDelegateGetRefCon(runDelegateRef);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width = CTRunGetTypographicBounds(runRef, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            tbImageData.imagePosition = delegateBounds;
            imageIndex++;
            if (imageIndex == self.imageArray.count) {
                tbImageData = nil;
                break;
            }else{
                tbImageData = self.imageArray[imageIndex];
            }
        }
    }
}

- (void)dealloc{
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

@end
