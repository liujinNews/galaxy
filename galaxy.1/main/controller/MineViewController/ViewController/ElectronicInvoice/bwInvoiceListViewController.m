//
//  bwInvoiceListViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/11/20.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "bwInvoiceListViewController.h"
#import "bwInvoiceListTableViewCell.h"
#import "bwInvoiceImportViewController.h"

@interface bwInvoiceListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btn_Lead;
@property (weak, nonatomic) IBOutlet UITableView *tbv_tableView;

@property (nonatomic, strong) NSMutableArray *arr_submit;

@end

@implementation bwInvoiceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:Custing(@"发票详情", nil) backButton:YES];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"取消", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(Navback)];
    
    _tbv_tableView.backgroundColor = Color_White_Same_20;
    _tbv_tableView.allowsMultipleSelection = YES;//设置可以多选高亮
    _tbv_tableView.tableFooterView = [[UIView alloc]init];
    _arr_submit = [NSMutableArray array];
}

#pragma mark - function

#pragma mark - action
- (IBAction)btn_Lead_Click:(id)sender {
    if (_arr_submit.count>0) {
        bwInvoiceImportViewController *bw = [[bwInvoiceImportViewController alloc]init];
        bw.arr_Data = _arr_submit;
        bw.str_AccountNo = _str_AccountNo;
        bw.str_AccountType = _str_AccountType;
        [self.navigationController pushViewController:bw animated:YES];
    }else{
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"没有选择任何单据", nil) duration:1.5];
    }
}

#pragma mark - delegate
#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr_showData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    bwInvoiceListTableViewCell *Cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!Cell) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"bwInvoiceListTableViewCell" owner:self options:nil];
        Cell = [arr lastObject];
    }
    NSDictionary *dic = _arr_showData[indexPath.row];
    Cell.lab_amount.text = [NSString isEqualToNull:dic[@"jshj"]]?dic[@"jshj"]:@"";
    Cell.lab_type.text = [NSString isEqualToNull:dic[@"kpxm"]]?dic[@"kpxm"]:@"";
    Cell.lab_name.text = [NSString isEqualToNull:dic[@"xsF_MC"]]?dic[@"xsF_MC"]:@"";
    Cell.lab_time.text = [NSString isEqualToNull:dic[@"kprq"]]?[NSString stringWithDateBystring:dic[@"kprq"]]:@"";
    return Cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _arr_showData[indexPath.row];
    BOOL isadd = NO;
    for (int i = 0; i<_arr_submit.count; i++) {
        NSDictionary *dics = _arr_submit[i];
        if ([dics[@"fpfm"] isEqualToString:dic[@"fpfm"]]) {
            isadd = YES;
        }
    }
    if (!isadd) {
        [_arr_submit addObject:dic];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _arr_showData[indexPath.row];
    for (int i = 0; i<_arr_submit.count; i++) {
        NSDictionary *dics = _arr_submit[i];
        if ([dics[@"fpfm"] isEqualToString:dic[@"fpfm"]]) {
            [_arr_submit removeObjectAtIndex:i];
        }
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
