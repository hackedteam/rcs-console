package it.ht.rcs.console.entities.view.renderers
{

  import flash.events.MouseEvent;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  
  import it.ht.rcs.console.entities.model.Entity;
  
  import mx.binding.utils.BindingUtils;
  import mx.core.UIComponent;
  
  import spark.components.BorderContainer;
  import spark.components.Group;
  import spark.components.Image;
  import spark.components.Label;
  import spark.layouts.VerticalLayout;
  import spark.primitives.BitmapImage;
  
  public class EntityRenderer2 extends Group
  {
    private static const WIDTH:Number  = 90; // 5*2 (padding) + 80 (width of label)
    private static const HEIGHT:Number = 66 + 26; // 5*2 (padding) + 50 (height of container) + 6 (gap) + 26 (height of label)
    
    private static const NORMAL_COLOR:Number = 0xffffff;
    private static const SELECTED_COLOR:Number = 0xa8c6ee;
    
    [Embed(source='/img/NEW/star_50.png')]
    private var entityIcon:Class;
    
    [Embed(source='/img/NEW/entity_people_50.png')]
    private var entityPeopleIcon:Class;
    
    [Embed(source='/img/NEW/entity_location_50.png')]
    private var entityLocationIcon:Class;
    
    [Embed(source='/img/NEW/entity_target_50.png')]
    private var entityTargetIcon:Class;
    
    private var mainBox:BorderContainer;
    private var container:BorderContainer;
    private var icon:BitmapImage;
    private var nameTxt:Label;
    
    [Bindable]
    public var entity:Entity
    
   
    
    public function EntityRenderer2()
    {
      super();
      
      
      this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver)
      
    }
    
    private function onMouseOver(e:MouseEvent):void
    {
        e.stopPropagation();
        Mouse.cursor = MouseCursor.AUTO;

    }
    
    override protected function createChildren():void
    {
      super.createChildren();
      
      toolTip = entity.desc
      
      if (mainBox == null)
      {
        mainBox=new BorderContainer();
        mainBox.width=90;
        mainBox.height=92;
        mainBox.setStyle('borderColor', 0x000000);
        var layout:VerticalLayout = new VerticalLayout();
        layout.horizontalAlign = 'center';
        layout.verticalAlign = 'top';
        layout.paddingTop = 5;
        layout.paddingBottom = 5;
        layout.paddingLeft = 5;
        layout.paddingRight = 5;
        layout.gap = 6;
        mainBox.layout = layout;
        
      }
      if (container == null)
      {
        container = new BorderContainer();
        container.width = 50;
        container.height = 50;
        container.x=-25;
        container.y=-25;
        container.setStyle('backgroundColor', NORMAL_COLOR);
        container.setStyle('borderColor', 0xdddddd);
        container.setStyle('cornerRadius', 10);
        
        icon = new BitmapImage();
        icon.horizontalCenter = icon.verticalCenter = 0;
        switch(entity.type)
        {
        case "target": icon.source=entityTargetIcon;
          break;
        case "person": icon.source=entityPeopleIcon;
          break;
        case "position": icon.source=entityLocationIcon;
          break;
        default :
          icon.source=entityPeopleIcon;
        }
      }
        
        container.addElement(icon);
        
        mainBox.addElement(container);
        
        if (nameTxt == null)
        {
          nameTxt = new Label();
          BindingUtils.bindProperty(nameTxt, 'text', entity, 'name');
          nameTxt.setStyle('textAlign', 'center');
          nameTxt.width = 80;
          nameTxt.maxDisplayedLines=2;
          mainBox.addElement(nameTxt);
        }
        this.addElement(mainBox)
        
      }
  }
}