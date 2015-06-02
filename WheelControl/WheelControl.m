//
//  WheelControl.m
//  72fAssignment
//
//  Created by allamaprabhu on 5/29/15.
//  Copyright (c) 2015 72f. All rights reserved.
//

#import "WheelControl.h"

#define wheel_image_y 600
#define temperature_lable_y 200
#define temperature_lable_width 200
#define temperature_lable_height 150
#define limitAngle 45

#define rad_deg(x)(x*190/M_PI)

@interface WheelControl()
@property (nonatomic,strong)UIImageView *wheel;
@property (nonatomic,strong)UIView *gradientWheel;
@property (nonatomic,strong)UILabel *tempertureLable;
@property (nonatomic) CGPoint lastPosition;
@property (nonatomic) CGFloat totalAngel;
@property (nonatomic) CGFloat currentTemperature;
@property (nonatomic) CGFloat minTemp;
@property (nonatomic) CGFloat maxTemp;
@end

@implementation WheelControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Can be varied
        self.minTemp =0.0;
        self.maxTemp = 100.0;

        self.currentTemperature = self.minTemp+(self.maxTemp - self.minTemp)/2;
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.wheel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circularwheel"]];
        self.wheel.backgroundColor = [UIColor greenColor];
        CGSize size = [[UIImage imageNamed:@"circularwheel"] size];
        //This is little hack to inflate image.Can be avoided.
        size.width +=100;
        size.height +=100;
        self.wheel.frame = CGRectMake(0, 0, size.width, size.height);
        CGPoint center = self.center;
        center.y = wheel_image_y;
        self.wheel.center = center;
        self.wheel.layer.cornerRadius = size.width/2;
        [self addSubview:self.wheel];
        

        self.tempertureLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, temperature_lable_width, temperature_lable_height)];
        self.tempertureLable.backgroundColor = [UIColor whiteColor];
        center = CGPointMake(self.center.x, temperature_lable_y);
        self.tempertureLable.center = center;
        self.tempertureLable.font = [UIFont systemFontOfSize:140];
        self.tempertureLable.text = [NSString stringWithFormat:@"%d",(int)self.currentTemperature];
        [self addSubview:self.tempertureLable];
    }
    return self;
}

//Computes distance angle between two coordinate points wrt to provided centre
-(CGFloat)angleBetweenCenterPoint:(CGPoint)centerPoint point1:(CGPoint)p1 point2:(CGPoint)p2{
    CGPoint v1 = CGPointMake(p1.x - centerPoint.x, p1.y - centerPoint.y);
    CGPoint v2 = CGPointMake(p2.x - centerPoint.x, p2.y - centerPoint.y);
    
    CGFloat angle = atan2f(v2.x*v1.y - v1.x*v2.y, v1.x*v2.x + v1.y*v2.y);
    return angle;
}

#pragma -mark Touchevent callbacks
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
        self.lastPosition  = [touch locationInView:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
        CGPoint curretnLocation = [touch locationInView:self];
        CGPoint centre = CGPointMake(self.center.x, self.bounds.size.height);
        CGFloat deltaAngle = [self angleBetweenCenterPoint:centre point1:self.lastPosition point2:curretnLocation];
        if (self.totalAngel<=limitAngle && self.totalAngel>=-limitAngle) {
            
            //Convert form radians to degrees
            self.totalAngel += rad_deg(deltaAngle);
            
            //Add boundery checks
            if (self.totalAngel>limitAngle) {
                self.totalAngel = limitAngle;
            }
            else if(self.totalAngel < -limitAngle) {
                self.totalAngel = -limitAngle;
            }
            else {
                //Rotate only if it is in the limits.Assuming -45 0 +45
                self.wheel.transform = CGAffineTransformMakeRotation(-deltaAngle);
                [self setTemperatureAndGradiant];
            }
            self.lastPosition=curretnLocation;
            NSLog(@"%f total : %f temp : %d",deltaAngle,self.totalAngel,(int)self.currentTemperature);
        }
    }
}

- (void)setTemperatureAndGradiant {
    //Compute mid cap
    CGFloat midTemp = self.minTemp+(self.maxTemp - self.minTemp)/2;
    
    //75-100 ,2nd quadrant
    if (self.totalAngel < 0) {
        //Get the absolute value for computation
        CGFloat angle = -1*self.totalAngel;
        self.currentTemperature = midTemp+(((self.maxTemp-midTemp)*angle)/(limitAngle));
        CGFloat r,g,b,alpha;
        if ([[self.wheel backgroundColor] getRed:&r green:&g blue:&b alpha:&alpha]) {
            CGFloat delta = angle/limitAngle;
            g=1-delta;
            //Only red varies in 2nd quadrant
            r=delta;
            self.wheel.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
        }
    }
    //50-75, 1st quadrant
    else {
        CGFloat angle = self.totalAngel;
        
        self.currentTemperature = midTemp-(((self.maxTemp-midTemp)*angle)/(limitAngle));
        
        CGFloat r,g,b,alpha;
        if ([[self.wheel backgroundColor] getRed:&r green:&g blue:&b alpha:&alpha]) {
            CGFloat delta = self.totalAngel/limitAngle;;
            g=1-delta;
            //Only Blue varies in 1st qadrant
            b=delta;
            self.wheel.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
        }

    }
    self.tempertureLable.text = [NSString stringWithFormat:@"%d",(int)self.currentTemperature];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
        self.lastPosition  = [touch locationInView:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end
