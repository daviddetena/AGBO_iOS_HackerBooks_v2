//
//  DTCAnnotationViewController.m
//  HackerBooks_v2
//
//  Created by David de Tena on 26/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCAnnotationViewController.h"
#import "DTCAnnotationPhotoViewController.h"
#import "DTCAnnotation.h"
#import "DTCPhoto.h"
#import "AGTCoreDataStack.h"

@interface DTCAnnotationViewController ()

@property (strong,nonatomic) AGTCoreDataStack *stack;

@end

@implementation DTCAnnotationViewController


#pragma mark - Init
-(id) initWithModel:(DTCAnnotation *) model stack:(AGTCoreDataStack *) stack{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _model = model;
        _stack = stack;
        self.title = model.name;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self syncViewWithModel];
}


- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self syncModelWithView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI

// UI presents data from the model
- (void) syncViewWithModel{
    
    // Format for the creation and modification date
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateStyle = NSDateFormatterFullStyle;
    
    self.nameTextField.text = self.model.name;
    self.textView.text = self.model.text;
    self.creationDate.text = [NSString stringWithFormat:@"Created at: %@",[fmt stringFromDate:self.model.creationDate]];
    self.modificationDate.text = [NSString stringWithFormat:@"Modified at: %@",[fmt stringFromDate:self.model.modificationDate]];
    
    self.photoView.layer.cornerRadius = self.photoView.frame.size.width/2;
    self.photoView.clipsToBounds = YES;
    
    if (!self.model.photo.photoData) {
        self.photoView.image = [UIImage imageNamed:@"noImageRect.png"];
    }
    else{
        self.photoView.image = self.model.photo.annotationImage;
    }
    
}


// Update the CoreData's model with the content of the UI
- (void) syncModelWithView{
    self.model.name = self.nameTextField.text;
    self.model.text = self.textView.text;
}




#pragma mark - Actions


// Method to hide keyboard when tapping in a non-text view
- (IBAction)hideKeyboard:(id)sender{
    [self.view endEditing:YES];
}

// Display AnnotationPhotoVC by pushing
- (IBAction)displayPhoto:(id)sender {
    
    DTCAnnotationPhotoViewController *photoVC = [[DTCAnnotationPhotoViewController alloc] initWithModel:self.model.photo];
    [self.navigationController pushViewController:photoVC animated:YES];
}


#pragma mark - UITextFieldDelegate

// What to do when Return key pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // Buen momento de validar y en ese caso ocultamos teclado (resignFirstResponder)
    // return NO si no pasa la validación
    // Deja de tener el foco
    if ([textField.text length]>0) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}


// What to do when editing ended. Save to the model
- (void) textFieldDidEndEditing:(UITextField *)textField{
    
}



#pragma mark - UITextViewDelegate

// What to do when Return key pressed
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    // Ocultamos teclado y deja de tener el foco.
    // No aplicamos validación porque puede estar vacío
    [textView resignFirstResponder];
    return YES;
}


// What to do when editing ended. Save to the model
- (void) textViewDidEndEditing:(UITextView *)textView{
    
}





@end
