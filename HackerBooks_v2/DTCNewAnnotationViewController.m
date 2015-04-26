//
//  DTCNewAnnotationViewController.m
//  HackerBooks_v2
//
//  Created by David de Tena on 26/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCNewAnnotationViewController.h"
#import "DTCBook.h"
#import "DTCAnnotation.h"
#import "AGTCoreDataStack.h"

@interface DTCNewAnnotationViewController ()

@property (strong,nonatomic) AGTCoreDataStack *stack;

@end

@implementation DTCNewAnnotationViewController


#pragma mark - Properties


#pragma mark - Init
-(id) initWithModel:(DTCBook *) model stack:(AGTCoreDataStack *)stack{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _model = model;
        _stack = stack;
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Set delegates
    self.nameTextField.delegate = self;
    self.textView.delegate = self;
    
//    // Alta en notificaciones de teclado para ver cuando se muestra/oculta el teclado
//    [self setupKeyboardNotifications];
//    
//    // Sincronizar modelo -> vista
//    [self syncViewWithModel];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI
- (void) setupUI{

}


#pragma mark - Utils

//-(void) setupKeyboardNotifications{
//    // Alta en notificaciones para cuando se muestra y oculta el teclado
//    NSNotificationCenter *nc = [NSNotificationCenter
//                                defaultCenter];
//    [nc addObserver:self
//           selector:@selector(notifyThatKeyboardWillAppear:)
//               name:UIKeyboardWillShowNotification
//             object:nil];
//    
//    [nc addObserver:self
//           selector:@selector(notifyThatKeyboardWillDisappear:)
//               name:UIKeyboardWillHideNotification
//             object:nil];
//    
//}
//
//-(void) tearDownKeyboardNotifications{
//    NSNotificationCenter *nc = [NSNotificationCenter
//                                defaultCenter];
//    [nc removeObserver:self];
//}




// Hide current modal VC
-(void) dismissViewController{
    // Ocultamos VC actual a partir del ViewController que lo mostró
    [self.presentingViewController
     dismissViewControllerAnimated:YES completion:^{
         //
     }];
}

#pragma mark - Actions

- (IBAction)didPressCancelButton:(id)sender {
    [self dismissViewController];
}

- (IBAction)didPressDoneButton:(id)sender {
    
    // Take data from text field and text view
    // and use it to add a new annotation
    
    // Al crear una nueva nota en el modelo, CoreData manda una notificación de cambio
    // por KVO a FetchedResultsController, que avisa a la tabla y le dice que se refresque
    [DTCAnnotation annotationWithName:self.nameTextField.text
                                 text:self.textView.text
                                 book:self.model stack:_stack];
    
    [self dismissViewController];
    
}

// Method to hide keyboard when tapping in a non-text view
- (IBAction)hideKeyboard:(id)sender{
    [self.view endEditing:YES];
}


#pragma mark - UITextFieldDelegate
// Qué hacer cuando se pulsa Return en TextField
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

// Es el método que se ejecuta justo después del anterior
- (void) textFieldDidEndEditing:(UITextField *)textField{
    // Buen momento para guardar el texto (pasó la validación)
}



#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    // Ocultamos teclado y deja de tener el foco.
    // No aplicamos validación porque puede estar vacío
    [textView resignFirstResponder];
    return YES;
}


@end
