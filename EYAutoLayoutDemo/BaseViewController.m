//
//  BaseViewController.m
//  EYAutoLayoutDemo
//
//  Created by ericyang on 11/14/15.
//  Copyright © 2015 Eric Yang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (nonatomic,strong) NSMutableDictionary* sizingCells;
@end

@implementation BaseViewController
{
    int _viewDidLayoutSubviewsCount;//TODO: not a good solution, change it later
    NSTimeInterval _lastLayoutSubViewTime;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _viewDidLayoutSubviewsCount=0;
    
    _dataItems=[NSMutableArray new];
    _isAutolayoutHeader=NO;
    _isAutolayoutFooter=NO;
    _labelsNormalNeedSetPreferredWidth=[NSMutableArray new];
    
    
    _cellsForPreferredWidth=[NSMutableDictionary new];
    _labelsInCellNeedSetPreferredWidth=[NSMutableDictionary new];
    
    _sizingCells=[NSMutableDictionary new];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark preferredMaxLayoutWidth

-(float)getLabelPreferredWidthWithLabelTag:(NSInteger)labelTag{
    return [self getLabelPreferredWidthWithIdentifier:@"Cell" labelTag:labelTag];
}

-(float)getLabelPreferredWidthWithIdentifier:(NSString *)identifier labelTag:(NSInteger)labelTag{
    NSArray* tagAndWidths=_labelsInCellNeedSetPreferredWidth[identifier];
    for (NSMutableDictionary* dic in tagAndWidths) {
        NSInteger tag=((NSNumber*)dic.allKeys.firstObject).integerValue;
        float preferredWidth=((NSNumber*)dic.allValues.firstObject).floatValue;
        if (tag==labelTag) {
            return preferredWidth;
        }
    }
    return SCREEN_WIDTH;
    
}
-(void)registMultiLineCellWithLabelTag:(NSInteger)tag{
    [self registMultiLineCellWithIdentifier:@"Cell" labelTag:tag];
}

-(void)registMultiLineCellWithIdentifier:(NSString *)identifier labelTag:(NSInteger)tag{
    UITableViewCell *cell = [self.tbItems dequeueReusableCellWithIdentifier:identifier];
    //refresh cell
    CHANGE_FRAME_WIDTH(cell,self.view.frame.size.width)
    cell.center=self.view.center;
    [_cellsForPreferredWidth setObject:cell forKey:identifier];
    
    NSMutableArray* tags=_labelsInCellNeedSetPreferredWidth[identifier];
    if (!tags) {
        tags=[NSMutableArray new];
        [_labelsInCellNeedSetPreferredWidth setObject:tags forKey:identifier];
    }
    [tags addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:SCREEN_WIDTH],[NSNumber numberWithFloat:tag], nil]];
    cell.autoresizingMask=UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    cell.hidden=YES;
    [self.view addSubview:cell];
    [cell layoutSubviews];
    [cell setNeedsLayout];
}


-(void)viewDidLayoutSubviews{
    BOOL isOver=NO;
    if (_viewDidLayoutSubviewsCount++ >10) {
        isOver=YES;
    }
    NSTimeInterval now=[[NSDate date]timeIntervalSince1970];
    if (now - _lastLayoutSubViewTime >1) {
        isOver=YES;
    }else{
        _lastLayoutSubViewTime=[[NSDate date]timeIntervalSince1970];
    }
    
    for (UILabel* lb in _labelsNormalNeedSetPreferredWidth) {
        lb.preferredMaxLayoutWidth = lb.frame.size.width;
    }
    
    NSMutableArray* cellIdsFinishedLayout=[NSMutableArray new];
    for (NSString* cellId in _cellsForPreferredWidth.keyEnumerator) {
        UITableViewCell* cell=_cellsForPreferredWidth[cellId];
        {
            [cell removeFromSuperview];
            [cellIdsFinishedLayout addObject:cellId];
            
            NSArray* tagAndWidths=_labelsInCellNeedSetPreferredWidth[cellId];
            for (NSMutableDictionary* dic in tagAndWidths) {
                NSInteger tag=((NSNumber*)dic.allKeys.firstObject).integerValue;
                UILabel* lb=(id)[cell viewWithTag:tag];
                [dic setObject:[NSNumber numberWithFloat:lb.frame.size.width] forKey:[NSNumber numberWithInteger:tag]];
                if (!isOver) {
                    [self.tbItems reloadData];
                }
            }
            
        }
    }
    
    if (self.tbItems) {
        if (self.tbItems.tableHeaderView
            && _isAutolayoutHeader) {
            [self sizeHeaderToFit:self.tbItems];
        }
        if (self.tbItems.tableFooterView
            && _isAutolayoutFooter) {
            [self sizeFooterToFit:self.tbItems];
        }
    }
}

- (void)sizeHeaderToFit:(UITableView*)tb
{
    [self sizeHeaderToFit:tb offset:0];
}
- (void)sizeHeaderToFit:(UITableView*)tb offset:(float)offset
{
    [UIView animateWithDuration:0.01 animations:^{
        UIView *header = tb.tableHeaderView;
        [header setNeedsLayout];
        [header layoutIfNeeded];
        CGSize size=[header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        CGFloat height = size.height;
        CGRect frame = header.frame;
        frame.size.height = height+offset;
        header.frame = frame;
        tb.tableHeaderView = header;
    }];
}


- (void)sizeFooterToFit:(UITableView*)tb
{
    [self sizeFooterToFit:tb offset:0];
}
- (void)sizeFooterToFit:(UITableView*)tb offset:(float)offset
{
    [UIView animateWithDuration:0.01 animations:^{
        UIView *header = tb.tableFooterView;
        [header setNeedsLayout];
        [header layoutIfNeeded];
        CGSize size=[header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        CGFloat height = size.height;
        CGRect frame = header.frame;
        frame.size.height = height+offset;
        header.frame = frame;
        tb.tableFooterView = header;
    }];
}


#pragma mark tableview autolayout
-(CGFloat)base_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* sizingCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(tableView.bounds));
    [self configureCell:sizingCell forIndexPath:indexPath];
    [sizingCell setNeedsLayout];
    [sizingCell layoutSubviews];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat height=size.height+1;
    return height;
}
-(CGFloat)base_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath identifier:(NSString*)identifier{
    UITableViewCell *sizingCell =_sizingCells[identifier];
    if (!sizingCell) {
        sizingCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        [_sizingCells setObject:sizingCell forKey:identifier];
    }
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(tableView.bounds));
    [self configureCell:sizingCell forIndexPath:indexPath];
    [sizingCell setNeedsLayout];
    [sizingCell layoutSubviews];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat height=size.height+1;
    return height;
}
-(void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"overwrite me !!!!!!!!!!!!! %s %d",__FUNCTION__,__LINE__);
}


@end
