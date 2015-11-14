//
//  PubHeader.h
//  EYAutoLayoutDemo
//
//  Created by ericyang on 11/14/15.
//  Copyright © 2015 Eric Yang. All rights reserved.
//

#ifndef PubHeader_h
#define PubHeader_h




#define SCREEN_HEIGHT ([[UIScreen mainScreen ] bounds ].size.height)
#define SCREEN_WIDTH ([[UIScreen mainScreen ] bounds ].size.width)





#define INDEXPATH_SUBVIEW_TABLEVIEW(subview,tableview)\
({\
CGRect subviewFrame = [subview convertRect:subview.bounds toView:tableview];\
NSIndexPath *indexPath = [tableview indexPathForRowAtPoint:subviewFrame.origin];\
indexPath;\
})\




#define REGISTER_NIB(TABLEVIEW,NIBNAME) [TABLEVIEW registerNib:[UINib nibWithNibName:NIBNAME bundle:nil] forCellReuseIdentifier:@"Cell"];
#define REGISTER_NIB_IDENTIFIER(TABLEVIEW,NIBNAME,IDENTIFIER) [TABLEVIEW registerNib:[UINib nibWithNibName:NIBNAME bundle:nil] forCellReuseIdentifier:IDENTIFIER];


#define LOAD_VIEW_WITH_NIB(NIB) [[NSBundle mainBundle] loadNibNamed:NIB owner:self options:nil][0]
#define LOAD_VIEW_WITH_NIB_OWNER(NIB,OWNER) [[NSBundle mainBundle] loadNibNamed:NIB owner:OWNER options:nil][0]








#ifndef DEBUG_LOG
#define DEBUG_LOG
#define LOGERROR NSLog(@"error !!!!!!!!! %s,%d",__FUNCTION__,__LINE__);
#define LOGWARNING NSLog(@"warning %s,%d",__FUNCTION__,__LINE__);
#define LOGERRORMSG(msg) NSLog(@"error:%@ %s,%d",msg,__FUNCTION__,__LINE__);
#define LOGLINE NSLog(@"log %s,%d",__FUNCTION__,__LINE__);
#define LOGDELETE NSLog(@"log delete %s,%d",__FUNCTION__,__LINE__);

#define LOGINFO(format, ...)  NSLog((@"%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#define LOGTEXT(value)  NSLog(@"%@ ; info %s,%d",value,__FUNCTION__,__LINE__);
#define LOGTODO NSLog(@"TODO !!!!! ; info %s,%d",__FUNCTION__,__LINE__);
#define LOGTODOTEXT(value)  NSLog(@"%@ ; TODO !!!!! %s,%d",value,__FUNCTION__,__LINE__);
#define LOGTIME NSLog(@"%f %s,%d",[[NSDate date]timeIntervalSince1970],__FUNCTION__,__LINE__);

#define LOGNOTHING(format,value)
#endif




//CHAGE_FRAME_WIDTH
#define CHANGE_FRAME_WIDTH(VIEW,VALUE) {\
{\
CGRect frame=VIEW.frame;\
frame.size.width=VALUE;\
VIEW.frame=frame;\
}}\

#define CHANGE_FRAME_HEIGTH(VIEW,VALUE) {\
{\
CGRect frame=VIEW.frame;\
frame.size.height=VALUE;\
VIEW.frame=frame;\
}}\

#define CHANGE_FRAME_X(VIEW,VALUE) {\
{\
CGRect frame=VIEW.frame;\
frame.origin.x=VALUE;\
VIEW.frame=frame;\
}}\

#define CHANGE_FRAME_Y(VIEW,VALUE) {\
{\
CGRect frame=VIEW.frame;\
frame.origin.y=VALUE;\
VIEW.frame=frame;\
}}\






/* color helper */
#define COLORRGBA(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0	\
green:((c>>8)&0xFF)/255.0	\
blue:(c&0xFF)/255.0         \
alpha:a]
#define COLORRGB(c)    [UIColor colorWithRed:((c>>16)&0xFF)/255.0	\
green:((c>>8)&0xFF)/255.0	\
blue:(c&0xFF)/255.0         \
alpha:1.0]






#endif /* PubHeader_h */
