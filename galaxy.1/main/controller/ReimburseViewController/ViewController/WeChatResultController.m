//
//  WeChatResultController.m
//  galaxy
//
//  Created by hfk on 2017/10/17.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "WeChatResultController.h"
#import "WeChatInvoiceModel.h"
@interface WeChatResultController ()

@end

@implementation WeChatResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"发票列表", nil) backButton:YES];
    self.view.backgroundColor=Color_White_Same_20;
    [self createTableView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}
-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_tableView registerNib:[UINib nibWithNibName:@"WeChatViewCell" bundle:nil] forCellReuseIdentifier:@"WeChatViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=Color_White_Same_20;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        
    }];
}

//MARK:tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSoure.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section!=0) {
        return 8;
    }else{
        return 80;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
    if (section!=0) {
        view.frame=CGRectMake(0, 0, Main_Screen_Width, 8);
        view.backgroundColor=Color_White_Same_20;
    }else{
        view.frame=CGRectMake(0, 0, Main_Screen_Width, 80);
        UILabel *title1=[GPUtils createLable:CGRectMake(12, 5, 80, 30) text:Custing(@"报销类型", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [view addSubview:title1];

        
        UILabel *lab1=[GPUtils createLable:CGRectMake(92, 5, Main_Screen_Width-24-80, 30) text:self.type font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [view addSubview:lab1];

        
        UILabel *title2=[GPUtils createLable:CGRectMake(12, 35, 80, 30) text:Custing(@"费用类别", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [view addSubview:title2];
        
        UILabel *lab2=[GPUtils createLable:CGRectMake(92, 35, Main_Screen_Width-24-80, 30) text:_category font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [view addSubview:lab2];
        view.backgroundColor=Color_form_TextFieldBackgroundColor;
        
        [view addSubview:[self createLineViewOfHeight:70]];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeChatInvoiceModel *model=_dataSoure[indexPath.section];
    return [WeChatViewCell cellHeightWithObj:model];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeChatViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WeChatViewCell"];
    if (cell==nil) {
        cell=[[WeChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WeChatViewCell"];
    }
    WeChatInvoiceModel *model=_dataSoure[indexPath.section];
    [cell configCellWithModel:model];
    [cell.Btn_LookPdf addTarget:self action:@selector(lookPdf:) forControlEvents:UIControlEventTouchUpInside];
    cell.Btn_LookPdf.tag=100+indexPath.section;
    return cell;
}
-(UIView *)createLineViewOfHeight:(CGFloat)height{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,height, Main_Screen_Width,10)];
    view.backgroundColor=Color_White_Same_20;
    return view;
}

-(void)lookPdf:(UIButton *)btn{
    WeChatInvoiceModel *model=_dataSoure[btn.tag-100];
    PDFLookViewController *pdf = [[PDFLookViewController alloc]init];
    pdf.url =model.pdf_url;
    [self.navigationController pushViewController:pdf animated:YES];

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
