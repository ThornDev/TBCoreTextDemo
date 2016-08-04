//
//  ViewController.m
//  TBCoreTextDemo
//
//  Created by 思来氏 on 16/8/2.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//

#import "ViewController.h"
#import "TBDisplayView.h"
#import "Config.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet TBDisplayView *tbDisplayView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TBFrameParserConfig *config = [[TBFrameParserConfig alloc] init];
//    config.textColor = [UIColor redColor];
    config.width = self.tbDisplayView.width;
    
//    TBCoreTextData *data = [TBFrameParser parseContent:@"按照以上原则，我们将`CTDisplayView`中的部分内容拆开。"
//                                                config:config];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ContentConfig" ofType:@"json"];
    TBCoreTextData *data = [TBFrameParser parseTemplateFile:path config:config];

    self.tbDisplayView.tbData = data;
    self.tbViewHeightConstraint.constant = data.height;
    self.tbDisplayView.backgroundColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
