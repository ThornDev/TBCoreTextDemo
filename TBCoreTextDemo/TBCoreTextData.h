//
//  TBCoreTextData.h
//  TBCoreTextDemo
//
//  Created by 思来氏 on 16/8/2.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreText/CoreText.h"
@interface TBCoreTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSArray *imageArray;
@end
