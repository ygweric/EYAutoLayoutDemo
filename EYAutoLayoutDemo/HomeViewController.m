//
//  HomeViewController.m
//  EYAutoLayoutDemo
//
//  Created by ericyang on 11/14/15.
//  Copyright © 2015 Eric Yang. All rights reserved.
//

#import "HomeViewController.h"

#define TAG_CELL_LB_TITLE 1001
#define TAG_HEAD_LB_INFO 2001

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    
    /**
     *  !!!!
     *  If you have multiple line of label in Cell,
     *  the following line must be called before [super viewDidLoad];
     */
    REGISTER_NIB(self.tbItems, @"HomeViewControllerCell");
    [self registMultiLineCellWithLabelTag:TAG_CELL_LB_TITLE];
    
    /**
     *  default cel identifier is @"Cell"
     *  if you use other's identifier use
     
     REGISTER_NIB_IDENTIFIER(self.tbItems, @"HomeViewControllerCell1",@"Cell1")
     REGISTER_NIB_IDENTIFIER(self.tbItems, @"HomeViewControllerCell1",@"Cell1")
     REGISTER_NIB_IDENTIFIER(self.tbItems, @"HomeViewControllerCell1",@"Cell1")
     
     [self registMultiLineCellWithIdentifier:@"Cell1" labelTag:TAG_CELL_LB_TITLE_1];
     [self registMultiLineCellWithIdentifier:@"Cell2" labelTag:TAG_CELL_LB_TITLE_1];

     */
    
    [super viewDidLoad];
    
    self.title=@"EYAutoLayoutDemo";
    self.tbItems.tableFooterView=[UIView new];
    
    UIView* vHeader=LOAD_VIEW_WITH_NIB(@"HomeViewControllerHeader");
    UILabel* lbInfo=[(id)vHeader viewWithTag:TAG_HEAD_LB_INFO];
    lbInfo.text=@"well, for autolayout , we also need to set the width we want, it is preferredMaxLayoutWidth     of course we can calcultor the `preferredMaxLayoutWidth` with code, but it is not autolayout , isn't it ?";
    self.tbItems.tableHeaderView=vHeader;
    
    /**
     *  register it for multiple line , 
     *  only this one line for label out of cell
     */
    [self.labelsNormalNeedSetPreferredWidth addObject:lbInfo];
    self.isAutolayoutHeader=YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}
- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    UILabel *lbTitle = (id)[cell viewWithTag:TAG_CELL_LB_TITLE];
    lbTitle.preferredMaxLayoutWidth=[self getLabelPreferredWidthWithLabelTag:TAG_CELL_LB_TITLE ];
      switch (indexPath.row) {
        case 0:
        {
            lbTitle.text=@"multiple line label";
        }
            break;
        case 1:
        {
            lbTitle.text=@"multiple line label in cell";
        }
            break;
        case 2:
        {
            lbTitle.text=@"multiple line label in tableview's header";
        }
            break;
        default:
        {
            lbTitle.text=@"this is multi line label, this is multi line label, this is multi line label, this is multi line label, this is multi line label, this is multi line label, this is multi line label, this is multi line label,";
        }
            break;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self base_tableView:tableView heightForRowAtIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            //@"multiple line label";
        }
            break;
        case 1:
        {
            //@"multiple line label in cell";
        }
            break;
        case 2:
        {
            //@"multiple line label in tableview's header";
        }
            break;
        default:
        {
            //@"none";
        }
            break;
    }
    
}

@end
