//
//  ViewController.m
//  72fAssignment
//
//  Created by allamaprabhu on 5/29/15.
//  Copyright (c) 2015 72f. All rights reserved.
//

#import "ViewController.h"
#import "WheelControl.h"

@interface ViewController ()
@property (nonatomic,strong) WheelControl *wheelControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wheelControl = [[WheelControl alloc] initWithFrame:self.view.bounds];
//    self.wheelControl.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.wheelControl];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
