//
//  DTCAnnotationViewController.h
//  HackerBooks_v2
//
//  Created by David de Tena on 26/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

@import UIKit;
@class DTCAnnotation;
@class AGTCoreDataStack;

@interface DTCAnnotationViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate>

#pragma mark - Properties

@property (strong,nonatomic) DTCAnnotation *model;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *creationDate;
@property (weak, nonatomic) IBOutlet UILabel *modificationDate;
@property (weak, nonatomic) IBOutlet UITextView *textView;


#pragma mark - Init
-(id) initWithModel:(DTCAnnotation *) model stack:(AGTCoreDataStack *) stack;



#pragma mark - Actions
- (IBAction)displayPhoto:(id)sender;

@end
