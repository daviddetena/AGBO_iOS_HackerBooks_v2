//
//  DTCAnnotationPhotoViewController.m
//  HackerBooks_v2
//
//  Created by David de Tena on 26/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCAnnotationPhotoViewController.h"
#import "DTCPhoto.h"
#import "DTCAnnotation.h"
#import "InitSettings.h"

@interface DTCAnnotationPhotoViewController ()

@property (strong,nonatomic) UIBarButtonItem *trashButton;

@end

@implementation DTCAnnotationPhotoViewController


#pragma mark - Init
// Designated
-(id) initWithModel:(DTCPhoto *) model{
    if (self = [super init]) {
        _model = model;
        self.title = @"Photo for Annotation's book";
    }
    return self;
}


#pragma mark - View Lifecycle

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Make sure the view will not include the Navigation or toolbar
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Sync view with model
    if (!self.model.photoData) {
        self.imageView.image = [UIImage imageNamed:@"noImageRect.png"];
//        self.trashButton = [self.toolbarItems objectAtIndex:3];
//        self.trashButton.enabled = NO;
    }
    else{
        self.imageView.image = self.model.annotationImage;
//        self.trashButton.enabled = YES;
    }
    
    [self hideActivityIndicator];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Sync model with view (CoreData model) with KVO
    self.model.annotationImage = self.imageView.image;
}


#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Utils
-(void) showActivityIndicator{
    self.activityView.hidden = NO;
    if (![self.activityView isAnimating]) {
        [self.activityView startAnimating];
    }
}


-(void) hideActivityIndicator{
    self.activityView.hidden = YES;
    if ([self.activityView isAnimating]) {
        [self.activityView stopAnimating];
    }
}



#pragma mark - Actions

- (IBAction)takePicture:(id)sender {
    
    // Crear UIImagePickerController
    UIImagePickerController *cameraPicker = [[UIImagePickerController alloc]init];
    
    // Configurarla
    // Comprobamos si se puede seleccionar la camara
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // Usamos la camara
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        // Tiro del carrete
        cameraPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    cameraPicker.editing = NO;
    cameraPicker.delegate = self;
    
    // Configuración de la animación del ViewController
    cameraPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // Mostrarlo de forma modal
    [self presentViewController:cameraPicker
                       animated:YES
                     completion:^{
                         // Esto se va a ejecutar cuando termine la animación que muestra al picker
                     }];
}


- (IBAction)deletePhoto:(id)sender {
  
    // Create UIAlertController
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"¿Delete photo?"
                                          message:@"This operation cannot be undone"
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Actions para el UIAlertController
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
        // Calculamos centro del icono de la papelera a partir de la toolbar
        CGFloat toolbarFrameX = self.toolbar.frame.origin.x;
        CGFloat toolbarFrameY = self.toolbar.frame.origin.y;
        UIView *trashView = (UIView *) [self.toolbar.subviews objectAtIndex:3];
        CGFloat centerX = trashView.center.x;
        CGFloat centerY = trashView.center.y;
        CGPoint trashCenter = CGPointMake(toolbarFrameX + centerX, toolbarFrameY + centerY);
        
        // Eliminamos foto del modelo
        self.model.annotationImage = nil;
        
        // Guardamos estado inicial del modelo
        CGRect oldRect = self.imageView.bounds;
        CGPoint oldCenter = self.imageView.center;
        
        [UIView animateWithDuration:0.7
                              delay:0
                            options:0
                         animations:^{
                             // Difumino, reduzco tamaño y lo hago con transformada afin de rotación para que gire
                             self.imageView.alpha = 0;
                             self.imageView.bounds = CGRectZero;
                             self.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
                             
                             // Trasladamos la imagen al centro del icono de la papelera
                             self.imageView.center = trashCenter;
                             
                         } completion:^(BOOL finished) {
                             // Recuperamos configuración del photoView original
                             self.imageView.alpha = 1;
                             self.imageView.bounds = oldRect;
                             self.imageView.transform = CGAffineTransformIdentity;
                             
                             // No-image
                             self.imageView.image = [UIImage imageNamed:@"noImageRect.png"];
                             self.trashButton.enabled = NO;
                             
                             // Centro original
                             self.imageView.center = oldCenter;
                         }];
        
    }];
    
    if (!IS_IPHONE) {
        UIPopoverPresentationController *popPresenter = alertController.popoverPresentationController;
        popPresenter.sourceView = self.toolbar;
        popPresenter.sourceRect = self.toolbar.bounds;
    }
    
    // Añadimos acciones al UIAlertController
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    
    // Y lo presentamos
    [self presentViewController:alertController animated:YES completion:nil];
     
}


#pragma mark - UIImagePickerControllerDelegate
// Acabó la vista modal del UIPicker
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // ¡OJO! PICO DE MEMORIA ASEGURADO, especialmente en dispositivos antiguos (5 o 4s)
    // Sacamos UIImage del diccionario
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // OJO AL DATO
    // Mirar en el online categoría que hace un resize de la image al tamaño de la pantalla, desapareciendo el pico de memoria
    
    // Guardamos en modelo
    self.model.annotationImage = image;
    
    // El presentador (PhotoVC) tiene que ocultar el picker modal que estamos presentando
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 // Se ejecuta cuando se haya ocultado del todo
                             }];
}

// El usuario canceló el uso de la cámara/carrete
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    // El presentador (PhotoVC) tiene que ocultar el picker modal que estamos presentando
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 // Qué hacer al ocultar el picker
                             }];
}




@end
