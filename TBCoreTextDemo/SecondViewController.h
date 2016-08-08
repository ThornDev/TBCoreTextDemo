//
//  SecondViewController.h
//  TBCoreTextDemo
//
//  Created by 王绵杰 on 16/8/6.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBDisplayView.h"
#import "Config.h"
@interface SecondViewController : UIViewController

@property (weak, nonatomic) IBOutlet TBDisplayView *sDisplayView;
@property (weak, nonatomic) IBOutlet UIScrollView *sScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sDisplayViewConstrainHeight;
@end
