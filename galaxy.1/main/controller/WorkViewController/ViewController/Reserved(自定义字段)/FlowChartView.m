//
//  FlowChartView.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/7/12.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FlowChartView.h"

@implementation FlowChartView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(FlowChartView *)init:(NSArray *)arr Y:(NSInteger)Y HeightBlock:(FlowChartView_Height)block BtnBlock:(FlowChartView_btn_Click)btnblock{
    if (arr==nil) {
        arr = [NSArray array];
    }
    self = [super init];
    if (!self) {
        self = [[FlowChartView alloc]initWithFrame: CGRectMake(0, Y, Main_Screen_Width, 0)];
    }
    self.array = arr;
    [self dealWithHeight];
    self.frame=CGRectMake(0, Y, Main_Screen_Width, _NotesTableHeight);
    self.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.btnBlock = btnblock;
    self.HeightBlock = block;
    if (arr.count>0) {
        UITableView *tbv = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStylePlain];
        tbv.dataSource = self;
        tbv.delegate = self;
        tbv.scrollEnabled =NO;
        tbv.separatorStyle = UITableViewCellSeparatorStyleNone;;
        [self addSubview:tbv];
    }
    if (self.HeightBlock) {
        self.HeightBlock(_NotesTableHeight);
    }
    return self;
}

-(void)Flow_Click:(UIButton *)btn{
    if (self.btnBlock) {
        self.btnBlock();
    }
}

-(void)dealWithHeight{
    _NotesTableHeight = 0;
    for (approvalNoteModel *model in _array) {
        if ([NSString isEqualToNull:model.comment]) {
            CGSize size = [model.comment sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-106, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
            _NotesTableHeight=_NotesTableHeight+75+size.height;
        }else{
            _NotesTableHeight=_NotesTableHeight+70;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    approvalNoteModel *model=(approvalNoteModel *)_array[indexPath.row];
    return [approvalNoteCell NoteHeight:model];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    approvalNoteCell *cell=[tableView dequeueReusableCellWithIdentifier:@"approvalNoteCell"];
    if (cell==nil) {
        cell=[[approvalNoteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"approvalNoteCell"];
    }
    if (indexPath.row == 0) {
        UIButton *btn = [GPUtils createButton:CGRectMake(Main_Screen_Width-60, 15, 90, 25) action:@selector(Flow_Click:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"流程图", nil) font:Font_Same_14_20 color:Color_Blue_Important_20];
        [cell addSubview:btn];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        btn.layer.cornerRadius = 12.5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = Color_Blue_Important_20.CGColor;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 12.5, 0, 0);
    }
    approvalNoteModel *model=(approvalNoteModel *)_array[indexPath.row];
    [cell configViewWithModel:model withCount:_array.count withIndex:indexPath.row];
    return cell;
}


@end
