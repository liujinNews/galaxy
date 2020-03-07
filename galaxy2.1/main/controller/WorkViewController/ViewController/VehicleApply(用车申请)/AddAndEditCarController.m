//
//  AddAndEditCarController.m
//  galaxy
//
//  Created by hfk on 2018/7/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AddAndEditCarController.h"

@interface AddAndEditCarController ()<UIScrollViewDelegate,GPClientDelegate>
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;

@property (nonatomic, strong) UITextField *txf_CarNo;
@property (nonatomic, strong) UITextField *txf_CarModel;
@property (nonatomic, strong) UITextField *txf_CarSeats;
@property (nonatomic, strong) UITextView *txv_CarDes;
@property (nonatomic, strong) NSString *str_Id;


@end

@implementation AddAndEditCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    if (self.dict_Info) {
        [self setTitle:Custing(@"编辑车辆", nil) backButton:YES];
    }else{
        [self setTitle:Custing(@"新增车辆", nil) backButton:YES];
    }
    _str_Id=@"";
    [self createMainView];
    [self checkInData];
}
-(void)createMainView{
    
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-50);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    
    DoneBtnView *dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    dockView.userInteractionEnabled=YES;
    [self.view addSubview:dockView];
    [dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [dockView updateNewFormViewWithTitleArray:@[Custing(@"确定", nil)]];
    __weak typeof(self) weakSelf = self;
    dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0) {
            [weakSelf saveInfo];
        }
    };
    
    
    UIView * CarNoView=[[UIView alloc]init];
    CarNoView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:CarNoView];
    [CarNoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    _txf_CarNo=[[UITextField alloc]init];
    [CarNoView addSubview:[[SubmitFormView alloc]initBaseView:CarNoView WithContent:_txf_CarNo WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"车牌号", nil) WithTips:[NSString stringWithFormat:@"%@%@",Custing(@"请输入车牌号", nil),Custing(@"必填", nil)]  WithInfodict:nil]];
    
    UIView *CarModelView=[[UIView alloc]init];
    CarModelView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:CarModelView];
    [CarModelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CarNoView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_CarModel=[[UITextField alloc]init];
    [CarModelView addSubview:[[SubmitFormView alloc]initBaseView:CarModelView WithContent:_txf_CarModel WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"车辆型号", nil) WithTips:Custing(@"请输入车辆型号", nil)  WithInfodict:nil]];
    
    
    UIView *CarSeatsView=[[UIView alloc]init];
    CarSeatsView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:CarSeatsView];
    [CarSeatsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CarModelView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_CarSeats=[[UITextField alloc]init];
    [CarSeatsView addSubview:[[SubmitFormView alloc]initBaseView:CarSeatsView WithContent:_txf_CarSeats WithFormType:formViewEnterNum WithSegmentType:lineViewNoneLine WithString:Custing(@"座位数量", nil) WithTips:Custing(@"请输入座位数量", nil) WithInfodict:nil]];
    
    
    UIView *DesView=[[UIView alloc]init];
    DesView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:DesView];
    [DesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CarSeatsView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txv_CarDes=[[UITextView alloc]init];
    [DesView addSubview:[[SubmitFormView alloc]initBaseView:DesView WithContent:_txv_CarDes WithFormType:formViewEnterTextView WithSegmentType:lineViewNoneLine WithString:Custing(@"车辆描述", nil) WithTips:Custing(@"请输入车辆描述", nil) WithInfodict:@{@"value1":[NSString stringWithIdOnNO:self.dict_Info[@"carDesc"]]}]];
  

    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(DesView.bottom);
    }];
}
-(void)checkInData{
    if (self.dict_Info) {
        _txf_CarNo.text = [NSString stringWithIdOnNO:self.dict_Info[@"carNo"]];
        _txf_CarModel.text = [NSString stringWithIdOnNO:self.dict_Info[@"carModel"]];
        _txf_CarSeats.text = [NSString stringWithIdOnNO:self.dict_Info[@"seats"]];
        _str_Id = [NSString stringIsExist:_dict_Info[@"id"]];
    }
}

-(void)saveInfo{
    if (![NSString isEqualToNull:_txf_CarNo.text]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入车牌号", nil) duration:2.0];
        return;
    }
    NSDictionary * dic =@{
                          @"Id":_str_Id,
                          @"CarNo":[NSString stringIsExist:_txf_CarNo.text],
                          @"CarDesc":[NSString stringIsExist:_txv_CarDes.text],
                          @"CarModel":[NSString stringIsExist:_txf_CarModel.text],
                          @"Seats":[NSString stringIsExist:_txf_CarSeats.text],
                          @"Type":@"2"
                          };
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",SaveVehicleInfo] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    if ([[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]] isEqualToString:@"-1"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"车辆已存在", nil) duration:1.0];
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:_dict_Info?Custing(@"修改成功", nil):Custing(@"新增成功", nil) duration:2.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1];
        }
            break;
        default:
            break;
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
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
