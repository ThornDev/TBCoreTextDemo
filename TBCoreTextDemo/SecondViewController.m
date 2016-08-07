//
//  SecondViewController.m
//  TBCoreTextDemo
//
//  Created by 王绵杰 on 16/8/6.
//  Copyright © 2016年 ThornDemo. All rights reserved.
//   增加UIScrollView

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DBLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    DBLog(@"viewDidAppear");
    TBFrameParserConfig *config = [[TBFrameParserConfig alloc] init];
    //    config.textColor = [UIColor redColor];
    config.width = self.sScrollView.width;
    
    //    TBCoreTextData *data = [TBFrameParser parseContent:@"按照以上原则，我们将`CTDisplayView`中的部分内容拆开。"
    //                                                config:config];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ContentConfig" ofType:@"json"];
    TBCoreTextData *data = [TBFrameParser parseTemplateFile:path config:config];
    self.sDisplayViewConstrainHeight.constant = data.height;
    self.sDisplayView.tbData = data;
    self.sDisplayView.backgroundColor = [UIColor lightGrayColor];

}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    DBLog(@"viewWillLayoutSubviews");
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    DBLog(@"viewDidLayoutSubviews");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
