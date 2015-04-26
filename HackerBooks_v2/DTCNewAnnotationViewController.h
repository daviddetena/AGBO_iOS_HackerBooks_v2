//
//  DTCNewAnnotationViewController.h
//  HackerBooks_v2
//
//  Created by David de Tena on 26/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

@import UIKit;
@class DTCBook;
@class AGTCoreDataStack;

@interface DTCNewAnnotationViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

#pragma mark - Properties


// Our model will be DTCBook
@property (strong,nonatomic) DTCBook *model;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;


#pragma mark - Init
-(id) initWithModel:(DTCBook *) model stack:(AGTCoreDataStack *) stack;


#pragma mark - Actions
- (IBAction)didPressCancelButton:(id)sender;
- (IBAction)didPressDoneButton:(id)sender;
- (IBAction)hideKeyboard:(id)sender;


@end
