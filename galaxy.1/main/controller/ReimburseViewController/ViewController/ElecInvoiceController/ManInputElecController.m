//
//  ManInputElecController.m
//  galaxy
//
//  Created by hfk on 2017/9/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ManInputElecController.h"

@interface ManInputElecController ()
@property (nonatomic, strong) UITextField *txf_code;
@property (nonatomic, strong) UITextField *txf_no;
@end

@implementation ManInputElecController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    [self setTitle:Custing(@"发票验证", nil) backButton:YES];
    [self createMainView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
#pragma mark - function
-(void)createMainView{
    UIView *CodeView=[[UIView alloc]init];
    CodeView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view addSubview:CodeView];
    [CodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    _txf_code=[[UITextField alloc]init];
    [CodeView addSubview:[[SubmitFormView alloc]initBaseView:CodeView WithContent:_txf_code WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"发票代码", nil) WithInfodict:nil WithTips:Custing(@"请输入10或者12位发票代码", nil) WithNumLimit:12]];
    
    
    UIView *NoView=[[UIView alloc]init];
    NoView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view addSubview:NoView];
    [NoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CodeView.bottom);
        make.left.right.equalTo(self.view);
    }];
    _txf_no=[[UITextField alloc]init];
    [NoView addSubview:[[SubmitFormView alloc]initBaseView:NoView WithContent:_txf_no WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"发票号码", nil) WithInfodict:nil WithTips:Custing(@"请输入8位发票号码", nil) WithNumLimit:8]];

    
    
    
    UIButton *btn = [GPUtils createButton:CGRectZero action:@selector(CheckInvoice:) delegate:self title:Custing(@"验证", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [btn setBackgroundColor:Color_Blue_Important_20];
    btn.layer.cornerRadius = 10.0f;
    [self.view addSubview:btn];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NoView.bottom).offset(@40);
        make.left.equalTo(self.view.left).offset(@12);
        make.right.equalTo(self.view.right).offset(@-12);
        make.height.equalTo(@49);
    }];
 
}

-(void)CheckInvoice:(id)obj{
    if (self.txf_code.text.length <=0||self.txf_code.text.length>12) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确发票代码", nil)];
        return;
    }
    if (self.txf_no.text.length <=0||self.txf_no.text.length >8) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确发票号码", nil)];
        return;
    }
    

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
