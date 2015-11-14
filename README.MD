
## Fist of all

*Don't use autolayout, it is boring and hard to crete great app. it is very hard to modify the UI precisely*
I use autlayou in my lastest App, it is easy to make some demo , but very hard to create beautiful app, to I am chaning all the autolayout to the pure code .

I recommand you don't use it , autolayout maybe easy, but not easy and fast in the last.

There are some defects I found:

1. hard to reuse the xib
2. hard to make animation as you want
3. hard to relayout views when  hidden or show some views
4. if we hidden/remove one view, it is complex to insert it again with constrants
5. hard to change layout as you want.
6. xib can't set width or height to 0.5, we need to change them with code
7. lots of constrants errors or warings , boring and diffcult to fix them
8. lots of strange error which is hard to fix

So I give up autolayout , there are some experences and code, share with everyone. 



##  how to set multiple line label

first all :

1. set `numberOfLines=0` or `numberOfLines>=2`
2. in xib , turn `prefered width explicit` on
3. set the constant to `>15`, not `==15`

####  what is `preferredMaxLayoutWidth`
In general, if a label want to get suitable height , fist of all, it should know the width, 
if we calculator it with code , is that:

````
//if numberOfLines=3, and we want to know the real size not more than 3 lines
{
        UILabel* lb=(id)_lbSignature;
        CGSize maximumLabelSize = CGSizeMake(lb.frame.size.width,1000);
         CGSize newSize =[lb sizeThatFits:maximumLabelSize];
        CHANGE_FRAME_HEIGHT(lb, newSize.height)
    }
````
or

````
//if numberOfLines=3, and we want to know the total size even the height is more than 3
{
        UILabel* lb=(id)[_vTableHeader viewWithTag:TAG_HEADER_LB_REMARK];
        lb.backgroundColor=TEST_COLOR_RED;
        CGSize maximumLabelSize = CGSizeMake(lb.frame.size.width,1000);
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:lb.font,NSFontAttributeName,nil];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:lb.text attributes:attributesDictionary];
        CGRect newFrame = [string boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CHANGE_FRAME_HEIGTH(lb, newFrame.size.height);
    }
````
well, for autolayout , we also need to set the width we want, it is `preferredMaxLayoutWidth `
of course we can calcultor the `preferredMaxLayoutWidth` with code, but it is not autolayout , isn't it ?

In fact, we can get suitable `preferredMaxLayoutWidth` in `viewDidLayoutSubviews` ,which we will introduce it later


##### what will happened if we don't set `preferredMaxLayoutWidth`

if your xib's width is 320, the UI is correct in iphone5s, 
but if it is ihone6/6p, the label widht and height is wrong


----
### How to use in Mutil line out fo Cell

just regist the label which is multiple line

````
- (void)viewDidLoad {
     [super viewDidLoad];
	/**
     *  register it for multiple line , 
     *  only this one line for label out of cell
     */
    [self.labelsNormalNeedSetPreferredWidth addObject:lbInfo];
    self.isAutolayoutHeader=YES;
}

````

you also need to set `self.isAutolayoutHeader=YES` , so when the header get the suitable height , it will layout  subviews


----
### How to use in Mutil line Cell

##### in `viewDidLoad`

````
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
	````
	
	//other's code
}
````

##### in the methods of `UITableViewDataSource`

````

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

//other's methods is all same
````


----
### How to use autolayout in custome view
if the custome view is use aotolayout ,use it as  usural

if the custome view is not use autolayout, when the frame is changed, call  `[self invalidateIntrinsicContentSize];`,
then the view will call `intrinsicContentSize `, the `intrinsicContentSize` is use to tell system the intrinsic size it is, 
just like label's width. 

my be you need to override `layoutSubviews ` to layout your subview .

````
#pragma mark autolayout
-(CGSize)intrinsicContentSize{//UIViewNoIntrinsicMetric
    if (_numberOfLines==0) {
        return CGSizeMake(UIViewNoIntrinsicMetric, _newHeight);
    } else {
        return CGSizeMake((_tagPaddingSize.height+_tagHeight)*_numberOfLines+_tagPaddingSize.height, _newHeight);
    }
}
-(void)layoutSubviews{
    [self layoutTagviews];
}
````

----
### How to create custome view whose view is load form xib file

````
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *customConstraints;


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit
{
    self.backgroundColor=[UIColor clearColor];
    _customConstraints = [[NSMutableArray alloc] init];
    
    UIView *view = nil;
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"EYGenderAgeView"
                                                     owner:self
                                                   options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[UIView class]]) {
            view = object;
            break;
        }
    }
    
    if (view != nil) {
        _containerView = view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        [self setNeedsUpdateConstraints];
    }
}
- (void)updateConstraints
{
    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];
    
    if (self.containerView != nil) {
        UIView *view = self.containerView;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"H:|[view]|" options:0 metrics:nil views:views]];
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"V:|[view]|" options:0 metrics:nil views:views]];
        
        [self addConstraints:self.customConstraints];
    }
    [super updateConstraints];
}
-(CGSize)intrinsicContentSize{//UIViewNoIntrinsicMetric
    CGSize size = self.lbAge.intrinsicContentSize;
    return CGSizeMake(size.width+14, 13);
}
````


----
###  Errors & Fixes


#### Error
````
2015-11-14 15:33:38.125 EYAutoLayoutDemo[13395:189143] Failed to instantiate the default view controller for UIMainStoryboardFile 'Main' - perhaps the designated entry point is not set?
2015-11-14 15:33:38.180 EYAutoLayoutDemo[13395:189143] Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want. 
	Try this: 
		(1) look at each constraint and try to figure out which you don't expect; 
		(2) find the code that added the unwanted constraint or constraints and fix it. 
(
    "<NSLayoutConstraint:0x7fb8d0cab980 UILabel:0x7fb8d0ca7360'Label'.top == UITableViewCellContentView:0x7fb8d0c088a0.topMargin + 3>",
    "<NSLayoutConstraint:0x7fb8d0cab9d0 UILabel:0x7fb8d0ca7360'Label'.centerY == UITableViewCellContentView:0x7fb8d0c088a0.centerY>",
    "<NSLayoutConstraint:0x7fb8d0e3da50 'UIView-Encapsulated-Layout-Height' V:[UITableViewCellContentView:0x7fb8d0c088a0(11.5)]>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x7fb8d0cab9d0 UILabel:0x7fb8d0ca7360'Label'.centerY == UITableViewCellContentView:0x7fb8d0c088a0.centerY>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKit/UIView.h> may also be helpful.

````
#### Fixes

when I'm calculator the height of the cell, the height of cell is 0, so constrants is error, 
*just set top margin's priority to 999*


### some code

````

````
