package it.ht.rcs.console.entities.view.graph
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import it.ht.rcs.console.entities.model.Entity;
	import it.ht.rcs.console.entities.model.Link;
	import it.ht.rcs.console.entities.view.renderers.EntityRenderer2;
	import it.ht.rcs.console.operations.view.configuration.advanced.renderers.utils.ArrowStyle;
	import it.ht.rcs.console.operations.view.configuration.advanced.renderers.utils.GraphicsUtil;
	import it.ht.rcs.console.utils.ScrollableGraph;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Group;

	public class LinkGraph extends ScrollableGraph
	{
		private var entities:ArrayCollection;
		private var renderers:ArrayCollection;

		public function LinkGraph()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onAddedToStage(e:Event):void
		{
			//clear
			this.removeAllElements();
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.stage.addEventListener(Event.RESIZE, onStageResize)
			this.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, onStageResize)
		}


		private function onRemovedFromStage(e:Event):void
		{
			this.stage.removeEventListener(Event.RESIZE, onStageResize)
			this.stage.nativeWindow.removeEventListener(NativeWindowBoundsEvent.RESIZE, onStageResize)
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onStageResize(e:Event):void
		{
			resize()
		}

		public function draw(entities:ArrayCollection):void
		{
			this.entities=entities;
			renderers=new ArrayCollection()
			//clear
			this.removeAllElements();

			var centerX:Number=this.width * .5
			var centerY:Number=this.height * .5


			var numberOfPoints:Number=entities.length;
			var angleIncrement:Number=360 / numberOfPoints;

			var radius:Number=this.height / 2.5;
			var i:int=0;
			var entity:Entity;
			//draw as a circle;
			for (i=0; i < entities.length; i++)
			{
				entity=entities.getItemAt(i) as Entity;
				var renderer:EntityRenderer2=new EntityRenderer2(entity);

				renderer.x=centerX + ((radius * 1.5) * Math.cos((angleIncrement * i) * (Math.PI / 180))) - 80;

				renderer.y=centerY + (radius * Math.sin((angleIncrement * i) * (Math.PI / 180))) - 50;

				renderer.addEventListener(MouseEvent.CLICK, onRendererClick)
				addElement(renderer);
				renderers.addItem(renderer);

			}
			//draw connections
			var lines:Group=new Group()
			addElement(lines)
			lines.graphics.lineStyle(1, 0xFF0000, 1)
			for (i=0; i < entities.length; i++)
			{
				entity=entities.getItemAt(i) as Entity;
				if (entity.links)
				{
					for (var l:int=0; l < entity.links.length; l++)
					{
						var link:Link=entity.links.getItemAt(l) as Link;
						//draw link

						var from:EntityRenderer2=getRenderer(entity._id)
						var to:EntityRenderer2=getRenderer(link.le);

						//function to draw the arrow===========================
						var centerFrom:Point=new Point();
						centerFrom.x=from.x + (90 / 2);
						centerFrom.y=from.y + (92 / 2);

						// Getting the center of the second square.
						var centerTo:Point=new Point();
						centerTo.x=to.x + (to.width / 2);
						centerTo.y=to.y + (to.height / 2);
						// Getting the angle between those two.
						var angleTo:Number=Math.atan2(centerTo.x - centerFrom.x, centerTo.y - centerFrom.y);
						var angleFrom:Number=Math.atan2(centerFrom.x - centerTo.x, centerFrom.y - centerTo.y);

						// Getting the points on both borders.
						var pointFrom:Point=getSquareBorderPointAtAngle(from, angleTo);
						var pointTo:Point=getSquareBorderPointAtAngle(to, angleFrom);

						// Calculating arrow edges.
						var arrowSlope:Number=30;
						var arrowHeadLength:Number=10;
						var vector:Point=new Point(-(pointTo.x - pointFrom.x), -(pointTo.y - pointFrom.y));

						// First edge of the head...
						var edgeOneMatrix:Matrix=new Matrix();
						edgeOneMatrix.rotate(arrowSlope * Math.PI / 180);
						var edgeOneVector:Point=edgeOneMatrix.transformPoint(vector);
						edgeOneVector.normalize(arrowHeadLength);
						var edgeOne:Point=new Point();
						edgeOne.x=pointTo.x + edgeOneVector.x;
						edgeOne.y=pointTo.y + edgeOneVector.y;

						// And second edge of the head.
						var edgeTwoMatrix:Matrix=new Matrix();
						edgeTwoMatrix.rotate((0 - arrowSlope) * Math.PI / 180);
						var edgeTwoVector:Point=edgeTwoMatrix.transformPoint(vector);
						edgeTwoVector.normalize(arrowHeadLength);
						var edgeTwo:Point=new Point();
						edgeTwo.x=pointTo.x + edgeTwoVector.x;
						edgeTwo.y=pointTo.y + edgeTwoVector.y;

						var arrow:Group=new Group();
						arrow.graphics.lineStyle(1, 0xFF0000, 1);

						arrow.graphics.moveTo(pointFrom.x, pointFrom.y);
						arrow.graphics.lineTo(pointTo.x, pointTo.y);

						// Drawing the arrow head.
						arrow.graphics.lineTo(edgeOne.x, edgeOne.y);
						arrow.graphics.moveTo(pointTo.x, pointTo.y);
						arrow.graphics.lineTo(edgeTwo.x, edgeTwo.y);

						this.addElement(arrow)

							//================================================
					}
						//this.swapElements(lines, this.getElementAt(0))
				}

			}

		}

		private function getSquareBorderPointAtAngle(square:Group, angle:Number):Point
		{
			// Calculating rays of inner and outer circles.
			var minRay:Number=Math.SQRT2 * 90 / 2;
			var maxRay:Number=90/ 2;

			// Calculating the weight of each rays depending on the angle.
			var rayAtAngle:Number=((maxRay - minRay) * Math.abs(Math.cos(angle * 2))) + minRay;

			// We have our point.
			var point:Point=new Point();
			point.x=rayAtAngle * Math.sin(angle) + square.x + (90 / 2);
			point.y=rayAtAngle * Math.cos(angle) + square.y + (92 / 2);//height
			return point;
		}

		private function resize():void
		{
			this.removeAllElements();
			renderers.removeAll()
			var centerX:Number=this.width * .5
			var centerY:Number=this.height * .5


			var numberOfPoints:Number=entities.length;
			var angleIncrement:Number=360 / numberOfPoints;

			var radius:Number=this.height / 2.5;

			//draw as a circle;
			for (var i:int=0; i < entities.length; i++)
			{
				var entity:Entity=entities.getItemAt(i) as Entity;
				var renderer:EntityRenderer2=new EntityRenderer2(entity);

				renderer.x=centerX + ((radius * 1.5) * Math.cos((angleIncrement * i) * (Math.PI / 180))) - 80;
				renderer.y=centerY + (radius * Math.sin((angleIncrement * i) * (Math.PI / 180))) - 50;
				renderer.addEventListener(MouseEvent.CLICK, onRendererClick)
				addElement(renderer);
				renderers.addItem(renderer)

			}

			//draw connections
			var lines:Group=new Group()
			addElement(lines)
			lines.graphics.lineStyle(1, 0xFF0000, 1)
			for (i=0; i < entities.length; i++)
			{
				entity=entities.getItemAt(i) as Entity;
				if (entity.links)
				{
					for (var l:int=0; l < entity.links.length; l++)
					{
						var link:Link=entity.links.getItemAt(l) as Link;
						//draw link
						var from:EntityRenderer2=getRenderer(entity._id);
						var to:EntityRenderer2=getRenderer(link.le);
						var startPoint:Point=new Point(from.x + 40, from.y + 40);
						var endPoint:Point=new Point(to.x + 40, to.y + 40)
						//lines.graphics.moveTo(startPoint.x,startPoint.y)
						//lines.graphics.lineTo(endPoint.x,endPoint.y)
						GraphicsUtil.drawArrow(lines.graphics, startPoint, endPoint)
					}

				}

			}
			//this.swapElements(lines, this.getElementAt(0))
		}

		private function getRenderer(entityId:String):EntityRenderer2
		{
			for (var i:int=0; i < renderers.length; i++)
			{
				var renderer:EntityRenderer2=renderers.getItemAt(i) as EntityRenderer2;
				if (renderer.entity._id == entityId)
				{
					return renderer;
				}
			}
			return null
		}

		private function onRendererClick(e:MouseEvent):void
		{
			e.stopPropagation()
			var renderer:EntityRenderer2=e.currentTarget as EntityRenderer2;
			var entity:Entity=renderer.entity;
			trace(entity.name);
		}
	}
}
