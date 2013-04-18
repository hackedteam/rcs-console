/* 
DashedLine class
by Andy Woodruff (http://cartogrammar.com/blog || awoodruff@gmail.com)
May 2008
Still in progress; I'll get a more perfected version eventually. For now take it as is.

This is a Sprite with the capability to do basic lineTo drawing with dashed lines.
Example:
var dashy:DashedLine = new DashedLine(2,0x333333,new Array(3,3,10,3,5,8,7,13));
dashy.moveTo(120,120);
dashy.beginFill(0xcccccc);
dashy.lineTo(220,120);
dashy.lineTo(220,220);
dashy.lineTo(120,220);
dashy.lineTo(120,120);
dashy.endFill();
*/

package it.ht.rcs.console.utils {
  
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.geom.Point;
  import flash.display.CapsStyle;
  
  public class DashedLine extends Sprite {
    
    private  var lengthsArray:Array = new Array();	// array of dash and gap lengths (dash,gap,dash,gap....)
    private var lineColor:uint;	// line color
    private var lineWeight:Number;	// line weight
    private var lineAlpha:Number = 1;	// line alpha
    private var curX:Number = 0;	// stores current x as it changes with lineTo and moveTo calls
    private var curY:Number = 0;	// same as above, but for y
    private var remainingDist:Number = 0;	// stores distance between the end of the last full dash or gap and the end coordinates specified in lineTo
    private var curIndex:int= -1;	// current index in the length array, so we know which dash or gap to draw
    private var arraySum:Number = 0;	// total length of the dashes and gaps... not currently being used for anything, but maybe useful?
    private var startIndex:int = 0;	// array index (the particular dash or gap) to start with in a lineTo--based on the last dash or gap drawn in the previous lineTo (along with remainingDist, this is so our line can properly continue around corners!)
    
    private var fill:Shape = new Shape();	// shappe in the background to be used for fill (if any)
    private var stroke:Shape = new Shape();	// shape in the foreground to be used for the dashed line
    
    public function DashedLine(weight:Number = 0, color:Number = 0, lengthsArray:Array = null){
      
      if (lengthsArray != null){	// if lengths array was specified, use it
        this.lengthsArray = lengthsArray;
      } else {	// if unspecified, use a default 5-5 line
        this.lengthsArray = [5,5];
      }
      if (this.lengthsArray.length % 2 != 0){	// if array has more dashes than gaps (i.e. an odd number of values), add a 5 gap to the end
        lengthsArray.push(5);
      }
      
      // sum the dash and gap lengths
      for (var i:* in lengthsArray){
        arraySum += lengthsArray[i];
      }
      
      // set line weight and color properties from constructor arguments
      lineWeight = weight;
      lineColor = color;
      
      // set the lineStyle according to specified properties - beyond weight and color, we use the defaults EXCEPT no line caps, as they interfere with the desired gaps
      stroke.graphics.lineStyle(lineWeight,lineColor,lineAlpha,false,"none",CapsStyle.NONE);
      
      // add fill and stroke shapes
      addChild(fill);
      addChild(stroke);
    }
    
    // basic moveTo method
    public function moveTo(x:Number,y:Number):void{
      stroke.graphics.moveTo(x,y);	// move to specified x and y
      fill.graphics.moveTo(x,y);
      // keep track of x and y
      curX = x;	
      curY = y;
      // reset remainingDist and startIndex - if we are moving away from last line segment, the next one will start at the beginning of the dash-gap sequence
      remainingDist = 0;
      startIndex = 0;
    }
    
    // lineTo method
    public function lineTo(x:Number,y:Number):void{
      var slope:Number = (y - curY)/(x - curX);	// get slope of segment to be drawn
      // record beginning x and y
      var startX:Number = curX;
      var startY:Number = curY;
      // positive or negative direction for each x and y?
      var xDir:int = (x < startX) ? -1 : 1;
      var yDir:int = (y < startY) ? -1 : 1;
      // keep drawing dashes and gaps as long as either the current x or y is not beyond the destination x or y
      outerLoop : while (Math.abs(startX-curX) < Math.abs(startX-x) || Math.abs(startY-curY) < Math.abs(startY-y)){
        // loop through the array to draw the appropriate dash or gap, beginning with startIndex (either 0 or determined by the end of the last lineTo)
        for (var i:int = startIndex; i < lengthsArray.length; i++){
          var dist:Number = (remainingDist == 0) ? lengthsArray[i] : remainingDist;	// distance to draw is either the dash/gap length from the array or remainingDist left over from the last lineTo if there is any
          // get increments of x and y based on distance, slope, and direction - see getCoords()
          var xInc:Number = getCoords(dist,slope).x * xDir;
          var yInc:Number = getCoords(dist,slope).y * yDir;
          // if the length of the dash or gap will not go beyond the destination x or y of the lineTo, draw the dash or gap
          if (Math.abs(startX-curX) + Math.abs(xInc) < Math.abs(startX-x) || Math.abs(startY-curY) + Math.abs(yInc) < Math.abs(startY-y)){
            if (i % 2 == 0){	// if even index in the array, it is a dash, hence lineTo
              stroke.graphics.lineTo(curX + xInc,curY + yInc);
            } else {	// if odd, it's a gap, so moveTo
              stroke.graphics.moveTo(curX + xInc,curY + yInc);
            }
            // keep track of the new x and y
            curX += xInc;
            curY += yInc;
            curIndex = i;	// store the current dash or gap (array index)
            // reset startIndex and remainingDist, as these will only be non-zero for the first loop (through the array) of the lineTo
            startIndex = 0;
            remainingDist = 0;
          } else {	// if the dash or gap can't fit, break out of the loop
            remainingDist = getDistance(curX,curY,x,y);	// get the distance between the end of the last dash or gap and the destination x/y
            curIndex = i;	// store the current index
            break outerLoop;	// break out of the while loop
          }
        }
      }
      
      startIndex = curIndex;	// for next time, the start index is the last index used in the loop
      
      if (remainingDist != 0){	// if there is a remaining distance, line or move from current x/y to the destination x/y
        if (curIndex % 2 == 0){	// even = dash
          stroke.graphics.lineTo(x,y);
        } else {	// odd = gap
          stroke.graphics.moveTo(x,y);
        }
        remainingDist = lengthsArray[curIndex] - remainingDist;	// remaining distance (which will be used at the beginning of the next lineTo) is now however much is left in the current dash or gap after that final lineTo/moveTo above
      } else {	// if there is no remaining distance (i.e. the final dash or gap fits perfectly), we're done with the current dash or gap, so increment the start index for next time
        if (startIndex == lengthsArray.length - 1){	// go to the beginning of the array if we're at the end
          startIndex = 0;
        } else {
          startIndex++;
        }
      }
      // at last, the current x and y are the destination x and y
      curX = x;
      curY = y;
      
      fill.graphics.lineTo(x,y);	// simple lineTo (invisible line) on the fill shape so that the fill (if one was started via beginFill below) follows along with the dashed line
    }
    
    // returns a point with the vertical and horizontal components of a diagonal given the distance and slope
    private function getCoords(distance:Number,slope:Number):Point {
      var angle:Number = Math.atan(slope);	// get the angle from the slope
      var vertical:Number = Math.abs(Math.sin(angle)*distance);	// vertical from sine of angle and length of hypotenuse - using absolute value here and applying negative as needed in lineTo, because this number doesn't always turn out to be negative or positive exactly when I want it to (haven't thought through the math enough yet to figure out why)
      var horizontal:Number = Math.abs(Math.cos(angle)*distance);	// horizontal from cosine
      return new Point(horizontal,vertical);	// return the point			
    }
    
    // basic Euclidean distance
    private function getDistance(startX:Number,startY:Number,endX:Number,endY:Number):Number{
      var distance:Number = Math.sqrt(Math.pow((endX-startX),2) + Math.pow((endY-startY),2));
      return distance;
    }
    
    // clear everything and reset the lineStyle
    public function clear():void{
      stroke.graphics.clear();
      stroke.graphics.lineStyle(lineWeight,lineColor,lineAlpha,false,"none",CapsStyle.NONE);
      fill.graphics.clear();
      moveTo(0,0);
    }
    
    // set lineStyle with specified weight, color, and alpha
    public function lineStyle(w:Number=0,c:Number=0,a:Number=1):void{
      lineWeight = w;
      lineColor = c;
      lineAlpha = a;
      stroke.graphics.lineStyle(lineWeight,lineColor,lineAlpha,false,"none",CapsStyle.NONE);
    }
    
    // basic beginFill
    public function beginFill(c:uint,a:Number=1):void{
      fill.graphics.beginFill(c,a);
    }
    // basic endFill
    public function endFill():void{
      fill.graphics.endFill();
    }
  }
}