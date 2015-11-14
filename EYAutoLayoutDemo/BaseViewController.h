//
//  BaseViewController.h
//  EYAutoLayoutDemo
//
//  Created by ericyang on 11/14/15.
//  Copyright © 2015 Eric Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tbItems;
@property (nonatomic,strong) NSMutableArray* dataItems;

// for header or footer
@property (nonatomic) BOOL isAutolayoutHeader;
@property (nonatomic) BOOL isAutolayoutFooter;
@property (nonatomic, strong) NSMutableArray* labelsNormalNeedSetPreferredWidth;// preferredMaxLayoutWidth

/**
 *  for tableviewcell
 *
 */

// string- mutable_arr[mutable_dic,...]
// cellId ~ @[@{label_tag:label_preferred_width},...]
@property (nonatomic, strong) NSMutableDictionary* labelsInCellNeedSetPreferredWidth;
// cellId ~ cell
@property (nonatomic, strong) NSMutableDictionary* cellsForPreferredWidth;



-(float)getLabelPreferredWidthWithLabelTag:(NSInteger)labelTag;
-(float)getLabelPreferredWidthWithIdentifier:(NSString *)identifier labelTag:(NSInteger)labelTag;
-(void)registMultiLineCellWithLabelTag:(NSInteger)tag;
-(void)registMultiLineCellWithIdentifier:(NSString *)identifier labelTag:(NSInteger)tag;


- (void)sizeHeaderToFit:(UITableView*)tb;
- (void)sizeFooterToFit:(UITableView*)tb;


-(CGFloat)base_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(CGFloat)base_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath identifier:(NSString*)identifier;
-(void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
@end
