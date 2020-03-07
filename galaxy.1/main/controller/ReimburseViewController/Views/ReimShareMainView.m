//
//  ReimShareMainView.m
//  galaxy
//
//  Created by hfk on 2017/9/20.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ReimShareMainView.h"

@implementation ReimShareMainView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor=Color_form_TextFieldBackgroundColor;
    }
    return self;
}

-(void)updateReimShareMainViewWith:(NSMutableArray *)formShowData WithData:(NSMutableArray *)formData WithEditType:(NSInteger)editType WithComePlace:(NSInteger)comePlace{
    
    _formShowData=formShowData;
    _formData=formData;
    _editType=editType;
    _comePlace=comePlace;
    _MainHeight=0;
    _totalAmount=@"0";
    [self setUI];
    [self updateUI];
    
    
}
-(void)setUI{
    _ShareDetailView=[[UIView alloc]init];
    _ShareDetailView.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_ShareDetailView];
    [_ShareDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    
    _TableViewLine=[[UIView alloc]init];
    _TableViewLine.backgroundColor=Color_White_Same_20;
    [self addSubview:_TableViewLine];
    [_TableViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ShareDetailView.bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@0);
    }];
    
    _ShareTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _ShareTableView.backgroundColor=Color_White_Same_20;
    _ShareTableView.delegate=self;
    _ShareTableView.dataSource=self;
    _ShareTableView.scrollEnabled=NO;
    _ShareTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self addSubview:_ShareTableView];
    [_ShareTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TableViewLine.bottom);
        make.left.right.equalTo(self);
    }];
    
    
    _TotolAmountView=[[UIView alloc]init];
    _TotolAmountView.backgroundColor=Color_WhiteWeak_Same_20;
    [self addSubview:_TotolAmountView];
    [_TotolAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ShareTableView.bottom);
        make.left.right.equalTo(self);
    }];
    
    _AddDetailsView=[[UIView alloc]init];
    _AddDetailsView.backgroundColor=Color_White_Same_20;
    [self addSubview:_AddDetailsView];
    [_AddDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TotolAmountView.bottom);
        make.left.right.equalTo(self);
    }];
}
-(void)updateUI{
    if (_editType==1||_editType==3) {
        [_ShareDetailView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
        }];

        [_ShareDetailView addSubview:[self createLineView]];
        
        UILabel *title=[GPUtils createLable:CGRectMake(0,0,70, 50) text:Custing(@"费用分摊", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        title.center=CGPointMake(12+35, 10+25);
        title.numberOfLines=2;
        [_ShareDetailView addSubview:title];
        
        UIButton *btn=[GPUtils createButton:CGRectMake(Main_Screen_Width/2, 10, Main_Screen_Width/2, 50) action:@selector(LookShareDetailClick:) delegate:self];
        [_ShareDetailView addSubview:btn];
        
        _ShareDetailClickImg=[GPUtils createImageViewFrame:CGRectMake(0, 0, 20, 20) imageName:@"skipImage"];
        _ShareDetailClickImg.center=CGPointMake(Main_Screen_Width-12-10, 10+25);
        [_ShareDetailView addSubview:_ShareDetailClickImg];
    }
    
    if (_editType==1) {
                
        SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:_AddDetailsView withTitle:Custing(@"增加分摊", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model) {
            [weakSelf AddDetailsClick:nil];
        }];
        [_AddDetailsView addSubview:view];

    }
    
    _txf_Amount=[[GkTextField alloc]init];
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"合计金额", nil);
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_TotolAmountView WithContent:_txf_Amount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_TotolAmountView addSubview:view];
    
    if (_editType==1) {
        _isOpenShare=YES;
        [self updateTableViewEdit];
    }else if (_editType==2){
        _isOpenShare=NO;
        [self updateTableViewLook];
    }else if (_editType==3){
        _isOpenShare=YES;
        [self updateTableViewApprove];
    }
}
//MARK:更新分摊明细详情视图
-(void)updateTableViewEdit{
    [self getTableViewHeight];
    if (_isOpenShare==NO) {
        _ShareDetailClickImg.image=[UIImage imageNamed:@"skipImage"];
      
        [_ShareTableView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        
        [_TotolAmountView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        _TotolAmountView.hidden=YES;
        
        [_AddDetailsView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        
        [self updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
        }];
    }else if(_isOpenShare==YES){
        _ShareDetailClickImg.image=[UIImage imageNamed:@"share_Open"];
        
        [_ShareTableView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.tableHeight));
        }];
        if (_formData.count>0){
            [_TotolAmountView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@60);
            }];
            _TotolAmountView.hidden=NO;
            _MainHeight=60+60+50;
        }else{
            [_TotolAmountView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            _TotolAmountView.hidden=YES;
            _MainHeight=60+50;
        }
        
        [_AddDetailsView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
        }];
        
        [self updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.tableHeight+self.MainHeight));
        }];
    }
    [_ShareTableView reloadData];

}
-(void)updateTableViewLook{
    [self getTableViewHeight];
    [_TableViewLine updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
    }];
    if (_isOpenShare==NO) {
        NSMutableArray *array=[NSMutableArray arrayWithObject:_formData[0]];
        NSInteger height=[ReimShareCell ReimShareCellHeightWithArray:_formShowData WithModel:array[0]]+30;
        [_ShareTableView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
        
        [_TotolAmountView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        _TotolAmountView.hidden=YES;

        [self updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height+10));
        }];
    }else if(_isOpenShare==YES){
        
        [_ShareTableView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.tableHeight));
        }];
        [_TotolAmountView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
        }];
        _TotolAmountView.hidden=NO;

        [self updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.tableHeight+60+10));
        }];
    }
    [_ShareTableView reloadData];

}
-(void)updateTableViewApprove{
    [self getTableViewHeight];
    if (_isOpenShare==NO) {
        _ShareDetailClickImg.image=[UIImage imageNamed:@"skipImage"];
        [_ShareTableView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        
        [_TotolAmountView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        _TotolAmountView.hidden=YES;
        [self updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
        }];
    }else if(_isOpenShare==YES){
        _ShareDetailClickImg.image=[UIImage imageNamed:@"share_Open"];
        
        [_ShareTableView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.tableHeight));
        }];
        
        [_TotolAmountView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
        }];
        _TotolAmountView.hidden=NO;

        [self updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.tableHeight+60+60));
        }];
    }
    [_ShareTableView reloadData];
}

-(void)LookShareDetailClick:(id)obj{
    if (_isOpenShare==NO) {
        _isOpenShare=YES;
    }else if (_isOpenShare==YES){
        _isOpenShare=NO;
    }
    if (_editType==1) {
        [self updateTableViewEdit];
    }else if (_editType==2){
        [self updateTableViewLook];
    }else if (_editType==3){
        [self updateTableViewApprove];
    }
}
-(void)AddDetailsClick:(id)obj{
    if (self.ReimDoneClickedBlock) {
        self.ReimDoneClickedBlock(1, _comePlace, nil);
    }
}
//MARK:删除按钮点击
-(void)deleteDetails:(id)obj{
    NSLog(@"删除明细");
    UIButton *btn=(UIButton *)obj;
    UIAlertView *deleteDetilsAler=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@(%ld)?",Custing(@"你确定要删除分摊", nil),(long)(btn.tag-1200+1)] delegate:self cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:Custing(@"删除",nil), nil];
    deleteDetilsAler.tag=btn.tag-1200;
    [deleteDetilsAler show];
}
#pragma marks -- UIAlertViewDelegate
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
            [_formData removeObjectAtIndex:alertView.tag];
        if (_editType==1) {
            [self updateTableViewEdit];
        }else if (_editType==2){
            [self updateTableViewLook];
        }else if (_editType==3){
            [self updateTableViewApprove];
        }
    }
}
-(void)getTableViewHeight{
    _tableHeight=0;
    _totalAmount=@"0";
    for (ReimShareModel *model in _formData) {
        _tableHeight=_tableHeight+([ReimShareCell ReimShareCellHeightWithArray:_formShowData WithModel:model]+(_editType==2?30:27));
        _totalAmount=[GPUtils decimalNumberAddWithString:_totalAmount with:[NSString stringWithFormat:@"%@",model.Amount]];
    }
    _txf_Amount.text = [GPUtils transformNsNumber:_totalAmount];
}
-(UIView *)createLineView{
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    return view;
}
//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_ShareTableView){
        return _formData.count;
    }else{
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_ShareTableView){
        if (_editType==1||_editType==3) {
            return 27;
        }else if (_editType==2){
            return 30;
        }else{
            return 0.01;
        }
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==_ShareTableView){
        [self createHeadViewWithSection:section];
        return _ShareHeadView;
    }else{
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(0, 0, Main_Screen_Width, 0.01);
        return view;
    }
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_ShareTableView){
        return 1;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_ShareTableView){
        return [ReimShareCell ReimShareCellHeightWithArray:_formShowData WithModel:_formData[indexPath.section]];
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==_ShareTableView){
        ReimShareCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ReimShareCell"];
        if (cell==nil) {
            cell=[[ReimShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReimShareCell"];
        }
        [cell configReimShareCellWithArray:_formShowData withDetailsModel:_formData[indexPath.section] withindex:indexPath.section withCount:_formData.count];
        return cell;
    }else{
        return [[UITableViewCell alloc]init];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.ReimDoneClickedBlock) {
        ReimShareModel *model=_formData[indexPath.section];
        self.ReimDoneClickedBlock(2, _comePlace,model);
    }
}
#pragma mar-创建tableView头视图
-(void)createHeadViewWithSection:(NSInteger)section{
    if (_editType==1||_editType==3) {
        _ShareHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
        _ShareHeadView.backgroundColor=Color_White_Same_20;

        UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
        ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
        ImgView.backgroundColor=Color_Blue_Important_20;
        [_ShareHeadView addSubview:ImgView];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
        titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+90+8, 13.5);
        titleLabel.font=Font_Important_15_20 ;
        titleLabel.textAlignment=NSTextAlignmentLeft;
        titleLabel.textColor=Color_Unsel_TitleColor;
        [_ShareHeadView addSubview:titleLabel];
        
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"费用分摊", nil),(long)section+1];
        if (_editType==1) {
            UIButton *deleteBtn=[GPUtils createButton:CGRectMake(0, 0, 50, 30) action:@selector(deleteDetails:) delegate:self title:Custing(@"删除", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
            deleteBtn.center=CGPointMake(Main_Screen_Width-15-25, 13.5);
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            deleteBtn.tag=1200+section;
            [_ShareHeadView addSubview:deleteBtn];

        }
    }else if (_editType==2){
        _ShareHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30)];
        _ShareHeadView.backgroundColor=Color_form_TextFieldBackgroundColor;
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
        titleLabel.center=CGPointMake(90+12, 15);
        titleLabel.font=Font_Important_15_20 ;
        titleLabel.textAlignment=NSTextAlignmentLeft;
        titleLabel.textColor=Color_Unsel_TitleColor;
        [_ShareHeadView addSubview:titleLabel];
        
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"费用分摊", nil),(long)section+1];
        
        if (_formData.count>1&&section==0) {
            CGSize size = [_isOpenShare?Custing(@"收起", nil):Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
            CGFloat titleWidth=size.width;
            CGFloat imageWidth = 14;
            CGFloat btnWidth = titleWidth +imageWidth+24;
            UIButton *LookMore=[GPUtils createButton:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30) action:@selector(LookShareDetailClick:) delegate:self title:_isOpenShare?Custing(@"收起", nil):Custing(@"展开", nil) font:Font_Important_15_20 titleColor:Color_Blue_Important_20];
            LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
            LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
            [LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
            [_ShareHeadView addSubview:LookMore];
        }
    }
   
}

-(void)updateMainView{
    if (_editType==1) {
        [self updateTableViewEdit];
    }else if (_editType==2){
        [self updateTableViewLook];
    }else if (_editType==3){
        [self updateTableViewApprove];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

