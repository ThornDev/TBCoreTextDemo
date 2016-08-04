//
//  TBCoreTextImageData.h
//  TBCoreTextDemo
//
//  Created by 思来氏 on 16/8/3.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
@interface TBCoreTextImageData : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger position;
//此坐标是 CoreText的坐标，而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;
@property (nonatomic) NSInteger singleLine;
@property (nonatomic) CGFloat containerWidth;


@end
