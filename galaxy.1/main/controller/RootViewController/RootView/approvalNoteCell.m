//
//  approvalNoteCell.m
//  galaxy
//
//  Created by hfk on 15/10/30.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "approvalNoteCell.h"

@implementation approvalNoteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)configViewWithModel:(approvalNoteModel *)model withCount:(NSInteger )count withIndex:(NSInteger)index
{
    NSInteger rowHeight=[approvalNoteCell NoteHeight:model];
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, rowHeight)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    self.approvalNameLabel=[GPUtils createLable:CGRectMake(40, 15, Main_Screen_Width-150, 20) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28  textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:self.approvalNameLabel];

    self.resultLabel = [GPUtils createLable:CGRectMake(Main_Screen_Width-15-60, 18, 60, 20) text:model.actionLinkName font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
    [self.mainView addSubview:self.resultLabel];

    _stateImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 17, 17)];
    _stateImgView.center=CGPointMake(19,24);
    [self.mainView addSubview:_stateImgView];
    
    if (index == 0) {
        self.resultLabel.textColor=[UIColor clearColor];
        self.stateImgView.image=[UIImage imageNamed:@"share_Finish"];

    }else{
        self.resultLabel.textColor=Color_GrayDark_Same_20;
        self.stateImgView.image=[UIImage imageNamed:@"share_Already"];
    }
    
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSString stringIsExist:model.handlerUserName]];
    if (index == count-1 && ![[NSString stringWithFormat:@"%@",model.handlerUserId]isEqualToString:[NSString stringWithFormat:@"%@",model.ownerUserId]]) {
        [array addObject:Custing(@"代", nil)];
        [array addObject:[NSString stringIsExist:model.ownerUserName]];
        [array addObject:Custing(@"申请", nil)];
    }
    if ([NSString isEqualToNull:model.nodeName]) {
        [array addObject:[NSString stringWithFormat:@" (%@)",model.nodeName]];
    }
    self.approvalNameLabel.text = [GPUtils getSelectResultWithArray:array WithCompare:@""];
    
    if (count > 1) {
        if (index == 0) {
            UIImageView *lineImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, rowHeight-X(_stateImgView)-HEIGHT(_stateImgView))];
            lineImage1.center = CGPointMake(19, rowHeight/2+X(_stateImgView)/2+HEIGHT(_stateImgView)/2+4);
            lineImage1.backgroundColor = Color_GrayLight_Same_20;
            [self.mainView addSubview:lineImage1];
        }else{
            UIImageView *lineImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 18)];
            lineImage1.center = CGPointMake(19, 8);
            lineImage1.backgroundColor = Color_GrayLight_Same_20;
            [self.mainView addSubview:lineImage1];
            if (index != count-1) {
                UIImageView *lineImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, rowHeight-X(_stateImgView)-HEIGHT(_stateImgView))];
                lineImage2.center = CGPointMake(19, rowHeight/2+X(_stateImgView)/2+HEIGHT(_stateImgView)/2+4);
                lineImage2.backgroundColor = Color_GrayLight_Same_20;
                [self.mainView addSubview:lineImage2];
            }
        }
    }
    
    if ([NSString isEqualToNull:model.comment]) {
        self.opinionLabel = [GPUtils createLable:CGRectMake(40, 40, Main_Screen_Width-55, 14) text:model.comment font:Font_Same_12_20 textColor:Color_Red_Weak_20 textAlignment:NSTextAlignmentLeft];
        self.opinionLabel.numberOfLines=0;
        CGSize size = [model.comment sizeCalculateWithFont:self.opinionLabel.font constrainedToSize:CGSizeMake(self.opinionLabel.frame.size.width, 10000) lineBreakMode:self.opinionLabel.lineBreakMode];
        self.opinionLabel.frame = CGRectMake(40,40,Main_Screen_Width-55,size.height);
        self.opinionLabel.text = model.comment;
        [self.mainView addSubview:self.opinionLabel];
        
        //时间
        self.dataLabel = [GPUtils createLable:CGRectMake(40,rowHeight-25, 115, 12) text:model.finishDate font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:self.dataLabel];
    }else{
        //时间
        self.dataLabel = [GPUtils createLable:CGRectMake(40, rowHeight-25, 115, 18) text:model.finishDate font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:self.dataLabel];
    }
}
+(CGFloat)NoteHeight:(id)object{
    approvalNoteModel *model = (approvalNoteModel *)object;
    if ([NSString isEqualToNull:model.comment]) {
        CGSize size = [model.comment sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-106, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
      return  75 + size.height;
    }else{
        return 70;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
