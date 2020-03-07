//
//  NoticeOrderViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "NoticeOrderViewController.h"

@interface NoticeOrderViewController ()

@end

@implementation NoticeOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"订单通知" backButton:YES];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
