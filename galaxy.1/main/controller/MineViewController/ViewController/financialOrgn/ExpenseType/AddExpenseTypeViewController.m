//
//  AddExpenseTypeViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/7/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "AddExpenseTypeViewController.h"

@interface AddExpenseTypeViewController ()<UITextViewDelegate>

@end

@implementation AddExpenseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = Color_White_Same_20;
    if (_type==1) {
        [self setTitle:@"Add Expense Type/Purpose" backButton:YES];
        _txf_text.placeholder = @"Expense Type/Purpose";
    }
    if (_type==2) {
        [self setTitle:@"Edit Expense Type/Purpose" backButton:YES];
        _txf_text.placeholder = @"Expense Type/Purpose";
        _txf_text.text = _str_txf;
    }
    if (_type==3) {
        [self setTitle:@"Add Expense Type/Purpose - Sub" backButton:YES];
        _txf_text.placeholder = @"Expense Type/Purpose - Sub";
        _txf_text.hidden = YES;
        _txv_textview.hidden = NO;
        _txv_textview.delegate = self;
        _txv_textview.text =  @"Expense Type/Purpose - Sub";
        _txv_textview.textColor = Color_White_Same_20;
    }
    if (_type==4) {
        [self setTitle:@"Edit Expense Type/Purpose - Sub" backButton:YES];
        _txf_text.placeholder = @"Expense Type/Purpose - Sub";
        _txf_text.text = _str_txf;
        _txv_textview.hidden = NO;
        _txv_textview.delegate = self;
        _txv_textview.text =  @"Expense Type/Purpose - Sub";
        if ([NSString isEqualToNull:_str_txf]) {
            _txv_textview.text = _str_txf;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

- (IBAction)btn_OK_click:(UIButton *)sender {
    if (_type==3||_type==4) {
        if (![NSString isEqualToNull:_txv_textview.text]||[_txv_textview.text isEqualToString:@"Expense Type/Purpose - Sub"]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入内容", nil) duration:1.0];
            return;
        }
        if (_txv_textview.text.length>=250) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"内容太长", nil) duration:1.0];
            return;
        }
        [self.delegate AddExpenseTypeBtn:_txv_textview.text type:_type];
    }
    else{
        if (![NSString isEqualToNull:_txf_text.text]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入内容", nil) duration:1.0];
            return;
        }
        [self.delegate AddExpenseTypeBtn:_txf_text.text type:_type];
    }
    [self Navback];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([_txv_textview.text isEqualToString:@"Expense Type/Purpose - Sub"]) {
        _txv_textview.text = @"";
        _txv_textview.textColor = Color_Unsel_TitleColor;
    }
    if (textView.text.length>=250) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"内容太长", nil) duration:1.0];
        return NO;
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length>=250) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"内容太长", nil) duration:1.0];
        return NO;
    }
    return YES;
}


-(void)textViewDidChange:(UITextView *)textView{
//    CGFloat size =[NSString getLabelWidth:15 biggestWidth:Main_Screen_Width-30 text:textView.text];
    CGSize size = [NSString sizeWithText:textView.text font:Font_Important_15_20 maxSize:CGSizeMake(Main_Screen_Width-40, MAXFLOAT)];
    
    _lay_txfview_hight.constant = size.height>34?size.height+30:44;
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
