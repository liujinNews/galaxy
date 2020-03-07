//
//  CarFilterViewController.m
//  galaxy
//
//  Created by hfk on 2018/7/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "CarFilterViewController.h"
#import "DoneBtnView.h"
@interface CarFilterViewController ()

@property (nonatomic, strong) UITextField *txf_model;
@property (nonatomic, strong) UITextField *txf_seat;

@end

@implementation CarFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =Color_White_Same_20;
    [self setTitle:Custing(@"筛选车辆", nil) backButton:YES];
    [self createView];
}

-(void)createView{
    
    UIView *modelView=[[UIView alloc]init];
    modelView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view addSubview:modelView];
    [modelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.right.equalTo(self.view);
    }];
    _txf_model=[[UITextField alloc]init];
    [modelView addSubview:[[SubmitFormView alloc]initBaseView:modelView WithContent:_txf_model WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"车辆型号", nil) WithTips:Custing(@"请输入车辆型号", nil)  WithInfodict:nil]];
    
    
    UIView *SeatView=[[UIView alloc]init];
    SeatView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view addSubview:SeatView];
    [SeatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(modelView.bottom);
        make.left.right.equalTo(self.view);
    }];
    _txf_seat=[[UITextField alloc]init];
    [SeatView addSubview:[[SubmitFormView alloc]initBaseView:SeatView WithContent:_txf_seat WithFormType:formViewEnterNum WithSegmentType:lineViewNoneLine WithString:Custing(@"座位数量", nil) WithTips:Custing(@"请输入座位数量", nil) WithInfodict:nil]];

    
    
    DoneBtnView *btn =[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    btn.userInteractionEnabled=YES;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [btn updateNewFormViewWithTitleArray:@[Custing(@"确定", nil)]];
    __weak typeof(self) weakSelf = self;
    btn.btnClickBlock = ^(NSInteger index) {
        if (index==0) {
            if (weakSelf.filterCarBlock) {
                weakSelf.filterCarBlock(@{@"model":[NSString stringIsExist:weakSelf.txf_model.text],@"seats":[NSString stringIsExist:weakSelf.txf_seat.text]});
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
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
