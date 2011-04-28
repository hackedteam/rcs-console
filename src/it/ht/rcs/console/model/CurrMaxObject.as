package it.ht.rcs.console.model
{
  [Bindable]
  public class CurrMaxObject extends Object
  {
    public var curr:String;
    public var max:String;
    
    public function CurrMaxObject(curr:String, max:String)
    {
      super();
      
      this.curr = curr;
      this.max = max;
    }
  }
}