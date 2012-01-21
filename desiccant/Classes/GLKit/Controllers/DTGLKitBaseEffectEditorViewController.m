//
//  DTGLKitBaseEffectEditorViewController.m
//  word-game-3
//
//  Created by Garrett Christopher on 10/26/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DTGLKitBaseEffectEditorViewController.h"
#import <GLKit/GLKit.h>
#import "CBucks.h"
#import "FloatSliderView.h"
#import "NSObject+Zest.h"
#import "UIView+Zest.h"
#import "Vector4SliderView.h"
#import "Vector3SliderView.h"
#import "Macros.h"
#import "OptionView.h"

#define TAG_LIGHT0 1000
#define TAG_LIGHT1 2000
#define TAG_LIGHT2 3000


#define TAG_LIGHT_SPECULAR_COLOR 101
#define TAG_LIGHT_AMBIENT_COLOR 102
#define TAG_LIGHT_DIFFUSE_COLOR 103
#define TAG_LIGHT_POSITION 104
#define TAG_LIGHT_SPOT_DIRECTION 105
#define TAG_LIGHT_SPOT_CUTOFF 106
#define TAG_LIGHT_SPOT_EXPONENT 107
#define TAG_LIGHT_ON_OFF 108
#define TAG_LIGHT_LINEAR_ATTENUATION 109
#define TAG_LIGHT_QUADRATIC_ATTENUATION 110
#define TAG_LIGHT_CONSTANT_ATTENUATION 111

#define TAG_LIGHTING_TYPE 200
#define TAG_LIGHT_MODEL_AMBIENT_COLOR 215

#define TAG_MATERIAL_AMBIENT_COLOR 310
#define TAG_MATERIAL_DIFFUSE_COLOR 311
#define TAG_MATERIAL_SPECULAR_COLOR 312
#define TAG_MATERIAL_EMISSIVE_COLOR 313
#define TAG_MATERIAL_SHININESS 314

#define TAG_FOG_ON_OFF 401
#define TAG_FOG_COLOR 402
#define TAG_FOG_MODE 403
#define TAG_FOG_DENSITY 404
#define TAG_FOG_START 405
#define TAG_FOG_END 406


@interface DTGLKitBaseEffectEditorViewController() {
@private
}
- (NSDictionary *) sectionAtIndex: (NSInteger) index;
- (NSArray *) rowsInSection: (NSInteger) section;
- (UIView *) editorForIndexPath: (NSIndexPath *) indexPath;

- (void) vector4SliderChanged: (Vector4SliderView *) slider;
- (void) vector3SliderChanged: (Vector3SliderView *) slider;
- (void) floatSliderChanged: (FloatSliderView *) slider;
- (void) optionChanged: (OptionView *) optionView;
- (GLKEffectPropertyLight *) lightForTag: (NSInteger) tag;

@end


@implementation DTGLKitBaseEffectEditorViewController

@synthesize effect, sections;

- (GLKEffectPropertyLight *) lightForTag: (NSInteger) tag {
   GLKEffectPropertyLight *light = self.effect.light0;
   switch (tag/TAG_LIGHT0 - 1) {
      case 0:
         light = self.effect.light0;
         break;
      case 1:
         light = self.effect.light1;
         break;
      case 2:
         light = self.effect.light2;
         break;
      default:
         break;
   }
   return light;
}

- (void) vector4SliderChanged: (Vector4SliderView *) slider {
   GLKEffectPropertyLight *light = [self lightForTag: slider.tag];
   switch (slider.tag % TAG_LIGHT0) {
      case TAG_LIGHT_SPECULAR_COLOR:
         self.effect.transform.modelviewMatrix = GLKMatrix4Identity;
         self.effect.transform.projectionMatrix = GLKMatrix4Identity;
         light.specularColor = slider.value;
         break;
      case TAG_LIGHT_AMBIENT_COLOR:
         light.ambientColor = slider.value;
         break;
      case TAG_LIGHT_DIFFUSE_COLOR:
         light.diffuseColor = slider.value;
         break;
      case TAG_LIGHT_POSITION:
         self.effect.transform.modelviewMatrix = GLKMatrix4Identity;
         light.position = slider.value;
         break;
      case TAG_MATERIAL_AMBIENT_COLOR:
         self.effect.material.ambientColor = slider.value;
         break;
      case TAG_MATERIAL_DIFFUSE_COLOR:
         self.effect.material.diffuseColor = slider.value;
         break;
      case TAG_MATERIAL_SPECULAR_COLOR:
         self.effect.material.specularColor = slider.value;
         break;
      case TAG_MATERIAL_EMISSIVE_COLOR:
         self.effect.material.emissiveColor = slider.value;
         break;
      case TAG_LIGHT_MODEL_AMBIENT_COLOR:
         self.effect.lightModelAmbientColor = slider.value;
         break;
      case TAG_FOG_COLOR:
         self.effect.fog.color = slider.value;
         break;
      default:
         break;
   }
}

- (void) vector3SliderChanged: (Vector3SliderView *) slider {
   GLKEffectPropertyLight *light = [self lightForTag: slider.tag];
   switch (slider.tag % TAG_LIGHT0) {
      case TAG_LIGHT_SPOT_DIRECTION:
         self.effect.transform.modelviewMatrix = GLKMatrix4Identity;
         light.spotDirection = slider.value;
         break;
      default:
         break;
   }
}

- (void) floatSliderChanged: (FloatSliderView *) slider {
   GLKEffectPropertyLight *light = [self lightForTag: slider.tag];
   switch (slider.tag % TAG_LIGHT0) {
      case TAG_LIGHT_SPOT_CUTOFF:
         light.spotCutoff = slider.value;
         break;
      case TAG_LIGHT_SPOT_EXPONENT:
         light.spotExponent = slider.value;
         break;
      case TAG_LIGHT_CONSTANT_ATTENUATION:
         light.constantAttenuation = slider.value;
         break;
      case TAG_LIGHT_LINEAR_ATTENUATION:
         light.linearAttenuation = slider.value;
         break;
      case TAG_LIGHT_QUADRATIC_ATTENUATION:
         light.quadraticAttenuation = slider.value;
         break;
      case TAG_MATERIAL_SHININESS:
         self.effect.material.shininess = slider.value;
      case TAG_FOG_DENSITY:
         self.effect.fog.density = slider.value;
      case TAG_FOG_START:
         self.effect.fog.start = slider.value;
      case TAG_FOG_END:
         self.effect.fog.end = slider.value;
      default:
         break;
   }
}

- (void) optionChanged: (OptionView *) optionView {
   GLKEffectPropertyLight *light = [self lightForTag: optionView.tag];
   switch (optionView.tag % TAG_LIGHT0) {
      case TAG_LIGHT_ON_OFF:
         light.enabled = optionView.selectedIndex;
         break;
      case TAG_LIGHTING_TYPE:
         self.effect.lightingType = optionView.selectedIndex;
         break;
      case TAG_FOG_ON_OFF:
         self.effect.fog.enabled = optionView.selectedIndex;
         break;
      case TAG_FOG_MODE:
         self.effect.fog.mode = optionView.selectedIndex;
         break;
      default:
         break;
   }
}

- (void) addMaterialProperties {

   GLKEffectPropertyMaterial *material = self.effect.material;
   
   
   FloatSliderView *shininess = [FloatSliderView floatSliderViewWithTitle: @"Shininess" 
                                                                      min: 0.0f 
                                                                      max: 1.0f 
                                                                  current: material.shininess];
   [shininess addTarget:self action: @selector(floatSliderChanged:) forControlEvents: UIControlEventValueChanged];
   shininess.tag = TAG_MATERIAL_SHININESS;

   Vector4SliderView *emissiveColor = [Vector4SliderView vector4SliderViewForRGBColor];
   emissiveColor.titleLabel.text = @"Emissive Color";
   emissiveColor.value = material.emissiveColor;
   emissiveColor.tag = TAG_MATERIAL_SPECULAR_COLOR;
   [emissiveColor addTarget:self action: @selector(vector4SliderChanged:) forControlEvents: UIControlEventValueChanged];

   Vector4SliderView *specularColor = [Vector4SliderView vector4SliderViewForRGBColor];
   specularColor.titleLabel.text = @"Specular Color";
   specularColor.value = material.specularColor;
   specularColor.tag = TAG_MATERIAL_SPECULAR_COLOR;
   [specularColor addTarget:self action: @selector(vector4SliderChanged:) forControlEvents: UIControlEventValueChanged];
   
   Vector4SliderView *ambientColor = [Vector4SliderView vector4SliderViewForRGBColor];
   ambientColor.titleLabel.text = @"Ambient Color";
   ambientColor.value = material.ambientColor;
   ambientColor.tag = TAG_MATERIAL_AMBIENT_COLOR;
   [ambientColor addTarget:self action: @selector(vector4SliderChanged:) forControlEvents: UIControlEventValueChanged];
   
   Vector4SliderView *diffuseColor = [Vector4SliderView vector4SliderViewForRGBColor];
   diffuseColor.titleLabel.text = @"Diffuse Color";
   diffuseColor.value = material.diffuseColor;
   diffuseColor.tag = TAG_MATERIAL_DIFFUSE_COLOR;
   [diffuseColor addTarget:self action: @selector(vector4SliderChanged:) forControlEvents: UIControlEventValueChanged];
      

   [self addSectionTitled: @"Material Properties" 
                      rows: $A(shininess, emissiveColor, specularColor, ambientColor, diffuseColor)];
}

- (void) addSectionTitled: (NSString *) title rows: (NSArray *) rows {
   NSMutableDictionary *section = [NSMutableDictionary dictionary];
   [section setObject: title forKey: @"title"];
   [section setObject: rows forKey: @"rows"];
   [sections addObject: section];
}

- (void) addFogProperties {
   GLKEffectPropertyFog *fog = self.effect.fog;
   
   OptionView *onOff = [OptionView optionViewWithTitle: @"Enabled" options: $A(@"Off", @"On")];
   onOff.tag = TAG_FOG_ON_OFF;
   onOff.selectedIndex = fog.enabled;
   [onOff addTarget: self action: @selector(optionChanged:) forControlEvents: UIControlEventValueChanged];

   OptionView *mode = [OptionView optionViewWithTitle: @"Fog Mode" options: $A(@"Exp", @"Exp2", @"Linear")];
   mode.tag = TAG_FOG_MODE;
   mode.selectedIndex = fog.mode;
   [mode addTarget: self action: @selector(optionChanged:) forControlEvents: UIControlEventValueChanged];

   FloatSliderView *density = [FloatSliderView floatSliderViewWithTitle: @"Density" 
                                                                      min: 0.0f 
                                                                      max: 0.1f 
                                                                  current: fog.density];
   [density addTarget:self action: @selector(floatSliderChanged:) forControlEvents: UIControlEventValueChanged];
   density.tag = TAG_FOG_DENSITY;

   FloatSliderView *start = [FloatSliderView floatSliderViewWithTitle: @"Start Distance" 
                                                                      min: 0.0f 
                                                                      max: 100.0f 
                                                                  current: fog.start];
   [start addTarget:self action: @selector(floatSliderChanged:) forControlEvents: UIControlEventValueChanged];
   start.tag = TAG_FOG_START;

   FloatSliderView *end = [FloatSliderView floatSliderViewWithTitle: @"End Distance" 
                                                                      min: 0.0f 
                                                                      max: 100.0f 
                                                                  current: fog.end];
   [end addTarget:self action: @selector(floatSliderChanged:) forControlEvents: UIControlEventValueChanged];
   end.tag = TAG_FOG_END;

   
   Vector4SliderView *color = [Vector4SliderView vector4SliderViewForRGBColor];
   color.titleLabel.text = @"Fog Color";
   color.value = fog.color;
   color.tag = TAG_FOG_COLOR;
   [color addTarget:self action: @selector(vector4SliderChanged:) forControlEvents: UIControlEventValueChanged];
   
   
   [self addSectionTitled: @"Fog Properties" rows:$A(onOff, mode, color, density, start, end)];
}


- (void) addLightEffect: (NSInteger) lightIndex {
   GLKEffectPropertyLight *light = nil;
   NSInteger tagStart = (lightIndex+1)*TAG_LIGHT0;
   switch (lightIndex) {
      case 0:
         light = self.effect.light0;
         break;
      case 1:
         light = self.effect.light1;
         break;
      case 2:
         light = self.effect.light2;
         break;
      default:
         light = self.effect.light0;
         break;
   }
      
   OptionView *onOff = [OptionView optionViewWithTitle: @"Switch" options: $A(@"Off", @"On")];
   onOff.tag = tagStart+TAG_LIGHT_ON_OFF;
   onOff.selectedIndex = light.enabled;
   [onOff addTarget: self action: @selector(optionChanged:) forControlEvents: UIControlEventValueChanged];
   
   Vector4SliderView *specularColor = [Vector4SliderView vector4SliderViewForRGBColor];
   specularColor.titleLabel.text = @"Specular Color";
   specularColor.value = light.specularColor;
   specularColor.tag = tagStart+TAG_LIGHT_SPECULAR_COLOR;
   [specularColor addTarget:self action: @selector(vector4SliderChanged:) forControlEvents: UIControlEventValueChanged];
   
   Vector4SliderView *ambientColor = [Vector4SliderView vector4SliderViewForRGBColor];
   ambientColor.titleLabel.text = @"Ambient Color";
   ambientColor.value = light.ambientColor;
   ambientColor.tag = tagStart+TAG_LIGHT_AMBIENT_COLOR;
   [ambientColor addTarget:self action: @selector(vector4SliderChanged:) forControlEvents: UIControlEventValueChanged];
   
   Vector4SliderView *diffuseColor = [Vector4SliderView vector4SliderViewForRGBColor];
   diffuseColor.titleLabel.text = @"Diffuse Color";
   diffuseColor.value = light.diffuseColor;
   diffuseColor.tag = tagStart+TAG_LIGHT_DIFFUSE_COLOR;
   [diffuseColor addTarget:self action: @selector(vector4SliderChanged:) forControlEvents: UIControlEventValueChanged];
   
   Vector4SliderView *position = [Vector4SliderView vector4SliderViewForPosition];
   position.titleLabel.text = @"Position";
   position.minValue = GLKVector4Make(-10.0f, -10.0f, -10.0f, 0.0f);
   position.maxValue = GLKVector4Make(10.0f, 10.0f, 10.0f, 1.0f);
   position.value = light.position;
   position.tag = tagStart+TAG_LIGHT_POSITION;
   [position addTarget:self action: @selector(vector4SliderChanged:) forControlEvents: UIControlEventValueChanged];
   
   Vector3SliderView *direction = [Vector3SliderView Vector3SliderViewForDirection];
   direction.titleLabel.text = @"Spot Direction";
   direction.minValue = GLKVector3Make(-1.0f, -1.0f, -1.0f);
   direction.maxValue = GLKVector3Make(1.0f, 1.0f, 1.0f);
   direction.value = light.spotDirection;
   direction.tag = tagStart+TAG_LIGHT_SPOT_DIRECTION;
   [direction addTarget:self action: @selector(vector3SliderChanged:) forControlEvents: UIControlEventValueChanged];
   
   FloatSliderView *spotCutoff = [FloatSliderView floatSliderViewWithTitle: @"Spot Cutoff (°)" 
                                                                       min: 0.0f 
                                                                       max: 180.0f 
                                                                   current: light.spotCutoff];
   [spotCutoff addTarget:self action: @selector(floatSliderChanged:) forControlEvents: UIControlEventValueChanged];
   spotCutoff.tag = tagStart+TAG_LIGHT_SPOT_CUTOFF;
   
   FloatSliderView *spotExponent = [FloatSliderView floatSliderViewWithTitle: @"Spot Exponent" 
                                                                         min: -5.0f 
                                                                         max: 100.0f 
                                                                     current: light.spotExponent];
   [spotExponent addTarget:self action: @selector(floatSliderChanged:) forControlEvents: UIControlEventValueChanged];
   spotExponent.tag = tagStart+TAG_LIGHT_SPOT_EXPONENT;

   FloatSliderView *constantAttenuation = [FloatSliderView floatSliderViewWithTitle: @"Constant Attenuation" 
                                                                         min: 0.0f 
                                                                         max: 2.0f 
                                                                     current: light.constantAttenuation];
   [constantAttenuation addTarget:self action: @selector(floatSliderChanged:) forControlEvents: UIControlEventValueChanged];
   constantAttenuation.tag = tagStart+TAG_LIGHT_CONSTANT_ATTENUATION;

   FloatSliderView *linearAttenuation = [FloatSliderView floatSliderViewWithTitle: @"Linear Attenuation" 
                                                                                min: 0.0f 
                                                                                max: 5.0f 
                                                                            current: light.linearAttenuation];
   [linearAttenuation addTarget:self action: @selector(floatSliderChanged:) forControlEvents: UIControlEventValueChanged];
   linearAttenuation.tag = tagStart+TAG_LIGHT_LINEAR_ATTENUATION;

   FloatSliderView *quadraticAttenuation = [FloatSliderView floatSliderViewWithTitle: @"Quadratic Attenuation" 
                                                                              min: 0.0f 
                                                                              max: 5.0f 
                                                                          current: light.quadraticAttenuation];
   [quadraticAttenuation addTarget:self action: @selector(floatSliderChanged:) forControlEvents: UIControlEventValueChanged];
   quadraticAttenuation.tag = tagStart+TAG_LIGHT_QUADRATIC_ATTENUATION;
   
   [self addSectionTitled: $S(@"Light %d", lightIndex) 
                     rows: $A(onOff, specularColor, ambientColor, diffuseColor, position, direction, spotCutoff, spotExponent, constantAttenuation, linearAttenuation, quadraticAttenuation)];
   
}

- (void) addGeneralEffectProperties {
   OptionView *lightingType = [OptionView optionViewWithTitle: @"Lighting Type" options: $A(@"Per Vertex", @"Per Pixel")];
   lightingType.tag = TAG_LIGHTING_TYPE;
   lightingType.selectedIndex = self.effect.lightingType;
   [lightingType addTarget: self action: @selector(optionChanged:) forControlEvents: UIControlEventValueChanged];
   
   Vector4SliderView *ambientColor = [Vector4SliderView vector4SliderViewForRGBColor];
   ambientColor.titleLabel.text = @"Light Model Ambient Color";
   ambientColor.value = self.effect.lightModelAmbientColor;
   ambientColor.tag = TAG_LIGHT_MODEL_AMBIENT_COLOR;
   [ambientColor addTarget:self action: @selector(vector4SliderChanged:) forControlEvents: UIControlEventValueChanged];

   
   [self addSectionTitled: @"Effect Properties" rows: $A(lightingType, ambientColor)];

}


- (id)initWithEffect: (GLKBaseEffect *) newEffect
{
    self = [super initWithStyle: UITableViewStyleGrouped];
    if (self) {
       self.effect = newEffect;
       sections = [NSMutableArray array];
       
       self.contentSizeForViewInPopover = CGSizeMake(320.0, 400.0);
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSDictionary *) sectionAtIndex: (NSInteger) index {
   return [sections objectAtIndex: index];
}

- (NSArray *) rowsInSection: (NSInteger) section {
   return [[self sectionAtIndex: section] objectForKey: @"rows"];
}

- (UIView *) editorForIndexPath: (NSIndexPath *) indexPath {
   return [[self rowsInSection: indexPath.section] objectAtIndex: indexPath.row];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [[self rowsInSection: section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
   [cell.contentView removeAllSubviews];
   UIView *editor = [self editorForIndexPath: indexPath];
   [cell.contentView addSubview: editor];
   [cell.contentView setNeedsLayout];
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   if ([sections count] > 1) {
      return [[self sectionAtIndex: section] objectForKey: @"title"];
   } else {
      return nil;
   }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return [self editorForIndexPath: indexPath].frame.size.height + 10.0;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   return nil;
}

@end
